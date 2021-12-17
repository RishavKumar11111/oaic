CustomerInvoiceViews
====================

SELECT a."CustomerInvoiceNo",
a."MRRNo",
a."InvoiceNo",
a."PONo",
a."OrderReferenceNo",
a."POType",
a."FinYear",
a."DistrictID",
a."VendorID",
a."InvoiceAmount",
a."NoOfOrderDeliver",
a."DeliveredQuantity",
a."InsertedDate",
a."InsertedBy",
a."UpdatedDate",
a."UpdatedBy",
d."DivisionID",
d."DivisionName",
c."Implement",
c."Make",
c."Model",
c."UnitOfMeasurement",
c."HSN",
c."TaxRate",
c."PackageSize",
c."PackageUnitOfMeasurement",
c."RatePerUnit",
c."PackageQuantity"
FROM "CustomerInvoiceMaster" a
 JOIN "POMaster" c ON c."PONo"::text = a."PONo"::text AND c."OrderReferenceNo"::text = a."OrderReferenceNo"::text
 JOIN "DivisionMaster" d ON d."DivisionID"::text = c."DivisionID"::text;



























 MRRViews
 ========


 SELECT a."MRRNo",
 a."InvoiceNo",
 a."PONo",
 a."OrderReferenceNo",
 a."FinYear",
 a."ItemQuantity",
 a."VendorID",
 a."DistrictID",
 a."DMID",
 a."AccID",
 a."PaymentStatus",
 a."POType",
 a."InsertedDate",
 a."InsertedBy",
 a."UpdatedDate",
 a."UpdatedBy",
 a."MRRAmount",
 a."NoOfItemReceived",
 c."CustomerID",
 d."DivisionID",
 d."DivisionName",
 c."Implement",
 c."Make",
 c."Model",
 c."UnitOfMeasurement",
 c."HSN",
 c."TaxRate",
 c."PurchaseInvoiceValue",
 c."PurchaseTaxableValue",
 c."PurchaseCGST",
 c."PurchaseSGST",
 c."PurchaseIGST",
 c."TotalPurchaseInvoiceValue",
 c."TotalPurchaseTaxableValue",
 c."TotalPurchaseCGST",
 c."TotalPurchaseSGST",
 c."SellCGST",
 c."SellSGST",
 c."SellIGST",
 c."SellInvoiceValue",
 c."SellTaxableValue",
 c."TotalSellCGST",
 c."TotalSellSGST",
 c."TotalSellIGST",
 c."TotalSellInvoiceValue",
 c."TotalSellTaxableValue",
 c."POAmount",
 c."NoOfItemsInPO",
 c."EngineNumber",
 c."ChassicNumber",
 c."PackageSize",
 c."PackageUnitOfMeasurement",
 c."RatePerUnit",
 c."PackageQuantity",
 c."DeliveredQuantity",
 c."PendingQuantity"
FROM "MRRMaster" a
  JOIN "InvoiceMaster" b ON b."InvoiceNo"::text = a."InvoiceNo"::text
  JOIN "POMaster" c ON c."PONo"::text = a."PONo"::text AND c."OrderReferenceNo"::text = a."OrderReferenceNo"::text
  JOIN "DivisionMaster" d ON d."DivisionID"::text = c."DivisionID"::text;





































  StockMaster
  ===========


  SELECT COALESCE(sum(a."ItemQuantity"), 0::bigint) AS "ReceivedQuantity",
  COALESCE(sum(b."DeliveredQuantity"::integer), 0::bigint) AS "DeliveredQuantity",
  COALESCE(sum(a."ItemQuantity"), 0::bigint) - COALESCE(sum(b."DeliveredQuantity"::integer), 0::bigint) AS "AvailableQuantity",
  a."DistrictID",
  a."DivisionID",
  a."DivisionName",
  a."Implement",
  a."Make",
  a."Model",
  a."UnitOfMeasurement",
  a."PackageSize",
  a."PackageUnitOfMeasurement"
 FROM "MRRViews" a
   LEFT JOIN "CustomerInvoiceViews" b ON a."DivisionID"::text = b."DivisionID"::text AND a."DivisionName"::text = b."DivisionName"::text AND a."Implement"::text = b."Implement"::text AND a."Make"::text = b."Make"::text AND a."Model"::text = b."Model"::text AND a."PackageSize"::text = b."PackageSize"::text
GROUP BY a."DistrictID", a."DivisionID", a."DivisionName", a."Implement", a."Make", a."Model", a."UnitOfMeasurement", a."PackageUnitOfMeasurement", a."PackageSize";