public class HtmlTidyFilter {

    public static String filter(String part) {
        // part = part.replace('<br />','');
        part = part.replace('<br>','');
        part = part.replace('&nbsp;&nbsp;','');
        //part = part.replace('  ','');
       
        //part = part.replace('&nbsp;&nbsp;','');
        
        return part.replace('  ','');
    }
}