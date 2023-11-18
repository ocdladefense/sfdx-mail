public class TextPlainToTextHtmlFilter {

    
    public static String filter(String part) {
        part = part.replace('\n\n', '<p>&nbsp;</p>');
        return part.replace('\n', '<br />');
    }
}