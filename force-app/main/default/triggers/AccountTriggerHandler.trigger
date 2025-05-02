trigger AccountTriggerHandler on Account (before insert, before update) {
if(Trigger.isBefore && Trigger.isUpdate){
    AccountTriggerHandler.accountUpdate(Trigger.New, Trigger.oldMap);
}
}