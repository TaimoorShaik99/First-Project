public class FBLeadScheduler implements Schedulable {
    public void execute(SchedulableContext sc) {
        FBLeadIntegration.fetchLeads(); // Calls the @future method
    }
}