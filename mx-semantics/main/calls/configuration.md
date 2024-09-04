```k

module MX-CALL-CONFIGURATION
    imports INT-SYNTAX
    imports MX-COMMON-SYNTAX
    imports STRING-SYNTAX

    configuration
        <mx-call-data>
            <mx-callee> "" </mx-callee>
            <mx-caller> "" </mx-caller>
            <mx-call-args> .MxValueList </mx-call-args>
            <mx-egld-value> 0 </mx-egld-value>
            <mx-esdt-transfers> .MxEsdtTransferList </mx-esdt-transfers>
            <mx-gas-provided> 0 </mx-gas-provided>
            <mx-gas-price> 0 </mx-gas-price>
        </mx-call-data>
endmodule

module MX-CALL-RESULT-CONFIGURATION
    imports MX-COMMON-SYNTAX

    configuration
        <mx-call-result> .MxCallResult </mx-call-result>
endmodule

module MX-CALL-RETURN-VALUE-CONFIGURATION
    imports MX-COMMON-SYNTAX

    configuration
        <mx-return-values> .MxValueList </mx-return-values>
endmodule

```