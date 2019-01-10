//MIT License
//
//Copyright © 2019 Sujil Chandresekharan
//
//Permission is hereby granted, free of charge, to any person obtaining a copy
//of this software and associated documentation files (the "Software"), to deal
//in the Software without restriction, including without limitation the rights
//to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//copies of the Software, and to permit persons to whom the Software is
//furnished to do so, subject to the following conditions:
//
//The above copyright notice and this permission notice shall be included in all
//copies or substantial portions of the Software.
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//SOFTWARE.

import Foundation

class Tokenizer{
    //stop words defined as per sqlite fts algorithm
    static let stopWords = ["a\'s","able",
        "about","above","according","accordingly","across",
        " actually","after","afterwards","again","againstain\'t","all","allow",
        "allows","almost","alone","along","already",
        "also","although","always","am"," among",
        "amongst","an","and","another","any",
        "anybody","anyhow","anyone","anything","anyway",
        "anyways","anywhere","apart","appear","apprecia",
        "appropriate","are","aren\'t","around","as",
        "aside","ask","asking","associated","at",
        "available","away","awfully","be","became",
        "because","become","becomes","becoming","been",
        "before","beforehand","behind","being","believe",
        "below","beside","besides","best"," better",
        "between","beyond"," both"," brief","but",
        "by","c\'mon","c\'s","came","can",
        "can\'t","cannot"," cant","cause","causes",
        "certain","certainly","changes","clearly","co",
        "com","come","comes","concerning","consequently",
        "consider","considering","contain","containing","contains",
        "corresponding","could","couldn\'t","course","currently",
        "definitely","described","despite","did","didn\'t",
        "different","do","does","doesn\'t","doing",
        "don\'t","done","down","downwards","during",
        "each","edu","eg","eight","either",
        "else","elsewhere","enough","entirely","especially",
        "et","etc","even","ever","every",
        "everybody","everyone","verything","everywhere","ex",
        "exactly","example","except","far","few",
        "fifth","first","five","followed","following",
        "follows","for","former","formerly ","orth",
        "four","from","further","furthermore","get",
        "gets","getting","given","gives","go",
        "goes","going","gone","got","gotten",
        "greetings","had","hadn\'t","happens","hardly",
        "has","hasn\'t","have","haven\'t","having",
        "he"," he\'s","hello","help","hence",
        "her","here","here\'s","hereafter","hereby",
        "herein","here","upon","ers","herself","hi",
        "him","himself","his","hither","hopefully",
        "how","howbeit","however","i\'d","i\'ll",
        "i\'m","i\'ve"," ie"," if","ignored",
        "immediate","in","in","as","much","nc","indeed",
        "indicate ","indicated","indicates","inner","insofar",
        "instead","into","inward","is","isn\'t",
        "it","it\'d","it\'ll","it\'s","its",
        "itself","just","keep","keeps","kept",
        "know","known","knows","last","lately",
        "later","latter","latterly","east","less",
        "lest"," let","let\'s","like","liked",
        "likely","little","look","looking","looks",
        "ltd","mainly","many","may","maybe",
        "me"," mean","meanwhile","merely","might",
        "more","moreover","most","mostly","much",
        "must","my","myself","name","namely",
        "nd","near","nearly","necessary","need",
        "needs","neither","never","nevertheless","new",
        "next","nine","no","nobody","non",
        "none","no","one","nor","normally","not",
        "nothing","novel","now","nowhere","obviously",
        "of","off","often","oh","ok",
        "okay","old","on","once","one",
        "ones","only","onto","or","other",
        "others","otherwise","ought","our","ours",
        "ourselves","out","outside","over","overall",
        "own","particular","particularly","per","perhaps",
        "placed","please","plus","possible","resumably",
        "probably","provides","que","quite","qv",
        "rather","rd","are","really","reasonably",
        "regarding","regardless","regards","relatively","respectively",
        "right","said","same","saw","say",
        "saying","says","second","secondly ","see",
        "seeing","seem","seemed","seeming","seems",
        "seen","self","selves","sensible ","sent",
        "serious","seriously","seven","several","shall",
        "she","should","shouldn\'t","since","six",
        "so","some","somebody ","somehow","someone",
        "something","sometime","sometimes","somewhat","somewhere",
        "soon","sorry","specified","specify","specifying",
        "still","sub","such","sup","sure",
        "t\'s","take","taken","tell","tends","th","than","thank","thanks","thanx",
        "that","that\'s","thats","the","their",
        "theirs","them","themselves","then","thence",
        "there","there\'s","thereafter","thereby","therefore",
        "therein","theres","thereupon","these","they",
        "they\'d","they\'ll","they\'re","they\'ve","think",
        "third","this","thorough","thoroughly","those",
        "though","three","through","throughout","thru",
        "thus","to","together ","too","took",
        "toward","towards","tried","tries","truly",
        "try","trying","twice","two","un",
        "under","unfortunately","unless","unlikely","until",
        "unto","up","upon","us","use",
        "used","useful","uses","using","usually",
        "value","various","very","via","viz",
        "vs","want","wants","was","wasn\'t",
        "way","we","we\'d","we\'ll","we\'re",
        "we\'ve","welcome","well","went","were",
        "weren\'t","what","what\'s","whatever","when",
        "whence","whenever","where","where\'s","whereafter",
        "whereas","whereby","wherein","whereupon","wherever",
        "whether","which","while","whither","who",
        "who\'s","whoever","whole","whom","whose",
        "why","will","willing","wish","with",
        "within","without","won\'t","wonder","would",
        "wouldn\'t","yes","yet","you","you\'d",
        "you\'ll","you\'re","you\'ve","your","yours",
        "yourself","ourselves","zero"]

    
    static let minimumWordLength = 2
    
    //Implements tokenization of strings
    class func getTokenizedString(string: String, useStopWords: Bool = false)->[String.SubSequence]{
        var loweredString = string.lowercased()
        
        //remove all escape characters,punctuations,periods etc
        loweredString = Tokenizer.preprocessString(string: loweredString)
        
        let words = loweredString.split{ $0 == " "}
        let filteredWords = words.filter{
            let word = String($0)
            //If stop words are enabled, lets remove stop words
            return useStopWords ? $0.count >= minimumWordLength && !stopWords.contains(word) : $0.count > minimumWordLength
        }
        return filteredWords
    }
    
    class func preprocessString(string:String)->String{
        return string.replacingOccurrences(of: ".,\'\"\'", with: "")
    }
}
