codeunit 60000 "EBT Plutus Event Subs."
{
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"LSC POS Transaction Events", 'OnBeforeInsertPayment_TenderKeyExecutedEx', '', false, false)]
    local procedure EDCPOSTransactionEvents_OnBeforeInsertPayment_TenderKeyExecutedEx(var POSTransaction: Record "LSC POS Transaction"; var POSTransLine: Record "LSC POS Trans. Line"; var CurrInput: Text; var TenderTypeCode: Code[10]; var TenderAmountText: Text);
    begin
        EventHelpers.POSTransactionEvents_OnBeforeInsertPayment_TenderKeyExecutedEx(POSTransaction, POSTransLine, CurrInput, TenderTypeCode, TenderAmountText);
    end;

    [EventSubscriber(ObjectType::Codeunit, codeunit::"LSC POS Post Utility", 'OnAfterInsertTransaction', '', false, false)]
    local procedure EDCPOSPostUtility_OnAfterInsertTransaction(var POSTrans: Record "LSC POS Transaction"; var Transaction: Record "LSC Transaction Header"; sender: Codeunit "LSC POS Post Utility")
    begin
        EventHelpers.POSPostUtility_OnAfterInsertTransaction(POSTrans, Transaction, sender);

    end;

    var
        EventHelpers: Codeunit "EBT Plutus EDC Event Helpers";

}