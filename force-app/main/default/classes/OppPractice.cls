public class OppPractice {

    public static void oppAmount(List<Opportunity> oppList){
        for(Opportunity opp : oppList){
            if(opp.Amount!=null && opp.Amount>10000){
                opp.Description='Hot Opportiunity';
            }
        }
    }

}