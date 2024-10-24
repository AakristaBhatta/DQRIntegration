codeunit 60001 "EBT Plutus EDC Event Helpers"
{
    procedure POSTransactionEvents_OnBeforeInsertPayment_TenderKeyExecutedEx(var POSTransaction: Record "LSC POS Transaction"; var POSTransLine: Record "LSC POS Trans. Line"; var CurrInput: Text; var TenderTypeCode: Code[10]; var TenderAmountText: Text);
    begin
        // ProcessInnovitiPayment(POSTransaction, CurrInput, TenderTypeCode, TenderAmountText);
    end;

    internal procedure POSPostUtility_OnAfterInsertTransaction(var POSTrans: Record "LSC POS Transaction"; var Transaction: Record "LSC Transaction Header"; sender: Codeunit "LSC POS Post Utility")
    begin

    end;

    procedure ProcessInnovitiPayment(var POSTransaction: Record "LSC POS Transaction"; var CurrInput: Text; var TenderTypeCode: Code[10]; var TenderAmountText: Text)
    var
        TenderType: Record "LSC Tender Type";
        EDCIntegration: Codeunit "EBT Plutus EDC Integration";
        POSTranCU: Codeunit "LSC POS Transaction";
        EDCResponseLog: Record "EBT Pinelab EDC Response Log";
        GetstatusResponseCode: Text[1024];
        ErrorMessage: Text;
        I, J : Integer;
        UnknownErr: Label 'Unknown error occurred while calling EDC refund API.';
        TrasactionFailedLbl: Label 'Transaction failed with following error.\%1';
        ProgressWindowLbl: Label 'Timeout in #1#### seconds.';
        ProgressWindow: Dialog;
        ResponseLog: Record "EBT Pinelab EDC Response Log";
    begin
        if TenderType.Get(POSTransaction."Store No.", TenderTypeCode) then begin
            if TenderType."EBT Pinelab EDC Tender" then begin
                TenderType.testfield("EBT Pinelab Request Mode");
                POSTransaction.CalcFields("Gross Amount");
                ResponseLog.Reset();
                ResponseLog.SetRange("Billing Reference No.", POSTransaction."Receipt No.");
                ResponseLog.SetRange("Approval Code", 'APPROVED');
                if ResponseLog.FindFirst() then
                    Error('Billing reference No. %1 is approved', ResponseLog."Billing Reference No.");
                if EDCIntegration.UploadEDCTransaction(POSTransaction, EDCResponseLog, TenderAmountText, TenderType) = true then begin
                    if EDCResponseLog."Approval Code" = 'APPROVED' then begin
                        CurrInput := Format(TenderAmountText);
                        POSTranCU.TenderKeyPressedEx(TenderType.Code, CurrInput);
                    end else begin
                        ErrorMessage := EDCResponseLog.Remarks;
                        Error(ErrorMessage);
                    end;
                end
                else
                    Error(GetLastErrorText());
            end;
        end;
    end;
}