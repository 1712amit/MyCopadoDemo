public with sharing class AppAccount {
    @AuraEnabled
    public static void AppAccount(String name, String phone){
        try {
             Account acc = new Account(Name=name,Phone=phone);
             insert acc;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static List<Contact> getContact(String accountId){
        List<Contact> con = [SELECT Contact.Account.Name,Name,Phone,Fax From Contact Where Account.Id=:accountId Limit 10];
        return con;
    }

    @AuraEnabled(cacheable=true)
    public static List<ContentVersion> getVersionFiles(String recordId){
        try {
            return [
		SELECT Id,Title,ContentDocumentId,FileType,ContentSize,FileExtension,VersionNumber,CreatedDate,VersionData,
                FirstPublishLocationId FROM ContentVersion	WHERE FirstPublishLocationId =:recordId
			ORDER BY CreatedDate DESC
		];
        
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static void deleteFile(String ContentDocumentId){
        try {
            delete [SELECT Id,Title,FileType from ContentDocument WHERE id=:ContentDocumentId]; 
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}