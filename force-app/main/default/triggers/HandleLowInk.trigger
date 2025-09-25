trigger HandleLowInk on LowPrinterInk__e (after insert) {
    List<Case> casesToAdd = new List<Case>();
    for (LowPrinterInk__e current : Trigger.New) {
        Case theCase = new Case(Subject='Low ink' + current.Printer_Name__c + ' color:' + current.Color__c);
    }
    insert casesToAdd;
}