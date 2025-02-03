public class FirstQue implements Queueable {
    public  void execute(QueueableContext qc){
        Delete [Select id, name from account where name like 'ABC'];
        system.enqueueJob(new SecondQue());
    }
}