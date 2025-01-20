global with sharing class manageClusterScheduler implements Schedulable{
    public void execute(SchedulableContext sc) {
        batchManageClusters objManageClusters = new batchManageClusters();
        database.executebatch(objManageClusters,200);
    }
}