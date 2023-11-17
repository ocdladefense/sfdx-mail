public class MailMessageFormatter {
    
    final static String MERGE_FIELD_PREFIX = '{!';
    
	final static String HTML_REGEX = '(?mis)<.*?>';


    
    public MailMessageFormatter() {}
    
    
    /**
     *  WARNING!  The String parameter <part> of this method must contain
     *  actual merge fields for the whatId, otherwise the merge will fail with an 
     *     EMAIL_TEMPLATE_PROCESSING_ERROR error.
     */
    public static String doMerge(String part, Id whoId){
        return doMerge(part,whoId,null);
    }
        
    
    /**
     * For more information, see:
     *  https://help.salesforce.com/s/articleView?id=sf.valid_merge_fields.htm&type=5
     */
    public static String doMerge(String part, Id whoId, Id whatId){
        
        String mergedBody;
        String completeMerge;
		List<Messaging.RenderEmailTemplateBodyResult> merges = new List<Messaging.RenderEmailTemplateBodyResult>();
   
        if(null == whoId) {
            throw new MailMessageFormatterException('INVALID_CROSS_REFERENCE_ERROR: WhoId cannot be null.');            
        }
        
        part = part.unescapeHtml4();
        
        if(!hasHtml(part)) {
        	part = TextPlainToTextHtmlFilter.filter(part);
        }
        
        if(hasHtml(part)) {
        	part = HtmlTidyFilter.filter(part);
        }
        
        if(hasMergeFields(part)) {
            merges.addAll(Messaging.renderEmailTemplate(whoId, whatId, new List<String>{part}));
            
            if(null == merges || merges.size() < 1) {
                throw new MailMessageFormatterException('MERGE_ERROR: No merges resulted from the operation.');
            }
            if(!merges[0].getSuccess()) {
                throw new MailMessageFormatterException('MERGE_ERROR: There was an error merging the email.');
            }
        }
        
        return merges.size() > 0 ? merges[0].getMergedBody() : part;
    }
    
    
    /**
     * Returns true if the given string contains merge fields.
     */
    public static Boolean hasMergeFields(String part) {
		return part.contains(MERGE_FIELD_PREFIX);
    }
    
    
    /**
     * See https://docs.oracle.com/javase/6/docs/api/java/util/regex/Pattern.html
     * for more information on Java regular expressions in Apex.
     */
    public static Boolean hasHtml(String part) {
       
		Pattern regex = Pattern.compile(HTML_REGEX);
        Matcher m = regex.matcher(part);
        return m.matches();
    }
    


}