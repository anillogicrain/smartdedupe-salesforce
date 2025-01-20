global with sharing class TrialCustomerPortalHomePageController { //NOPMD
   
   User loggedInUser = [Select id,contactId,Contact.AccountId from User where id = :UserInfo.getUserId() WITH USER_MODE];
   
   public List<Asset> myRegisteredProducts {get; set;}
   public List<Case> myRecentCases {get; set;}
   public List<Solution> topSolutions {get; set;}
   public List<Idea> popularIdeas {get; set;}
   
   public String sortField1 {get; set;}
   public String previousSortField1 {get; set;}
   public String sortField2 {get; set;}
   public String previousSortField2 {get; set;}
   public String sortField3 {get; set;}
   public String previousSortField3 {get; set;}
   public String sortField4 {get; set;}
   public String previousSortField4 {get; set;}
            
   public TrialCustomerPortalHomePageController() {
    myRegisteredProducts = [select id,Name,SerialNumber,InstallDate,UsageEndDate,Status
                                from Asset 
                                where ContactId = :loggedInUser.ContactId WITH USER_MODE
                                order by SerialNumber desc  limit 3 ];
        
        myRecentCases = [select id,CaseNumber,Subject,Status,LastModifiedDate 
                         from Case 
                         where ContactId = :loggedInUser.ContactId WITH USER_MODE
                         order by LastModifiedDate desc limit 3 ];
        
        topSolutions = [select id,SolutionName,TimesUsed,LastModifiedDate 
                        from Solution WITH USER_MODE
                        order by TimesUsed desc limit 3];
                              
        popularIdeas = [select id,Title,Categories,VoteTotal 
                        from Idea WITH USER_MODE
                        order by VoteTotal desc limit 3];
   }
   
   public void sortProducts(){
        String order = 'asc';
        if(previousSortField1 == sortField1){
            order = 'desc';
            previousSortField1 = null;
        }else{
            previousSortField1 = sortField1;
        }
        superSort.sortList(myRegisteredProducts,sortField1,order);
    }
    public void sortCases(){
        String order = 'asc';
        if(previousSortField2 == sortField2){
            order = 'desc';
            previousSortField2 = null;
        }else{
            previousSortField2 = sortField2;
        }
        superSort.sortList(myRecentCases,sortField2,order);
    }
    public void sortSolutions(){
        String order = 'asc';
        if(previousSortField3 == sortField3){
            order = 'desc';
            previousSortField3 = null;
        }else{
            previousSortField3 = sortField3;
        }
        superSort.sortList(topSolutions,sortField3,order);
    }
    public void sortIdeas(){
        String order = 'asc';
        if(previousSortField4 == sortField4){
            order = 'desc';
            previousSortField4 = null;
        }else{
            previousSortField4 = sortField4;
        }
        superSort.sortList(popularIdeas,sortField4,order);
    }
    
}