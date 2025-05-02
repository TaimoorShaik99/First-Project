public class WireTest {
    @Auraenabled(cacheable=true)
    public static List<Account> getAccounts(){
        List<Account> acc=[Select id, name from Account];
        system.debug(acc);
        return acc;
        
    }
}