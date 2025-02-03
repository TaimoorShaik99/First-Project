public class Future {
    public Future(){
        gettingReady();
        breakfast();
        bikeRepair();
        accObj();
        Office();
    }
    public static void gettingReady(){
        system.debug('Getting ready for office');
    }
    public static void breakfast(){
        system.debug('Having Breakfast');
    }
    @future
    public static void bikeRepair(){
        system.debug('Bike servicing');
    }
    
    @future
    public static void accObj(){
        List<Account> accList = [Select id, Name from Account];
        system.debug(accList);
        //system.debug('Bike servicing');
    }
    
    public static void Office(){
        system.debug('Reached office by Cab');
    }
}