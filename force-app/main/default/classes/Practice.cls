public class Practice {

    public static void industryMedia(List<Account> accList){
        for(Account acc : accList){
            if(acc.Industry!=null && acc.Industry=='Media'){
                acc.Rating='Hot';
            }
        }
    }
}