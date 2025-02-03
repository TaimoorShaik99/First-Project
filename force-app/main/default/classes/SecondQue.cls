public class SecondQue implements Queueable {
    public static void execute(QueueableContext qc){
        Account existingAccount = [SELECT Id, Name FROM Account WHERE Name = 'Test 1' LIMIT 1];

        
        Account newAccount = new Account(
            Name = existingAccount.Name + ' - Copy',
            BillingCity = 'New York'
        );
        
        insert newAccount;
    }
}