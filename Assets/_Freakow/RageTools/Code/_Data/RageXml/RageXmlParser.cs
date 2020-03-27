using System.IO;
using System.Text;
#if UNITY_EDITOR
using System.Xml;
#endif
public abstract class RageXmlParser {
    #if UNITY_EDITOR
    private static readonly XmlReaderSettings Settings = new XmlReaderSettings {
                                                                                ProhibitDtd = false,
                                                                                XmlResolver = null,
                                                                                IgnoreComments = true,
                                                                                IgnoreProcessingInstructions = true
                                                                               };

    public static XmlNode XmlToDOM(string xml) {
        var input = new MemoryStream(Encoding.Default.GetBytes(xml));
        return StreamToDOM(input);
    }

    public static XmlNode StreamToDOM(Stream input){
        XmlReader reader = XmlReader.Create(input, Settings);
        var doc = new XmlDocument();
        reader.MoveToContent();
        doc.Load(reader);
        return doc;
    }
    #endif
}
