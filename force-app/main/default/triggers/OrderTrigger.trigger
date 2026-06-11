trigger OrderTrigger on Order (before insert,before update,after update) {

    if (Trigger.isBefore) {
         OrderTriggerHandler.handleBefore(Trigger.new);
    }

    if (Trigger.isAfter && Trigger.isUpdate) {
        OrderTriggerHandler.handleAfterUpdate( Trigger.new, Trigger.oldMap);
    }
}