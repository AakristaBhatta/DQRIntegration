codeunit 60002 "EBT Plutus EDC Integration"
{

    var

        EDCSetup: Record "EBT Pinelab EDC Setup";
        Store: Record "LSC Store";
        Terminal: Record "LSC POS Terminal";
        ResponseLog: Record "EBT Pinelab EDC Response Log";
        LastResponseHeaders: HttpHeaders;
        LastResultStatusCode: Integer;
        BaseUrl: Text;
        Client: HttpClient;

    procedure Delete(Url: Text): JsonToken
    var
        JRequest: JsonToken;
    begin
        exit(ExecuteWebRequest(Url, 'DELETE', JRequest));
    end;

    procedure Delete(Url: Text; JRequest: JsonToken): JsonToken
    begin
        exit(ExecuteWebRequest(Url, 'DELETE', JRequest));
    end;


    procedure Delete(Url: Text; HeaderValues: Dictionary of [Text, Text]): JsonToken
    var
        JRequest: JsonToken;
    begin
        ExecuteWebRequest(Url, 'DELETE', JRequest, HeaderValues);
    end;

    procedure Delete(Url: Text; JRequest: JsonToken; HeaderValues: Dictionary of [Text, Text]): JsonToken
    begin
        exit(ExecuteWebRequest(Url, 'DELETE', JRequest, HeaderValues));
    end;

    procedure ExecuteWebRequest(Url: Text; Method: Text; JRequest: JsonToken): JsonToken
    var
        HeaderValues: Dictionary of [Text, Text];
    begin
        exit(ExecuteWebRequest(Url, Method, JRequest, HeaderValues));
    end;

    procedure ExecuteWebRequest(Url: Text; Method: Text; JRequest: JsonToken; HeaderValues: Dictionary of [Text, Text]): JsonToken
    var
        JResponse: JsonToken;
        Request: Text;
        Response: Text;
    begin

        JRequest.WriteTo(Request);
        if Request = 'null' then begin
            Request := '';
        end;
        Clear(JResponse);
        if JResponse.ReadFrom(ExecuteWebRequest(Url, Method, Request, HeaderValues)) then
            exit(JResponse);
    end;

    procedure Get(Url: Text): JsonToken
    var
        JRequest: JsonToken;
    begin
        exit(ExecuteWebRequest(Url, 'GET', JRequest));
    end;

    procedure Get(Url: Text; HeaderValues: Dictionary of [Text, Text]): JsonToken
    var
        JRequest: JsonToken;
    begin
        exit(ExecuteWebRequest(Url, 'GET', JRequest, HeaderValues));
    end;

    procedure GetBaseUrl(): Text
    begin
        exit(BaseUrl);
    end;

    procedure GetLastResponseHeaders(var ResponseResult: HttpHeaders)
    begin
        ResponseResult := LastResponseHeaders;
    end;

    procedure GetLastResultStatusCode(): Integer
    begin
        exit(LastResultStatusCode);
    end;

    procedure Patch(Url: Text): JsonToken
    var
        HeaderValues: Dictionary of [Text, Text];
        JRequest: JsonToken;
        JResponse: JsonToken;
    begin
        exit(ExecuteWebRequest(Url, 'PATCH', JRequest));
    end;

    procedure Patch(Url: Text; JRequest: JsonToken): JsonToken
    begin
        exit(ExecuteWebRequest(Url, 'PATCH', JRequest));
    end;

    procedure Patch(Url: Text; HeaderValues: Dictionary of [Text, Text]): JsonToken
    var
        JRequest: JsonToken;
    begin
        exit(ExecuteWebRequest(Url, 'PATCH', JRequest, HeaderValues));
    end;

    procedure Patch(Url: Text; JRequest: JsonToken; HeaderValues: Dictionary of [Text, Text]): JsonToken
    begin
        exit(ExecuteWebRequest(Url, 'PATCH', JRequest, HeaderValues));
    end;

    procedure Post(Url: Text): JsonToken
    var
        JRequest: JsonToken;
    begin
        exit(ExecuteWebRequest(Url, 'POST', JRequest));
    end;

    procedure Post(Url: Text; JRequest: JsonToken): JsonToken
    begin
        exit(ExecuteWebRequest(Url, 'POST', JRequest));
    end;

    procedure Post(Url: Text; HeaderValues: Dictionary of [Text, Text]): JsonToken
    var
        JRequest: JsonToken;
    begin
        exit(ExecuteWebRequest(Url, 'POST', JRequest, HeaderValues));
    end;

    procedure Post(Url: Text; JRequest: JsonToken; HeaderValues: Dictionary of [Text, Text]): JsonToken
    begin
        exit(ExecuteWebRequest(Url, 'POST', JRequest, HeaderValues));
    end;

    procedure Put(Url: Text): JsonToken
    var
        HeaderValues: Dictionary of [Text, Text];
        JRequest: JsonToken;
        JResponse: JsonToken;
    begin
        exit(ExecuteWebRequest(Url, 'PUT', JRequest));
    end;

    procedure Put(Url: Text; JRequest: JsonToken): JsonToken
    begin
        exit(ExecuteWebRequest(Url, 'PUT', JRequest));
    end;

    procedure Put(Url: Text; HeaderValues: Dictionary of [Text, Text]): JsonToken
    var
        JRequest: JsonToken;
    begin
        exit(ExecuteWebRequest(Url, 'PUT', JRequest, HeaderValues));
    end;

    procedure Put(Url: Text; JRequest: JsonToken; HeaderValues: Dictionary of [Text, Text]): JsonToken
    begin
        exit(ExecuteWebRequest(Url, 'PUT', JRequest, HeaderValues));
    end;

    procedure ResetLastResult()
    begin
        Clear(LastResultStatusCode);
        Clear(LastResponseHeaders);
    end;

    procedure SetBaseUrl(Url: Text)
    begin
        BaseUrl := Url;
    end;

    local procedure CreateHttpRequestMessage(Url: text; Method: Text; RequestString: Text; var RequestMessage: HttpRequestMessage; HeaderValues: Dictionary of [Text, Text]);
    var
        Content: HttpContent;
        Headers: HttpHeaders;
        AuthText: Text;
        HeaderKey: Text;
        HeaderValue: Text;
    begin
        if not url.StartsWith(BaseUrl) then begin
            Url := BaseUrl + Url;
        end;
        RequestMessage.SetRequestUri(Url);
        RequestMessage.Method := Method;
        RequestMessage.GetHeaders(Headers);
        if Headers.Contains('Accept') then begin
            Headers.Remove('Accept');
        end;
        Headers.Add('Accept', 'application/json');

        foreach HeaderKey in HeaderValues.Keys() do begin
            if Headers.Contains(HeaderKey) then begin
                Headers.Remove(HeaderKey);
            end;
            if HeaderValues.Get(HeaderKey, HeaderValue) then begin
                Headers.Add(HeaderKey, HeaderValue);
            end;
        end;

        if Method <> 'GET' then begin
            Content.WriteFrom(RequestString);
            Content.GetHeaders(Headers);
            if Headers.Contains('Content-Type') then begin
                Headers.Remove('Content-Type');
            end;
            Headers.Add('Content-Type', 'application/json');
            RequestMessage.Content(Content);
        end;
    end;

    local procedure ExecuteWebRequest(Url: Text; Method: Text; Request: Text; HeaderValues: Dictionary of [Text, Text]) Response: Text
    var
        RequestMessage: HttpRequestMessage;
        ResponseMessage: HttpResponseMessage;
    begin
        CreateHttpRequestMessage(Url, Method, Request, RequestMessage, HeaderValues);

        if Client.send(RequestMessage, ResponseMessage) then begin
            ResponseMessage.Content.ReadAs(Response);
            LastResultStatusCode := ResponseMessage.HttpStatusCode;
            LastResponseHeaders := ResponseMessage.Headers;
        end;
    end;

    procedure FindNextLink(var NextLink: Text; var NextLinkFound: Boolean)
    var
        PageInfoStartPos, PageInfoEndPos, NextLinkPos : Integer;
        PageInfoStartTxt: Label '&page_info';
        PageInfoEndTxt: Label '>';
        NextTxt: Label 'rel="next"';
        Link: array[1] of Text;
        Links: list of [Text];
        PageLink: Text;
    begin
        NextLinkFound := false;
        if not LastResponseHeaders.GetValues('Link', Link) then
            exit;
        Links := Link[1].split(',');
        if links.Count = 1 then
            PageLink := Links.Get(1)
        else
            if links.Count = 2 then
                PageLink := Links.Get(2);
        PageInfoStartPos := StrPos(PageLink, PageInfoStartTxt);
        PageInfoEndPos := StrPos(PageLink, PageInfoEndTxt);
        NextLink := CopyStr(PageLink, PageInfoStartPos, PageInfoEndPos - PageInfoStartPos);
        NextLinkPos := StrPos(PageLink, NextTxt);
        if NextLinkPos > 0 then
            NextLinkFound := true;
    end;



    local procedure GetBaseURI(): Text
    begin
        EDCSetup.TestField("Base URL");
        exit(EDCSetup."Base URL");
    end;

    local procedure GetSetup()
    begin
        EDCSetup.Get();
    end;

    local procedure GetResponseCode(JToken: JsonToken) ResponseCode: Code[20]
    var
        ResultToken: JsonToken;
    begin
        JToken.SelectToken('responseCode', ResultToken);
        ResponseCode := ResultToken.AsValue().AsText();
    end;

    local procedure GetResponseDescription(JToken: JsonToken) ResponseDesc: Text
    var
        ResultToken: JsonToken;
    begin
        JToken.SelectToken('respDescription', ResultToken);
        ResponseDesc := ResultToken.AsValue().AsText();
    end;

    local procedure PrepareValue(var POSTransaction: Record "LSC POS Transaction"; var TenderAmountText: Text; TenderType: Record "LSC Tender Type") ValueTxt: Text
    var
        TxnType, TxnMode, TxnID, TxnAmount, TxnDateTime, MID, StoreCode : Text;
        SeparatorLbl: Text;
        TenderAmount: Decimal;
    begin
        Evaluate(TenderAmount, TenderAmountText);
        TenderAmount := TenderAmount * 100;
        SeparatorLbl := ',';
        if POSTransaction."Sale Is Return Sale" then
            TxnType := '01'
        else
            TxnType := '00';
        TxnMode := TenderType."EBT Pinelab Request Mode";
        TxnID := POSTransaction."Receipt No.";
        TxnAmount := DelChr(format(TenderAmount), '=', ',');
        TxnDateTime := format(CurrentDateTime, 0, '<Year4>-<Month,2>-<Day,2>T<Hours12,2>:<Minutes,2>:<Seconds,2>');
        MID := '';
        StoreCode := POSTransaction."Store No.";

        ValueTxt :=
                    CopyStr(TxnMode, 1, 4) + SeparatorLbl +
                    CopyStr(TxnID, 1, 20) + SeparatorLbl +
                    CopyStr(TxnAmount, 1, 145) + SeparatorLbl +
                    SeparatorLbl + SeparatorLbl + SeparatorLbl;
    end;

    local procedure PrepareSKUItemDetails(var POSTransaction: Record "LSC POS Transaction"; var TenderAmountText: Text) SKUItemDetailsTxt: Text
    begin

    end;

    local procedure FillResponseLog(var POSTransaction: Record "LSC POS Transaction"; var ResponseLog: Record "EBT Pinelab EDC Response Log"; TenderAmountText: Text; ResponseTxt: text)
    var
        JObject: JsonObject;
        OutStream: OutStream;
        CsvLine: Text;
        CsvFields: List of [Text];
        Separator: Text;
        i: Integer;
        Field: Text;
    begin
        Clear(ResponseLog);
        Separator := ',';
        CsvLine := ResponseTxt;
        CsvFields := CsvLine.Split(Separator);
        ResponseLog.Init();
        foreach field in csvFields do begin
            i += 1;
            Field := DelChr(Field, '=', '/');
            Field := DelChr(Field, '=', '\');
            Field := DelChr(Field, '=', '"');
            case i of
                1:
                    ResponseLog."Billing Reference No." := Field;
                2:
                    Evaluate(ResponseLog."Host Response", Field);
                3:
                    Evaluate(ResponseLog."Approval Code", Field);

                4:
                    Evaluate(ResponseLog."Card Number", Field);
                5:
                    // if field <> 'XXXX' then
                    Evaluate(ResponseLog."Expiration Date", Field);
                6:
                    Evaluate(ResponseLog."CardHolder's Name", Field);

                7:
                    Evaluate(ResponseLog."Card Type", Field);

                8:
                    Evaluate(ResponseLog."Invoice Number", Field);

                9:
                    Evaluate(ResponseLog."Batch Number", Field);

                10:
                    Evaluate(ResponseLog."Terminal Id", Field);

                11:
                    Evaluate(ResponseLog."Loyalty Points Awarded", Field);

                12:
                    Evaluate(ResponseLog.Remarks, Field);

                13:
                    Evaluate(ResponseLog."Transaction Acquirer Name", Field);

                14:
                    Evaluate(ResponseLog."Merchant ID", Field);

                15:
                    Evaluate(ResponseLog."Retrieval Reference Number", Field);

                16:
                    Evaluate(ResponseLog."Card Entry Mode", Field);

                17:
                    Evaluate(ResponseLog."Print CardHolder's Name On Rpt", Field);

                18:
                    Evaluate(ResponseLog."Merchant Name", Field);

                19:
                    Evaluate(ResponseLog."Merchant Address", Field);

                20:
                    Evaluate(ResponseLog."Merchant City", Field);

                21:
                    Evaluate(ResponseLog."Plutus Version", Field);
            end;
            // Message('Field %1: %2', i + 1, Field);
            // ResponseLog."Billing Reference No." := POSTransaction."Receipt No.";
        end;
        ResponseLog."Response Log".CreateOutStream(OutStream, TEXTENCODING::UTF8);
        OutStream.WriteText(ResponseTxt);
        ResponseLog.Insert(true);
        Commit();
    end;

    internal procedure RefundEDCTransaction(var POSTransaction: Record "LSC POS Transaction"; EDCResponseLog: Record "EBT Pinelab EDC Response Log"; TenderAmountText: Text): Boolean
    begin
        exit(true); // Since we do not have refund api, we are doing exit true for this case
    end;

    internal procedure UploadEDCTransaction(var POSTransaction: Record "LSC POS Transaction"; var EDCResponseLog: Record "EBT Pinelab EDC Response Log"; TenderAmountText: Text; TenderType: Record "LSC Tender Type"): Boolean
    var
        POSTerminal: Record "LSC POS Terminal";
        ValueTxt, SKUItemDetailsTxt, ResponseTxt : Text;
        JToken: JsonToken;
        OutStream: OutStream;
        ProgressWindow: Dialog;
        ProgressLbl: Label 'Kindly make card payment of %1 Rs.';
        ProgressTxt: Text;
        HeaderValues: Dictionary of [Text, Text];
        BodyObject: JsonObject;
        BodyText: Text;
        PayLoadObject: JsonObject;
        payloadToken: JsonToken;
        ResponseTxtFormatted: Text;
    begin

        if TenderType."EBT PinelabWaiting Message" = '' then
            ProgressTxt := StrSubstNo(ProgressLbl, TenderAmountText)
        else
            ProgressTxt := StrSubstNo(TenderType."EBT PinelabWaiting Message", TenderAmountText);
        ProgressWindow.Open(ProgressTxt);
        GetSetup();
        POSTerminal.Get(POSTransaction."POS Terminal No.");
        POSTerminal.TestField("EBT Pinelab EDC Device IP");
        POSTerminal.TestField("EBT Pinelab EDC Device Port");
        BaseUrl := StrSubstNo(EDCSetup."Base URL", POSTerminal."EBT Pinelab EDC Device IP", POSTerminal."EBT Pinelab EDC Device Port");
        ValueTxt := PrepareValue(POSTransaction, TenderAmountText, TenderType);
        BodyObject.Add('request_csv', ValueTxt);
        BodyObject.WriteTo(bodyText);
        ResponseTxt := ExecuteWebRequest(BaseUrl, 'POST', bodyText, HeaderValues);
        PayLoadObject.ReadFrom(ResponseTxt);
        ResponseTxtFormatted := GetJsonToken(PayLoadObject, 'response_csv').AsValue().AsText();
        FillResponseLog(POSTransaction, EDCResponseLog, TenderAmountText, ResponseTxtFormatted);
        EDCResponseLog."Response Log".CreateOutStream(OutStream);
        OutStream.WriteText(ResponseTxt);
        EDCResponseLog.Modify();
        Commit();
        ProgressWindow.Close();
        exit(true)
    end;

    local procedure GetJsonToken(JsonObject: JsonObject; TokenKey: text) JsonToken: JsonToken;
    var
        JsonValue: JsonValue;
    begin
        if not JsonObject.Get(TokenKey, JsonToken) then;
        // InsertErrorMessage(GetLastErrorText(), false);
    end;

    procedure GetJsonPropertyValueByPath(JObject: JsonObject; PropertyPath: Text) PropertyValue: Text;
    var
        JToken: JsonToken;
        JValue: JsonValue;
    begin
        PropertyValue := '';
        if not JObject.SelectToken(PropertyPath, JToken) then
            exit;
        if not JToken.IsValue() then
            exit;
        JValue := JToken.AsValue();
        if JValue.IsNull() then
            exit;
        PropertyValue := JValue.AsText();
    end;

    procedure GetJsonPropertyDecValueByPath(JObject: JsonObject; PropertyPath: Text) PropertyValue: Decimal;
    var
        JToken: JsonToken;
        JValue: JsonValue;
    begin
        PropertyValue := 0;
        if not JObject.SelectToken(PropertyPath, JToken) then
            exit;
        if not JToken.IsValue() then
            exit;
        JValue := JToken.AsValue();
        if JValue.IsNull() then
            exit;
        PropertyValue := JValue.AsDecimal();
    end;
}