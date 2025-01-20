/**
 * An apex class that updates portal user details.
   Guest users are never able to access this page.
*/
 
public with sharing class MyProfilePageController {

    private User user;
    public List<User> lstUser= new List<User>();	//+
    private boolean isEdit = false;

    public User getUser() {
        return user;
    }

    public MyProfilePageController() {
        user = [SELECT id, email, username, usertype, communitynickname, timezonesidkey, languagelocalekey, firstname, lastname, phone, title,
                street, city, country, postalcode, state, localesidkey, mobilephone, extension, fax, contact.email
                FROM User 
                WHERE id = :UserInfo.getUserId()  WITH USER_MODE];
        lstUser.add(user);
        // guest users should never be able to access this page
        if (user.usertype == 'GUEST') {
            throw new NoAccessException();
        }
    }

    public Boolean getIsEdit() {
        return isEdit;
    }

    public void edit() {
        isEdit=true;
    }

    public void save() {
        try {
             SObjectAccessDecision decision = Security.stripInaccessible( AccessType.UPDATABLE, lstUser);   
             update decision.getRecords(); //NOPMD
            // system.debug('40==>'+User);
            // system.debug('41==>'+lstUser);
            // update user; //NOPMD
            isEdit=false;
        } catch(DmlException e) {
            ApexPages.addMessages(e);
        }
    }

    public PageReference changePassword() {
        return Page.ChangePassword;
    }

    public void cancel() {
        isEdit=false;
        user = [SELECT id, email, username, communitynickname, timezonesidkey, languagelocalekey, firstname, lastname, phone, title,
                street, city, country, postalcode, state, localesidkey, mobilephone, extension, fax, contact.email 
                FROM User
                WHERE id = :UserInfo.getUserId()  WITH USER_MODE];
    }   

}