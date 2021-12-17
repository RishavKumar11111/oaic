PGDMP         1            
    y            oaic    13.2    13.3    �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            �           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            �           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            �           1262    71960    oaic    DATABASE     `   CREATE DATABASE oaic WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'English_India.1252';
    DROP DATABASE oaic;
                postgres    false                       1255    72716    Paymnet_Insert_MR()    FUNCTION     �  CREATE FUNCTION public."Paymnet_Insert_MR"() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
	IF(NEW.purpose = 'advanceCustomerPayment' OR NEW.purpose = 'customerPaymentAgainstInvoice' OR NEW.purpose = 'farmerAdvancePayment')
	THEN
		NEW."MoneyReceiptNo"= (SELECT "DistCode" FROM "DistrictMaster" WHERE dist_id=NEW."PayToID") || '/MR/' || NEW."fin_year" ||'/' || nextval('payment1_sl_no_seq');
	END IF;
	RETURN NEW;
END
$$;
 ,   DROP FUNCTION public."Paymnet_Insert_MR"();
       public          postgres    false                       1255    71961    UpdateDeliveredQuantity()    FUNCTION     �  CREATE FUNCTION public."UpdateDeliveredQuantity"() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
	IF(NEW."DeliveredQuantity" IS NOT NULL) 
	THEN
		NEW."DeliveredQuantity" = CAST(OLD."DeliveredQuantity" AS INT) + CAST(NEW."DeliveredQuantity" AS INT);
		NEW."PendingQuantity" = CAST(OLD."ItemQuantity" AS INT) - CAST(NEW."DeliveredQuantity" AS INT);
		
		IF(OLD."ItemQuantity" = NEW."DeliveredQuantity")
		THEN
			NEW."IsDelivered" = 'true';
		END IF;
	END IF;
	RETURN NEW;
END
$$;
 2   DROP FUNCTION public."UpdateDeliveredQuantity"();
       public          postgres    false                       1255    71962    update_invoice_number()    FUNCTION     R  CREATE FUNCTION public.update_invoice_number() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
	UPDATE public."POMaster"
	SET "DeliveredQuantity"=NEW."SupplyQuantity", "EngineNumber"=NEW."EngineNumber", "ChassicNumber"=NEW."ChassicNumber"
	WHERE "PONo"=NEW."PONo" AND "OrderReferenceNo"=NEW."OrderReferenceNo";
	RETURN NULL;
END
$$;
 .   DROP FUNCTION public.update_invoice_number();
       public          postgres    false                       1255    71963    update_mrr_id()    FUNCTION     �  CREATE FUNCTION public.update_mrr_id() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
	UPDATE public."POMaster"
	SET "MRRID"=NEW."MRRNo",
	"IsReceived"='true'
	WHERE "PONo"=NEW."PONo" AND 
	"OrderReferenceNo" = NEW."OrderReferenceNo";
	
	UPDATE public."InvoiceMaster"
	SET "ReceivedDate"='NOW()',
	"IsReceived"='true',
	"MRRNo"=NEW."MRRNo"
	WHERE 
	"InvoiceNo"=NEW."InvoiceNo" AND
	"PONo"=NEW."PONo" AND 
	"OrderReferenceNo" = NEW."OrderReferenceNo";
	RETURN NULL;
END
$$;
 &   DROP FUNCTION public.update_mrr_id();
       public          postgres    false                       1255    71964    update_order_po_intiate()    FUNCTION     �   CREATE FUNCTION public.update_order_po_intiate() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
	UPDATE public."orders"
	SET "status"='indent_initiated'
	WHERE "permit_no"=NEW."OrderReferenceNo";
	RETURN NULL;
END
$$;
 0   DROP FUNCTION public.update_order_po_intiate();
       public          postgres    false            �            1259    72134    AccountantMaster    TABLE     k  CREATE TABLE public."AccountantMaster" (
    acc_name character varying(225),
    acc_id character varying(30) NOT NULL,
    dist_id character varying(2) NOT NULL,
    dist_name character varying(30),
    acc_address character varying(1000),
    acc_mobile_no character varying(15),
    "UpdateOn" timestamp without time zone,
    "UpdateBy" character varying
);
 &   DROP TABLE public."AccountantMaster";
       public         heap    postgres    false            �            1259    71965    CustomerBankAccount    TABLE     :  CREATE TABLE public."CustomerBankAccount" (
    id integer NOT NULL,
    "CustomerID" character varying(255),
    "BankAccountID" integer,
    "bankAccountNo" character varying(255) NOT NULL,
    "accountType" character varying(255) NOT NULL,
    "bankName" character varying(255) NOT NULL,
    "branchName" character varying(255) NOT NULL,
    "ifscCode" character varying(255) NOT NULL,
    "InsertedDate" timestamp with time zone NOT NULL,
    "InsertedBy" character varying(255),
    "UpdatedDate" timestamp with time zone,
    "UpdatedBy" character varying(255)
);
 )   DROP TABLE public."CustomerBankAccount";
       public         heap    postgres    false            �            1259    71971    CustomerBankAccount_id_seq    SEQUENCE     �   CREATE SEQUENCE public."CustomerBankAccount_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 3   DROP SEQUENCE public."CustomerBankAccount_id_seq";
       public          postgres    false    200            �           0    0    CustomerBankAccount_id_seq    SEQUENCE OWNED BY     ]   ALTER SEQUENCE public."CustomerBankAccount_id_seq" OWNED BY public."CustomerBankAccount".id;
          public          postgres    false    201            �            1259    71973    CustomerContactPerson    TABLE     �  CREATE TABLE public."CustomerContactPerson" (
    id integer NOT NULL,
    "CustomerID" character varying(255),
    "ContactPersonID" integer,
    "AuthorisedName" character varying(255),
    "AuthorisedMobileNo" character varying(255),
    "AuthorisedEmailID" character varying(255),
    "Designation" character varying(255),
    "InsertedDate" timestamp with time zone NOT NULL,
    "InsertedBy" character varying(255),
    "UpdatedDate" timestamp with time zone,
    "UpdatedBy" character varying(255)
);
 +   DROP TABLE public."CustomerContactPerson";
       public         heap    postgres    false            �            1259    71979    CustomerContactPerson_id_seq    SEQUENCE     �   CREATE SEQUENCE public."CustomerContactPerson_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 5   DROP SEQUENCE public."CustomerContactPerson_id_seq";
       public          postgres    false    202            �           0    0    CustomerContactPerson_id_seq    SEQUENCE OWNED BY     a   ALTER SEQUENCE public."CustomerContactPerson_id_seq" OWNED BY public."CustomerContactPerson".id;
          public          postgres    false    203            �            1259    71981    CustomerDistrictMapping    TABLE     �   CREATE TABLE public."CustomerDistrictMapping" (
    "CustomerID" character varying(255) NOT NULL,
    "DistrictID" character varying(255) NOT NULL,
    "InsertedDate" timestamp with time zone NOT NULL
);
 -   DROP TABLE public."CustomerDistrictMapping";
       public         heap    postgres    false            �            1259    71987    CustomerInvoiceMaster    TABLE     n  CREATE TABLE public."CustomerInvoiceMaster" (
    "CustomerInvoiceNo" character varying(255) NOT NULL,
    "MRRNo" character varying(255),
    "InvoiceNo" character varying(255),
    "PONo" character varying(255),
    "OrderReferenceNo" character varying(255) NOT NULL,
    "POType" character varying(255),
    "FinYear" character varying(255),
    "DistrictID" character varying(255),
    "VendorID" character varying(255),
    "InvoiceAmount" character varying(255),
    "NoOfOrderDeliver" character varying(255) NOT NULL,
    "DeliveredQuantity" character varying(255),
    "InsertedDate" timestamp with time zone,
    "InsertedBy" character varying(255),
    "UpdatedDate" timestamp with time zone,
    "UpdatedBy" character varying(255),
    "CustomerID" character varying,
    "DivisionID" character varying,
    "Implement" character varying,
    "Make" character varying,
    "Model" character varying,
    "HSN" character varying,
    "UnitOfMeasurement" character varying,
    "PackageSize" character varying,
    "PackageUnitOfMeasurement" character varying,
    "PackageQuantity" integer,
    "ItemQuantity" integer,
    "TaxRate" integer,
    "RatePerUnit" numeric(20,2),
    "PurchaseInvoiceValue" numeric(20,2),
    "PurchaseCGST" numeric(20,2),
    "PurchaseSGST" numeric(20,2),
    "PurchaseIGST" numeric(20,2),
    "TotalPurchaseInvoiceValue" numeric(20,2),
    "TotalPurchaseTaxableValue" numeric(20,2),
    "TotalPurchaseCGST" numeric(20,2),
    "TotalPurchaseSGST" numeric(20,2),
    "SellCGST" numeric(20,2),
    "SellSGST" numeric(20,2),
    "SellIGST" numeric(20,2),
    "SellInvoiceValue" numeric(20,2),
    "SellTaxableValue" numeric(20,2),
    "TotalSellCGST" numeric(20,2),
    "TotalSellSGST" numeric(20,2),
    "TotalSellIGST" numeric(20,2),
    "TotalSellInvoiceValue" numeric(20,2),
    "TotalSellTaxableValue" numeric(20,2),
    "PurchaseTaxableValue" numeric(20,2)
);
 +   DROP TABLE public."CustomerInvoiceMaster";
       public         heap    postgres    false            �            1259    71993    DivisionMaster    TABLE     �   CREATE TABLE public."DivisionMaster" (
    "DivisionID" character varying(255) NOT NULL,
    "DivisionName" character varying(255) NOT NULL
);
 $   DROP TABLE public."DivisionMaster";
       public         heap    postgres    false            �            1259    71999    CustomerInvoiceViews    VIEW     
  CREATE VIEW public."CustomerInvoiceViews" AS
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
    a."CustomerID",
    a."DivisionID",
    a."Implement",
    a."Make",
    a."Model",
    a."HSN",
    a."PackageSize",
    a."PackageUnitOfMeasurement",
    a."PackageQuantity",
    a."ItemQuantity",
    a."TaxRate",
    a."RatePerUnit",
    a."PurchaseInvoiceValue",
    a."PurchaseTaxableValue",
    a."PurchaseCGST",
    a."PurchaseSGST",
    a."PurchaseIGST",
    a."TotalPurchaseInvoiceValue",
    a."TotalPurchaseTaxableValue",
    a."TotalPurchaseCGST",
    a."TotalPurchaseSGST",
    a."SellCGST",
    a."SellSGST",
    a."SellIGST",
    a."SellInvoiceValue",
    a."SellTaxableValue",
    a."TotalSellCGST",
    a."TotalSellSGST",
    a."TotalSellIGST",
    a."TotalSellInvoiceValue",
    a."TotalSellTaxableValue",
    a."UnitOfMeasurement",
    d."DivisionName"
   FROM (public."CustomerInvoiceMaster" a
     JOIN public."DivisionMaster" d ON (((d."DivisionID")::text = (a."DivisionID")::text)));
 )   DROP VIEW public."CustomerInvoiceViews";
       public          postgres    false    206    205    205    205    205    205    206    205    205    205    205    205    205    205    205    205    205    205    205    205    205    205    205    205    205    205    205    205    205    205    205    205    205    205    205    205    205    205    205    205    205    205    205    205    205    205    205    205    205    205            �            1259    72004    customer_id_increment    SEQUENCE     ~   CREATE SEQUENCE public.customer_id_increment
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE public.customer_id_increment;
       public          postgres    false            �            1259    72006    CustomerMaster    TABLE     /  CREATE TABLE public."CustomerMaster" (
    id integer NOT NULL,
    "CustomerID" character varying(255) DEFAULT ('CUS'::text || nextval('public.customer_id_increment'::regclass)),
    "LegalCustomerName" character varying(255),
    "TradeName" character varying(255),
    "PAN" character varying(255),
    "BussinessConstitution" character varying(255),
    "GSTN" character varying(255),
    "ContactNumber" character varying(255),
    "EmailID" character varying(255),
    "InsertedDate" timestamp with time zone,
    "InsertedBy" character varying(255)
);
 $   DROP TABLE public."CustomerMaster";
       public         heap    postgres    false    208            �            1259    72013    CustomerMaster_id_seq    SEQUENCE     �   CREATE SEQUENCE public."CustomerMaster_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public."CustomerMaster_id_seq";
       public          postgres    false    209            �           0    0    CustomerMaster_id_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE public."CustomerMaster_id_seq" OWNED BY public."CustomerMaster".id;
          public          postgres    false    210            �            1259    72015    CustomerPrincipalPlace    TABLE     �  CREATE TABLE public."CustomerPrincipalPlace" (
    id integer NOT NULL,
    "CustomerID" character varying(255),
    "PrincipalPlaceID" integer,
    "Country" character varying(255),
    "StateCode" integer,
    "DistrictOrCity" character varying(255),
    "Pincode" integer,
    "Address" character varying(255),
    "InsertedDate" timestamp with time zone NOT NULL,
    "InsertedBy" character varying(255),
    "UpdatedDate" timestamp with time zone,
    "UpdatedBy" character varying(255)
);
 ,   DROP TABLE public."CustomerPrincipalPlace";
       public         heap    postgres    false            �            1259    72021    CustomerPrincipalPlace_id_seq    SEQUENCE     �   CREATE SEQUENCE public."CustomerPrincipalPlace_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 6   DROP SEQUENCE public."CustomerPrincipalPlace_id_seq";
       public          postgres    false    211            �           0    0    CustomerPrincipalPlace_id_seq    SEQUENCE OWNED BY     c   ALTER SEQUENCE public."CustomerPrincipalPlace_id_seq" OWNED BY public."CustomerPrincipalPlace".id;
          public          postgres    false    212            �            1259    72183    DMMaster    TABLE       CREATE TABLE public."DMMaster" (
    dist_id character varying(2),
    dist_name character varying(30),
    dm_id character varying(30) NOT NULL,
    dm_name character varying(225),
    dm_address character varying(1000),
    dm_mobile_no character varying(15),
    "UpdateOn" timestamp without time zone,
    "UpdateBy" character varying,
    "EmailID" character varying,
    "BankName" character varying,
    "BranchName" character varying,
    "AccountNumber" character varying,
    "IFSCCode" character varying
);
    DROP TABLE public."DMMaster";
       public         heap    postgres    false            �            1259    72171    DistrictMaster    TABLE     �   CREATE TABLE public."DistrictMaster" (
    dist_id character varying(2) NOT NULL,
    dist_name character varying(20),
    "DistCode" character varying
);
 $   DROP TABLE public."DistrictMaster";
       public         heap    postgres    false            �            1259    72023    InvoiceMaster    TABLE     G  CREATE TABLE public."InvoiceMaster" (
    "InvoiceNo" character varying(255) NOT NULL,
    "PONo" character varying(255) NOT NULL,
    "OrderReferenceNo" character varying(255) NOT NULL,
    "InvoiceDate" timestamp with time zone NOT NULL,
    "WayBillNo" character varying(255),
    "WayBillDate" timestamp with time zone,
    "TruckNo" character varying(255),
    "FinYear" character varying(255),
    "DistrictID" character varying(255),
    "VendorID" character varying(255),
    "Status" character varying(255) DEFAULT 'notReceived'::character varying,
    "PaymentStatus" character varying(255) DEFAULT 'pending'::character varying,
    "InvoiceAmount" character varying(255),
    "InvoicePath" character varying(255),
    "POType" character varying(255) NOT NULL,
    "NoOfOrderInPO" character varying(255) NOT NULL,
    "NoOfOrderDeliver" character varying(255) NOT NULL,
    "InsertedDate" timestamp with time zone,
    "InsertedBy" character varying(255),
    "UpdatedDate" timestamp with time zone,
    "UpdatedBy" character varying(255),
    "IsReceived" boolean DEFAULT false,
    "ReceivedDate" timestamp with time zone,
    "EngineNumber" character varying(255),
    "ChassicNumber" character varying(255),
    "MRRNo" character varying,
    "TotalPurchaseTaxableValue" character varying,
    "TotalPurchaseInvoiceValue" character varying,
    "TotalPurchaseCGST" character varying,
    "TotalPurchaseSGST" character varying,
    "TotalPurchaseIGST" character varying,
    "SupplyQuantity" character varying,
    "SupplyPackageQuantity" character varying,
    "Discount" character varying
);
 #   DROP TABLE public."InvoiceMaster";
       public         heap    postgres    false            �            1259    72237 
   ItemMaster    TABLE     �  CREATE TABLE public."ItemMaster" (
    "Implement" character varying(100) NOT NULL,
    "Make" character varying(100) NOT NULL,
    "Model" character varying(300) NOT NULL,
    p_taxable_value numeric(10,2),
    p_cgst_6 numeric(10,2),
    p_sgst_6 numeric(10,2),
    p_cgst_1 numeric(10,2),
    p_sgst_1 numeric(10,2),
    p_invoice_value numeric(10,2),
    s_taxable_value numeric(10,2),
    s_cgst_6 numeric(10,2),
    s_sgst_6 numeric(10,2),
    s_invoice_value numeric(10,2),
    p_igst_12 numeric(10,2),
    s_igst_12 numeric(10,2),
    add_date timestamp with time zone,
    update_date timestamp without time zone,
    "Division" character varying,
    "HSN" character varying,
    "UnitOfMeasurement" character varying,
    "GSTApplicability" character varying,
    "Taxability" character varying,
    "TaxRate" integer,
    "PurchaseInvoiceValue" numeric(10,2),
    "PurchaseTaxableValue" numeric(10,2),
    "PurchaseCGST" numeric(10,2),
    "PurchaseSGST" numeric(10,2),
    "PurchaseIGST" numeric(10,2),
    "PurchaseSGSTOnePercent" numeric(10,2),
    "PurchaseCGSTOnePercent" numeric(10,2),
    "SellCGST" numeric(10,2),
    "SellSGST" numeric(10,2),
    "SellIGST" numeric(10,2),
    "SellInvoiceValue" numeric(10,2),
    "SellTaxableValue" numeric(10,2),
    "InsertedDate" timestamp without time zone,
    "InsertedBy" character varying,
    "UpdatedDate" timestamp without time zone,
    "UpdatedBy" character varying,
    "DivisionID" character varying
);
     DROP TABLE public."ItemMaster";
       public         heap    postgres    false            �            1259    72032    ItemPackageMaster    TABLE     @  CREATE TABLE public."ItemPackageMaster" (
    "DivisionID" character varying(255) NOT NULL,
    "Implement" character varying(255) NOT NULL,
    "Make" character varying(255) NOT NULL,
    "Model" character varying(255) NOT NULL,
    "PackageSize" character varying(255) NOT NULL,
    "UnitOfMeasurement" character varying(255) NOT NULL,
    "PurchaseInvoiceValue" numeric(20,2),
    "PurchaseTaxableValue" numeric(20,2),
    "PurchaseCGST" numeric(20,2),
    "PurchaseSGST" numeric(20,2),
    "PurchaseIGST" numeric(20,2),
    "SellSGST" numeric(20,2),
    "SellIGST" numeric(20,2),
    "SellInvoiceValue" numeric(20,2),
    "SellTaxableValue" numeric(20,2),
    "InsertedDate" timestamp with time zone,
    "InsertedBy" character varying(255),
    "UpdatedDate" timestamp with time zone,
    "UpdatedBy" character varying(255)
);
 '   DROP TABLE public."ItemPackageMaster";
       public         heap    postgres    false            �            1259    72038    ItemPackageSizeMaster    TABLE     s   CREATE TABLE public."ItemPackageSizeMaster" (
    id integer NOT NULL,
    "PackageSize" character varying(255)
);
 +   DROP TABLE public."ItemPackageSizeMaster";
       public         heap    postgres    false            �            1259    72041    ItemPackageSizeMaster_id_seq    SEQUENCE     �   CREATE SEQUENCE public."ItemPackageSizeMaster_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 5   DROP SEQUENCE public."ItemPackageSizeMaster_id_seq";
       public          postgres    false    215            �           0    0    ItemPackageSizeMaster_id_seq    SEQUENCE OWNED BY     a   ALTER SEQUENCE public."ItemPackageSizeMaster_id_seq" OWNED BY public."ItemPackageSizeMaster".id;
          public          postgres    false    216            �            1259    72043 	   MRRMaster    TABLE     K  CREATE TABLE public."MRRMaster" (
    "MRRNo" character varying(255) NOT NULL,
    "InvoiceNo" character varying(255) NOT NULL,
    "PONo" character varying(255) NOT NULL,
    "OrderReferenceNo" character varying(255) NOT NULL,
    "FinYear" character varying(255) NOT NULL,
    "ItemQuantity" integer,
    "MRRAmount" integer,
    "VendorID" character varying(255),
    "DistrictID" character varying(255),
    "DMID" character varying(255),
    "AccID" character varying(255),
    "PaymentStatus" character varying(255) DEFAULT 'Pending'::character varying,
    "POType" character varying(255),
    "InsertedDate" timestamp with time zone,
    "InsertedBy" character varying(255),
    "UpdatedDate" timestamp with time zone,
    "UpdatedBy" character varying(255),
    "NoOfItemReceived" character varying,
    "ReceivedQuantity" integer
);
    DROP TABLE public."MRRMaster";
       public         heap    postgres    false            �            1259    72050    POMaster    TABLE     r  CREATE TABLE public."POMaster" (
    "FinYear" character varying(255),
    "PONo" character varying(255) NOT NULL,
    "OrderReferenceNo" character varying(255) NOT NULL,
    "CustomerID" character varying(255),
    "CustomerOrderRefence" character varying(255),
    "VendorID" character varying(255),
    "DistrictID" character varying(255),
    "DMID" character varying(255),
    "AccID" character varying(255),
    "DivisionID" character varying(255),
    "Implement" character varying(255),
    "Make" character varying(255),
    "Model" character varying(255),
    "UnitOfMeasurement" character varying(255),
    "HSN" character varying(255),
    "TaxRate" character varying(255),
    "PurchaseInvoiceValue" numeric(10,2),
    "PurchaseTaxableValue" numeric(10,2),
    "PurchaseCGST" numeric(10,2),
    "PurchaseSGST" numeric(10,2),
    "PurchaseIGST" numeric(10,2),
    "TotalPurchaseInvoiceValue" numeric(10,2),
    "TotalPurchaseTaxableValue" numeric(10,2),
    "TotalPurchaseCGST" numeric(10,2),
    "TotalPurchaseSGST" numeric(10,2),
    "SellCGST" numeric(10,2),
    "SellSGST" numeric(10,2),
    "SellIGST" numeric(10,2),
    "SellInvoiceValue" numeric(10,2),
    "SellTaxableValue" numeric(10,2),
    "TotalSellCGST" numeric(10,2),
    "TotalSellSGST" numeric(10,2),
    "TotalSellIGST" numeric(10,2),
    "TotalSellInvoiceValue" numeric(10,2),
    "TotalSellTaxableValue" numeric(10,2),
    "POAmount" character varying(255),
    "NoOfItemsInPO" character varying(255) DEFAULT 1,
    "ItemQuantity" character varying(255),
    "ItemQuantitySold" character varying(255),
    "EngineNumber" character varying(255),
    "ChassicNumber" character varying(255),
    "IsDelivered" boolean DEFAULT false,
    "IsReceived" boolean DEFAULT false,
    "IsDeliveredToCustomer" boolean DEFAULT false,
    "Status" character varying(255) DEFAULT 'indentInitiated'::character varying,
    "InsertedDate" timestamp with time zone,
    "InsertedBy" character varying(255),
    "UpdatedDate" timestamp with time zone,
    "UpdatedBy" character varying(255),
    "IsApproved" boolean DEFAULT false,
    "ApprovalStatus" character varying(255) DEFAULT 'Pending'::character varying,
    "ApprovedDate" timestamp with time zone,
    "ApprovedBy" character varying(255),
    "IsDeleted" boolean DEFAULT false,
    "DeletedDate" timestamp with time zone,
    "DeletedBy" character varying(255),
    "IsCancelled" boolean DEFAULT false,
    "CancellationStatus" character varying(255),
    "CancelledDate" timestamp with time zone,
    "CancelledBy" character varying(255),
    "POType" character varying(255),
    "VendorInvoiceNo" character varying(255),
    "MRRID" character varying(255),
    "RatePerUnit" numeric(20,2),
    "PackageQuantity" character varying,
    "PackageSize" character varying,
    "PackageUnitOfMeasurement" character varying,
    "DeliveredQuantity" character varying,
    "PendingQuantity" character varying
);
    DROP TABLE public."POMaster";
       public         heap    postgres    false            �            1259    72065    MRRViews    VIEW     �  CREATE VIEW public."MRRViews" AS
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
   FROM (((public."MRRMaster" a
     JOIN public."InvoiceMaster" b ON (((b."InvoiceNo")::text = (a."InvoiceNo")::text)))
     JOIN public."POMaster" c ON ((((c."PONo")::text = (a."PONo")::text) AND ((c."OrderReferenceNo")::text = (a."OrderReferenceNo")::text))))
     JOIN public."DivisionMaster" d ON (((d."DivisionID")::text = (c."DivisionID")::text)))
  WHERE ((a."POType")::text = 'NonSubsidy'::text);
    DROP VIEW public."MRRViews";
       public          postgres    false    218    218    218    218    218    217    218    218    218    218    218    218    218    218    218    218    218    218    218    218    218    218    218    218    218    218    218    218    218    218    217    206    206    213    217    217    217    217    217    217    217    217    217    217    217    217    217    218    217    217    218    218    218    218    218    218    218    217    218    218            �            1259    72070    NonSubsidyPODetails    TABLE       CREATE TABLE public."NonSubsidyPODetails" (
    id integer NOT NULL,
    "OrderReferenceNo" character varying(255),
    "PONo" character varying(255) NOT NULL,
    "CustomerID" character varying(255),
    "DivisionID" character varying(255),
    "Implement" character varying(255),
    "Make" character varying(255),
    "Model" character varying(255),
    "UnitOfMeasurement" character varying(255),
    "HSN" character varying(255),
    "TaxRate" character varying(255),
    "PurchaseInvoiceValue" numeric(10,2),
    "PurchaseTaxableValue" numeric(10,2),
    "PurchaseCGST" numeric(10,2),
    "PurchaseSGST" numeric(10,2),
    "PurchaseIGST" numeric(10,2),
    "SellCGST" numeric(10,2),
    "SellSGST" numeric(10,2),
    "SellIGST" numeric(10,2),
    "SellInvoiceValue" numeric(10,2),
    "SellTaxableValue" numeric(10,2),
    "ItemQuantity" character varying(255),
    "ItemQuantitySold" character varying(255),
    "EngineNumber" character varying(255),
    "ChassicNumber" character varying(255),
    "IsDelivered" boolean DEFAULT false,
    "IsReceived" boolean DEFAULT false,
    "IsDeliveredToCustomer" boolean DEFAULT false,
    "InsertedDate" timestamp with time zone,
    "InsertedBy" character varying(255),
    "UpdatedDate" timestamp with time zone,
    "UpdatedBy" character varying(255)
);
 )   DROP TABLE public."NonSubsidyPODetails";
       public         heap    postgres    false            �            1259    72079    NonSubsidyPODetails_id_seq    SEQUENCE     �   CREATE SEQUENCE public."NonSubsidyPODetails_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 3   DROP SEQUENCE public."NonSubsidyPODetails_id_seq";
       public          postgres    false    220            �           0    0    NonSubsidyPODetails_id_seq    SEQUENCE OWNED BY     ]   ALTER SEQUENCE public."NonSubsidyPODetails_id_seq" OWNED BY public."NonSubsidyPODetails".id;
          public          postgres    false    221            �            1259    72081    StateMaster    TABLE     y   CREATE TABLE public."StateMaster" (
    "StateCode" integer NOT NULL,
    "StateName" character varying(255) NOT NULL
);
 !   DROP TABLE public."StateMaster";
       public         heap    postgres    false            �            1259    72084    StockMaster    VIEW     Q  CREATE VIEW public."StockMaster" AS
 SELECT a."DistrictID",
    a."DivisionID",
    a."DivisionName",
    a."Implement",
    a."Make",
    a."Model",
    a."UnitOfMeasurement",
    a."PackageSize",
    a."PackageUnitOfMeasurement",
    COALESCE(sum(a."ItemQuantity"), (0)::bigint) AS "ReceivedQuantity",
    COALESCE(sum(b."ItemQuantity"), (0)::bigint) AS "DeliveredQuantity",
    (COALESCE(sum(a."ItemQuantity"), (0)::bigint) - COALESCE(sum(b."ItemQuantity"), (0)::bigint)) AS "AvailableQuantity"
   FROM (public."MRRViews" a
     LEFT JOIN public."CustomerInvoiceViews" b ON ((((a."DistrictID")::text = (b."DistrictID")::text) AND ((a."DivisionID")::text = (b."DivisionID")::text) AND ((a."DivisionName")::text = (b."DivisionName")::text) AND ((a."Implement")::text = (b."Implement")::text) AND ((a."Make")::text = (b."Make")::text) AND ((a."Model")::text = (b."Model")::text) AND ((a."PackageSize")::text = (b."PackageSize")::text))))
  GROUP BY a."DistrictID", a."DivisionID", a."DivisionName", a."Implement", a."Make", a."Model", a."UnitOfMeasurement", a."PackageUnitOfMeasurement", a."PackageSize";
     DROP VIEW public."StockMaster";
       public          postgres    false    219    207    207    207    207    207    207    207    207    219    219    219    219    219    219    219    219    219            �            1259    72089    VendorBankAccount    TABLE     j  CREATE TABLE public."VendorBankAccount" (
    "VendorID" character varying(255) NOT NULL,
    "BankAccountID" integer NOT NULL,
    "AccountNumber" character varying(255) NOT NULL,
    "AccountType" character varying(255) NOT NULL,
    "BankName" character varying(255) NOT NULL,
    "BranchName" character varying(255) NOT NULL,
    "IFSCCode" character varying(255) NOT NULL,
    "BankDocument" character varying(255) NOT NULL,
    "InsertedDate" timestamp with time zone NOT NULL,
    "InsertedBy" character varying(255) NOT NULL,
    "UpdatedDate" timestamp without time zone,
    "UpdatedBy" character varying
);
 '   DROP TABLE public."VendorBankAccount";
       public         heap    postgres    false            �            1259    72095 #   VendorBankAccount_BankAccountID_seq    SEQUENCE     �   CREATE SEQUENCE public."VendorBankAccount_BankAccountID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 <   DROP SEQUENCE public."VendorBankAccount_BankAccountID_seq";
       public          postgres    false    224            �           0    0 #   VendorBankAccount_BankAccountID_seq    SEQUENCE OWNED BY     q   ALTER SEQUENCE public."VendorBankAccount_BankAccountID_seq" OWNED BY public."VendorBankAccount"."BankAccountID";
          public          postgres    false    225            �            1259    72097    VendorContactPerson    TABLE     �  CREATE TABLE public."VendorContactPerson" (
    "VendorID" character varying(255) NOT NULL,
    "ContactPersonID" integer NOT NULL,
    "Name" character varying(255) NOT NULL,
    "FathersName" character varying(255) NOT NULL,
    "MobileNumber" bigint NOT NULL,
    "EmailID" character varying(255) NOT NULL,
    "Designation" character varying(255) NOT NULL,
    "InsertedDate" timestamp with time zone NOT NULL,
    "InsertedBy" character varying(255) NOT NULL
);
 )   DROP TABLE public."VendorContactPerson";
       public         heap    postgres    false            �            1259    72103 '   VendorContactPerson_ContactPersonID_seq    SEQUENCE     �   CREATE SEQUENCE public."VendorContactPerson_ContactPersonID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 @   DROP SEQUENCE public."VendorContactPerson_ContactPersonID_seq";
       public          postgres    false    226            �           0    0 '   VendorContactPerson_ContactPersonID_seq    SEQUENCE OWNED BY     y   ALTER SEQUENCE public."VendorContactPerson_ContactPersonID_seq" OWNED BY public."VendorContactPerson"."ContactPersonID";
          public          postgres    false    227            �            1259    72105    VendorDistrictMapping    TABLE     �   CREATE TABLE public."VendorDistrictMapping" (
    "VendorID" character varying(255) NOT NULL,
    "DistrictID" character varying(255) NOT NULL,
    "InsertedDate" timestamp with time zone NOT NULL
);
 +   DROP TABLE public."VendorDistrictMapping";
       public         heap    postgres    false            �            1259    72111    VendorMaster    TABLE       CREATE TABLE public."VendorMaster" (
    "VendorID" character varying(255) NOT NULL,
    "LegalBussinessName" character varying(255),
    "TradeName" character varying(255),
    "PAN" character varying(255),
    "PANDocument" character varying(255),
    "BussinessConstitution" character varying(255),
    "GSTN" character varying(255),
    "GSTNDocument" character varying(255),
    "IncorporationDate" timestamp with time zone,
    "ContactNumber" character varying(255),
    "EmailID" character varying(255),
    "ApprovalStatus" character varying(255) DEFAULT 'Pending'::character varying,
    "ApplyStatus" character varying(255) DEFAULT 'Pending'::character varying NOT NULL,
    "InsertedDate" timestamp with time zone,
    "InsertedBy" character varying(255),
    "IsDeleted" boolean DEFAULT false,
    "ApproveOrRejectDate" timestamp with time zone,
    "ApproveOrRejectBy" character varying(255),
    "WhetherSSIUnit" character varying(255),
    "WhetherMSME" character varying(255),
    "SSIUnitRegistrationCertificate" character varying(255),
    "MSMECertificate" character varying(255),
    "CoreBussinessActivity" character varying(255),
    "Turnover1" character varying(255),
    "Turnover2" character varying(255),
    "Turnover3" character varying(255),
    "Password" character varying
);
 "   DROP TABLE public."VendorMaster";
       public         heap    postgres    false            �            1259    72120    VendorPrincipalPlace    TABLE     �  CREATE TABLE public."VendorPrincipalPlace" (
    "VendorID" character varying(255) NOT NULL,
    "PrincipalPlaceID" integer NOT NULL,
    "Country" character varying(255) NOT NULL,
    "StateCode" integer NOT NULL,
    "DistrictOrCity" character varying(255) NOT NULL,
    "Pincode" integer NOT NULL,
    "Address" character varying(255) NOT NULL,
    "InsertedDate" timestamp with time zone NOT NULL,
    "InsertedBy" character varying(255) NOT NULL
);
 *   DROP TABLE public."VendorPrincipalPlace";
       public         heap    postgres    false            �            1259    72126 )   VendorPrincipalPlace_PrincipalPlaceID_seq    SEQUENCE     �   CREATE SEQUENCE public."VendorPrincipalPlace_PrincipalPlaceID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 B   DROP SEQUENCE public."VendorPrincipalPlace_PrincipalPlaceID_seq";
       public          postgres    false    230            �           0    0 )   VendorPrincipalPlace_PrincipalPlaceID_seq    SEQUENCE OWNED BY     }   ALTER SEQUENCE public."VendorPrincipalPlace_PrincipalPlaceID_seq" OWNED BY public."VendorPrincipalPlace"."PrincipalPlaceID";
          public          postgres    false    231            �            1259    72128    VendorServices    TABLE     �   CREATE TABLE public."VendorServices" (
    "VendorID" character varying(255) NOT NULL,
    "Service" character varying(255) NOT NULL,
    "InsertedDate" timestamp with time zone NOT NULL,
    "InsertedBy" character varying(255) NOT NULL
);
 $   DROP TABLE public."VendorServices";
       public         heap    postgres    false            �            1259    72140    approval    TABLE     H  CREATE TABLE public.approval (
    sl_no integer NOT NULL,
    invoice_no character varying(30) NOT NULL,
    fin_year character varying(10),
    dist_id character varying(2),
    dl_id character varying(50),
    status character varying(50),
    approval_id character varying(30),
    indent_no character varying(30),
    approval_date timestamp without time zone,
    ammount integer,
    transaction_id character varying(30),
    deduction_amount numeric(100,20),
    pay_now_amount numeric(100,20),
    payment_status character varying(30),
    remark character varying(500),
    dl_remark character varying(500),
    paid_amount numeric(100,20),
    pp_id character varying(50),
    pp_status character varying(50),
    dm_approved_on timestamp without time zone,
    bank_approved_on timestamp without time zone,
    items integer
);
    DROP TABLE public.approval;
       public         heap    postgres    false            �            1259    72146    approval_desc    TABLE     �   CREATE TABLE public.approval_desc (
    approval_id character varying(30) NOT NULL,
    permit_no character varying(50) NOT NULL,
    serial integer NOT NULL,
    mrr_id character varying
);
 !   DROP TABLE public.approval_desc;
       public         heap    postgres    false            �            1259    72152    approval_desc_serial_seq    SEQUENCE     �   CREATE SEQUENCE public.approval_desc_serial_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 /   DROP SEQUENCE public.approval_desc_serial_seq;
       public          postgres    false    235            �           0    0    approval_desc_serial_seq    SEQUENCE OWNED BY     U   ALTER SEQUENCE public.approval_desc_serial_seq OWNED BY public.approval_desc.serial;
          public          postgres    false    236            �            1259    72154    approval_status_desc    TABLE     ~   CREATE TABLE public.approval_status_desc (
    status_id character varying(50) NOT NULL,
    "desc" character varying(100)
);
 (   DROP TABLE public.approval_status_desc;
       public         heap    postgres    false            �            1259    72157 
   components    TABLE     �   CREATE TABLE public.components (
    comp_id character varying(10) NOT NULL,
    schema_id character varying(10),
    comp_name character varying(30)
);
    DROP TABLE public.components;
       public         heap    postgres    false            �            1259    72160    dept_expenditure_payment_desc    TABLE     �  CREATE TABLE public.dept_expenditure_payment_desc (
    sl_no integer NOT NULL,
    reference_no character varying(30),
    transaction_id character varying(30),
    source_id character varying(10),
    schem_id character varying(10),
    comp_id character varying(10),
    head_id character varying(10),
    subhead_id character varying(10),
    head_name character varying(70),
    subhead_name character varying(70),
    sd_path character varying(100)
);
 1   DROP TABLE public.dept_expenditure_payment_desc;
       public         heap    postgres    false            �            1259    72163    govt_share_config    TABLE     �   CREATE TABLE public.govt_share_config (
    sl integer NOT NULL,
    fin_year character varying(10),
    head character varying(30),
    govt_share_ammount integer
);
 %   DROP TABLE public.govt_share_config;
       public         heap    postgres    false            �            1259    72166    dept_money_config_sl_seq    SEQUENCE     �   CREATE SEQUENCE public.dept_money_config_sl_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 /   DROP SEQUENCE public.dept_money_config_sl_seq;
       public          postgres    false    240            �           0    0    dept_money_config_sl_seq    SEQUENCE OWNED BY     U   ALTER SEQUENCE public.dept_money_config_sl_seq OWNED BY public.govt_share_config.sl;
          public          postgres    false    241            �            1259    72189    farmer_receipt    TABLE     S  CREATE TABLE public.farmer_receipt (
    sl_no integer NOT NULL,
    receipt_no character varying(225) NOT NULL,
    fin_year character varying(10),
    farmer_name character varying(225),
    farmer_id character varying(225),
    full_ammount character varying(30),
    permit_no character varying(225),
    implement character varying(225),
    payment_mode character varying(225),
    payment_no character varying(255),
    source_bank character varying(225),
    date timestamp without time zone,
    dist_id character varying(5),
    office character varying(225),
    payment_date date
);
 "   DROP TABLE public.farmer_receipt;
       public         heap    postgres    false            �            1259    72195    farmer_receipts_sl_no_seq    SEQUENCE     �   CREATE SEQUENCE public.farmer_receipts_sl_no_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 0   DROP SEQUENCE public.farmer_receipts_sl_no_seq;
       public          postgres    false    244            �           0    0    farmer_receipts_sl_no_seq    SEQUENCE OWNED BY     V   ALTER SEQUENCE public.farmer_receipts_sl_no_seq OWNED BY public.farmer_receipt.sl_no;
          public          postgres    false    245            �            1259    72197    head_master    TABLE     u   CREATE TABLE public.head_master (
    head_id character varying(10) NOT NULL,
    head_name character varying(30)
);
    DROP TABLE public.head_master;
       public         heap    postgres    false            �            1259    72243 !   jalanidhi_dept_expnd_payment_desc    TABLE     �   CREATE TABLE public.jalanidhi_dept_expnd_payment_desc (
    serial integer NOT NULL,
    transaction_id character varying(50),
    scheme_id character varying(10),
    scheme_name character varying(50),
    comp_id character varying(10)
);
 5   DROP TABLE public.jalanidhi_dept_expnd_payment_desc;
       public         heap    postgres    false            �            1259    72246 ,   jalanidhi_dept_expnd_payment_desc_serial_seq    SEQUENCE     �   CREATE SEQUENCE public.jalanidhi_dept_expnd_payment_desc_serial_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 C   DROP SEQUENCE public.jalanidhi_dept_expnd_payment_desc_serial_seq;
       public          postgres    false    248            �           0    0 ,   jalanidhi_dept_expnd_payment_desc_serial_seq    SEQUENCE OWNED BY     }   ALTER SEQUENCE public.jalanidhi_dept_expnd_payment_desc_serial_seq OWNED BY public.jalanidhi_dept_expnd_payment_desc.serial;
          public          postgres    false    249            �            1259    72248    jalanidhi_payment_desc    TABLE     N  CREATE TABLE public.jalanidhi_payment_desc (
    transaction_id character varying(50),
    farmer_id character varying(70),
    farmer_name character varying(50),
    implement character varying(50),
    make character varying(50),
    model character varying(50),
    serial integer NOT NULL,
    project_id character varying(60)
);
 *   DROP TABLE public.jalanidhi_payment_desc;
       public         heap    postgres    false            �            1259    72251 !   jalanidhi_payment_desc_serial_seq    SEQUENCE     �   CREATE SEQUENCE public.jalanidhi_payment_desc_serial_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 8   DROP SEQUENCE public.jalanidhi_payment_desc_serial_seq;
       public          postgres    false    250            �           0    0 !   jalanidhi_payment_desc_serial_seq    SEQUENCE OWNED BY     g   ALTER SEQUENCE public.jalanidhi_payment_desc_serial_seq OWNED BY public.jalanidhi_payment_desc.serial;
          public          postgres    false    251            �            1259    72253    jn_expenditure_desc    TABLE     �   CREATE TABLE public.jn_expenditure_desc (
    transaction_id character varying(70) NOT NULL,
    item_name character varying(50) NOT NULL,
    item_price numeric(10,5) NOT NULL,
    quantity integer NOT NULL,
    serial integer NOT NULL
);
 '   DROP TABLE public.jn_expenditure_desc;
       public         heap    postgres    false            �            1259    72256    jn_expenditure_desc_serial_seq    SEQUENCE     �   CREATE SEQUENCE public.jn_expenditure_desc_serial_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 5   DROP SEQUENCE public.jn_expenditure_desc_serial_seq;
       public          postgres    false    252            �           0    0    jn_expenditure_desc_serial_seq    SEQUENCE OWNED BY     a   ALTER SEQUENCE public.jn_expenditure_desc_serial_seq OWNED BY public.jn_expenditure_desc.serial;
          public          postgres    false    253            �            1259    72258 	   jn_orders    TABLE     ~  CREATE TABLE public.jn_orders (
    fin_year character varying(10),
    dist_id character varying(2),
    cluster_id character varying(70) NOT NULL,
    farmer_id character varying(70) NOT NULL,
    dist_name character varying(50),
    farmer_name character varying(70),
    status character varying(30),
    date timestamp(6) without time zone,
    system character varying(30)
);
    DROP TABLE public.jn_orders;
       public         heap    postgres    false            �            1259    72261    jn_stock    TABLE     �  CREATE TABLE public.jn_stock (
    fin_year character varying(10) NOT NULL,
    dist_id character varying(2) NOT NULL,
    dl_id character varying(4) NOT NULL,
    system character varying(30) NOT NULL,
    po_no character varying(50) NOT NULL,
    cluster_id character varying(70) NOT NULL,
    farmer_id character varying(70) NOT NULL,
    farmer_name character varying(50),
    implement character varying(50) NOT NULL,
    make character varying(50) NOT NULL,
    model character varying(50) NOT NULL,
    engine_no character varying(50),
    chassic_no character varying(50),
    status character varying(50) NOT NULL,
    receive_date timestamp without time zone,
    deliver_date timestamp without time zone,
    dl_name character varying(50)
);
    DROP TABLE public.jn_stock;
       public         heap    postgres    false                        1259    72267    lgd_block_master    TABLE     �   CREATE TABLE public.lgd_block_master (
    dist_code character varying(500),
    block_code character varying(20) NOT NULL,
    block_name character varying(200)
);
 $   DROP TABLE public.lgd_block_master;
       public         heap    postgres    false                       1259    72273    lgd_dist_master    TABLE     |   CREATE TABLE public.lgd_dist_master (
    dist_code character varying(20) NOT NULL,
    dist_name character varying(200)
);
 #   DROP TABLE public.lgd_dist_master;
       public         heap    postgres    false                       1259    72276    lgd_gp_master    TABLE     �   CREATE TABLE public.lgd_gp_master (
    dist_code character varying(20),
    block_code character varying(20),
    gp_code character varying(20) NOT NULL,
    gp_name character varying(100)
);
 !   DROP TABLE public.lgd_gp_master;
       public         heap    postgres    false                       1259    72279    log    TABLE     �  CREATE TABLE public.log (
    sl_no integer NOT NULL,
    date_time timestamp without time zone,
    user_id character varying,
    action character varying,
    status character varying,
    ref_url character varying,
    route character varying,
    ip character varying,
    browser_name character varying,
    browser_version character varying,
    fin_year character varying,
    remark character varying
);
    DROP TABLE public.log;
       public         heap    postgres    false                       1259    72285    log_sl_no_seq    SEQUENCE     �   CREATE SEQUENCE public.log_sl_no_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 $   DROP SEQUENCE public.log_sl_no_seq;
       public          postgres    false    259            �           0    0    log_sl_no_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE public.log_sl_no_seq OWNED BY public.log.sl_no;
          public          postgres    false    260                       1259    72287    mrr    TABLE     g  CREATE TABLE public.mrr (
    sl_no integer NOT NULL,
    mrr_id character varying(30) NOT NULL,
    dist_id character varying(2),
    invoice_no character varying(20),
    fin_year character varying(10),
    dl_id character varying(50),
    date timestamp without time zone,
    items integer,
    indent_no character varying(100),
    mrr_amount integer
);
    DROP TABLE public.mrr;
       public         heap    postgres    false                       1259    72290    mrr_desc    TABLE     z   CREATE TABLE public.mrr_desc (
    mrr_id character varying(30) NOT NULL,
    permit_no character varying(40) NOT NULL
);
    DROP TABLE public.mrr_desc;
       public         heap    postgres    false                       1259    72293    mrr_sl_no_seq    SEQUENCE     �   CREATE SEQUENCE public.mrr_sl_no_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 $   DROP SEQUENCE public.mrr_sl_no_seq;
       public          postgres    false    261            �           0    0    mrr_sl_no_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE public.mrr_sl_no_seq OWNED BY public.mrr.sl_no;
          public          postgres    false    263                       1259    72295    new_item_price    TABLE     ?  CREATE TABLE public.new_item_price (
    implement character varying(100) NOT NULL,
    make character varying(100) NOT NULL,
    model character varying(500) NOT NULL,
    purchase_price character varying(100),
    taxable_value character varying(100),
    cgst_6 character varying(100),
    sags_6 character varying(100),
    invoice_alue character varying(100),
    selling_price character varying(100),
    sl_taxable_value character varying(100),
    sl_cgst_6 character varying(100),
    sl_sgst_6 character varying(100),
    sl_invoice_value character varying(100)
);
 "   DROP TABLE public.new_item_price;
       public         heap    postgres    false            	           1259    72301    opening_balance    TABLE     e  CREATE TABLE public.opening_balance (
    fin_year character varying(10),
    date date,
    system character varying(50),
    dist_id character varying(2),
    transaction_id character varying(100) NOT NULL,
    ammount numeric(100,2),
    remark character varying(500),
    purpose character varying(50),
    reference_no character varying(100),
    "from" character varying(50),
    "to" character varying(50),
    head character varying(100),
    subhead character varying(100),
    payment_type character varying(30),
    payment_date date,
    payment_no character varying(50),
    test double precision
);
 #   DROP TABLE public.opening_balance;
       public         heap    postgres    false            
           1259    72307    orders    TABLE     �  CREATE TABLE public.orders (
    permit_no character varying(225) NOT NULL,
    permit_issue_date timestamp without time zone,
    permit_validity timestamp without time zone,
    farmer_id character varying(225),
    farmer_name character varying(225),
    farmer_father_name character varying(225),
    dist_name character varying(225),
    block_name character varying(225),
    gp_name character varying(225),
    village_name character varying(225),
    implement character varying(225),
    make character varying(225),
    model character varying(225),
    status character varying(225),
    permit_validity_1 character varying(225),
    permit_issue_date_1 character varying(225),
    fin_year character varying(30),
    dist_id character varying(2),
    engine_no character varying(225),
    chassic_no character varying(225),
    ammount integer,
    remark character varying(225),
    expected_delivery_date date,
    delivery_date timestamp(4) without time zone,
    c_fin_year character varying(10),
    date timestamp without time zone,
    system character varying(20),
    paid_amount integer,
    order_type character varying(30),
    "FullCost" numeric(20,2),
    "PendingCost" numeric(20,2)
);
    DROP TABLE public.orders;
       public         heap    postgres    false                       1259    72313    payment    TABLE     D  CREATE TABLE public.payment (
    sl_no integer NOT NULL,
    date timestamp without time zone,
    reference_no character varying(50),
    transaction_id character varying(30) NOT NULL,
    "from" character varying(30),
    "to" character varying(30),
    remark character varying(30),
    payment_type character varying(30),
    payment_no character varying(40),
    fin_year character varying(10),
    purpose character varying(30),
    payment_date date,
    ammount numeric(100,10),
    status character varying(30),
    system character varying(50),
    source_bank character varying,
    "DivisionID" character varying,
    "Implement" character varying,
    "MoneyReceiptNo" character varying,
    "PayFrom" character varying,
    "PayTo" character varying,
    "PayFromID" character varying,
    "PayToID" character varying
);
    DROP TABLE public.payment;
       public         heap    postgres    false                       1259    72319    payment1_sl_no_seq    SEQUENCE     �   CREATE SEQUENCE public.payment1_sl_no_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.payment1_sl_no_seq;
       public          postgres    false    267            �           0    0    payment1_sl_no_seq    SEQUENCE OWNED BY     H   ALTER SEQUENCE public.payment1_sl_no_seq OWNED BY public.payment.sl_no;
          public          postgres    false    268                       1259    72321    payment_desc    TABLE     �   CREATE TABLE public.payment_desc (
    transaction_id character varying(70) NOT NULL,
    reference_no character varying(70) NOT NULL
);
     DROP TABLE public.payment_desc;
       public         heap    postgres    false                       1259    72324    payment_desc_2_sl_no_seq    SEQUENCE     �   CREATE SEQUENCE public.payment_desc_2_sl_no_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 /   DROP SEQUENCE public.payment_desc_2_sl_no_seq;
       public          postgres    false    239            �           0    0    payment_desc_2_sl_no_seq    SEQUENCE OWNED BY     d   ALTER SEQUENCE public.payment_desc_2_sl_no_seq OWNED BY public.dept_expenditure_payment_desc.sl_no;
          public          postgres    false    270                       1259    72326    payment_invoice_sl_no_seq    SEQUENCE     �   CREATE SEQUENCE public.payment_invoice_sl_no_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 0   DROP SEQUENCE public.payment_invoice_sl_no_seq;
       public          postgres    false    234            �           0    0    payment_invoice_sl_no_seq    SEQUENCE OWNED BY     P   ALTER SEQUENCE public.payment_invoice_sl_no_seq OWNED BY public.approval.sl_no;
          public          postgres    false    271                       1259    72328    payment_purpose_desc    TABLE        CREATE TABLE public.payment_purpose_desc (
    purpose_id character varying(50) NOT NULL,
    "desc" character varying(100)
);
 (   DROP TABLE public.payment_purpose_desc;
       public         heap    postgres    false                       1259    72331    schem_master    TABLE     x   CREATE TABLE public.schem_master (
    schem_id character varying(10) NOT NULL,
    schem_name character varying(30)
);
     DROP TABLE public.schem_master;
       public         heap    postgres    false                       1259    72334    source_master    TABLE     {   CREATE TABLE public.source_master (
    source_id character varying(10) NOT NULL,
    source_name character varying(30)
);
 !   DROP TABLE public.source_master;
       public         heap    postgres    false                       1259    72337    subheads    TABLE     �   CREATE TABLE public.subheads (
    subhead_id character varying(10) NOT NULL,
    head_id character varying(10),
    subhead_name character varying(30)
);
    DROP TABLE public.subheads;
       public         heap    postgres    false                       1259    72340    system_desc    TABLE     u   CREATE TABLE public.system_desc (
    system_id character varying(50) NOT NULL,
    "desc" character varying(100)
);
    DROP TABLE public.system_desc;
       public         heap    postgres    false                       1259    72343 
   tax_config    TABLE     r   CREATE TABLE public.tax_config (
    tax_mode character varying(2) NOT NULL,
    "desc" character varying(100)
);
    DROP TABLE public.tax_config;
       public         heap    postgres    false                       1259    72346    users    TABLE     �   CREATE TABLE public.users (
    user_id character varying(225) NOT NULL,
    password character varying(300),
    role character varying(20)
);
    DROP TABLE public.users;
       public         heap    postgres    false            T           2604    72358    CustomerBankAccount id    DEFAULT     �   ALTER TABLE ONLY public."CustomerBankAccount" ALTER COLUMN id SET DEFAULT nextval('public."CustomerBankAccount_id_seq"'::regclass);
 G   ALTER TABLE public."CustomerBankAccount" ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    201    200            U           2604    72359    CustomerContactPerson id    DEFAULT     �   ALTER TABLE ONLY public."CustomerContactPerson" ALTER COLUMN id SET DEFAULT nextval('public."CustomerContactPerson_id_seq"'::regclass);
 I   ALTER TABLE public."CustomerContactPerson" ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    203    202            W           2604    72360    CustomerMaster id    DEFAULT     z   ALTER TABLE ONLY public."CustomerMaster" ALTER COLUMN id SET DEFAULT nextval('public."CustomerMaster_id_seq"'::regclass);
 B   ALTER TABLE public."CustomerMaster" ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    210    209            X           2604    72361    CustomerPrincipalPlace id    DEFAULT     �   ALTER TABLE ONLY public."CustomerPrincipalPlace" ALTER COLUMN id SET DEFAULT nextval('public."CustomerPrincipalPlace_id_seq"'::regclass);
 J   ALTER TABLE public."CustomerPrincipalPlace" ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    212    211            \           2604    72362    ItemPackageSizeMaster id    DEFAULT     �   ALTER TABLE ONLY public."ItemPackageSizeMaster" ALTER COLUMN id SET DEFAULT nextval('public."ItemPackageSizeMaster_id_seq"'::regclass);
 I   ALTER TABLE public."ItemPackageSizeMaster" ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    216    215            j           2604    72363    NonSubsidyPODetails id    DEFAULT     �   ALTER TABLE ONLY public."NonSubsidyPODetails" ALTER COLUMN id SET DEFAULT nextval('public."NonSubsidyPODetails_id_seq"'::regclass);
 G   ALTER TABLE public."NonSubsidyPODetails" ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    221    220            k           2604    72364    VendorBankAccount BankAccountID    DEFAULT     �   ALTER TABLE ONLY public."VendorBankAccount" ALTER COLUMN "BankAccountID" SET DEFAULT nextval('public."VendorBankAccount_BankAccountID_seq"'::regclass);
 R   ALTER TABLE public."VendorBankAccount" ALTER COLUMN "BankAccountID" DROP DEFAULT;
       public          postgres    false    225    224            l           2604    72365 #   VendorContactPerson ContactPersonID    DEFAULT     �   ALTER TABLE ONLY public."VendorContactPerson" ALTER COLUMN "ContactPersonID" SET DEFAULT nextval('public."VendorContactPerson_ContactPersonID_seq"'::regclass);
 V   ALTER TABLE public."VendorContactPerson" ALTER COLUMN "ContactPersonID" DROP DEFAULT;
       public          postgres    false    227    226            p           2604    72366 %   VendorPrincipalPlace PrincipalPlaceID    DEFAULT     �   ALTER TABLE ONLY public."VendorPrincipalPlace" ALTER COLUMN "PrincipalPlaceID" SET DEFAULT nextval('public."VendorPrincipalPlace_PrincipalPlaceID_seq"'::regclass);
 X   ALTER TABLE public."VendorPrincipalPlace" ALTER COLUMN "PrincipalPlaceID" DROP DEFAULT;
       public          postgres    false    231    230            q           2604    72367    approval sl_no    DEFAULT     w   ALTER TABLE ONLY public.approval ALTER COLUMN sl_no SET DEFAULT nextval('public.payment_invoice_sl_no_seq'::regclass);
 =   ALTER TABLE public.approval ALTER COLUMN sl_no DROP DEFAULT;
       public          postgres    false    271    234            r           2604    72368    approval_desc serial    DEFAULT     |   ALTER TABLE ONLY public.approval_desc ALTER COLUMN serial SET DEFAULT nextval('public.approval_desc_serial_seq'::regclass);
 C   ALTER TABLE public.approval_desc ALTER COLUMN serial DROP DEFAULT;
       public          postgres    false    236    235            s           2604    72369 #   dept_expenditure_payment_desc sl_no    DEFAULT     �   ALTER TABLE ONLY public.dept_expenditure_payment_desc ALTER COLUMN sl_no SET DEFAULT nextval('public.payment_desc_2_sl_no_seq'::regclass);
 R   ALTER TABLE public.dept_expenditure_payment_desc ALTER COLUMN sl_no DROP DEFAULT;
       public          postgres    false    270    239            u           2604    72370    farmer_receipt sl_no    DEFAULT     }   ALTER TABLE ONLY public.farmer_receipt ALTER COLUMN sl_no SET DEFAULT nextval('public.farmer_receipts_sl_no_seq'::regclass);
 C   ALTER TABLE public.farmer_receipt ALTER COLUMN sl_no DROP DEFAULT;
       public          postgres    false    245    244            t           2604    72371    govt_share_config sl    DEFAULT     |   ALTER TABLE ONLY public.govt_share_config ALTER COLUMN sl SET DEFAULT nextval('public.dept_money_config_sl_seq'::regclass);
 C   ALTER TABLE public.govt_share_config ALTER COLUMN sl DROP DEFAULT;
       public          postgres    false    241    240            v           2604    72374 (   jalanidhi_dept_expnd_payment_desc serial    DEFAULT     �   ALTER TABLE ONLY public.jalanidhi_dept_expnd_payment_desc ALTER COLUMN serial SET DEFAULT nextval('public.jalanidhi_dept_expnd_payment_desc_serial_seq'::regclass);
 W   ALTER TABLE public.jalanidhi_dept_expnd_payment_desc ALTER COLUMN serial DROP DEFAULT;
       public          postgres    false    249    248            w           2604    72375    jalanidhi_payment_desc serial    DEFAULT     �   ALTER TABLE ONLY public.jalanidhi_payment_desc ALTER COLUMN serial SET DEFAULT nextval('public.jalanidhi_payment_desc_serial_seq'::regclass);
 L   ALTER TABLE public.jalanidhi_payment_desc ALTER COLUMN serial DROP DEFAULT;
       public          postgres    false    251    250            x           2604    72376    jn_expenditure_desc serial    DEFAULT     �   ALTER TABLE ONLY public.jn_expenditure_desc ALTER COLUMN serial SET DEFAULT nextval('public.jn_expenditure_desc_serial_seq'::regclass);
 I   ALTER TABLE public.jn_expenditure_desc ALTER COLUMN serial DROP DEFAULT;
       public          postgres    false    253    252            y           2604    72377 	   log sl_no    DEFAULT     f   ALTER TABLE ONLY public.log ALTER COLUMN sl_no SET DEFAULT nextval('public.log_sl_no_seq'::regclass);
 8   ALTER TABLE public.log ALTER COLUMN sl_no DROP DEFAULT;
       public          postgres    false    260    259            z           2604    72378 	   mrr sl_no    DEFAULT     f   ALTER TABLE ONLY public.mrr ALTER COLUMN sl_no SET DEFAULT nextval('public.mrr_sl_no_seq'::regclass);
 8   ALTER TABLE public.mrr ALTER COLUMN sl_no DROP DEFAULT;
       public          postgres    false    263    261            {           2604    72379    payment sl_no    DEFAULT     o   ALTER TABLE ONLY public.payment ALTER COLUMN sl_no SET DEFAULT nextval('public.payment1_sl_no_seq'::regclass);
 <   ALTER TABLE public.payment ALTER COLUMN sl_no DROP DEFAULT;
       public          postgres    false    268    267            �          0    72134    AccountantMaster 
   TABLE DATA           �   COPY public."AccountantMaster" (acc_name, acc_id, dist_id, dist_name, acc_address, acc_mobile_no, "UpdateOn", "UpdateBy") FROM stdin;
    public          postgres    false    233   6�      �          0    71965    CustomerBankAccount 
   TABLE DATA           �   COPY public."CustomerBankAccount" (id, "CustomerID", "BankAccountID", "bankAccountNo", "accountType", "bankName", "branchName", "ifscCode", "InsertedDate", "InsertedBy", "UpdatedDate", "UpdatedBy") FROM stdin;
    public          postgres    false    200   =�      �          0    71973    CustomerContactPerson 
   TABLE DATA           �   COPY public."CustomerContactPerson" (id, "CustomerID", "ContactPersonID", "AuthorisedName", "AuthorisedMobileNo", "AuthorisedEmailID", "Designation", "InsertedDate", "InsertedBy", "UpdatedDate", "UpdatedBy") FROM stdin;
    public          postgres    false    202   p�      �          0    71981    CustomerDistrictMapping 
   TABLE DATA           _   COPY public."CustomerDistrictMapping" ("CustomerID", "DistrictID", "InsertedDate") FROM stdin;
    public          postgres    false    204   e�      �          0    71987    CustomerInvoiceMaster 
   TABLE DATA           N  COPY public."CustomerInvoiceMaster" ("CustomerInvoiceNo", "MRRNo", "InvoiceNo", "PONo", "OrderReferenceNo", "POType", "FinYear", "DistrictID", "VendorID", "InvoiceAmount", "NoOfOrderDeliver", "DeliveredQuantity", "InsertedDate", "InsertedBy", "UpdatedDate", "UpdatedBy", "CustomerID", "DivisionID", "Implement", "Make", "Model", "HSN", "UnitOfMeasurement", "PackageSize", "PackageUnitOfMeasurement", "PackageQuantity", "ItemQuantity", "TaxRate", "RatePerUnit", "PurchaseInvoiceValue", "PurchaseCGST", "PurchaseSGST", "PurchaseIGST", "TotalPurchaseInvoiceValue", "TotalPurchaseTaxableValue", "TotalPurchaseCGST", "TotalPurchaseSGST", "SellCGST", "SellSGST", "SellIGST", "SellInvoiceValue", "SellTaxableValue", "TotalSellCGST", "TotalSellSGST", "TotalSellIGST", "TotalSellInvoiceValue", "TotalSellTaxableValue", "PurchaseTaxableValue") FROM stdin;
    public          postgres    false    205   �      �          0    72006    CustomerMaster 
   TABLE DATA           �   COPY public."CustomerMaster" (id, "CustomerID", "LegalCustomerName", "TradeName", "PAN", "BussinessConstitution", "GSTN", "ContactNumber", "EmailID", "InsertedDate", "InsertedBy") FROM stdin;
    public          postgres    false    209   �      �          0    72015    CustomerPrincipalPlace 
   TABLE DATA           �   COPY public."CustomerPrincipalPlace" (id, "CustomerID", "PrincipalPlaceID", "Country", "StateCode", "DistrictOrCity", "Pincode", "Address", "InsertedDate", "InsertedBy", "UpdatedDate", "UpdatedBy") FROM stdin;
    public          postgres    false    211   :&      �          0    72183    DMMaster 
   TABLE DATA           �   COPY public."DMMaster" (dist_id, dist_name, dm_id, dm_name, dm_address, dm_mobile_no, "UpdateOn", "UpdateBy", "EmailID", "BankName", "BranchName", "AccountNumber", "IFSCCode") FROM stdin;
    public          postgres    false    243   �:      �          0    72171    DistrictMaster 
   TABLE DATA           J   COPY public."DistrictMaster" (dist_id, dist_name, "DistCode") FROM stdin;
    public          postgres    false    242   �C      �          0    71993    DivisionMaster 
   TABLE DATA           H   COPY public."DivisionMaster" ("DivisionID", "DivisionName") FROM stdin;
    public          postgres    false    206   E      �          0    72023    InvoiceMaster 
   TABLE DATA           I  COPY public."InvoiceMaster" ("InvoiceNo", "PONo", "OrderReferenceNo", "InvoiceDate", "WayBillNo", "WayBillDate", "TruckNo", "FinYear", "DistrictID", "VendorID", "Status", "PaymentStatus", "InvoiceAmount", "InvoicePath", "POType", "NoOfOrderInPO", "NoOfOrderDeliver", "InsertedDate", "InsertedBy", "UpdatedDate", "UpdatedBy", "IsReceived", "ReceivedDate", "EngineNumber", "ChassicNumber", "MRRNo", "TotalPurchaseTaxableValue", "TotalPurchaseInvoiceValue", "TotalPurchaseCGST", "TotalPurchaseSGST", "TotalPurchaseIGST", "SupplyQuantity", "SupplyPackageQuantity", "Discount") FROM stdin;
    public          postgres    false    213   hE      �          0    72237 
   ItemMaster 
   TABLE DATA           n  COPY public."ItemMaster" ("Implement", "Make", "Model", p_taxable_value, p_cgst_6, p_sgst_6, p_cgst_1, p_sgst_1, p_invoice_value, s_taxable_value, s_cgst_6, s_sgst_6, s_invoice_value, p_igst_12, s_igst_12, add_date, update_date, "Division", "HSN", "UnitOfMeasurement", "GSTApplicability", "Taxability", "TaxRate", "PurchaseInvoiceValue", "PurchaseTaxableValue", "PurchaseCGST", "PurchaseSGST", "PurchaseIGST", "PurchaseSGSTOnePercent", "PurchaseCGSTOnePercent", "SellCGST", "SellSGST", "SellIGST", "SellInvoiceValue", "SellTaxableValue", "InsertedDate", "InsertedBy", "UpdatedDate", "UpdatedBy", "DivisionID") FROM stdin;
    public          postgres    false    247   qZ      �          0    72032    ItemPackageMaster 
   TABLE DATA           W  COPY public."ItemPackageMaster" ("DivisionID", "Implement", "Make", "Model", "PackageSize", "UnitOfMeasurement", "PurchaseInvoiceValue", "PurchaseTaxableValue", "PurchaseCGST", "PurchaseSGST", "PurchaseIGST", "SellSGST", "SellIGST", "SellInvoiceValue", "SellTaxableValue", "InsertedDate", "InsertedBy", "UpdatedDate", "UpdatedBy") FROM stdin;
    public          postgres    false    214   r�      �          0    72038    ItemPackageSizeMaster 
   TABLE DATA           D   COPY public."ItemPackageSizeMaster" (id, "PackageSize") FROM stdin;
    public          postgres    false    215   '�      �          0    72043 	   MRRMaster 
   TABLE DATA           '  COPY public."MRRMaster" ("MRRNo", "InvoiceNo", "PONo", "OrderReferenceNo", "FinYear", "ItemQuantity", "MRRAmount", "VendorID", "DistrictID", "DMID", "AccID", "PaymentStatus", "POType", "InsertedDate", "InsertedBy", "UpdatedDate", "UpdatedBy", "NoOfItemReceived", "ReceivedQuantity") FROM stdin;
    public          postgres    false    217   ��      �          0    72070    NonSubsidyPODetails 
   TABLE DATA             COPY public."NonSubsidyPODetails" (id, "OrderReferenceNo", "PONo", "CustomerID", "DivisionID", "Implement", "Make", "Model", "UnitOfMeasurement", "HSN", "TaxRate", "PurchaseInvoiceValue", "PurchaseTaxableValue", "PurchaseCGST", "PurchaseSGST", "PurchaseIGST", "SellCGST", "SellSGST", "SellIGST", "SellInvoiceValue", "SellTaxableValue", "ItemQuantity", "ItemQuantitySold", "EngineNumber", "ChassicNumber", "IsDelivered", "IsReceived", "IsDeliveredToCustomer", "InsertedDate", "InsertedBy", "UpdatedDate", "UpdatedBy") FROM stdin;
    public          postgres    false    220   ]�      �          0    72050    POMaster 
   TABLE DATA           �  COPY public."POMaster" ("FinYear", "PONo", "OrderReferenceNo", "CustomerID", "CustomerOrderRefence", "VendorID", "DistrictID", "DMID", "AccID", "DivisionID", "Implement", "Make", "Model", "UnitOfMeasurement", "HSN", "TaxRate", "PurchaseInvoiceValue", "PurchaseTaxableValue", "PurchaseCGST", "PurchaseSGST", "PurchaseIGST", "TotalPurchaseInvoiceValue", "TotalPurchaseTaxableValue", "TotalPurchaseCGST", "TotalPurchaseSGST", "SellCGST", "SellSGST", "SellIGST", "SellInvoiceValue", "SellTaxableValue", "TotalSellCGST", "TotalSellSGST", "TotalSellIGST", "TotalSellInvoiceValue", "TotalSellTaxableValue", "POAmount", "NoOfItemsInPO", "ItemQuantity", "ItemQuantitySold", "EngineNumber", "ChassicNumber", "IsDelivered", "IsReceived", "IsDeliveredToCustomer", "Status", "InsertedDate", "InsertedBy", "UpdatedDate", "UpdatedBy", "IsApproved", "ApprovalStatus", "ApprovedDate", "ApprovedBy", "IsDeleted", "DeletedDate", "DeletedBy", "IsCancelled", "CancellationStatus", "CancelledDate", "CancelledBy", "POType", "VendorInvoiceNo", "MRRID", "RatePerUnit", "PackageQuantity", "PackageSize", "PackageUnitOfMeasurement", "DeliveredQuantity", "PendingQuantity") FROM stdin;
    public          postgres    false    218   z�      �          0    72081    StateMaster 
   TABLE DATA           A   COPY public."StateMaster" ("StateCode", "StateName") FROM stdin;
    public          postgres    false    222   c�      �          0    72089    VendorBankAccount 
   TABLE DATA           �   COPY public."VendorBankAccount" ("VendorID", "BankAccountID", "AccountNumber", "AccountType", "BankName", "BranchName", "IFSCCode", "BankDocument", "InsertedDate", "InsertedBy", "UpdatedDate", "UpdatedBy") FROM stdin;
    public          postgres    false    224   ��      �          0    72097    VendorContactPerson 
   TABLE DATA           �   COPY public."VendorContactPerson" ("VendorID", "ContactPersonID", "Name", "FathersName", "MobileNumber", "EmailID", "Designation", "InsertedDate", "InsertedBy") FROM stdin;
    public          postgres    false    226   ��      �          0    72105    VendorDistrictMapping 
   TABLE DATA           [   COPY public."VendorDistrictMapping" ("VendorID", "DistrictID", "InsertedDate") FROM stdin;
    public          postgres    false    228   ��      �          0    72111    VendorMaster 
   TABLE DATA           �  COPY public."VendorMaster" ("VendorID", "LegalBussinessName", "TradeName", "PAN", "PANDocument", "BussinessConstitution", "GSTN", "GSTNDocument", "IncorporationDate", "ContactNumber", "EmailID", "ApprovalStatus", "ApplyStatus", "InsertedDate", "InsertedBy", "IsDeleted", "ApproveOrRejectDate", "ApproveOrRejectBy", "WhetherSSIUnit", "WhetherMSME", "SSIUnitRegistrationCertificate", "MSMECertificate", "CoreBussinessActivity", "Turnover1", "Turnover2", "Turnover3", "Password") FROM stdin;
    public          postgres    false    229   7      �          0    72120    VendorPrincipalPlace 
   TABLE DATA           �   COPY public."VendorPrincipalPlace" ("VendorID", "PrincipalPlaceID", "Country", "StateCode", "DistrictOrCity", "Pincode", "Address", "InsertedDate", "InsertedBy") FROM stdin;
    public          postgres    false    230   N:      �          0    72128    VendorServices 
   TABLE DATA           _   COPY public."VendorServices" ("VendorID", "Service", "InsertedDate", "InsertedBy") FROM stdin;
    public          postgres    false    232   �M      �          0    72140    approval 
   TABLE DATA           $  COPY public.approval (sl_no, invoice_no, fin_year, dist_id, dl_id, status, approval_id, indent_no, approval_date, ammount, transaction_id, deduction_amount, pay_now_amount, payment_status, remark, dl_remark, paid_amount, pp_id, pp_status, dm_approved_on, bank_approved_on, items) FROM stdin;
    public          postgres    false    234   U      �          0    72146    approval_desc 
   TABLE DATA           O   COPY public.approval_desc (approval_id, permit_no, serial, mrr_id) FROM stdin;
    public          postgres    false    235   �]      �          0    72154    approval_status_desc 
   TABLE DATA           A   COPY public.approval_status_desc (status_id, "desc") FROM stdin;
    public          postgres    false    237   q_      �          0    72157 
   components 
   TABLE DATA           C   COPY public.components (comp_id, schema_id, comp_name) FROM stdin;
    public          postgres    false    238   �_      �          0    72160    dept_expenditure_payment_desc 
   TABLE DATA           �   COPY public.dept_expenditure_payment_desc (sl_no, reference_no, transaction_id, source_id, schem_id, comp_id, head_id, subhead_id, head_name, subhead_name, sd_path) FROM stdin;
    public          postgres    false    239   P`      �          0    72189    farmer_receipt 
   TABLE DATA           �   COPY public.farmer_receipt (sl_no, receipt_no, fin_year, farmer_name, farmer_id, full_ammount, permit_no, implement, payment_mode, payment_no, source_bank, date, dist_id, office, payment_date) FROM stdin;
    public          postgres    false    244   �c      �          0    72163    govt_share_config 
   TABLE DATA           S   COPY public.govt_share_config (sl, fin_year, head, govt_share_ammount) FROM stdin;
    public          postgres    false    240   k�      �          0    72197    head_master 
   TABLE DATA           9   COPY public.head_master (head_id, head_name) FROM stdin;
    public          postgres    false    246   ��      �          0    72243 !   jalanidhi_dept_expnd_payment_desc 
   TABLE DATA           t   COPY public.jalanidhi_dept_expnd_payment_desc (serial, transaction_id, scheme_id, scheme_name, comp_id) FROM stdin;
    public          postgres    false    248   �      �          0    72248    jalanidhi_payment_desc 
   TABLE DATA           �   COPY public.jalanidhi_payment_desc (transaction_id, farmer_id, farmer_name, implement, make, model, serial, project_id) FROM stdin;
    public          postgres    false    250   `�      �          0    72253    jn_expenditure_desc 
   TABLE DATA           f   COPY public.jn_expenditure_desc (transaction_id, item_name, item_price, quantity, serial) FROM stdin;
    public          postgres    false    252   @�      �          0    72258 	   jn_orders 
   TABLE DATA           {   COPY public.jn_orders (fin_year, dist_id, cluster_id, farmer_id, dist_name, farmer_name, status, date, system) FROM stdin;
    public          postgres    false    254   8�      �          0    72261    jn_stock 
   TABLE DATA           �   COPY public.jn_stock (fin_year, dist_id, dl_id, system, po_no, cluster_id, farmer_id, farmer_name, implement, make, model, engine_no, chassic_no, status, receive_date, deliver_date, dl_name) FROM stdin;
    public          postgres    false    255   ��      �          0    72267    lgd_block_master 
   TABLE DATA           M   COPY public.lgd_block_master (dist_code, block_code, block_name) FROM stdin;
    public          postgres    false    256   Ř      �          0    72273    lgd_dist_master 
   TABLE DATA           ?   COPY public.lgd_dist_master (dist_code, dist_name) FROM stdin;
    public          postgres    false    257   ��      �          0    72276    lgd_gp_master 
   TABLE DATA           P   COPY public.lgd_gp_master (dist_code, block_code, gp_code, gp_name) FROM stdin;
    public          postgres    false    258   �      �          0    72279    log 
   TABLE DATA           �   COPY public.log (sl_no, date_time, user_id, action, status, ref_url, route, ip, browser_name, browser_version, fin_year, remark) FROM stdin;
    public          postgres    false    259   Qd      �          0    72287    mrr 
   TABLE DATA           v   COPY public.mrr (sl_no, mrr_id, dist_id, invoice_no, fin_year, dl_id, date, items, indent_no, mrr_amount) FROM stdin;
    public          postgres    false    261   ��      �          0    72290    mrr_desc 
   TABLE DATA           5   COPY public.mrr_desc (mrr_id, permit_no) FROM stdin;
    public          postgres    false    262   t�      �          0    72295    new_item_price 
   TABLE DATA           �   COPY public.new_item_price (implement, make, model, purchase_price, taxable_value, cgst_6, sags_6, invoice_alue, selling_price, sl_taxable_value, sl_cgst_6, sl_sgst_6, sl_invoice_value) FROM stdin;
    public          postgres    false    264   T�      �          0    72301    opening_balance 
   TABLE DATA           �   COPY public.opening_balance (fin_year, date, system, dist_id, transaction_id, ammount, remark, purpose, reference_no, "from", "to", head, subhead, payment_type, payment_date, payment_no, test) FROM stdin;
    public          postgres    false    265    �      �          0    72307    orders 
   TABLE DATA           �  COPY public.orders (permit_no, permit_issue_date, permit_validity, farmer_id, farmer_name, farmer_father_name, dist_name, block_name, gp_name, village_name, implement, make, model, status, permit_validity_1, permit_issue_date_1, fin_year, dist_id, engine_no, chassic_no, ammount, remark, expected_delivery_date, delivery_date, c_fin_year, date, system, paid_amount, order_type, "FullCost", "PendingCost") FROM stdin;
    public          postgres    false    266    �      �          0    72313    payment 
   TABLE DATA             COPY public.payment (sl_no, date, reference_no, transaction_id, "from", "to", remark, payment_type, payment_no, fin_year, purpose, payment_date, ammount, status, system, source_bank, "DivisionID", "Implement", "MoneyReceiptNo", "PayFrom", "PayTo", "PayFromID", "PayToID") FROM stdin;
    public          postgres    false    267   }�      �          0    72321    payment_desc 
   TABLE DATA           D   COPY public.payment_desc (transaction_id, reference_no) FROM stdin;
    public          postgres    false    269   79      �          0    72328    payment_purpose_desc 
   TABLE DATA           B   COPY public.payment_purpose_desc (purpose_id, "desc") FROM stdin;
    public          postgres    false    272   T9      �          0    72331    schem_master 
   TABLE DATA           <   COPY public.schem_master (schem_id, schem_name) FROM stdin;
    public          postgres    false    273   :      �          0    72334    source_master 
   TABLE DATA           ?   COPY public.source_master (source_id, source_name) FROM stdin;
    public          postgres    false    274   Z:      �          0    72337    subheads 
   TABLE DATA           E   COPY public.subheads (subhead_id, head_id, subhead_name) FROM stdin;
    public          postgres    false    275   �:      �          0    72340    system_desc 
   TABLE DATA           8   COPY public.system_desc (system_id, "desc") FROM stdin;
    public          postgres    false    276   8;      �          0    72343 
   tax_config 
   TABLE DATA           6   COPY public.tax_config (tax_mode, "desc") FROM stdin;
    public          postgres    false    277   w;      �          0    72346    users 
   TABLE DATA           8   COPY public.users (user_id, password, role) FROM stdin;
    public          postgres    false    278   �;      �           0    0    CustomerBankAccount_id_seq    SEQUENCE SET     K   SELECT pg_catalog.setval('public."CustomerBankAccount_id_seq"', 36, true);
          public          postgres    false    201            �           0    0    CustomerContactPerson_id_seq    SEQUENCE SET     N   SELECT pg_catalog.setval('public."CustomerContactPerson_id_seq"', 141, true);
          public          postgres    false    203            �           0    0    CustomerMaster_id_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('public."CustomerMaster_id_seq"', 177, true);
          public          postgres    false    210            �           0    0    CustomerPrincipalPlace_id_seq    SEQUENCE SET     O   SELECT pg_catalog.setval('public."CustomerPrincipalPlace_id_seq"', 202, true);
          public          postgres    false    212            �           0    0    ItemPackageSizeMaster_id_seq    SEQUENCE SET     M   SELECT pg_catalog.setval('public."ItemPackageSizeMaster_id_seq"', 19, true);
          public          postgres    false    216            �           0    0    NonSubsidyPODetails_id_seq    SEQUENCE SET     K   SELECT pg_catalog.setval('public."NonSubsidyPODetails_id_seq"', 1, false);
          public          postgres    false    221            �           0    0 #   VendorBankAccount_BankAccountID_seq    SEQUENCE SET     T   SELECT pg_catalog.setval('public."VendorBankAccount_BankAccountID_seq"', 90, true);
          public          postgres    false    225            �           0    0 '   VendorContactPerson_ContactPersonID_seq    SEQUENCE SET     Y   SELECT pg_catalog.setval('public."VendorContactPerson_ContactPersonID_seq"', 111, true);
          public          postgres    false    227            �           0    0 )   VendorPrincipalPlace_PrincipalPlaceID_seq    SEQUENCE SET     Z   SELECT pg_catalog.setval('public."VendorPrincipalPlace_PrincipalPlaceID_seq"', 99, true);
          public          postgres    false    231            �           0    0    approval_desc_serial_seq    SEQUENCE SET     H   SELECT pg_catalog.setval('public.approval_desc_serial_seq', 107, true);
          public          postgres    false    236            �           0    0    customer_id_increment    SEQUENCE SET     E   SELECT pg_catalog.setval('public.customer_id_increment', 177, true);
          public          postgres    false    208            �           0    0    dept_money_config_sl_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.dept_money_config_sl_seq', 1, true);
          public          postgres    false    241            �           0    0    farmer_receipts_sl_no_seq    SEQUENCE SET     I   SELECT pg_catalog.setval('public.farmer_receipts_sl_no_seq', 635, true);
          public          postgres    false    245            �           0    0 ,   jalanidhi_dept_expnd_payment_desc_serial_seq    SEQUENCE SET     [   SELECT pg_catalog.setval('public.jalanidhi_dept_expnd_payment_desc_serial_seq', 12, true);
          public          postgres    false    249            �           0    0 !   jalanidhi_payment_desc_serial_seq    SEQUENCE SET     P   SELECT pg_catalog.setval('public.jalanidhi_payment_desc_serial_seq', 24, true);
          public          postgres    false    251            �           0    0    jn_expenditure_desc_serial_seq    SEQUENCE SET     M   SELECT pg_catalog.setval('public.jn_expenditure_desc_serial_seq', 36, true);
          public          postgres    false    253            �           0    0    log_sl_no_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.log_sl_no_seq', 5207, true);
          public          postgres    false    260            �           0    0    mrr_sl_no_seq    SEQUENCE SET     =   SELECT pg_catalog.setval('public.mrr_sl_no_seq', 229, true);
          public          postgres    false    263                        0    0    payment1_sl_no_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public.payment1_sl_no_seq', 1330, true);
          public          postgres    false    268                       0    0    payment_desc_2_sl_no_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('public.payment_desc_2_sl_no_seq', 93, true);
          public          postgres    false    270                       0    0    payment_invoice_sl_no_seq    SEQUENCE SET     I   SELECT pg_catalog.setval('public.payment_invoice_sl_no_seq', 114, true);
          public          postgres    false    271            }           2606    72381 ,   CustomerBankAccount CustomerBankAccount_pkey 
   CONSTRAINT     n   ALTER TABLE ONLY public."CustomerBankAccount"
    ADD CONSTRAINT "CustomerBankAccount_pkey" PRIMARY KEY (id);
 Z   ALTER TABLE ONLY public."CustomerBankAccount" DROP CONSTRAINT "CustomerBankAccount_pkey";
       public            postgres    false    200                       2606    72383 0   CustomerContactPerson CustomerContactPerson_pkey 
   CONSTRAINT     r   ALTER TABLE ONLY public."CustomerContactPerson"
    ADD CONSTRAINT "CustomerContactPerson_pkey" PRIMARY KEY (id);
 ^   ALTER TABLE ONLY public."CustomerContactPerson" DROP CONSTRAINT "CustomerContactPerson_pkey";
       public            postgres    false    202            �           2606    72385 4   CustomerDistrictMapping CustomerDistrictMapping_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CustomerDistrictMapping"
    ADD CONSTRAINT "CustomerDistrictMapping_pkey" PRIMARY KEY ("CustomerID", "DistrictID");
 b   ALTER TABLE ONLY public."CustomerDistrictMapping" DROP CONSTRAINT "CustomerDistrictMapping_pkey";
       public            postgres    false    204    204            �           2606    72387 0   CustomerInvoiceMaster CustomerInvoiceMaster_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CustomerInvoiceMaster"
    ADD CONSTRAINT "CustomerInvoiceMaster_pkey" PRIMARY KEY ("CustomerInvoiceNo", "OrderReferenceNo");
 ^   ALTER TABLE ONLY public."CustomerInvoiceMaster" DROP CONSTRAINT "CustomerInvoiceMaster_pkey";
       public            postgres    false    205    205            �           2606    72389 "   CustomerMaster CustomerMaster_pkey 
   CONSTRAINT     d   ALTER TABLE ONLY public."CustomerMaster"
    ADD CONSTRAINT "CustomerMaster_pkey" PRIMARY KEY (id);
 P   ALTER TABLE ONLY public."CustomerMaster" DROP CONSTRAINT "CustomerMaster_pkey";
       public            postgres    false    209            �           2606    72391 2   CustomerPrincipalPlace CustomerPrincipalPlace_pkey 
   CONSTRAINT     t   ALTER TABLE ONLY public."CustomerPrincipalPlace"
    ADD CONSTRAINT "CustomerPrincipalPlace_pkey" PRIMARY KEY (id);
 `   ALTER TABLE ONLY public."CustomerPrincipalPlace" DROP CONSTRAINT "CustomerPrincipalPlace_pkey";
       public            postgres    false    211            �           2606    72393 "   DivisionMaster DivisionMaster_pkey 
   CONSTRAINT     n   ALTER TABLE ONLY public."DivisionMaster"
    ADD CONSTRAINT "DivisionMaster_pkey" PRIMARY KEY ("DivisionID");
 P   ALTER TABLE ONLY public."DivisionMaster" DROP CONSTRAINT "DivisionMaster_pkey";
       public            postgres    false    206            �           2606    72395     InvoiceMaster InvoiceMaster_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."InvoiceMaster"
    ADD CONSTRAINT "InvoiceMaster_pkey" PRIMARY KEY ("InvoiceNo", "PONo", "OrderReferenceNo");
 N   ALTER TABLE ONLY public."InvoiceMaster" DROP CONSTRAINT "InvoiceMaster_pkey";
       public            postgres    false    213    213    213            �           2606    72397 (   ItemPackageMaster ItemPackageMaster_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."ItemPackageMaster"
    ADD CONSTRAINT "ItemPackageMaster_pkey" PRIMARY KEY ("DivisionID", "Implement", "Make", "Model", "PackageSize", "UnitOfMeasurement");
 V   ALTER TABLE ONLY public."ItemPackageMaster" DROP CONSTRAINT "ItemPackageMaster_pkey";
       public            postgres    false    214    214    214    214    214    214            �           2606    72399 0   ItemPackageSizeMaster ItemPackageSizeMaster_pkey 
   CONSTRAINT     r   ALTER TABLE ONLY public."ItemPackageSizeMaster"
    ADD CONSTRAINT "ItemPackageSizeMaster_pkey" PRIMARY KEY (id);
 ^   ALTER TABLE ONLY public."ItemPackageSizeMaster" DROP CONSTRAINT "ItemPackageSizeMaster_pkey";
       public            postgres    false    215            �           2606    72401    MRRMaster MRRMaster_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."MRRMaster"
    ADD CONSTRAINT "MRRMaster_pkey" PRIMARY KEY ("MRRNo", "InvoiceNo", "PONo", "OrderReferenceNo");
 F   ALTER TABLE ONLY public."MRRMaster" DROP CONSTRAINT "MRRMaster_pkey";
       public            postgres    false    217    217    217    217            �           2606    72403 ,   NonSubsidyPODetails NonSubsidyPODetails_pkey 
   CONSTRAINT     n   ALTER TABLE ONLY public."NonSubsidyPODetails"
    ADD CONSTRAINT "NonSubsidyPODetails_pkey" PRIMARY KEY (id);
 Z   ALTER TABLE ONLY public."NonSubsidyPODetails" DROP CONSTRAINT "NonSubsidyPODetails_pkey";
       public            postgres    false    220            �           2606    72405    POMaster POMaster_pkey 
   CONSTRAINT     p   ALTER TABLE ONLY public."POMaster"
    ADD CONSTRAINT "POMaster_pkey" PRIMARY KEY ("PONo", "OrderReferenceNo");
 D   ALTER TABLE ONLY public."POMaster" DROP CONSTRAINT "POMaster_pkey";
       public            postgres    false    218    218            �           2606    72407    StateMaster StateMaster_pkey 
   CONSTRAINT     g   ALTER TABLE ONLY public."StateMaster"
    ADD CONSTRAINT "StateMaster_pkey" PRIMARY KEY ("StateCode");
 J   ALTER TABLE ONLY public."StateMaster" DROP CONSTRAINT "StateMaster_pkey";
       public            postgres    false    222            �           2606    72409 (   VendorBankAccount VendorBankAccount_pkey 
   CONSTRAINT     w   ALTER TABLE ONLY public."VendorBankAccount"
    ADD CONSTRAINT "VendorBankAccount_pkey" PRIMARY KEY ("BankAccountID");
 V   ALTER TABLE ONLY public."VendorBankAccount" DROP CONSTRAINT "VendorBankAccount_pkey";
       public            postgres    false    224            �           2606    72411 ,   VendorContactPerson VendorContactPerson_pkey 
   CONSTRAINT     }   ALTER TABLE ONLY public."VendorContactPerson"
    ADD CONSTRAINT "VendorContactPerson_pkey" PRIMARY KEY ("ContactPersonID");
 Z   ALTER TABLE ONLY public."VendorContactPerson" DROP CONSTRAINT "VendorContactPerson_pkey";
       public            postgres    false    226            �           2606    72413 0   VendorDistrictMapping VendorDistrictMapping_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."VendorDistrictMapping"
    ADD CONSTRAINT "VendorDistrictMapping_pkey" PRIMARY KEY ("VendorID", "DistrictID");
 ^   ALTER TABLE ONLY public."VendorDistrictMapping" DROP CONSTRAINT "VendorDistrictMapping_pkey";
       public            postgres    false    228    228            �           2606    72415    VendorMaster VendorMaster_pkey 
   CONSTRAINT     h   ALTER TABLE ONLY public."VendorMaster"
    ADD CONSTRAINT "VendorMaster_pkey" PRIMARY KEY ("VendorID");
 L   ALTER TABLE ONLY public."VendorMaster" DROP CONSTRAINT "VendorMaster_pkey";
       public            postgres    false    229            �           2606    72417 .   VendorPrincipalPlace VendorPrincipalPlace_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."VendorPrincipalPlace"
    ADD CONSTRAINT "VendorPrincipalPlace_pkey" PRIMARY KEY ("PrincipalPlaceID");
 \   ALTER TABLE ONLY public."VendorPrincipalPlace" DROP CONSTRAINT "VendorPrincipalPlace_pkey";
       public            postgres    false    230            �           2606    72419 "   VendorServices VendorServices_pkey 
   CONSTRAINT     w   ALTER TABLE ONLY public."VendorServices"
    ADD CONSTRAINT "VendorServices_pkey" PRIMARY KEY ("VendorID", "Service");
 P   ALTER TABLE ONLY public."VendorServices" DROP CONSTRAINT "VendorServices_pkey";
       public            postgres    false    232    232            �           2606    72421 (   AccountantMaster accountants_master_pkey 
   CONSTRAINT     u   ALTER TABLE ONLY public."AccountantMaster"
    ADD CONSTRAINT accountants_master_pkey PRIMARY KEY (acc_id, dist_id);
 T   ALTER TABLE ONLY public."AccountantMaster" DROP CONSTRAINT accountants_master_pkey;
       public            postgres    false    233    233            �           2606    72423     approval_desc approval_desc_pkey 
   CONSTRAINT     b   ALTER TABLE ONLY public.approval_desc
    ADD CONSTRAINT approval_desc_pkey PRIMARY KEY (serial);
 J   ALTER TABLE ONLY public.approval_desc DROP CONSTRAINT approval_desc_pkey;
       public            postgres    false    235            �           2606    72425 .   approval_status_desc approval_status_desc_pkey 
   CONSTRAINT     s   ALTER TABLE ONLY public.approval_status_desc
    ADD CONSTRAINT approval_status_desc_pkey PRIMARY KEY (status_id);
 X   ALTER TABLE ONLY public.approval_status_desc DROP CONSTRAINT approval_status_desc_pkey;
       public            postgres    false    237            �           2606    72427    components components_pkey 
   CONSTRAINT     ]   ALTER TABLE ONLY public.components
    ADD CONSTRAINT components_pkey PRIMARY KEY (comp_id);
 D   ALTER TABLE ONLY public.components DROP CONSTRAINT components_pkey;
       public            postgres    false    238            �           2606    72429 (   govt_share_config dept_money_config_pkey 
   CONSTRAINT     f   ALTER TABLE ONLY public.govt_share_config
    ADD CONSTRAINT dept_money_config_pkey PRIMARY KEY (sl);
 R   ALTER TABLE ONLY public.govt_share_config DROP CONSTRAINT dept_money_config_pkey;
       public            postgres    false    240            �           2606    72433 !   DistrictMaster dist_master_1_pkey 
   CONSTRAINT     f   ALTER TABLE ONLY public."DistrictMaster"
    ADD CONSTRAINT dist_master_1_pkey PRIMARY KEY (dist_id);
 M   ALTER TABLE ONLY public."DistrictMaster" DROP CONSTRAINT dist_master_1_pkey;
       public            postgres    false    242            �           2606    72437    DMMaster dm_master_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public."DMMaster"
    ADD CONSTRAINT dm_master_pkey PRIMARY KEY (dm_id);
 C   ALTER TABLE ONLY public."DMMaster" DROP CONSTRAINT dm_master_pkey;
       public            postgres    false    243            �           2606    72439 #   farmer_receipt farmer_receipts_pkey 
   CONSTRAINT     i   ALTER TABLE ONLY public.farmer_receipt
    ADD CONSTRAINT farmer_receipts_pkey PRIMARY KEY (receipt_no);
 M   ALTER TABLE ONLY public.farmer_receipt DROP CONSTRAINT farmer_receipts_pkey;
       public            postgres    false    244            �           2606    72441    head_master head_master_pkey 
   CONSTRAINT     _   ALTER TABLE ONLY public.head_master
    ADD CONSTRAINT head_master_pkey PRIMARY KEY (head_id);
 F   ALTER TABLE ONLY public.head_master DROP CONSTRAINT head_master_pkey;
       public            postgres    false    246            �           2606    72453 !   ItemMaster item_price_map_1_pkey1 
   CONSTRAINT     {   ALTER TABLE ONLY public."ItemMaster"
    ADD CONSTRAINT item_price_map_1_pkey1 PRIMARY KEY ("Implement", "Make", "Model");
 M   ALTER TABLE ONLY public."ItemMaster" DROP CONSTRAINT item_price_map_1_pkey1;
       public            postgres    false    247    247    247            �           2606    72455 H   jalanidhi_dept_expnd_payment_desc jalanidhi_dept_expnd_payment_desc_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.jalanidhi_dept_expnd_payment_desc
    ADD CONSTRAINT jalanidhi_dept_expnd_payment_desc_pkey PRIMARY KEY (serial);
 r   ALTER TABLE ONLY public.jalanidhi_dept_expnd_payment_desc DROP CONSTRAINT jalanidhi_dept_expnd_payment_desc_pkey;
       public            postgres    false    248            �           2606    72457 2   jalanidhi_payment_desc jalanidhi_payment_desc_pkey 
   CONSTRAINT     t   ALTER TABLE ONLY public.jalanidhi_payment_desc
    ADD CONSTRAINT jalanidhi_payment_desc_pkey PRIMARY KEY (serial);
 \   ALTER TABLE ONLY public.jalanidhi_payment_desc DROP CONSTRAINT jalanidhi_payment_desc_pkey;
       public            postgres    false    250            �           2606    72459 ,   jn_expenditure_desc jn_expenditure_desc_pkey 
   CONSTRAINT     n   ALTER TABLE ONLY public.jn_expenditure_desc
    ADD CONSTRAINT jn_expenditure_desc_pkey PRIMARY KEY (serial);
 V   ALTER TABLE ONLY public.jn_expenditure_desc DROP CONSTRAINT jn_expenditure_desc_pkey;
       public            postgres    false    252            �           2606    72461    jn_orders jn_orders_pkey 
   CONSTRAINT     i   ALTER TABLE ONLY public.jn_orders
    ADD CONSTRAINT jn_orders_pkey PRIMARY KEY (cluster_id, farmer_id);
 B   ALTER TABLE ONLY public.jn_orders DROP CONSTRAINT jn_orders_pkey;
       public            postgres    false    254    254            �           2606    72463    jn_stock jn_stock_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.jn_stock
    ADD CONSTRAINT jn_stock_pkey PRIMARY KEY (po_no, cluster_id, farmer_id, implement, make, model);
 @   ALTER TABLE ONLY public.jn_stock DROP CONSTRAINT jn_stock_pkey;
       public            postgres    false    255    255    255    255    255    255            �           2606    72465 &   lgd_block_master lgd_block_master_pkey 
   CONSTRAINT     l   ALTER TABLE ONLY public.lgd_block_master
    ADD CONSTRAINT lgd_block_master_pkey PRIMARY KEY (block_code);
 P   ALTER TABLE ONLY public.lgd_block_master DROP CONSTRAINT lgd_block_master_pkey;
       public            postgres    false    256            �           2606    72467 $   lgd_dist_master lgd_dist_master_pkey 
   CONSTRAINT     i   ALTER TABLE ONLY public.lgd_dist_master
    ADD CONSTRAINT lgd_dist_master_pkey PRIMARY KEY (dist_code);
 N   ALTER TABLE ONLY public.lgd_dist_master DROP CONSTRAINT lgd_dist_master_pkey;
       public            postgres    false    257            �           2606    72469     lgd_gp_master lgd_gp_master_pkey 
   CONSTRAINT     c   ALTER TABLE ONLY public.lgd_gp_master
    ADD CONSTRAINT lgd_gp_master_pkey PRIMARY KEY (gp_code);
 J   ALTER TABLE ONLY public.lgd_gp_master DROP CONSTRAINT lgd_gp_master_pkey;
       public            postgres    false    258            �           2606    72471    log log_pkey 
   CONSTRAINT     M   ALTER TABLE ONLY public.log
    ADD CONSTRAINT log_pkey PRIMARY KEY (sl_no);
 6   ALTER TABLE ONLY public.log DROP CONSTRAINT log_pkey;
       public            postgres    false    259            �           2606    72473    mrr_desc mrr_desc_pkey 
   CONSTRAINT     c   ALTER TABLE ONLY public.mrr_desc
    ADD CONSTRAINT mrr_desc_pkey PRIMARY KEY (mrr_id, permit_no);
 @   ALTER TABLE ONLY public.mrr_desc DROP CONSTRAINT mrr_desc_pkey;
       public            postgres    false    262    262            �           2606    72475    mrr mrr_pkey 
   CONSTRAINT     N   ALTER TABLE ONLY public.mrr
    ADD CONSTRAINT mrr_pkey PRIMARY KEY (mrr_id);
 6   ALTER TABLE ONLY public.mrr DROP CONSTRAINT mrr_pkey;
       public            postgres    false    261            �           2606    72477 "   new_item_price new_item_price_pkey 
   CONSTRAINT     t   ALTER TABLE ONLY public.new_item_price
    ADD CONSTRAINT new_item_price_pkey PRIMARY KEY (implement, make, model);
 L   ALTER TABLE ONLY public.new_item_price DROP CONSTRAINT new_item_price_pkey;
       public            postgres    false    264    264    264            �           2606    72479 $   opening_balance opening_balance_pkey 
   CONSTRAINT     n   ALTER TABLE ONLY public.opening_balance
    ADD CONSTRAINT opening_balance_pkey PRIMARY KEY (transaction_id);
 N   ALTER TABLE ONLY public.opening_balance DROP CONSTRAINT opening_balance_pkey;
       public            postgres    false    265            �           2606    72704    orders orders_pkey 
   CONSTRAINT     W   ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (permit_no);
 <   ALTER TABLE ONLY public.orders DROP CONSTRAINT orders_pkey;
       public            postgres    false    266            �           2606    72483    payment payment1_pkey 
   CONSTRAINT     _   ALTER TABLE ONLY public.payment
    ADD CONSTRAINT payment1_pkey PRIMARY KEY (transaction_id);
 ?   ALTER TABLE ONLY public.payment DROP CONSTRAINT payment1_pkey;
       public            postgres    false    267            �           2606    72485 1   dept_expenditure_payment_desc payment_desc_2_pkey 
   CONSTRAINT     r   ALTER TABLE ONLY public.dept_expenditure_payment_desc
    ADD CONSTRAINT payment_desc_2_pkey PRIMARY KEY (sl_no);
 [   ALTER TABLE ONLY public.dept_expenditure_payment_desc DROP CONSTRAINT payment_desc_2_pkey;
       public            postgres    false    239            �           2606    72487    payment_desc payment_desc_pkey 
   CONSTRAINT     v   ALTER TABLE ONLY public.payment_desc
    ADD CONSTRAINT payment_desc_pkey PRIMARY KEY (reference_no, transaction_id);
 H   ALTER TABLE ONLY public.payment_desc DROP CONSTRAINT payment_desc_pkey;
       public            postgres    false    269    269            �           2606    72489 !   approval payment_instruction_pkey 
   CONSTRAINT     b   ALTER TABLE ONLY public.approval
    ADD CONSTRAINT payment_instruction_pkey PRIMARY KEY (sl_no);
 K   ALTER TABLE ONLY public.approval DROP CONSTRAINT payment_instruction_pkey;
       public            postgres    false    234            �           2606    72491 .   payment_purpose_desc payment_purpose_desc_pkey 
   CONSTRAINT     t   ALTER TABLE ONLY public.payment_purpose_desc
    ADD CONSTRAINT payment_purpose_desc_pkey PRIMARY KEY (purpose_id);
 X   ALTER TABLE ONLY public.payment_purpose_desc DROP CONSTRAINT payment_purpose_desc_pkey;
       public            postgres    false    272            �           2606    72493    schem_master schema_master_pkey 
   CONSTRAINT     c   ALTER TABLE ONLY public.schem_master
    ADD CONSTRAINT schema_master_pkey PRIMARY KEY (schem_id);
 I   ALTER TABLE ONLY public.schem_master DROP CONSTRAINT schema_master_pkey;
       public            postgres    false    273            �           2606    72495     source_master source_master_pkey 
   CONSTRAINT     e   ALTER TABLE ONLY public.source_master
    ADD CONSTRAINT source_master_pkey PRIMARY KEY (source_id);
 J   ALTER TABLE ONLY public.source_master DROP CONSTRAINT source_master_pkey;
       public            postgres    false    274            �           2606    72497    subheads subhead_pkey 
   CONSTRAINT     [   ALTER TABLE ONLY public.subheads
    ADD CONSTRAINT subhead_pkey PRIMARY KEY (subhead_id);
 ?   ALTER TABLE ONLY public.subheads DROP CONSTRAINT subhead_pkey;
       public            postgres    false    275            �           2606    72499    system_desc system_desc_pkey 
   CONSTRAINT     a   ALTER TABLE ONLY public.system_desc
    ADD CONSTRAINT system_desc_pkey PRIMARY KEY (system_id);
 F   ALTER TABLE ONLY public.system_desc DROP CONSTRAINT system_desc_pkey;
       public            postgres    false    276            �           2606    72501    tax_config tax_config_pkey 
   CONSTRAINT     ^   ALTER TABLE ONLY public.tax_config
    ADD CONSTRAINT tax_config_pkey PRIMARY KEY (tax_mode);
 D   ALTER TABLE ONLY public.tax_config DROP CONSTRAINT tax_config_pkey;
       public            postgres    false    277            �           2606    72503    users users_pkey 
   CONSTRAINT     S   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (user_id);
 :   ALTER TABLE ONLY public.users DROP CONSTRAINT users_pkey;
       public            postgres    false    278                       2620    72717    payment Generate_MR    TRIGGER     y   CREATE TRIGGER "Generate_MR" BEFORE INSERT ON public.payment FOR EACH ROW EXECUTE FUNCTION public."Paymnet_Insert_MR"();
 .   DROP TRIGGER "Generate_MR" ON public.payment;
       public          postgres    false    283    267                        2620    72506     POMaster updateDeliveredQuantity    TRIGGER     �   CREATE TRIGGER "updateDeliveredQuantity" BEFORE UPDATE ON public."POMaster" FOR EACH ROW EXECUTE FUNCTION public."UpdateDeliveredQuantity"();
 =   DROP TRIGGER "updateDeliveredQuantity" ON public."POMaster";
       public          postgres    false    279    218            �           2620    72507    InvoiceMaster update_invoice_no    TRIGGER     �   CREATE TRIGGER update_invoice_no AFTER INSERT ON public."InvoiceMaster" FOR EACH ROW EXECUTE FUNCTION public.update_invoice_number();
 :   DROP TRIGGER update_invoice_no ON public."InvoiceMaster";
       public          postgres    false    213    280            �           2620    72509    MRRMaster update_mrr_id    TRIGGER     v   CREATE TRIGGER update_mrr_id AFTER INSERT ON public."MRRMaster" FOR EACH ROW EXECUTE FUNCTION public.update_mrr_id();
 2   DROP TRIGGER update_mrr_id ON public."MRRMaster";
       public          postgres    false    281    217                       2620    72510    POMaster update_order    TRIGGER     ~   CREATE TRIGGER update_order AFTER INSERT ON public."POMaster" FOR EACH ROW EXECUTE FUNCTION public.update_order_po_intiate();
 0   DROP TRIGGER update_order ON public."POMaster";
       public          postgres    false    218    282            �           2606    72511 ?   CustomerDistrictMapping CustomerDistrictMapping_DistrictID_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."CustomerDistrictMapping"
    ADD CONSTRAINT "CustomerDistrictMapping_DistrictID_fkey" FOREIGN KEY ("DistrictID") REFERENCES public."DistrictMaster"(dist_id) ON UPDATE CASCADE;
 m   ALTER TABLE ONLY public."CustomerDistrictMapping" DROP CONSTRAINT "CustomerDistrictMapping_DistrictID_fkey";
       public          postgres    false    204    242    3251            �           2606    72516 <   CustomerPrincipalPlace CustomerPrincipalPlace_StateCode_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."CustomerPrincipalPlace"
    ADD CONSTRAINT "CustomerPrincipalPlace_StateCode_fkey" FOREIGN KEY ("StateCode") REFERENCES public."StateMaster"("StateCode") ON UPDATE CASCADE ON DELETE SET NULL;
 j   ALTER TABLE ONLY public."CustomerPrincipalPlace" DROP CONSTRAINT "CustomerPrincipalPlace_StateCode_fkey";
       public          postgres    false    222    211    3223            �           2606    72521 1   VendorBankAccount VendorBankAccount_VendorID_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."VendorBankAccount"
    ADD CONSTRAINT "VendorBankAccount_VendorID_fkey" FOREIGN KEY ("VendorID") REFERENCES public."VendorMaster"("VendorID") ON UPDATE CASCADE;
 _   ALTER TABLE ONLY public."VendorBankAccount" DROP CONSTRAINT "VendorBankAccount_VendorID_fkey";
       public          postgres    false    224    229    3231            �           2606    72526 5   VendorContactPerson VendorContactPerson_VendorID_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."VendorContactPerson"
    ADD CONSTRAINT "VendorContactPerson_VendorID_fkey" FOREIGN KEY ("VendorID") REFERENCES public."VendorMaster"("VendorID") ON UPDATE CASCADE;
 c   ALTER TABLE ONLY public."VendorContactPerson" DROP CONSTRAINT "VendorContactPerson_VendorID_fkey";
       public          postgres    false    226    229    3231            �           2606    72531 ;   VendorDistrictMapping VendorDistrictMapping_DistrictID_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."VendorDistrictMapping"
    ADD CONSTRAINT "VendorDistrictMapping_DistrictID_fkey" FOREIGN KEY ("DistrictID") REFERENCES public."DistrictMaster"(dist_id) ON UPDATE CASCADE;
 i   ALTER TABLE ONLY public."VendorDistrictMapping" DROP CONSTRAINT "VendorDistrictMapping_DistrictID_fkey";
       public          postgres    false    228    242    3251            �           2606    72536 9   VendorDistrictMapping VendorDistrictMapping_VendorID_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."VendorDistrictMapping"
    ADD CONSTRAINT "VendorDistrictMapping_VendorID_fkey" FOREIGN KEY ("VendorID") REFERENCES public."VendorMaster"("VendorID") ON UPDATE CASCADE;
 g   ALTER TABLE ONLY public."VendorDistrictMapping" DROP CONSTRAINT "VendorDistrictMapping_VendorID_fkey";
       public          postgres    false    228    229    3231            �           2606    72541 8   VendorPrincipalPlace VendorPrincipalPlace_StateCode_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."VendorPrincipalPlace"
    ADD CONSTRAINT "VendorPrincipalPlace_StateCode_fkey" FOREIGN KEY ("StateCode") REFERENCES public."StateMaster"("StateCode") ON UPDATE CASCADE;
 f   ALTER TABLE ONLY public."VendorPrincipalPlace" DROP CONSTRAINT "VendorPrincipalPlace_StateCode_fkey";
       public          postgres    false    230    222    3223            �           2606    72546 7   VendorPrincipalPlace VendorPrincipalPlace_VendorID_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."VendorPrincipalPlace"
    ADD CONSTRAINT "VendorPrincipalPlace_VendorID_fkey" FOREIGN KEY ("VendorID") REFERENCES public."VendorMaster"("VendorID") ON UPDATE CASCADE;
 e   ALTER TABLE ONLY public."VendorPrincipalPlace" DROP CONSTRAINT "VendorPrincipalPlace_VendorID_fkey";
       public          postgres    false    3231    229    230            �           2606    72551 +   VendorServices VendorServices_VendorID_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."VendorServices"
    ADD CONSTRAINT "VendorServices_VendorID_fkey" FOREIGN KEY ("VendorID") REFERENCES public."VendorMaster"("VendorID") ON UPDATE CASCADE;
 Y   ALTER TABLE ONLY public."VendorServices" DROP CONSTRAINT "VendorServices_VendorID_fkey";
       public          postgres    false    3231    232    229            �           2606    72705 *   approval_desc approval_desc_permit_no_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.approval_desc
    ADD CONSTRAINT approval_desc_permit_no_fkey FOREIGN KEY (permit_no) REFERENCES public.orders(permit_no) NOT VALID;
 T   ALTER TABLE ONLY public.approval_desc DROP CONSTRAINT approval_desc_permit_no_fkey;
       public          postgres    false    266    235    3287            �           2606    72561    approval approval_status_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.approval
    ADD CONSTRAINT approval_status_fkey FOREIGN KEY (status) REFERENCES public.approval_status_desc(status_id) NOT VALID;
 G   ALTER TABLE ONLY public.approval DROP CONSTRAINT approval_status_fkey;
       public          postgres    false    3243    237    234            �           2606    72566    lgd_gp_master block_master    FK CONSTRAINT     �   ALTER TABLE ONLY public.lgd_gp_master
    ADD CONSTRAINT block_master FOREIGN KEY (block_code) REFERENCES public.lgd_block_master(block_code) NOT VALID;
 D   ALTER TABLE ONLY public.lgd_gp_master DROP CONSTRAINT block_master;
       public          postgres    false    3271    256    258            �           2606    72576    lgd_gp_master dist_master    FK CONSTRAINT     �   ALTER TABLE ONLY public.lgd_gp_master
    ADD CONSTRAINT dist_master FOREIGN KEY (dist_code) REFERENCES public.lgd_dist_master(dist_code) NOT VALID;
 C   ALTER TABLE ONLY public.lgd_gp_master DROP CONSTRAINT dist_master;
       public          postgres    false    3273    258    257            �           2606    72581    lgd_block_master dist_master    FK CONSTRAINT     �   ALTER TABLE ONLY public.lgd_block_master
    ADD CONSTRAINT dist_master FOREIGN KEY (dist_code) REFERENCES public.lgd_dist_master(dist_code) NOT VALID;
 F   ALTER TABLE ONLY public.lgd_block_master DROP CONSTRAINT dist_master;
       public          postgres    false    3273    257    256            �           2606    72621 +   jn_stock jn_stock_cluster_id_farmer_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.jn_stock
    ADD CONSTRAINT jn_stock_cluster_id_farmer_id_fkey FOREIGN KEY (cluster_id, farmer_id) REFERENCES public.jn_orders(cluster_id, farmer_id) NOT VALID;
 U   ALTER TABLE ONLY public.jn_stock DROP CONSTRAINT jn_stock_cluster_id_farmer_id_fkey;
       public          postgres    false    3267    255    255    254    254            �           2606    72626    mrr_desc mrr_desc_mrr_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.mrr_desc
    ADD CONSTRAINT mrr_desc_mrr_id_fkey FOREIGN KEY (mrr_id) REFERENCES public.mrr(mrr_id) NOT VALID;
 G   ALTER TABLE ONLY public.mrr_desc DROP CONSTRAINT mrr_desc_mrr_id_fkey;
       public          postgres    false    262    3279    261            �           2606    72710     mrr_desc mrr_desc_permit_no_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.mrr_desc
    ADD CONSTRAINT mrr_desc_permit_no_fkey FOREIGN KEY (permit_no) REFERENCES public.orders(permit_no) NOT VALID;
 J   ALTER TABLE ONLY public.mrr_desc DROP CONSTRAINT mrr_desc_permit_no_fkey;
       public          postgres    false    3287    262    266            �           2606    72636    mrr mrr_dist_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.mrr
    ADD CONSTRAINT mrr_dist_id_fkey FOREIGN KEY (dist_id) REFERENCES public."DistrictMaster"(dist_id) NOT VALID;
 >   ALTER TABLE ONLY public.mrr DROP CONSTRAINT mrr_dist_id_fkey;
       public          postgres    false    3251    242    261            �           2606    72641 ,   opening_balance opening_balance_dist_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.opening_balance
    ADD CONSTRAINT opening_balance_dist_id_fkey FOREIGN KEY (dist_id) REFERENCES public."DistrictMaster"(dist_id);
 V   ALTER TABLE ONLY public.opening_balance DROP CONSTRAINT opening_balance_dist_id_fkey;
       public          postgres    false    3251    265    242            �           2606    72646 -   payment_desc payment_desc_transaction_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.payment_desc
    ADD CONSTRAINT payment_desc_transaction_id_fkey FOREIGN KEY (transaction_id) REFERENCES public.payment(transaction_id) NOT VALID;
 W   ALTER TABLE ONLY public.payment_desc DROP CONSTRAINT payment_desc_transaction_id_fkey;
       public          postgres    false    267    269    3289            �   �  x�}W�n��}�|�? ������[�AXi�y�v0vd썸_O�1a�M��R&�ԩ�s�k]l��ݙ�Ή��b5T+?,7+�y���:f�σPȈ�_1�ݬ�cV9β��T���j>TO��$�|x,�ͱ�2�;����ur�u�d�:�n��>������D()I�RJ�yH<�;F�<�P1�A�]
�j<�o����Z;Ӥ�-�E|o�G�W���UvL��z�+d,���'(Eq��i?���E�t����?��p��)��zZl�Q;jW�NWrtFe�^V����y�Y�lo�}��z�o�в�w"�2q_P2�>66����Ɠ�x�b�DhD>��UY�N��%E]�%�״,s�� Sy�nH�q�{|�����0x�S7��8�j5a�Jr��� ����@HJ�+5s���U�*H�ң��z(�.�?4�AM�R=?F�%V��n
���*I�[g�A�ާɡ)�����߁
0�G)����R�[��.���!�7�X�\=����Y���a�f�ֶd�T;m�"3�HIՒ����&b�����	a��T�МX��lv�'���M�n�:+ΰ�DW����+�;������/��>�[��0"@(C�����_����c���>��qf�v�g���OG��M+)&��j�Yz����}�u9�<U�H��\�+�i���S1��fa0��T3>ْ x�+!4m�a��cj�A[7�P ���ג���TEV7�$�cSi�
��*vR�
Fa�I.y�O�=S��/�6�b=kH0��U�L�2?��%>w9ׯ��W��l��g��9��.k���AV�j�}��=~���
2�g�6���z��'�KlA�ܱ�܅{i��},��4�S`�#������A!����c�0i����`��}Sa�?K,D�h���Y�K���aY�����AB��F�]+T�^�`zPݶ���ԌPN�0��X��N �)P��To+�7�3hP�!�_8G���?g�>߫���u��f��
IX�gI�����l{�';,1:v�'R�>e����eE���/����@�!i�IG��g5B��t��w��,� 6C�Q�y5E#-%��Y�BD_&�n_�A=��$׳� [Vs�9G��7yvm@�JL�I��#���7��
.ї39\� ���J-7τE�-��ؙ'����_�';� \𽩑�w��jg+P�J������t�0��\�z�]Wcu��Ub5� (� $e�j3ݲ��З��0�I��\w���I4������}��#kSX����R���V�hf�8ph�"��4�{p9�����YY�+�	r���g�y�.�9���O�&�l�8ü|�_ieϜka`�EP� 	��1:`��� ��\=ͬ�}(�z2����U~�#�{+���������^Z�'\t:8�^��g^���Z8�"�sd�]���V��	g.s������W��f[���hf���<l�9�����}�LwN��o��΅C��cc&Ɯ��ot���?W�y�e�<����1�v���z�*����qe�q�A:���(��}1	r#�_L�=�z۴�&���Y�s�ŧ�f;t0D���n4�%8�p?��z|ߕ��3�b�Z���1C�Iv��̼e�ߧ�q��B�|��׎����f���1��1s9��R��ۢ��6f�Cb.m�����%H1o|���܈�g�&I��_2�Z����˽���?�)�!      �   #  x��WMo�8=+���m��%��jG������č�����!eű�b,��!��y�3oސ,)�gɷ:��Q��	�U�p���#�?~��}Ҵ뗖�}&/��]�Ij��_/W/��)��JC&�2�H������x*�_T�&vtW��[}�?���C57�(<:GT*S�T����d~!I�������Nj�Gn�1IJ�p;�V%U�r���'��w���7sR�m]�&�M]�.� 5 9��@ˍ�_�V]ܝ=���99�4�����@R`RPIy�nW����b���a�&��[wOn�,|�(�r�AJ�ΙI���Dp�eD(&1S�]���1zr���m6k���PB��%O��V%P �ƥ1(�������~�����I,���}�[��xJ�Ya1�wF��R� S�D�HH���կ������V�˭�/���Ȓ;[�d>��cM@S=H��B��U�aBF@e��^�㮜���z=�>�l��o�ݶׇ�\�q���*��3��%��ݤk.	~.8؜1(&��3�0�*k0�6�74.���J|��L������k}����F�y|�~�c�xS���Xm\���?A�םE�!��Ll��i1����J_B�/۾O)���ï���f1D�hFi+6�h�q����hTx�۸gt�^�bO���,Tjb����Н�Zq	R\=w?w��=��^熁X*��ᇹeTȹT�������TiR7�ގl_j��{��L�L��ł��`9[�3C5�=Hѝ��+��-���߹��9� ����΃��mL&3)9�&��x��Ӈf�̫��Fh�r�h���3�1T5\��s0A�����R}��>R�*��,�\�� ���Je��2��ǋ�v��}`C0�S�f�����e�;��NR�bJ׺�;ʯW_Y�om�x��	8h����0�aߨ;��K-���M�G�����@,��@s������\�ʶ��v鶯�~�!w-ރ���\di�4ȃ�AwT�Z��P�����r�/�����4��	<�,g2�8���=�L�8T��c��n&O���m��eg����byt���q���&�2�A�B�đ�{�yy��q�{?��/h1���|k�p���3^Fe1��1\��GN���S_�����;3��5�j�}*��s��d<�=�����V0�G�a��,��<Xh�Y��Hdqu�/�Ø���@U�*d4��ն7 nD��~�P-�jP�NʄK�%3��KB6|m�w�i���z:��Jw�A��қ��   �0      �      x��[ko�Ȓ�������~���#M�X~@��	p�m)��JN6���j�R������@����:u�a)��'#i��їWҚ�eF$��|[������yU����uEߔg��5�
��Jɫ̥������̒�{[ޅ���[~���7�?��Ln�agT�'�τ2Bm��i��9�yh^7M�{m�C�W�\	�j�#h�mQ�	 7�ݸ ��{2�i��ɶ���Y�����̦���'0�#�+e��H}fb��1��Fպ�un�VU�&�^Z!���K_��'mx��PS�EO3����u9�a��r<��ؼ����l6ݞ�W@�L*2�3�����8i���>�ֿ�`���@v��aN��Q�s�������fn�U��v�j6�5»�D�1b=Nǈ��sػM���a��!2�
���q�V��RWZ��R�bP��l�*F�Ÿ7`$m��&�bx����n!�o��{���o���}:5>� � 	�}e�/�,:�Ű�!�D48�u�j���<�q�r�T�(�`��'������%�3>4o�U���L���x"�ʳT��i��Lp�bX��0,�*���%��nAY=7��j)�%�����e�1�h�rP>t~��t;׽���2g�,KVߦ�Oo��z�Mq����U�S�b^��dL~���NF�O����Kv��<>7�R{	*}�J�B_3�8F�u�M�j�3p;�j[o�*�3 ��T�����)�o���I�*F��G��"�y���*����~�׵ �_�i��J}�Q5���q]���h�����
Ċ�����#�[U���)���:+c��9HEL��=�f{����P&���[�4�:��l]m���g/�;�N�Uԁ��3^q�/q̟&��rk��o�­6t�u��b���\�y�09f���6��l��\$�h�7.�&n�p[����^�Ӥ��y�a.r�{���Q��Cf?��7�î7�K��W"��Z�L���������n�)�(���C�� �:&7ӏgڃM常�m�b<,W����/7L�W>w1,f��Q�nzW|`��r'�N��u���7��9iE/b�n�n<�M��{(n:]J�!e�܀	��٦Z8�@�R\\�IPEA�p<N��V�j���d����d:�_�3i+�y� \L�&���BQu���>���aߗ�zi�pʜv @u�T�(S�g�A|o)a�:N
�]�̫��o�sg� CWI����a���2�;��C1��L��Jmm�\�An�j1'YP]��X�+�R��b�2�x��A��A�H�	�:�'����yY�� Vy��H!�U?�	�3��!"�T���������#0��s�V2�x朏�z�� x���
9��c�8}[V��W�/�I�8f)�ꐞ��3�	�R��&��<�Є�T1�|�BI9(�+�NT/� �uR=W�]ռ-k��㻬��z�=���D�E˝��`F� y���	�>Ήd;���z�G*D*T"�#��y��F-B��ծ\@�U)Ro�Hh���	h�L�Q��k/��$w��s��&�9TіTV�l�_�g�T0�l+x��xe����\T��S9��aZ�����d�Yk�=��S�-}�Eڼ���i�m��&]�ELs�s�'N���k���>�IT�j�}}���l�8]�-�Z�T��+f��#BDN�(�X\}�<��aKR������Wp������ :�cg,��9TBA���N�dZ/����m�����[5}=��V�4�����d/������2ɢy�����A%K�J����7pW�I�=&�q*\(�&?m�2���R},*�5��>� X
ख़�Ő����A@��)���g���N��Y�TT�dY��9j���(��T��=�k.ޫ>C�D���˼3�g���Ъ��o N��v��de��K�~�;iO�D
��09�e������H���2_�,7�dZ�N��*�VϿAB��:���	V�?�X9��\����U��C�VR�Ө�b�3����j:e t?��J��b%D����gn���k�ċ�|���]7�9 ��g��9}D&�"̎���kr�J�-9�swx����U�yc��CEf�_����(�^�DnVR�'U�Aξ)�a����S�K�e�V
/�W^}AXp��N�Tǡ�Ae��z�Ew2�@V��3>8&Yo��7�c�ޝ����P(��d7��ƣ��H��2�7x� .u�ռ�f�t� 7'*O]T�Hvw���v4��v���#�i2���t��`q�Z�6�j�B����8�i�>n9$sfSe5ɞ,��L,��PB���mz�<�J��D9Br��}>�u��2y�~����f�x��|��+�Q�a֐�#�J���ӛf�<�x-�兎��
��6:ǫk
��ɿ�U����)�d�r�i����\T���&��\z�����R$�5<�/|ݿ��	���E�?�%�iSh�n"��M	!r��A����H7���� e���ռ	P��:�Z�N�L�?n���ZS�A:x�]��gW�Omtzb�"���fr��`%uM��Ș�7�"TKj���@D@�fQ��. 2%��o��ԙ˵I��v�����]I��hv��zɘ���vY8Ј��V�7f�;���[Qt��6�ֳ}ƙ{p�"��;��ND4
��F��Q�'��e�>��l_�~,ǭ��+z�QcU�HZ���4�����y��!m�ծ���.�F��]9�����{��r0�|fs2Y�ͪZ6��l�*�D�"�r�/�y,,]��P�>����ޓdg�A:�ɦ�QBk>Ϛ]���=k�L�.N٦"��w���P;�8�
��r�!i�$#�H��6��b��&:8(T����xX����*�+I�^���6�3��H͡�G.P��A0܍��Hj����6F�������] ���ng����*��C8_�-/6��/�B�t�����F�
.Q�*��7���u'm��c����;m^_.3�B�{(�Xu��BSa49������f����^��
BF񓧹�6r7���1�m	R84��@��v�5����̀�Dm���BKa4'].ԛ��5�n��{��yM�&��n
}�Ə�Ɇ�I�nFuQSe:�R�Y�pE�R4��Q������Dm�!VT�k�5����3�� ���} ��[7}ZL�:ޏ�F�aDn��}�ؼ��ċ?:t��G/9U,z}`��e��
^�`J>��)�Pr���"j����t�C���⚇=���A�X�j@(Hv�lwU�Y�m������<2O
�OE���B/�K~�7�o�SC�61BGYKy�@����s1��B�b4��C/p�I����S*؂�Q$/g����5�	2�VE�I�j�"��a�X����[$��I׻�Sk,
���ЪKN���r;U��~���!D�5H�ɴG)C�Ӫ�v �m��}�.a��nh�W�Tb0:�1�
�z��g^�=3�5"�xZ�N!�Oc��~�N�Q��S����)��=n�D-����i����@��S3 ��G��m�nٹ��{��:�;e�g��V�d�3'oշoA�h=��]l���-5��A�U��f�#��h�}P���4�l�݊?&�A�����s +�H����Y�PL�����wj���L*�N*,�Nz�m��E�膝I�Fq7�T�j���Ax�v�R��%۾�Q�]�j\�S3��m_Z��E&�P@C�|���`~����D`,�o�o�pV���r��	�E����|��iw�@\��9�r��x�iU�k.@��P*E8F�S���6�~\h���VUȿϸ�ɧ�l���{��A�.����V��d2�!�7�%������O�=g���h�c����<-`�͊�N���n^�N������L��1�V?N���#5)�<�T���:��.�Tt�8���0(�w}ԇ�uF����U�szF��/V�Yt9Q��0ݺ��� �]�Z缠%����\*�_3�= �  c$%���xS`0��7�ei�qH�ߖ˰�l���� m�>qQq'Lh�'��p��ߐN�����l����R��5��U`-$i q�[締�I�CH:��~���k��wȒ�����|W����W�,��}�8�g��6�5G�:����˝��a�&�V�]�k���B�p�YBq�m]�Y�RX-��̘ٟ�3D������c��>�Q	jK��nwWCّ�&r	�E�c5�3:Ѯ��O���ʭ�9pè�%&�����O�/�V@2Na�'��8\��/����u�kj�¹ ���eKH������s��� 	�?��It�su\�`�h�{�ΏW��e���;VDc:��G�k�{A����޽sP$�p��V�����,l�_�O��rN#;�����dR]�ᇃ�i�w�7p��v�Ҫ�6�7͌v����"<�{�"�h�]�)�0���90��JЦףVJ�3�N��vL��N�O<=0�сT���/�ۤ�G��#���w�W1/��=/�����0^Ɔ4y]��6�jq7��fZm�j��,�!)��O��l�eNd���G1�E����7��r�v~���1��:�i���bfPJ��z��ן�����<��mI�T���N8�7LZ�p]Pr���C�o�ZC˰��ߐ`�=u�+�37�Z�SR�ک7*�Z�@����d���H9�s�2����W��/��/�q      �   "  x�m�Kn$9D��)j߰ ��>��#4z7�?�ew%�"����~������+�W]_4_4.�K�����^R?����n��E��y�(:捩��7%|�*��������a=�DK�	���4�M͓j|�Z��㯄�Kp.��P��V�^�	�Wű;,X��Q��K��S�D�R�8,�b��B�a���g�gb�����1�X[euwQNT�j�vo9K���\5�%a7ĉʗtx�����V��Ɖ���%.�6�O��$�j�j/�_A�|c��zI���"g���A�>�ES�g!�XO1����<�	�/��r�J1�R����n��M[&ȸ*�e�5)fW6J�e?:�$�ۦ�Xd&� i#Tҍ�D�����F��������7wO�'��ƈFO���&�V�GugS91&���Im	�wV-��ꉡN"���V���fI��t<1�
A�q��`hy������; ��Ӭ�;��3�Ӊq���9��4�GG���zX�U�Ao	6���?�&�2��e^�O�M\b�B	���yl&X�����ƫ�ͣ&ش`kބA'F�A)r�>1�7���K�8L ������6�5˽*.(����t��N����qM�gK\�����0��(�g��� b	þ����T�����	(͌��<��X{��jU}���$fɆ��c�F3`��)���l�`�b\�49�-`( {��p��`kg�w~���\���_5���B��'�
�.Ԫ�tI���w��N�z�˘�'�6���دD7�P�E�MG��=�����]졮O�u�ۭ��c��z�۷W�	�g�J'��@		�aC7���� T���6���XuJհ�N�u����������=F�-�V�s���0��a�F����*#,�T�;0����˞�_z�no��o�Drr���]�%\����'�������a&a���6�p�b~��`�>���vwB��>?���,�j}ܗ?h�g���a����M���]�l�X^>���`FN�\�0�5h����[���4���ɡ3R+5�ܶl���[	f	�����m�ts�g��	��,�~sr�+�Y�s���ͺ�����:zr�|��=���Y�N�oYB5�F���,q�o	Uk��M��enzN�ζ~��NΪ=�������
G��m�[��m�p�ќ�	�v8LN��2tg\K�eE�����-0r}OK��?���C�����Z��/�7����{�7G���OĦ"~!�	gk���!=�ͩ�{l�Tj�8��-	vNNYna�
����﷎�:����읋��?d�q���CI���z|`�lC���<9����+��Zt�][�lYG�ņ�a���I��a��΋�{�`�jAO_�ɖdzs|�߆1 �`�5��abB��|�n	?�n	��\J�~(|s������ݡ�v0��.0w�$��x���tГC���أ�N8{��
�eH��� �J���6�7�fI��F����͡`�=�6azrjK��Л���lo��+�����l��      �   �  x�Օ�o�0ǟ�_�=lB��N��T����O}��V�h<9�j������B)�hU4-�.��q����R����.J�b��p��?}~���{�7n�\l�/��š�u���9���l�C��R&Wn��jeQ	H�-�M$+ʲS��lp9\͕y2.�ՙ ��\Z�ȭU=���@�~�%�*�҈,W`QƂJ��%yg,:�R�+�ti�ۈ�ҙm�
c�9���"R�#�SDxDǇ����~�������B]����MG��Or�&���v�o�V��U������|��]���t����q�5/�b���,zW�6�z�� <��?�$Hj쫟��8�o���}�'F�\2�m)#h`�l��7�
�
۵]zW$�N��s�~dZP?G��5Ui�~����q�&Ф��x�0��\��E��棟N����K5�Q�7#�7�+
>�BG#I����$Q)��2+Q#�e)Ƶh�Z����[      �      x��}ms⸶�g�_�O���=�W�%[Χ��	o�jW�r��IH
������Z������:u�z��r�i�k-5�δ�S��r���_ʍ[��w��ޤ5p�$�K;��IF�<q��^V���}'ۼ�mV���f�\�9�64::Q䇔�����}���o/���{|}qa�_$�c.%WB^qߣ��"�|��0��K�N:���I��B�� +�N'��4���)����p?d��6��[����b�=��^xD�cD�F9���8n��U���;�l�2���)��Fg��FaF�ܩ!!����OH~�GT0�������$O;W��4L�y⎯�as�?������=�t�ݦ|vo^��y��ؕ����q���|�?y�����գ�Zט�p)��(�hȎ0뽕�P�T�F�j�9�ʅ7o�@��sI��i����O�����.�^M�3G2D0:�`�M��^���,*�Dx����@J!��f|��j:q�[u�F#5��I>I -w��&�E�Bc���q`�� x���ۼ��(9+D�҃/u�iX��u��e���@8`�r5I�x	�x�r����y�ߋ����[���=��g�5_�8�N�64:�j���!u�m�ݾ>�`߷�ٌ��,n��P�[�b��������I���$=�8�4:cZ��"��8/o���,�?�<����X{�^H���A��!��ʿ ۝��T�:�$≓���zQ3^C���"�A������s�y^mʗ�k��x�$���,p��*zi%!NzI�p����a�~Q n1ͲA��
�$�I��[�x4�
eĨ���.Kx�	p>,��MI#yn[a���C�$t�C�W����u���#�U��,#4$�_CD|2���i9�Oo�z������x�%%ZO���Z@*�k�K#�n�>'��^C���^��Q�g���F��0
�q��=-0���Sw ��f�MJ﷿Q|����:����#�[���љ�VI%�}���W�_��V��|u �ȁ�� 5�؅��>�o^!�N�#�,^��Q��G�����M��4:�5^�%��|���z����+���G�|}�u�=��ԡf@���荚�6�ub��й�Atq���Y�$��X�&+�ZF�����}�\��K`�hC��yx~U��!j��FF5�/ꭺw8�vp2OK}�e7�PnEYQ`g"#�|/ @��֚��}
�<B��2Ւc��BK��y���Y���(�{�����x5��R'b�CF�ٕ�%���c�W\�:�01m�ّ%��4ľ�9F5*�]��K7nK�	�tk���~����1�.5]�P,���z������ȸ�W��z�%�L{	0Ӹ����j35�*�;�o�!Ƹ0�`ѵe�j��~�`L|��[�<<�]>�x���V=�nr���,G�v{j8B[��O=��ϊ���9��u�,_��k��/6䄲���`�R�D_��G��1�sηA/�Bz�8^`����� s���퍁'�0�_��O�/�K0S�O�ḷ�y"`�ګ���X�8�Ma䪍������l�����6��w�1x]}�]��1��t���.��&%��,�1�,���~���`�(�y�n�j��\���ب1m�`��]mw�zw�FhۅO����W-����/���ڔ�X,֫׍[<�� ��߬@ݹw�o?ʵ�_��(�=s�d�"�tRY@����[x��`�O��qa����S������o��ʭ/��y����{/�޷�l����`���O�]`0�` ����9-�1#��V�B)oR\�:�M!$gC����M��~"�� �цFg'"��A9k����^��� ��z��(�$V|��Ī;��7ԅ����[�/ϋ���f�N6�\G��0�>����)��?�-r���������q��0������k#c�0�bL|�1��|:I�V �d}	.�-����,ق@��y�-����Y��^/�-����X�|7�����R��t�� ��v��m>��H��љp@H�p#���y��l��%|f[�U�Y��E/�I�1�PCP��4�@d�kb���8o�^�;�B�m�'Zi3_��0�K6�n������~��Ͼ
�w(A�������u�{z���"�g�_�kM��r��R�}���/PdDN���*���y&7��cEƵ����J /K��u�w�i�i!�"�!���}}/w�qF�FQK�jWF�����5<`�O��) �0I���d��"ңm��#/�`5 ѡR)����yu!N�?��K4���q�u��;���'*�_Cd�� ����)�߿��u�D��<|��%��X�ݾQ�
��a�ڝ]g��|j	��Mu�DQ �>1`�s�a�(�x���
-�0B�F�b����5���t<�Й�!���C��Z�lr��oە/�\� hg�5�?�c��3z�q��}�L�nx�{�]�[ȋ��������PL	'$��@�.�/K�;�_�a����M�v�`�4�:��S��H:��l߿��mNI�5B�3��g^�������"�����N�eE(����lhti'?">�IG��0������o�*x�F��cB��&Z��U4�U��.��O|���9 uݬ�9}m���d�-�J�=W��?��Cd?��W�4)@2�U� ���?�e��[zZ�3q&2܋]<�` ~����9����wI���I-�׏��]hk_tc�WO��5T�n��!��#z�*wԠ�e�qbS�5����M�>4�����쁁��֊kc���`���v���v�E�q��mM�#j�$�?4���g; �hЎ叡�A�^���Z-��u1��Ӿ�߰N��|ܻ�b�?�?5�������p^6&Oj;��I��o�?�IØO���S0�� u��B\s�'wIf C�k�F�ِ  K(���,֌�a��yz)�+BPw�C���Z�@[j51����������6S�rb��64��l\J�F��	K?�o�������x����6�0��"����:�� zr$��x#���~�<��kz<h�	�q^~�_�_@��l�Y��\0L�8'h����S�����;fB�c�Q�މ�eAK!GC������K<�x�����U����[GY�6Q�%u�<�i������萁z�h���K��Q�Jz�Aԙ�[5Ч��]��g
��AQW�����e���tm�`��(`"�3��c��^����6�0G���R;��>S��� U�a���v����*�af��){�Qm}`���~��C�����+X��#QKei{�'0���S���W�u��T�z!hE�6T0~�J��|�?�Դ�v=x����
Ɂ�vz�R�Y��I��~���T`%z��{#�6X0^����a4x)���_L#,F�qXۮ�]���d?�������JO�4A�M�����G	(�Sh�A[4/��Z���ӿ����Z��P[�P\ ����R���	l x=?h�6aap�jUV�'��%���}��Ք���
8<r�2���
T��5�űj���>~<�T�R���	,�	=֮Ԧ+�.\����K�V��/�Ŵ��ZZVj�>���F��О���:P�=t��n^��m���x�i���Vj�%�-�w���X�� x9_�w[�{ku�P�k]���v���x�'�I�ިQ�$Ot^�3�����54���}A���+���r��s�����z|(���QWv}�j�a
Ȕc���&��_���Yh9�lh��\�0���o�^��~�V�Z!Ģ8O�\B������}��Hݫ���F���<�F~�|[iM3�]�'������g/%��l�PMj{����1WC��j{����Eڭj��Qq����%E���W�H���
nʗ��b]�2��z�`�J4�\��P[(U�Ka��u&����2K�pC�Y�    0��/��d�Ն�'�A�ٮ��&��p��BX�p���iVpJ�-eV�pg݈�2$��K��Bw@,"[ҴmH'N�9��ʝ[��%�G���n�	Dh͖�4:+tV�_�ւЮ�lG��H�'�ck#���1�n?��&�?��?����ZRN��FX�($ ����Eǂik�#�/ݩ�Ã���qq�u���"��ξ8!�g$"���V+��/��/�v�.�tZ�&�*N_�z��8�g#!8�IdM�����b��Y=��{Z�Nt.�!�'[�60v�$S}��9fT�7fq��}i;8jh����!w��[�$#�fs���	lD�[y�H������(r{������ͳ�-������N��ș/���԰AaK�9�v �nr�+,��K�����,'L0��lht������_����ΩT��ڂz�e�"��a��1����hZ��<��7u��3��[
���lK!�4��X���-��
����;��5��Ar��t��Uk��>���Q5�T��]�-i�/��96�_����߄��@�[���\>-1�_�;�7(��ǂ��� F��ݪA�Nz`D=�6b��4���z�M �%�k���y(s��v��ϫ���H�B"'��"�q9��c��m�$)%��9P��L:d#���N�P>�ߟ��^�|����Vc�z��f>��Nc��aƎ_��q
��jhtv]�� �JG�<���Xp:8<���&���&7Y����i�x!��c�Q!.��{�GH�#���C�`#ը�=�j_�$���:����Dغ���J�@b��;s�cp�v�.���>�S$��Ķ�TG�)J�����4:�+�	�O�nV ��a���壭<��d��E'IqJL�!L���^=��"q���ť��t�1��4�eĨ���Z>���5T��S/jw"Ӂ��i��v�J�n2%Y@,��m�`�wL���:GAt��|x-X���A:�Ѣ	�U�^�F��ȶ�5mPL��t/�$ tAF�^,!�*�d�`�v��4���Y��v���t	�[�O�Ҁ�0��'�L3�=Է�� ��=}O��8":�y�{�n&$�BNBS��m���jw��5�~�{�#��O�N�(w`��x��0��wt��E]��6[�ek�SA++�� }�ڼ�ϛ���e�l��4ഷ���@�o�2��C�n>�N�WI~� 
�dyDydqSZc�(�70�/�͟M/�y��͠}[N 0�I��t�An�������	q��N����/�N��?��-�NC��{Sä`���=�)�=-��2]�	qH�10�#5R��һ�A����?�� ��3k�yM��{�	�w�\?�R>��WZ��
���ըG�10aMLZ- f��_��.اH�|44���c����tX�J�iՆVƸhQ��Q���KN�x�t*�wY��naĆ�/a[C��Vt��K�R�����n*k;)U�2LU�o�J7��Nlo�쏬�d��j���DI!�C����v���-#����h�10�&�h�ksuӛjE]���qv0bk&ih:�7Аp��_�����kl�(��X�Q�V��0b��	ve�Ax�φ�'�����b3��AVa.H��I�/��iz�ȼV��ړa*�9.�aB��Q����3vb�| �O�5��Ɔ�O9�����-5'Z}�)A<�*��Uk2L ��,����Mg�b��<��V�n�G��>a+غ�0xUy2�r]��Bj�q��O���{)D:�q��ihtv�� �����n�Z�����RZS�ĞI�v�L�2N��a�D�x�C~���T|=�V����	t��>�GЩ�݇��n���CQF�b�eV�p�x�ti�6�X�h�S�&T�����\g��%�e�k��C�=�~o&�5#k�A��
�̛�Y�	tu�����#�����t&�� Ѵ���	�QN�����ܼ=�oW���d�B�����=6�'�d�o:z*N����E�7îI,�����k���D��!`���XG���������j�����b:P:�� �߽k��:�@Hf�54�F\�PD�5l�.?,�����.�i 䤥��c=����l�^�t��E�7����ZdPF���okcR�-=5�˟��`p�]\_w:DA{q����ie�"��w�\ø��b��Q��v壭M��̱e^��1?,:)��<(��1]���u���1�>�k��<�C����No���/YA���aMc3��7� �v@l�?/7�z��X�C�U���ph�`����qf�c:p��un�^746SN��T9/7���[������n���X��vR��)�g�I���E�q�[�ʺ,��v�Z����`8À:\?���g+�h_.<���L�2NՍ`�v"O�P�s=����'��K�t��y+���fc��Qe��뗷l��L��5����1��<�v�O^��i�sp�l~PM�k���a�(�o�c�*�E�a��/Z���$��+���z�w��� �0f8�2N��u�i����I�S���ސ`MP�V/m3��Ǟu=T}cK���6�(l�KwgY&%��o��1�>|D4/���f��	�i���/�1_�iux,lYr�Q��43�RU��<��S�d����{Y��@X<��Fg��D�GTPo){+��뙔A)��o�%L_7N ͝F�`�0{��Q�I6[[���1�l �8s��b����{��قp��l�������HS��[��ٵ#2��A���;��核OlRM��)!}�
�i��� >�|ϗ�+�i��x��w��]����e~�nh(��٣�1�D1?�����>����E�"�ߪ���^�͎��_��w7���$�Ŵ5M/"�$P� Ee	A�7��f!mI�
/�y���klg���%3ͭPa��~�|C�OC�ᦾ�/��^~��]W #��׎ M�;N�V�uϤ�iU ~[v�K�e�M�A���3!���b�\!�,:,ޣiFR^]����NGGuex#^�7��� �k����@�pt��������<�S�e���S7���<���È�s�é�݆Y���@�H �G�~\�?�'p&��o�1�,(<Ҏx�1A�z�R;H��࡟+ά��]ٶ5����P�ݭ=�.��Wt����_����	�<�i[����k���ui'��g~B�%H��I�e�-���3�d�lX��?l"3Nɿ�NͶg��=��@��i�|�E���4ذu�=�fL�@�ge�5�U���.���a����Z�4��ĆY)#���}��Sۢ����4;(���@4W�T[��z�Bz��/a��zِF�Z�~Cӝ�xk�#�@�9����l�e�5G� 0���L;=N�4yW}M��-5�d�T���kZ�,�T
d �Tn���f�'�����[*�4��/���є��]'���\pJ���t2,�|���ز����ڪ�2���>���/+��pP���'��+�{t=����Vӥ�ӽa8̻w�,#Q����oN) ��1]B����R�[�-kж����Q��=�տw��B���a'���X��4K���$�����ix^�������L�;5]��.?�e�̢;�.�-�]C�Ѥ�ů>8r�n�W�3�n����:9�5��8jr�e�UP�?���ǷY��mφ�@:���~���a�����R���6�8��t{�ރ��c����/Ỷ�l%5M���X��2_��Zl�)!'�\�T��8�[;n�q�x���ě�|�V�q�)�[
k��s��z��]��ӏ@Fx��6Hc^`*�10��&S�c�F�=G;Y?�����=�d,�<��ƈ�ܓ�@Ӵ�����E�$F���<C"-QGC�����#�Y�x����x��޺���ѓ<.>�v��f}<���
���9 ���N��6��X�KK��A�E'�Ѵ��T�G���U'f1wO+m� �  ���ApΥU����Z�+�۬g�	L�t���U�xF�5�E��4Ui���2�g���ݲ��g��]��~�ˌ��)Wqz�e�O�����B��@��i]�[jھk��Ng���+����$�r]5�8�k.T>�4��M��,�6&q)xI�I��;c�<����^����2t:��om?n�����N����I ��b\�w���'*5z���?����nl��]�������k]�&!����ǧڏ��k�G��?�i�Ʃ}{��wy���nA
9MY�;z$���ĵ7�G�t2�ݛBMW7N�i������&`zZ�����2�W�M�ŋ"l_Eo�)Lx����G�궗��Ͼ�wN#~�H��1���;v��:')N�q��g"ss�s��?�'�����2��ɺ� h/�j��E�U��i.�۰��XM��b�M��*_���Peq@ht��hL�M`����{��2��j�=P���k�L�4N�2�VQ�ONƱ�Ȇ�`�2������Qط�Y>�@�wz�K�t�<�}`ڥqʀY���E�5��c�S���C#���6�⍧`Uۧ�a��'�N_ݪAS0:�Se�e���Z��rdc�xm�AO9�D?��1�������A�%.      �      x��\[s��r~��
<&��p��P�	� �;��c{m��%�֪��Owx{�=��T�֢,�7��JM�V%�դx���0�b���������$��(������E�Lā�s��Q�,����U4��mQ���o2!�bL��|}�x���Ӡx
�xy~�<�|���������Ӡ���������ϫ����FpH$.@_�/�>���$FDBM��z�"hj����.�9AH�h���a&A���O������/���I)�DH1�%�;�o�Ζ� Ǥp��0��ф���ē���y����l���Uٵm����8BrX���
��y��ղ���}�����=��+�Uʡǈn�_��_��s���4�>^���/Ϗ�����>�t,h���k��!2�Hs�[C$'��z��������/��oAeϿ���
[�Aoܴd�S�g���da�%vF��؋ç��Q)@v�3n�iD(��(_?�����0��IƙM*��jD���&1��_������7���0������K[��kk�sc���T+��$# h��ۮZZ��U,&X�����F�0� ��}`7H�c��������>F�	P)�u�S�H�d�P;������b�BD�P�z�D-q�ǐ�d�*wrq��b � s&�s8)�F,F���3s���b�)�7M]��M����.��v]Q�a�ޭ�h��k�8�Eb9z�����AUe:��|_�
�΄ _l��w{��MѶv�s��m�i ���iˠ?5�Z�+�1�oRb���u���z~��8��e/���ե�*�s0!��QdD7���Wr<�rվ�ͭ�d.ehT̉&z��_��&UQ�y��3,��%#f���f�Ŷ�SH�h�B#r���ĉ_2F{��b��Ph.ʈ)�tt�pq��T���h�`3"�8]�G%$�8��F�LT�D#��&��E�o�G��$bD.x6`0�n$�l�TŬd��D��F�X��a�7#�KF��wu"3Ʌq""�KF��z4Xj���Y�duɈՉlҬ�2�c�j�yZ��%#V���U͙�����)��O�M�a�"u�;���W(|<�{��4��;��.[��
�����M�@�s%14���:�K�b�Ԥ
-x�{P���*�q�Q�p���g���L����UQF�Xb�Q���n�z��Qc���;1D��P�	fM�O�!#=��$'��0�{|��	�,0Iv�hHw�isx�d�O��;�<�yx� �~9�~ f�^����p�lHG2�*�*uؓg�$
Ws��q�)��+���$�ނ
�d*��-:���=�K��,:M��Z5�����ף�z3v=ļB���M�3`װ�f���G&)Gn��X��~_�����&���ȋ%���Z��Y��~�
\���8�1q�� ܞ��[󉉛�_�A+���>�3��F�vޛx����f�Pq�;N�+8E�-��c {8~Δcb
�����&2��c�)�� ��Qf���*��v��.��Ņ/3\��H�}�9`2��Y75d�>�4�q���M�"��tv�������
��u�y���A���ORA5�Z"�'�T9W1�ZV������R�B�BBB&/�&Q���d�r��R���sϒ�@��N@�����<<
�
c�.��$]���᫊���S�4�Q�Y�рʎ��)�;�Q-:�2���DQ,k��M+�_PʵX-���ݕ��.�Z�&h����6��>xo��*�uUZ���zi��S�a]wmN����5���v��KIv_v	+8#8jP.���]H8�`�jm�Wo6�}^T��YIH��Ƣ��)3�B.��z�����K�q �!�b��"����D�(	�����U:"�T�
���圡(be��=�'�����i+6"Wd�:7��M^�����d�:E:�Gu�*/vEYl�k6�c#��.�)n��AȻ�MUD*�'�tw�Xu#��z�[��������(�"��pз���ʄ�L���8��L�d�z�o��X�cD2x
��#"�����w�/�@�� �h�]+KL�\a��"�����
D�-���#����UŦ� <*ڼq�*ᵠ�ź�B&�gB�ı	�_y͌���/�{0�-ڢ�,���p���yu���@?� �AԖi$�rn,hWp|@�����B$~�9��Fs��Ĕ�5SV�.GM�5�����f�\|> �����0���(� Q�!�d�i2P�\��4K�_�������q���B�>����9�Wl�m0x���wo��
� >H�1����S��\|�; ���� 
یQ��B�DY�2�HȤw��MO����Nc:��ʢ\UK���ޯ�{Hh��_��`�)���6�wt+�0Mީ��s�@ditҵ=��Ro�X��
�v�4·:�e�0�k�x*�c����5@y�/6�u�*Sc��UP�?���S���w�A��1˼�x*�c� a�mڢZ�>��?<_Hb��x ��D�;��!����JC��)D�ղ���nqx�rx�:X�a
� ��|2B\z�Xq��N%Ul���%A�	Iܕ�p�����TP}.�kle_H�l�ð*���b�RL�b$.~c��8B\Bs ʐ��
�$B��Ɗ!~^�ňe�Ŀq�f�M,a�hԷ�����(�/����\1��#��4�K͙��t|�83�j$ �߉�o!�M=z�j��㜍B��(blUKߌ�p�#"�(��"��A`{g�e���p9$��gp4	@�}�L�?���h���u���$ U6ѐ��ѥRl�N�)�k[W^�s�6w��]1>�%�]�,�?}~E=<����10���##=g|��2Z���U���O�	�۸�W�Q��\�/�,1�DԹm��<�p�Iȧ��я���8[_wMl�Mo Q�����oxg?������ΑHℼ�]��*1BU��x�^���Y�߸#1J>���l0I���9���*�(��aE��OH�<�#1B*=�mYR� ����l�xH��ru�o�ь�$�n�"C��n���pԡ��;�|'_;��4�V,i�|r�Ĝ��1B/f������8[zB�<p8���Ui�;b<���J�=���6����1��-��P[v���u�`�{u��"����[�]�QJ�ע]G��aK�B;�#�����E��/,R$`�,�#�A������Glh"#�6� &E���{{��B�$G��R�0�W=������en��b����ǅ�窀���JF��&�R��,���A��V�3�+�N���=Ō�Ƶ��`���{��̎����A���C!�N�y)*� �~�;(�`�1�X�� nDCV��D��T@�:�x��2Ġ[5X�q�����t��8��Z` ���2��{�PԳ}Wڶ ���PX�߉c�A��>}y}������%%/rl6W��x��\
h2��c��㌁�K[��:�w�cq��>*$ <��A_n}x���;Є��]Ǆ)ג�k[=��$;���0�C�~�b�k;�DpQ[o-�1Swy�v����U��-1����t[|���4�.��U�mhx����hqI� .��p���*b��~ c�6;c�(ґ,�2�c�?�������=�k��-WXO�-��.vݝ����-�*�I�S���Am�rgp���r	�o�:ƾ4Y����bu�w��+:;�+�ȇ���X�:�̀��L���g�B�Տ�g����M�5˛U�ثV젮p�b�1�X~:����>���{��l�np�v�hf�o���}�w}߰g���$�`�*� ��m�� 7"m��K'"�
9e�p8��*E-���M�7=������
5���1hY>��?�1�I?�Gqt1�b\Mu��|��|
3���R�P�s��͙`N��U@*�U��{6YBcx�p�4X�cؠ5�� �5ֻ �:�� ;  =9j��o,=�S"�,��2��y&w$���wX��c~YE1�d�p3.b��X�{Y�(*�W��EW���f��A������<X�I�g�^��LA<�,�������%�$��;��1���LC|�z"�H�A��c%���ƚ�IL�,D���#�=�G�|d�=��k�1q8Z��܁c��CF��f��|R��!8s\4|@x!L��W=arr����ዞ�O_�yRO�d*8]w4%� t&��a]va��$�Y�k�jQC�s^����B8����S��%^xÅ����|@8��|�#�^�HOJ��bE��UFA���������a�B��$������1E��8�	Fϒ�{�(�/��&���l{�p�
!��X��^ ��G���`����Z?j����}Ρ�\���nU�������γ�����ybj|��*���T-�<����.�0�h��h&�u9,��Z>�w/��{�Y���SU�E0X���x�p��kAޮ��{�f�2,O&찧p��ͫ�#�>z�bۿ{d���:ftq���tT%2�{��Aa%4��5\��P��]j�=�Q�ҷp5]�92E#�)��I���k�8g���S>�N<tʀ�y6 �k2�����w���<�;#)z�9�C�����C�Id�5Kʆ?H��O�����e1dX��޾p�|ޕ4܃g{�7��T%����uO��1���8��nW�}aK�d*l���[��	�ݢ������U��B���!Tc,�@��}S�=�����r�
Ǫ�G���p��C��N� &���j�˖7��τ/"�W�"�����~���A�R�k���,��[e��ݷp��2c��;�HF��tp�Ǳ޶(��_���ӳ�P���Q$#� 3�w�-���P]�}K)ܛG1x�x��౟/�Z� S�>��˟3i�&/n0%�<�˨s32��m��*_5��U!H�;|K�c�kGm���!�i|{����+R�=��������ں�X��
��CF;�Ge'Q�{Z)����ޱ\�r��j���j���~�d��      �   R	  x��X�r�L���B`�4�W;6���^0_6[����`��)����
�-��gL��������Kg�Q���_�X����2�,��S�����"Hw����e�$��LJ��(�$�%�A���Q&"�t<L��[QY�c��n�y)����͛n�6�L��?�a1�M����h�!��+�M��i��S�F�Xߏtz;������6�i8
��ˋ`lVKS��e<�5���T@�g=��2"-����,��a\Mtz=���1B��\�\�4¨�)�����@�w�OvsD�>�w�m�g��z]��K���Ep����lna���S�^��2��(�(�R�(J�/ �{L� F�輀�1g��+=��b�(����1��O�7z���ٓ�vb�f���i0����Y�j��d��w[E���("#Ջx��}������1Υ�B*�OMJ|�x����n�'ȩ��^_�I_��Ax&��b�Yt���d��uaJ�H�I�["�:DG��2$t�emz��#e	%��=�|����w)k�\�=��y΂��l<�n��M���D�J7DJ
�3Po$E��X��+ӳ����9&#�P��3��>��h0�T�w�R�"���	R�bJ<o��n�l��ń�ZI�-�o���1vn�+�d��~��S}[�$N�d�5����P����	��څ�:�:|��?��:�u�A���u�*��H*���6=�_�8������/q�BD""����G.��@k��9$��tp�����,�X����AWZZ<�ͬ�&�͠<�B"�Oey.�J�G�h�Me���-�,򦳴�'��B�t7�I�45\e������|W��6<@�Mw�<���e��I�Q�� *%g�H7��	�܀��_b֖6��1��'ĻE�c�h���n��M	����X��¼�� �=ļ��D�I����a�l��p^��YP�i6}��}�L�8�f2���j���qfL�ȡsH���v�ߏ����k��1�W9~﬈� u-�X����PvR�ϓ����=�B���Lۂ��#�!T)􄾷�~�i��{����>/��ՅK4H���4��E�t,��Kb��"`�cI ��v�μ1:��/�XD$����#��n���ڊ:[ ��c�u��h��K�2�m��~�~���͇�
I�(V�b "E-�	��lmz�p@���kFbB%M�1S���yw�Φ%0�l���̝y�ox.�n=�	��Iz,
������,��S��	���N�T��\=��.��ݜ��o���?�3>lկws��=ɨThd�z-zQҤ�s��y:s�4��U���@H"p
��@C�������
��r,5�m����ݮp�o�za~�*z[���.,U۱��8�c��kB��8�վ|����Q��/:a?�v\���4$�#&.+�srB�cޫ�NL���}��6�N����VUL\Y��P�����`�"�va�Ꮂ6={�)J䐲ʫժ��ɮgOO��Ɇ�N?���#���|� ^���VK��"G����<��.[ϕ噙��!�п�'�n9�����ୌ����;��-��m�k�Áv����lʺ�D`Zu؛(Ȝ�,���J�8k�W�p�^;i���N����5����7���_��ȷ��K��P���n���=��U��ZL�-&c��B4���&�az;�5�TΡ��z�j�F-��#Mn��F�+�sb�c���2˶v6B6�E�fϭz­%�"T,[I$^|�{c$_���#�*�?���b�ף��xfC�Ĥ�	�̀-��8���*��tg	��qE͓��y�����fgi���t	�(G=�ۋ��;Yk��3a�Q4!�1�*e��;ݤ���ɍ���wc/��uioT8���� (f�C@҆Pr�כ��>��;�(s�:�;�����WhN̞Zw���b��۞�v`աkܖ�O�*--'�<f{�[?�OӲqQ
H�I'!���O5��Yk���f�-Ř+$�Xr�#$L:��g	�8!����[A�ǘh��>�t�M�o��d���N�N�����N�p5T���Mc��p��07S{we�/�o���j�)��!�i�/'Ȉ��.ڛ���*�˶�	�	9�eU�B���tSY��%�h-\@�ʤ�$��G)��~r��
���03�h�+��0N,����&/^���N�2�J/!\�PHё��ߜ~���8��� <�cd��<4z�xIN^��������|ٺ�lC�ߊo��R<��a��Wҽ[�W��M~��V2��3����B���j��A      �     x�5QKn� \�Syߥ"'���R��:i�1�3�`,XB/j��Ⱦr�ד0r\#�8����K#���u1�H扩O�1�y����uE[,Uy��>ΒY���A��;��@�i%�8��	q�U�F�馽��!E����)x�wd1��S�<��sed���F69Y�~!�^��uS�F޴� g�r��Ȫ�¯^�0�:���k(7(���e�ҵ�����ݱ�^F�S�%,�!�D�HZH�ƫ��kE�o�M��N�A���?����~ ��a�      �   A   x�s	3�t�K-J�,N,����r	3�tL/�W�ML���T��!B�y�%@�	�[jj
W� �
�      �      x��[W�Hֆ��_��Y��]g���!fu���n�� !����{�dYRT&!Y@��h׮wJ�������n�[|ع�������-Ƙ���i���-`0`[�@=gj&،��o���;GGJ
cMf���/�� �W�Cr[-���������^���eu�������J0����uU]o�ח��\\�m_]������[\Y!��J	g���?����.���wԞ��b�9�3�fJ�D{J��넾>��b�\T�~^���zv;���s�<=hw�w�3{y��z�L>Afī��؀��ˋ5�����\M�M������i���eg�s�ᏚЩ%��"f����@���eŕ0��bZ�0)�-��PKeҴ���]����Jx�G
k5s�8�'��mi��ק-��ӱ�V;�b^���/5㢖BM��{�|�O�p�L 3�3��<���0[NMj��45�k��_���� G��z�%+V�߅�(��pn:��Ib�𜹙t3�k��ת�,�����
��[oO��k��5�tm?�=&�����ƆAg��'��x��
��?_�'R��u�q�59M�/�_EMi�/�&3��,�����h��������?sԚH�m�,*,r3j��aS�	ͤK�ܑ�q�!Z����ژZ_�&���Lm�+��	ZYip0_.��M6Y�^}���C���C���gcl\��f��,S܍}a<Us1lЃ�o��|h}�k�2���}�@f�e���8[13[�7T_9?5W�\92���'pZ;������|>������ic~ 7E�T<
���|ZM�DY�V*�2�$<j
E�%����м�]l���'�5�5�짓�r�Y����	�b���_�����Kk$�:!�^�YP��IPV�t�����5��&��)Y��L��Nb�;9��]���V��r�#������p�JG����KTF*�S��*��Z�t�q�D@���R�ۖcJ:������M���
����Ϲ�q��Lt�\ ���BRMJ[?���԰�����A)3������]�ډ��r���`>B6�\3�M�B��Ke �����.�2*�:R��������u�ￏ�
Y5E_3f5x�	���&qm�@��in@Y��&�5�bdy:��^}�@���,��)J��R��@M����}��N����}A�^����	��N�n���>��f�����(09o��s6�_��"xN��x�-�3ƿ�PVj�yw�7�bj��瞞/�Z9ŷ ҦŜ��D�k��q�c�V�b&8iO�ў��>�)�jA���^����
��bNRr|��'\��*cMh��j�8)m�z"�����8�ռ���M$��Wj��z����p���f�1���#c�&�SC �9�ڙ����o���-�J*��\�o�w������l���
Ͷ�v���<��F��7$��Y��<�2�3EQ�j��2��,& �sC>f��n�/߳���8<�cL��x�d����e~|��4�|���H׎��#�����*y G�͌+û�|�Ⲅ��H�K4i��V�gR���)�gG�p�;gF!>�Ϗ~�=:{�8S��)4`)ǈ1�:���ES���f�m��܈	1�3�"Ƹ�τ�1L���yc�(�zV<g�Y�C��0P��!�ӳ		SК�1����L�B�ǥ�%��(�F���@Q�\mT:(�;����}AB��ڏ=!�wqw1�+���S��xŒ۝�a~Q.�3/ʐqIazY�Ci��i�BpuƔV�3ĪX:���Vc�)�
����)�����(H��v�[L���SeD����'JPxB�9��̑�c"ZO�����j2%�
h�C#��@�,ؐR1i�-�}�
��R�}٦���q��2V褂�)�ܓJ1s*NDj 4f��QsZ�W3�|�$9�ƚ ��' �0Pr�����8g;�́��U�5�E�tO����Ҡ�,�c}6�9��X�)�\�l�Rǂ�Ά�9>;{�$�uO"'5Vi�z��"h���׏��
�}�,[ۙ�K%-��E_^��Y�p]5��R#Ք/�������}��3�w��Τ@�/��7�.�8Sx*v�M����EO/Yu� �q�9Iluf�Jbn�P*/��L���P,��Ib�2e��Q�8�g9 �q���ఙqtH�P+Lb&T�k{	��=<�#���s���fA��󟟂V�'t ��W��8�T���� wA}g�+LhC�_ߥ&���~ZH����Ec�h��m������[߇�o޿_H�Q6�ڹ��)P΃jk�r��ڀ�QXm�E
�����8���Gf�����M�eR��y絛{�	zIW=��
�ZPM�o��,�7Z����MJO���e��ů��hw���Y��h~��y�#P0C��$�E4����e��.[�qci>ހ��*�ޛ��W&gL�F�)U�`���u�<��İ��.>��=�;:rf䃆N�*�
/��׾A��p1��A�'K.w1� �Ey�?�,�<���aN�ag�Ix�̸��<P�8���(P��[PRj"r	�ȣ���(� {փ�C�`�}�h����qe�7+���C)gDt�V?��x&5��4�c�����=f���V�U�q~r������\�)���b�A��[�!h�䐓У�#�:���屇���xKB_@k�=K��v�7��c~\��o򄠽���H��g��0Q�(ۋ���J������U��dR}k�+��N9������c3-������E����H=�ot)B�~hH�c+eQ�JN��j>����|�f�I�w���
�D}�>آn�xr�	���#k:��}LA�އ&�ܤ]"�0�������0�@9�q2���$��#$1r�	aTae�Yfq�I��lP��%1A;pd$�	���W��-4`hl+��x1�b~<G��H�Zÿ�p� ��7�UFր�q3�R+�8K�ܮ�Δ�q)*Vl,Pl��W'�Aʊ~̑��y>8nf�"F	�s"�p��"VUJ���ո��V&�66�s����b�-w�q3�,�0�h3t4�����m��	���X�P�Vi��Q��;\�+�)��?�N��b�ю+����_�`�ܲĮ"�Ɯ��� KóVN�܈��i�kk�a��k�w����ll�H��5b�֯��0
�N2��7�d)ʬK���s�z&%)i�һ�Eu�o�����vs�(O�y�F��$�JAK���b���)�}�(i��I�NA�/\.�CL&}�:{{��D4�W��f�m�H6����iJ�əⵘ�8;>�]ߨ@�]��g�ԴU�hƩ��$,���"��GL$%78nf�C�>FMkѝ�}�g(�/,/}��D�lF�ڨp"+�G.a�<8lf܃i>m�a�����#�@�a�le�|�(���[��p��;z2�9L�Q��U1FB�b+��09��^a�
��N7$�/Y����<hg�5$:��`{M�S{Pl���q�{`��� �Lv�X��K��Ԓ0�d)2�z	h�I�chݜl^��DE�bh��;z����W�ǡ������t���\��T3��qRL*'ⰴe�-��B)K�^�)̒67-�����$��
���>�́˦0�39?<:�g��~�E׶Gw]G��a��&��&��_C��e~����|[�f��@ś&�	���2��1,��D
�⨀�Ŏ����S�.4�6��.e����B����Ds^J�|~ ��?��V�8����I$�������rP=.ݏػ�lB��%���Iȣ�a[���v��.�_�3�;�����%��5�ᴭ����$��L�R�ڻ���{MKwJD�}�"l�暻 x�f�4�C%Z��^�}pV��5��_�M��������;��xY[A�:.hD1S�)m�TςD�wMf�k���,i�(��If��\U6���ʆ^�Re(- }w/��;F��oN������|�M	c\H�����1����;QRN2������ӌ�:�pn�3,ct%zP=bNS�Q��X��I��k]�BC7�� �  ������L�:�mq�n��>�md(�D������T=E���J a9�1�]:�1R뾌��e��0��мZ�tp:N��ٻx�;4m��:a�Y/��.Y���cG�SYK��E���:c]W����V�K��s���zi��7�!�:<\��t��hoVF�i�@+�%���;~����Ҁ	�(� xE��.����sƵ1z_T;o��g�dl)��Ѥq"4dٞy�+���7�A���Q����$�;�EQJA�/A.�ipK��əm;�hWkm�=��MT4!#���X?6�c��3�:sRcN��=8	ɡN��J����8L�Ҕ�Rz�3�s�!���j�ߐ%��r�%z�4:D�4g�*�׏���}n��#Ta���uH?Yli,����lUZO����_���\,��d���K��gȈ��1oj� ��UȌ�d��qn0J�V�~"�H�޳&����n�`1�&�Q��@+�EE�bdWi@i��޴���(�EL!%֧Dy�dm��<�,C�s�@��i߃A�Ʉ� 4���I��P��~��t����<��yqV��S�V�A3)�7���v�6��tު�p�a�λ��\)$��Z5zH�@p�(~�H�*�i�JR�4��o�U:7�����ҮM)�����4�6�(p�$
$1��l����(��<�oV�=3,���q;�!$�d�r�����fD�7=e��.�HOO.��P(�.��S������{m��8K��jD�5;�r��!~�c��h��Ά|��w�]~�'��5MJ��x'|b��c?I��I�EH"�Ȍ� r�]KT�\�M9�ֱ�~M�����ȏ��R�g��yj���de�y�-BzN��_�\�EcK��c.8��L.]�1o��
3d�ǘ������o��F�,�N6��Y.N'6��+2-l��sn�I���K��5�L��1�C �0_.��1 F̵0�4M�%�b�T��.�&�go��+�~;��{O�`Y3�&�ڙL�cN;F���0�O��z����U$���i?�}���]"�W\�Q�+�"F֪z;�c���ʷ��
s�S�́�R(j���*Yp�	.ӗ�+	V���ڎ$٬��?d:S���g�5�Ӕz�-_�7a���әlR;PϘ�1�cn5�ݵOۏ`�\ ��4M�4�O�R�xh���78�v	�X���H�FL������pJʡ2�#�.��lZ������}SV�;Ūq�'�V�z��6)h8��~����S�      �      x��}�v�8���)pS���2�3A���ؕ��XNR��alU�.Y�C%�ռü�<��II$MҒ5kzU�ao~�a��~�����w~����w�������$<2���H���D�p��(�1�(���O�\��u�����o�Y:Nƽ?�8��1�{?M���tֻ������hx�~z�ш\������,���"3��Q����)g{��1M��|_�HP�Eǟ�?����Ɉ�L�����`�;��1y�N��B	9�LSx�����~8ܒWgo�}|��0������g�AJ^]\��������1Eߧf��(6�R�/�kF�IһX�E�o�����"R�;�X���4�Ȉ	�p�܏�V�E��������Y�������x6��o���Y��净B�p�0��9�9�~!������]:��r���0��žL"��e 5��]��4�_���B�l�(2@�U`�����,�sr9��o����6"��t:O����trs7�L�DQ��w�D%��e��!� �b�%8�>�����9�6���p0�$.��#�#|������n2#A89j�A>(�:IE��� �@|��iz3�L{'gG�'W������(��{O�X�\�UOH�ddL���Ȱ,�B�=͙�`O�yzs7����gb��%̯y�u�P���|X��c�� TE1^3���Z�H#5�;I���H�<��1r;��m�qDC�"[��I����
l�+�d��Df�D�&�N�e��N�>U�3���I�vG4T(���"%��K����u������������_�}� oyOjJcX�|;Me$U���(�Y���Fl	���:�h�Pd�J��+���tq�~�����'��_1����랢\���+(�*�,�`Y�[�jC'�DY�u�P��V;�N��]��������^�������.���v�N���+���'t"p��G��N����E,�RɄ�v��ۮ㈆
E�ځe��Khi����q�S03b� �j��d,���ӄJ�&�Ӈ���8��B��v�$v�������ү����.�Y�p���F�-��y�u�P��V+x@.���{��:��V�E��t�H�~
�����=.% !$��u�Gq�g�?Z�͒--py�u�P��V��}*����Z�����HE9>�i[�8b�M��Q��E4��XÏ��]p�ۮ�(�Pd�-n�D&Y���<�X��3r����:���[r����&����b>Ma�.�5����7�y�"��0��%�2o��#*�j�������e��`}ط>��;�H�(�#�Kb��:�`4�� �-�{y�u�P��V�`k�Hh�UJ��듓�M��r�
���PJ�2X�KN�&�
�A�������_�����*=<+���-��U(2�N�M����"�28.'�SM7D
�|��p�Û'1�<�3Xf�p�*%A�����T0] (���2�y"��X��̬v])������T̵��b���2X�$K�L�UZ�F�P����=�(���4D$o��*�Y'�W���X�ȇ^��}r7&ǃ�t�	syu�����v"D~��ZVv�	�/����0Kc��
�c�Qa���r��uhm�RT��>�
Ef�	�j9���*��N��8�%��;��d�Dp�_��z�/����l���)�.S���2�c�R�,���yñTh��*�Y'�zNF=�
/M)P�����>Q�wv�LR�C,s��ͅ�``q���|\x�,���a/)�X��̬v�)���X
�� "�u���]��?��MA�y�9����5Nm,Vv6����~��2�B
3�r�.�&I���ī<�!kU�ba.^bf�p��=���U�6��9>�$x|;<T���r�%aO�aa��ZU�(A������\O�E1��4�Elg�M����(�C�4sG�,ۭq�B+0�"a�̡�[;��~��=�4�F�t��Vׅ �Ҝ�!�Y�J�88�X�@ԁ�?�>�C����`t�4$^��-��%tE�%[���H����,�i�3���P{�#w��������c�[Ȕ�g:R�1�j<����b���]F�(�H2K=bƞ����r�y��*�}K�;�)��s�[w�YA���/��RAd�d��K��F�BKF�5��b�y7J��B�#�w�?�i��v0m�;V�S���Dy�h��Tm���$�s�����mv]I�іu�����-�3�gs�[^YT^�s�D,S��b	]�]�;�0)���F����g ��'�n��d��C$�)T��_L��<�eSY�AHO���ۮ㈆
E��m��>�9h}vq����~ 9 ��:E��1������Иo��,o���R�ZA� lh�fe�%���,��yo*v&�A��b��0(�d+�	��(�'N�q��pCkdq�g`�U,)c�D��[�჆
Ef�	����<���e�Gฃ�-����1Cä,�e�=)�9���1�;�H`@ w!����n��k���B��u�~�s�FCPI�`�̚��EP�0>�ev�	��<q��v��K
K�0�h�@�m�;�Z�჆
Ef�	��Y���X��x�0�-�ܟ���z8���O2w@�zWÛY��y̤�ccB�X��<�e��*�JJ�{��y:����V>c���	�d��[��#�Pdf��?a�sW����ӿS�9E�|orR^/�Cn&������'Jr~��=�B��G��v��B~%�h!��<&�]ͧ�lS��ƪ�����\�
D3�V������|999>�B�ܩ"�2��G��]��|H������7-8��h�,>ų:h�'Fhfw�:�s�vꆐؘ7�#o��8��V��*ь�58���m��?8?��{~Hp9eҞΉ�g�,��,�<��R��L�TB�%�(i牐��4��^%4Y%�*e�s�Va�?L�G@�0��$�H&s2�5�$AB�G�1�]���o�p�w�S�+��*�U!����V�"�I8��'�� :n�P�N)E�.�.��sL��T!r�W흧�Ŝ��]6L"��l6���, ���|���lF`B������7g�7_>�)�{g-,3.�"JTx&�S8E:.�&$�ƪ:Y;��k�.�q�xZ��*t�N&�����` ��P�b9�b��� ���~ޗN�p	Zy��Tn6�u Ƴ�쁁O$��a�R�E9�e2�s8Z�����G6����#t���h�|-��χǔ&o����|C� ��ᚠ������R(<A����8���y�'�/M�\�N)�0n2��d���zN� 9^�P9?��o�����7�O'#ػL`���I��8}��7���lNG8��,�ɭ�9�V#��4"G�Cz3�?�b�t�p*$0��O�O����,(����)�xj���)��֕�e2n��'��O�9@�ꌼ�f��Ś�;��ӯ	�9�N�/��\Z$�@�S9푴��X�T��6^��R�axed�����hN���������9=�<!���/��i��g��p<Ó;O/��n�_�3W�&��P|�a~�>��!�i� �/8XܓI4��O-���bV'�X��dz���z����P��|N�H�z:�����Q)�C����q�\mp�qOfG�rg�������{2��b���N��T Y$�
=��C�&7��.!�{����\�������.�%�|�=�3�"�L\M��x�̺
���R�@v��+��'�V��u��5�5� z��%N`v��B�*�	�-K�5.��M�N)����e2���'�o]�~9�L'� F0`�[�3���\��>���s�������W��P�����T� &㵳u�@�/ռ��헍�L�F��2'F�$�햎C�@�,��*�sQ�g�E`l��ݖJ��`��qnO��I���\�������uE���t,���v���ܙ�>� 2lL&�yk\�>����(w�ǉ�U����x���d:�:r���5�g�Vc�}�`ٕ+�/Wc�}��xb&�-��q�B�y��    ��c[��2k��S�A�h`x�y���P�Sa7PPt��Gdd�ۯ%����_2�XD2�$g�hi#���O>]�{����;v>�}����c�;��,��Y>����m��dm�qDC�"[O��%�^��
�wў�aT�2����(؇�E*O%^�O�L�vG4T(����J*��������ங�Aq�g�,2*K�q�-����:�h�Pd�-$0�b��0��\��F�uۓt��1�4O�5sk9����x��('Z�*��6���t�NE &�ZTu�̟�D�;SOli���,�[>�T��ql�w�m�q�U(�ծw�/[�&C��:g�|��H�"'0�����|åPQ"����1� 7^�C��Z �u[����1�U(rܰǉ�by��(HH]�~�,c{���ʞy
��F�,��8Oc�s�f+�,6��C-���2�u��P��qSA"�X.H`����&��c,.P�|c�=�E{]{b��<�e��d)t����-Y�u�P��V��,c+����.�s��Dm}B�U���Y�j�4��[�r\��Ьk����1KC�"��
,�^��,��)l9��J�-ilx���KQy��Z3��I4���Z��]��l��1b
�/f��i�)0{;Mɿ>}�e�Y��^nB�"���,�en�s��,1ۊ���]��l�@Ƞ	'�-��T����t����k������L�RX�z*a��"�`Y��,�	�̀rc"��l@�q�bsV� �f�4T(��@��M��h�e��3O�'�yű��O��c���qx�7����X���!�V�^���&B�Y�Pٓ�SJ�����27�yZ��b����|T����1c��}��j�2;��C���O��M��C;��+��.�qŞV�꭛k m'�ɽ����_{�,Pg�o0�MHP�&��O����vJ)��RN�Yz?r�u���;7 �g��4���'d6�N����7�&�W�o˘���N�!�ZC�Dkr�3V��H:��ȡ
����-�a��SJ�����2[hN��H����U ���z���H�#�G�&$�Ÿq�$vR��k-d���D�x���)��zK��2� ��"'5��c��&���a�-��S�;{���~| ��r8�O�d� �U�}���=f�t���'|D��9f���r$�����d1m���RB�M��E���	<Tv�<�25�ڔt<�So8���v��5�j�W��y:�+�.?X'���d1���yiq]����#"�[:�ɠ�C���39�OB���	�ʢ��K\�~6�����[GM�r�'9�9�O���	�W���a8�F��=��js��)�rJ��ලRGX�D�Av��1�[��/U�H�}P�L�s:�~}*�!t��b���#��=����j������10���f ê"�E�������A7��'�),Hl'Q/i ^���i����kE����,��(�ֱ�=��)`���Ĵ~lx�@��B���@|:�����;	��rp{��"G�#���^N�c��S��>���cr8��`�j��hA��ł�d�*0��^s*�zw�xtB�N^�{hԒ9�@��f��pD��J���h�0��?}i�W��s⑒�g�}Ū�@h	A#@�!�
g(�U����3*�
�-�mJ����߰�ܥ��[m �nC�[������K��T����ȡ�C��LGXZ�01����p�_�^����?���߆�o���d�^FG�����iW�s:���y�)TL�Z��S���=P�Q��-�^�cT�[h��*�Y'l���s�+B6	Xn�G.j�S!����e����[��,�eh�RE���t"}'ô�y����~�k���B��u�ƌz�c>ka����o��U&И��H4��<�eh�R�$�-+,��×��y�����4)k��*�Y'�@ʨ�<V����NI��am /��2i̧���iZ�yo�(�"N��&�R��>h�Pdf��{��z�c�s�H�1��%.�7qbmX��Y7�*×|zZt�[j����8�*�z��cnſ5��*<�rCN��_�!*1z�d,��<Y��I��EM<��
����GF��Y*9n�"
́�RM��a	_�O��8�p����]\�\]\��zv6'}��`����y�NS��;���;d�̝��TA���fdڮ�(LXKl��1a01���X�u�U���S�`��Pb����7�Y�2X���YK.Z��0�����3:jF��Y*9n�Qy`�������"��{�l��#����P�5,Y�В4K��
�]�QV��V��h#�Hq��&���]�A�x��d��K'kTv�U�O9�K;���3kG�����n�"��=l�"�g&����+nyh����H"�%b5���`���M2��n'l��o�nN�)`X��|x3����G�-��BM���0��bF'��yE�='9l�����hߥ�s�rj�0 ('J�b�g�������;<����/�������kr>G�z���A?��#�!k݅��GJ7�i6��S��@|�K�fD�M'��Bj2�����廫��|7�
�`4ސ�B�:��|� �<�#���+���Ye�%��+�$=?�X���񀇃,Hw6�D`��Z�F����O_��+	j`�JL��24U����$�dm�qDC�"[��lI��<F���=��=��R۸�\�����EZe)F�[2y�ۮ㈆
E�Z�݊��%M�6�K����<���%7�mn��3X���4Ⴙݪ�;Kg�v�h�2x)k��b4T(2�N�V˩�<)�E�:3#����kK����������3�2�W���1�Xb ���
��s�J��ɲ�4h���B{�<�P\dd����Qι{R����u���Y��, vt�g�3g����a�m1HH�ҹ1�$K���<�߱��7V�>>e1����
�U�@Cq��U��@9�D������
7����Aq"�� �X2i���X�	��$�N`M�B�L�[� ���Jh(.2�J�U�(�ܭ�5cr��$����̺u��R�2�\�8<��Xv.��N��)bw�3vI���O�\]N+����2�N<(�]&�=��I+0gk`���_\�=ϯN�{׀"��1�sh�i�\p������Q~P{����,Y�7�vJ����%"��S
|l��U���(r�BH%V3���ȞF�wq��v�H�Ę�`�v���r�KD�`u��`=i�n!+�^�s��62_�(�kmXTd�%Ypk����UM��>a�]���7UJ����eZ�B �1�R]�w8'h���s���K,��:�����͔�E��{���ܑ��N��$�$������(9�,B.�&3{z��K4M�H����qJ�"f�aR�,M�KQtD�A�A"hg�,�"F>!��u��$�~l�d�}y,vB�K�?�����Z�����T�:6����-tfQ��=�������`NW-[Z3��b���Y�+h�5�pgƼv�Ifh��0��#�M�;�v�����ZK����S��d�}ݶoU@�<��IM�_'.�阈_�Q�[&lx�֮2���-40��b�-�.����d'׵�@|=���l�
��X�v`��p�q�7`Z�A�e<!�(�����Z`��@���=���Vi�]ۆ�2`�Vh`$b��el$�c�Qz�ҩ�d�m��vGY�"[O����?�kn�y��B��_��;&o��� �Þ����/(^Z��!�eV�R��=DÏbR(�)#�DW��l�4T(r܄E�p��,V�SS蝿����ۓ��[�%��J�M�x�*M��ٰX>՜�$�~I�t��c��
E�")��H&�ʊԫP6��� 0`��Rn\@ff�Ne��2:§�
�z�馆y�vG4T(��j���cx�Ӛ����d%(�ϧ�����aauG�O��*e�C(�a�XȐ����,U�����8n�`�9�Y    N��Y*9n�iU`�Ծ��N��C�`p���x�����C8���{}��Q����<<�@�@ �"�u��P��^��j���ڄ�t���HJ���b ?�e�2X	��I����Ĉ�Ɔ�7�峌�T6�E"k��*�Y'��@=�H���I(���|�p}u�{8���Wbq���ϋCjsAH��i�)�*E�L���MhUhZ�䂆�%V�Ⱥj��U��uP����W�jE!@�'WܝǺ�S����_!��0nC���˦Z���R��('�L�{Z��V(V)*�{���h����Y��/�����������o�#x%�t�� �%�?����c�u�ች?�=Y�4�F�J	5��
$�$\��x�B�,�����ܭG�X�ds��M���t��B���.8�K`�l]lc�](a����6ʎO`�P:!����SJѯ�9�e2a�B�������Z�^��}&*ߡt'������.�"�К�*p{�6�T��T�m]��8���x*k#���U�Tg�1�Q��6�x{4��|�h���^��7]�m��
n�(�W�)$~ڷ�.>�	���K�d�B+�-�h������oF�VN���v܎g�l�d��Β;8�V�v��vbC�g�l�^,!�Z^at�D;8WGm�Ȓ��P�I�اq�C�'��/������c{y�Shw����.��l?��id��
��#���<����^�򂇺��z\���h�/hςs��a�L~�-]��B�q��_:r�}�o2����KH<3�Q�^Z�bN��P��gwCr���Gx6^c�E����F�|�o.��j�	��@�8�w��(E��a�*�Ү���l^8��'7S���**4�1"��[XoA��N��X �������5f�Ĺ��K�\�o �%w3�C�{����dg�f���|CV�w���A;�NZ�CL�V�_�,���(|�{\
�����p�27��Hr�J,���t�I$^ܐ¾�
ğ�l��5vI�7xU`����t�����hE������d1�9�pu0�����JE��61�����v|2�w�$������8�~��W^�8�Bw�eH���%����|��:�1G=jfolk�S��\ŽD��n<W�JӜ�0E�H���%�Z:M���8�!c]٤�R����y�u�P���|�\Z�P�j��n�B�H���}n�_r<����!�exs[�&J����}4Ð�ҝ�Dr�u��P��qq�,�k�^ց�+x���
�˻T�e�{��`�Sp�#j$¥t�y��:�h�Pd�Eϳ>�x]��U�h��rӄ���i2ㄢќ�.�.G<6�r��QV%�d�振��l
���:�h�Pd�dʀ�1�f��~W�]��P�(jXU�g�= ��0!��?<q6A�[��g4^��P�Yh��*�Y'l���s�=(���(8s�`��O2�&
���J��CC����!��}$K0#���6��rf(���>�T	��B�#��[��g"i��,�X��̬^���`���ݕzC>����7�Oޥ�#�׬{=<�.'o��l�0&�{*FC�C{_7��$�(���,��U�P��SNv���p�V�	O�*�Ǟ�����d��'irΒ;�3XUk� 0$ME�D����Bq%]|E�8$�4����)��}��2W�iNVAY?�x7kP�{��3��v�́h<�\��,���X��E}�@k�H�nY_@�Q��5�}�G��[�* �P�_�N��O7T���$�ٯ�n�m��Q��=��+40��+TT�k�R�99j��wh1���\�(zc:��p�ڨ�^n�e'�U,�2V �y�!����i:��ˠ,�1Z�h�؀��xh5x�*hW��'⫆j/d��w����!�b@*;�t C�fu�-��?F݄�i�m��#ę*(��1|g�<0�5�����|��+U��%d ޽K,�.�8ov�-�fX��fm]bXi��gݍ��8�^�Df]#�y����b�w:�ו�)"��Gz�N����gx���Mcm�,����s1�#+cX�:1��a���A�����sS&�=ߔ��lu:چ��?�Q��o�T����D�-���gcq9Ń���[l��N�j�L
I���>h��?����jA�`�'��љ��iTA�ט�5���KA;�@�`�_x7T�Q�u �!���������l6L�)a�J)��a?��!Go?�<B�H	��D�]<�MF����2�&ldb�������EonG��Py�����Ц���� c%��컁(ӱ�1oe:��(Ӂ���쏇{ކ�z S����}�����`����`�,�HTٺl��w9>�t�ｷ�WxE''=%�k}v3xg�3Xf%�4�1ߖ�A�vG4T(��+�Z_*!4��f0��{?�]\�o��L���s��<�e��T2.�F��h���(��#L�d똥�B��&,�X,�b�i1l�$�������9�)΄��}k	�3X���Yj޷�����]��l��o�]V�����A�0��q	�\��,j��+B�����k4z���R(�bF����
�4�޹�2�T�ȡY{�P_Z�b�"]&��V$��Jy�&��?�\vN�Ç���x�p����qH�@}�&�O����RP{3�K4�I3�vJ)�y+'�L�:G+pR�W��-�#��RCO~\%
����!���C�i�'�=�t���K��MCt�v�)�U��d�h�'�W��F���B't�c��!����obrp������r��O�6H㟊k�F���~}�(��Ĭ�R���e2O+p����|���t:�+m%0�?\	T��O���}% ���#I��C��{k�G�p?b��-��í@ڔŞ�ך���V'��:�EP�Ub��1��?e�Qa�p�x3�N�?S�����k�7����C
4���ь_į'�g�~����G��êqL�i�?�5j��^u�~�h�c�Q��������أ,ּ���H���z�@|3��׍>T� �
�#�_ڳ�v�@|چe�9�.X���C_j�Uּ�?��?�c1�y5�?�;�'�A�i�h\X'o��8����B��~D��چ[B��u�܈�G�s��]X�x:���h��n��1��70\6d��zڱ�z�8�;��6�n�H�־ �p��@��&�^�6`t]�#������Q2o������z���b�?[� U~��G����R���h�'�;ZRXW���\Pl��� &ώ�)j�nn0�;%4�Vߚ)��N���b��xӲQO��d1���9Ig�0�O(���]N'��`�o�&� �����±N=��#0���~�xv��G�A&���O����8��q`��>�?����T�2�VA���Q��fc����@��y�;�pϹ&��O�ލg��W�R
;bT���Y�oH5�Ex3,*\��U���2��U�O���ݳKc#���2�xAc���ެ�2�r6�.6�0ޫI�,ם��>^]�{6�:�Bx5r�~�/���aB8���`��R�e~͠��Ҟ�u��$'[�,�7aњ�zKҰ�K�dM!��xut��{�7\%֟8d\$|��
z�{n��}��em�qDC�"[O���K�t�����f���������(�L��9d�vcy���*�h-��J��}0'[�lV��q�>��M���u�b(�5c�淞@������Ѝcz�g�CKdi�Ģ��1�AW0X���%#[�,�7�[K����Z���bA���8����5l	T!�ex'��3��y���8��B���?�qM��®4��|C��}�X�zC���b��`0N;���Aƍz����n1}�X��k�4����rDW�0*0�0�E�>�pp�h ��^�W��0�����n/�����X@p���� �  Cq�p��{�e���=m�7�Ql�3U�>�J��}v��x��D�
��a��6��)>�ku�9|�)�e���
	��P)Y��m5�ʶ�",�Cd5���ズG��pc��M�8ğ:SjW�9�������C��7�vG���IQS+��JD���A��@(�V���܃�m�s�ڬ_��I�L~�-Z.:HP�@[�]��iס�����#c���K{h�:lVg�"tW����LE+}��y،on�]���o�u��7��Qɋ"$V]�x�M��zH��d���fw��)(�E�݆v���M����)v��҄!���Q�m�F����L����d������FD*<�����)�{k�w�K��7}� 8s�*���zx�����%��(f;s�`�0���1������D��m>i����$����,�Cc��M�-��s��(b��{W���@<O�^��{�H�ܛ�x(���/?�&8p-�gw(JJ��|9n?�*��DI��20�Y<ڏ��zO�nJ���:,jm_��a��u x��o�_f��@�����R�7���ѥ/`��;��c��w�	Am�X�wam���m���;�!v4��޽Yd�� ���7i�e�����t4�M�o�c�-��y8`3�D�=k=���W�M@!�b���/���`�x���Ì`H��i����`:���xe��o�x��1N������,����Ȋ��ez��V��p���K-�6E̠��E\	�<�~�Ln�5�����P�J���dU��-�䈯ޱ���p����ѿ���;����G�һ����od�m�sz��x�F�����{B}��0V�j�e��*���D�[���E�jE�j<�B0�B��v���a:�=�}JȨ�էa�YTUl�mB�ё�/�o�d\=&�:�`�x�-�b�m�@�
���eWY�@�b��s�t��і1	ğ^�+{��0XQTE��2�xG��h�>�Ʈ��K��*����<Ļ�g��u�H��S����xǏ8Z�";���VVYjÅ�� �ƿ0P6�*���N{��i/��(~	nn���Ym�@�
?�"�VL9��]���0����a����γޝ��
�2�����<��֢e0�h����vіx�����W:�U~�[}G���s1�I簷{˦:DȖğ�6�]�t՝8[!��f�������N�
���w����������b����;~��t������+^E|7�^��?�3��(�y�@������z� v�\�׋@�����f��ot���w����a�Kߜ��L�)ި�cCU]|�e���`�PX�p�w3�@�����㉭�����U�J[~wO����>�x �n6�2����7��C��682X$�n�| ���?������T�=o���~0K�)��`:w����:ս��3N�7���P����-��w����� =t�X�d(�g�g�|���4ف�Zc�RG��g�<���Gg9�8�ߍ�E�ݿ����_��1n&(�6@���ۓ��[¨�1�>3�{�*{7L
��&�`Y��Tq%�j�V7�ނ�Y��ްm��@��Y*9n�"��;Q���wZ��<�Kg�0�؄�g����&R2�`��,U�5�kXt�t1:uK`3�u��P��qS`���&xZǓ�@NX.�z9J����x:�{ |+���s��2X�2K5�%m�E�1�h�>���c��
E�B+��!��i9���쳚r&�ie�1rc�c0f,���R%�dk �JM����:fi�P�)���* ����@��$���|<�el�Y
�Ldd���H�Y��mM�i���m�]h��#*�z��eX0n��{��������#�6�gO�a��K�lM��)d�0�R����Z'����8��B��V)������W������A�      �      x��}�rG��5�)��v���<g�N[����Zn;�cn 6�M��D]�;�Γ��̪J��P �H� ��2���|x��:�����rqV}?�]\.>��'�f��]T/+�l?�9�u��Z����W7�'�>���r��zvus"���5����K|�JM������Od-ų:<�j*�������6SU�<��ǟN���˫}A�6H����i��A��Z�&~(��n8�xN~^��.��s �̖��/W˛<Ϊ����O�������|]}�O7׋���rqwϧ�^T_�Y�����8} ��/��6�	�O��h�okbtܕ�sb�|gOz*j�����ݓ�l	^�3��(�z��ىKon��ܓn�t��$� %xΧ�����R�_�����j���j�����^U?�ݮ����[y9[��\W/f7�Dx��>�x|��˼���<�_қ��05v"�|ʝȴ��5#y�Ǹ��	��{6"�r#&m�N ���MZ��F0��g��<Ƚ�Dcb�<���Ƚ\�NN���n\u�p�dx�].%K>e�~���r"-~U>-�Yd�*2X��B�!BWp��D9�A}��c��d��R��j9q�0J OW���Q�����T��R����ù�Q`Ϋ�+���$����i�����`{{�Z�/�f�׿>�ͨ䦧Z�
�>��i������pB<�9�D�;}}9[ϳ2|S��<_��g/�M��h;PEߎ�g8��{T��d�![H>,�x�g�"Z��L���J[	1��T�C�nʮ0�e��tr֧�-�d�j�V����,l25�W��TZ�1�� D;��k�W		o{��ĹЃ������vq�8��R��`��?��v�����jq�^�W����ޝ��R���$_a�y�7�;�-�x�n�Ak��7�m�����#Tȼy�(.��{����9��!�Y����EB�����ë'���:��vR��=��6w�^,+����^Vt�]���e�d��-�?�DҠ�)Wb�������?��hջ3 �38e ڇ�D��:ǎ��B��&�U�e	��	: B֒ �a���������u�v�E��lT����P�'JH�lG;���vC5�(x�g~*Q.����*q�������7՛�����z��}�	���r>�__�n畂��N����ҋw��n&��e�R�#�������*�D�rvt�-��^UW'������#�1��XO8 �������:����g�Ȁ&U���`[�ɩ�����%>&�^=U�(S��lm�e�{I�PC^�cr�
 ������j�HҮD`Dd����D$��̲�y���J�(���q�\��TA({�	����W۰�u��S���j`%�j�i�'�����j�r�~���n=[V����6�w*Ol`i
���0�� ,�.�P&X�� WO���ڲSj"O������ĕI@NB2
�c��(̦�:
���u����zuvq�l^���u؃2x�8R����}8��`�˸��K���#C�R5�?+N@�� �Z"NT�@�-P~R�[F���}@ƍ~�'�k�A%
�i��5`0 �f�9�l,s)Ѽ�_(��D�{r�i���66$�'���N��TBp�-�f�=<$n>C;��'��|#Z�!��p@��R��0�ŋA�������^�\��#e���p����ۓ���MQ����� �@�
Gf�]u�KOWQ�*�)*��$�,W�����%�4;8X9} �)Ԕ�1J'��Mk�Q:�:�t ���5
�At>��޺g��_7N�r�
�W� ���o��S���Q(YO�df�>�^tC4BrX���6�a`��e`Cg��賫��������W�d��BY��+j�O��F��B2�D�q��#���he2+,j:`W��h�A������bu�������՜���W*��=n*�)p�G���Qj@)�Vyj�KԀtH�@]"h��~))�V�QZ���x�d��$�1�E5z��_�nJ�VQ��lHQ
=^��L� A!Pb�L���<(����U�&΢hc3���H��4�f`kA��Ŕl�A7���3v� �A�:m8��K,��DDKT�T�L;p�
-9���a��8Fz��kG�É�A�z2�>1��Q��APj$/�2�8�%A��zj�.Ա�6�����كq��&sC����8�ǂ�8?PWA��T�,B��=�'gx��>m큸���xڐ��3O�G j\�; tWb����ul.4Z�����)UC��4���Qh2�b��������]C��2[�Q��P:6���f�]+`���ho;��j�q������{��,bAƛ�>�!�:�����\ؚE(`ϛ���/�G�t�`��A��6_���?���Pܑh�˺���,�!ƍ�ۺ��zQ�=q���d�l=��[^T04j�_#F�b.�)K����H�Ո����o8 M+�4��k�NF�N��}l� AYI���1i��?&vi�����لT��?Й�zg�$�ɂ`�z
z��U�y�ht�s�8�_-��"��6s�F�Oc@����qM��:�PZ�R��l�a;%�sl�.ϻ&Ě�E���&m%�J�[8Ѧ���?���n0c�&��_-���9G�d}FѠ��<(�h͈��R��<{�t� ��Ō
1���KV�&��n<�Z�4�aFlǍ�3���w�ſ����T/1a�t���t�����
���^̗��L�`�A�p�E
���2	`���#cK��"�~�5�?�"��O�HSR�=�
W�g:����JzU���=�<[�^��X��ămÉ�plH�t5Ƥ�U�:�#"�[β��4iڍ��Cђ�nEy��1�g��
*��S�?�~0v���CNX24�Ԫ�JM�%�An��g��������ۋ�jY�M?Smr"X[�3H ^ěx�3e0
`ݨ�N�!�5&Zӗ<�v��J��s0Ţy�k�Wf��}�m0�Km�1pw�8�d'��h|�t"χ��F�����F�V�@�9����>�)���j��_���a4�c }Št�}@�皈<�@ݬ��CW7_VTD�F�����%�����+b��\R��I	vJ	Aaфd���p��)�P��èb8�.Q6`8Fqf<f溸Fծ�
��*PH]�A��K�NR$�
ˎHr��6>G̜�1�d�Di�(Pb�rv��5eh�џS��ך�B!��Mi����������j����v���k����J��B��w��#4UF%��`T�SJ?�Co�#C��)k��5y�B2���
�`�ht&`���X͘Yz�x�8��]��d?��m�X2�4'rca��kz�JL�h�Z���3`���b<�1`�&�$eϳ��Z���Nv���� 7����\�CІ�D��t���|�t��l�� ��D����+\B<�z�:�/܎@\iU��)�4�\W��� �ސF�U�	l��z����Э�K|l�b�Ϊ�3
@�c��=�i���<������v�!��I����k/���Э`t} ���7������~���p�6�R��V��&6���0�&ɏ`E�S�#oX�h8�PtvZ�"��X�T�N�^ƪ�O(����� E����r���o�����A��9���k֋R ����krw���n��}]�v��]K�U(xƥC�9�r���Iph�{٩"��F���E��ofW��g����_����]�b�g��@ŔrK)��[��9֦Ȋ��<߅��F��ˆQ,+4�PWZ^RP�
�Y�هO���J�ς�s@�u��T"����Ȓ�w��T�/k {��k��t��N�ڶ�$aw����m�I�m�|WV��&4���{�˽�4��k"���� zꠔ�Q�o��F���QH'��J�	BX��+�Qz� `��Lk�Kq�0�����WFD!d���}a"�¨�
!i���Y�V^�5E    �球��r�A��][TE	�8L�5#��^$�PY�O�ϸ��\8�_�-1
�bS�]oƳ��^�zU��љL�t�4P��,�L��F���F~�,����lf�-��	�]-Wg���2Ȕ���.���;:-0H�A&�teI>�r��Y>�n�&�
�1(�dwt��'F�D1�"�2��%e�"/"�G Y*�y	��JNy�5*���D+�)�<ʟV�.�֫eU�V���[���>��f�� 0�:��]A��+�k<�W& ��9z��pm]�$�5�#�֎����,t��W��W�t<�{�ۘ��K5o��f� �U�f��0qM�G:&+j~�C���!X"����DW�#��=gpiJ��M��԰�X���҃?&���	��_�b�Д��9�s@���cQ��",i��i/FBe�G��nA)���ta����r���M8��߁km��[��Rة�-��A��%=hfk��ϑG��imx��5		C���^K���Zo_�Q����PbXS�4)�FH~����IV\ `R��{���n��]r���y��#�)�`Y�l^��ӓ���2�0S�<!�ˮ��b1��ڏ�+�`��H�������?�׆�Y���%SH���]hr�@F婦|�b_L��80l��^�>ΒtsTF����7���R).�.���vd�b2��m7�v�7���+I����.e\�+ɬ^C�g��%�R�SjE�ϱ~Go��&Ϲ�u��]���;�h�=Z��Q���+ޒk��/��*��Y�(��
���M3��m��a���L�aY�)�*��V`��&��iP�t��SVz$�j��ڀ�����p��bW��GB���b�CP��Ǜ��w4�H����_�#�?�A���Sn�6�ö�B��nʉ����0�v����N�9P�������$�U��Xhʠ�&o�z`��a s!@M=4{k�Kt6��|����5e;�|�-7]���-fD��������+�����dh��Dm��9v��4�!�� ��	hS��~5xǁؓ��j�`]>P����LS���m�<<WvZ����*��"���ִ;:�)}��ly��w�M4BŒ/��dvO��Qr��*D5,�.�&5]p۱y����{+���ٙ��4_���W�N�X�ϒ_��G׵���P�C����=a��|1GA�k�tv��n�� 'ˈ�F� (}M��[�w�u@J��*%c����p+" �(�m�z3��q�9��|�~�9|��b9�.1�����Z#�f�yMa�\��9���UO��R]cߛ?n�o�n̝�v:6/n�D���z�:����{W��T�u���1)��x��E��@��k��Q
L$ԺOr�z�?^�>ß����4B�`c�IP}�k�E�ӡ͆;����`��N�v��w�.�v~D}�=�]�o���L���G:������|�N� ��bAo��~ �^5Fֱ@fF�8���|5T�+���)=Ӳ��� ���\ݭ�/+����Z��y5�����3
��W$e&�OP���&5��5�nw ���mT-fԞ�D�f�!e�P0���0���I�N9jo���py|Hd/�Y�]?ಫ��-��3�G"�N����>��������bB1��a���.��u7w��cH~���D9�-�1Z\Q���)2B�:�o��|	�T�&���{�iv�X��cI>Ə���Vu]]__}SU?́	�cqɓ6˴K��Fg�M�Q��d5*�\W�ݐ���:�g(?Ɔ�\J��,�j��%F�1�dŦ�`��/qO�!r.nL7^�5���0�ˠ�#ʨ�{w�Ʋ�+0.��MV�}������e*6��`~��o���r�ۺ�Î�>_/�q{	jͪ-�'�MIM�U�a�Oц�w�1V���]���x�]��66s�et(Ҹ��DA�rm�%-��4,�C��?4��8[٠7�F��C&w\����l��_�x������7�=�������Ŭ�^m���66�¶wv�{����oZ[�3�^�@!����|d��\C4��iS�����P⮛$�_�gw�׋Y�~vs��-gz�d����A�������M�����Sw�l�ɜ��镡�W�%����J=4��i�@5�frCj5�s5[��:ز���V+-x'�1����\�f�������ⅇp�n��[������W�����Eu�^�_�lu��zqv�:���f՟�� �ф�e[�,�|DF˞x�Q`��B�cbm�j�t.��0+;O]�ӻ�F��l��8X[��I�ρ=��پ^�>�^T?��W��������㥯��������Y���FN{xSv��z�C7��`Zӛ�I�DE�k�mh����ޙ5��Fa�����q"X�߁l��<8X-A}1�(Z)9�;8$)/�O�x��Q�뾘ml�Y�!B��i^��մW�5,n*/����c��A��M����D��`2{.��1A	�%�1zJ���z�m �|�Ef.��i��&%'hj���Ht�s�a�w؈A*����4��V>Fפ�HN�Ơ�4�M?-���+2�Uc@+�8��^�t�û!�5\rz��}Z��v�g6�xjm.��f3"�$!�_��O��D�qj(/�	_og� N�?�^߭��Ku�|y����n����#(t�z��h��{���ma�2Gi�����?�A���Z���8`����sl��!%�f�h���2�1}"'��+|;j�ҭ�>�=�<i�X}��-c�윕�e*�0`�bZE��wpΠS{m(6��-3�L\�4
�PѮ�%,��(�ѫWn���3�۝ž��5q)���HW�i���({�v�������̯��p�hΪ�r��<1ݦϙ�E����g��n(O��ƴ�ֱ�D��i���@� ܸ%u
��sv��G�����K��\�#|�,x	%;��q�Z<��R��A[�K:�)|yF�
�	,w�ໍ49e�G���X�j�����9�L���-�yC��F������������]�}��Q=�6��U��-��q@-P���n��+HI���a�ר��G1�Z� �b#��L��s-v7�b>_�Z�����P��&'��.�/��_R!AW[}8�6;:���D\����(��q� ���!�1174�v�9*���s61���V������O��O~b���CM�j���!T�b����*�-8i@�q������_��YE������m��`��k��2p�	ꖐ	X4NfM��N�P�Ma^כ����=���FwB_���m�x5�Ǆ����N���F�^)B�E{�9;6��+�F�����T�sD��!l܄2Fi7H�G~���a����2�)!5���<�)4�Ƹ6�*,��P�6��[�7�}�N[[�����5�,=P.���A_��=X�پ�ƢNo��G_��k�ɭ�����c����~F�W��<2��C�[��p��X,��+3�:M�&86U��$��Xn9�(�ɥ�$��:r�S�M���&��=�����@�����SK^��4��ÄV�'u16#��f튭�~X��/(��V���k��iN�|lBǭ��1ݨc}Gl��]7|�f)�8�Z���������5jz��N߽��~������7EA����*k�, 񁺕���p�*�����v�Wtc�AȘ�GQu�Ṧ�mm�V^9�����f�KR�S�RM=�D;kf/|��ޯ�K���
�����O���t�f��_2+g4-��K��Dy�B; �i�u��r���5��lDc�6e�����x$p�p��d82/�(���X���{(�rߣk�Wu�T�����y�h�mF*>����?y�~?_��>-���WU�-�՞�>��WV�L��e6*�@t�7��e��%�����Ð�2��[*3d�M&��l��Gnד�o��V�ݏbg��&�~~Q�.��H�aZ�DG�̝�hÑ�0�.��8����VO��"�Ғ�.t����=�Y�1lS��p0��lc��'0�$�D���21� �  K��N�:��J���U��U�Z�nR0�K��s�D	.jWR�FI��~��ݐ5�V`0�^�����&�w΂@
�~��Y�n�D��-6�5Ԥ�S�+i�������v	?a�*��Q�`��wl�H��|�@�oɺ�$j問We�E�(&iU��5��L��Pg�0�#�>1b��}r�I�4E`}��풻#�^]_��9T.�Ɏ��F�� r�實�� �~��8���_u��R���ͳ\��-Q�TM*ز�l�j�R�M��� ��a�qv�Z�>�.i�=��5��!�[�&rn��t4s
��
]:ah]	o4��nJ]6���fz
���xlh�lE�)��ܹהU������DaY`z1�^KQpӚ���PB+�"��D������t�:ә��w�u�G1|+����5m�,g�������Rd������%wc'���df4������bb�V\�m΍�y xhW0N�n���s(�,1��.�<ߒ�4]XL3�� b�7��#�l��q��g}���ԑ�����6����(h[]�bn�l䠤5��l�r�`%�Uǁ;��]�>�_V
��y����M�)*^�[(u��i�^�P��K�L�q6*iMjg���e.�M��$��.=�� ��D{�Hx�g�hnW�ӥ5�$1oU#hP�6tУ�}Vm��^�f>��1U�"0@���.L>�X4�*:�+:#�5���@�Xܚ���rA^&^��;�btڔO��VN-�9�4�֔���v0S�����=	�$�Q��7��1�u3r�����Z�5�Az����WXr��:ٞo�ǂ��h��@��M��:��q�����4tA4��iJ=�'�v���Y���K�v�H¬C���b<���ɱ3�5p��fVڣ�.G&��lg܃�;&V�F����W�ֶ{7�b�h����j���|1&�������3�!{y�'��J����)Z�3�t�nƋ��6������U��ILr��1.
�,aK�'cս����J�U��sCN����f5Y��a�����|�����]�м��l���)�[��0^��C)����-�J,&��x�{��E��p��؈�.��R�bF��&	5����-`dZo$#q!�&QRq	׌�r�?�
��>�z��`'����׋���˖㪱L�"[�S�6��;�<l-La� ۀ)�7?i�nA�48����MQ���jz�b+@AT��\�2{|�=ۆN4u��9*R�D4�DS�(���"p����D'�4un@�q���m�wU@�������--W�o8�#, ����b e�9)���'lMH��2�d���C�a]�/%V�:���:�\�Ϯ���J}UQG�6��������)#n�llP�vqD��OǊ�o�-f#���TU�/�p��\@�����LJ#<ڮ���bX�gt6j4:��u9Lg�<��q��C����-�A5�/.)�*��A��}���Y��3�YϮo�`{s���Ax`��T�4���}b1��i�k��Zg�M�2�ʰDE]�8x��lຝ�?�V��/X��nuy�͘��c���}��aG�r9��@�X��`���Ⱦ�A��V}�|�q����W�������s�תz���3��V7pa��"_]}�ֿV�?.n�)��U��A"�+�&,��i���}���ׇ1�u�^��+j�����b���g`VWW�S�d�lZ�l|���dl~ӥ�p�]o������zؙ������C��X��ۨ�4�/�=�ȟ~'�)+{3�J���j��_ͪ�D�s���,t�T���)�;�tؑ�0�\���P�Vi&�QAI�9�{Î	����4��5v[<�W���.��h����w7g�[`*#B�ST�����q�9B�;�n����]b�ѱPy�)Y��P���F�a�\�kk�q�����F�$1�����FF��?	������X\����[ZT�֣��d���̈́vZ?���0��w����[0�G� ��\��
��'wD���V���y����z3(1�
��Fi�u12.�L��`���ޝ-��#�8�w�!�����ai�F�7El�Q�ofW�Yb|��/ǣz]4��.��v,�4�O����^���F=ڟ�כ>��FE�8zt8��zP�.nQEM4��n�[���5:0T�'[��?'��_��D�      �   O   x����0��0L�8q�����(�KAL�
T\���6*x�A�gC�G�c -hZ3�*���r���w8��>$?�`      �   �  x�͘Mo�H��ͯ�®���n��5�� C�4FDC4�����o9	�m�m�	;B����V�����pB�b��⮈������}�OP�^P���ԗb�O�y�O'�lz���
�u����������]������/_�0;FN�O#�����}�T�y����$�!��3�.F4�оi��٬~N�?W ����|��[t�Éɭ\6%��UV,.�,Dop�1��� Bƶz���\R��e<]��O]��q�}�!9��m���LڢXc
&r�ZB_W�w
�?����j��S@� M�ٞ�����r�|�n
�DA������0:5�k���v�+�N�90{��Yw��<��P�ܼ/-�n/p:n|/p���pn�"C|�����p����ܦ7��:�R�����u���X������Br��lAݭ~l��QM*�Ps��1()�e��'p�U~}9��}+��
���f7ٴ��\�&J����= .�%�g�{ũ���j��܎%򕸻��9��4Ф�;�,ܺ��Lm�%��A�!�}jdBL"��F��!�U�m��k�J��e��2ݘ#m���+�N5�*y_cT����Ѧ�SґKڣ�!�d �&a}[�(?,�%�K�)#dBal"B#���e�LR�$Wڷ)�d2��a�P6�^+�n&���v�+Dx�y)�
�2�=7���,/�۶J��κdw����|�XYTA9hl��ņA�]Isi�%ܖ�Tsh+�[��qhY�u��%r���bs:��u�,��,q��o�<�cm"q���
�	{�/�j����T����W�|ޙZ��k���޼,~hT-��r�~:/�,��������e(��r��R%3����Qf�3I+#��꜌�bE�z��>>0�y���v�]��n�?�.ÔM�Gε�(R��.��,�f#�����%��Bj���0�����F�� 9<�      �      x������ � �      �      x��][s�H~V~���fj�J�/z`;�@\`gg�\�Eb�cC�3����t��Z���ablvY���w�}�i�> $�w�_||Oҷ�N�������NZ�����N�;������>�%�Fr~q��f3���0ϗ��$h��0���I�>k���O����/�?���σ�C�$ `p-4���hN"�����d��h����M:k���������8�������8�	�j`t�T�I�e�Y�%��܂�g�:����R�g�x���'�?���1CUb����ǚ��������Ⱦ�;RL���4�zT�@�|%�4h���`�8��5�����ǓQ�|������d+�\��O�?o�������ۤ� !���@D��D
泋%	1���O��օ��e�M_	Zi �<&*�L�@����9�1��^m:���j)S��v�#]L̗1���cXJ���e����Ό������3�йJ.�Vbav_Huk�P]�1�1ӑ<����<�Ec�c�"��A(��o��������:�q�^� ۥ?��t{W�W��ϼ-�����ac�݄��� l܎�������B�+㚦�T+�#�P��7��j<Z�=�Yg�wϏ�Y#!�P��I�irv�=B�	�<� 
#31�%�̚�D2��o�W�d�XŌGZȪ$��LRY8�6k\�>S�ĥk+�4>�_�%H���g�MN�ޟ���J�ã������9C�zZhL�%�0��� /��&ը������uE�12�W�,U�K�%n@F ����'�S���3d����7���&.xGr[��i|HZ��,����WF	�SL9k"ĩ�Vt�2��/�T�T�Ào���j�%��z͟�!�1�1����}:+��FѪd�r�VW:�����)Y�%��	U�׳�q��˟NǷ��5L?�T��b����@ä�V�))���^ܤ�U��e1�W@���|�����qh��� '��R���A]�v��:�of^��6��>L�S�0̲.c�	��JM?�I׾���0�ϻØb0Ɵ��zM����h��ϻE@�Q�P0��<�
�=u���<��V�L��8�Х'����ѥ[kY�TEL������`t3}�������/����W�ƒl��>�����~�����7�W��E�����H�C�Cp����6�<��Ў�S��d�U���E��!ɟ˕'����@sf����0t~�?�&g����ۯ`L\<�s)h4��*ójθub[$)Ld4u
��rH��^2�EL�U��rM�3RhC�	zPD&ler�h�`��g��2���i0�������bH	����Hn<{�o��W�DK��>�Ө�JV]���g����
�-��|D�1�6�'�![g�u&l2?�"Ǭ�e�U�e��	
�����a�7IY���{f����F�I�ߌ��X���.E�E�����%��������I�OΒ�sy��$�'�x������,v"$G�j.�)� �X@�B<�jq�����s"��n׉P1�a_,�݉+�f���?O޽���v�	9�8DHs�k%��&�N��y���x�e�C��^��}
R�2Tx�����p?M#��~y��;�;ݺܙ��oV-��K���+�nG��=w���Զ�^UhXd��J#k?z����8>�Ϥ���ɟΫb0����
�Ƴ�Ȃ���Ė������a���q��f0	1��'û���=���u�?�������ম�M�x�����K]ڀyl2G��W1�aq�#M�1 e�"�6��ʩ��3fvY4J����fXl��G����_�u���O���	�Mŝ?.#�^��ߒZ)I7�Ύ0���2����L��U�U�/W���S��	M#��6�2F��`��ؐ��xU�-}�<�Ǿoú :߬�=��Q]!��&^��#�L��O�X#�2#�kd�`�/f��.c�Gr��
06�s�tN��]���k&�6�R�U���w��e�/u�$���t�VL ���3��*Q�ÓM\��a�j�zc=���_�^�O�ɰ?z���
 I�!DSi��S)�>��&}����\���S� J �fMdF����~�u�[�zt��0�>�b."V1��8�#�Lhjѻ��!�Yr��)�i���
2��� (����	� F
(U�FZ,n,>5�uY�;Km���f�T�	�Ir�k��=��7�~$7,�j�D&F�5@/k@��.dL>?K�㝸Y���v����T��N昆��ҟ��X�[#K?��Ӣ��ҭ2E2��u ߹}N�)_��sl�*�LH,����"`�?&1���Ӹ����{�SN�\~�����ÿƟM�fͭP,���lKtq]��U���z��uC�:ϱY�iTY��o=���zG�7�U���7נ���-��j��1�8����	�an�5]��'����:⚮t�d�6K�~I؆g��~q=�$G@`FY0�_��H��^�k9釿]}��[D�fg
���2��&7�r$�Iɞߤ�X�GkPJ:k�3��f ^�E�L�E�YI
,&Ȧ?��5?�/��ǩS�G�ze%�j���I��a7����s2�eP��瀠I�ݤ�\��:��κV���Ƞ>��Y��1%�b%���������vR��#.�
��R~�Kv�5���)Kg� x�C3V�������C^F	��X���?r��X`��ݖ�6��G�ŏ�16�����j/?��k����2}�Gr�C���Bj^�U��S�� Q.�8+r6O��l���=�O�ߔM.1F��S���k�km�M`p���0;����Sn��֭$��4�#7��<1٭�_�R��p�3#�� QO#�q��԰% �n� �y�뷞hg,�4kb�`I�6��O��P���Zr�;R3�5�ab���6���-���+��*��:�L:ۈ��ELK��H�mn���_���3w�Z����@���`�F� hh!��+�mϬ�n��&��{�c�u)@±H�VJ��^`�g�F���#.1��n.�Y�
H1�E@�H�D�lu r�)0n��_<l��	[�E������e�Lw2f�%yaw�؟�/��r�X0R��L�`(%RE�/nR����u��vֺ����<FHd�lyr���k�p-�h�6Cn�𦎖ꂷ�l�f.N;�MCO&u��j��ҴBN���l�dZ����F�u����q�����|z:�ؘJڊ_����R�N1`�e��V�5�2ò���R�#~YN8�{�-��K�p��a�{����S�(���F�¶�M��Y��E� �:I�@$٤U7����ok�m�C0��[�tD�b�jY��)^TYĒ��{�,��.gt�G6䍾ܖx.��Ygts�ED��� ��|��E;A��� ���HX�*.+����l�e%%iT�l
��.r��#�Z�\o$�%��	��.E��#%�W~��׿-�Q� ���"BA� )Q��j9��O����Ko�;f2ׇ��U>k
,��X�q6��>��4$4..��_���+��ͳ�^v�c+U�A7�{��
uJ"%wi���gv:�ܽ��M�T�Mg��|���0�S[R ),����`A2��I��8Y���5��6�)��:b,�ejʲ���L����]����f�vw09�/t�2���+��V����J��9'�e��n:�2��i���.��^��p�\o���'\�D��V5�iL�!
�V=V��nɓp�͔7߬������G��7���H��>ծ�/(zܚ���N�e��7�v"��7����)�l���(v����?�99�(}v�����U%�m���:�Ds"}@��m��4¬8X9���aEM�J�b`�-�ru�<�G\X�����ut C��'�%@iBJqD�ƿ{]�a(�2��t��y�����C�� �w����/����G\��ս���4Ѐ6���`�ו.�f?S��d8�@E�{�M��9��q$�SS<Jx����ͤ(�z��3����g�K̻7�v��RN� �  ȾOo�>���6�ިF�h��̈́z6ߨ���m?�E7�r
p��J�삝�-n?�@�\> ��u���ʙ�F�D��Q��FRW��� ��a@:ǭo���q�g��q�dd�(�4Y���� �Msyzj7I��V�Z�K	�e�;��Mw��m彨^�K�Kۨby�m􀲥��2�#�7"�����yӶ^��,Z��wOA�MK�g�^��t�Wu���F�>�r-U������R]ǈ����x�y�8/�ڸf���d}%�	��{1��%~/ws�
�s�F�{�_��<��1<�묎���>�~�����>o~·��|&Ԋi$��"A��o�b��=)I[{�}>�k�`k:@���4���_SmN�eMr燫�7���N�e�d-�5���uA%�#5ۀ��]U�G�?�^���*����ܼ�����a�j@zp�}MPB�5ALF������j�xи�;}>[�1�#��Q�ذ�1�_�Pv0�i�65�4�����#��6#�IC�x�
�{�m�~��4�VtN:O[�tی��Z��&|���*���B_���m��6���_v��Ac���X��G\���cR�گ�%B`:����8`6Ƕz3�m����Gn��U�]�)��v��i���*����"}$P�V�$�� �����4�2h\-�Ys��;��X6a3?�_��z��-V��}ܞy��%ɒA�o���GLn�`��y�m.�v�4yJCm&�1h�Gc��a���q��b0		�����[��:<��ҳP���u�6��;��҄�t���6�aY��t^R�yZ���Y�_6W�	ɔ#��W'��n��~��ͣAZ(�"t;��E���-HI�`��A���sn�ĥ�*�G��QS,�+[��CJDs�Fv#����C�=�ʚ�ZV�9O��Vf�E�d-u���a��)�GG�uO��O��:z�������8      �   >  x�]PIn1;K�����ȉ���K/R���&9��"%S́P,2�$�T��6�N�%���yk���^a]�4����G��2�2�����d�ذ�z�Z�G�,���VB���ۥ��@36>�u�6;Zn`��e���|$��D�|��ъ��K&��*���%n�X_(�tD��]E��D	ѳQR��a��Yʰ��	B��=Q���K���J:n;x
�~nu��vlz�Wt�A����>�zW듍��b�3U�h]ܲR�B�!�1ԑC���`s��Dn�RP�|�ѻ8{�zy�O6z�֧���Ŀ_��̓y�      �      x��\[WW�~>��>�ʹ_�VBd������@��셡����ۧ$QUg{T���t ��}�.�?l�R�wZ���Z��e�2&q�~�X�=?�?�T�o�}y}z��b٬�y�^��e��6+�\,�R�y�N���������m�>��i���?�^�)��K�飭���M�_-�;%+f�Ό�S
�"�M|X/����?}�*E&�d�3A6�ۻ��<Zm~�r�b�>�G��Q�ΗkD�|H�#��:/�0bU)7�v&c-�D,ː�������}}~Ưx���}y�����j�t��V�Y_쮪�k$�m�g��E�^\.����>	��?�ؓ���h�&�+efO>�I�Cð����3|h[;%���r���B��q�I��fsH��r�Q̛�\����%�N*d�F�*��9��&�xx���3>���	L:RDa�W�H�M�/����8�)���2���L���~�i���@{� �N�_��u�\k5Zm'r�m�]1Ȗ�©q�f�1�dkuH�[~簓��D���NF���d��V4��Gf2|2dB#�l���FC�$�t�9m�N�\/5��Ms��O��ۻ���V�i�]����3��%�ҠBj���N�JƙU3�0KLJHO�'���B�s��_κ�]���b��B}���u|��Y�ʩ�S*f=ͤ��T'��YO��ę33'k���J���U��0��F�4�����ͪY�5(�����e T�L��h��1`>�����&N����r��G�Ŕ4�b����dܗh�f[m7��9�TOٺ*ؘB�u����ȕe"���K�~��y�u�����<���E;��H?cB�I�`�O����I=S�V�3S�A9�$!�ӒX=�"�ק�ۿV�������w�E#nvk<t|?~����aט�16���v�V3�&p'�R����wIB�g���,���ۯ��Ϗ���}��c5���H��g��_���kY%�5kf��ט<��\�>� N�=lfQc�^ '��%6�1��xt�T��>�� ���S�dQ��D���S F�xj��r8��fJ��GZc��=-�d�����r�Bz�4���t'�΁0�M�m���>~�֤����$.�4S��{��Jɀu�(S.�q������g�����
��)�X�=��"�0�PkY;��T,��, ,�CPic�-3�`�>��m����2��٬c�0�:����j������K�H[e�B�TrV�X
!�<}qÅΰW<n�?*��35]f݄����	}�Q��.��}���@�آ*�P��Ǘ�i�p�`�\��ֻ�j�����_<l#m�:hm�3�i$�7�g<@�eN-���:�`Wd��?YM	� &y7����YW���f������B)��� �ɝ�k�������V�Us	ݳ<�-h���͈M��(lk�ˤ�t�0��"r	^���i�������Dh�YW���k�罼�E� x dE^(�$WIkF�Y�!B�����?Ҙ@����VO��`M�mu�>>0b?�R��t5�H����f�ӎ�j���ÊB����"�%Y�k4_V}���3嘒T�)�gȔ��6̦u�A�a�b1+#;� m�mG\l �	���A�>!� �����CF6��c���m��pĨ]��;W�������]s��?y��1e�baE'u(��3	��k�t�c �YA$�h�}��|�g�5{�q�>9[o;(�S�=��A�}m��զ��b�e� �����\w�#�g�I$�}�XY�D�l��L��R͌��
��)0��K�-=���^4�v�f}~�'���K/'�DB�����Z!r���(��2����
,��I�]��)S)����G����I��a2:/S;��6Q|03����Ay�ah7w@O��OV2��گ���[Np2<ȃSZ�����}�d�ă�;�Ɓ(����t@�1�`��L^��^��=J��yOr";JH-KR#'�6�ю�0G������\��6#�LLc�4S�$�Qa@��c��t�{��L�9P���X��ꘙ�ÉZ[;�N�ɯN���B�������Rrt+��/�M�M�X)(�ƩeN��А�s�#L�0�����L������ɺ �6��l1�����CN�ȁ�1``�}�f�����lO�A6�V��Y�N@6bT5�˜�<���Ѻˎ!)&9�1��bv��E�"��]�0\��ׄ�#kjǹ���ɀ?ґ9�51�PJFs0M�O'�Ǔ�6E�+���ȝ8F���u��a!�����B�G�g<@�eF\L�rؙ��G-fF�y��$�Z�!�H��'N�KB�+�͎;�\]�_�W=ݲ����ݷ~��Z�,j�**d��8['Ηp�� �U�� s�|�β[��O�K����ڶ��^V7W�säWM��IY%rzU��#�ҩ�g�bLSl3� <P��<C�FCsp���B�;!��1֔��I�;�1βp�v��t!i��5��p.ڧ��o�h�� �&� M��������Fʰ=#��XO�4F��7Zr<pq��K�6K�E��|�a$Ci<c�b���Gb�3V��)�Tz�JO��621D�l��)�F��w�(ao@��
K3�L��zj�|�\�hK�4�VT��Og�U
VE?4$�ΆD�I]K�Ն���_F �L6$�[Jξ�>�|}xi�r���:�G
(��COg�B*�ך;��oB@[��B�M5b/�b7�.d�"���v'i����]u�l��g����3d~D��!�9��H�(��@�u��{ီ)��6"d����m�7�:�p:�䍗I��$�O<�̬�]heT8��1��Y'V�}���|{$�J��\�3�27"����d��$� D�Q�_�`���`ʦ�������B��<_��������COn3�Q��KG>=A2��p3�S/3De�Mʙ	V`�;O���c�s7��	�_�������N�z�M^I:{G�F�\I5LT�{YXr
42Uo�Fww���Md\��,#���y�����������ĻS�^J�,�W�z�))��F��V���̀zK���AR�Q���`�����E�I�/��us���z�V��jJ�<9����]Vh1�j���ʌ���o�h��MA�: }!'�:���i����^]5��
b�����;�7T�xzc�r�@���4�*��bӣ��/�XrFA�`��L�NZ;2�щm3_Vw��jy~�?k�����Ŷ��$�0t�L���S=t�Ta�0��s5afPp�Aq�N>Э1M~���ayC�n�����=��l�xaEF:G�j�=�4����a:�a'���2���&�Y���~���O�#h��}N{ڗ-`�� � ��2��yA��2����o�6w�zS-�j�;�\���oW�wh;ȋ�(���W�r��:^������&K�IՀ,A}p�O�������.�2�DrY,48�KGuti �g���8k̈́���(��q.�t7]t 9ara�G��-tٞ�)F}��{r������dy�Y4�fB�*��@�����i�uu�x`̃��!F˦KA�2��S���{��G��xO̞V����/����Ҝg@�- K>/�a�:9f}G)�Z2(U�B��W_^�O�u��<)�CT������\�V�e�܄I�j(�a]��ǣ�K�5�'"c5D%����=��x��=�����U������@�{���$��|P�^��$S�l)Ib�S�� �(	X��M��G�Ͽu/8
�N�<X�L������c&.c��9l��� �
�wj#�6���χ��t��g�hOþ�q�a��y#
�ق�q�`>P1x��р��G����nn��#1�o�u
n�QߢN���{�������(�I��������c��nί2W�O�ϼ%P�oP26ڠ�7���h��P;N�Fգ�?�n��̔'�us��mn��x���������,�oՎ�D�G� c���j ���c���F���>M6�e6���eO�&Yfl�	���3 `[�n���w���� �h�L�Mܒa� �  *w eZ�>2���^�I�:k�[I��<����O3s<o��q�,��+���I2�*��k%Q��5`NR�}��p�h��sOq|�겹]��5��VS�
�5M��L)���W�?�K�����L�]iP̡yR�$�#$Rj�`e�XGfq�y���GLH�4!ԓ
ÔB�
O#���$���kX8^{s��4
|���]V������v��������cm�i�)[|�"��f*�PF�&� OHB��T?�>���S��;S:��ӧ�H�ؐ��e-��fГ~{m����ZQZ�S�"�{�ݡր���i9�򑗧	�e鲌�q4+Y��&9U���b��!���^�?�[�;:���(A���H&r���Dep��>g��4��G�3J�9�?2�}��/{�O��!���Ĩ�R6H�7���a0;>��	�n�yu�N8�`ϖ)�	A�_�]����V�m� �������� /�{#��·��(��d\�a���d�ѐ!Z{�M���H���D�]�r���m�[2~{o?k:�u�� 4l$W��(t����^\+��$oCf`y�MJ̧bք�y��k���}�xN��B/X�F����-��1��Q�Ì����� B"��1��|�0��]||x�����'��.t�o�#�DL,��f�D�2�w �Q�ř�ٌW�[�y�v�������Z�a�YQh�u<b�)�ދ��I�]=�R���O�rw�      �      x��[kS�H����+�}����|�S�����3DlD��.�¯�{�_��dca�kw���.%P:�ǹ�ޛ��Sr)�H���iv�~O������&���>��w�d��ގ�������M�ɟ�2�$���"����j��6��&߭6,���}�!lS��0���?�nƜ��[�/���9|{�͖��q�=�V�.[>Ͳe�,�],���
��|���b��]F B6�n*c*����g�k�ٞ�d���q_<8.���r�6�kxl?ys����/w��?��G�ޯ \�^%7I#�=4����:�_'8�>f��N)n�g��.X`����n��r������3!��������}��b��[��yf��6����k6[�>|yܔq3��3��r�r�$&}
��&u��n|�tڭqq��v�;�0@���^�y��Y)/ a���mrI�O1�*���Q��� v�I#�JF��KG��9��
�`��f:}����~L�_p(6H:����n������N��u����8�ϣ�ǟ��=x��W^ʙ���|7��j$ϛ��l>��0��q~r�5�j�9[L��n�(���>����'qh��4��������P�7��Fo�P۽"5�K���	� 6`���~�m���?�����f�v�.�6��d�w��Cҧ�&p���h9��QY���f>���N�?.�59oryYS�H�0l�I��t8��w �kJʆ�V'��'G�	��Z�5�Λ�[D���2iʆ��P�z�+��
&��eH�~J��W$%{��I/-�Y#�SF��6ʶ�|�M
@�b&&(Z5�x�:ꊙ9�I�-�|2줍���R����W�96��q�F�b���J�}3��6�)���ò���w���N�����j	H+�L�~��L8v���t� ,(Tqv�:;��bc��a/�b2�.�%��q�sTx��`NQT0�
W�n��܎G�*�'Wi'��s�&ccP�6˳��j1}�刋�OBE75����5hL��w"J;o�)����w~�"Y%堖�K6��>�I�GR�D���10�uJu�D4D ��2���ǈca��l��I~���m��L���d�(*�<�U�=��p7�v�<��['m�`��ip^,��l�߬f�n���"[�	*@B��q��AU�
��p����%#���f�������x��P��]v�5Q2(�L\6jD]hǕJ.<`)�t�����.B>9<[畒��e�J�v=N��<���ᤉ��E�ԄS\)q̐q�D�hD��-�=
E��Hq�AR�B���Y��v�k�) )�����T�FŐt�Q�4�h|3LQO�V��<��E0)G�;	�l���_r�	����5���C3��]�nt!$6��|�Cg3�;��|f��Z��g��-�P����S\1>t$|��*l����4T��T�U'�eI�*�&���3�d�i�g�,��7��H��nJ��.�u�*�[�O�:�'�iܷo���<��Lz��uO��I:(2P�h\d�A)D��(���qS��
�Ǝ!K�v��}�\AU7�:VA��I�D�g�O稵`v��I?�>�M���*Wg�
�ƞŲ�m���� Uȸ�{�S"C��+��]�����]���o
�TS��
*���d��Cυآ�� �N�;�Χ<�Z��T�j��
CQ�-?.5�d
u�<�ܿǣ*��9��M�h�;�V0B�Ĭ��)��Φ��r7��/��_l}�8  �kpT(�t����P��[d����ya�G,��9���j�	�.��!��`
(6�@��a��8����?����UE ��zA�v̍�EAق�.�NH)�k*��p�RI4� �C���܀�)����Cr����v����ln��J��u�
g#i���UrR�b���.�~;>��\j�XQ�&�0\v�m�T�jYWS�U��ea��AU��sKOQ!�`O![�O�t��>�DP�H�:U(P9� ���s��A��!�+M��F�`�l�K���0IMl#L�
�&!����ˬ�={�7�?�s��Z-��W��On_��������uR�(XU�:��x���>�W��$iSԨ�1Lռ� J�F�HׅR��{���N��[W�N�t�d�IBT%t�	�އ�B�Pyrl�>9�9]f'U�}_h�R"LP���) �BtZ2EÄ��X}�8E2����p���#<�/o'�`���i`�Wՙ�B|:fH��t�"���oc4`U�(Pbڰ�$$�'�j��F>�u@*���կ�����IYB3��'���ƚ+Dɏl� �],˖��"c(��P�ZӚ!�^::�����{rݢ��f(o��5�3�����%�LW���QiF��:cTT(�"��ֲ'��*	�.�Y��I$Br�U��R;ʛ0ʈb50*�-C��/Y�q��$�I�O��\�*���/\�3^_��:���$ZE5BEW�5D�1�5�i1c�EW̗���ֲ��y���'*��.���&��I%]!S�2%������l�rM/5D��4)8�-��.ח�Q��Z�.�+\k8C���[4Q�r���_Xw_4��(�yyD!��:FG�����G������U�1:;WCr�B�h�Q�+4׍a�|��l9�7?�!w�:��2��=���vMG����qa��2�k$��0.�6gtG]�=�
�pF�R->���4�wӧ��u&�1�JE��2��n{D�q�)맥�+FL*�FK��D̐R������&yY���T��H�f��k�r����`R�B�\�C��d��,���H���嬲lM���C��s�}�o$e���!���.�8[f�񐈕#/��Wք�Gd��@h�견R��fH4K�'��I��� ���떡 +iK�^��蜶���|��\��
�]���,T)W�0�� {��Ca�֙]g���O���J�v2�l�a兔�a��ƀVi�.�+E�X�0Jh�\̕��,��c?�g���B�q�yϵ@� ՙ=�^��K�)�'�:.��\�R��c�AQ=p
23.s@80!�k�@�"n�����mX0�C1H��f*�*��~�5\'�^�")�\���>3�<$=�W�s*��7l9Y<�hٸ�.�j��"�ݧ��[։[	e+��`�NP9�	����g�):C�VDPq��]_��A0�} �r�Jɰ1�#0t�:�������_@�h2���tX�B��B	RS�l����֢�hƇ`���~����pB�qd�j2�,L7��e��Lf���,IK��&ݬ<�%��g/0�j3mV��zee�?<7B'z�/#���/ᑬ����m�EE�����<�Q�A��(nPH��u0b����)s�u��6`'�E�)�.>n2�:9�;JX�9m.^W����7�6�1���.�u���1��W�8P��U脴��:�Y��Z E���6����'�"(���q�\
r?`�N��0J8����w�(~AC�٥n��$�F�#��j�?�dh����qI�IM�a�����*��FJuĳ�/��'��X�f��G���^�Ѩ<+���� F���i��U�Y h$���&�F؊�B��kY�t�fa��(��><|�YC����=�B��4���6��s�1D���
h+� �!>�w�i�E���;������0�9����l���Y6���������1^��1|�=�GZw�^s֚��Ã���Q��&�x�|�䃘+p�#_�,�Uq�A��a��C��v��ѱ��Á7$����G��z�l�)�0���Z�H%[�g'�3(/;H"��8it W�TL2��x�,T7�ah�����-��"�N9I�ځ��h (T��!a��Kx-����3��(d}qF��cɞ��=��~�M�l��b�ZRp�nK�*2	����/;�n2���6$� ����f��|�&T(��=�_-]Ru*�U����$�=����������u���g��z+ƽ��o��[�E��Mԃ��N����m��hi��d�n�U�Th��ˌ =  F���v�t|E>����ޘ�ڰ�b�{!ݾ�[O5�%�a�nr��YW�[�b�K��������y�(VO�5��"�+��?��W�|9ɳ�EkI`W����,vlH��1lw;%=�%p;��7�.�*[/���E6˩��V�ն$��]�R�ã��`<�kl�����U'�Nȍ��;<^u�7�r���h�u޶��#mj�=Ry�d���R^��'R[+�-�U��V�Ξ��ȶ��d�rȠv��\b1�	c��c��3��v���~�<~�g ��;���҃Y�A��F@���l�>����������c�j�p
'A�<���0���֠�F	ϲ�Y���������/!(�6�L����;� XR�K
�GԾ���q$,k<"\�cԾ-�jی_@d���r��+��T!=� "�pE��J���#��W|\�t��]X�A&��U�������̦�����lӪOS�6�&��_gx~G��x�6h N�f���hi����	�O���`p	-�z���|�Έ[�Tet�_仲��<�"t��%46$�!_9[�v�"y�q���)W~e�G�+W`�0��JЅ��S-��V�y��@������b?�i�Y{���sd��.u|7�͸�J�0����Q�"���Z�}�I�����$_J.>\C���A�����v��\�o�CA�ai�-�(��n��47ˣ�bw��j��55Z�:H�9$Oc��t�.��$۲y��g���ˬ<�Y�W�äx\��!�?�����?�D�T���~`�E�=hm���a�� �c'T��L���$�5���"���|E*#� ��pz�;8*9��qp+�=��x 9D��|�J�^���&�s.�a�H�:L5��\�1�0��1����>��ʓBJ�9����������� 
գ�c�*/[`��v�QO���9[U����o�������Xf�:ruJ��w�X��܍t���#�
�㰸�{<��p�J�h���o�Yq���ln�������#I'#%�:P�E�vL�q눆����V��zr���a����j����?�����X�j��G�4j����q�=��gI��B�vH�'�{�Ȋ�R�Q�4x�r��2$(��hYU3^��W��.��j-�4�-��V+c �C3x�L�P��� ����8LT�aXr�[8K
����i���kn%"�&7Qݴ��"2�rm��;^W��~4+m2h��'��Pd�v$�������ˇ�D�U�"ECߚ� U\���7���lHڸ\�*ZqF�U����Q�|F���$J!+)�#So-��E������U��      �   3	  x���M��(FǙ�x󎤐��2jP���:q������7ɈN�#������3�a���/��ƿ|���C��rEr����t���ο<-x��'Ws��h�Y��3�g/��O� ��{�����?T.���.����ǎ���:�\HQŹ��2�GR<���!V���by�RP������'�d��`����+�K�r��9���Ct�.�;�]=L�����g%�}�������|��4����r��jC/+��,8�Z�{T⊷�7m�;Gr�-*���GI�EGY�z�S=I�寺��qw��{\;�:jW�
�z{E���÷ܽ��(�'���Z��:�(�AS�U��z�t1I���ez2d�q>ix]�,WO�e�n�(�t�(��HI��W�\=��K�W��HS�x:eGML��W�W�^L�)�T��0=H|�1�x\��@�&�ƞ����W�9])J�Ų�=|��ȹ��h"�a���o�)��3�#g8*�7�)��x:��nJ��۪�'�L��J���sp����%����=�ϗ�OHv������j��pp%+GJSE-��4
pa�SE�H�Ț�Qєʤ�JE��A���)��t�uD��DfmzOmzV�D��{
.k���:�,�=�Z��gZ�U+׹��8��1��b@[��p��G>���{�S�wb��XitIIj��9�l�ca��L��礔�������v���0�x���y��x�I��)�I�������i��?,�"唴����?~�E�/���ݟ���GWR�~7o���+�7�w���U��$l�J���}!a{Z���[s��6�lRׂcV�ʘUƬ2f�1��Ye�j ��6�>k��U���D3Dg�.]!:AtC襏�DC.	�7A.	��"H�y��d� ��d˥�2ܒi��M�t����-�n5pK��[Nu<XR��}BY�^i�g����5��T�ǞDv�Ҋ3�����3���0�A�����1��ŝ0���a�$,	K�0��Ye�*cV�ʖUm��������e��-�nY��`Y�[d�'�}�՟0p�?a�X���a�	����'�O0ҟ��Z�+���&,y�W�������y�W��	��/��#nY5p+�nY5p+g$aI@X��Ye�*cV�ʘUƬ2f�-��+1�-���F�����M�=�k��_{��ھ{����������/��4:��A�ܲj�V�ܲj�V�8ȭ3��[I`�V8fu��?��խ3��cV����Y�:�8fu��?��խ3��y��ּ����W5|z��㘗�f�]z�_*��j��	�2�Ux�g�^0�bx������nYպ
���7�e����1p+�n%��[I`�V�eU�ٲj��UƬ2f�1��Ye�*cV�ʘ� X�4�ؠq���$��)�����q�X㊱�c�+�W�5�k\1ָ
@㪖{�MNz����j�{�8#��L���|?�şS�Iz�A;�\����+<`8��@��~��^0�bx����X�p˪�cq'˪�[9c�F �t����H�62���:͆P�6|��Ӡ�m�4h�%[.�s��^�_�M��)��I�oR����q:F:����3�g/^1<ax���!�7�%����f���!,��%aI@Xf�1��Ye�*cV�ʘUƬ2f�1��Y�մ`���8u��|�W�gzM�3�*:ӫ�3�
:�kn�����
\ne�LC.��{��n%�LC淂{�!�[�=Ӑ˭؞i��Vj�4�r+�gr���3�܊��ʧX�*'�f�W>�:�[��o�3�u����1:�[��o�3�u����)�Ǭ���8fu?�v�1���3�Y���q��~��cV���Ǭ���3�Yݻ�gܲ�����=�U߻�<߯�ؕ�i����3��}�^��������p���?������߯��G荦~j���?�c�7f��2�?з��Z���W
W W�w�mj����>��4��}�ߦ5���_�t\�չ�������2]}�<�'�ZM�����/��z
h����}�<	��+�g��lƵ�������3���0�A�m��[V�;aV	��IX��%aV�ʘUƬ2f�1��Ye�*cV�ʘ� X%�W�U~%�g}�!{�Oc�eb�3�v4�<O8�S}:�.G���=���7�7{jP�|g|[G��myƷu��֑g|[G��myƷu���|g�����8fu��q���;��}�w�1����cV�=�Ǭ�{�3nYU����U���e��-�:����������k�d%      �      x��}[W�H���W�_�jO�/<��\��Ń�fk��+��*�*�P=���?_Ȗ�lYv�i�.la%�B�}q��7L�_�����`|P��^_^�N>��?-�.N/w������_Bz�봼�ğO���n�3�q�,c��.����9��=<�(�8�ߟ,q6��Y�3/�5��f~�������0}(Y�5�j�Y����������r��3=���Sx�>�/OE�����o9������f���9d�=�v�����/��������*6rR.^W�/'W��}��o_Cʯ���Hgu!��N
]���֜�,�Ϣ�B2%"S>
c���
I�*e�]�#�*c�$����!&�����`V^}*ono�����P9>;�1%�x@\�0-�}�Z�����Ek(�t+.�Å���N)f�/���G����۾��Jr5RڭJ
W�+)}(�!�#���VIq��Wn4S��#�0��D�aLk�+�]�YL:FQ�Tm\b\gˢ�(�s��*y#���2������਼(����o�of[��㿟Ό5�d���v�s��^�������5kx!L+8��"ٺ��юy��o�9W�{����k��{��o�r|ߔ ;��?�lĘ��ښ �!d�!��*@|��^uT��<���r0���Q^M���=��<��\�����hnφ���i��������c��uq��K����K�e83�%�������3Ry+��������RF�I�C!F܋�rl膂!�#%�������.?�����8��?֏1������,��^+g4~�
�l����c������-�0G����9dvS^��O�\o'�#�?2x�[/�6�.���׃6�B�Ձ�#���:R8ǘ嶈�9����ؽ��gP����#�u��R��n�I�r0q�
�a��%���O��,n�_Of���.�����|^j��-Ewz4s�� ���e�&����ӐJ6�(\��J2��SI˽��)���vo��{xxy=>��%���pfUxrMv0��K�]�s�빆�Ϳ>��rĸ����hrq2�9R�_ 4��*4_j���xpy>��n��|�ڬ������M��nlË����_���ן��R6CfT�C�Fζ��{Q6�);�|$�vG�����*/ea�0��JjIS�:��J}�IY��K�>��BB����Zk����9�E����Q���XqQ^L`!��n�yYNN/p���vE$��[,����-���}k ����~-�������=����^RSd"� d����	�B��^�_�V��O0��f�<��#$d,f��<�*�"W�K9�(�5�&u�e�d|wsV�\ݞ�Lo&�����eyv:�J�OC
g��!���k��~P�|�P8"`���98���0�|���J�����s=�3J?��j�S~Я����AB����Ա�Q�3<9J�U�l%�.�c���~)cr)i���"�T.�����@g{��T ,�#�(n���-���m�{�X�ߟ�n��W�E&�qo��:�����ŏ��-�=�t��=�Y{�O�4�Xe{ķ�@��w{�L�E�\���~��N���&�gIK��A1Q%.c���J��� �pc�J9�DP*B� 2Ί��P�rrP��\ �O�Nn��*�oNg�v7�.�f��{����aV֬(�[����^og�d�x�����S������%;Iʤ�;\�Mىu�S�$\C�;q
<�RpQ�..�)P�� S���V�;�O��Y� �S�L]Q1�T�,����������,�ʛ�eqw��� N��!��i���.�D��Y�ܢ~K���A�a���Jo3� Ȍŵ, ������[����1J�L�#8��j��z��T'U��t�@Y�*R+�+Q�p`.���!s�X)L�B�VEakT�`:d����� R8X<<�:;;���ͧYs�-��`%0�S�G�S P5H
���� �=���2BK�D/A*#��R��$,���S %�q�1�b''���#�Z��pB�G�m���]���}�`\���98M�| �:�UU��y�2�
��W��:�Xk�>��	��;U��r]�
5��*o�;l��hY^��* ��� �']?�i������	0�����&D��</�������8����ې��#�g}q�z�	����0
��s`k#]a���n9mĢ�IX`l��D9jXT�},��86�T�N�����
����KQ�����>/O~=�Y�į������Oz��wdh%pyl�7ʷau	S �:� X���R��!Lh�?Ԟ\�jU��f��b�{��0/�`R�m�#eyrz��\�z�����GK�k�Z��~a
߽h���<<LJ�����o�9=��~�.{�͡V#�d���H~�-E2a�v�8��ܠ��-����b��X��8�"T ��_E��d���Z��*UGf(�&�w�9Wƪ��\���)/����c���tS��]�V9�{i���a���pK0)�$6B�^��s� ��^)J�j�� ,�d�`�{`������=��2t-,��Bۄ���,q�"12S�K��Ys(z��x�c�!0�<���x#I�b|r2=X��f���uqt^ޔ��/��jr[���Θ�v{>���
Y.������� ��e��GP&`�4z�nio@����{x��z�������E�M�D����8��H%�h��#cv#Im$T�z�rB6l�����>��=i6�� a2K��+�*܍F��� d�HU.ILW�������D�7%����\ݵ~�(o���Vo ��;-�ؐ�r	q:�p�2��ܵ'�֓��`Y��Sz��?�h_e��̒�鑜X�`n�h��~'| "��́�+�f�ك�iu9��T�;:�u�X��ǁ:�(l���5�KV�l�]��);pQ���c{�����R_H� �:�T��k�F��5�G�Nz�8�M6�f!�z��_���}z�?R�g/ /	N082���^�u�-@�� 7E�O���h>�����"�-���(`$=�^�a.�����>>��PH�as�נ|2yU+	D�_�:|OH���n'���14��@Y�'��Q�	:��}:�6V����l��K���aϗQ�pu2��1j/�"t�V��+�<����~�agYN�	��N&H�XCV��۫�GU�����hq�U[^�����̀I����բ�|q�����:䄆����(௼V!���� Aht�w!�z��S��t�n������HJ́�Rj֍�Y����-$�q�,?�^z@��H2ޏ0��+��|~/�0� ml�OSR�/Í�{
�1�s���q��0ov���C6Zb��vG���\�"�O�@ܦ�GZӀ�� �Y峴 ����/h:�D3�%��I8���H�U��Zy������
 ���x��yB�g
.n���x�m�%������&m�>�2x,��3�u^�x_�s|�o�k��m���\��c�7AK�w�(*�`NCV�Sޓ�0��B~�VJ8�cR�B(�&	������>sa��ub�����h4�)�U�i^\^�On��p�\ɚP�Faz3�\ޞ\L.'�'�/���Ǘ
nsH��Ʉ\0����`f.��s:8~y�����z���CRo�SK{�8%�{*�`�q=��P֧��������~ⶤ�XL�P��:E���\q~'W��w~Y����2�蘍� D�De#>�4A��#���� �\�9x�Z�yGIE��5������mY�?����\���eMʧ鹂јH�{�&n�Ii��CY��2-6('���V���?^�wj߀�[T��v���zK=�|d���1|����$%�\x
��}�I���#�&%�Y���ؚ\�P�X�k�c�y�bvwD�Ԗ��$oqxrs}�H�<�8�\��f�DՏ���`v(�ʭ��z��K���!�5˴Eq�;M��mRuBτ֮�S������{�)�S#kz��̒K��nwi��^Yel�pW��#
O���Sm!    RH��,�;H�iJ�%�A�0�>G0��`�MU�	w�,+f%D�����vB1��/�؁�iQގ�S���w�c[_��gCbk��jY�4�����e/����{Av_M�þ�� ?է��%�z��"�	9R����Le%+,���2A��l��@�k�q)AY8\���̵IL���
�v�#7Y|�|�)�n)�6�:9�e�<R�ǧ�q���o�@�/+j��!6ZH�.��J���,Y���4�L���������>>g���q�]��uy��M*K��=�S(��1�V�H���Q);�s!U�AhS��`Ax�Q�Zd�'�m�Ue^d诌9�܍�HWP|����¼��We��yprqr|{39./���`>�o'�W�ѯ��1T��P��t[jV�K�j��4l���_�f�i�P �E
�o�9�O���
��}���!��jʆ�������b�����Y~��1�|��͔z�B�\��AT���+��%\c*D�]-R�
0�;�J�J�}NU�:��s��QS=Y��WH���tF$n���+��6s�.��X���H�#P��Hx�7גz������ӊ��p���sEрV>�bw�Hr����S��ԐW4DoU!kN�M�eH�A`��U�J<���$����E]红�htB[W[�-S`'�'7���#ey{z���\+��-�~���<�5�d;�g������_q~~����~�
�R|��ܬ�*t.�:
U��fd�΢#�ZQCa��r�5�\�EdS�B�$r��MV�&0�*g}e+��J�Wu��	4��=H�9ױ�Z���|���l�� ����������Lz��J��&_��/��W6k�5XI$���ӀR:W�=��Ǧ�� �����T�葪^�x�9�zd��&-��P;W�:���:�<��قS�dA�x�Y����N([q2�RU��� �g�q't��*n E7r�(�v�,zBr
Zl	���,i����RrPy_琧H� �+^�K������Wjc�W%��p��=�$�HU�b�GJ�������{���j� @f�n��L��Ub���3���\�*ײ�s�����rШ#;���?�h�Ь������_Og0������O�V�-��C������4�x��/�h
/)�~�d������S�&~jz��&N��9��i�e�ݶ̲R,��+����U]Il2�B�h�P��\g�J0HH�� �SK�\��/I�"���	�L˛r�7eys��{����8ŀ��������
na%�k�R�U��-�ÿe
��{�V	�z"�+i���� MW��]�gVK)T�U�T�a5�U�<Y�J���-��q�ɚG��:0��A;G��#B���h�i��d����i)p��D�-W����-�����(�a���[;����{Ex��-{���
M���%.�:��M�.���]?a�Z%�l@����'����ڛ��9dUq�&���M��+ U�b4T?������(�N˛˃���M������CGW��rNn������Yo�py���!�YiJh��=���5QE�Z��'z�R�� ��=�Jz3u�<��Ͷ��= OAmyNB��b5Ϲr)�@P��Lu�Q��i8=Ui�o�p	�5NsY�VFu��|q9>8*�7w���ey��,O���|�8NUz[��r	~������]��R��^O�����l�Y7����/ôn�6hR/�v	j�L���by��F͓嫲ǿ���e >��b�2���d9��I���a'�m��K�]]]:�\�-�NǸ� �[���җK�fi�q&4��H	E��?��_�Q�{SG��+,��YAބ��Hʝ23�IÌ��@��q���� L���4yÉ��`��� K����	w����L��� ��i*Ѿ��������˓�ә�z(l-�n���/�l�N54kP��J�3P�f���Tu�`��^�e�s{{���(�����Z���tG��BY5q��5fs�!�]@�l���Wu�	�'}�5S,��	8��Vj������;���/�&�R۳�����yߡf:���82�_`.�������dHZ��P�8��

���K�㢴�~}}|��a��o@��+-G;P��6|CXZ�`�a�ڟY8�s6
`}���L<U<�4Q{�+�!@	�T)�A IO�.w����E	�ئ��( ��۴�������^:�a40ۖ$Z.���>$BZ��&�bΞ�i,�=Y&H�����9���������`3	@����6�G6U4	�~����E+��-��m�&0-�*�X� �VU���&MO���wt�Lx��cM.�<*o�B�VZ�Ǜ�#�&l����i������̻YC+�M��~t� Q^�k�����)�(�[J�T;��.t�֔O4=�v�vG5�:����\VREEe"Ԋ[i8��i�BSn/�L�v4�eū@= �)���?S�n'G��ͣON6�_�xIy4>�Af��Z*�˴��
��Z��hPS��6�5����*`�������z
o��i>@�R��=����oj�4���%.�4�MA�<�8�iJ�`'T]/(��U�k%`���*�]`����S�}��8���"y��������w���^� c�N��0J��s�=|[�M �@��F��E�zF�0�$���
粪8lgThCd\�P�Y�#K8�m�9� �u����M�n�g:��YyuF~��ss��	�ϻ���*ܥ�0�Q��6��.���Qƃ�]�HM��kj*|�2܊���E��G�����zؤ�}�70v�񦌥qun�V'_�#�c`UbVԹ��t
�!�[f"��@L�f�V �[&�Ĝ��g�w�
������|��&__B�(�<�2�rP�������&�v	1��:_F��b���@2���g��c|ȯj/�M�*t�����v�FP��P���TZPc�.p7Q�-8��Ы�E
WQ"�+��ƹ�Q7M
�³@M��*��*۴z�cҸ�Nէ�l���]��f��]3�a�I��r:S�ً�r3 �V3�5�.!��|/W�f��tBR_"�4}���ɽ����o�F�g���P��3�L�7����f��W�N,�[Cn���Ӽ�0(�:_�����L
.�d43��VFDW+	pSk���P20�������N���vu�B	�4��&5P&�O��F�����b�kx�;��g4��ԓ�o��5<}l��^��4�!hZ)�T�|W���2��L�#=Ь܍����6xVJw�	�p�'2a��>� }%���T���*Ӳ� wQ��Hc�]��nZ���,?��Q� s���શ3h�����-��Z|`��(�5=�~V/��-<U����{��f���y�eOxŬFʄ&9�'����W4s4���0Am�T�D�#v�cm��
���YF�"�q�Z�/���\�2M팀�q�S�&���5r�';�+��n5���#P�����*������|>�<;_8���S-�fi'���\�jQ�J=���ES�I�|#�3�j�/��%�Glw6�-4m�n�	�^g��Z渮S�Ғ��d.���
L�KQ�-d����2�k"]Q�|�(z_}�}�༶�K +�U��fU��?T�׮aŲxL��T;�Rus����F��ϣ\mSWt�����8��6�������O��Np �+ 9�8��B^J�l`��z��̔��K��T)K����0��R����j�k�E`�"U�8�]=���/w�k���ˣ��5Zo��0�Tu�=�iY�?�1Z��ڲt����$�����k�!>���}/m��[�����9�� ���T����ܞଚ�7�%�YX/���@-��2!�+M���*A��S�h^U��U�5���ϺS)o�/��d��!��P/�d�����u6����֔*��j�m���Cy�v�ZpJ�[[����#�O�OOy�^N��Ք�8�F`���
�̏`���5�BJJ�/?�l6�{~|��_��i8�����?�_$��{q5�Z�o�A��@6��r [�e�Ma    ����>�̨,F9j2��S2��b]fq�:�1U�Ѳ AUW��A�r}v����'����ey~<�Ю��FХ��ˮ���i�Z�z�X�-�>�z�Wb�/����L	��J�vƠ&w��j�-۸��k&��g�~��Z��� ��↕ރ�	C|Gij�S�5̶򔂏)F�b��l �um*���J���V�qLy�"�Nr���&KqywuU^���bB�Q���2S
�NJX��tj����O�@憠 l?�
���X��*�)l}3�P��9C�{�%}��ɂ$�eO��v�D3V�a���D��3�����E�ex�Y�>���4E�O�ȃ�m���r��. ��4��I0�(�c4�ӔX��u�5K T����:��`�2�Yv�����t��8�Q}�]2-��q�|��/pt|>�ĕ��]
U�H�t;x��c���H��2`�u)��n�D`ͼѕ�[�~���:u��#<�rь\��[�z��ayS�#vG5�mq�_�|�_�Z�J$Xtj�P)j�w��V��B�k� ��ƜS@_�*�S5:^b:D���z<���x��>J����z]k0��PNPd�	m�h:>�6?_�jװ��3��֓p���\/���a>������u��q��a��J\�\3��Pq�9����i�ϩ��f<�B9�4��h���5�'F=���Y��
�S�4t���1�sɁ����ӻ���x��d\���'7���F�ӓ���x2nJ��S�����$`������%��&�e�h���-�o�1z��O/���5l�����kz�#�6�� #��v�^�uyꦵ��N��k�PHK��L`��s<+â	��������+�d��j�`�4��u��`=�&�#PU\� [��lB-X�n��r|^Q����|B������@�����ri�1�;��=���%�&y�����l8c�bA��9=��B����{����1,�^.zJ��ڐ���lv��gN��J	���iR�aP�����-w<W��D�BJ���,|n
�(�*\p��K] 7��o ���/�'ey4=��k[����wLo��l��/��y]g�7<����G/�1�B�oMB��.{)b���q݇������ʏ�����PY�9SV2��1'������"U2^r��	Bf�Mg�D��|�"&ݩ؃��8ĵg�O� �[+��'�W�أ���$�b�'�x�ǆ�h�&�9���D�5��P7�T|���]���u���5��%�|�#M��	@5�hl�U�È�B%�XgAu���U��R?�`ReG`����]�X?>?����Y�����t�����G�����㽃���c�5pS�Q��W�zX��Sv��%>�'�B�g��6���O0��[�P�}���)c��0�p�����N�x)_��p�N�\*OS#���Y��&A[�x48�y�N���R�ڧ�Cb�-�����+I�;z�)>'�ʗ�.��Ce���)����(K|��H��=�ߋAnKkX�Z���K� <��T�'0�����sB��xW*ޓ�n������;K���k�
w�qTd�%5�P�B��稦%��셂�@��`	�:x��22�ܵ1�{ߩh�� �m9]���k��8�99�:�8)OW@������@K���#�h� ���K�AP4_�-g�qՔnH�Q9��
���k���s�?RD��}���RC�G��l��c-M�����c�Y���J s6�
��VYS�5�P�����l%�OԠYA��&��"�������:]P�]3+wz~=����'������{���f;t����bvNJV�coȱ]j0�8_���G��=��&*��C��?������-�߰���0��~��U�=�j�WL8k�0)�#fZ/�ϮD;浅N�bY�IY�e���QT�ݞT/+hi���<�J�l�"x5�kYi+��+	����TQ�J6u��TS����}xc܄w�+������;��Qb��.��$�e�Z݁�o?e� ;&E����O�X�r����Y3��۞>���I�xcb����懛�H	��~x�R��&�X"4��d�9ܯ�Y�p�(U�JYڵ�Ҥl�Sم�0kxa�ցi�m��T�N����dE��z7��l��F3<m~�hr=^�7y��鹃M�Z솏c@�h��mv�]bh��v��l��,�?������M�	�/��ڭ��������N�*�ݝ�Z\��杢���k��pV���ͱ��9\5-���m__OOh��珌�������ׄ׀����S6����#��-�^"�hב�z 4k�v�0��l���O�
�x{z��9a�n�8�����T��o�F��Y;�y�H�g�ez�A�xeQ�E�T-�]��ۙR¬@]cp���)��1��i��
"�UY�Q�(��VRl��;�O�h%;����?$�{�8�P^b{(����b�6�۽~���ZZΰ��S��PSb�"��b<���~��?B�a�-���=�ؐ)\���_�m��F�1O�"���8�նy�	��f\XaS�PIO{&���4��-Ɯ)Fc4"ǵ�>Fac#u}�N��������%$rB����'�W��R�;_@�9���}�[�(�h[��|����b9�\��|�n��6UVE��S>y�N��/�/O�9��'����Ǐ=�.�����h��>W��ڥӰ0v����^y&�X>�>��r��V�$�^���u���9ipq��fu�5n oc
���=@���r|}��m(���cc��]��>� ���=�����5�W�g}���f% *^;�T�[H/�!�=j��	H�ք�z�;]�z��Jj��gg�2_Nz[�!T��Gh�����4y��j.r��R�!���ԕH��h*��U��6-g�v���ܞ�lX��P��~3�Q1���=�'�=�͖���%&%��2����k�Ӵ)�e޴�N~��6�'lFz%(�IsP��i:����������ן9�����r�6�m�HY�O/��Xá�o���<���]Ú�ڦ��;�<�������Qy3����og���bt|}9 ��YBL����*/M#�lʸ����4�"���<Z@c�V��Y���%fO�V	f�U��G�e��QH:�mV&gk5�[�O��P^M.Z+��f����~�����2���Q��y]��L|,1��],�߃�pI�e7#mb}t!���T�j�!)M;?�)��@G�'�4sp�ni[�j��1e]LSoj
��\3O�Z>��h��!rJ3D�$��)�Z��T��N�����������ո��,/N���r;n�Q�]�������A�Hk���@�@�$�쮊��OR8���~2s�hGAeF0d=��mGG�J�N�~��6CD	���?�n:_��]��e�x�YY^��Jn����
r���[{��5k�V����r�4o��?�����Տ�-�R�Q0}���ߐ�n�OP���:��)XHO� �
�a�O���+�&AhJC$��A����Y��jHI��6A#LT`�I�B�eAQ�v������o�K곺=�O<:�LǤ�[���QA�brK�c��9R�e���#����IO�W���������q����{?ޅ�t4LC�=B�r�V
K#o��}�:n/���R����р�������e�M������א��`�*�:W��ef9(�йc+=+�h����伤!7'Weq~rqq}��2�WEy���W�<���D� Z�/ �K���v�V{!MόoG[Uцڪx�߿�|����hދ���Y�[�C�0��v�ٹ#�{��rp���h/?����ĺk$\^�'8FS��4�azI�cH�@:���ڶB��`��b)�J ��m^���)�~>=�/�ׇ��Kz�W��ӹ����H=_��$YCK�]���m��rc�|�&��rM�$:�*	N���(_	�d��z��[)�2�N�W����QytW�!�����[������9���tL�!��D˪m� �K�{;D�e<�l�oZ��� �  ��?�o<�#�-M����՚��j������u!� P��:H�V�!��?�L7q�M��6sU�\�
Nҋ*HU��)��qE[�}�)=/��-�-��iJ��&�e{���Rn�eф�i��m];�%vH��$ �,"���|�*���ֽ�|m�Ұ�=7a[p8ٔ#�3}�Ϯ1>�TN�Pcvv�J p��]$�q�@y6��}s
��
,�0p<�U���X�
�Ġ� v��	]�UL��S�f�5��y�O���/i����-��]L�ΖJ��U+޳r:S��TH.4��I�E��%à�e<�lE1��0(�2������W���8����륀fC��&��v�l�e��U�����:�ׂ��MxWҖmXN����xUg��v5����]ɼp��o4D��<=>��'�W�j�t��eRs{�T��`�b=�1?n��=��@/�,��&;����c/+L�*MջZ�l_��kQ�Lm#ɻ�*����z���3�9)% 6�����!�k�Icr�����u>�d��,�����h�G��3�*Nq�l�:���6X_wr`�}�Z/��s��/}�ʓ�әVVo�~i��C!�ޠ������kp��sF���
]h45��M�B���ߓ�ʦh_6��u_įFdӲAy��<VC��ƛ���ڐ�ֆ�XE��T���S)�x����N$@�B��̡�� �98^����N��Y�A�g�L��Y �⸆J���7�i�����{Hj��@��Ͷ�ˠ��Ã�_���;�⾢"�M�pu_=>]�u���7�j�S6���
�^Q�W����oT-Ygbmi2�y I3�k*D��vk褩k�*'*[W��w��E���+9�tw����nS��l�_��S�);�nHs3,���~,1��/��2S�NR��2E�T~&z�����
H��e$��)*�*���$>=Rj����K��4��]���%F���KA�L�[4�����s�Ρ���i���s������i��\      �      x��[]s⸶}V�
=���F�m�&� �tON��}��Н�.B����wI6�J��:u��2	�����k����T�/ĀI��ö"���ԌKsKR�p��b�W=z55��/M���vﲬ���P�C��X�SC�ȧŸ���:S0��9^��ǟ��&)�)1�a�Ϋ�z��Q���i�������'�w��`������/����\ Ð'Q�zx�@Ig��ׇ'���o����n�X��u�B��>?ow_��X��]��=��`�&�c��fdʅYnʓ�VeNo̵Y,�zJץ�Z�w��}��]��i�d�����h?�| t���9������h�\��n��+�߭^�T�]U���f��:2ʓa,�JF�槅t��V��]���̬^M���/6fif9���iY�1m��ZO���Q&�|�|�������K��bO��͎�Mk��~�;o2�P�H�;��-#��Ϋ�zm�l�H�9YΊ������f���M<�56����Z9
%\L�yK��t)x����f��wcXPL(ӡL"�Ű��zS�:Lq;�#���`�X`��scטdY�o�OV�M٣��=Z��������+��<�8�,�<�V���&�̀C�XY�f16+;3���_ѪO��=j�䶘��7��t9Y�3��̗��̮
��Ʒx[E��ψ��+%�"�� ��8�@��p�B�S��@+yF72���$�a��9�ufz�2 ���0P[b��d��N�-#x��E�ۚ��b27��� ����R&c5P8�@.�w��cY,ִ��}��+�9��;��30�����b=�/4���eCד4�7��o`�Y�2� 	?B4��V�`��fV�Ȳ�?����6+�Z�M���~�~w��=ڝ��ґV* @��a���' ����?�95�u1/F9"��YO���S���9ܗ��ֿ������&���43��x}g�1��ւ�b�_D�A�EH��ɗ�r��J1��Q>�\&�Q�������sei��ˢ4l��$��nٲʹ(�SK5�!Y�F$	Î��r3��̋��vG�Sy(����Y ��y~�;A�����V"h��x��6(똔��L\BK-_dZ������Cv޺�3An���nW��y=��l�_^���L��?~>?���$�o�B?>�����������Đ�����B�!���"D�<�	�Af�]f�CV���٦\�k��\�w�\j(��e�� �J�^eJ��(�L	o����\vB�����JpQ�Z�Ţ�����}ˇ!�pӈ�*�;�##��77 ���z��4L��t	{D	#1��y�^�bq�s�������|�C�oVk��N���I�3fdbm�X�d��HQj"�˙\����Bxi��|�vmݿ.�M��d����3��i3��z��<��ŌHu�b�zcfηzt=5��ri�������P��A�E�X?��a���C��b19�y���d:)�d���H@�ɪU��WP�a��B|"pG���'u�7=v$����SՄq=�����C�����ƒ��
H	�6O�;'��h�y�"�.~R�4�G�qL���L'c+.N�;-V���Gg�շud/^���C�;��+&���D \b����j��#>ǹEŸ 䱍in-4��gz�C�ISʙ��d�Z&��,NI�>��iQPs=Y\��Zǚ?�Ռ�N# )ZOC���~%����z�.jP0�H���{�g$�/*ɠ�k><m��,~D(�<	��Gq�&�e���O��S-�p�$v���GY��8	�~I��Y�D������`=魢���$=�q$C�����ث7�W�gL� EЇ@`V�����:O[�N�uM���S�k�������<J�8�PI����N���G����!n'��^�AX�N�����A�X_��)��n�����b2)�F���Ut
��~�JF2d�rI�B���lE�XҿSŧ�g�����Ϟf�p��4���ߛ��(yv*au��H|tZ�*�N{���%�1w�����2�ui>[����N������O;������Jt��*<o%*!Jj�X����ԝ�:��+G������:%���mPe��H��;��)0���u6�,�d��&'D�-E`A4�6/6�4��P�[��M!����l���]��<�g�D#}�"�L����>j�w��B@��=�^���u���$" ^"/����n-A>���W���v��k\f�f�<b�*֋2".���w[9~ʑ!���w�B���٠z3�x��`S��P��-J��P���Ǆw��/]ZL�4���i�zMo9���ow���~w��?�������H�����^���)d�;>U������~|��mǹch7��<W̵X�����FTr9�3�B���������4��Q�gM��I8Q�{:����)D�˛ �Ui�-��v�!S%r�e�D���Q��y	���/g�?�K�����D	Q�k����qk�*[w�b}@��D�Bc�N<�Kb�t:���S��>b6s.� ����e�O���t�Bo^w���[\;ü���ۣ��`�Ξ
�ZOp'[����%E~14��S�;l��drnMQ���H�\Z���d�|��ũ�<?K��,��ӝW�U(�ZWq�z//&�(}�q��̷B�0Z�k?h�N]j����y\�$$�ݷ��R�X�����Aw�֗\8��Io�r(�I~JΝqÝ!�F�*���B���$%I��A�f��<��[�����5�������ζ�ǎs!��ݷ�ǉ���g\�0g6��ī�TLT�0Z?N㴇�����i�*�_{�o*�Ԧ+!�4	D��<_ )d2<fn�Ӽ.��*�v�}k��ֺ��dL��v^g�K){��uj�����n[2a�#0�C�'��[��Z��l��A�]8w�lk�eKB��g݌$�R�&��`�@���i�;l���nv�2���v��6c�:5r��5$�g���̞��O��7�I�q�ۧ��C�J<�Ȣ�"A������f�zbO����Y�ꖅ' �$- �DHƩ�')'I  �j%94L)��sqU�f{�A���=��uF�Ri������-�̑z;�J��9ę�#)mcӝ��C�M��'��go3�
�I�{Z����G�� I��;�D�E?���a�m��j
s�����z�\����tS�{�5a���(侩���(I�Tލ��,C���뾼��.��;���:�x�\B:Q���g�������=���:����@�8|9�UR__i�� >��Y~��P�nl�r�v�V�Y�7GB��w���8�79]O��`	w�#�$���II�%X�e�����lQ�/y�	IEx|{�P,]�h%1�@��'��F��$7���7���@�w$�փ�!�/��f�|]*{�G��'��l���{M�zgsp'y��(�P��$�;����ã��j�f�7厃%�=	�X�2dQ/ǦIC<����r�����[w��r?*��WH�'3���m����=V�ݏI}z�0�	IJ��'����ce+��VGp�����
�Q�]=�����U(�~TϠ�:T/O�Cկߥ������n�}�Gd�f9����"��qG��G7���yލ�V�Xg��ZS�y�T��4��$�$�����q���U�������񰭞�%��,k���J���x���F�fV���iB�Q���7�&�20�>�e	Z����������I��E��KB���X�*��3E�nc����<���~�-�������������}���O�W�)_=¥�����8��͔j6Nm*���L�사��;}�}�쁣���M�Xo<�`�����j����:�[CJ[���1[�Q�I�7\cjH��ʊ��� 'ҏ��ݜ0���$�)�Z&�h����--7�)$s-]<P�!/�r�:��b|�Z��9f^ѫ�b]N�W�F��X�Qp������^���63{b�%�Q�UnI��ɁX��R��5�A]:�X�щ%g&,%��a�z;-�8���,V��z�,#YGJ��� B  ��a�N��(j�AӁ�'�˙�� �ڊg�tu��X�֥��@'���2M�����Mi�� \��]��7{�.+F́#庾006eqm�f���bf�fd���E<�YM�P��$��̻.P,l7�2&Y{hD��lr�h�i� Y&uvj�I�<@���^�Qdu/��V��ϒʨ�}�|���*�_�]Hf�`�B�N�i�I�Mo���q�ғe�5O�`����S���Ζe�RW{�L�uxd^��z�i���&�����.�"Lo�0��ε+����k� @�<?B��.�f����y�.��f5��jh�;�$����TLU}���+j�����׃����z]0A,�PA��(���pd���m��M:M�L�`�5����S�������"�{S!N���R>3�^B�1�]�E�F��ڋ"#g~]n7f.ZOf��|�^uo)Y �|�+TUI ��'@�"Z�G8���>�w��#{Q�ޑ3�Ql�D*��Y'Dˋv8;�v���X����]�O���^�"yYGR�nڏޔ��=+��ڙ���W�ߵk��P�"�C>���ΈV�M޴���oy�e��=Tt�r _���C)^�J�^0��͘'������X	E����&�r~�%�u/�s�������y���m^,�E@��fa�΢�r�OF��;[X��䶯�"�&|��H�5(���T�R��_	:�lpI���k7��,�	`��,����L�Ĝ�n��N� �ᵛrn�+��ʻ��ZDk{��V��"O���s��]��VW��l��P������l>TA���Y�\<�k��oB�7�T؀�B�u0Շ��Ç���x�      �   Y  x���Mo7���_��D}�-MP ��A��^w�,���zӢ����qlI�fFv_���J��������Ή^�y�i�yuy��iw8�������J�K�Uz"3I/LT?H;i��xlV�k����������K3[�&J+���h/_����c����˫�Mi��AJX��e�%������5��좄v~bS
"�v�Q 5�q�i�2NF	2����q�<��a����2�m�E�� ���������Ua)[S �4��X�Tf���a������۾�|{����r�HƤ1�$S���/��lױ��a�m���r�RX�
��ؖdg�n�?�e%�ck��5��u����~��O]S����*SxN:I�5��BJWX�ʺ�ᵶz)�r�3�FA.<�6��gٲ%Y�s�l��(�jE�"`Ϗ1��now��O��ݧ��I��R�� �U��1��~FH�s1LR�����sk#aό0Bo?��	g��P��������n73����p��3@����*e]4�pcEXЎ1��mR��4)#��-A���g�_� B�����Фъt���=�A!��r=���� `* H�ҧat�y��pN�<PH2A�Ԯ��"��n�;�ۤR�H�����c�9���tg����	s�W��~�3�淛ßw�W7_������n�. �Ӆ�i�v'B������.�� u:�E\������P'�)��	��FU���U���>�'[��*^�=�9���>ǅ��4��XW�1ݭ�,e&�Hȱ%	ktdK"�0�6��1v��Rf�2Brm��㻜k�]IW�� �w��S�!%R`|�Y^�t��@6��B
*�̾( z�@�3�d�&����k�:��h��IB�heE�:c��1��^.�@�"s�q%
ȝU�g�jP&�r�UL�}Ă
�S=�\ҝ@e�Zk���THy�yT �5�c�������	��>1�g0O um�[����B'��c[���'L�ҭ�f�-t�9�T���Dk(���	)��DX�'rd�?�ω�e�Gv�Tu UC:
�#	E�W��i���#�*m�+�̵iF���zR�<sE��6�(�Mr@YǃHuW��kC��㉵���يЦ�8c�V���4�<pr"����y��<9�jhy* P����$�K�����P�iL���X&cI��LZ|y����k`ˏ��iz�;W>+b�/��Iy-U�R����9J�qE��#� �s�P�Zp�����������R�g�����ѻ�wW ���� �P1`I�OE6&E�D{,T5jH���ɫD�荵P�hZB.�6M1����d�EEsy6�ኮ%�\��%�0�� |�%��݌e%�C��7"�H� �}��2?	�P��-����7��x6�X�P��¡�xSM��T������-6��3�4J-��Ń�UlЫ^ëx�6�:����Ｗ$��QƮa�,��2t����p�mgJ�w
7ݒ�u�y��l쬰_���,X������p���]����ЦiGyA����o�hj�n7��ˋ_�q���tAb���e�R:<P��d�LX�,��:�R`��˳ H�Y�{��o����t%�y����0l�`�N{��b��O�ڦsQÀ��x�Yss���W���E<���/�*�B�`�6�iK�n0=��k1�+X�2`��?�Aм���G|��4P����)���_H�L���l��N*�Ùt�jp��F5�ŷ���?�J�$(�K�b'�9<n�4b\�J�X���<S�FJ��D�����(�D�F%��>b�Q=� �WplT��u��O�Q�k�Ru��8;;���E8      �   w  x��Y�n7��~�}������j�~�%�n� 
�R�[���? o�!w��h���k����9s��ɼ�r��͔?R2�]L��}]ޮ��y5r�a<Qɑđ�9�BR�Jx	�e@h5��V#��<-�#dϓ�F�K���o>�����O�����77w�w��z��	����u��e�{��>\~��w#�
��^�q䜿
�mߌ@�����Y��uJm7�1�r��"�g쇧/_�/�l<��?�f�ة����|����?�^(�,����˛�v=ZX?�n?��|�c��)
^�R���X 	4h�I5ޑ7CJ
d�2(������'�o��*��^>lv��Ύ��� z�J�]C�^��쬾E���������wB̤m���V5����i^{���5�֢��?@ c8����Nԩ��gcQ���l��Em�#��"�d:� d�T�ՠ��m>�ͭ���˧����䊷2����G�='���\I޵�FXc!shbЯ�
$�������V��8�3�}��]��Q�p�tI`%�>p�Ba�\Ű��k�#�ό�|C� ��H�#��A�r�xT&D�J���Y���@�;m'c���o���r��^�M��5�V���F.�[6-�4�6����ǵ!{V6�@L��T�v=������� ��-f��?s41�>f�Y�j�ƵJ�-8/���c�^ԩG��&l���-<*�A�hV�����ȿ�Е��[�O�i3wܔꆆ�3VJvI��9	�	q�z��ب��Jz<��L�8lӽ!�KR�֐�ǓKn�)�]X(-PrY�3+e�CCl���D%���=�6I�.�ho4u�8�D\=`�<��n��:������$�y8�}�'e��L6���rD0�9�!'U��ǎ�7��t'y������@6đ�����jU?84/_�]�W���>=�����!r�W$� Ʈ����֐+,�*4w����������A0�cDgj�e�ۃ9{�>��-���ٯ������/g������j6�8I���o��%n;uA3�mQ'_�<��* *�yo�y�;�J��t6�1�L����d���䜴>�X�*܁R�+U��zMp+�8��6�M+��7ܫ�������c��:��aOz�8uJ]�|c�����Zڐ������#G����S�,�A�a��{��s�ټ�������k!Dz��3|[��j%��a�I�����_�r`/�BqG��YP��p�pH=7w7wQ1C3��م�1�ZXp@��\Շ1����Ƈ���I���v`��۳�+�����(�����FX����6y�r��L�H�LH!L;�Tև;+�I��.-9�B��{���_���e�M�o	 (:��Y�?��TDF��U�čl��Żg%��\C�|5�x�ی�v�}5@Vka�v�rK������XlL.���s�e�v(t'�x��e�}73A;�>;מP1A]�rb���;@�p'��,�"�p���=�W'����"�H�������	 �ygȱ.��'��?�at�Qt�H�ݧ�7��H���:h�Vr[4I�~+#\�\]]��h9��Pۦ�|\�\�}�	˧���l���i���&�&�/m˅@^��z�
v����n����$����ǟ~�\^G�K�.esnȇ.�KD�cl��?58:�Nn-�Mvpe�M�%���QJJ78�.g�A�������҅#9b�jy��Zh�T<���mǜ���<��n�ߖ����e����v�ވH_b�.}&���&�~i�����Y4�P���j
�4Ν"8�%d�A���5��Kn0j������:��H�X˂�8�ۜ54Ή��'��l�sz(�Vs\V��X������~�ϧ&�6c�뺌�XU�t̝;F7�ɂ�By�Qe���Ph�`�s���M���j =w	��"ឱ"o��9Jb��OAa׋�׳�I
+��L{E�U�1;K;x��!��d�׊]�\N>F�4�?v�Į�ח��p��Y>o^?����b#�=�+�q$�Y�z{�E�ub]c�����/\�����x�G o�P����~I��~�/��,`;��}p�����]�+
k}������������      �   �  x���Mo�0���q#����ˊ�`X{��Ê�ȚF���i]��c�GC�c�"E֕8έ��z�nu�������%G������0WpJ���ѲL+���۟�HҾ���LR�J)L��~��d�#-�^���۫���dWARC���PWC�J.�`��|�����>��I���L� z+f�1��,��$�T��|Z�����.��@���c�4_T��t������i\�no�|=x����zu�H�CO�@]����"����<iqp&��9xS�)�t�[2�ս�R�̲~�fb���9y[\b0����H1<�wu�C��+~b���(�i�6�80S��hF{����`�F���s�{����)�땁;4��/øO�2ٚ�)9�̲�~��u֦��6e*�����?�exfM��~�4gzk
��B�~��3���;0�:�5M]��d���_4M�uN��      �   U   x�+H�K��K�O,�O�����*\|�
rI�y�ȲN@>WAbf
gpirrjqqZiNN�BAbenj^�BI��KjbNjW� I�#=      �   j   x�U�1�P�9>L���ܥsU�?��b|r,+4���]�G�ü�ՙ�c�E#�l\� )%薭��|i�h�GS��U���fk>�&�ϋ�~ ��:E�      �   6  x����N1��g��/���/C�(�-!U�&4�D	y��z����R�\���?c�o�
��q����9�Z
���E������㦾~YԌ1qr��9!����i�K@Lv���,	H<�iT�|y��2m$�I��/1X�� ��"�|Ju:�h�%�Ғ4+��MUEx  �gSv��ͥ,�t��MRv5g�X�Ad�T��T��0=���q�>���xfA�6qz����zGllIxX-���ݗ��=o�|�Z�wE^�x_�J��&��F�/�"��)b=���T�H	��,!��;�HX�Y�J���tV��?�v��A㨼�R���	U��Ҟ��H� 3J(.����x�ݘ��[Р�bD���~�d�J��H&�L�<<%�(m�����j�]�VO�׎�c���3����rYX}�7�#���C*s'R[��, t�kߚ�3Ω�$��|��t��}3��C��a�`
6����܊�Y�����&	"y��a�.�}\<8��t3F"V�����"�gySX���̎-�1y<�FÏ�ۮ�q�cۥFk��\��f:þ�q����q�r]�X�m\�&�8z�\*���C�w���z�Z֎K:��-��F��lhz;5���cO�O��|���=��<� �d7�T��T2�����Ψs�(�Ry#P����;u�XÁ���QP���Q�=�}z� �����DQ��7wƚ(��������������J֧{�3*���ƪ�P�>�����u�S��X8莓���9�M�5�%:W$^t>����| WG��ۯUU�}w��      �      x��}Ysɕ�3�+���U�}�[���"6F�G7�ji�lJ��"����='��̪,,Ǹ�n�*��=�6�Uy��������F�e��|���U^���ȋ�x���v%4Qz�g��&����w/���s�����4�?���������a4�����6���~F����1e�T\s�)ʈ�#jF�������;�m�����u���|}��ǫ�<��we�_q%��H	��M�^��F�7�|O�y	O������ܻ>f)3*=��=S�!d���'�v?�M���d?��@����zwx}���_9OyMU�'���S 8���i��^8���<_;�J38M���r�x�|���i�k�3B�҃��bĬA��׻�v>���3x���F�����6�D�Mt\Bi2�3j�Ly��7W�zS��6�o6���;�Jj��P<�-���Ɉ�*q����h��wŮ� �MW
�m
�1	� � �c�peW6p�|;_��o��LV����g5���vQ�f�,	�Z��U���j��b�*4� ��ڢN
��K�h0j������f$�Rb�p��nuj�Z��W�rY,�9��#0*\���I>|��/���:�T�LKc蠽21R� ��|���*׀���@���RsMy��J�=�h15���������{�S8ʚ�$eB5�����C��f
$H'A�1YґHxա�g��>��؟Қ���\K�I�h-躍���4�o�2��x�J�ƒ��yLw�:�)�$r^LE��"0;�b=��
�7�9�;�R ��kn2C��}�	P��ؘ�lKG����c^��)XPT	�8���5��ϗ�1PF�	�4�D�ݶ1ٖ��y9[�{�"<�|�S�
\EN�?сS�s� �i`��Jb2�-m��P���L�ȸC9����"ڠ4墳%ecb��rF��iJR&�L6�!����~�z7[���x'�+I�������^�Đ��1ِ��Fy�t��
�?��2��8��� ^�0��Yz���4f!k�;PŹ����#���@�c�sqM)�Ɍʤ2A�dc6�-m�~�_������^:-U�x��ǧC/>���m�u��,,p�R��} T�N�������z�$5�,���޵G�ͬ��%��t4F�r�6[g��𰄴
�L��[g���~��gk�g "�$6}�e��d�9����X讀7��2Ɍ�����@�욃+i��N�� <F��~�n���Y���,؄d���w�J���N8I��P�u�<e���ʎr�QJmX«�ǰ&UَA9��&,�#y�e�kI�vs_x�X��ȉ��t̫Nf����fZ3��t��1�@}T^:>6�q� :ev�	�3���d���U��Y�0[f�_�|{>���<<>{x��C�Ph�<��ԅ8iK�i{�X��^u�&��r�"_��@`��H�1hP��������
���Bf�a�/�q� ���0z��X��b��zZ���f�ϼ��,8'�KZࠐ���7��Q�'tL@5����*a��C�%BJ����O��۷�������������/���#.8��K;��#Gas����z6���6�o�[!�-ַ��ч>"N�h���|�e���hZu8
��5�GE��S�c�7��b�t���{����t�����r���l:+�� ��W�#dL� =�0�s�M~��}g���c��L�}�	o@A�@3i@e�rOP_!:�a��h%�w�� u���hp���xZ�{O)����ԘQ#野h��5��h�3�5HM�2`\�`@���ԯ���@�c ʹ�?�[�
���L7 '���[����{l�:QJ)f� Ť։�Z����f���Xn �^����cGC�+�|4���KT�꠹4I���	 �Le�r"��*GB4&!�����s��l�������O�1R��T2�H�����%�HA��5S��4�� ��,�"�r�n���8�/w�:���$+�`>�t�s��П��j��C�� c�d!8Y�kYh;[����S�J�
;�H�I�u�����7y�@[�5�I�ţ�)����}������[E��/���gl(����;C��I1 �n:��x�
�>EW;y�[���X�G[���v��Yv���S��X?o�N8��< E�CjA�RE��0c�b�L��g�N=��{��Z�t��(�� L0cNb-'}��X�u��y	�*!��R=*�~|y���o<y|��%%�)b�|��a�j�4)����XKL�|RT�\��"}�oF�����=��'�H:p�0)(M��Viy�H�e����o�:�����������f�}��\��r5�.��^�qB��Q�
��5�TB�%G���/��E|�1S������#:�5����z�5U����['`Cx�z:'�����r�3��K�XYLU����2_�)`y�X8��c6��n}{s���i^��r�a(�����x�Wi:���
'g���|kp���$MX.���·����%�,�[*'_a���������	<����Ï����'���?�w:Rw��B�Z(��L!��Xޯ�Upc�-����=eJ ���y�D��)��L������qèN7
uLn\�*8-�]��	�ƊT��L#�� ��`������2��x�pM��k�h���$k�Z�����ԁ���a���f
Z��&|3o�mr���� n���屢l��#���t��Ʊ�l��o6����w�f��N��KE)�x�1�q}d�ٜ	9mv�B:�Ƃ쫴�E�1���@�� ���Ǫ�(,�{�=��#�W�����30R���\��9@�1���N���:ϩ����
�b��p�W����9L��m�s���`�l2�ud�����\1cO1'�`�~�H�$h'�I�Z}{¦�39f�����(�X��h鋘|;��1m�9'&R���h��M� �h	s�`�j#��S�Rڍ�d2цt(�mT��1,Qs��go�	f��c>�4<%E7NJ�;/_߀5>��R���:˘PDK(�}�q3������c�`�V�e��������1a�,��f_L'����a��=OF�G�
5P0{\e܀�O�Z������;;s�犪��cÚD#'�du�H��H�j�݁J�qft�"Wh&�fh���O�����Gu��=�i�4���!�??���9��ѥqɚ�j&�I��6�gۓ{ɰS�*�>HTM��2&��g1���*"0M���|�D�$i��xy|=|�2����w���7P�x�XO�����M#n(	F�CXcE�ͤEcP�u3���|7o�`��ި�j��1s����w5���R�bt�AW�|o��|�)��]��qe�FGzD��)�~QĂ�?����x���kQ�\�������D�N�0��	�|��ɽW-4O6���g�O���*�� 'cp��.��=���lUӋ���T�؜��_���L��7��(��uڶUQ��?�\�W�U�4�h��i�t��ߎ��3גeD�0��9B��/�s���o��H�J�41=��9��bL0�w�ӛ��>c��-Y,��X�e0�3�?�2z2q��[�_�2 |,�	i�W��F')��5�"^�N�$�Z���+�]l��\����k�H��||����\#[y�mrx~������x!��l�$�� 4���5��:S�b�Kı�ߗn��T�#��2�.����w�a`Ǖ�����۟o���0�u��g�	�
�H�S�E�I�_�$�|�_���}���vsw��G�����/b���6�1Nb�w3�j����� \7��:*]�dx�bZ8";:��w��._����巅j)�-�m��6���b��̅��P�� ��F����an��DT�
Ѽ@K5���~�!Į!8��g���jZ;�*&#ՒѼ �{A�l1�S�Q��|����ߞzT	G�L	f�=@�S�`8�_����j�)_��n�O��s���t^䕅5VZ���<���md?�[�+    1N]�*M�� f0�2ض,�j���E��~�3�`��?o�L��r�����g�v�o���PBa���h`r����=��0ވ���/�ϯ��|�@5�\��[��{�]CP�I�7{,�'j��E˪���<}���\TLm*��=(b��9�(�rZ�\�6<Xu�@�^�Q�e�)�Y��8	����c��$$�`ήn\X��]{}xz=Ny=��3��5�[�0ELR$*�1����rY�7#��Q~�Y�.��)� D-�~8�����*@ 73�X�$<���nT�x�]�3[qf��@�����q��/K���ͻl�g�	�#���"�1� ��o�E�~�X̖�H�<]v&f�L�7���!d ?M���<�[�5ت1��Ϋ����j����dvy[��.z��V�I��c&�-���|����VFـ��R��D'ECa�X`�~��W�ƨ cL}Z&�v�wɊƓC�La��b��'=9��)�����v�Y�f�ͬ� �J(0؞7l7b��-땳I�sn�t���W��6\��so�l��=��eƶ���?S4�6p�,��)O��7y8�A�����������xA��4�yLq1Z|��x�ia�TaV�����i�����2��!����pz-U����V��ny����nl�������L f��h��sob�Y
	&���V�� ���_.:?&�=��^�������ǜI��A,bϑ`�i/
�r�)���hkLu&��V3���]Zu�/}|'�&��;��F��Ee���	�Q"�� �/�XDT.�dB�%Cd�ab4,x�0kgs]ܖ��pGN��I���#�'��KJ�_�d�O ΰaVP�4�=5�1������@�e�d{P���HBO?�ͺ�T�@Spg�S����4�2R�i��c)�B�YL̋��E��r������+��24�w�~�� �OO�R�������[`[$F ���d�*
�0x$ ���o�|�<011��!&�MB�I)F��S:�~:oqb��\l�.���c��&��[A��Ҵ|�s����ǫ=�Rv���&��A�'%�����K�c�h��~8~%�����S"&fLĉ�-�}���f�2�>���OK�dQL[�'�ze��;�C��s�ʹ,y����DjZ"]�>B�D�+�?�W��-�P�6�� �9��1N�P�	BFS�	�f�JA�8�x�B0�mp���Tc ڜ&����/����\a�,O[u�bc�-�"ᗘs­>*�����}��z2G��(����\��*����`�HPmm2a��lL����.�q�=�ֹD�{�)����� ����@L� �t�Q�e2Z�n��Ƽj[^�W�n��헕^���><?���)��+)6ؖb@�-Is�|�A�m̥���|Z�>��
Y����~��3�-c8!L�c
�-�6[U�u'y��[�t��1���n17��5C���m�sfY���z�уcΚOX�8�>$"l�7��>JDܹ�B@3t�`�mL��%Rl�[��b��z��P-�D���u�Ղ����7�$n��}N���>fP�2�X/�q懴�������c�Ҩ�a>�9|���X���c�Զ�����6�bOe�֜~���[�;���a�t���!6i(�7S�m)v:/JߔRK�Ogw0�I��e���{�"@{�5(x�4��d����Iѭ$AȺ�΁���$��}���2x/F���b��"�-���owĒ�^K���<v�����;�����=FB�$�QP�zk��cd1Ɩ/ᓘ�,ћ-|��)l�J �(��586Hp i��A�:�N8_ECoI�v^�15����m�+	 �NY��[�-zzi���B��
���E�����3{y53��~U޳�:�vz����?������_�~��ѿ!6��܋�����*�8�A����m˔��W�
�|z8�T�=|�kw�{��y��x��O��es�!;�}��c��0Ə����_�|�<�[�f�b���4��Ө�iZΜ����u3��7��(\�WJ6�O��?R C�2�*cl2��iȍW���s�|�$:~��'8t��6�.!P=�����t�>�b1Y`�B
��h���07:�����}�s��)�`�GR�� \u"o������)� =zF�QI���c�]������)�0�R�m<�������U�o����4
�0�?|~:C��%��u�º�v��� '�����NҘ$i�.�\�n���D{�D�)�*�@�':@�k�b��*�TL43q�z����5�F(�,�j�b^��k�t
�5�A㿖x�X]%�*��Th����%�$�����}�؋�:I�� �$N����?E��ɹ�G�"��� j�V�����nZ��m�/�2I�{�����4Hn�ќ�<b�oھ�f�N�9�!C
�Ip!՗-O-(>�0�OU��:U�Y����;�vE�e �}7�>�>T@�M����bC���,"�4��޴Ҙ�i��@�%�Hve�4�X�,H
Ȭ��6Q��zg*P�a�1Ӗ��)0G�k���TQ�<���m��R``5��>��r��@�<�(1Ӡ�u;�,�]�k�hhx�����|P�@p-�;��?�j�	���By�(tR��P��K[�]��~���r���Qq�B��$k��S�s!a�,�͚Å6��b&|�G�?�M� 7�$i��4���/v�Iu�ĒkM����1�N83rQ��DG�f>�����d13H{6n�>�]3��c�9Em��?2%�I�H��A�]�	{@:
�"-�˭���l��`��@��f��ھ�>�����d�Qm8��&� ��3L�����a1'�`bo��lVU�ǣ���
ob ��`'�?.���gv�^.�4U����7_�k��9��a�Xi���}�wQr[�cĄ�Z¬��Kv����畄x��:;}���/%[5 Kp6il<r�!�P���#7�$�����Y�||߂�Y�k%�\�pR�h��'���o?���~��S�2i��y�d��#fUF�uo`Q���p��:��/��+�,<��&^sd���V��p��-;�\Wcuщ�!9<�q�Du�{����ط����i�:��A��}��7w�q�+�bbe-��A�	v
��.��k�_<?\��/w�۞f68�O��D��D�3)k�4/s\�Z��@��֖J��uy�e-6�|�)}oxӇ�����L1�?�@�u̚,��}�vx9<?��7ߥ���G�d��lO˱;����bR���6/�6𴘙?h�U�C۟4��������,��w�!f$��`yo�����/:k,�e��j�>ng�c�-����6���_�b�[���W8w�۽�ڮ�p�f��qӷ��D� {�ǌ��(���(�V��D=\D��=��OZ;+��%n\�"us$�tկP�N!q棶p�B�)��&Υ=8'F:�+��y�	.�z�;?�����bd�	)�Tf=�؊�{���"I)����@G7���&4y�G�0�X}.�~b��-?t��@XF;5 1��`8eY����w�t�F�U�Zw:���uLpe�����U�	��n6� �d���z����L8�;��}���6R%
ugt�.�%L1���q�z�
 5K/5��C���p��$K��lxL���ɻ�cx��|_��6tL9'ڹO��m��GN���6^�ᦲ��6���S�y̚�e�x��7'	ܶ�h�<=��Ȓ�P��Ȓ��p,�Lz�5 ��C	_ø^�V�1`6E�����|����y��� ���tAm1��`ҥ�K_��uz�	��:��{���U�K5�q/EL�"
G�}�>w]��C q�U5�vA���Į{�[�n���F�� 7��KEo�A��Ώ�MB�(�фã�����9[4��Q�n3�F_��*n�j	K0��}y���ժ�?�Xu�#�ً�|\�&��0���<��ر�+�M���ulJ�Z}�    ����b ����o}���?�_^cG��p�'�+�:�fZ��,D8�M�>ڙ�rEK�<���h��p��b���e��ɗw��}��.T��	�Zp�^77!\L﶑�n��������x������eU(|�4H�Bm~����Mc���t=�2�s#�=7�}կS%�+p�p�! ���������ٳ.À�,`��#��x����\[��(׆���8��L�®Čb� .c1�H��8R�3�wxk�j���wUM�U�&MI�9��]X��ibp'F�i]U'^�#��8�/��z���0���\�*�ܴ��@T�����
?�ǉ1�ɸ!�w|�/&�`C��}J�Xƕ`l,���Ȇeܣ	n8?mRЀ���2y�Xe�I!�A�� �����:����v�irx����엞1��,	IT��o���V��ǰ`F�y9�=<�uk���
����Q8D���ɋ;��f�vѻ��Qū:�C]���k�2L7��M^×��<w� ���掴�	�R�]]	\
� �j�DA]�xY�����Op�+6��+�S����'����6�Z���{�?��� bK,�Y���F��v^������Uޡ?9����ܖ�\�=���xS�6��23A�,#N�&mp�@E[Õ��=Ss��g��id��f[�{�B�J��h�"�.ȝ`�r�aV�?��՘Sl��ۂ8��q5���Gx݂�[�{
��﨑����U����Yv��8�$���5��:2nPLK��0~7�J'��>��H��F;l���8��g���L���t��!&�z�5�A����b�_���?�q��6��{!�'�7�d���j&��Xo���� �C,�@��5��; 6�t#�M7�����+X�@��P�y�@\0ƍ���|s���g���f�_��l�PJ������nd��f��4:������|�����]_\�=��?��.�T�6�w��`�^u�֟�؜��&�J�Ó�����8@����1��J�*��)���9/Xo���׸�w��VpZ�
�M������q)�����H��;�b� \Ʈ3����'�('13�[o��s����*Q����~ª���:�e�ǐܭ��֨��fp0Z��nd���.�E����s����G�婪v��i�-���]�A�ާ�D�G`xY��XK���I�G�RWE�ל���q�������~W�d����"�*e� �K�o'����`	f뫔����x�c3���U�+���ѻ�cE�V�c.��5�m@"��X��B�4j� Rnn'����#&��iEG)�X5̀�p;S�u�@� Gr�����c}��v���H�c���8#�(pê�6��u�TA���,�d��ZEQ��8R���6ò�]5��k�z�bA�8�a���Z��7e��4��r���vu�L|�.z���)���x�-G�rr��w�Z�0�,�L�#�����kt��eEH�=`ܸTY_VP�c"6�LJ,ON|;-��]qn!ZI�iyGrs�������'Z��ݡj)���� �?�E9��6^L]���-�*������ (�lM���~��D�p��4ǎ\�[���}G�M��9R�ܹ�TK� ���p���	��T#�i��qM��C-&l,D=,�S���] ��u߄F�tʄ�� �8�0��
�,����KW�b�!=ޮ#��:�b2[T�����I99b:�@�s`�w�X�����t��j: �4ح3�W�i�`vv�[�t}�jy��7����PtЎl�0g�zfܧ%�:2X��\C�$G�֏�U1|�u���_����"eh�@�m��� kL���`��o�f,M1AU��z�X�H�%Hy���t7
ė�4V#ޑ#�9������M�e��͈�i_ ��H�ۡO&��t�l�o�pc3ܠ���nȔ�z��m�q��1N�E"A���a�6����I}�fK��Q	E�}��ŋrd�(gUl���8��%z�x�s�Eۇ0X�2x���Px�?3�7��#�u92X���NS��;\��۲yp\Lkë'8"�É:�9g��1����T�*���xq��ܿ�}������,��5���"/��^�)-ɸ[$�)����sd�<�yE��6q��4>wd���Q��ޭ
ץ'2Θ�o�Q9�E92X�'�z��N���(����uN�ʰ���ʙ@�<�YWv����`�
��Nfk��b[h��%(i
�� #�lt��F;o�!ܽ��~�yQ��$���!q���K��P�V��t�=^r#m8����k��Y
�c��ī��໪YPj�p���,�I��ld��F�p/\���ƸΧV� ��Ћ��g�OjDpz<VޱƵ�	e�C�Y.Xb�w.���p�����¡�3���nna.b�`���=xt�2pK�h��ld���D�]V��������W�mC:������ڸDNMY�n�*�S�kjzGrף���v�w�Xa�
<����U5�oܒ�z�A�k��c��3��@��c|z�#�D�K(c�j����,�J.�V>�����M�C@����Ш`	�p�E́9Og\RA5�2K�A����Tc]4�4�-:6���������̴��G&��p�>4��`k�{	����^k�E�RśkT���x6�r�ͥ٘���e����`5f�rP�K��Y*�/��O.?���
:_�����Zi�ߚڂ��fRi�(�U�*�\���5�������tL`��W��#�ڭ<��
0�2����(rNrT����t��F�E���H�I§}��\���)�b�/P�a����.s����N�f����FܠȐUĊ.˘�'����z9�1������%��uK8�r���T��dH��&&C, 51Ж �H�.��1�H����L�'f�<b�E.�.�p 	�ƀ[�,���M�x8T���5�p���g���,^P/��<t��}W�:��Y�����E�-�o��J���O#�G>[~H6�l��$�`T{ӆ.���/*���Ee�w���t�6x���m�#�ۢ��	��x��a:t�+��*؄��-1T�á�_�<
�]n��wt�{�/�Q�RLv���{�/�(�%�8��膓}}��������������!^�c��`[{��f��������	xXl��Ѹ����x��^p�%[__*�n���$q��~$E��Hl��$�T��E����iV��w�t��8����u�����hc0�`���,z����\��?�Eɑg�dV��1_�Q�,q��h�+��5�r��i����ӣt�߮.0�+4XO�[����S�T��E��Y�m��oڦ�r6�~DW��������ï��6�~z0X��hI�.�~3�{��EK[&��pW��,	N#�ä�4@��[emTKb�XFGg�
���YT��e�/�;�?}�zEނXEq�o�8�B�sR5Yw���+����S���x|i}��,&',�^�s�O6�+�7�5���_/X��1�SS�Ĳ��`�ҥ�U�lE�V�C|]�K~K8�	�+Q�ֻ������/$S&y-A��`k�$���ص~�xǊb�u�[:9��tKg��DW^,��&������_ڍ��Էr�IK>��<��`���EN�/�<����H��X�((RQj������y�̸6�����mD[qx٧Ο�d2S3��el*^��XX�;��Jp���XO5x;�?�1�A�CҦ��d
�K�M}��U�YT��e2/0�Y�¯ec%ֲ^͖+�4Ն���3�;���(P�ľ��&�Tlcq�3�k�[���@ﯟ~��D�b��`�����N�=w 1^����+��O�kش!��3\�=8-#8t��D��4u;"�n��5�P	�aj1��`�)1X�jx[�1�����0�Il�^�o#k�	p,i�����5�� ��*�H�r�|�E^8޹�xy�v�y��Ô9c �   n┸�����K�g�ߩx��
��T�>�Щ+�}t�R�9í;>���=|����Wү��>�³̤�_.��C��/ؤ���
�r{{�A���u]�<<���~~��y�F�'��V���M���>Pc���L�	.;��w�2ǢRm�_O������c�����.Y�x�Rw���d�޽��M���      �   &   x�3�420��52��J�I��L���425 �=... |�%      �   6   x�3��HMLQ0�2�0L�L!S.CN�Ĥ��"�Ģ�T.#N����=... }�      �   i   x�U�1�0���á1�g,���H���p��� qC,��X8�#�z��dKRI�$AR��H�$ �I��L2�H��y����r?c���ʄD'Sz�ѻ����9�      �   �   x����
�0��s����I۵=��@elz��*��W)XX'4���{�Je=,�1�<M$���q{ޡk�4���ξ2N *�z$�>gX�sæ����J�eTѐ�aE�a��é,�FC���2\4�����h������{I��v�=�}p��١������.5t0,�g�b�W!Fh��]��mC-�f)W���.��>��H      �   �   x�u�1
1E��^`���fLzO�Ղ�����GDa���̃�߯Z�/Z�˭�R�����:I�ZJY����-��$�Oj�����=9��{?�?Sֶ�@���A�#�1)F
���uuja,�ڄ���6j�&X@�	��s���M-�M,�	�P�7���-��)��|,0߀����b>�;U�gl����.Ղ|t��cK��^�A�J-�|�Yx��9���-�      �   �   x����
�`�����������$�J�мD��,���I'I!:��c�a$1	"FD�(�� ���!*�A6˃�	��q��u��&�Iތ�O���%�i��M��չ6x��l����kcː���E�	,�����MU�W��l��K��ncO�~�u:�u�����7�M@��a/P�}i      �   �   x���ˊ�@Eו����[I&]�	4C��E�4�!��?�0�ѵ�[��Uah*L���~���p:���vj� ̬��?�T g��ml$�r�_���\��~|����SF
�@YRC��Ӕ\Ś[:�r�v�&��'��Y� ~
F��ۥ;ޯ�ˏ�_�rS��˪45�Y)���!K����P�      �   &	  x�]�Yn�:���Ud}ak��HG�Ek2(�������*���g�bMTYU�,n��kx���T�f�1.v�ݔPk�v��e�������e{a{1�]ݘ嫙�>n~X���D�u�7�f�� ���I*�9�+dPC�ٮ�IC��VYH��܇�e}���a�5��<B�g��4��ڣ}y;�ۜ��̛���ȣ
���P;*q�C�6&T�Wp+�Hmv�Is�c��v3G��4Ƞ��&-O���}�+�*/"g�^�\A��&�0�q{x�(͓��֨xz��ڬn����l!޲�7��<˭���F��7�A�A�^�]�j�AWx�aﺩ�i}4��� �r	T8�=�2�a�aM2��=�7��y8i�s�>��m:Ó-�i��M�XT������u��Gg	+�]J@ԅ_z��`_��� ����� �8�Gv3�h��FX�]�1e8��ˋ��[���2+G�/$#��	��=�'��!5�$�*��6��R��󺗂��	�ҟi�z>�V5P�QԙŎ���� �XF�(�Tz��ET, �?#��{�����5��	r�����ͪ �G��W9´Ct�h,�i�y@��ܭ ��� e��#�v�N���!7�$���.*�0̂|�.YqE{MX�{�;X��O&��C����B ��mW5En���&�ê�o܈���ecrI2����z�k5(,�'�a	��>e	�2<�꒶&d$� ���&��̧���2���co�v�n 7��%pe� ���w�����J$�$��<�Hp��j�F�Z#(�܀����w����0
%"�e�;\>L8���=���IP*_ی[��(��9�\"���H\�zp��9����0�mP3wT���jBo�kʍT�)�	�w,��ܚ��_�N�r�B��U3D/>d�ZT�1��{*���Eǌ��Dg¤#N'��ʼ�kC���_��g�����yfB����
%�i�'Y�K"���| S�ɩ�o���=�����_��)��ls,qJnfFaޠ���^-���P��"��E�|��B�����GQ���ڏ�(�a���3'ݭ��������m��_�P}��ym&�^���[���45�v�9�[v�����R2LL)�T�eI���-�6���%��Gۚ���}\LQ�ۑ�$�::�#B�}�a��@���d�G��)r%�����Ŗi9���
5�S��n���bEP���iUY+u�Wy�� �#���	���0��v3��O��S�Z��1����x�5QMI{�k������m�D����nD��%-��3FoI�>p����9��J�s�T�i2U`�AZsI**#5ZQ��0�Ìv����Fv,�܄ĈR�O!UZ@��^0�v	��V��|K-����l����X�6����c����担��~�1�\e�w��>F�Bh��HK�HS�"͙����9����܈G#EBQe�1�+���r��� �.�McNn%�&���;_��E�8�t�2l�>����-�vRr�OUC5�a���<*�#>�l#�B͓<4]b5�1Jߩ =�&�n�M�hx�KD�os��t�X�s`O���T��B�&ñnGR�Yc���=�۷<�BxYu���ۙ�r����xB�V���؞�gV��#�=�\_X�#��a�K2�ɛ�K�6��L޹F��fe�k���U�4�1�4���o�%h�N
���>�Y�H�S*M�|�q
��D��;7��2���B�t�l$���a�G
f��k���Ť��j|��F���!�'L��f�|�C�q�8`�� D����ȕ�=ҷSP���e�1ҹZ}�)���)w	i�� �G@�G�	��9�ɖ�	P��*F^�6��h��U+��P Y�a� �Hc��#>C!���(���<�c�D�b��=�"y7�=�Дm�jӣ@q�'�4R��{��_�?Z�D�;�V��Z ��;�<��n���{A�|���XdFԜ�PS�)�]�	��;�y^�v ߡziBUR��r�����Ө��5�J��,vl[�yD��{��<
�����*����J��TN��=�t�~`+���D��A��+A�����Q���g��@���yX�%�8����{����Ǵ��9>�PJ�v��gX�.F���N�����!�jE��2��	J�?�|	UYzsycV�`S�S�4}�]Pg���^o�Pg9DCF(��k���w�+�s<)�)C��~x�Y���v:J"k{�����������      �   �   x�-�K��0D��0#~	�,:�@�Ѩ���9�����r��h�ӻhZ##��y��a:�/2u�8#z�^F���X5���u�Ū��M��6�8?i��+L#3V�BK���3�s���H\i,K�Ww�zē9���P��$u[�`K	�2݁H��nL��TK�{�����Ӗ.�V���9��'E��+ъ����Nc;��}�M\�s�Ah����x;r�����ϼ��Z�]�G7r&uߏ��)����[�      �      x�t�۲�:�5z�~�y�}�*&g��
�Y�l�g`X_W���l���RtDE̊1!�R�<�U��E�dy^��w6̷a���>�e��[���Ev���s�s�Y29.����e����o��P��j��3��I�:�/�m�fg��S���;��WO|��0y��~'����PEv����mVSf7���7�c_��27?�;����o�<��g[�d��o�3|]F�����y�/�8�wws��>{���p�oμr��=�y[�>F�g�av���j���Y����e�l���6�������[2�:������0M��7�Oi3��|���<��3�����s��;����"�V�?�-3E6�,����mNX̅�v�Q�
C�]ߓ3���G`����#�]����)净�����˶:߸{Ҳ>�����=��Ĳ�|#Qf�v7S[��S�����k?��/&D�	��{����{��겟�1=*�鳟�꧵��f��7??���.�8��d/*<�3�NnWf�i���U��-j��ٺ��Ўц뗗�-E�mI�����e�p5,��69�,a�T��o�e\���\�E�[�]A�����)g�"��w�oBx��^���!���Q����[HL���H&Bl�^�1�G� ? 	|w_���l�0��^- 'ۛ&�kHz��yp=����w��lQ�Z�*�7���W���}��EC��|$�eH��A��6�8/���'FK/7,�^��g����R�UH�7��`]�5��z�Qqr���x�� ?��w�8��ί�4'O�=5��5y��;�n�-}P�ӰL�U���6|]������U�B\�!�T�zq��?�h���~�?�K
���>y*�e��ǩ1��t����׌��UxQ���넳���׫��u���w��������) 8��L�W�����y5p�ܴǫ��rS:���ǻŴ�k����}=�דQ�U����^� �Ά�ހ�ܿ�����(/8��"��(5*=������+�p��i�W�.n�觻6^[4��*�������:��:���3����&�sr����j=��H����i{�w�ӏ�c����q2��g���g��۟����1�'���ާ�����i�^��:ɏ��R=���ca�������b���[5��������K����'x����"�h�P^��_Ǘ��{&�%}Ff�HMn����uy�mL��L�[�������-1�z��1xt5pN
�<�g�^�#y�W"7[r܏s�eL�H����_�Y�|��M�%�n��u[�!{���X�˼@���z��?����<ƫt�GJ�L��|>�X�� �4��"8u���}d +L5j��E���Aʭ��V-�˦��@w����Y���퇻��x��}�oX�f�݆��{�$DAB"mtQ�R���0�^�����G=�o������m��5�\���u�p���jE_���x�i���IaI_S����~�¼�W��1\�O⵺�}w�Kh�ξF�������˼q�/R2���z���^���ͯ���ŰW�.hjl\	d��-\�re�r
[��.~s'�t������}I�x��h�H/��p�ۙ���y�7�~��L�|���y)�XꦑT:5��,h�u�-K�J�mC]��>�ƞIK���a���O������_���J-�5���>�s{�{)����-ݭli���[��j��;?ʮ���y~p|��1D��2�U�E���3[B���)��{�{�j��0����ǌWꄹX&����A^��J�v��I��ˀݔa0�׻1��"�[�4��[(�,bjf�Ӻk��°m�g���`(�4��Z�_���zm�����Vw�
/�.�7���(y+�w�����<��tv��s�uH��+}���d[L86����`���|B���5e`��ǐP9������;��b/)3���-(����:�|���><N���b�|٧x!�.b�׸�~}g{�ū��`��l���CȐ�y5��%{x����B@
L׻���̷w�i��`�Ddi������K��t�&�[콢^BL��^�`������4�W���U��ϡf��f_��^/��d��v"���+�`��;�y�E�sKƏW"A!M g��<��e[���5�����ڟ�����E^�[�fv<�e�v}/.��u9�Qp|��x��5W�Q!xCG,n�j���w�Q���a��&z�"^I�7�
�c��۔9�������/$-��jP,�?J�
\���3��W�}w���_�ǈV�:��7
��^��V=�9JPx����~!`ӹ;�^��x�B�!آ3N�w혫��xl�zo!�׹FH��	5��S���h��ͨc����~�i�x���I��U�+-b/�4���w��|��5^�*6�k
:ߴ��M����Ǩ��l�==�f���>(}Op?����M�E��uR:'�DO;!
:5�$��U?��l��f���럌��mW�*k?��=lгˊ�ւጁ�w���x�	����l�Ө����5�'Q�wAK��Ѭ�,���
^g�_}�!#�b�V��1�S��LB�����1�n����P�5��s�+RGS����5pu�g�w��K�Y}�@5X���~��0���1}��Ǥ��i��i�y��C��zuTN���ϱ8����H�D����4�@U�*����h1L����}���H����.���t��> ����e[����n�>���|#��4��*�Y5J'�fI��{���9?��H��ا4t�2��~���iww�e��禷�G3^m3Fp`�}i0�'�%��U6��fh�N��@a�����j�b�X��3pO��p�p���yiQ"&P��.���W�no����%$������c��6u�`;yn�0�*,��(F:c͚����W@G]��K��n]�*L��bI)l�<?���%��&`���x�	E��G�̴~�L������w��J�6)�E:x�܏c
�����EN�\As��#�]M��?.�d����>����k��B5$Ξ�'�_��`(�TǛq>����۰(^��5��������?�����
R����+oF�	��\�~�*10~����f_ǫn���^�i�'c�+n۴o<���>��pq�Lz�mX��8g��+�Os��I�2U�E�i�W�|��z����.��'X��z��%��?r~��^<�wa�����I`H=7�-o HsK{��n��(P9��&y�m��&��mC>,�����;#�>�)��|w��;8_���W�!y@�ef���j&�|�_Y`���^��2�E7����xa����c]��Ӂ9��>����.m�ט`zId����@�٤�H�k�21������zRe�g5d���"����VC�qO�
o��hAD����z���F���/���D�a�{�ф��.։��j7?b�R��e��,a`�{�j�	�]ڬwK����ݴ*�x�-gG�fgH|�w�,2��6{'���4���4��~��؝�vz�n����D�G8�u��ݞw����qP���Kx�ՠ|�l'��^���0el�	0��Z?[��&3j�d��ϣ;�h��x����:�n�adi���ٞwCy��c�9�jF����U�?w���^�(���+�.�O��y��\��&(�S^G{E';�Kp�0�>�p�k�B��%_e�a����0�mK�e������̀p��`���ɆX��hKz��A'P��P~��>�ycq������ܽ�K��W��]zi�G�)��?��!�����V�5����8M�т�-O��C�o?��o>��\���~=:�b��mLz��}w+�k��x�}���7l�·�gp�v��z��`�W�
��0O%�y����v�Vg�_��슃)�h�`9��k4����¯$�4����u����!y �=��h��Ξ��p���/䐢�.{Ct�����{w��P�p�HG��y77늰���J!�O��*��M����<���x����`Ymw���Gd��{    >P��+u��=߳�s�0J�-*�������;���Oh;(�U����I��^��HZӑ��%O�A�O���9Lq㺻�k&��qg
Z*_~�4�Ho�h��H'���}3hÊ�f�R������y���9��t
*��"�o��j"��m�xA�t����rʮqq�����}�]����g��3yC��y���w2,��sf�/�Vx���Qs�奾�0�/C�{
��I�*s�c�D�%06�~�����#/̏e�=wI�?�d����o�k��)M@����S}ga

$�����_����0{;2:�Q+�Nza��ִ�ȇ^l{��&[Z=�k�u��9y	��d���:|U7*F��094p��=��V�T!(<Խ
��}"q#LC�Kj�
����]OT���A	�fH�z�-Y�w�g�^&v� �]$�TS^U߂Ӟ�q|���`��j?�I����ޝ�:ۼ�������9� 6bHz�����Y��&��6\���r��;Ud�ׯ�����!(U^�w5!��L�s;����	�f�{ȷ�{J��4X���j����CG5��M`ǌ�)(��	�Ur�d��]�A1�|9to	�aPz��}Y��⤯���3��#���j���������(1����s�6�/`��c���P 
�5<�N�+9^9�J;/��K��kxD��+m4����۠^���6:�^��)����! �?���}W�SE��Z~%�顿��dpH��{�����I/���W�c���{p�fN�ya.r�;
�զ���o�H��C�Tg	̉�@K�(y(�+*;�'����o=-�l�sAM�bi�xGZ�;��B�a?����L�4�v(΂������[��,���8�mS�^r�s|bH��c�Z8r��XX��i����)�u�>�,�O�z�����0� :����'?����{�Z��!���v]��*(�SRP�g����dU.��7<�pb38|C�I(���mSZp��/�h�	CgNX�%6��ɢ��UMx�x����&��xZ;�!���*y�p��y�Z#��~�J�5�篟_$���2$�TA+���#j:\B�j���\&�D����M�ظ�8x�s�<������ߨ��1����d,fx�����ж���व0��p����a�μ���c�8�0�Z����"\X���zK~��L}L�曒��UZ�<ZB]��
+�K���/*��C25��٬w�`˸t��ɂ�S�F�l��s;d��d��3�bZ����8Ð����c#pU����]GjD���l�M/hD����D�vB��M��Wlcs��$�c���Oʐ���)hj��i�#A&�5r\����tMא��%��|���f�g��s=i�_�EOm�ٌ��򺟊��D�v���B��������
^g��5�����4�-�Q<�a����00�9k���*O&��.��;Tg�����Ƀ� �>�=�&�xw�a6�q���ipyvA�*۫�W��-މM�Y���F^��pVv��/2ئ8l�Xͮ�!�3��p�q<�c�Զ98t�E�[?�}sJ�+���C_��	���;A��&�%�P��z	^��L�!���&�)��E�������΃�{����n�TR8�m؃[4�S<�^	�s�ND[��s§˝�f��^0�k�x�=W{A�n��A<4�e"�XB<.�1약Ii�ɳe�-U/ؿo�x#M�ن	МQ/�^S��B����'ۅR5�U�m
�U�W\/�����r^�:{v�X��Fn��$��m�0�v�{��JS�d�w8�����nĚi8"��D��E�䚎�M���p�}-�|�����+h��P%����d�L]M`��������7�W��p���:yLG�T�HM����H��ҫdC�c�0<��	�!��e0�%8e��+�Z���關q��Q18o)��6.����ЗmF�Ņp�tt�<�I.g�X�Q��)��k���q�%jI'$M5QL�fZ�*��0��1 ��==v'=��lw�m��z�5.'?�^,D�#�d�P^�z'�G���d%㵊 �8���;��-�Ra8d�%~*��9Q�v��
Ǩ��$ͪ��'�KS}�C#��bp��.�������)Fݵ�4��S-9�l	�e�8'��-ο���mS;�j$�PT�բ~�������e	�������B4���j��Rf���9�F�M����d.(H徎'Wx��
��{C�����ru��[�o�:y������ɽ���c��0m��	�{�$��i/8��dbG�[H~�q�<7{Һ^�O�(���ZW͸�?�<E�'��|�oWK4�y��j�<���l`��ۏ���?/��y�G�P�'x��;q^��~�)���Q\5W��Ll��2(0bqdG��������U�a������)���-	A��t)�����I�_/-y&��s��L�ǅy�滐-G<��P�$���V:�0}*ƙi����)���C��=P��JF��\R�.��4GY5y�a����W��za���3�_f%f�ew0�L��,x�h�.mk[q��q���$N��!��T/F.�����u�rR�n7�j�!/�[�7`��N?�09������"w�e����5�
&\���Å��jy�d%ږq>k_K��rvYGU��5D���%HD���A���I99�:��`ؒ7�K���/��h�}��!��h���ٳ�?�z?y���H�v�w~û�-ڇ��+6 Y��'�ng88�M��B��^�d��^ſ]3�_|��?Gn�u�oZ
���5҂�iCZ<>�T��OgG�gPr�[�-���+~^��J�[��s^�q�&h7���&N�F:y3�gԠ��A!h��\!:��iy/DO�j�[%�A3^��3��dlUbP���eM����0��Dځ0t�0����lz��5��B(�b�"Y�$�N����: {G4GS��f�
��1��۾S8�n�|��;4Gyx{��5�`���R�(D�:��TI`U�C�
� 芣S{�@Ҿ~����E:E��=M*����W% �Hx�p��U�&�ױW��Pa/�s��(�?���(��d{����e[@�Ӑ���z���()��q��E�0{b�;^F�F2��*E����㱫��Q�-��G���(:m�(�#(h�|�)X�!��N��I"����N�(
x�9���^,00U����{�o`R�p��	)��{���@+���R�C�xE��N.`�����+ 㬔�����}'��-�V)u7�(3q,�2�|�S0jV�`6�p�C�a��^�0�
�ecq$&Zyc��zwC�h��d�x��&�YM�q������"��O��ߔ��c���/XI�+�g�{�L3e6^W�<����V4X�IuH��mw��D�*�����l�Mz]� |�,�
O�y����f���,)��^n?����U�hE����]Cs����ds�k&�tl��_'��S�X/�އ���9#� }1'�����	W�EK� �Y%B��q��9L���[��⺨���K��0�Ȭ�^ѳ� F�d��'{A�>do��Bi���G�ͮ�i���C��f���c/���$�o1�l�xee
����6�u3?�*�m��w+�\�pg^R���I4E����%��-�qM�:��%L#�k�p*��|�N�j�;��0F���c���dɎ�	�p`2�Q���Uy�u\1\Ir�h�	WGaX�i�Kl<Ĝ0-���")/9��$8)�I�j��/Ӧ��n��Ց���*xI+��rn�I�MԔ�v�0�I�ሦ�6M��b�,�r�?���7U�#�ܸjkv�aRo^3���m@H47Y��{T"a��U���,Ѣ�m64�L��	�!{2%=��d�ɚ+Tn�`4WP^�x�Ur��p�������	�U1hÑ��Ǽ���&�O�]�oIS��3Lw����������pF���u%�b��'    x�ìc<4�bm��!(;N�?l���|��w4n���l�z����/���p��r�;��l4'��c�J�d;���+,��+Q�8ņ��c��󑒤�m���������]J���/�TMI����4E�H���e�4�S���c���^׷A�X=y�qw���cj����u�?E��F�8��{y'�Ӛ&ԛ�pW�6{]�i�a�ԻG�K��d��d��Ķ�!�e������|t8'�W�d�>���pUy������6�ܩ���F�&����N���*�1�m%9���B!�j��j�q��83�/ڼ=��\��&�ǝ�$�4�PB��a*��B�T�0pCI^��`�'�Lܳ1h����)��&o�V��\�Bj���<�*Ře?mUq`����O�_R������vuɣZ�:vw��:�IA�8e��jT�rkzE.�n�r�z�LWa*:�-�5�z����b�p^Ӗ����;W��DK��e@	`�
����D��x}���l�4%�ӌ��+I��J��:Ĳ�5����>���������]�Dgh>�<o�Ym��T�?�mkK�F߃虈}74S���Cv7�!}f?��LK9��ك:ʘ�X�爚m6���.m[�V���_%�G%{��;�&+����'�QR���e�<kW��5�����w{��;�)ƫw�h���uY�G�'�iMq��Y�A5w�˔�L!@b�C�#�4,��+���"�5�&�`�o؞̖~����e�/:�����4E�֧��E����R2[����`��)ƶ�+�PM�+�;ݤQ[⃰���Xy)����[\����\�)�s2�݉s(9�F���k��$�S�P�>C��D��������PV�=�Ġ��[��G�*�9%�=v����
�,1�0I;5%e�v�͑��:P<���y��ދ�ZvI����sװ������FP�R<"��\���e��n4^f𑄷���IǗ��V��\�mp����
�8񾔲���ͳ<$"���dDj"8�qdBĐ,`m-�QO��J��,ɣC�1��O�:�EpC�î(q�&Oi%�u�.������J�#��{ߒ�U���Pz�ȅHDuư�%-���G�U1EuDP���lcި���h9	!j7}��Љ��ȫ��Sa$S�F���c(ŝ	2��"�Bu7�Ju���4�!��{�0�\�t�x�x����Q2	�E,}�e��^"�g	׳��"���PU�ҏO�!�E�!�\���@̄勤)Tb��z?��o���gX���h��2q�ʴd��5�،q��N�e&��'�Ù{!�����%�I���NR{rW�"�b:�n@��!��2�Es2݄�!��!���v�:��S튉��s��m ��!�WR��p�^�|m��qw�*�����P�:�v;@DQ����#��i���ӇC/;�P�����N;W1���M}@�)��5��P���SY�n�������z���*�2��z�L�������q�&�H�t9�&�r	ab�=�(�����%%�U?��[L;�Y&��ȸ�-�o��G����������<�*�9rV�b� 7ЛK~_�h4�((��3��.�~�'TC9�M��p�r�L����D����F���xK�.wqO�U�2\�/���	��-LE!;}M��d��`8��x�8[���j	� N�[-"���X��>��7*�ܬ�Ǿ�bh�B�g���rO2i��l �1���L�bᆾ���E�����2x�DLG�?o�p���������>J3oEa�a�h����LP�y�#�����S\�j��������1�����\���R"��q��5a�����!!B�fB��-L��[�5n�uFڥ��L�����-r� F�<���q3��>�R�i���+�Q�\-��ra�!&x)�_Ve��~��~�D�u0�]�
"\���>�J�qw"�'�쩫?"3�P����29�BL���*�793sĕُ_��K�
=��"�k
�_�O�3�������|0{F��0X�>�u�'��dث)�#T�g�2DA�v��{��� ��Ӿ!��˚X����^�J�n�w�o��r���E.��솔�����^dbp�В­z-����=-�[L~V�^�X�͚d�����3�V��%-E9+Z{�������4R��^xu���%y���-
\�T�w[Bx%�}}qʜ�h�=�ه���}���~s�d���=lJ��	��/�o�#*�(~ѠEb�
����_��L-����<�ԋ
��3N�~���q�����Y�=��Bɋ�r�N^�I�7p���E�^ (���Y�U��� S�혼�z{����+w�|�nJz�T�'i�1��nX��q2�^'��kt���S&�@���P��Y��I[�>�>iQé�m�U-ϭ���Y����z�����7� ٱMѾG>݈B�cȨr�J*�mQ���ks ��Ò��N��sX	���}Ԗ40��!K\D��|U�>��\x�r#���1pA1�J)D4�����s10|��)�^{w���4�M��q���ޫrl7K�i��6��d�i�[��\Z�ZaD)G��~Z�o`=Mp$o�y7p��v�őp�o�h��<�&�0�Hҧ2��a���S�<�t���U�;�m��w����J�	Zg�+_�xDo�~#��A�*�33�RM/!�jt!�&�p7�^ճ���b>P�;����v���*��N%Q�&% �C|�Mos�2��\b��:�}oL�����K<`Ðo�޸������.p�p^��3pE��i0
_��Ӥ<OD7�{Y-a?]mc��G5�Ɇ����&��/>n�������ͩ8����u�3G~�Ӳa3,�m�%����I�`�V��
���nJ�	�V�8��.��d
������ ��-��p>aʓ#����GO����> �H�ڸgˋ(Q��T�6���	���ɝ����Wp�{�� ��;�y���G+ɹ�joR�Q[���{�Ln>0-�@b���k�M�ݑn�Es�J�Ug[̠@(����oQ�U�g�J���<Q�rt���U����=�]�"O����<�cG;.�A-I����P!�/�z�}V+B��M9P���¯��bp�R�_Ȇ��h1#D+�G�uRn���?Ôޫ!��H�"?9�
�S�L�<B^"�[���ִ#�x'�K��6�~�[��	����������*C�Tׯ뛽u��ov/Kt {�G�����R�*�	Q'�"!q"��#T+����8��%rRM* ���z����T?�$DN�k*��E�q%W�{��y�(��1=�?XD���.���A�%�����2H4��aHj��P4t���Gr��F���Իq�������B3ҍ�>$���1�E�Gs���� ���_P���ɛt�_P(��1�%w}��1au\s5��������?�
E��{i�Rn�z2/�@���%^���I��!ئ���
rm��2_p�E�W��e�G���{˅��=�>���iI��SN��3��@4����^��V���p�0����w2T���^WCȊ���ԴWS�W�}B4r���(��d���pD�{�{]���=X?��c�y,����1xD
�[Ҡˎ�hD8tw�����[-�e�P���J���eC��f������*�.�6������HH_xC���|y�*������u6>�!�MCK�����n�ѿ��:|w��h(�����6��<���7�q�<���8��q«��K�y�"RB�e���J�&��.�Z^�w����iIU6?Mr*
���<����f��֢a�O!`L3)�,ӗ�V����*iwS���g����?;Ӛ1�T݃UMա��%�(@%� �Q�6��7|J���mt�-�1��KZ��&�����1�>>�+
�:fE���c�fb�V3�rI�,�?P�l��z��T��9ݷ��,�k*��&o��    s|7�Q�fAD3��f�L�[Q)����qMu�N�i�&��aW��q4R�	o[�mz�O}m��K.3l[ӋW��Owa9���%�o� ��h��4���i�I=�/K�,¾��;�F� ّL8��B�Lr!���ˡ�����f}?,W�j:Y�&��y���T��f[F�>ׁ�������KT]0�g{ ���o*թ��9opZ�c���K����N	a����U������%�B!���Ǩ0P�_B���D����0}�=�5���S$�[�H7�j�`d#I;�8Ӵ0Ů�c�x-j��E���Nd�X��0���W�Ory/������VsEI��7��!h�/U�yDp4�d���F~��˱|	�,pϧ�_�t�n�+r1L>	g\��҆(���AK�V|2�����DFp�0���lrT�)h8��z��P��܎Y%x���cF:���Ԥ�8�n�{X�4���ցW�T
c3-�%���:B4��2�}g��h[�	���67M�d���i����P\�5���+��Lɴ�%��z�g�� u�=ٹQ�h0��5�4�q򴣵�St"T٣˘i�%��zar(�iKl���.G�5["��6�0#�jYN������:�KG�<�f�v"��q������e�:�������Q]�m��A���,�I�皞���1�$WK�P|��x��a�~�|��p�!0�&}Ǜ�K�>��2��	5�	��E��`{5�ʎ�~Ԋ,L�#�̀ϝ���^&���wrf�mh`�wi�ې����f�+�G$�v~��5�58��5�r� /��T�4�5���02��\�e�zW"J���~Q�
k�?!'\'K��p>�tjE'�`���ph��F�j�0�g(����R�W7]�=���a���y�G���D�����6-�a�$S�%�f!zr���c�2Z�.8�'F"\�=��N�#���
�W,��A����"���R/K���ݎ{_M��F�hf��?�p��n��>gUr@`ʴJ�zW��]N�C%�Z�hå~�UK�-�mFKL(oq�x{s����%@�z[̑��n0� ������/*x�%�>ݷK�BP.���N~K�./~��K�(NQ��#�d����~"�>'m�Q�7�������;dϊ�"T���4[f�22B���OS~Ph��/C�엛q]�;�?��������.C���}�	a
�SE��7�]v2x.�����0�Ԥ���4�bQ,���E��1��oX�_������i$����*Z�l_ ��{q	L�U�j��<�,�T��R�S��W��΁c���&7���	��~�Խ�ْ_�@���Ȕ�����QJg(T����S�u�{���m�k��N�V�=��!I?�-�R��ԎEp.*���g����x�g������p�/�&dɇ���*����
D-�e�W@3M0�K���Z��<�ԇ	**�d_�qT@��f^�4�H"�y�;P�y�N4�X����v,���U쮢)�iK��:��
D�=�_C�EIM������v�{�*i��n�(���d�TG�%7+�L�gD\�Y��r�:{q�������L�-��W*V��4��e��R§��4>�)��G�r&)��v��
�K$mWr��3���zh.� S�c��qj�O*pK���D����kOkKS<��RHD��ƺli˨��+dx���N�O���5Z����:�X�B�n��0 ���7�cʝP�V�<hS��6�W��߯ǻZ	Wp>��(97�?�A�$g�F�p5�v�q����S�n�e�G\�T�"�����l쾫�0S#��w�E=F�<EB�~|;������'��/�Q�3�g:n%�Y�d����i�xs$��ih�+� pAYoI'��������ú%�GYW��:V���ih��i��ӗ���+wJd1���]iBr�p�؈�\+�0�5SHZ���!��K���
*���*�������A�M{Y|H�����c� n���oC
 �ݰni.6�s0�R��P�[�(�$q��PE��:n�#(��D�i���I�a�_R!h��t�q�U�Wg���
��W�*Z�f�?Yך�2�#&iMU2F�B�k0|�B�l@4��:�mv�G��8��^Y(l	�-�4Ӌ�[O$��͇�Z�h���ٜ�ѓf4ߜ_�5�W�fJ��.髆Bp�Nn�[�$�CXY 5_�ŋ��
�GT˔hݚ鲟;�y4J����YO^�+n`�����sv�H.)ȣ}��}���4����=�a��}D�'���,�i�/�C)�l+!�W{��Y�nD�T_�h�2T�<;BGb5�ډs1{'���\!H>8J�c����<��kI+N�0����������� U�H/� �h�m���[9	��}Ԓ'���,�N)����!��$���P"(��B=��?mi#z���g�a���J����r�����	�M�HY�4�s�i�F�0�pK	�<��Q.��,��N����k3pG�;�����?�=l�#d��s��<���u�%z�o�1W�}A��PU��<��0~�N�C�y�A#I�ԧ�����$��~���)���;�(������j�QL�؝4U��wƠ@��r^�ll��x-��;Ҵ`{ޓ�kH,�U�'!::�:y����Ǔ�)��&�A���lGr�g$�z&JX�?��ŏ��X8Þ_ʫD�$&��bh8
.Lo���mҳAN]p�6(�#́�gl�	�ҧq޾��H���hB*�\S��t���k��"��´���HzQ�k%Dj����)�-XP�C�h&���-ׁ)���s(]�؏�C(�&�G�� �Z��>�@4�`��'�I�1d���M'm�b�}�h/y�%=�M˻��8*��t�y,�>�pAeR7&����E������T����ڜ��"���{�T/���蠨��r\iU40da�ԧ������5���'�\�E6BC�� �
"����X�	9����N��g���T�AT��CE�l;V� �d2`�i��$%ڂ	$�x��d�ȿ��R��Hޥːް�%rI,��Kxs��o�����?&��+���kx��¡?��#I~ �z�Rޗ?_:�{���c&"wxͣ�9����OON�^�8��`�V8%��Bў��`�|���;��I�(����";z뇎��J����Dd���ܷۖ���?���jX(�u�v��@/���%]v�sO�R",��s��)D������D�NW��"�j��X�;��9{��2����Se���\�ɳ9��׹��p�w�3�(ԇ#c�s_�m����/H�������!Vi�8竡�`�Q#U�
q1Z�
Jc�*LC����hE/��C:
��Ľ0=BݔJ*x�"����[ڔ_�!8)Z�%9�&�����R�8?���^P�`#�8��EjV�ZR���^�*dM��" pO1�1��ٕ[Lwx�������`{����oX3]Jֱ��2r�mGc��� ��1�့a9����خ~%���a�L"_���lϥ4�	=0<
ȃ�0�'���X3����5S�̇���AP0��:P�����V���+! w\U�gMF��5E�������D�S�P>�r?,K�+3��3ߩ#-3�y�5��=�B5�>3%�a�5F��w��ǷΖ����}[�s>�����Pv%?��5��0���^�O�OE���LMgOo��0-��(�C��#ZD�����i�xz�S��EB|4�Q���[��֏@T|Pi_'�o?NZ��Ł�-s~8/D���Ţ�n��IL�/D�̱)�$���y;�A���-�J�g�0pmy��!aj����=�4,䉵� �Q�#���#��7/o�!䩺W��KqZog�������mTH
Ss�
���"�����e��S��(^���������%�U窆XD����;{�Q�'�c���J�
^c+O�������_3�n�4���:�V�{6n=ԩ�P0S���sJ�ܫ�7ʚy������iý�H�R����"�q��:��Q�A��dfUQ!Qd    (}N��XҖN���3���6��ݥPE���i_#� �;�;�W��-�p�G`>�J�f\��޾���bC��=��kҬ��L�F1ar
�P�J����H�
Ur��hd
�`�d�*\-g�z_)�k�g�l%27e:JHzu7ӫTun]�n��3��J���f�"6oI;��lg^38���vbON����5v��}3�/g�VZ������f�3�""~���u1�����]���)Yr��)����>�>���L5ZZ�r�o.�6[����io������^�g�_��2��,:��aK��R�t8U�{Gڪ\���r jɥ�~"�?����"�5懁;�����;.�ٻ#�ԁ˽6�/Q �ˡxt9�e@���>%S'g}��|���<��-f ����N
�S!���%e&{�)��ݽ/̻���c��_G�\�+��� 'Ԉ��=�_�A���he�[��46�V���ޭ�oK��$*�t�=*&�۪�
�@{}�&�HD��AB^��)0�5��Z��&P1(閊7Z[r;��h�����9%�B��y��D����W��D(�"�60%�a(*�,D����I��5G� T�-m-�)?��M0�&/��㴝RT�����B�R�:�K�U���P_U�Z�.��r �,9UT+I�S�O�]i���um_r�j}��v�W�ph�r$��d��h����!xB3��v�\�Y��Uo�ٲ�~�7�(�a�xo�B@�|o��27�s�f�"����
n��U��iq�JǬ�P5*GP}��a/��m��۫ J��%ד7���T�&��~�c���I˗�q�G�=������BC�G��쯑+P`B���B��+6�+�T�r�d�n��^��`:�(��Y�6�_Ȇ�2D���pG�Jh�<��'Ɖ�k��<�3W)��סV	�TST��j�L��J��L��Jtjn�����|#��Ӷ�RZߓ�$��xR	�7w�7�]�T�7��n�f����|�+$�$[�t��(�%�V�Ik*'jrE��VS��Ǥ;ShK�5� ��Dx	� ��a�f�M���n�V���9s}��z��fC(W�����<�P\��L:�,پ�t����Y�V�?�����bp�yz6 JJyz��e���I�h�JS��0�gT���/ �8����p�?4�4�ƕ�"M�bv�i���!�74��5�4*⬺k���AQKv��%���!z5GC�=ӻq��ˠ����	x�%/Q7\G0}��S5�4ދkKzI�x(TvK.j�BA�T�)�*����:yF��Mio45Z�0%����vM�ln���f8�����D��fډ^�C��1lZ�s:윯o����j���]��i6�0�	rq9�ƥ���P�X�y���A ,��xc��<�$0$�����R�e��ʇ��Br��m2o�Se���[su�^�쵔���R��$\'�t��C�]R�+|�s;��>�x���c����TS�Q��\�k�x)���l���

��J@�fɯb���Pc҉�]�T�H�)8ʓ���0'��x�ۼن�>	h��sOYv�zn� ��22ϳ�E5�����P������3TGī�O�Uri��ߪđ�sv�J����t�=EU����)AV���(�~�Α���)M�_$�u���G
����d�.����Q�t�A�۔C��r�S6����G&�u|̚,�$|�/.L�Y�&�E#1/j���IF��_Ѽ�IrO-���w�^I^�{_��cB�n&���"���磤�H���B7�T�K�F�_H�9� R��q=��r�d�����Kjf*9"Ipr�O�P�6��j��~\C�RMQ�)ިq9�b��U�ͬw4�,��Zz���C�����9���T��k�hXL��əA���o�x���?��)��	���>�9�\��މ*ik�2ع,C��c�l��a�[��R\��v6�z��xa��5Gy�C�隊�鲯�ɞ�٧P����DK�������@�UgH��S8�l?�+�/��	xNZ:����{`�3s�(�uh��#� ����6��.�
��r(F|��|�zJn{=�!���-y27�Z1,��f�b3g��̪�ڨ�GU���(�ڄ<?�
�[��&�m I�̅��G���d�q����`g��Y��Ѕ��U����W!���5��h7�Xd�d}^�U����P��Y��=XT"a�H��Yds��i��$�c��YQ���P��ā�b�Z"Z����[�T�ONbJf:*�~HJ�{���b���֣3�3��/n>����<�U�a_SQ�hM4;�Ͽ�f�"�6��v���OG���*uʐ�{��$DA���c����1{x}Vd����>e�Ȟu����m��mޚR\5�6\� ��6Jy�L�>4IjM�eA�2Z �)!��ᄜ6[	h�W��8���25Kim���6:����O�f�{'�����ŉ�M��i��Ti�� %���)s�H�W�g�Y�=��kY��k��+��CGs��[bB̆�}�g��C���^�\�y�0t��8һm����.E]5��[8N0pM�#Ñ�@����M��M�9$�TJ{�kȔ�حɚ��s�͎D2��K�%割��x%م����@���;i�RO�@ѧ�d7��lɐ���)o5����ސ��B%�Ѹ��c}MT�����gw�L��G߅�4���u�vRD��0��E��/�g��v7 LЬxk��R-N�U�ES5�E)/w�m� �$`H����~v��=�pfuG��"6�ɐyf��j� 7��^�Qs��S��xZ�r��H��p	k=A��ؾo'��(�f�\?��Ϗ������ ����A�0I���
[�h�2lV^��O�� 8�Ϗ]K�"V�t	܅��h�g{�W�ݵ���*>E.�;Ջ�*a TI�>XQ���/��������O4�����`��ܓ~�zR��Kh��,.8�*� ��!���~��5�����j���1-xMV���U9��s1e"Z&�p�"�n�0T��2�z���3����q�K�����3������g����I����,ZB��{�M�fk�;^^i����բm6b%�X���c��^���orF~�;Q`�?짹�,$�M4�e��M�lB��R�|$��=߻�&
V[���v/�r҆�\\K�F5N>�IC�Rǅ��@%��	��yOB�Z�\��Z��4.�R�K/�,��0��|���l,R0\C�c�iŲy��pȨ�
{y�	.��j~$�B���طiX",���F�qRД��:�wT�����-�i)����&�[�X�'�ò7�P���8��$�7�D�ל��-C4��m�d��;\8���ڟ�8��˱;ia�!#�d`���?��w�þ#w2L�������=�&�}4Siì&��@A3\:����	/���
!���q���A}5P��Z�.h�6��s�*9�D�Q	GuV�|�������P	�%Vk���4�y&��B��v�T ���S�ٜD�"��!g�#pQSTw�Ǣ��H�Z����Aɻ�؟S`��h"_Y�4�K����ɬ�o8���̭)����v�wݤD����>�%�C��0#�)�hB����$R�go�NuR.�b#S!
��g����r9���a�`�٥���7�M��A9Lq�jӴ�v���LKɖO_��e�Ⱦ�S���yʕp�\�s&�P���cZ���e��t
�E��ո�7�;N�HN�6���,������P:���t�d]}���˅�9pt�r$�k�֣m�c�w=���$N�Uk'�;��ԓ�T��o�9��|�S2o�h_�О�#P8Yn�g&��nޏ��� �h�<��a5\pJ�buI9<�q%T���8=,	��IStP�	7�� 5o>yHG$ϔ���7!�+{h8;���yݟ\0����t��(32U�'!�x)ێ�[M��W��T#��J�S�zI��^��EH8��}J���t����8����sR��ג?O-F;��.�M}z    ��3�%\c��5�f���&)��}��^��׉�;D]�|P��A�^�������X�	ﳥ_�����u���彭g�"�u8�ڌk��L����� �9?\�BK�R%���t�x�I���GҚ*%9��ً*��M]���f/�!z&��=�	����vWSD����WG}d�$PA3�^$Ѷ�f��34T��wB�{ڟ#����6�����.�b� {������y��~&a�6�S�U>"�p������T���(7�����\�e��=���(�C� ��o�EgP�����)�`I��U��/h���Lsy�w�/s'r�{qn��ȏ�%��e�����ޏ�5Aq�W{J/>H`Mt�>QV2f\R���j<d�`����,uW�2�����(���:�&����ԓK8dH(��5Y��Z���9{z�}B�h��t��#�=��
�(�r�����8��/D	?lw?�����W�75Ug\������6�ꆽ:��:
W�h���e#���������4��ǅ�r�J�G��r����RCJ�
�D�c��~{�\]z'(z�[Ȓ��V�!4щș����y�X=�l%�A�eLT!��}rA!����*L�o�2����C�5�7z��,����Є,҆#k�rr��y��&-\��_�.+��f�������Ə����dg����Է�5v#�fE����u(B�GsK���k��@-�U��`q����vO�58��֡��������d����ֻK��~����Kr���4�_-ڑ\8����yI��oIf`� @Fk�P���#:�=�%�@tw��7��͡���5E R^�4`��� ��Y����G��ѷ�5�OG��� ��5�g��O
^�I����
�X�����/�!����s.�j�A��F��Gݹ�U�8!��$��A9��*{8��Z`w���ج�"��YM7���݌S]�0�<����+��9��$߹�Y����3}���6��\��NIW������	H�╰�є	����@��f�q����e<y��B�������x܌g�\�;��&��q6h�n`��Y����`�G�9��<����^W�#Ւ4���ZǢ�c`�[�[ ��f�s5���2��Nğ�i��>TfQ*\�M���n�;e�L�����8���(����]�J9�j�FN�kP35�d(׮�-g��q�_}9���#��x(����l��8����+������e��S5\eT�tN�:�{O���&�[t'��$3��hoӑ������Ǵ�����,͚ʅ�D(�]^�n�2o��I�\br���Ly�$%��;iW���5�����9k/�'���s9��-�3x��70�d�{�H5M6kZ8�Esl��230�{z|LA����8R<.\KB�%D�ͷ�]�C���C!:$��)�ɣjL�)P��~������
�K�g5[I���5���U1�}TU�D���,��ftt�{|֒a����~Wfz/��9P9Wߢ�:Ca0�ǭ�
�?��e�����qZ�H�	��.�x�ٙ�>:r��\�Rj<k¬�u����_��a�������r�l���Z*\�a��%�\'���5�ٽ�pT�`�M���t䣃A���E8˛ҾA9��/��I�J퇟��N��x@%�k�<�byw�Դ4�M��z���J�Z����l4�siϤG:݁�;Dw�L.��3���RDYHS}�z.��Lo'\g~qW��'ӌ����)��9a���d�zFW&�ضh~
Sd,���xqaJ�*D+�P��1h�6�R`�D�`�x��c4ڑ���{ܟ)��Q��z�iz����Nw)�603eC��O�+�q�*Ǳ��h���m�u"��
��X
�6�nr��%V��4�!��u�LƝ�������5%4'��}���@
�R���«�T��/�B����ݬ�{2�N���k����N<H4�Kb��^R�����D$^��%���=�C��)��4��k�mՓ�e��	�R�L��k${����G|�f�jR�(�I�MhV�+"���f�t��Ν��xk<�����]$o�jٲ��%��y~Ԉ�6�ό{��>[���>�'��(D���G"��zLQA�+�B�Hr�s��P����٫Z/�^��u�v��ʱ�
_߷J5�	�}�=^��Ӱηh~�۲�NM�X��eB���0M�����Ɇ��"�^�ֺ�j���ٶ+z6t-J,A9�|=Vf!r��6�
d�X�d4���ؙ��M�X��I{l=�kض�~T���!IO!�lE"��q'�L��ע�q*�����kD<x��z]J����Mh??~-�6#�N�sh�sLZ�R��,a=�A���R�F����py���Pp۞F=/��Q�]�h#M�����7d���`��ŷ���z���+���K��@.ԒS_T��>��TΉ
N/CUț�-L��K[`��g&�a��$�s[M7��Г4�+"O���DX�V�y~���l�,��ȝT��@��q�<��'����q��|�A"Δ	x�Y&�#}����gwcmA T�@��BBw�.������i1�R{Ek����7��j����mq�;	���/�h�}N:iӏPp;i2H��\�'�#tO^�T��4G6~���C��`
f�?��>�`��	���fP\�l�Z+��
���k
idV�^B��n�LIg(Cz�x/���Ӕ�ȍ���Wr�^��h)�8}I�١���N��ΖL(m�QZ�֬�������_�� =z�t
}�\�\�FtZ4Nj���v�~��	�RJHj�a�#:��{d���4|���v��C�����·�f$	E5	;2�s�`�PM��C	�(�y|�ܬF��'�i�S-%�S3Ep��-�8�\�׶���6ᨨ�a�ih&���W���&)�F4��(�g�dM�D\��*$����w{����_�d�W�����^�i1�ߒ�`�i����ߊ" q1�5>�y��������>@���&v�$�f����D�&�7�8�I�Y�6����|�TQ/)\٨�w�Sx��c
vf�V��0SE�O}|La��39�6a*�u�'�0u��m���]�Q#*�����0�T�FZ���P�y�EL�<xc&L�A�F�e;���	��ȸ�2TW�g��	G���!!����
��bW����ԮH�2SQѥa�0��=���y�`$���!ur_f��O*Z�F��P�h��/�1��Y��<
#E��8���9Ƃ0����V��R!` Y���^|/�#'��l�����P�?�4T�p9��3ɣ`�F_[�`����S��[zM�K��*�4��
Wȶ6mH����}:�*x��]���*[��_�b-��qs!?�&�P�����X!c��H��y�s_ή�3~��f��-)�F��-� ;�U��b�O�6$���9z���f�U��F�(�9��y<�p�MA�	�sMզ��.�T
>�+��k�B6�>L��˱��3�cT�F���9��Q��!�i�A*��_B���������+&r��)?��5a���C����s5��A7�kGGL�S�ѕ�����.]ԣ�~���(�o.R'/q㷾�zFp�	��DMz��(B��w?A�s��c��o�H�%8JG/eI�{�^�I9-��C]
�v����A3�ʭ� >F�PTw�9�0��QJK�&�:`�����%C��$%!7�f
l)s��zgP�uy]\�7<�="*J��r'"j4!V]b�W�X�~����e��x�q����<J�Q�W"��n���I�Em��g��!�ѐ]ƀ-ˑPI:��9����u]4�>g�U�9䷎���Xڅ�
w/�����=���<��;DpK�˯�U�@�<�s�";h�.����ќ��,-B��-)4^���8�'���hD8m�.����ǐ����Bc��    �P"YG��5�|S
W������-���>�!C�X)�:�9�=L#g-�(����a��d��=��#5T�C�#���G5ͷ�QF���᫶�s\(��4�-MtlDb�O��h0�E�h#�R�����Ph���/���05�YT�uGb���~U2����Ow�p9%���BI�lW�����G��>�*�3P틈�uY��i8�Q�ݙ65υ����v�I14MS1��k��q9���ҫ8���E%)i����H��꾖)���3^,�d��n���m�.|�U=X�^�&U*cPj��y�c�\n%�DYW�$�~O�V��=����}��
�75��^~����� �����u���S��t�d�Ԙ?��1���EE��ɣ�ڽ�7BAė�iQD4��sj~�r2�����V�(Ρ��#��+���(�}D\�9>8���c��\�C��Ԣ�V�l��)��M�F2�ڟ���&b:>���Ո"G*4k�����4 ��P�&\�����y�͢X�)8�ƿ.oӅ��J(��(�FFx'��)�� �c[>�\Q}���~!��Q��d+>����������D�g�I��٭��ߠ-�lp��ww��	�qv��ef�g��kB�I���w�?���"�0��T|-*�F�%a���u5�k����zt�-��AO��=��{Z�i�4ȴ�?��^�P,r4��̃CL����7��9z�%����q���7�LD��.51�@��DDO:�p��P&�)�ϖO3>��ofH��l.9y�{e��$������א!�I[�\áK�s4;��G�~��	/ތ����,#n%�7��E��Y P��g�2���G�/���ΰ�=i^b���?!ޟ����^�G�l^�Lz����yH��L���8Z>�{�s^�{o���m�.�W��P"�ǐth�p����6��"��5��L����7i�O r.z���*g�χ�uS
q J�������~�kLU�(��{u���'}��9�!i���p��������XY^E*�2�/��:�6a�A ˪wn��F@k�������!����	-e��w�]�í7s���֒�Z����6�6��������������4inQqF;����L��/J�9���o����(���ۀ���\>3F�R�.�l���.�di�O������L�YB��/z8'��WF��a*	4|?�@;l��@J��>����>���/�B����m*TЊF��9�af���`�1g�SbӒ�P��f��ޞ$ �1����-�+���Ct�����>^�)�#���sRla	V�M�ݍF���'C|Dt<��#��,=��rD���ϰ�D\-	�Y�j�!����h�D�9��+:)�ƫ�f v�@���5A��w𼍨BU���TI�i����n�*DTLH91�2B4����B`-��U����8�8cg����}x�&�Q�啂�������V�!�ʏ�#��a^J�N�1���3pjƈh�0��XDp��Q�M %��c�}�t����c��Iy'��P߃��,3�5��RW�����g\�����Y3��i��]��#w��N")��5>�3�;��C�O��'�HK6MJ��)�4�_����T���~���j�Fv�μQ�rp��Bt4�%`��llr�ˠ���p��R)K��Y�d�-	D"��zǎy\S�P:��p��-���}�K��F�,����Z�,$+�%ؤH_e ������L�k�j���������	DxΪ��	 ��Gd<<H����a��@�4�t�V�M�5��oN��A�wvYS0�r��K(�������:�nc��b[69;������<��4R0��.�D���:xl�%�Ϯ6�R� �T�2�;�g?�Mo�ֿ�`]�n.�����Jo�1xbM����nﾺ(z�2r�zAߟ7�J�R~��8տ�#a��D�Å��������$��ad!F���&�Il_(�U�D����<�n!n�:���:���Ki�]�*��Ђ��|�<�	B��	��<�[ԥ-�� ��%d��RM��1�=^�R+��y<Q�	�ب����:�M�@��14@�^C̰J0���X���x���]�j*5� �`^��|�l��4d���n��L:I���2=���<S
n�a�Dbr��t!"Nhz�&"�F�R������,\��^s���� I��.���SW�A����|P�ua:t�{r%�uZ�5A�R�6�"��gF�>����ot~�j�Ji�r�I��vqG�{z���Vl�B��O�d#��X߭<c����<_	)o"��He�O�֪�`2�㝿=�rf%r�8^[��晔9c��=%�Z�R�A=<�w�BJ��g29-���ݶ�
���IC�rb�yX���O�`�`��oh 8���6���p��ׁ�=�P��It�ZFT������ ܵ�eU�ݜ<*���PwG/�$����B�x��F������]K��1��x1{��řT|i'W��k�`2�Q�sH����#D#��V�Re�x�q8�k6�G{DQ��2�&Q�a��x]�����uyE�zZ��B^(�YE"��a4�0U�oN�5�t�NF�)3�X㣝�X#,���p����?IPǓ�x������;sz�H��
�KK!���HL��h����=�[��G�����r�E�l��0��W�؏K�Ĝ@�?�N��w҂�yF������v���
1�7"n4l`^���o�Y+	�wV]�C�N�T�f3��C��ü{���X!QrC��5͞�J�z[�9�`���TH�����_��R����w�Tj%]��si���]��qR��8�9�9�.��>�V����~��������l��
�m�1�F9��S绸bFWg��"@O���\l�feW�R7̢��*��ţ	�7[Z�����x���f�v��w�_�s�3$ 5�Dh��;���j��GBre��0�bń"r)y���h?���~�icq?Y�Z�"���?�����v�fU<"�
]�2B �(9�\�d̩�E9��ى��;�ߗ��ǝ� l_+@O�.��U?��"�b���k񚟒�Y1�z�� vpP�`;W('q�x��BPvV�����b�I���V����zv	�|�!!��k���|#���JS���do��|ia�BG��i�v^� RqŪđS.�j���3{D���-A��ݶ�ٮ4�`8���m�q�8�3#�i:�l�HN�� y�*T��F�u�.��|:��杗��܋���gp�_�H��=��+J���	�E�LK},��'�4�vO1TA�8:- g ^� (�'M�5�q)��1Hf����'�7�;�E�O�%�� �S��� �N����ex��%p�=�ʢ����sU>���>b�]ܴY�(BB�mp��P���E�ζ80�.>W�OP�N��{[�Ԯ�K�F&�TH������U�8�_�%T	��YY����`��Δ�K8�P9����=�����;"q�d(�a��.� � �`��]�"2R��xĲ�CI$ض�[~�D�-�<�_7�^\2
o�(�V�@��8��,�oX�V�h�<�t��]B��
��pP�Qq}��i}�r�H#�����޴P�Z묈�dd��Do��	���U�mj����z"�4C~Mr��9�6��:�y�ҮSF���j&�N䵄Qm۝�N�+HRyCZ�Ct��{��
�Qz��aٌ�q��,���v:/Z��W���1��
u�M�_>��f@�|�(��b��<���n-CN�P��^J�y.�,����b5���\Ό�[�	���e�����͓T;��֬r0O�(^��uq�5+PۈQf�tjA����e���w7'/����k�*Xɞw�P 0\���� (�"�A_�u���� چn��[ C�f����q����}2"d+;N;B�P��������e/U��v��XK������V�    D��<���-��u��ZDr%£�="���=BK�&�,1	?��^/)*�n*W��<{q�o<PKL�t�Z�9�9�f���l�Y�U��^��&�'�f�d) $��_bA�"ew:�Fʇ��H�0�g�[��R���7���<���l��
����%��p?�,BZ��j4ʓ9���U^�t�8>�It=�����yq#�����Y���^�#ʵ��Y`�.���R�b�Q9Sh�`e�bj_l>�EK�Q.㤊FHxюR��a�%R�����h�NeA� ��Ћ,إSUZ��F�ྷ���s&q�.�=�=*�˻� �lR?��y��\��{������=Md$�� �N1R�%�BK�[��D4�q;��_�����k
��4���x���y�)P(�7M����kh���!�f����1��\#�R�	a�,�H�o�ºk@��Fd3gXYq�B͛��<ȝb���
1��;��KD�'�PZٻ[����d�T ����.��s�to�� �c��C�H �a��f_"�L��%�H���%�0��&�C�3S��,�e�%�c"o$-���B~1������v(
��6��M-�e���E��g���arMg���R�\��UF��{�h��������o9\w�4 ̋4F�F+�|:�Nl��E�b�@4�o���kl�:�Q����J��[���r�'H�l9�X���`�L�gFԌ�L��C���J�U;^�G�4l�?b���R$Wf������/�弼OEn��}X/�x�F��8�b9����!�� ����BdOZ�3͋xpE�:������ˣr�%�RY�s��?��P�v��Ư"/8�G����M
Tǒ�n+%���C�J�bT<WȲs
!�/�u!�k��O���2o'���h��𾿜�������O��ς%�F��E�㴺� 2I�~�P�0E ��V�t®?��[!Q	]Ԭ���� ���j��2��u����L7�.2>�&��PG�pH�����?�J���H���|g�3�^(����������KY	�jv�l$��G�{tf��u��Q���v\D���O:��`'�-�U��ۿt]k�Ό׈5�����P���Yӈ�����]!]t�W��� � "�_}!"L���-���-?xJ��i��z��(]�T��}<�	P���ψ���`;#&�nb����T��ym�չ��2ƺ,�!c�v�lxG�Ã����Y?�s��inD�䁡���� ]C1:��B��?��+{X��}�;�+.���Z]4Y�#�� ��SqP���l}{6n��L���� �ԃ�������dߋCAc)��[X�	R��1�J1�����DN�<zq$���
,�KpZ�^��o�I��<vT��nW1O��Ď[�d4E���Bm���&ʛ���8�{@e 0��`1+f�DͳE1����%��|k���{�4�9�����uٴJ�\T���@���_	θ��.����JfqUdM�B'ܠ
5蘝\���e��J��7�2&d`{�++A��⥕h��,���QE����T�Wi���˫J)�a&��7B�g��
:Ԕv`�\l��7Dd �ȓ�C�r5�>��r0�^_矗"�}�<ʹ�ͽ.R�v;��V���/ݐ��4D�$AF�s�u9��0d����)%Ag�N�e� f��uR� ��C�I������a=�3bk�|Myg����8�`O0uq�����7��,PL)�V�4�0�4��B�S~\3�g���r��<�K}��Z�I������A�l� ���d�q ���d�b�aE�+â��'3@��aE�A���hlH.�lX��g�'i���;����ɚ�"��|;/��*��;���o�������D[9?�a?O�#��a��uj�MK� ���I���	ד�J�{��f7�m���f�)��Ύ�scD����N���w�F��T:9k��^���k�C�q8����Ԗ�dR_�56(n�ҮRIݹ8i	o����T�b	ߘpym�{�o���L��59���W5 ���%��#>ル6�(�d%s�p)p����X�/�m�.�PA=�����7�|��\0��G7#��e?�We4
� �gL�	z�y<p���5Iއ���R���!w����u9�y,LaXwi��w{z�.��y/��V�?!7� �pPw�L��~FB��י[�CYC����xY0���Dz��Z�ϝ9W[0c AT�,w]�ŀ,��:�iZ�-�w�����~�Gl`���y�tsz�xH1�L�쀝��i�F0N��.���}�2N�����b�5��[�X�ڋ��ڐ���er��$ڹ���m�����Ηa����$Wc�f� av�U.�X�%YP��L�bl��"S"��v?O<i[%��E���v��:�������)�� ��1�B!P�wR���(�>�t/(@z3�H�5�
����������A�pX�R������/:h�P�\!UI�|fܳ��KaQ�s�m:��`ܿ�>io�K���0��u�'˪<��V����{��m�Ra���{{����҂Jx|���9�"�P+t���0���j�@�&̈l����Xk,E�@k���U�75 d(��  g�A�;;D����N�*|��IZ�41M[��Z�pq�*��\
G-V�0,���j4�hv�dq� �,�f�B����R�`6��4
Y٭}��	��u7'��(�j�KČ�yyP/��ۀ�v�9��i����Ĳi+.P�{��M�p�|9?��l�K������h��-4� e�	�}�0A����������W �ݵ�&0���?/��1����_Ur�E������iЌ�Eb�E��qa�X�}�3-��㻅��?w��I�f�L����r�m(š��S��K�fϑ����W�n+��nq��C����k��A
	��>��=�չ��H��KT�[	`���,��F -c�%�l�O�0����[Uk*��	亹��J/����RR`�=��-�|'�������ws�*�	��T(�Yy���	+A����ւ�m�zn����y�J��n�;���������7�.{Y\�M�$	��n�v�"����a
���+�Ex@<yiy+(lD(�;�6r�i���R�bb��^|lճn���t��\3��\V��yi��1���oV3F��\e���vo�l�&�h���K῅!<]��v���&�x#��Y��8.�(�]��ruw��6�Y� �.̀�����d�."H���!RT�@�ڶKD����w��f�#D��7f�\�MD=q#�0"%3϶�ݷ����9m��Z���	��(�f@(�~^i��bZЬ�;�6ͣ(ϴ\��3K^��:�W�U���
��x��G�2�E�9���#��M�*�t�޷z���� ��n)�
Aŋ�2�6�u�jf��k)��3��톥��e�~��x��(�J�f�`�*��0�!��w�%����f����Zj����#��v�/˕NωøQxxq���ƾ�J�1- g:I�A�f����W�6����M3Ji�N��=}���E�?Q�N��[�� 6�؂�	#��n��h��ŕpub&�s���"=Y���iV�V����@�A�s@Z�G�&*�A�9�r�܍������B\�,j�ι3���O6�5�:������侳�夶Dd��a�˅HɁ�7�!�긿�w��YHK��G9T����ZX���!y������?D)�u��&\�ِ>���a�P���W�8Y(7��VN������KI}�.R��-�W�Ӱ|0����]?Ko�SdD��%�M��WP#���'��<fx�&𡋙�*7�N���:oN\k��.ͪ盧��Y�[��V�p��&z�"d{]����'	CwP.����E�pN�.Z:�".�h>�b8���D�v������X�~�������|��_��hNvQd-ZE�)�hC�ࢌ��^, �.�    ��ע���?x��f��ŪUP����b�2�-��ЙTՀ���w���=�N
��e�)+J:���hSv+gf7�;VJ:l�.�����-R�io^	hh$J�������Z�=VW�9^���ݙ�� ����}��=��=�}�$PW5�Z��B�d�􂵗�x?,���j#Z�O���*_�y`8�Z�v1S �YyyAN�I]Rcs2�*�!zd��u9��7��S\�����_]��_�ы�칳�D88�J�iw1���.G���ԋ@'Es5��	+\�Q�i����*	*��ĄH�p<t�"�8��:.�xq���oO[�ey"�c#+GЇ���<�X���I�u�C;�	+��C���O��p���iPQ%��"��k�*%+� ҭn~����G%͚��?&�T@���p����
T�ö��	�ؙA�b*��g�v��NX=G[1|èi��g5I�
)w;�Q��f5��`�e# ��^9��7���V�"�c���톩��cD��,~��;��=�!D$腩�~ֺP�[�0�	�Rg�0����X,�H�B0�1�L��M������7�� >��=�&��{n�)rʂ�|:}|B7�����P�;"T/7�8( c`�mWG�ϰ�:�\��$etX祵P���	y�ʘ�{e��k� ���nl��\���r!Z���;D4G��
u��E��4g�	(5��l�M�Jk�y�P-u��B!P]�c��T��b��p��ƹ�M���#�1ި=�(� �6����%��bzX�R� ��h [c횀Zf�|R��~�0^��Q��2˒"뉋���O����$��_ȵ
��i��K��,c}�n�n&v ����0(����@� ��{��a��L�S��Bz�ǝG2-'��5���Q�h�K���%���S�zkV^3g��k�"MZ��@9�_7����ñ������X	�%�`�#�c��gqA�Z��L y������`Ax�O^ؐB��\0FvX�A����A�S��&� ������9k�`E@��߽�R�B3gjA���2^���P#)	�=�v��dƳz���L�b�I���A����v7�PA���+vp �@��q�,�mV�F���=�� ���d�W��;E�@��Oޓx洳���Н�M��O��?�-A:X����@�G/D��$���󤫗"���D^����j�	1 �^?����D����]�"�+%�˼F�~����R3;&&��,�f����/��a���2�S�����AkYR\Ī�=E$K�9�<&�W`�����WS�؈	���J�Q&���}�j��E��{��7DP���ACZ0�g<�atH8����4i�8���Z�Q6#RH�����B�����o0!��5c�q���ˤ�E�/OO��x+�p��"k�I���	ج+�$�b��3�	�u;qM@�&e�3�;��N�*K�9i�R�;g�,�L~Ьޡ]mX����!e��sp-&�n�C?i����|
��(8��C�+�p�&V3!�c!<�e̊2ʹ�gz�Oq��P��?���ۻo�IOA_�r�����^x���3�R9O��)m�E�R�a��V�IS�|�G7kV/��� 9�>w�qP\�X�����3�`%g�
eI��E���E�Lm=u�ץ��3���d�@݃g7�Ӱlo���*�1)���H�=�>!�x�: O�Qʱ;���-�F�~�����	�ڂv*�b�?a�C\��!%j^p��{d�%�Q�hg�W
�A6��̂)��B�ٶ��Tjm��e���U1�z�D��rV;|����8�K������_�_�x��89�T��.�
־�i��9Թ��R��k�O-V"�X�nV~� ��p���}(���~�m�F��â5�փ����_��0��vO�b�jx�.��M�p�����T�����B+�\��qq�x�f~����̈����n!���^����TE�"���n�
�>��B���<������ԘH�?C-rtC8� ��>�(����x�KeL��CW��<�=�刨ep��(��<̳Oť�'}��"A5yp�:����!c�����Ц�
13���Բ��>�<���k�|�)�Q6���%�����u���Z���N��4	��A6L���J�Ȉ0�Ji�'��kw1��t�ں�� ̗WiIb������,�XgM�J�c7b�r�=�{����g�$��4&A��Ќڹ���H���S
�w�r5�:�X��ہ5�O���xH�\:�Ӫ<�����k��Yjqb@����WΪ?;!���|���Q\���7gu��E��2O��נ��u.hdx�
�c��A��/^0�o�R��;-�l��Oy~�YJ�6����aZI"TF:Ș�hA���)�I�4���˻��١���|�{����Zx�a������§c��@��[.�VFr�ƭ��(��\m�z��F���<<M��Y�`��n1�\�����,g<_/����^�(�ˬ�Dy9�6��Q�����������T�0r��$�B�#�uu�@ݷ��]k	8��c
䫉Ċ�t}��4�1��"�� d�1-Nf��D�'�`����i�ut���B�b1S�Ǌ���XyaBQ��Ϊ.�e �f[�Z����hɁ��,�����~�)�el}��`��o$�n�E%��2�����F��������ߗ��o��\�<v($|�������+ج`�S���w@TV�I,�@m�w�}�unA�_�??�{b�{a��*i�����?�f�G9�{�aɡ�k�l�o��'ף������O
�F�W�/�ɥR��<[���e��y�++�l���>,��f2\"i�E���]�n��B��Zu�+V��~���t�*�1�д���;��S��"�c�R8��+BRfq�Z���[�%i�Gc�:@*���,y)��̢M��BZ�y3V��B�-[����5���~��2f�%�B���r��kʂ�� j����py����a	{�i���,�\�^��B�~�L(!Ʉ��_~�"�"#��UE��n���(�*���
T�Yu�nIn�!�����/z���L�[KZ�r�R|3�w�qAA��ul�������V��O��l-*��}t{'�^q&¡N����04��߷�P�q
(4 ʿ��r?.�$(�gd�-{��4�R�n��m'��;���d�PI�H�w�G�����_����`�Tu�ư�X��"��Ɓ�Ӡ@���m8zDB�wm$����[��(F���.>
 F$�����V�0���(�2�O�M�+G����"fю�!]Z�;9�f�`+���͘0�|6��n�RD���I�@�wu�;b2��1�T���e��(�a��h@݂C��-��Q�3�E�����*KV+/p	����J��u�.i�b�-�c�X�gy	J�ݲk����Ք�c!l���<z=��X�<砉Y)h9{q)�����J�]���t�x����.V"����taRd�E�.�X�	t���	Y��%��pF�v��H!Al����`��oǎi����_<��J����f! 5����%�|;��Qlxp���.vi�,H��m������+�j�*�,V�$E��L�`����{N�=����PIC��׬Xn�S`*�_M9e�g�b�@�8
5�+�
\VL_j��G��{����wfɏ{��zɐj�)R�T�d�t!�w��7��$8C��R@4��"9c��W�#��:�#bKI����-&��L�J֮:��f��ۡ<\w��a+F��n�5ʍT�tl�K�Xȿ=�Ne�`�ΈHD��� �@g����ʩ/wW�-.�ip��_S)솷������f��O��S[�TKg|��A,�~���:֜��g�Ҋ�H��|ۃ~+Ǧ��7��TH��ȃ2���{���@�L����rD�^����6���J��K֩TjL0?�:q�Y    2��7�r��f"����VyC-�������a4虸�D�/���ٶ?�Zk��� (��)V���m1F�O{�E��0��ӽ2�6�F�6�5�`���� s�\=�5}*�k"]��; GRs���"X�]���tH�^v�Z���R\��ւ�
�s�Z[�t�k��5�� �z1w�ʃ�/�:�X,����R��сV^�^�\~��zс/��׌���iH�%�k#�@�9��Vs���l6�o���҉s��Q�?�@I���C$�\1��rpA��tQ1m�a���Z�����G$#�Q?�cP1���7��|C�(�ra'��j���_%�@!� F�:�����aՊF���ʂ5�c��y����f��xvW�xY��_�K�ѭb1��/{�>��P\G�-����v���CK�g���A�$�>zU��DN-�Nސ�u�".����Y�r��:��B>��� ��?�V�8���ʋG�L1)��%��B�,�!��jXԮS؅�����+rdx�v�D�gw�r��(l�+���>�O[$�Q{K�����R��d�(VI6�˭�;��u�,����qr��b)w��Cx��/{��fK���a�&��bߵ:��h ��E�<h,R��Y�^g�59jz���&:.���WtwY�-���aqņ�ؒ�f��?���������ۊ�V^
s�t���t���a������*�	m�(���u	����D�[$n��~"��r([(H}�)d��v�TҜ�wZ�B0Z�����a��������,��q���PC��uwӄ����ڝ��E7�u[�߰���>xh$���Š�v�n����U��3�i�z,,5N4J�@-@�a����y~(�зs�yaO����ч@��	&�y3�Il�]��TD�����X�]�[�����	�W��SJ�WU46Nvի���]�Iy�1Yw!��U��|�	:N��P��V���8��1F�Z8G�J�������%i]#@)���%�Ŀݱo�L����`Ơ �ҠFϿ��.kaEH}�T��ǰX�q��Y��ZvM�-�6���V@��)����#G�����N�7��h2�0��q��y۫_$Ce�W'�VaO��F� �z����Ō D���?\
8��Bw�e�� q2�\B'�����謱�Z��x���g�k������[lk�,�b�����%��ƾ3C8b�k'�cnka�܍m��F�E��a�1J-H��� ��t��^6��+�xB~1c,"��Ȫi�4��D9g�r�����ؿ֒�Z������Md��[�\��N*���I�7:af»����^䑏\��A �{p'D|n?ZìEk��m�NY�Q,u1�_�2�������]kN�n��XƄ���8"���tRfA���K����/ �kͮ!X<�`��wo:��;�>̾v�A�T��[�x���1&�[H��^���`��u^�#/���J�ԈTbMض�����?�BM�@N�x?�k�S�0��^��Y�̜������ j;���Q���-�����)�������ySWqP�Z�:�:q��{�z������0�;J����w?wg+��\=��x��
(݋;�[�%
HD`���"bd�o��n�L���>�\�����˲qV|�Ծ�1�YDh>FAi2��R2���j٠n��$�fu���!������Q��pd������e����KH �찌Eo^[�Y9y.�I� 
���$�x�z5�o�\�F8�n�SfS��(��d.p��W���`��v!��';���� �nW�b�?+�$�*q[�f���9�H#�|(Pط?�
�J�p�.Y������/�(Ϸ��#��>�r��.�0����g�� �/�,1�Ii�����-@��O�}^�}1��?/S2�;/PRj?bOr��oX�Z��(���B�Q�.?�d=������;[uJ[�N�X�R��O#�Z=?Rz[Kt�UI�5l'/�d����.o�S����9*"ԗ����L.lR�Ao��8����59	(hJ�������o�o����]r��Ț>)3uT���'$������m����+d}^��9�i*�=�O^M����>}pa�7������Ս�������A�܍��%J7�q^�:��a뛢�,F7��,;I���=��8����(�|$��t��8���k���Z���A(9Ǩ�%Ĝ��<l�Wvh��*J���㡪?!�z=��Ʌ�2�JfH"���z	��q/�a��ɡ����>,*�ƨ�r�Ț̽'��x�b�	����K�����5�b�1y����@��DNo�d�%�5�F��H��0,A(,���ݿʆ�u�
���v�P�d�r��s��	�|�Z��;�*�,���|E�$m<�I��h���B%7��:0�twTv�ʗ@���'_� C��T���K0�F��V����6�x��o��j��$H��-�h��̃��8�G�w0iR�, ��O�!����9y��΍rf�I�VI���.ۛ����|�l+�	���h�t�(�����(�p�lH�{q-�V ��HT�>�}wR�<�1��A��ߤ��a���7�����K7�jM ��T�4��U,�q���4f�0�3���W�� A��'��͘�|oϾ�(�|6���4�8��G�)��P��{HE��C뻭�Л�!
���]��ɥ|��
q�:��fV��� ���k`Dj��l;S�f�����$��t;��oS�?����M��B�����_��sN�	�b��Kym}7]Q��'R֚�<B����"oJyػ7h֢��A���g"��	LtI�(̰��bڥ �Y�Ӽ*G9�i.n�U��J����}��O�I��X�&��ӡ�w;�bB&h6M`��ֿ����#0��n7[4|�s�H�,�m���?!� ��#;�5��;�)��8��ٰ ���Xel���c�V�O4�Y`� -����[�`�t�VNa���3�R|�	�o���ͳ�ۚ���:��H��v���)���lO�#��8j�R��.��%�R���p�K�x>����WȘ3�V9��3�D�=K���#=y1�ڬΈ3�a���z׬L�ѷ��Y��q|{i��joR
R���<��nA�1J�P�pь) /����d��E�{m��}��u�F�������^�����	]=�kJ���y\����c�k"Z��S��V"�@�'V��D�Gv���N(=��d]�����O��B�P�;��JηŃ
-a��"���sD�F�Q)2-����F���������A/�i�4	8[��U(�|+J�-Wř�P�T���(�I����`H��J*^����/@Q��裷iX��߮bMrk��ő��Za��8�a��&��׉.���C���Tȧ����Z�̦�F�ǳk�SCU ����z�S9\�,�+��֤��.�}����@��a�x�����v���x���5�F~&��?@���X ��L���o���ص�wؚ���ր�{tP�����F BY�t�B0��yy>u��,��H���=!
K��}�/@��P^a���et�ޒH%t�Ғ�l-ki??!Z���ě9�(�s��8���*8;��?}�������b��p�Z��ba��5>Y�I���]�\E�V�H�%�	� �����w�3�ȵo���"'O+���E
&���e�l����B���#�'lq��������N���N��%�Z�5}�'Eb�e�����D)�o��h��9]J�[�Ui�Ѿ�"�Vo4�3B5�RW������a���m�vy	�����=�,/���p;��'W�P��n�m������ Sy�tkr!���|��/�a��t�
B��z�tb�|M)���p��l�X�����
!����4z�~Q �?.f�b��?݄)�������7j�k+G��DK    �4��uF��pjBF�����8��&�8������[& 9��d�(RϹ4��s8��Q.@�L>qu�%rqO��p��ߖO�2a�v�|�Vj+�`��58	�1�#A�!����G*t�819��j�b��6_����@�D���v�vxvPE�{⽰8����&��Xvn��y�Mdk;�L��z
�|�o��i����v;p(4f�,-� %K��B���*��e4Z��OB�����^Tɳf�S)�z��Y��ã����2�dP���8��k,Y-=|���J���=zV�� �^�'�� �W
l���uN�4��+���p/�mw���mz��G�,;*U\R�_�AE�����<�ݬ��� .:.A����R�$U,ͬ�s�sҌ����el����"���X���v�S~�Q������udur:�eqж^`�.�59'uc� "I���ȳY��b�0�?/_0+���Ƀ��?��;g+�^\+Ǖi�(?R�2n�G���"�t6���E�<G�����_��ug�lu���I�0��XD"��X)u�c�"�e��P��p���M�ӖC�h��n��L�]
˃:��j�dd�6"�VЁ��s �ja��;���m�_�2�i����Ow2mV�&����v��E_�/`��e���}q/�2G�s,�FƼM�M�Đo�|E2�K8��!��#�o㩗�����/P
o@P֢bhA�"Fחpa�'��j-D!���c�6`�U�]��G�gs�nMs9��úOGl�H�����?B̤���6,R'���K�F
��+��J����_��� (#&����w>w��C��G��M�%"�{y���H��E^i�����T�3�k�X�G��6����٫{Jè���y�������D0m�!�Y2�p3� $�r���(/��.^��"�h��
�B1:F!�M�u)�%���:zٚ�-w�OFd�)�������7Je(3��dܿ��dJ�?�̺!���N
�~�2�
���f���A���(
a܃��?	�x���K�^g�6�(�����$H^��})Ltb�� �R���z���ɛ��X#�C�EB�A͛U��L�kN�Y�Fw���gJ��=�1P����܈-W�m�X+��,��xx�
J�K�Gi��q��&h
���lF�<�-VL#���3��\x�!C|�~j�Н���D
���+AJ�L��LĹ���Z�P�B�����ʙKwo�, ��C�z,��Q/ܬ�£n+G�������xd� �����2ԌE�s��_�O�PM��Yk_$P8ۍ�V}6x�+�;��w��CZ)Y�J&	sz/_N��;��E���QEP��r�/n�������S:������痬s�9�:V�2�]��B�#�;�b�w��8U$_��0ᢴ)i����uH)=l�EP���C����H�2U�-R=���5aOBgNf^mf�g�1��< ���GO���7�2�r5�Z1IC�t<I]�+�k98��pF��S�~^v�"Z3��
mX�OR� I���Ks�a<P��j�*�`�|� �Ş�
�@���ډ���X�֓͡T�A�5k�"nz׃�C��1�%��j޶���Y���g����&@����C�ŵTo�jj�H�(�d�CBRf�ѽaI����&���>W$�Okw-E�	ߝ��G��l��ip���1Y�C �e�`���cY��fg��/�0ͷv�P���+sK�lX�l<{9�[�^ʌ������t�* �<��T(
�h��f�TN#��НLw5^��Y�0Nv�[F9m�J�y4a89��瓗���f}D*��e�\�d|�^ �r�^�y��,V��|M��Ά�0��v��Ꞓ����B͏.��6�,�`�XL!AJ�g�F��T�3:fL��C��}k�X0gv���f��	��+�ܬ�K�.['&����6�X�����u'�vqE���
(�e�t�b�z������4���:6�nF�B�t㤛��2�gz�Z\��/П��K�JJ{��%.�������5�ވ�<?� �n�FQ���0�
*���-sΈ���K7��ʩ����(G
g8����!x&Ή2�B
M$}��0>��
hfS�Nl���q�=2y¿$�ʎbwqȚ�%a�09�c�||��;O/]�Mq�|PD2AD�M�BE� an����/��ȴ�E�T@4F�@$;������0�6d�M��"��ξQ�3���}�H)�BN��("�p��@T���Hp��7a׷�q�S}�x�s���䵝�(߈?tV�" �.�>Y��#��A��%]>�2׃C
I�S���Q�^����b�q16oP�4�v�T`�:�_���X`pB�]�q�h^���kmE�����Wϒ���Q�"�s�!��B����~R����>��+4���&��V���_T.1ák�dR5]��$׹�{ D
�;�B��oO��lv��W�O(��z�
*��n����Y |���%�ug$���V��ow*�6���B�7B�����A�K�v)�z�.�*F	�A���,c�q:�D1�v0L�UP���V�wE_�bx��Ld'/Zt����h�7X�RyOf��Xn��R+�.�9*_�x+	å덞� ���,�*����߾ ���6T1�^B�: �����"P�C�����u޺HR��x����r�n��j���f{�H��H�����x�K�u�h����M�ܯ튪�z��i#���Ak4S��#lM��)���ی��юtEp�_|;��*����_��-|�;�����jyzQ��~�ֿ�4�l�+9��()1�Q3�CA)�gf�ʥ�����ɒ�t��B�s7�J�_Ov���kצ{�",�m�(�3X?E�p�5#��u�.�� ���]vM������!dw�uzM��9/�{���U��"���+C��&L@Df��SX�g�"�V"��ÈK��c����@����'$AjA6ZG����u�.S��.�s�j���3�[��Ք׉�;�y>��_��������;�[Fl#d�/D�`н�D%L�	������������o��rD0q��~a1��Iy��u22,��o�}���׷�T�n��ߞ�/o|P,"i���U3g,�?k�p�?cD);be�\#F�#�aR���c��o��&����1-V�Da�޿�{���ߟ߾~�&�����lM�Z ����W/��}zwMh�>5l���/�Z�5"��p蕞@��fu�>뛻&3�� _	�2b'X���hA�u�yp�A�Ä�|�����߾|ywX�:|�����w��L�c.B*��LyI��>��v�t)H�>������f`�W(ae�ύVi�B G�Y	�3y�l�S&�����S��022$(��}��冊V��3����]�����?�o�
D����[^v��a�����WUkfZ���Z+�Y}��Yg������K(�޾���������_�����ׅ�����y�G ��o�~�xw@�:����/D@��޾�� ��uhާ�o�~y_L��!`��B㸻.,�o_���ۻC�A���ﶓ(Vm�C|�0F�\���?�S���o�HA3<�v�������#!o�wx�xQ��O,(}�9!s�y�������i^��'�ڳ�(|���j,5E1�C���J ����Kh�{@�z}�UZ�U�B=�j�Xy!x������&ث�!�X����}m�폿~��S	v��v��2�TV4�Ln�A��a������>�Y�K��y��ah|	��!�c��J���K��V����	��۷�o_�_�#��˷_�Nس`�������o���D7�O0V�'��R�9oX���tHPX��bo�.{�E�����?��m�%���s��j��I���7'�L��y�+�Ҩ������_���e*��߾��W�\���w׳��$e����t�@ش���L������F���kŪ$:/�s��>��.g��,��ICTX2�=pRu��hӛ!u����{��B��ԉf�Yg    �4�&U�����/_��Py�������>k�2�]�_�"z��5��!2�nEj�|~���^��	n�nz��ǘ����n��A%۽��0>c���6�����}���.��Zua�KOʷ��#�~��$I�K*^ǰq�ǹ�ez#6��vSD�~f�A57�&:9���h�p�ZA�9���̠���U7���累�V�S��,��o8�_I%`�V2h��u>��T� �O�����J4e/����i��mwYLv;;����[U4J�H��S�*�;u�ۑZ���x����T�?O94�9�6��OOa>	g�yHE����f��2-�����*����Aʁk@���JjI�p�׀��48g�wDf��L���J:GŚ�#F�mp��սi��3X��,\�Yv�0�_��߷o���1� A�4��>��c���ޔ�J�q/��.���0w�#���1�>��
zӉ߶�ˎ^A�F1|8��-q�ň4dUBAy{4H/L�a�ZsX�$�� S��/O1����=�?���܀�F0���T��c@~dR@�K��^��,�?��?#��*,�8�bf[�~V
d�������9�=�����6|`@��CԬ��?���d����	2V���a�*����հxd�U��Mv�DN���K�)�.s���� =[R<���o0�`����vHο�6�g�2ЌL�8&W�^�k�������r�� &�a�(/^�U�TB�@��%yG�A,%}Y��rZ%ж7̈́R�\�5S�p�j�'Wm�h�O�ɴ��/�!r��}t����0}by����4$�dM��{R�]+ja�<wN��1�j�gd:���B#��0r#Ubqr<��v��̳hk��K�^�kA6M��ya���.�˩�p"�V׽(���*�B���.;�{��mOJ�3�x�����F[ي�<���'�Mn�ˊ%�BraASr�0~'�2&O���oC�񋰇�֫]�e�{ߎ����QIR`=��*���O�y����?��3��a�P�ۋ���4��
�b���q�����DR�'WU������#�ݥY�Y8,��|���Z���V*��"�S�b�7+�A�1r'�]��cg�/���HHw:��dO۴�J����T	XJ��s��w�����K���t0]Fk.���b!sZ���v�/堁��Y7�]k�qd�A"1���Ϣ�,��J�d�V@}��uL�ju�g"�����Q#= ��~�~~��B ���IFo�ʵE�BoL�@�N��/o���ӻ�b���o_�����>/�E�ӧp~{���g���ۧ�?�~��ӛ�*@0�|{��]Ǫ;���I��Y"� Ξ�֝Ɨ��6�W�?�����A�d�Y�����>X+M����L���������q���v�]?��ݢ���C�2�T^�	zCx$��	$�������Q��8��߿����\"X��	���?a��r����t����oi���az=�w&f�\�� 驳���\[�D��a{�˧]4r��4�<�܎`���Q��=����t�,�L�XCA�%���,��:��5b�&k��f��=*ё�R3���LF@ d|��0ٲ~��*��BZ����b����t(&1��v�������F`�B�������uH&q�&܄b����9�C�kη6~D�R�b��I�*-p�fd�e?&�6	��:q���v�_ib�W�L ���=>�0>h�d{����p��/���2�r�)���U���eg��'sT"g��v�W����G��F���}K1 
Ӭ���o+^����Ky��Hc%�����	��m*���[�6hp� *�������o��*�@�w�E����_o��2c�����~6m�Q����o_��vU]|�&r2���x�'�c��<`�5Zb�l�^�>�>|~����k{Ppz]�����A�B�,��-�ߟiO��ɒF�u���bzA��6��Z^	���~��od�߬��{Ko���/o��o���^���_��J�a\����]\2�e������H�V/�������Y\zv�#���/a��nV��<�v���G8��_���P3�5_��������T7� 2��U���/�}A˱�D\�-+�h0�4R"��\u�	_��M&|���ęe��������Һ�:�(4��)/����o�����/�&Xͩ���z�^��C_���������Z����o"r�mP��u��cl[�u��Oji���K$e�U��GyNG�o���nZ BY�ً�"~��.�	j~�rS�t�%iXh���׌Ze���3w�/a͙��HÙ��oo�뎑N�g�g��<y\-rIr+x�>����/��z���	s�g��"�j��3{QVõ��'H�.��.h����@������%���<��۷7���{���tp��2�@$��%����E����9
��0�c�l�dD�ľu�J�l��Iw"pL�F��e�,�Z8�WQ��X�Aɶg��T�N�*�4�nֳMǢ<cX�ޱ�|�X��`��!V
V�^?Óe���������Ӈ��ueA�rx[�-�·��.�5'���A���Y�0k[���/8����x����o�@�ۅ��?���Ź�o��}�Ʀb����;d%��q>�G� ��'�+�jƙ6�j�7W9��A� A�!C|r �I�_�$���/*'3��a0���3?,BR�x7]!��|�{]����Q�8X��#��vb�b@�)�1c���O��Μ��\S�D�\/9n�*�H���>*��ʇ�<���E���Â������Bm�5����?���%B�A���N5�����ߜt��߾�����
Vj.� �ޠ��ct[(m�l�F!)�Do��3��Ӛ��Ж�U3|lr�%P��37z����v�;@؁���-�Y��=V@�@&9ׯ<Q3�Wγ�_C����)5g��jC��p��(B����q*Q$��@��<��1g-��4���r��E"��YSz���8��,E �ߣ�Kw�9^#������+���^:IXlXQ���Y�w7�<' z���J��S�.^Q
��c�WX4�����Ka�4��N�yY����'��l��QO1IZ���k�'�� �_�7D���{�to/��(���oʕ0�$�*rD,~^k¬z-����Z9����5��7�@���]\��@c�L-��~ޟY�,�h�~0�����>�E_�f�Ȉ�5`���|,�D#���E�ͪ��B)�=v��_[I�P��]^Hz%PǱ����"�_�͵ҕE>W�N�X�O����{��~�C+�+�v�

�Z%�?,�f�%;;���n�:qЃP=���!���J����7���.?�o���@8ϥ=�6#�� g"����w��I�w��\{��14��0A�:��3�[�=wI%�w�X�����|�*c����:�b�9�_[9'��n޶/v|�\�{������ &�^K���;���G`�E+�XɰMoX�A�!�C7]#��^��'L�����~���m���y�3I;��qE�,�F��k<�ǝ�WB
wt+F����k����������!�`�\�rF/%U����HP���!Bdg,m�ɥA�j�v�Py�;���C]�v*qˣ���V���
UOrMu]�Fҁ�]
���>��Iר��T��X2�Х�H�Y�ab�@4����L,��2Jp�F�)Q\����s`Ŭ�1�e�Y�pl>��4N�� �K���wZ#U�:/H&F�5a��X���Y.�:xkXB^.� ��xU�Z�¿(38�k����[���}+-WۑU��"ﰮt�6c2t��t�)k��c��L\�$�E
&%���w1c�='�an���~# 3�Nv-�� �T�]`��>jÃZK��e��mV�N��BT�`����s�x���{���X��������&2x��*2�)�6�-�a��g����A!=� �l~�|�,f�i�A�)}�T�Ђ�����"�;�5����\^   �^�@���Q"�Q�3��	R��A�Jk&�R��cT�ń8��i��!��wF���6�q�\��"}n��s�5���/.�|=�Y#$��LW��2��N]��wwI��r�|n�S�sk�z�n1�Y��^�D����a��\����3�Ξ��ik�����_N�0s���[�K��y�Ї��r�}�y\1<��(G���&-�`�sȐ1�3�g������%1$ϘsJ���v�B!���_}���9hJ�Ϗ����Q��l      �      x�ܽKwǑ.:���TΌG>8��v��-�K�;�	D@o��HZ�#��ި�,�v=r�}���% _dT旑����څ�]�r��;�)g������7_�����_�r�����ۯ������x������w�_%�\G�a|�g��Ӈ���77W��>^�r���M����� _8z��9��C�������S�O�]��s�!�h���q����w�7W��|xw������F��r !~�������Oo�����J�����C��O_�w����q����߳�o���J~��C��8u�`��EI/��\ȉ�kK5����hm��dߥ̐|#H�,&�@�|� �́�~���b�f˄�]Ǒ����_�Lx�#�.�W/������O߿z��*G\���/(w9yVl	�8���LQI�!p0��t��Q���8Z`�%eCe��-p������vseL��bn�bp�_������n.�5�|c�����z�$�ma��e��(FXj
ly�pf������E�s��	�*j<�-����1�����m�&���0%,�����-}d�z�C�F�:�	��07�2zLX��pV�}�`�9�3'���mW<&�(W�LB�̮�̓��ݕ�߬��|n��X�gQ�w��8`�jD�}��G
�rlj�`���%�b$n��l��|�RL�)09,v�[N����A��b��\k`���rİM�9>�X_����m+�&̨FO 1���9`���©�!���5,0+U��m��瀣������߾�}�۫_�����_�v��w����뛛�����7��������>'��w��7Wn��G�'f�/f1F�����W��1w윏�����ݧ���|\u�٪.vVj��-0xnz�����]����u�\z�����	����ݽ	VHs�cOq#��ik`�)rz6����5B ׏�l��{�^�T����l�P)+��7��k`�F��s��h'Y!Q�r��>@洓0f=X��z�p�,�8�
7�+���2I���9,�7�����K��G��{��?7c7y+~������ʏ����͛��<�΅7��c�c�0���^�� ��/����	D�+'�	j����`����9����X�b@�M��<�[��26圐j`Y1{$?:��y���^��՟��<������h���r��B�ϳT7)������%�GF�GF��G����L�[�PLS�K�#6s��%�OH~58��c�D4"���]��z��tC50p�|�<����~���퓚y]~d�>
���T����ވ�\���Q����VDPϜ��5B�!�'�G���_C��wK����.��4P�%�!���49
z.�f�\��������޼�l����F+�\�������3vY���6�4�f��Ruc�b�-�,oj�u��ZrR�dY?xb�ns��[2`1'2��P�2� ˹r^L�4�p�}���7���E����;y����ʟ�C���N)�3ż:cpz�Y2C�Zu�Rƶ���&� �.j����^Y�x��Ǐ����:�Iȡ��� ��/k�T��rS�S����cƭ��9`�������t#U��}�FZ9)�?}�( �O��?��ݷ������Om�	H�Q2��)K�w�M��,��x@r.��&�6�]����n&���ي����oL���Y��Y.pr�=w�E+:��-���@N5���Ɓ�g��lEg��!�1;rFg�YdJ�����g�i�ٻ I-� �}S����E��f.��ԤW7���o��������/w��_���;��w�Zh������r��Jo/,&{��s�CꝽ4[SL������<�f/L�[���t[��A�5�����P�ӑ�Uj	�(���^ԇ���Ɇ�y4xg/���e�L��YNg��p�s@n�:6j����,g�Q��{{��/�9�9����~�{��۫��|���۷r���޺���l�r5��꛷���#��-����%��� ���J]��G��Jy����[y{�h�$w�_ž\���Oi��F�4w3��ZY��[dYb���ww>yo/�W]��ɷ�v�"T�K�(4X�e���l1t���~��P�X8t^��m����"u+���7[?n�k�ya�8>�Q�d`j���jd1�A�y�=n�oU��Ȗ���{��{+�
ћ\�m������$|�]�o�X�3b��i`K`����ō��-p�����v�a����_}w���<�|����Ȼ?��w�ȿ�ꏯ��������ϋl�a)��G�M�b	V�C)���Kc�Us��Ǐ�V
�l*r�<��r��
BK���,4�(��2[���h7sϻ����&�IB�l'EK��:I�ܾy���|������W�4�Q�r��G�[`�[�#��� �o���������0�?�����/o��n��?]`�\Oé��~9�ϊ�XsMe�Wq�|�����,%���E.=K�-�s�R3y׺�~Z�������E�:ɴAS����g�	��,�s	�s5�F�ډ�r�f��˞�:���iwk�5��1??�OSd9��)��|�=������/_}s�V3�u�~���ݾ����_���7�?�E~��܉�A��d_j+r�y�v|Ts�xww��7c=r��a�qɜ�De}ٸ�Bۤ?���Y/�s�_��E��9{��C~x�Mwm��.�5�D,
"��z�5�:� �1��z{4��Io�b��{�oU`���et����Ӛ��ۺ�̩n\G������m%����;����"��]�\���8.y둵jQ8'�6�wo>hb���ۻO�n�W���������y�Q�՚R���~�c�l������&�/~��z���m�bG�8����9��6�����,�k�[�|p�k�dK���9���G��s1��Cjuϙ����A�ɓu���?W�ի�Ī�(~x�n޽y��ww7o~����^�}����'�_}\��a�w���"=*��n� �HQ�l7F8��#a`�r��n����,hqK��M͚��h�:���t���&�s�I�T>I�Kƥ�`u��Y�D�� u�bv�Y�Ln���ܭ�*JFZ��|(g�V*����.�iCK�9�hYM��"�@\U�����u�A�5�R����}�j�N��q��&h`iӊr�$�5Y�G˜��PS�"9l�qˈZ:S�����F�v�X�3ɿ �Ħ(�A��r&���`��^]7�#�y̩ԟ�șc ��ҥ�(�k�1�#����wW	w_���r?���,��XZ���q��eyQ@�=%���2;x��� �Z7�I	5nG��d��Of�[��LN����J�d��Bɣʐc3�I�R�s@.���7o�MQ��埯g��WEK�e�7�w�U� �,�
��<h����k�]��G���˳ڰ>w�"R3�8Y�P-��N��pn'��T	���˩*O�R��N�ӟ�u[������eS.}[]���H�MK�@y�L���2E��c�SEb�O.O}�I�\}Z��9�8�r��5�K�C�V'[��1�@}�ᘯ��`\}��t?��I�_xp-޺#<���H	�`�'C�|�};�ğ�LM�+5S7�����u�����og�K⎠�kh�>�N/�a�J�Xh\5�b;"3tQN�����ZI�a�[/"jp�c��ld̵������DF������-�y���3��2jDX˞����gl�Ò����� ���h��>?�c�FX�Q�(�.RI=mS� �(�V[1���w�O &��;�Mc��b�,�v���6�d���L%JE���Q�6l��k�����f��T+:�L��8��?�wF$_��Uڕހ�ի#���P�Cn��;���Z���nVC*B?;��/��<���h�c�
w�/�p��U������^��v��]vF�52s��4{�s����h�m7��A7;J�`��|�"}�V^ �d9(���P\�Ĳ,    ��$j�&N�WyXvU8��Rl��0bؾtH����K��8Pc�=�F�_P�? ۅhv�l���D�PC�s�vF7����_�e�^iq�d���z��ӊ���v׃a�\i�z��)&�m�r-P���C��*�y0��*K�.���.Fntʇ�_'H�K����f���:lWz���0��:!jk����g����K�Q��DA���c�9Oy˴�G��&��i��Z�l�ї�^V�*��YPԜ����U yZr�}�����@`A��q9s�����?7ǜ[Z�Ȁj��; ��([P��:��w�G^Mp��n�р�f���*>�,(i�\�f�@����߲J�l��,hм<�ABͶ{
�gn���f�e��Q��o��5(h��v�ɀj?h/��1[���!��܍@-!�����|�e2�O���� [>Ҕq�t��o��l	K�[�n��V,#ay��`����H����k�H�2�R�衝),!	��*\L��Q��� ���YR"KH}z�fu5���wvb��n�ZB��ҦԮ�$KH4�3���Y���vL����Z%�A��������P_2%F95�@��R��3G+L4���v���BǄ��yU���>�"�` ��ܲ��1QiE�'��ZPA��Z��	Zv���,p��
�����'�lhv��&W{�a?j#>�h�|-���Zl����ׁ����+�֧�Vuq��dC�1���-���th��_����a�놺��A�򛛫�w��~z��|�-lR�L�v
�|����,j���ž�)��d�eę���F�&[�n�%l��-.�,P��6;�ː>J��o���:8�=�1�qw:�& S�sjۥ2Z`,ur���2Ո�O]j��������|�#����j����)�ĵ��R�����KQ@Z�&�����Z�ҡC܁V6\/:�QZ۟��]>T�4µ%���R��m�k��羽"	tK\�T�xRo` �M�k���SHv\��k�Jp9u���y�Wr�:��ct)���5,��������.M jGNy�6M'D�-�/-�2zj���rk9Qզn'5{_C��L����=z0�zh/���ᵋ-n �<�Z��0O�\iVJ�^�H-LVf� I�8���v�LŲ�����k�����9�������������aŝq���C�Ŗ�g�b���2�]*��z���dH��QL����a��J��!7M��a�<GT.s�d�7C&�,T�S�Crm�#�E.M��pj��`���+�htM�#��D�1��kN��/!��/7M�D�52��3dj�ft�����i�{حy��ɟQy���au��>�]�5�V4�Y���BA����{�%��p,����GK�\J� ��i� Y�W:�#׎\��1N����Y/��+Z���j)y��kK��kd�⺘�3��&�OFrv���<We/��|�,���8��;�+j���=�G�?��]A�`cpm���F�[33�����
J��1�}PuI�dKf�܉/�z��Z�^U]�.�"VR�B�/c��z*�d"Qu�dMr�BlV&�l�m��I�Yێ}�e���>��u˼�0��<����R���Y�/��:���}F�,�KX�Qhk��e�R��x�2z����-��R]�8�V�%䒱�9��=��Ȗ�}���>s�-�k�k�x�v��1���!�@�Qp+�R��'�0�\-��B	}˰@sn.}5�3��u����u5l��N	<�:L�34w�SB��kB�����Y���{ʛ�x(��+�ys�Z�]Nxy@\߿�l�?�S_�_�A~�ǻ?��8��>�o^�}{�9��5�Đ�2JAp��ZE�W���8�g~���]-#��#�O5�s��}Iڐ�#R3
�`P1�ѐ�q�2�&Zj�2R-���-)=Z�Ŭo�(�[�gDK�X���c�l�|�h�V���i7)/�hyV�Phgl�P�%�~vJ�:����0�6�E�!��Y/�Ғ���@ǹe�B��DIu�'h�kى�nb$H�2;/��I3��FX81�d�D�]�l���g!�-I(���?_�IL�KcC��m��8Mq�;��q�HJ5��q)�m����R����-��B�ˋ�]-��6o�-���,�Jc��-��yĂ�' j�����}�f����݋Ư��"�G�"�&@.`����R�GF}�#8���b���b�L|�\�y�gbI�y��
iX��қ�^8͹�qT���*�qX�C���r�c]D��G�a��P��/+7,�a�N��NEb��x��ʑ�����O���n��d�����w�ys��p��t�����8~u��K~z�K?�����r���5�Z�֠؛��jE�N%�inv����m��S[������w�m�m/brcV͇!�An����%��ٵ|ڒw����o�'&yop��;������nQ-mX�hp��'ABƦ�dqc��<���tp=׀�P>��uv�ENj�y\��ر���b�ie�S���r��H!���	ڱ�-�	0pG��gm�X�TѓXwQ;��0d��&��S"ͼhhO�eN֖:�!<K�*�M�m6)a�*�M�2�]K���jd�J���oky�B0�J�bĆ�$�hp��k�n����� YܠS5!�A�|�B�����Fs����O?���ۿ�Tt:��A�Cq��8��a������h�߅L�˯��,z]��E�	��=�w�	Ue~��C-<jd�Bz��Q.�>��c>�mX��;t>:�?_^!�B2j��|(�g'�`1�L����j�Ѣr�������Z,��ͨ�㽣j�yN�_�k|�������x���[ق>5(�ѝ�e�Z6�or<Toe�ޑTr��G�q��VSq|��"�[�'U�K+Q�Q�i�,����&�%Y-C��%U��v
H1ElGV-��*9��q��} Tq|q_ �Vk;}(��=�I]�:ī��+�ֆp����z�N ��<��`5V[8����v��[z�ْ�wǹ[��^���Kh�`����R���z]+���֩,�Ϛ�M��\�0J��w=Cٓ������g�Uգa:G��o����Z��3y_u��W;���b���n�g��2&ы.ߴP�d,U� >Ħ��(�E�����m�$
l�Q��(��D�R� ��y��n�����ލ�s��)X%~��e!˟�K�s�ܰ�EK�}j/ :�2>0�%�+��g-��2�aXM���R'b��E�[���jwV\*�.r��-qy�4ɀs�R�B\����}��LM�Q��eB(m_�7Y\�֫I��f�4��);Ӽ��̰���;1�&K��5y���8��F�J@J`pK(��]�`f�	@-=�1c-J5�/�]���x%rJ�M��d�	�>�<��S(YvB����(�]�3(YB�2PR�X��Zn�R����x���}���&E�a��M{&ʖ������r-9)[N�Ι���Բ*�򘚒�B��B.�TjOJ>���!��m�^�5$�s_=-y)G��K�}��	��1;���E�)��"r6�}{~��}��v��f�B�ǖ�@�y���;r�r���r�Bs�2���ұ�!���d��\9 ��7��;'��q��jLZ�C���*�8�+�Ɛ|�{��e,��Gr:���=�nDX�����x�����dȥ������W��7�bVyA�z��"C��Z��kjo�G���/����~DYK��,VG�����l�����i+�� #+o�i���9��"����O��fў|�1r6��S�Ҝ�m���Yd�RA���;]�' 5d"��a�=X\ҳ�Q�rZܾ�#����0�,��ij�&�.[��2����Hn���������������wo>�����W5�\�)�c�x��-r���9ߦ�C���뜫��8\�:-d������B'����c�����.���6���u�O�aU>#\�/��EZ��-M����<���Z���^#@Zn�wL    V��O�J:Um47��,�ơ�Qa�IC%���>0d�.� e��Ӓ3�D%��bhHf�5���`j�����5sS���J����5ؘZΙ��:��#��zf�K�'�!4-Pe
�0Ut�5�(Z�P
r}��A�xzv�Rp�� O�夝9�v?��g���Mf�PƬɛ���j���M���Z�*�$�C���"-��5.�6�h�>����p���e4��ߧ�3A�!��dq���D�g��b��Zf�E��Z��Y����w�1��I�hqK�ŧM�Q������9j�}s�[:݋����gp˅���|�}�ťR?Ŗz`p����!��w�WA�0���^4�Һ����P�i!��N�aR}�դ�PJڛ��0���-�.Q>oS��0M��-������M�6�v�-�I&�q�q$�$a���0=�L4qQ�i�W�0=>h�9����9L�W:�.������F4����:L�������^Y-S['w�Y����8
�~�*��ȨuY�T���֞_�����s��8'�9ʞj�)vr�ݑ������Ւ�cp�!���ur���g���7	0%?�/�Z���d�\���΂����d�^� �x�4��[�p�$�%�)4-��d)�/��<=F�R-t8U̮� ] 1)���Ȝ*�GM��Q��犡Q[7nق�SŮ��Z��R��i�URI?��mw����\&�� ���G'p�X��9����o��sE�:�[�XցM���p����4��2���m�sEʬ�rH�Bl�m�sŵ�����F�����Y��(5��9Y��b�.���9h(9���q*P+���	%A[n�wFl�-4�y�)3U��;C��.�ϝ��C����B�!��t�bc�1��Du�&������4��x�?�Gap�O%�����[4�\�Me�j[v\����c�����l�'�a����fz�cF�ÁX^�D��=���%O�	��֫-��k���M;h��e޵#8fK<�Q�����N��ۍ�?�vg��}���?;o�n} zt�z�� �?"yh[<d����erZ�>�ФSz�����J�쐏��v��B�5..>d,!(�������NBw:�7bc�cX\�Ծ��w�C̛��=����%��w�&
�Mi���h���1�ߔ�>L�̡B1�7�2��.e��6��50w��ԣj��� ���H��v�NX�w��65����]EʓqK^�,��� \�@Y;�6�ƃ��0j���ߔ	:50k�olz�5'�2@!��)�k�,pТ�Cڔ�>�C`m���d��ln8���ۉ����M�.��� �S�����.灓�ꖧ2o��6�>y�	DYj�����b�YhM��z�:����K�&�ۊ���B�O���C{C���=:ܽ���M54F�����@s��'�qc��<�%0֒=Yu>֟���&�j�+���cC�r�h�1m�t������U���tPTP�Q#���|v����4��#��;{P!r@�j�Ř�k�h��u�EN�"�v�d����I��T��]�y�O����p[�y�`�KXC�������jzF9�9mL ��N�$a;�a�b��.%�/
O�ǒ�$�Xm�Y�%	Bn��aL�e6hk�Ӽ�v�PCks�uOɽ��B�� �FJէ���4���4�h�,:�])[T�{V�Y}�PC���N�/����h���=���-2T =:�rC�\c�̖�S\_�<��E-�$�)��D�R�C�<�Z�ZV��	�b&em"�
�R��G����������!�zŢ�#uNihS�<�e$H����=6u�G�MP����v­��妾��,�V����7%k�_ԧ�޻8YZB(�!m\��vI��0��ȑ�ˆ�yd�OZ^:B�nF�yӳ%'����mX6d��/��it���9TM�-Q��5��<�o�l��|i}�J��m���}`�Q
)ׁ��Ϋ��WjIJ�T�ά��p�C[��2��;��8��ٲ�2A�g�}����J�QL����Ax~�c��rᓖ<f�fQ1��t��:;�.��,*hne��=5De��ʑ����[��	Ԡ��xB����]���0t�ٹy�����ݼ��߯�;���P�>����J�t��'�2�g�.Y��sT�`�/6�<0�j��OnSۜ9��&��8�h��l<� D�OIcM�����Ӛ��O%}g1���Į�y��vkhyBr�a{���@�Tc�'W�#xv�<������!�{#�\2h�؅����s��HLpM�i��&���6�޶��Q��,{������ZHy{��#g�T)0��*�m1����Y� �/R�8-�㕏�C-��k�����#�-�s��䴑m��ѓEM�]��ޭ��gQ-OjO�~C��.�E��S��yuţ3��;�O�" W�>ݏz=�������o�4�0���!���*��6��.��֛b�
��$�: ��Q?���x����}�w�u�Fb��S�����C�[e���|�̓R���Ju����l�"�e��PL
�XN�Q�̜&i��͢ZZT�����G�������ߧ��MQVo	�����q,_i�X�.n)�cI�|ņ��'��g8�ϠX�����s�k��o���}K�X*_�+-}/�I<Z����]"Ni}�nN	�,*�H�?�IE_��Ie�C��:3�T���Cm���z�pJM���U��i��"Z�J�sQf6�=}�Ǟ��TK'L#/-��t/O�OOK)?���\���TbQ���D��LHj285c�)�4�h�����z�漾�h%�������;%�J�طK�=��^�2�6_�wv�˿4#�%h*�;���)�h�AI���5����6z�*'˰T2z���j�v��@K�d�!�eF�%I����2�|���Ý�e��Vi�r�E�+�@����̪$���P�c������_߾=��|�ه����G���9���_��W���wz�S�B��Xd.m����#O@��k�.�v�P�5��[sk����B�1�q���F(e-9/�]�Xy1���	:�!������=���Y��r(�ވf�n�����.�K�&�ZN0�;��ڵ���x/��}�F��Xa�?}�(0�O����?�}{��>^��a����m�#�%j�D��^��q<�-Os*�J2����`���X��q��wo>��~{����Ӈ����������V�����͛�Bg7�1���	d��uʌ�/f�ƌ,y���|"75~��Gc��|��C����J�YB����9V{7�qOv������.�ѵ�����c׿��z(�Sm�c`+����nq�����&H~r�����r[���ߟ�G������?��g���X���o�\/��)Z���Dac���R��s{st��	��������_�����7�o��{�����߅���?���`�Ğ9��tٮ����������B�q,���@�suw��n��7���_~4�-��"T���
�Y�Y��%=%gt�*������x�o|��R���#��`��K!]�_8A�����6\0�}��Q���weٟ��("׈b蠎��mX��X�b,�[E�T�EMǌ�G�G��0�Z�I�j�뙜pL�TCʣ7&��3��_g��Q����-=w���3_I�
�ʈ��[�WΖr2�������$����`���`����Þ��֘]�����S"�F�ǉq�՝�D��r�S癴��>O�
���<��C-�M�0���6Ƥg�I'K���		�)��ă����-���:4X"�%v.c�e5Fy�(��ؠ�c��-�i=���6��2�yS�q�=���Ҡ��<��#�?�#E+����sD��n���F((s�=��K�wΦ�L�4P���(j��:%�\jjf#i?,���w��r�heN�t�ܝ�EƬ�53ZYY�/�z񜏜2��:�V=Z�Gq)�V���ѯ�w.rr�"�~?�+c9�{�/�fI$�`|ķ6\�[�x,�?߼���Uy    ��K�x����z���)�ȥۊ\�����S�8!�#+{T#!ȓe]���Zc�,ƹ�&I���A�i����$�*��ӗ'���4�\���uB��z�'�\���}X��r>��aʇ���Ul��-���|n{N��a������h�K�2*�6�Q]���|d˨�5�j�
y{*yK���H���_��Ay��1�;w<t��Z�@rg�}��_��+.�RH�b���i�Ĕ��P��R��KiP$�m��E.	�Hܚ��[dVo"�����F���r)T�s;m-�R_�`]v������KL%D�d�l!KN��R���y��"�R���?a"�ݜ�<o��0�he�'z�r��cނ�P틌�O�Aγ{�%^��,S�4�&�-�hJ��,�����L��FN���m甧2Y��
��1�i*�9�fiޗ�>����߉��Ҽ���&I��]��&=���G���.����!��tN_�B�o�A{��R?������Z�R����9�nJ��2�Z6&-m�Rb�KfWO	~NruB��T&.Fu6�L�K������Id��������S�>#i�%v�t�@�΃�N.Y�>��Yy�bM�T-�Z�Y�S?k�%suҥN#fy�r�ubY2�� �s����dN��N3&I[0�$s�dN}�>�0~^�̩"sM$�l�g���%٠3AҗF�liZ���''��[g�;[�UH��B�VȖx������Ɩq�oUK��f���*��u�Y����o?ܽ�'��o>����ۛ��w����~�5mo��w�9~{>��"���_�C�e	�ud�sv-�k���텃��)��d9��YB�1u�NY?#ְ�r�|=��2�em��]`u76b���*sޥ5�$��V�bNR7ȻX��}$gE;��d
S����ʦ�3_)T����N,�]$��Jsi���c}�&�OK�x�*/%���}ܪ�sߦbר�Ly�u&�1Ѣ�Ɓ�CF3�]a�����զ��v�0� �,w�ZǙ�N)$���rd��w�vU�B6 ,�2)��3�&�R��<�Bi���j� ��u�=�ɑN�h�9�	wr�S��4(#; ���!��q�xPEv@.Ѷ���kd�ٸ�:wjXUV���)��El�-2iH!����9Yd�GiҖ_mm�a���u@%l@��dV�`�}���%�ab��<���r���ae����b��7�>t@_�J�+!N9PR��h��J�̬5�����a��MG���žl� �_%�|�X]� M^Q�Ҫ#"�.���Z����l��FJ��I3��˩���w�M��3F��EVG�q�6��iXDu�,�<r�����UR=�r���I{�~��O&#�<���#����	�R������C�E"!����ʖK�+N9�>o�'[��~ҍy�k�\�
��n_���c���U�Y2W
	B��p�2�-�Y�/�{�>�~�2�L�-�٫�C�� 7���l�v��{ȗ\������k�T���u�瑁�Um�J��PL1d�6���h�҄0�*'}��4J�zH�8k0�t�P��WT�@��W̬�[b�h��#�ɷz��S�YҞRZ��DG[g,i�tB��$~�l��OEf���J/u�BX<=ftz�P���Jtd��?|�SU� NG�z6�VJ�Y'�b�1�����yh>A��W*�OR/���Y��1�2�a#���8N`f�5����Zb�yo5��r����,=�l</�'Z�\.�IG����=��y���dK��yU�U+(4�D7��kd�W^̳���I�=k̆�%)?i��e�x�:�U2�4�w�)�fZ��cU�ARж^X��Cl����!3v��v4��:�����aF�Y�rN���|�� rÅ�Sg=��㗎�9�MZ�)��6����bf�?jc��3����@~q��|P4����;Mâ�-���Q.ݳ�S1k3�v+��ygJaELh�B��pHiR;������πG�G�Xڐk����)w5YT,/>�����9��-*�A- |>*9��g[�Ja�֝G�U�,��Le��?l^���<�z��_$ZT(��N-iJ��9J	pqL|*ר��s,*�c$��v�@��t�ڣǽf�K3jߘ�2�6玢N�-���s�;Y�ӗ����@��ُ��徒5�<?{�V4�5Х�����]�ߞ�m���f�4	��d�ٻ-�#�̖�̉���/<�Yj7�Ä���Z���dM�iG�l��d
��G�<��G��5,�������S�rD!���w�̫�^�T�Xp��^;�`%���[�6f��i���|P_��&(��>����cE��K�F<t&���|��_,�v�R���S���������:}w����
H����ȉ�c@����� �P���l�6*�З�r:F�`�Q���;����C:7���Z4�\�h)GG6�.@����n��D������2���8-�ir(��*�c��#�	`�3\��Ҥ���֜��c��- -�0צ5Z[ Z��Ⓤ|l�i�<_;�1�2=]���hv��#��ALy8�iGģ��Q�;����6=�K<�EuEY!q��E,aq�|�F�h{��Ν>�"�S�;��q��x@.�W�����k�����3X�2G�b<&6�[�Ch�Y^"�ڲ�zT��8f��!Y^RL�P�iX��<{��R�/}������%&u�.1{��5�ђ��*6�qEV��"-3)\�@�Яh	}�2-/i�C��Ӫ��s�t�{� <g������ZN�0Nb��
��Vj�H�q�I�S/oGq�J-��;9�:�`Uw���Z*����qMnr�� }L� �F�c"��O_�9jbz��@���b���bWH����?��3� ����A��J�d���;eih0)*�O',X��}�Y.+�_��O�D���ِ��Y���d��b�rkcfZ��7��dAYS9��׶�;�*D��Zp�8n@C���v~�/Xo�C���C��!����>D"3X�SI[���ʻj���,9��w��5�Odi�d�u,�
��r-�A(e�1��4��d�#��d��)Crs�
(�[b������+�},Y���%Ě�r�p�-x@m�ʡ��"}aռ��ǂ���:�\+C5�b��� �e�����Z�0��:#�͙�1����׼��,�,t(�58�	��4�\�1u�J�q����d�������������P���a�Ǣg����2�Y�X
�qU��%��b�
>�!U�pvS5�	P֧����]{�-l���5ax����M���J�9���_1��A��t���b�5G)F�?�y��i��;�2�w_+[�c�z2�~�dU@� X�6oɂ���~�+Ǫ�s��	� �#���ڷ%>�
��+�V��G?l��s��,v��ON��J��J&?��a�D�%˄d*-�J:<�;��j��5���(���#>�f:A�|��K=�I�i�bs����s�q���0S�Uk��.5Ԉ�tJZ\_�`�q�(8�)��]d�pA�d�k/�L\��#+��>^y(.�Hєt<��E��t�
B��<
��
Ar����7�D�w�jXSO�_Jod���s��s1=@-�����GCA�s���)�j8t��(�K��V��QB��;�P�`��A�B$��E�2dʹ&��dH#�d`�B:��y�ӌ��
�j4����{"� DpF�G��uU��[!J�'y��Y��`d���A"�wGK!���ͨł��i�d�����;-d{x����k7��)PɊH���(>!�Ie��\;��~�/�j`��`�Kf!g�8���O�J���0.s}�W��Z.�y0� ��}�T�vH��>s$�_#Z�UKD��������D�,����0�e�e�\�搘 	}0k�˴\�D;���FT�.�vܙ��"��S�Cs�CD�#K{|K�Z'�]��7���K�Z8�4:g�\�P��L�5*s�v�Wb�    @��r�
M0 �pr�ϱӌ"��>�Z8f@<��l�amE����X���1�)ݻ��ѤH,]��a=/���?�u�>��l���)ǃ��$�֝6f���"�&7�tR1T�z�O�`�	A���|��� ���jQ��G��O��6[IH_��@|�&D�ӈ�,��E�J������.�g�?��d�K&�P�H���x��#��B�&[�����!W��`���g��B���E��*��~+dK���:<��8C�,�h5ɓJX;���՘��#�y����l�w�!���%�-��[��Gc<PΆ�e)T�:��:�{��Y*QHk� �Gϣ�D�Aa����.ϻh��i�5\\O�8��2M)�3�9-24M�а��u!����*ϕ��&�i���w_������������Y��U��� f�Kߠ�>4�~��p��i��F�b6m�Z��~�9s�;o�Ke4b�|�K��*y(���E��R�I�X����	�M�㒢�]�@F(CW�����~��cI ����]�b�>��kë�ƚw���x"E�Rx�y�M�^�K� JH�ٹĻ|�l%	z��4uAj����-�B�".WƎ���ׅ���zh{��pW'ף�����޼���SwQ��O�\�1:�����.F��w���0В�����C)M^Vi��8%���KV1k$�`�Q�`������G�r���ӁF��^�˷o/��l*���kc����9�k`���XoO��f!�.?29�q���yHE�T�)��d��[�l�,�[@����nY"ʀ�1@���|J1,Ȣ^.�$��ҔnLMO�k��?g�$ `ף]��(�A��mڣ��b��k(��@.����Ȯ��[Ct�B�m��k1���,��[��-W�|����Pխ���r1�8zpŚ�z�J�T�eǤ}B����X����ރ�� �v�(��>�<uh�81��x��a��|�C{���Ȗ���0yŧ{zB��ho.�RBϬ�A��o?ܽ��������z�������_���K��q��wr�~~�i9&,P��������R��1q�(fm^��m�v���I㿡���~��6��Riْ]��eS���� i��c��HG^�a<6wr���y�d�����I ���7��z�=��/Z��8v�~)�ח�HN��0����g�{��1��X�/d=d�GM���B#é� �m���lsY��v�L{Ȅ~\����'�w0�y� �,?k���X\>�q ��xX�?�ih�4hq�+L`���_���= $��\�}a���E�Ň������^d-#vP;�^�%@��g֌"��
��^d�o.��N{��g&����$�Q��賒��+�j�%���3��=�N N��{^�Vf,#�Qw�Er\]}�sU'��,��5�t�i�?����Š%����$(˘���-?r���(E�d��^9ZiJߐ�#�/�V�I�SJr���Kܴ�^� myH���qV��Ų��~���>�~�.�� A�ꞝkP%~7j�E,�$���X�K:�R���W�����Ik������f����IT�ɘ�������T�3�8��K�-{��@]�Xک��`��:��aV��JU����
��I�ۚ#��)��M�h/>m�Jp�v���:W�$�k��2.K,?y��KJ���<�a�ޗf��F����!}��o����#?ޕ��?��n���s7��M�}���//�H�̗���n�Rh1"��	�ۿ��y|�G��*ø��R?�}���B��xC,w���۵��5r_M'ʤe9�ۿ�%xO$��hy
�������$�pi�$��P�a��M�/��d�J�m����
��P�ES������2�B��K�w��11���9L�#�q)A�2�����꾋�j	R�e�ے\@w�H�]41&UԎne��m��K<}J�Y`��^���ȵ(b7��:�P8w��	ٙ�P)�r 6�e˩}��(��=`����6�0!CԱ H{up<Ch�����%w�����Gm��/m�Q�L��<�{� �
R&�G�����/�8�ٟ����([Bg,�|]��7�X���a\�Η~�g��ɡ�+ִ��99J^`'̣�7��$���p�ȫ��<�c��Y���^!㞝������@��GH��$�'+?#U��R���f7�,�蜂#��&;���)8���#%�SâguNC-�p�G��҃�/O|����sM���D����s|��_��\������D�77��}�3�J��P� S%�W	��_b��Ӝ��-�V
�X%p��A�ӹ�b6j�d�NP�f}0��WL�gAF���7j�𢯮����b��C��>���"�W�>ݏ�Nj=���C���u*�� ;��Pv-�w��%�>��t@�~|�h���m1�}^�\�랬(�1Ay2������Sctq3��
	F,cm���-�6>v O؈�nu�,��B^gZgOy��r�4Ï�jX�!�8�o��Ǘ���B*�F�2m" /��^�1W�`(F����N:�x����:T����f|�UPˠ}a)�k,�V��OL:�g{���_l&��&�Lr���X�`p��/�DH�uU+J���f�/��2��%Ԣ����13G�]b�aP��Ry_��N����Y)�FGs6-l��5�v+��΋)a���J㺤Rh?ԃ����y����Ī�[:�8nN4�`	%'V%��oY�#��㐕�T�?%�_V-lő'=iÃO�BZPh��6��)���ZI���5j�V��j	b��Mz9K��b�D}ѡ,��5�E�]�D���k�u�E}81/�ghXR����) ��:��V����E
�Y#�65ׁ�%k�f^"�`7�������(#��j����;�{=�2Bp�$,Ҷuۋ��m��>���b�`/uf�Xtޯ��KAcXOkl��B-�|,�3-\��z� ӟ,>�e�4Ŏ])�MMХ�F�֥�{2��^��Y�iUd+HҺj-��+��=IU��ih�[�4Sv�yy�N��!���V���[M�Y�EϥL('��g�
����]!dJۧ�̪�jt-����o���@�Le�j*e/>��MY����J
kD	��.e����f��!��đ��]��t�Y���F|�I�.S?�=����UT�r�,Gʌ�+O�M//Q�&�� ���t*�<
$Oc���9fm膕��1WI�:�ӒJi_�C��/oI`����|����$|XRV/��&�xм�i��ӓ�d�C���p*=�CZO/F�5>��<r2�$�/nT�tc�Q��6^������5�#��OSn�4!ς[���ʩ�r(H�H�X�Sܬ�d�[6�ѣm���ɗ*"��)!�H~Z�����W̹��n���k���-�׸96+�<A��9�	�TC�`-�U���7Y1�3�0�[�Q�T�KU�$/U١���XqhR��V���ј����ɥ+	����ˡ�:;���.{R,�2���Ӓ���
I�KY+�9��e�(1s��7��)c�,~��'�2���X����m�՗�)ƅi��_���A�?Qp��ZJ�y9��㜏yA���r�
"v�B^Qɰ^!���)�#�1�3�ؖ��C��a��,v��Y+�2 �g,��6���[�d�����i�M��bO$�OH�k�!w�4vr�ˮ���ɝ�VE����<���g�R�kv������X�oP�ɺZ�~R��ع�ԷV��%+N�p�1i2�wS�r�9
'�g��%Xy�&�0L<<j%�R�gDZR��Y�}�s�y�䊈5S�.�U��_��h�ed�O�c?��*�YV	�N�Bet���*r�Ô0^�rD7bRm1�c��$���Pp��D$�m<�(�Zf%�cK���ߩ���`����$�Q��g�O���ۜ-���#�i�ّ+w��T�:+JG�xQA�Hz�un���)����۳�!�J��1c��\���x��XU7E�l� }K�>��R���JQ�/��#)ZmM�kx���i�<�ǎ<�կ���8W�λU<�Eۊ�� ϒf    �Uh$��]^=�T��� s�s�lE	fF~j�`����`.�>��D-��w�g-Ѯ%i�qn�E�H��dUkw��|��s/`����[p��R�����e�qΞץQ�����$�4/ T�MRh���/y�����S�M�ٷ3��h�Ї":Ԣ{� ��S]�qB��A���E�W�^�ٍJ��x�x�x�Ţ�����oo�-��!�O�[Sͷ�#�ˁ\�I�|�|CK�"���ɣ�>���|{����{� Z}S9��o�ω<���ӇJ{%�W�!��Y����%x*�CV�.��A����?T�=�+����,4��+��Q��C+�KJbi�K���󅘃hy��ނ����!�v�YWĺ^^��ˎ���G�ž�cs/���LԎ̥["�Zdm.��y}��($YAtУ\���K�8��s���5/t�����F'WK��^V�틒�B$�qL��d�>�������+��4�T��}��/-�Y��p��/}��� �+?p�؆�		�\�5'ب������Ƨ��<lۻ6�������"����\�(����f}U��l��7:W�Y�W$��1J�p�S�Cg5/u|�� ö��g�hkc���];+�|ҳ����Q��V�FV}�	��|rK\�Z���c��ͳ�Sg��S>�|��y�!]� Z�V	ԣ�>���}I����͝�R�9o[��}���`�\+�K���`9]��sG�T�%sm�#���F�lԂ%f_J���:��*��,�� \�?ڬ���AK�5.����(�e��R��fUTL���Z�����XTo�_T��YOR�K�֩ Z��OGL�Lh��!�vU��"	-��#�����`��?���[�ˑ���I���,E�b�8k@7S�%H�݌�2.Q��F,��p)'�X�%E,����vA����81<<]����>iÂ��@�fPwx�J�A�Ԑ�<��ePGxC����xؠ�°f�b?y�b*�Z�����py�.�H!F����Z�EG-b���Z�ҿA	a(��/8�N_�����o!�4,oq�f���O��k�}Y��T3��)��.M6Ґ�E����������j�d�(�?�-hp���b��ԹU2�+e����C�L�K*S&��%"��w�/&Uӕ���E��m�ܷD�E�<w�}z����{G��p�k4�%�8���Ԯ�������>�����nrdJ�N��X�p�|��I�'$>�g%��%�A�^/)��ض��4(�l�}
�)}?���e�τ�� CyvL�E��T�J�N��D��'���L�HT�A֞Ⱦ�rXR�z���H+H��5z��î�[�-Ηb�-���y�q���U��B��&�U�Ƿϖt.�M�R>tW��Ԗ?�!��[Y/�5
L#Y�ů��K�l<	s�e4(��(Ix��"O��i��Aq z���e4�sK�B�:�
��eBy� j/����g6ۺ���'!��1-�A?_W.T��^�5�­�F�xm�fn�7��}����>�wO�����f<�U��*phZ���g�䬑�t*/L�?����K�T>�k}:U�è5e�����R�A��I�'@u\@و����'��o��3�Lڜ���$��+���r��K�@��j���d�Nɫ� +DҜZ� �,1;�T�7 '9i�9�ti��"L�ЩP�$KւǇ-z���뷿}��Y��Mʵ,$lC��;$a�O����W��mg�I�f9��$ƕ~ѕ;?Y)����B���\� �7�p��.CWC��h�����#��-���g:�-��t7�%q��ݒ��_В9��6�U�X��ҷ�]�B�u`����\X�{k�,Us}���fltP,��q�H��*���4L�s\�X1,�S1Ws���3tK��Ner'���õ,��WZY�MN�#�.�>n�j�e萪#���+�y�sT�0�ĽOs>�+<t�m�~��W���������oYBu?i�y�K��|�Tw\��5ˆ�|�%Tdi��� ��$��'�>�51wh+4����&�2#�E��nˤ�:4I��VU�d�l����n���a��@�݂.k2��~О�%Cw���)G�jItj��Y2k��<�lTW�s�4��N�>)�Fdd���؅5C�7��#YH��kFtm�%Y0�P�یlܯ��C,�zV6۬i$ �Ц�Zc�>R����Zm�Uţ�ǀ�X¬��Y�<OWM�1%`V�Y�9x+��UL�k�b@�l���P���ũ�[�d@+J�or�V�����w
TK.��V����\���.1,�=X�	��t�J�п�R�F����ǷY�塄25N�O��Y�3��,���(�����*V|�4�!O����W�X��p�ѻc}
�B>���l-wv����<E��l�
C+C�xq"@���/����+B�m�`�e�-��,>��_r0��ʒ�Q�kWG�T���V^ּ`v6�D/8��ŶzrV��:��z�N|3��Z��׫��AE�4���v�*NPK����l���<hgt}#�+�]��Ȁk4H���͵l�\�ʕ´��u����/\I.�'x5!�"�ﲃUE�˾@2����x>�a�N��껻�߼����9%�Zd��X���Y�Ȯ�@�˹U)o봐�t���F����?G*3jV���$��Iyڋ�t$@k#E���vy( �FK吮�uP���,:k�1o���#��wa#��}k������%���K.�����,�y�9ֲ���ùD�G>S2�PIs�$��z[�ug츜�z�v��E���]�Q&��\��q����s^�� d(vZ�`���5ث����\�y�2�����O��B�6���g��s�vd�Ƅ.��wX�/�WvlŠ2{��G6�6�P#Xp�o$`��O���Zz����-?h�R�&YN%�_��f+LЋ+VṶ:�Cs���<�7k�{#h_�N�˘i&D�j9@�(,sG��\�ҡ�/q�e{K�� ����-a�%b>(`o	57�K�>�k.Y�Y�����@�4Bc���f�~+/��� �Z��~-fI�y�ݜs�3�-����e	��w�Xe�	�+S�֞���Q,)���#��-�_��?�������J�ssG-[��o}�#� ��g$,����%9$�Ȳ�[�ғW��m�=�y�*�5`�����ޓKAv邪Ὃ�B�((J]���&_��U�'�K��*i��PK�U�v�7SƀÕ�����v�f��%1�d�4-w��*�4��))���#���'_ n��(�r��O�3Pc��\f��s(eX\c�A~kS�)_��J���S��rU��/a֝2���1���R���3��u�k<㡂G�:qx�!�b8%M�q��[q�FL�̔Y$�𘄡�մM-.�gxJ`�y*�i^���jd���wټC$��8���������U��S��F2k�_�O`1f�7�y�����u��Icf��e��u�-�����=f���(%�,Ғ��Ny�s+��%����b�����U=[��KbXaX�V����h��}݆�r3hc��I�+�c����u�b���Eb>�h�&E'� V9��}�\��T�جH8_��r;m���~���gnΗ̖�A���2[�n��+��(hqS��ʏe��_A�UR�.��s2>�B�3zw�ł�g/�yu�K������K�����FGo!�DeR�<���<��R�Z
��{{,dx�����G)WM/��A��A�҉ym	�J��OR���%7Ơ�� E�T�����򾕳�	�F��d��>�+[Th<1�m� d���k7-울vcp_�֎=ٶA�u�z�o����RgKr��0��4��s�&Yib��$\/9>�͒�\<3����۟~���Y�YO�d���GtV�XR#�$�g	3PG�jRW�<}��䬭z���ܪjItt�a��%�5��5��B�����7��sN���Ҋ+��5���̧���1�HF���;���, ��a+B�l9\V��튉#V-3�ԥ���+f��E�Q�xon�C��D��S%ICed#��v�KnU�    6u���,���"�W���^}��?G
��
֭�&oe���;D8�k�/��[$��Y]�Q�篿'����lN�I�0��]�#��w�/��9�* ��� b	SoU��M�F
,cD���J�^�ey��v��1x<�N��x<O	:�N#>��y��)%+G�q�r�q���2TD60��Ƅ���Y)�J���rw�#*9�p=X<�k�]������%����b�n�gУW����P�����נ���B�+�'��v�+���|������{��Hn#a�z��\�^, ��ЕGֱ%�l���!eў*ȑ�����$�Ev��x#�z4��T��H��v!xAAC@�b���>r�Uބ���@��]NE9��;������=��(�vG�Q��#G�����U� C����
���k�#��(���v7�*����!:��5�P��(�����	���}����^<��� k:l�AVSgu�)EC\�����Iԧ5�5gL��@A��_xU�t1�hk����j�
q����E1SE��(���+�2T**c��ݹh_1/���:ɸ�7s޸#��꠱]((��n�����~��߾��w�>٣��%�5,^��<�c��ey�����]�/"�(Qx��;�gn$��5d�����q�[-!xغ��t^�����HX�I�}���>��#,H���|إd��� 1K��-b�g�!QN��)^H1�֗Ϧ��m�� (�E���&�֚x�� +5uȭ��t�C�����R0�ݖ��PẀ�Qu�����`$M$K���=X���jTE�_����?����ۻ�_��#)�����,�ܥ��P�~%�k�k�]ޯ��Ki��$pJ��5@#���\�	�.�ӏJ���i� h�7_}���K*	Y,��g��Ď��A��P<u��Z8;���DI����5�H%��C��B��2*�@,7A�qM��f3��(��uQ;*�:>�3�8ӧ�@P8�a���nB��@�ҡi�ɡ��)Gv��bC���p��Hq� ��]���ھQR8����m�I<>�8֪���4KW�P����HG: 6UPhK

��O(XD��N�)��R©j�ܺ;e����D���z�r�q�'�^>>P�ApMϣhꢾ6(Q+�(�n�>lm��m�H��؁�Y���S��	C�l��@�4T̗�畅׵���#��n�|�=�4�$y��Ǔ#U�fk�,&��<�H.U2m��/10��V��.� (hCR)k�/���WZk�r��g�,G��"0�`�Q�~�Ĳ�c�|��Nɵ9z-�x���=���"L4�1|����\7�=�bK�|�F��� ��|;=�)����r��k�����$�엡k�Ο�{��w����(��â>t5(~�	
w�R��ܜq1<4/�Z�v��q�mc��~eu|������(�>���?��A?��ǛO�w���uJ(�Yʜj76k?ƵH`�3(/�eJ.�����3.W��J��`&(�5�Z���A�q�Pe���������F}<���;���Ï���W|t-gm�Xt%���ah(�(�\�|.�<��l���ʈ��~�|���(�7���{*�qɬ�~��$N�$F"�G�'�ߑ�wԕv��"�m��2?@�G���U�\)�4>+8F�g\T�0�)�"�ţ��O,ٚ-��(��Ě��qe�;^VQ]Q>34G�%��U֐�I@�P#�k��J.�>(Q8n�1�G��9R!4�9J�����֚Į�v��ʑN��y�u��ؕ�V���Z�E��]S�sԩXU���X����� {3?��u�����Z���Ҹ�&�l+:p�qi���sT5�N����C6�ν�����Oˣh�h@�xR�A�N��J��=�]N>��j���~������9J��'�lJ���/����
������qq�?��W�*$�5.��a���Ivkr6a¸&l @>L����*�����|��8������5���_����k�(���)k\&���,��X��qԐ�BXVbE�z�*�j�>��'����`Q[���u��M�A�`����B���q�]�T�`�D����1/l*Q��Q2��[�B<�d�ȇ�������{����膟��g=T�b���|�n婑������6�K���"�ˣ�9����mD��[�R�yԋ�?J;U�Cf�Wt����?�>>����
��8I^s�b����Ô��Q�������ٸ�&b+	
:��óo�CZ/)�P�oϻ`4v�&Bl(U�?�	`�ȩ��L���I$I�:��T�С gR�_�/%z
R�(�[&�P�������Т�����կﮯn~�a�)r)�쪁x�P�2.Z90`%ͿT����X�;�$e��$|�&�,��ϣ H@��(nj��{ '�<ӛ�P���s&�2����k�l�
�܌'6�6 �ǻ�I���/ν�+g��
q6��H%��[zms���H�����3-����3�$����1՛@�Ij����t�jp ���%�/M�f�aשp���W�9^�P��:�@ik�-��W�e���+W��P�V�+�I煵&	��N���kM	�ʬ�lݬ9��p�vi]u�6�q[�4|0��?��~:|���a���IQq>����dFӿg�e\�6��83�Ǔ�үO>�"���fNq�͚�r/<�  	�)��r���r/C��N����۰�I2fMjN��
��-{I(_B�6���F�5�$��8S3`��<��=�w�@�gHD�=��>���/_�i�WG7�?)�K�TC����3U3�q	�jv�V�i-'i�q��ã��F�Z���%s$���q��	JtCym��Ji8��z��xw�z{�����0.�{�P��=�З�'h~J�-��P)\Ll9���U�/M�^�y�TE�\)���q���o�<�F����IS��R#2ȹE����u����Rʎ��`%l�ץdA�b��ۅ��� x�G0f�hs�B�`���Ȏ��v��%�ӊ�!��ARP���D[��(`O�K��N]�&k9t���$=�F-a#x�3ɢ�l�&�����V<�؋�v�V a�U�y̑�KQ��|&K)JE@�V\s�ߺ����X�7�jCI��<O ���!޶�/��T���d/�}�`�*�h�8ĩ��7�����'-`����Ge������6++xs��������rݪ�OǱszg��ɖ`�l�\��DK^��tq�%����ј?�Y�&"R���Nx\|�l	�%,_����)V����]FR���A���M�B��V�W�Z�aLj��!���I
{�����EE�������W�S�E���3�	���e��������i�դ�	K!���IE�3t*�1(u��TJ�B�Qw]�Rq}d�"2#�NEx�ZӴM	��J�D���HRW���Q��c����AئK�Iۀ<�J�7�LlU�x>�v�?�`�*�l��M��<|�A�F�$	K����ux���B���m`����V���-YQ�Х� a�ӯ���v�
�:�x��v]�b	K�%�����ʰ���Y��~�!��G[k���CP��R���J�E�ף�i�2�ç&D]�J��8N�G��|!w�L2P����j!W��.�85VYGin<) eD��x $t��%"�W�A��"�h��;b������F.ʘ$#]+�	r�dtZ0�P�!���2��(����E�`t<FAL.���ш#��0J#C=
@ɸ�E��9&j���2J#C���nz`�V��m��ۋ2J+�C.y@�(��2�ɍED�8�2tZ�qud	�HF��
�PsQF+-�`,���$#�Ur/�^D��Kd�`>���Y<�O��)WdC&;#EIj�˾�u)R/I��"�<X|6���i�;�:����v.%�(I=u�K��H��J��j3�;N����K�+XՏ�͜�wSs-=-&Ah�^;�Z��t'jZO����>�2� 0���    FZ��?q�
�㴢��KR�]���stXQ�Ϸoo�%����uuSux�USqZlO��.��Y�uu��ٚ��!5��!:,q�p�N��"� �E>�C>��sĴ�C(m	�/x|�9N%�!�f��片��PZ�r�l�p��$H2\� ��h|�M��᝺V��V�<�^R�ecZpZ�Op<DŤ�i%�ᢄ��+�>��k�!]7C��s���B8��'�H68�|�i?�3T��T�tQ8+�%�?��_̓�j2�0{��w���:*���_�8��|�����"O��:�%��Aͺ��h���ᜄܕ�t'm$�Gj����<QjO�a�Br�<�sP`��%͓�o"��XVi��0lKVS^�2%i��r�ܿBi��R�>˅�y����C>">38��L�``�R�؅N�v�١����u�o�w�H�Ȉ8�������;ǅ�yCI���(�/H%!�}1�i� ��,p�6 �H��#BS������4m@��r���� !���vgLZ�6���E���p͉�h��5�4�l7�Ƥ�5���Q���JkB��O�� J�§��r�FZ-Ã�!���.ߏ�A1ܞ��5iPh�@��}�.�u%#m	�,	*t$>iL,g=<uf��W]��!V'#M�l�7�����4�r1T�Q��%iG��)n���	��,�^3Yo[�Q2R�[R

��fj�0V*��E��ec�:��i��y]�N6R�S�g���&�U��J=�~�4m�0R��.�vv>��na���g�~�P+�0������"��h2W/�Rm�P	���T�C��ρ�z�Rpw����J�ﲞCe�Yd�V :� �rK�@�
ʃ����Ҏ86�酮/��eN �
��Q\�����+��[�y�K�g�f�q�j~p���?5�*�k� lRw�Y�R���պ��%,�Z��uUl�%���U��r����
�َ��ڎkə����5�&�i\*�����Tۦ(�17E!�k� �:k���H
�h����7/o��v��_ڸ�a�ý�U϶�uza\>�:kk������6RM<�F83m���;Ov�+r7,�|jESZi$������-iQt�6햷 mJ+�ro�Yʝ�J�Õ�>��s�JC��gg��0iJ;�d�S�^��-��Ң��V�I���
z	�#�`y̦"�����	m��H������$I���mZ��c�Z�Z�;��hd�JX#`�j[��ļ�4�����iܹJX�|�_�YC5��xio����T1^~�*�Ҟ�܎0Wk���(��U���CZ
�p��	7�����?�|����/��}��`���td�V�����_ڒ��Jr�r��A��	/�W�/N�G�@�J�9-[&��_ؤă�z�?�|��|{w�>]�������a�/*F��c��kb���X��
ȓ}��-L\����G�+��4n�O|Y�/�/�Ηo���y%M��=��(�����`z]�$�-��`������wy9e"D��F�� E���+�����E,�W|(����+�w���Z�>��.*}�~�Ϝca�<W9��k|<���#U��;7<�J.�ƅ_��(�}9���.��&��X&Nd���K��I��	��[�f��I���4^�h�=����{V�͞B�J�Z�kE�&��������H R[��ll���)�S�p9���6���$�Z-�ˇ̦A�$U���'���ڕ���zn��f��!�)�J�'{7�V��R��H>5~l �L1U��O� LvF~����K�3���0@�XncBD��7�Gבm����J_����_>�P~��W�@����TR�-wF��A��7����QC����x�F�4S%A��{�<vh�DFK
�D-n�ӥ�O���0f�Vёׁ��;j����D9�|��|<>���1`~}w�O�?��U�AJN�Y�<�x@1t���������?�?����W����~_��W�ѼD�;��<Z(�TXS��}预@N2-�9V�T>�&2����ߴ�	T�ţ�*#kJt�5����m��)���	gS�� ���Ǜ��*��I�@0���)&Rf%]f�����8s���||"w�Eb6�4T�f�{
%	I�G\S��Y�yQat3�����w)�x��R�wR�-�2�ԣ�j��uYL��������c���B���|�k*?��6�A(�=�.�qDAc8�:ĶuZhKu
\����i��@�0�ļ��M�x��g.p?�i�����O�m�W�r�a�6��ŉ�I�JP��/}�uR�f4�J�xy��
�d�!*(Nqw���?�n>_��q%�E�U3���s?����j�ta������R�U걲��i�'	�h�ܸ��E��c��u��ӝQ�x���5���r��z~�ɳ�Xؖa,�'�l�[������⚸ıՉQ^��Q�葁K�1ԵX[�1�+�w"��Zo(�
%��S�gܹ��K̶:����*�0a@��ԨP���,.���+-˨�DT��<׭U*�|���5�ZYx����A�*��j(�Vg�f?e1Ϭ���K��<���D�#T�I:�e�,eq�*�k`��AJ���+x��K
G��g�(&�x��E�Эt�*Eʧgׄj�.�+b	�t��-T�$I
na��L������0�|����Ak�;���Q<q;��|Zv�1�{��^�/z˧@"$:�a\�
�)�k�ĳ��ۍ�Q6�V�j�4�S��,���@;�������ۻ���0S|�7TZ<u�~����q�S�3g����R5]_�Qr/#Sg�IpR��l�0��9��;r�7���є����0�o�.J��<et:w��t�
<� d��6-$J]�<L�&����R�S^aR�^>	,JՏ|kR�4�(��T��f��T�{��!��uƙ'���gN�\Ӥ%ɕ[y�[��%S>:�
T��mn�)H3wv�g	$�+Q�q_r#����%E�O�e�|��Nx4��	!l��A�G�ڦWU����վeǫL!5l����L5��h�h3J�����bQ����l�1���o��:�+����� 9-�tv�5�IN�i�qep�ΐ���=������h/hG�i��Abp#T97S�Fǒ";>4A����5|��Mb�h�x�>δ,�3Ɣ 걁`'ke���<B��fe���`��V��8����/y���T��|�mݥp�7Ni!���g�Ϝ|DVș8'�h�ͫViGN�^L�Ҏ8���lØ��Қ`�uФd�XiF��/Q�o����Q��e&�N�A��x��|�� 6m�+����q�ش�(��5iZl�Vs̷�7�Ǜ�#�%�{���8�q6��P���ҭд�����M�4��y�t�0`��#�*]bc�D���1� �֦ �A3��Ҹ�8��
����@Q�����?t>oB�%��"jI�j�h���|���CV�?�|��;���X6k[F5ޒ��+������_�,�d��Q�1 �H0����mT�7PXG_.��6�ĚQ=�#l>	R?�*wTx|<�7���G�r�Gj�7��l�m4�
h���M�Q�!���_pzf[�dT�7`Ф��^��T�wĳ�&�[���% s]�@�¦iA�ky�h�T�Ia����C�~�iyi�?|:\�|�;�����_h�VX�e0�˂R+S��.��XR?S�!����������쉔O���\Nrq���	�	p���F���iy�l����1����X鋜&1J�s�HC;�I` ��.��x-�8�a㥹���n��Q�\VpQ�$*siM�&�\ΘϠ�Œ��r�:F<���n�R/� R�s[�/�3�X��WF��^_���5���}v��ys���mv?>\�'6�Ejjbìm���&�6p�}��}�ay�T��r
ReS�i� ��"�%� ���]Ճ}���Ӎr��j>F��p��t7yA��ך5��6��IK�-\�t��ā��pҝ��<�g[(�:j�r��p,� ���>{����bɖ�\����}tS��TPA;��_���o����C/    ��ePα]Z���dȦ�0���b-g�_�h�Ǭ�c��f���-O���D�x@���tUݶm#HJ^���g��^E7m]����O;T������,�j��KT@���iP�z��|6���z��D�Bm!�q��ңJ�dp!3�SI�T�vC2�ٜD�״���RM9m���(bc(�-��J��IE¬���R+躆.�@�2���6�pG����o�Z�l��/A�ʛ	Ȟ����k�B���%M&
m�y�Z(���g-?�':���ܒ����w���n�G���B-T+.Ǭ6���F�X�<%Y������LTg>.��!�	ʷ��o�}������뻷���������O����`���\�u�����������_��%��ۻ������+�ˀ|N�b�w����ܸo>]����=����9���f\��r��h?<}�Vc�@5;�4��~��$�)1��J畍������Y�ah�+�:�|��7+�~�F��.�Nï��`�n;�o�ui-2���l�u��3E���� ��-�tE}���B�4�u��}:�F�Ͱ�:����/�հ$>i�|�ͻ��<6<��o_)�B�SI>z��!w��m��}>�+g_��ܗ	��aqP�Y
ч����gI�������⋧3��}������ʠ��}����%Ab���z�d���V��ܙ����ƘSu�r�'#Q;Ɨ��ew2'������8cF?��h=n>�������|\}��y��C��j���m��S�a�� �R�lxA�k�N�r�AJ�l;Vtrټ��x �H(42d������g�����r��/��42��yyBV��[�q%�c�MI�����Y�v\����e��B�]%�L���M
��N�K���Bw-���z�!{�B&;��h���M{$�q���ǰ��.� ����y7oJc�R�8�<��{K*	4˝��9���rRK[�h�?G�f�9��-_�Av�ΓJZ+6��-�ΥwT�Y'U��ܞܹ��j�&���yd���u|�MU���~�a��u^@P�Fg�z�EE>�uA>=P'W=�4�hSKOmQB�0��I|���K��b��X���Ĩ\�-��&��4`>�VxFG��+j[�2Q��Ɂ����S�7��
$[J�1��-NF���<��!��d����T�6�=��v%G�~��������4���"��B	%}&z~v��R��) ����J,Ir ݗ���9f�[�\��%^K*�"�TW�O���������y�Pq�ٶv^ �¸�]�V#��G��ϟ��N^�n���N�u��r+�3~�Կȕ�1�\���^�ژF��SS�w��7�T�(������9R?S3Oa������9R����Sm�U>�Έf�
��0�R���]*�HK�E�%��*[rЈ,/�[H$�2�n�g�ۛ��n��M2J���WB�0�%ws���ܑ������1�̞�)=��x�%��s��-��B�zn'[�~s����Ëg���W�t̜��g�����<���Fy�p/S�����<O�E�����h�pY�B/s��O�uc��#�p�;�-VՖ*�v�S����B<R�0$��H�k	�Ei
�.5���wh-J�A��x���6lޘ���4��@����$�>�eX���B�|�����C�Ijy�~Ͽu�Z��}�x��hI*s�d�C�-�"u9]{ҽ���Ub�J�r������MR[�ߤZ�X�$,剣���۴��p�j�"7�t/���vSZ*`;����An�@��*��
tmo�AKUl�?M���ݥ"u1h�h �|)h����?��p)h���B��B���(��)�8�T��d!5.�|�
�lllWYHeK-�J�Λ��T�t��D�Th�� �T��[8���bHUJYi�D��&����pu?���J")�n�ۚD�Q�\�
���H���;��y��Oe'�P޸�����p���՟�����-���/հ��:=\�4�����K���;U̖/s��x.ռ�ziep��&|l�9�t���,JH8Q-8/�4#���}!��熲��!/9kJ��Ma�(�Z��b�X+qE0 ɸ�W�n�}}G�?��|�9?�n{��9����������������os��a�H�V ߊ;E��ͲN .~H^�dsq����JʂB��?�s�����?�
'?��yo�#�	�!�o�l�{x����
�Ɗ��3|���qُ�sN`I��>�����L;�
ǿ���/�_8��0�g�KL,�:�.R�ի�ʣӮk,���͗����S����2��z���s��ϟ�@�R/���y��vin������6E�g��Z��:iKP�Ccr�s��T��A���b7�Pa����y�T�Bcs�������=�?r�M��Xk��S� ���I^ѝ�{��S�� �LP�2��1R-��Wi��/���e�ĭ퐵]:i$�˙FA��4�'��:�E�5bQ-�N��a4P���]� b���-�j?'Mj��t�7�w7w��TL�������V���������@0����]��O�J�,��6��(h���Umh��=���4T�i�?fO���F��'� $�'5�7ܞ߁4��g׸�.2J��4Ywq޺W��@�Bi<w����1�~��WY�+��)�Q^�uӽ� &���̇dP���
tM�����������m#|��M�2��҅����]�崎c 6�k��$EI-5M� WU��(Q� y�U�oI�$�DB�)Ͳ>D�,��0�ߪ@�E��V;26����ت%0�f װX���jR�M����$D��aH-g�øFv�H|$yl��Qk8��"�k��w�Eo8��><>N^��dh�!��L�Jɮ?�h���ӄ���OJ��奰��MAU�o�+\ߑ|}ww{�_y����`\T����xxo`��|����8tv�V�r*C,�C�o �<��X���N�A���1�����i�%���NwZ�^�Y��>a�[��O^����~��x'��O����t��v�^~[���C{Gw�o�Ư���s��	�jU<]���$�Ѳ\�n��<M=�(�����|òe�ڈҒd�:u�h�^W�I�Ż�(m��D�g*$�ק��a��&W�l�=k��eV#�հ�J��_g��#9d4���O�_�ʼ�w?���S ޤ�	��T��*�������4���^��{�cp�z��/t�@�����w~�Hz�Cp���M�j�z6�'B��FY��m��l�:����4�eY��V�I
�^��,I��}&�t����7˴ߎ\�%[6!��Ts�����X��-�w�{�u:J_׶�I��b�D��0Nk	C��-hc$L�<�X�jv�,8���u]�����i(_��C-`�c��N�����Eo5B}�/wg��d��h�/�QZ��u*Ai2=&���:�ﴴ��n[�Gn�Α�9=��NU_4�^F� �O/���Y8F���J�����L�Bb�4�_�7	��Cn�X����4"q%	]=7"yPGOF����d)�L=A������O?��}<������_�Tf�xdxx4��W0\�7f���W��;���hۖ&�)���挒$R$P�ɕ�t�v&�ԉ��󄈪�f�C��b�A�s:ڡ��
Z�M���`�WD�{�V��B���[�ĩ�Fg�Uq��Wa17赼�41��IED뵼�47ΑWU��z-�#-���g!)���}�ݣ^7Fџ����V�%�a�׺> Mm>gSk�2���>�SX�o`i�T�S������*s�`�%�+'�Hێ|�]��-�E�v�+��Y�Y�:��4�t��a��2�c�}���|"}�>��ԺF��_����}MN�PH�x���|��HYڸ[��(��@{ٵ�33T'�J����}���,�,�I��$%�J5�s�}8��J�Z����/�),�[^��x�>i���Z�GZD�w��ku霴�TAUx��M'�+�����    +�(-4�jUd��i^�B�S���Q7H�\��e��y���,��k`ӌ��^YVXk��U&��,k�K���A��AQk����7���o�"�7n�5����(��-��)؉݋�p<�y�޹c����-{�.l:�;�t����������8ׯ���[���L���]�J��M����.le�fc�=oo؅�����g;�w�]��Ȯ`�Z������nt|a+#��ػ륱��u��0��"�&H�GMX�򵓯7��iѨ��Q�x���� ����|�ҺY.�I33��܍�Vѱ^+[G@nۖ�A������J�iN�Йx�d���V�Q��,_~��o��aqg� �=���r��R�mm`��[�HM���C�!9�U�����i����)��15�.u�^D�Yϧ��ݴ�"�i
a�� i=�i��u��?R
��H���2PYZ��^�&����ϯ,Z;��3}�FI;��~���'�ya���Pm��x� �JP�k��?��&i��=6�B��+IF�_�u&Vi�,_�u����^4�;���G{��Yu�}o��3����ܫ���$�hR��3U�y����N�}����F�rpԾ`D/��4r��4��0�\���������-�OR�~}w��~h{�O��L�eq	�~�kԅ��*S���|<�x�t���|wx��_?��6��RͩJ�e~mOq������۷�Z�=�~']�0QKs�a�Wh����4`H#�`/*�X�#�&�R���dR�g���q�40 d`lj�k�4 T�h�}kgC#�F���оV�H�/s��K�J�B����WӮ#4��R�9�a>ĒwN�]9'��Kh����k|���.��J�X���^�˗��瓝�̙�̗A����6=�)�ܤ�[���e�i�W̎��;��RE�f�'R�@�k-�iK���Er$g���|���-N=q��l�N2�E2�Fu4�9�i{B�T/C�ܣ���Q!/��E�Ӟ$��:����D�y˃N���ԕ2�?�Y��-��[���ÿ�?>�����̉M�Jjl�'E�:����C_}�g��/�=�Z������L��J�}����7���*Hk@�`P�_=�T�)yz����,��A�9S��|;@Z
~��.-Q��Y$�	5C�}���H�s:�i`�ya�}��- ܙ��;�O�'E��a����E��|�r�������,Y뻄5�r��v|^X+`�����J�d��vX��@�慛��:	�Ԝ��{�\�(a#eC���s�N-�0�6)���	k�T۳�炍��ԙs� �6IX�Y���X�4r���$<���������7"�g�q�F �X����Sh�Ⱂ���Q�aypj��D@��Zw/T��N>�{'�����q!)jİ�����6*jY��c�dR�'��>d���3�([G%�؍fYG��� p�~Ib���C�YB^K�H��� ������g�����Z����]I�	K]_U9����74������?��ϻ�G,�����7ǿ��χ�?�oz��oѕ��x#�>n3�n;z��&�ؘ��:VoGW���(=38j7q�d�U��U^� �j����o�^�x��^�gY����]&�!��3d\�>��.W:����6����hL�>!��:G������х�\ �54��	Z�p��r�O�82�p�FO0���Bf���Rsؒ#�H�K������]�u����㠭����.w٢�n��J�J�М%�e���!��)�K�@Tɷ�l�d��T��&����27��T��P�n�t]�v5<�Z�Tg�P����=�_s݇���A�������9o?��������:3	�^���t������X��@�w�3��wv�b���KV��g��Z�t+�B�s��\�ֶP󉆞�X�!m]\�穄9{kf�ؽ�@���<gܤ���T�T�k�qD��ާ̄���op}G�뻻ۻ������^ I�_��>��y��-����H��7ؖF��N&Q'��-MMR>o����jݮ�0����K(6�X)�������̉yWyH<¡�a�=�~1��$�$5v���%S�]�ny�pV�83|�E�V��}��yvs>R}��ww>��ki0 Y74/z-U>pgt:�^���k��������ܵ���XJ�OZ� ��mjk���ZQgv��nK4ى�n^K[@��x瞂��f�:��g.A���R�g��ta.浴
��n4���\=ih�l��l��7R�g�|H3${I�H�>\`�0��-����T�^�}�7�,8�i@���0���ϸ�{/q���p?�.��M���p=8w峷<
���/9�B#��x�7��G�5���z
)^�M������d ��p�����n&c�����d@�z�{m��>ҵ���N"R 6��Gq3(QQO��CQE�ko�d��Ɛ�������u���ˍ���������lG(!�P�"r�8�$�,�+���$IB��
�r��ڦ0�ȉ}��b��j���>*�L�D��t��QNZ(�5@c���Z�qu+�-(Th��Ck[���Z�|��[�w
�8�Tp�Y(^`8���ڡ�[�gy��S��-{�{H�"��sM�My7Q`C�VC�+[���f)�]瞎)ͻ;+i-)���#-����{l�띓����
�L����3ٍH�i�3�W|h���KXn����hFlx�)���H�:C���D�"> �@ 6j��sB�D���4�r��c'��op*	����e�pS���ss�.�����J���;{?����5��o�Ƶ���B�k�N����n~>=75�l�4��GD��Nb���αQb��Y��K�]:��AP�G�K!��%6����a]c'��SEL�;�K	��zt�Azi#!���}�?/m�<0-��?���9��<;ܸ"�b�˙^�<
����F`���5/��r�K��"]����N�7�K��^ZN�H+ZW9�wۆ��BIk��n����]|{饡̯C7��4��?������4��}�
7"y�M}z?ڑ�$T~�'H���z�釛��Ǎ{��mȿ��R�"<2<<:�B����n�S�l� �:��57:�i���4�T,��}؉ �"��Y|�v"H�ܵ*�b��m1
�i�2��tʛ�;SZm��3����%��A��;y��<'r#E85��웰�7�zQ����0�#�=>�R�"�����lW#�Y�X؜�E�6��mbaN�# �W����x$�X��N���7Ñ(�?�K���px�s�a����c�CGR�2;��6,���4m��d�lF4��M�9�>i���]2-39;��4U?��ߚ��-�-M40�E�Ӄum�6!@��F�`�!8�@��tޕ+?њ�������}��^S#2�|	�h:��Ԡc�4d����)���S�M]3ȏ���v]��
�� R���K�m��[%�0��XhZ��X��]%�0*��Н/�c��L�:ݷ)[ڗt����V�,�,��Z�X�dɻ�X�ؘ�MX1ن�5�kHOAj[]�mF���*MM��"��6��Ӂƥ��V//�r���%�g5���/K�,��4��\�[$I�sQL���n�Q�"��7+�_���eG���	Ɣ�6U6n	�X V<�HY��5P����.�"�(�M�!�٘EjS�?'��k$u+z�3�p�[3ZEU}�Y�n�h�V1\b�JՊ���c9vg+�k&!=�s�M�f�j���^�p��k�� pm�u#�;p8�4f)�n�/Z_b�Z��I�KvF%�`�j�8�R�l^��Qՠ�;�:z�
ꖀ�\�Q����)�|�*��0���D8u�5R]O�R&���G
�@*.�6�dT}z��+��3ɛ��&;p�Ԕn����z;cM��v'hP�.[���ԟ�n���3���P�]�K�K��R:���J�H�1г�Yw�YR��Ԧ��ֲRS�<ށ��[���%7�f�0�v%~�	�Y�v�����n�s==>�=��R�/H�7 m    .v�s��V�e\a���!��6�V+_b�ж�B	34���m3��鞹��$E"�f�|.8Q��JөW�z7-Vx�x��L��Y}��躀��ǽ�r8q�6{�{,���V������dj�a��T�Y\ɂ�le�x
�<{7ԅN�������^b������W�+���� ��z��z�[���7��*���H���\v��#XN���,�y�:d���C7t�}��u�6�jC� �dW���9c,��oKN�BK�f�<~v�x���S�Eq�Ƈ�������e[�a�uR5i��� 9&�9���G3Ѯ&��>�E�۫A2��S��n-�H� 4�T������oͺ��C|*_�z��������)��W�
F��	��W�
V��%p�$zo ��wTKz5��f^������W��\D��W�債��©�T!H{	���#.^��H�K�������ב�󵲘��=���� m/�=�jM~��z0Q�N������<%�(�^~������q7Ei�+�4��o=J{�,�"M�=î�F�F��_*�S�NQK��b37��S�f�ݶI���Y.z3�lƽ�����'����XW���PO��@/_�K�r1�W�<�_ϡ i�
@-�MzE�`�W@T���-�o �I?�����R��0{�w��O*���@�e�#??R]��1I�1��m▛��Dc�HF�9�q��k��I�0** ��N���&�����m�|����t����u�E�:�^Q�6ԲUi_���ڊW��G=k������Y�>��c^�$0����ύ�I�>��P�U��'y�"AAAR�n�~D�K�|��,�'܏�C�tj�a+��6v �:
�I��� ��w�-��~l�'�����_����O�����?�+�H��7	��Vt�8�0/�K���]�\�1�Ɣ�:7	�BV�x.݂P�:�1՛�Tgv�v�ܒ��4]VԄ�afg4(1(�Ҫ�9ۅ�%u�V!�l�P+���F}�τ�9�3&�伺��|����� �٨W�G�Q����0 u���x����+0F�F>�n�8��ݟ����
�i��5	�[��	��*�Y�/�ڊ։������!�
5y]�℄{�*�1Ɏ'�/0w^'��q�6�݀�wd֜�n_^�2G�Kiۨ��i�0�hg�ԟ�l�r��-ga�bYn,�����M� MoxAK����"���O7�@w�a�+DaKJ��S��+��v�~����N�M�^Aj���g��9�:X�а �6�f�OW/���Q�16?�ڗԨƖ���(��6�����m�ۚ�&����CW�<O�y��W�qX��q��JСX9���F�/�M���%��-��V�bW�C��7����y��~������ڤu�/����f�%�o!�K�v�
��0�����gडAM'c��:�U$�D �(�˖jw!I���o'�p�4U�g�QW��,�����v� _C)%�S�kUD7��T�F�6���%��{J�|����c��VԷ�hL$c�������4��'t���AAU�����;���oFp��ߎӋ*�$���-���ݱ�0�4����;����������]�����W��?������w|/�>�H?��s�?���KL�8pY���|ۑO(�u�{-�=�ݺױ�����=����Ç�?o?����݇�_�]_�����.NwapQ��_4�s��OL*�r��`�J4em&e4T���N]�w��{�58#/޻����/��-(��ݱ�����C�*21<te���U��8�%���-"���~<�>�O];�q��3�H�����Ȗa]\����h�Q�L��JZj���?�P�sЂ�En�~�I��u%l>S��i��u4U�KX_�f�%y_�m���p��Q}���WΌ��V����Ј���E�h�t�҂PZm~����5��L���Iy/����N�v�@����k�{��"g��_�kz'i�)�������w���J*|���N^�H#G���S��d)���tY_�;E�Nȭŋ��青|'OIW�o���+���@�5������:y-��!e�����w�i��?�s���՟N%u=��Ɨ�I��&,�~V�[E��n8���K���r�+����CoC�i��D�Wu�+��2��q�R-�hi��J$�6#��殪�6O�G��= ,U����<<�f������%�Re�U{�C���g�wr=����e+jkB�3s��!���=O���Eg�.3e��$�
*R��ɲ:�e0O˒�5�Ա�z�MP��aNT��a���&�������?����ۻ�u�A�2Q�d5ݗQ=�D{�_�d7�'[7�lBIBA��-�QQ"8�s�^�M�*��@v�iYpüH���0'�K��j���[2FB8
h��⋷��\���c�gV`ɮ���*��Ӹ&���B?Ṣ��ڗ��E����Yrn����kןT����5~�6_P��~�A�9ظ����ְk������Xw���n���Oi��o^ʜ�K��LT���e�������cU��
�|��VHFjO�r��S�+άŭԠ6ѾM-Sa��z��pZO�.�J]J礼��jMV�G#ى*������jdϽ�x|^�'VlCIv�G)W-ѡ�炯o�59��&����]�Y� �h�xG���0ѓ8x㕮9�l]
��%���*��T.�HG�c�8����1����9�z�яi�e�� ��2E�����$QCl�VA@d3D�>�s�$��p��|+�������k'�q�p��o� ��/���+���:r��^��
"��e^�#wS�h����k�|:WB�|,p��.���8��~:��@������B�*�HJ�_�aP��!�� ����d�?G��j�"m�'��;NxH?�f�����j���ۇ?܊7d'\==��YMɚ�� `ݾũ:M��s�Z�m����&Z2��!��`C����٦�/!�K�i�ǉ"��o���XBP1�)�rR�|>jE����>����ޟ��>�P�)9��u���𶄠��f_����A��n��.m���*.L*�0Q�C~���]�okd�"i)���h)�X�|<�Tĺ�6Q�tez���JcÆ�i\���b`ZB�++ \R�� g�0��^���ն4��@xr�����t�ۺ�M	H�@�T�]�^W��Wĕ��}�7����fQ��������c?A���@��x�����Z}U'� Q8g�8'cL��4�BRhR�od�7鞄'�a��I�����}� Z4"Q�����id�}�ۛ��n��M2J�z�T[F6Y���C�|>�mZ��8Ւ��`B*���<���Tv�mE������Z������9��֤��뱵@B	�u���A�1�&��I%��:�	�I�I�$�}T8^,71�2�7�i�-�o�յ��%(�Yhy���ȶܵ�BM(�?t&��B��N�&x�]X��4�Xs��?@5߿���<\=�>[�ZlBT�`�(�DA����$���]A3G�0�/�xW�tm��Q� �g�.�5������55MLB��[�b',Hs�M�(������Q�bS(+3�	�g���F�� K��[�B�:�!?��<<>6�l��I�$�t>5����d�/��5��d���Y��۶=A$�u_$(I�����Evg��0�~G��_����M��n���H�Y�#�ID	����Y��x�v߭�h�!	\�,�&�x~�H�cq�1ʊ�����QA�#_ӵ\�4a�|Uy̾n�T�J�Ó;�]�*�
��x��u*�n'+(h�~v�E ��
=Ѵ2g7��yeٝ�M����*�B7Y_>>{3�a�l��b��6J���v�PIBp�e��O�f -o9�~U�h�2����O�՗/u���8��-E ��i����6�>��R�^��wk����@*E�%�O��ﮮ�~���ۛ���L᫫    o���!"㭲vE[��cףg�T�H	�*>��Ù�+��tS]��;��!�.袠��?Y���%I���c��1I}n�%'��8��L�?���TE'�6����Tܩ �z�G��Ϳ74I;\Me��q��ʡ��ѣ�pVB8��qv~�7��D�SW�@:÷���`����e�Y��pP�QFV��&�}2v�d�� �Kd��M!
��ڤ��+�耉�쩦2H��fĦ�ݨT�H�$�n�n��Q����-u��X���$�<q��w�OPB���C��+I����*,!(�ڪ7�Q)p94�qnXX�!���\rA9Z��%Tx,ѫ�c+�R��� N@w?vS��#���Co4��z#訬�#�;���.�(�Nd7Uف�m�J�@۹��̀��#�G�K��>פ�x�,�j}(y!�E�o)�Ȟx/17n�[B��IA�ˑ(����Α��ŏS>I0�cS�����?hI�'YjtL�|�7Vl��[B��Xq�p�p���Y�� HUm��	���p������q>ʵ�˯�U����-��b��>�V
R��P��v��K�N�5�
����n���,�ǌ���G�i��H�ٶa�j�H�%��fQ�hAv����E[}N��|8u>�5f��$�L\obk^ߕ�:�UyF�^%מ�~[-|���k��5A�Xǅԅ�Q���=ʖ�]�M��pgU������fyemыd]�P��O�+YIg雍]|�	�#�S��Ԍ˻%�	D����O��H�������!��`��*���414��Sٞ�6I�)��[�a��6{�����qs��%D�X�4iW��o��]���)>��a}L�l�f�w�DS��Mbh��`�+��hW�e4J7�o�P`�4�(���%�=U���t�n֧TnǑ.��ّ�����q�?N���ÁÌ+����K>D��и�n`�̓`w�>�����t��6���E"3����pL2��ƥt�
���
jK=���<7��̸�n@�~0+��c�ޤ��3���I�����3Y�^�(ՙ�����Aƛ5����jׅ!7��j�@mq����ψ������z�Ң�"��!�d��'�3Nv<���۰�1s��1�X'����\7�k�%XV 4բ����|>��n�m��4��?s�9L�C/D�̆�#I�@=�t���|�1�閛��ț�i�͇rۭX�4��4������@�|���&�3U���p�b�Div�C:��v_�Ѥ�F����a."��U]��I������Q"p
��["�K�^X�$���(�����3Z7ѫ��$Q]��}��8#I�q�
3w�D���|��p�	'U��(S�(,���ͷ�ן�;����7n���w��w7�G�h��~$���l�\�6�6��4�0�V�t���i�0��o}#�:M6��{x>�f\�faC�&�챺J�R(��Ⱦ��3\O#I�H��Ҷw\a7E�Ęx�~'�3.����l��u�xtk���bk,Qzk<�о����[10{�/Q@ {���,�lu��Π*D1F_���@7�T���^��yr�q-OƘf �.n�߼�CX�]L��2xS>?�Lh�y+!���E���ŃDd}�[D�+���Q5x{�z��q<%ެ��|��i����fh�����oC��"7�4(?X�m�D�t����;H�$"wY���t��ZA�J���F"����� Z�h(g��t&D(ѱe��ID��/��2�D�ԧ� J�A�c�2��/ N�K��Y�r��66DI���Y�<��$�6������Z@�Ȧɞ{*�3B�F>?Z5]�6�
K9���n��Prp�3��=-'!��!6:D,����\`gx	�����R]�{����S*M�,��A�iaH�!L3��B�z�YNꖟh��� �f4I�9��8w���A���t�{Ƅ����I�0j��Z��*��X�\�C}ۆ��И7�$Y�P>>����?-�(!u�3�Q�9���٧r5�
7��j-Xh�ZT�"�y�ͧ��7�xp5��x����O��>�UƧ��O��Z�y}��뻷�ww�whf �rZ�Z� ����9)�5�V��HCK��ǵ��k��B.�����{��s���M-�,52��e_�:�j���-*����Y-�4p�
�>(�7q{�XA'�;�f%�c��r:#����.dg����{�p����tS=�.�>��ҁ�JS�~�8���9I�%�O�M��CAG��.k�.����s���CvA��@��hv�!��.J��7��o6	: �> ݏ+`u�輲���k�@t<v7=�!�x���H�^��l��NZ��#jb���Ժ0ӥt>�2�)9�.�L�|+b)� 	�C֜n�tg�6�r��F�]v����\Aڄ{��!8�
g�֬�%��Yg?��#;�P5L���2CF ͉�57�?�,�ܰ�Cٸq��d"��xŸD��D2�>N=����Q��g��t(鸁1��}������h|�e邤�|��}|qB��"#��;�L�B�t����Z��tN:U+��y�Iǆܙ.�
g%�l0}��:�o�tqsN�!�u�PJ�D�Y߅�p���V�fVOS��ߺ `��Z�ʰ�c�`;���ӝɒ��Q' ��3R���G�*���ف�zg��|g9���4��*��8��_
J�\��G��zv�'fn�rF:����\�g�~�ځ|��s �
:��ѱ+߅W�RugO����W�MU;{��^'�(&I)>����ǻ�돇�w����_�����z�qI�G���AQ�e�7�����������#�\뵤I<�.\��*\M�!�]9o%�M*�r� �"���g��[�9AG�ґz���y�w��	�z���<L]�#�]V���Y�6u[�ۇ� ����̭�ʛ
��i,�ݢ�^�fz�W>�{�I1��i&��b�鬿�8�TG*�,�>���
:�A���日I�#B��"����$
0]�����!F���������?��옼�|��31[�|Dʊ-�7���?�����x�?	^���'���W�ZlA�p��=�z��������C�$IG*W�B�D-�3u�/�f�kz��R�⫈V�%�S�}�#::����<W�9I�x�K�]6y�E�M
�D�ʀ�����.��I?=Hl��1t����$��"(��$�.S*�����/��$m���?�n�_�$�3���� I�����ӧ�J�����R^!�Za�<I���	]b���g�F��/K7Q�C��b�#ښ���)Yv���BJ�.��m�b\h-�,�1�؃��H:a���m�~Ae�܀A�4u���4�I:G�g�ٶ�C	���
�:��+�H-Mz�R�>d75<.�D��3 �$��(��d�t�'M9Ӆ!3F�Y������^���3Ǌ;�og�~�������*i%���}|$��c����B�N@��t�MS<08�|j\>3;b�4/a��]�껿J��Awl*`�n�`�nw|-C��x`��v<U\_�'X���o<}��׽�L�����6ꆉ`�֥1�ٝ�s��r�k�֥9�B��/X�s��ౡ^��N�P#���"��t@M*!�	�¸H6qUP�o@���Z����3#�O�Q��
�Tˬ��~�����#��㇡LD�e�����vv �H5��6#@(��)�3����#�q5�u�6�FnH.��A-7�+Z�_?E��n1� A����qm�I×Ygqľ�4BI��h*�(!\�qJ�VD�֤�A�Y�aW����2{qY?Ŋ*�mRpRQ3�aI��ढ�.��no��Ta"]G:�s+��C�vt�l�c�89�H����@ABM�u�n���%�#'�����������_�$Gb���������EԔT+�I8��7�J�
�0��M���S� ��߿�}�o��0\�i���O�$����jA�X���RM�Ԛt� �;��_��W�    �B�L�\�j���OR_Z�CcA<�K�Z�h��u={�p�QE�#�d���`T�8@���VM�6C Fe�G�c֟�7�B����0�ΆQ]#�p���ߡm�s0>bP�@�7_��0�}9ɹ����2U+>�`>���ڀ�ruP���,�����V��5剛e$�upH�.�|���[lM�b�0���1�Z�0s5��P�.9Ւ5�?�Q�5���w�[^I#%� ��'R�S�Z�a�ŅY���d�o{us����-�[mpez�z@e�ہ ��0������A ����G�N�vb�U�G�Ҁ � ����� ͋�ơ�<�褽q\��Ǡ	��
Q��c������%S�' Jˀ�ք.M@���=�
}�M-��k�*��G���SFO.��}�H���=d�� !y�I�è�(�u�hzR"L����3NZ�Ŧ��1���ݷ��w�-sW��iS�H�@��1�o�����뛼�?�>fG�p��?~�x������:����]]��?�ivv��WM���|��o~+߀�d<�ἆ7 ��鬤�hI�86Cr�r�>A�*���e��(Woﯟ^��F)pd��=��m6���L(mz�u!�JE�A�n������LH�4�㕷���ii��q	{�D��F�)������ItӪ�9�NKs��(��,g���&RR������Ue���I!���9�%��!J��/�����@�Z�.��:%�N���%I�0z8:�%�MT��	�h��.j؝������!9�l��]�mtfj'�Ӛ5����ҡ������� v�:J����3A�����=8;]�`MT���a�$IGߕ���Z�e��r���ᬑt��tB���
j�DM;��Ct �,i���s�)EUw��-J�@�����Kg���~
���v6:@j!��y��ek��M��Qry�Ǥ���M��%R�R��S-�m���pK�:J�@e��QU�o�x>Ml0��o�fS}�u�UJ~k�����Y> *���e��z�W�y�)�ϥ�*$,Q0�s����y���
�5����E~�$$R	�w�I���j��pw�$�B9Xf��ִ��9-HPS�8O@oLbJKc�5�Qm�5\�b�Ƅ��nT;@dI@v\���F��G:��]��q��#p9V9pnT\{�s�!bY�nTrKt<������U��,��t1<Í�t�t���B�5jI���q�J{83L�������ف�<����⹗]��]s���p�1-�L?��D4���J�a��n��9�&��W�h>d�Ҏp����m^Z���K�|��4DYݏ��ҀX��E�����[��.��K�ae��.�;/�F�C�9c=�I�a���]��xi,,�-��c��v��㵊������FRq��� mU�f<�g�(y�v��a��q���tխB�B����M�.F�� U=R����.HUO��C/��A�z�!U=e�B��-HeN����#���,�|��.J��xb��]|�Q*}gyphs/]���U�AyEQZ�x`US�]���!%�YӅ���8��ׇ��8JW!u��Gi_ӛ>tq��yt1x�Ei)(��)���)�����O��Gh3[�%S>?��|Jj~dKV�p.�¶T\���;��~o������t#�/a�|������0@���ڨ����2�2��O�w�\y�H(71���]�L�d�AT4<�����?��|���w��������f�mh��R*� (���d����@��&y�9�����k��i����H7��)[���V@�%�ˑ�_��MHa�����_]>\�ݟ�>W WOO�g֩>�2#-/+�`u���"����XQ��@$>^b���+D�)�R��A�R���l��#2,P)�Ӫzg�J4�yw�Sh;z h����?����|+�(��iX�~�PB����JN>?r#�[
%��Ǽ������i�FR�5��$��v�� ��P�}ã��p(�m��he{e���*:�Pv�����ڴ�Gk��=�,���pт� �R���pӾ�4(��B��B�	r@);j�d���O��Z�=�y���!�El���5�a����j�$uvR�62��
��������ǅ��8��P �f�ȖJ!�D>�P�T���8��d�ܚ�5���$w�$�zM���HmY�oF�?�6	�n�ٖ6� �&&ˋ�.kD0՘ܨ�r���J��1�'�
��~�N�)㛎�-���TSrv��Ζ���T���+Y�5�cx�'V��@}�ot�u�|>�����p�^޿�?���6�ƛ�O�l��A����F�<���n�oS\Ķ��*U9%	��
����l(��CZP�Z�ͰP�\4�|��!�<RW��s'7B�t�3	u38+�!u5�F�tKL�0N(�y�%:2���o���d� ��F�Q��D�.��gH�7�?~<\]�p�p��7�����&Dљ�>���,��^,�M���w4��{����i�E���?��n�������g���W���<�כ�964�[ɼ��������KHO�ՃN�v\3�������q� ����Z�4=ߍk8��k���%�A �H��Y�;2.��c�R>�j�6�u\�����0��Qo^�$a"�عOfO�]r��?��uߺ#Ǎ��[�z���-x�i[�3cِ�X`QV��>#u�m��<�aDf�2�ٕ�J� {kI�/�d��E��W98lΏg6��h���%-����Hӳ��v�������т%SG8����z��n`�(�?C�9x�� �P��<u��������o�C�q �������<=�>�%[uB� Tr:���v��n_��`1R�d���m,xOBO��� �EK>�����B����z�&_�责%�`��bB!���T��Z���P�$8��V����� g�?�|��?�D���H�U�m1��1���"��F�)f҅\�n��~�?:w� ��7f[�m��%w��/ր����O�n1���[-�h�I�[̶㿵�VX���cm���*l爎c���RE����c���i��p��it�im-�8�����N������8���KF3Nj�CS�
�a;iӼ�vk�7���ǇE(h����ǥd��zZ�+̦O˧�Ϟ*s�kSC͔��M�����i���u
׶���Qh���a�s����:�u06��Ȧ �!W�@�Z���3B�:;A��m�3ag��5z�8 ���7=O#d-���j�&@�T�1Uo(nq
�����[��Q�h��Y��!r�E��Ǎ2
�W��/ ��珆g��Y5��烨3����n��μ�l�C:'8G�殈�L5;+�{Pθe����+/�>�SoX��/��
K�����5`ͷ�eJv���~�8�Bo����X��7���Y�7����A��"�c>t���ԣ���h*rE���@]��e4��ѕQ����-��W$E; 1
#+:��!l���8��b�����!z�&��=�~x��l�a5���
3!K�@8�-(�pB��{g���vH˟#�o�����(�=�ɵ\�#�d-eE��C�����r=�y	'|�m����*�^Z���jm�Gr<����Pw�$��RrN)�d�\;�� 8N�b���ץ%��n��~�$��h�� 2��ϵ�S�B�ѷ�u��g��f�'�B�uq�>� ,)��aX����{�y���`3�2�AT5XLn�p�,ÁD�a�ٛ�o�< �b�@n;��k�r����k4O���k궱K�9V
"�P��u�4$�>1���(-�p,�/�W���94C�=.�r��C�)A��G���O�\_�"[?��Y��k�-�}�~�u�0m!����ɽ��Y�Ս/
�/����`��~.!<������w�w�7/x�N�����vї� �.�n�Ȑo{�=�vY?��cӭ2�s:ތE�9*�,���N>^2$�    1�G�r���pĞ]��RA���0z��LB�`��:�����a &n��o�[�Ӑ�x�ug�2�s�2��C���K�{�����.G�IV�_����Vz�$`<��#����������<��dڵΦ^�?�?lv4��W߯�ٔܧm�f�l��=��-3U�7���AD��ќ��t��ɠYemF�b�����߾��D��K�=���1���ϥM}���f)ĭr�FҠ��qs�ӏ&�U7nnX,��j��qs+�s��n��z��XG�Fv̥<�H�]�]�x2V�E:6p�e�J�9}��<��75D��~Q�ٽH-'�W��12M�m�7�����X
�%R��Ƞ�ڀ �Ow�n� A�H8� ��Nt{?C��-�WN�*1C����Ph�aO�V7*������3�D�U����t�wD�?�p���f1a�Ɣ=��'�p��j�,�.��b"Y>�ػ��s�Ѓ��2� � �	�K�AP#�I�������������̣����K�1Yڜ�>�ij*~>g��}���@���\��'�A���x!Fn����V����0�zǴbú�'&�JO�"��#~hw��B	L ��S�-�
%�8�Q4%��W���8�'��.J������� ��pt�̘۲4\���h�����D`��9}�푌4��Pn7�~y��Ǉy$gm���q��Ȇ��|�2��1r�}���@�ڼ^?Tc����jl0��6��ˊg"0@dk�Tuţg3��H)����OF��0R=5qZǟ�6J��0��Z>���|�0t��@Zll�3)�.����,��xSat���4���9��,��A�s�� �
��&P�x�� �56m�	x������s�&��~�g�hd[r��3������M��R����?��'��\����V�Q��T'�V�B3؞���[R΍��q󝮾+2H
'bE�K�����&�<g	�;�y&P� ~�Z(.�a�'�F4C��0mI^Q}UKUH��*(�%r(TY�V�M��9��qq�:j�dy�3�@u��aà�{h�ʭ��#�Ѡ��77��?o��&���6ʕ��e���~����������~�d8?g&�_�h0���*	9HH^��
�c �������Ǐ�s}��~���_}w/�)N��ޓ�PDs�`Beߗ��_�����.�5��+���u�X#�r2��۾K�����grV�M{��ą ���h�x�|]0��C^���T4��L�$[��dr�0à���F����� "�ǒ�~ߔw �^`7�)�����di��M�#F�S�=�\�bZ8]�E��V��R��y��ScBq\�&8�@�̈:�9��L{�z+��l�O��9��s\�BSo
�{;�N�	����[[��*�]p�fI��^�&YV*���*��3Ы����=�>���������n����.�v�
�|�s!�9"�QҴ����{s�GqH^rH�"F��%$�rD�z]4_�5�CheR�%�Y�?�<�ұ���n�s<pG����wicѸ�ճ�iS��2��J{�)3Dr08�a���T&�ð��scMS%D$�f(���\\��%�)Z�4a��ʧ�_}y%���l�TU��\�H,#����ɡ�(��8ˠ %X�*Tf��OM:*��>}x�����������7�P�p�\�P@�����ͯ���"j!G$�׼X��^�Sǰ��z����%+�C` ��S0�b���L��I�(9�dg�7��W��W��l��A��g�ѨtS�^DOm�S@o$�jhӘ��]��)z'�=���߼�紗l�B����������p��S�c$�3�3��xIU��< ��9����)~ C6䛲�0� hY˝��q �&(W�t){@�Dp�~�;A�.��V�dʎ��&�L(Hn��%��9���se�q���:z��kM>�а�M��A�I�C��U�m8H� (��Y�r���8�e�Ԛ���׷�����W�Ǽhp	���� }�T��\uH� R/@(2拧��d�6?ZJ�Hp�:%9�8��A 3�^ײ�F,�#�]��P}T��]�U�x+7I��]�v��t���r���P'd,��u��4��T��G��5��DvdN�C�Z8}��`0y2�`�AP�a�����m����e���vI+�:�L�mҚ�H�]��.�h���'l�	ȷ���k)o���d�+辺�_Pi���j��)f`p9�7�O�t �C��M��\ӻN���ɂ"r�dC,S����{j���ʚ�RMA��(Q�rI�`t��'cI�nL�0���d,_��]�`���I�'�km*���U�̧��͒�*$�E
Q�^�(4��q�^�R?QW(���8Hf�Fd 4���Eb���vt.P�E�✎����$`���A2���g���8jQžvFV�}?�����)��.Y�c��N�r�=p�ȓ>�6�6��1$F�D���j*�����	9a(鷱8Gq�2�jY,�c��s�0R����MG0(���@Vdd��  J�SE����,��_��L�/O��:���a\}��׃��)}�q=���C(Y�NI.4�1��Bwrک玃��{�j3� 7�pz�T!-Re�0�uS�E��M`�+�^\O�&���M�)n�v�-c�hh�c�
Z(��%�9�d5z��{�D���
��(ү�%d94h�3���9���9	cx� ��~����9v���O<+a�f;���i���9�@TM��|���߼yvJT���#��0�l3;�߷}�ɑ�0�3�֥�6�5v5jULq��_��h�P�-�8k~�N5D������@h:���N���`���=�m��m6k��
�r�㲱98�,\2�s�K��@k�4Oz@�myy� ��T��{{V��s�J1�E%��D8��Ő!�¢�j��@T~M����F�J5��I��la�ժ�kU��%R�B2���Sm����e��Kg�z�[7!5���\�"��Ԗ�y��K=R�'o��N���7�jǱ5ߩ�N�9y�h�Cǲ.�ƶΩJ�"��
9-��gSP��̘C-���9�籙�!��A�1n��Qq4�֚STr��ݨ6M���f!�t��1}4<�h���'>w�-�E�SϠ�#7F�[`�sxs���6]�_w�z�]�����Ϗ�����?6N�����a=��h��C#���gnO,��h/�#�eAo2���\�u.��#�=�}�0Oa��'��?�}KB�;8IC��ˣ���I�97����0�T���m�����	E�8�@�����F�F�9���r�(m�A#s�	��D@A�x�)������p��qa�iK��C�$��L�`l/T��22p��sd��1��Q=�����_ܪn�'�l��X
#*�h�}��n��c^DT��n\!wA�`�7 ��*�3�����7����J���
�շ��`��G���!PϿ��٬F{mFk��25�U��#��9[��d�tD+D�4/�thnٌF�h�_�7p�h��JD[�:kn�p�v���S��e��"\}I���u8�>�L8�@Cs�e1mM���e ���ԕA���dYC��g�\u|�Iw���7u{6C���{�ϑ\��n��Y9��B�eǦ�ùǡ���p�}!�ah���`4c�гK0V1�A>��:���(��J:p	˱Е�j�ZT��S^'�c��i����W��\��DV�pU��� ��X��d��/�m��Hšl�5}��^dDp/����/������ݛ!*�heEcF�	8ӝ���7_��r(��ja.���Sb5G�б�q�Ѳ3bM��$������ՏW��a9�����@�T ��02[\�XǡR�{F/�M�hc}�9:���%��9
����{~��矯�*���~�>���_�t<`�L;ϱ#�-�2�Ne������Wo~z���B*2O�N�}��T,�����%#u�����
�^8���I�]��͌E��    K�ű��fF"`B�;p!;���u���|s���Wߗ���P��#�ɦ�����T��?�3y߽)�7;���acmy(\��3�����3︕P�B;|��W/��q�LЃ�a��g$[�yǕ;�E��ǌ��Wߖ�'8����;}���Bы�jk=�b���q��FQ�Ǳ��=A@��U��.�>AAJ��4�>3�Jaڦ�|�:�x?^�)�~��N {����X�13��Ţ�T<u�Ƕ�/�-O��4<5��`��W88#�tj4��-�I��>oc#9�^�y{6��>��U��?�D�)��Ė$R�>S��BՅ�$�쑿Ф߹���C��)a�$�ۧ���h�f�w鏆�[,<9�w�L7H��[U�2:p��)��4���̇B��T����c��	����j�^���=���Z�o�[��kyD����	���$IC�%��z^S?�d��F�傁�m���\�K@�F7ސ���_�Pf&���|f�Nq&
m�a��C��.$����Ƈ�ʊj�^̌��WFmJI/�;��t�K/�'�,�*�*�g�_w苐|f�<�T	>�_4|_JV9��Z�Lh���'�Y:��y�C7���0=s2�6���4|H�T�FX)3�0$ w:#p��@s>�n�*%�Έ����r��̎R14�M.iMX2�����j_IF�J���A$[�iK 2�Sυ��Ą;7��N����}�|�r�6�Y�SO+8m��*V�*KYl�l&g:FU���&��;��Q�� �LU�+nC $�rY�abG� ψ�k~����B��{rȑ&\�#/d��9\�E!q[��/B>z24͕G��c:\��Y�5G��O������,���������o�]�a|^����4�Ʋ?䉫E٪�h�It����2� /)̯��r �1�Lo[�-Ԫ�a;4�.��@�i|K����|v������EmHf �q��
�Wƀ�=���Ό`�������#&h���O�x :�x���:�_X�].A����z����2�G�+��/J緡i����[ƶ
�����_@Ji��;%J[26L�l����J��9�QY&3}��!w���#^�A7����9��^�j/��5%��a���S[.EЙ���onA���)��@n���_
�F35�SGK�:��鞇�[.ħE<�>7>n�_�=W	<n�xF�">n�|*�_����sf0�y|�� 33���1k��8G]��R�Yw=�g�9���K�uo���� f�H_���� kշ�m�`w���nw�=����}��:�Ϝ�0���:�-uڨX�ۖ���T!y��l�����s\��鈬�R�
<�gm��؏m��z֦�@Z-�w5��L��K��dfa(�|�د�?����{�u�[�p�f̙�ԣ�b̙Q,Z@^ъpf��lh8�ͬ�䮪�hf�>�*�z1g�f��3�~�/�P�Slŗ=#H�u��+F��.��ɢ�s�3ۄ��F�:��&w(0OV/��6ybo�l��v�@��g�>C�U-PFC� �nV�f�1]�0��d]�����X(L=���DkSTSO�"#" I�$�X��q�oQ)�Ί�����P�N�����!ATV@S�Y��)�4 "�R�#%n Y��o�@�"A#���� r[��Pm��E閌� h�E
�;�fm9��;u�%�= �ԀTs@2Z���b�2e4�Pf��:52*��?��*�oQ bEO"�B�����72=oB�`L�^�1=B��NTT���%���7��/Nf�,�z����2��ڙ
����F�J6k��Y���A�s�3:����˻X�8ƌ��)%t2����x��s2���0��|y���%�.�QDu��ZI��JN�x�uh˞��k<��v�`f\�[�	�=zp%c��h��l{��WW�LQ9SS�*#Yh ��&�rf*�c�l����L16�@��ph�����p NjT��r ��.��t��{�]���`���0oFy�G)��BU~n^�)�Tʇ��݊q 4�cċ�����������y���ߗj4V������l�F7�q�\�Y_�����=z|�}�}�Q����~��{�Ww�P 'H�1 Jm��{�R*��dt.^-�5�/Ί)��u��3�%D���r#��-�P*��'qi����Ԭ�n}�����ED�e.l>�k�F�3',S��;����7��Q���}w�}G�и����y��p�@��px�I"d��LE�+��ceIG��EZ��PDd�Af�ϭ�[��N�(=�:�8��&���LMg�-iL���	Cfb"�t�V����.��R*͍�j�6
� *�MO3q�K]8����Q�|�Y�''��	Z����E�#Uۛ1 (�M�7J��*�3o��6D}�ʇP���7o��l�φ4�d����J�-�M����U�)�M"�|C��'	���#\���� A#������ɴ?|����Y����PḧU&�D�0��d�H��彃*��!�A��Bϐ�f�'`���j*��͌N�B+a)΃03FD���:�t)�����s��lf��W��M���Vh��q���K���H,���<�;�]�8�;���7|�W6�1}<V��.=�S�N^fOh��P8TnU�� �_��N7�F?���V��D�&���/���I�b%���t�
���
9<ǲ&x��x��2hj�1| R`���Q�Z�T�@��H�6^����G���7G8[�u���,}���_�2������gP.�h_����f�e֋x�t�Ժ���TJ���ef�(�+9B�̬Q��9F�(�Y-���נ`(�2sd1�o�o�Ʈ���	��K,�t�IL[;����L�üV�~����gF��U�2��Q�Qqx}���gg)���e��-qX`��5$(�$�5�&��v�g����[V�6�gx��5
D�U���Y�@o�x�2#D�9u;Zd~�܄}V�!3!��{7C8y0R���x�������y��}z�������G����W�L$�n�~�Ѥ�U����}��ˇE1Gok0�/��O@���-^3�д��D��[�f��@��1lfF�./H��oI?�|�u�tpn����t���n��DJ��ܲ�D!�?6fM�v����g��8��Z[��ͩix���	df'5&}��i�cf�4n��e�01�I��I˧abfS4�=�.Ϥ�̤h�'�]`F)f��`F�ne�W��w7�py�;�++�W{'��
�l~��5���n��G鵡�,%c�0��c���0���Mܚ�R�2v�:�2�O@�?�X�c탇�����/�*�δ��eC�dR2�V�LT�q'�@��W}~2Ê���uۡ0��h�~4�:#A0�*��p��h3�Gg�-t�����:�%@$I����=���a�$���{W|U�Y�&&i����]P�n9��}ʬ��v�9?���FQ( ^���3��]����ve�V��wu���zu�q:4���e�Q�x�QUW��d�Z�{/�-7w88�ӝ���:c����E{��~T2��t�8�Og�8O�Y�x��k�QS�8GC���i��+oTBB�\�Έ%p#h�w�j��s��Lo�%�3�K�X����U��2z��U�	�jL�錇��%o�{��2{����9����������ݡ�k�s�>�ψ+�G��8�y��,Zķm|�)���x/����JU��:c���MMX܂e� ����_*�����Q��q_$ ��:��t�w�3Z� g�;nw�:'��3st'�`��q3��e�pQ��)pކZ�����У�v���'�f�9k�M
N�*�f@����+T�+y b'+�nf>�������D	3��� 5#�@�H�]��3b���}̮mfd,9���	73K���Uu�͌�ŗT�lf�,�X8ߨJ��}��(�r�wn� %�@Z�:d�u�hC�����#��R�s���b1�'�Ԕ�E�k��    �ҝ�C��*�Gv(��R�$�� �I3Pg�Q[ \,U��!��4S�b�(*n�� ���Y,���:�y2���[�b�h.���Ð5@��:�D�x�pA�V%�̨����>���5@�A{]'�̨�A�p3��g�c��¼�BҬ�X��Θ6.��]%���9��J�y�3��*-����B����IΡ�T:�� ������ᵯ�����'Ό9��d�]�b��=��&�;���V���x�D'#؀�yY-{ћt:���[��޺n��٣�tƈ�~��f�iƎqT�������'d���fAk��1��+q�h��=II�,*c��8d3i���J��}�����6ݒ�����)GF�q �N7N9/x����=D������{�	J�'����	���[�oǿ�O��,*T���|B��H$����Q�b� �@Fn���>E�%���gE@(a	n�����ܼ�H�-�t*�UDf�C��E|7�Za)�-�">��Ɇ�yO�v��ͤ6�W���l�q�8�)�\j��3VϮ�]�Dn��:��r;yN�>&I#���4��h]df����i�e�=���'�j��l$��	s
[[�����n���>�o} `�,�hdf=$�:�~��_h��|B523r���M��̠!��Pu�$��@��m�M�#�a����PsFpU��ō���Buօ�m ���,�0��?��N�����(n�\B�:����X�AĈl�77�w����iM��|�Q܎%P�ߞЅ�j�5���(n��)�Ŀ�ʧy�������L:S����Vy{�Q�� ۜ�ΪT���i��T[c>?�4a���RfKhjtP�d��r�ԙU��֑�[�!�Y	����_$��/�w��I�j����΍���q�"�ы�M�3_Xsx���۫Wo��5*N�3H2���IƄg��i���k��./�3��0��m�Қ�%�FgJ��Ღ[����8ƣ5Fg�cjY��͆Hg=t^���h�ɑ�<��jr�5����fp�Hǆ�����t�q�pdrL1��KD� }y(�&$(6���͚�e��n�^K
�����\���Y�,�x��\����(�}�\�Hq���z�k��5��n�Fα���z?���OڪϚ����ʵUxGmV 9�[��f�?����bY���&s����j3���eɄ���f�l���b��<�?�����Y��v�эƱ���Hg:k�ȁ?��T{8WP�7134�<��z4�MuHf"������0)0��
C,W� �Pqy��ҋ\�'Xy�^|���v{s����Q|�%_��a73G�.e\�Ԋ	��M- p�dE�@�P��� �hٹ4�3�_�*��2P�M�Ӂ�28�����_����K��T���)n%�^5]6�\:���{�W<k�f�S5�N��i��]_u�c�HB5�]��~K|f�qᶵW�L���4!a8E${F c�|)��[0�|La���{]`���UE�p��ıMt��o߾��Ƞ�-n��+6�	�}7x�wJ�0=���]&ǁ��ҧ�S�?��:5�vw����s([Kȱ�@q˶��U>DL�+�qU�^a����x�貧�?n~���:�1��B��YC''pd:Gҽ>7�ȑ�k�s)�w7�\�9j�]�	�v�
���'꾝�rz�� ��[G}��,�v ��HPs2�_�����n�4vsc3w!c�0��5�c�ĖN^�[il�S��gЉ�~lei&�:(�yg{y�s/���π-yIĪ���a�h��N��7ݹ�v]G�XS����_�;z���Q�����H-���Ư��a�ձۺ[c�N�t�g<E9�T̓�x��{��������nx��^𝴫��E���ǂ9�zXVgc�=���6�7��� ��W��s�r:�D8���6v�d���߶B���qq����ˣ��y�8��z? ���p���[�j{�!r��q\� e.�s����� �4`�"�+X����gG���G,���������?��=�<>�_�_��}J��<������"V*Zf�𫸅�
�g�I�T3Z�[���b����(�G>��!���u������P�=L����g:��\oy ���m���Pc�g?,ϑ Z�v�R�i� 	= ���0,���;=���8zf���10��Z܂��T�6�� \��N�����}W����v�k�{���~�<��W�Zi��\��}K�^�>�|��돷w�p�����yJ�b���b���$"�Pc�ւ����� ��2����kmll\-�N7�օ���E�5�!� �e[DnL@�ŇXDnD���Z r끏��y��hn��,$��A�m�&��n\���Қ�"7.	"8��᪁ȍ�^!cEg�KCP]�Qs� ���#E͍�m�vb=�Es��)��6��Q�`�B5�qizG|EB̌K���5En\��|��"7.�С����qC���?͍��,�j n\p�N2��,n\p���c�7.@����	Q7.��
ҍ�h��q�H}��"�ܺ$���|� ����*6�sj��s��RZOm���k�W���!jz���H�J�`r��j �"J��t��"�g�Q��0���`�u5-���,�zn��" �|E7�[��p]���ȭf��p����|e���Zn>�懢������B�z�p�(�XDn D�(� �����m�qJ���\�VɊ����M�;E��P-��LzZ��H;�
n���^+
k�$�KT��� ����o�Fd�*���!b�B�õ����"1�Գ�Nq��Z[Q,�4�h�#�ǂ��3���fD����1X	"��������MfJ��Ym���9�u�M�3)�O��F�`�H�e5�.rD�BXDɳF^�P���s�,�/�r`E��3�0��h:��"�5�4r[-�Q_�3&bA�����2�,~{N?S�l/�@h$El煉����� 0?$B�5�F{�8zڴ���BsÑl*���H~��%�@>rԑ�C=OНNj/��&`)4��=��e'���O���E�P">�;͡��z�sr˛��R�#h�H�3L{�(;g��D}@�x��)���!Q��/�=$k����<��m;]��؞�4s��I����݋���;���#q��n���ۭ�Xρ�h���t��d���&l���Ŏ͓�Gź�V���z�V�m�@��{��f �d�G�_��m�
�
�����t:+G�}_P��8R �c6���4'�@�&d�����+�0h���5����v(7`�H;n�O�S?1�0ٛ��7��c��P�>t��y��L��O�����hl[Az��zK��)���{�(H�̥X����nP�l��o�[�v��&���`�s~#�b�Q�$7;b6�ƵX���.`�7���@��1�j��Vؚ���lzﵖZ2�kI&��2��Z7H<2��G菆k¡�F
uϒ��@��I� ���	=$T��:j��Tg,��j��e^d�0�N^�OMw=cg���{dV6��������@��1t��=Lݾ��j�ˡ��Hb2���")l����J�������8}U������=��c�I�7������XA����HC1�����Y��\��,�?�θv���~��E�&Sy�*޾�
T%�8������������	xS����뙩�=�����@K�)U@��f�M9YScu�*�N9w[?t͡c뀰�~�&G�΋��~�C�ؕ���#9��Q� .���!��!>?n1 p.�c9�>G��@z����nd� ��Ӷ���՛���E)��*J�Ir�!��?�������n<[��p{�#ͦN�(��%@)�R��*2�-��7Q񜠸0���d�����d��A�0(�ޑ�֦�t/���~(s�W��Po~��g�W܆��)��wYF4\i����    �q�lkJW�	��y��
� �PwNP\a��cG{J82���Y���������4�6SؑX8cV}��ٶ\M[����Y���@�^Fҳ�����rE�`Axs̮n*&���Q�8���wm���޵�n�������|)*�t��/�<��*���FD��=��z�f��N��&q�-Ã/W�
�N�*_<�+a�����c^<�i��i����᱂$xS�':��-����h[��qԜ�i�@�i/�.�q MEE`�S�cH!�3�&h�G�P��;�ʵ� ���"���:�ddC�7s<�ڽq�CA�����e˽q:G��=6{���ՏWe�v���jC-�
�P��>g9z���**�P�fr(�����N�p۲�]�<C4�G�.��.p�n�mg�߿�z���oޖI�h �S�rh���9�� �x�E���@��8p��A��ql*
�C�NH�s�
�_��M���*PP�ZǨ\C$x�U��҈ 9�M��W��2�M%g��^-ϑ(
�=G��8B"��h
wR����(�zH�F�9��h�ׯ����՛2&(��M�� �MŢ9����3����|]"�&���iT.�	�C�m�~���ן5ɶH�!1�N���׷�`�s�v(\�6#��T��v(\U#�">����o�Ѭ��Zv�c_�G�"�7ER�F�Q�شL���`�f�@���ߪ����G���8�왇��P+j�\��x�~��m�|)��\]_�����$3R�������/�*-͗}yEc�����
`oPW;0h6Pkޒ���X"�8^D{b��-̰�2��l��]vRqpH���-��f'5�>�S�*����p�pv��S�$�.�� -�3d����3]F�Ijhhu�on���ʬ��g�u�Z����D<c!S�]v2�O�;2.ibA7Vw�d`��R�����oI߆S*�Չ[Qr�9�9��
����i8��2����K�7��9x���/d�Z����HAq�c�E6�K�ʟ�S����7)�R���8!9��s�p�����s�`����-=���_Ns��尗�Ề�}[�Igt���d�XE�m���5�1��<-�D�]�u��n�Lp"P��GGL�.��Hn��K(���NCf��C-p0u�C�Ђ��$6f%��
�'�d�$��NbY��t�:"�SIU%�1�n���y�xvZ:[���
�5��]�tv��rQ
������z�p�n�턱C�lS :Z��2n}��H*1��HV��I�k0c9�� x���P� opN�P��o�8���>)7��#�st�k��aW�nT�%9�_v�׫qQr�� ����BXn!�9D�^ժp�,7#� ޔVޖ�K��y	i�g�Ĥ��vȢXE�G��v���J���V�����(q��~���Yn�R�b�8�4V�p�b�-� 1~��f�A����!���oRCva��be8���
+�V4�F�1� L\�U�T $L�4b��	7m���#���!f��6�H�%bq|V�S&��T�-Ȧf�<�Zv �R�r� ǀg)��8���76}��m)6��0�Y8Mo���R�f�H�]$_����|hO߰{G������h/�_�psM��P�;-��v����0ˈc*�يdru
ܳPd���2[�6K��֗�e����ϩr�eZ�^(�g���K#��X�.@�:3	���1Be�3s�c#�.y{��5у�����^�H,Յ�m����ԍ�K��s����I��>����O6/i�/M�M��s^$m�
{��(���L}��$�d��9�nW3��ѦB�gY�@5�:i�,s\�C���Ȇ��d�TX���P{�� �˅�M��6�.~`Xh��P��O��@��w;��`q���l�e{!�������k�9X�JR�m|��k��f �A%X5j�QǆE}e�Tlo)@��'�%Z�F�c��T:R�mQ�7Kr�����`�}B�4 ��0��C�f ͼ1nG��9y�~�뚃��0M�ϯxșFb_�G�0HQx
�i,.������|�Ki��F��LF�ݻ���~w����t��۽M8��
�]Һ���!�H�A���n�6Ǩ$µ\��q���*�����r݀q�	�H*ppD��'5*,�����~d���U݀Ըyi0*�̅�:���"�q�J�r<�}�fX0��~3�]a�����W��ȭ
�����hʁ�9U�O��Ϫ�K��1�uB���j1��@Y�6f�se�Έ��%7X��A�p�߰/c�y}�^rӀ}��?��$��(7'!	���0��CgK!#�Ć�^q3`<΅��TPN\���u���Ȁ��������-�����΁������v@�nh�W��⻖w�.W���)8���U_�6S�A`��!�2��4w`7���j̏�L{���P������+�~�E������#���0�m�Ȱo�~4p4�A{[���kǱ��q�F����q�HW�����`��x]��͋6��ѐ��p�p��\�29,[n��Fŵro�n��&�2�*bG�-Ϋ�"F�k����L��˧�����aп�N+����}��OO���W~K���;:0�o�K�@D3� �Я6}Â$�4H�"r���|/k@��j��N�ܨl�C��6c�k�Π��/29�DFc�yj�я��h\fQb2o%��C!D(Aa:z��bణ,��h֮
W��=�Q�y�ɼ5`���9���203�)<����[n���
;�%��rӃi�d7�d
���N$^H-t�HZ؞�Q���ҧds/�&20�HnU,���qXM��u;(�XL��,��C�C
g� ��iG��Zq������۳���Q8��8h�e�v!����������L%kKN�t]���c��nWx3c�<G}���g��&6~�ky���ENƂ|�
�0_��������}�g<"2���xM��%�$,����?������=��w,*�A��D�>��2��&9�k��4ۖ�{R�_���ҹӎ�Y����d'u��cd����iݐ�(�-�+WCC>�/�}�J�Kh&��Ͽvv�ww׷s��ZZ5K�� 7����G��^�~5s����_�Z�eX2:n��w�a��zIi���������,'6r0���y/9 b�B�W��%^q4���1lrI�ΗW���^H�� �(u���l�>vY�|�� ���+��L�B_]"f�p��tU��j3&׆&��&���?�����~���8���("���mXG��Dld��������7�x��s�����d+�m����֌a	2�B��M:���]}s�fƜ��:�5��&�ߓ�@.w�6�.A��kO=ˮˢ�G�����ks�`9 ����N�f�n ��hZ�İ�N8�ꫬ�n��tu<0p�~B�n��G9.�.�>�<C6�a@JƄ�
S����W���������/�o�pc:O�o��O��������q�x����ϫRqQ�Jyߒ�5����v�����t�����j���(�A�.VK�q�����}�e
��>'�S2m�vT�:��b���'�ުqn>;�f����׽\�+"�W-9q�-��\�s��b蒂ᚻ)��*<M\��/F�a�Z?a'P޵a�[�\����R����WHV�`61H���NXS������6������������돻��w�����{?˿[&��J΋�n�6b������J��r<Mw&<��1�eυ'�xl$����Ç��>��݉����Ӯ��n֔��"�}N�CE0rÔ�`M"ʠLOvL�ӹVJ1�b��?^������n��������o��7��>q^(s�J�OpLpC��{�t����W{XEp��z;�ZR����X#� K������5��֭�S{JWJ�dхX��G0��	�1:]%sؠYN�8�g6�sD�aC�˝v    �' �^�/��E���2������M��%[٬t���l��;�G���K~fB+Gs8Ԩ������䐰rvQ���#��6�4q��h�3�5'D"-hD��^;^]��0���p\���m�߶PȔ��̆x���� �E8�|��}$,)��Z|$L�[�}.<�V{豛k$d%��N��� u��'�쀆�~��.���a�3t[�A���1�����tq�|H�A�L(z��Ky5|ٺ}T8=(�:�q[�Ft����L�$�Z� [ �Ph��^jV�yk��rԄ�±���� a�x֜��c!��j�?��6y�0��{�Ω�����jK��9�Lk��*�����z�/�S3͉M����鳋���9�t��~DM�Q��@�P��4M)2h��?����4�Fa�&�t����
D�!�9������ â�J^���>�Фk3g����q	{N��D&�.�.�`�6'�x�� 6pL4Տ���Es<iÑ��<>p�kƒ�y�xi@\���lV�c�S�S�g7��
'�4v������\�6����w�l:���D��r㸥��v�xȜ*_��+_����y�;�\PiD\A2>��0@_��,L�ɕi��:%r@�f�fNU�Z��IBS�N���ҩ����6�i�cv1������ۧ���u
��{/>�_��<Bm廒�Ws4��=8��Q_r{�{��S��9P�`g9,</7[` �?#�nI�b���_�o�;U����P�-�*��с9�Z,zp�zn\>��xE���!��k+��*�ur�v���c�<W���Uiot�XH!��{����~Idp8
i��
�AD��' ��M�/�,��*|V�+����b�L�q97�FR��60Xxe�K�z���P��<��|�h�~�����菗c�[�����l�'��u�h�!Kڍ��v��9����i}�*M��m@�?�r*ݍ�JTq+�����q�<����rG&���77�?q��H����PI�%�s���Y��`�Q@��+SPuϵ�Xpn����
w�s�x�*��,krrsEI�����ȋ�N^���T*Q�0���b"��nLT��V�f���^L�|��Җ"][u�&��@�"�d���<��(0ۗ�{��IŁ�2|v!ǀ�+� D�@P+��!>ĭs��s,��to��99ؤ��-���jn���(%K]�R.��_t��T��)���a�E����&.�5r�&1ξhQr�@`>k~_�$]!��o�`1ki>lv^ �A�����pIW����/�j��P�VF�ʆϵQ��:,,����d�)BD�Ӫ�*���H�����
m�+���qɐw�́ �����C8�=5��\sT�	�?�Oҕ��f@B)c�������29�<�4�sET_qj�CV"�ɵ������WӪ����]P�p$����G��V/A�ѣ4�x4&�4V�'v���Θ9M�����LGP�SmY�k�a��)���D9Ó��6酶WY!݉�ӂU�ǜQ�V3��HϧS���j8V2f�l�r�H�v���7Z�:�,��j���c�s� ����򱪷���+�%��z���������&�A�J�N����ƻ#Qa��XȦǕk��A��g�N��+p��һ�u��db�n�
yu -�׺�^*\�"y����)>tv8t8>t6���-����Mw�+�C���Ӎř��\Q� Cl$e�>W�	j}?'3�Z}M��ڤߜL�V��0��Ŗ�h��t��c��r�����Cf%�A�D�1��ꠇ��.��M���OB����4��]x��kjɐ�^z��k̓J^�P)z��C�$ �
�#R�P%X���k2r4T�[7M�?Mu�,�n)<0X�|�bV��t�ǫ���л��E�~�6�(t0+9��qn���ŸX�n7C��L��@��/�V�,�w�Fw��I`�w��G��`�����=Q��i�r#c;�ͩ�.O���v3�)Ynd,M��6���rCc��Mg�/�q���R�P�1p�z%�XU)�̂,|Ū�
�f,�4�#e���\f�"q���ǭЬJW�P���j3���ʀr�
5ZXǍh�@r$Iy&�r���#U��깱�z�L�zn��Z'���&%�rc�3C��*�rc�B�C�u^��J@��"u���gƊ&M��UG%��-V�|��N�l�)�VC%RQ}` ,E��o��R>�)����H�F��Q�ȿ�v�~�,�[{t��K#�	��ţΌ5l�GE�����1�<As4� ¤���WMP>�=0�A ��pn��1ψ���qX����a�Z���9 â%�:\K��j����iX�9��M�Kj��s��S%��j���m4E̗��翠s��� L3beώ�pj�Y������z�������]`�{�w��Ә
�#��+�_^��R���'�{�=� �ϕ���}V�:�n�n|�|C������߻�۝�j.�O��%-�6�6�Fb,���n�4*_���|̺2�����(̪�~�P���s 4��ۥU��r8�{�{y#A�Q�n���n�nwmB���nΒ� �m�%���3i����B�@8��K��s7P5��nn�U!Kn[滄��"�Y�`x.s���5J�_�b�������6�4�d����j��oq`(45�:Y�I��|}lO�K)�j%9"OUe�lZ_����vS��T�U��T��,{[c�cBϕ���G⥼�\/�OR��ex�Ա3��J�ss�|�8$�2�=7&ب�b.9�neL7&i.�%T{�T�Y*�͡��D�5�T��>K��i�R��`6MLYI���lF�D���qzt��yJAa)s}%� 5p�ȰO,��ulLA���5K��,&##M9���x���a�0߀�܁f��CS���ѡyũOx��ն{�M��R�Q-��|)H#9����ۻš��x]��5��G@�1g�G��A]�a�\���ق4\�1�&���F���D�/�ܐ���z�{z����~�z<�vQ#�}��g2J$l.ǆ�(ɋ:?6ϰ�k��;��6,���d�].Yl"��4ٖ+� i��<�X�*]��u�S���.�
�z���`���թ8kXm�=��&�����}��W��>��'JW.�ehR���P�gm��rsTk����En0E~�n{� kZ,��[�立�_}=y0���a�a>:�
��
 ��m�b��r,��< �>�y:��0�F��%$�|%�@� ��"��i��n�#����ʬ���A�����p	��H"r>a̲�`:��<>k^#_J�-2
'��
AG�N΁�K$b9M��ZV���uE=�s�P��9�p�iX(L�k�������^���6.|/��"���ݖ'���nm�P��<B�� T�?�|R�֋8��d�AP�6}��kJf�0���NP%5�������Cg��\_�LD%kg��X_�F�O�Ϋ2:�y�~��Ŵb J:�Kd�Xa�=�v�9���]<+c�t:��%���UV����s�9�� �s]��&�����H��Nn�Ym��������r����O�_w�/�SO�����-v�(�YcA���2�=���T�/��8������������㧅F��GϞ�������������1@L,�%�C��4*�6�I�,�__���BI-���ӳMc�I�r�e��l}MCڬ,��=���D��z�ۻ��O�_o�Q	I��<s*Of����p�#(�C1���A��W�{������>�9��g�ecP��U�E*{�xS.�h�B'M�[��<4-�ht��_LC=N�z�'59��}-q]͊{&`E6VE.R�T"o����@��G�N��P��Х�Y?9�J>��� �hݼ,�	94*�w`��(�Я�`Aj �A���<�x�`tW�M�J�����;CB�fM��e���ؗ��d��X�� �  Ry4��������v�i���aI�;C��a��n3������?�^_͜�0R�Ǟ*m��\�{{�+��8,�§�8V��]%��v����c^��/:����.���8�A�p<���z�VICs(H(t�����p8�>����u�bs(H�+��u�
8�Hqh����ǉ��zqpe�EcQ��q�eSqp5���@�M��X\�G6�E�dSqpMj*�6�+:���
�`!�h{�K��I8�V5ԓ��;HN�we��U*ƣ�����T\�&8j`N����
�&8H�6�2�T&\�&dt���M
Ů�/#�S-��<C��8�JM 4������^�p�j��,�Uq��l*�R���;���/x�jZ#�Zih�Mq�@�}$? �R�kRK\K`�L!��S��՛2�Es}��`s�uh6ת@yh۾Ԕ�ו�z�ҝ@����}Ŋ����c��!q����c�ĕ�^���pq5�DTw�B�Ȇlui�
Q���w�c�t��g�b$�bл)���P:�XSy#E_�L�*��/�BY��}���eLE�=d��V��C�@���P��1��b��~��$`��P�^���y�9�$�֩2oc�x�>�K���p��t4�i'��_���e�{؞Y:��n�Y��EaW��/�������~w�������)������ﱡ��q�E^���!��Gඣ���>�$?��m�̬�-݌BL��?U'2�p�ì�WDY���&tu/����:��/�?n�,��_`ۣ�t�����|=b��7�*��ڙ�.�{G����mpm�ŗ)z��F�",���cz}AG�ۘ���Y����������X�D�;۠���z^oǢ�;Z��-��Ŷ$pӥ[�P5b��O?``�U1��G}0���[ü��EK;��ǧ7�����=[�j���f{O_� �� u�	?8�Vmg����N�|����}�`+݂l���u*_դj�Ͻ�c����ek;��S���!��	��B�h]��E�=�t�w7�ܼ�u���������v~��{z�O�����o�z�嫶���C����Ǜ���<G�P����S-���������[d�u ���q�\�4eQ�x�_�U��M^��U~�}�
��3D������zL_ڶ�p+��[��i�Ŧ�$[�,e�xY˖�ԣ!774�j�fazm�z�����K�姪]�lkϻe��m>E���dr��tEB���"���M����h�ԥ�Sۧ~�y�#������1I{���cև�*Lh�dh���΃Fq44�)e�����݇2h� �x�X�F�γS�v�A��d��2h�0�p��
�h�=e�pM�hp|�9n���&&4Z�c���b��;�	�-��l�����e"�|?��8m#����_e����B�\<��NK��4�{3[t����`�M}S-}~�I�����������#�,�      �   �  x����n7���O�=�r/��@�"@�"��C����3�J&7�q$�Z�w�3s��p{�~zf\,�������}�|���K�#���u�ǹT�A����>Om$JY�B{ ���DW���G�&��N���OsY-�ZT�EθF#�����۷��#�㵕}5-D!ʋ_x<�<y�?��ߣ�"��V�U��&!6e$֟"Z[E
s��[	����������梹���uG1�7#�G`6|��_���@Օ���x��_~�8{�*�F9g�<���F8^@�}�;>����an���_
?��)?}�ة70cپ����t��H��
~�t��>!e����J��`�Y�3������d�vΥ���Cs:OL�1�M��}bȍJU���)�g&�cf��I�ub���0�2.�K4����\\���\]Y���h�PԢ��P�aq1R�&�����5�m���n��#V~�d&V�"i�BLUh�*�Mp�`J۷�`�E,]�<;���vG�Ɋ��b֌��j��
��.��oa��a{+ڑƺ�0o��d1�%�H�3�b�^\��o�#֖��f���ױ�q���Ahr���o��v`Y�uQ�k�2�3�A�(�,�H���Q����f`��(p��j�Y��-��i��\��>s�&���U��!m��	[g�=��i¼�V�XX�JR�D����9T+os�Qkdmc¶+��X�W�ö	�g,?���9�:��
H[�xm�����9V�y6���F3�M��?�eYԼ�ٯ3��S���c;,۷M��K3@y�jB��h(ݤZ ��R�W�)h%��j��+�$��/"7Y�Z��}�H�q����/��.l9Հ���*�a�w��6�k�?��y�D޷>�@AbU��`��|��������aH3�k׸�	ٸ-���`C�3V�Ou�������嚈�W4��i�l&�8�̌d�D�؞"1�ȏ"
������8=�y�/"m�A�= �:�=�A���`�Y#v-���v
��w)`�s+G �YB&���DZʮ��"�+9HX2�m'1��	�C����������Ecr�)!�u�,�O�V�c�y�1���~���J8�q����O2j����h8,X�%�����']�R�m�ǩ�ָ?��Na޸�4���v �ޫ������+UL�ĩG�~�8k��������Ñ�v5������.��o�r�>��kW��6���o_�����r�k#      �   �  x���Mo�@�����,,�ZcS���{ٶF��6ӿ_4;����d>ޙ@(!�Q ������RJfO�Z��"19��Kx̎�XV|�S���|7I�m�H���c��T�NC�[`��b��W8��`�oڇ��4���-�Yc���@�pz�4��P����g���C"cW��v��tg,�r�F9��0.'DN������|���eU�N����kM��r[�<��2�77�����t�Ҟ�DG�5)70ޮ�H8��S��[3@����<�#X���6���i��P�f9u;wS���9����#��v}!������[�a��X����h6�";}�X(�M�qb����C�����a��Ƕ�Xdu���Pll�3����P,���B"��P:1M0ఔ��b�?�����Z]~�S,�dI���Xm�;^D�קH}1���>vQ�����W��)���<���j]      �      x��\�r9�}��
<M�E
w��M7�Զ.!�mwļ�%m�cYtP��x�~O&
(P%�2۳�,��d�J��d�|��ڬ������r>kf󣣷b~�w���J#!�׭�~:I�685�j$@���TJ������t��>÷6���Pi�4���x�����L�֍���
����T�t�V�nj�H�B��3������>N�c��Z��ʌ�Jk�b���z��t�s��HݹVk5��Ӻ6(3��H�B�/�V�l;�b+��?èV�@ɐ[B��Ux�qJ+��z��Ó<��O^Ph�Q��e�l��ک�����SGB�U�y�m�Y����˻����vy�X'��˅���f�vs��i���#=3L��w:��h�Z�(���(�^�윁W>C�.F-TZ?�y_[�	�BȒ5U�m��.�l-�-���,�o��'����3|uȟQ�֏a~k����Mp�HB�?v��Z��Ə(��u�pW]$i�πqU��Z��
��������77�WzӉ���N{��>��Ξg�ɑVP��f;:��.��E�2&L��c�{9�n$TZ/��c�X������nc��u�Я�	nj�H��i�|��Z\�umt:�V�T~$TZ_1�u�;��l�[���J���w�����+��Xg;�(NM�9H�0��#
-4z�ޚ*� ������H�q$TZ_/��Ŭ��v�E���J���^���ދêM]H� Άl�FZhd��R*{��@rٲ�]4%�-��R�����es�����U��!��i�� vn��
.ؙi0#
-4r����yW;�v(��,K
5*��ش��T�]mt��+b�fdH�p��� gT%�ܱ�~�]�(HN���B���1Uʆ��S������/ю(��5�{Ȟ(�����CD)�z$TZ#L>���wШB�x`h�X�� �}	hċ�rL���*['K��Jk�	��P���gtH%]�+L��
#�Q��V�X���IkS��֢J7*�<h�/��ܩ��S(ZO#�3�N��>:k
-4rR��FJ����?'TZ/�::�F���>;���9�6�wC]!"�s��ĘYm-TZ��->� �=n�5y��]Ź����H+�V�Ӗ9E��esb��.�X���Q�a7`VĞs�������*�Ŭ	s�q�� ���
���N�%@��F���:_ȱ�mWZ	�F���\�V��wpD�������*��S����E�h��&�2��u#��44��j:;(�`�T ���sK���Cg�Gf	��'���@�L��Z$٘��&���o	P �,`[�L��(��*_>�*���l.�˻������������t�yx�m�p������x7G�B6��g�5TNd&o�Znq�( ���Q�K��� Jdd�	`-TZ߃v��f~"N:H���roon�X�3\�H���8�D;��W�L�%��<	�r �j.c��J�[��v�#�(ADA�;�7�"�wjo(��� ���Gn3�F�K����w�6�bK��~��������D�otD�F�;��Ԋ�+z�igF�6��R������w'}O�U0�8*��m'�pw���aL��	􁨸���eH����Z��p��*�A�v��M�v$TZ���{q|����"P����e�E�>�Q�-���g��r�C)�{�U�oH��b��[B����9i3ɧ�J�Bj��0�阏���Z������0x)�
�y��h�b��4��ˈDG`��m��<Y���H��y��� ��"�$����V�����D��t��>��rc��>u5�	P��"P��c�t����_~$TZ�B�rb��֡�1�>��݇�� ��5D,fvF�52�\�H����X[�I��(�x٩�H4J�Q�Dׂ�X*ˎ��D�3�T��΍�J� ��߻����p���b&.g� b`��_M;�(�"��mj
�6�I���>�JJ�A��H���" N'������&���B�C�Ho�!��u�(V2��R������sn-TZO���X�@	3� w����� �?e@�Μ�T�	(�
C�(��5CC09���W9��+c��H������0�j+x���<��+T�F���j�u�5�����d0[pK��^���H��apJ/�"�\�2�D"!�8� 6>�Q�c�f��C̾��c*�����i�?��� ������Bv�s�7� @��t�+����0*�-P�ESp��tg~^�_�R�Q�']΀���n��A���\�<R���� ���V-TZ[O�����BX���b��1�>shY�m�6�Ƒ@-4�@���Fɾ7�m�8��Pi������߮V���7�ū�w��rq�aƁ��I�9*dW�9L��4��5�+G�l%���A���p�������x�[�XX(ɓF+1��-�S�X:+�@3̀���xlc�g�B��Jq���fCq����Y�ss��y��rj��(�K�\��KW&W���>y�f�/z$TZO���������F��iX�#g���f�bX�smG�pCW�X�.�Pݍ��!�B��<Xr� �TJ��B��Y(?��B��Pt��� ,t���%�~$TZ[���6`�vi�
Ncr��$��Z<D��*X�*��'"�]��4�5#��z>���˻s�rWTrEu]?4�"
��FW��rmvw,LU:*������
B�!�/9W9�,��)����p[���r���貇�h�8 t<U��B��5�Ɇ�ڠ5gp��,%�2��q$�w��h��`Q���#�t#��Pi���l��ɛ=qr6?�<ۛ��?4<}ۙ����bf�j!�:��-��N\�C1�2׫(����ɚyЎ��?A%�z��*�o#�#�ɉ�4Vy�[���m}i�@��(�K�9&X����;�P��T�B��f�Ю�j�b�A�c/G���J�9�<��ofA��dbK����%�� ���w��rȇX#tuޏ(�YjT�x�y��獆����Pi}X�L���E�Q *A��F�%xh�p�afB��f��(k]	��w�����\�"Z�Y��=������*;���N�h��T|�:��j��*�O����K�-��Bֲ]p���"�ټw��Ӽ�	Ph]5w��-��"7��G?�p�H����������('@��|�����H��8L�{*ҁd�Q�+���f�m�H������%hA��O!��!Q�U^�Z�o;e/D�+Ǵ��,Sw*[6ڷ�J�h&[]w9�g�:>��H�'�FE�� �$D�Teh<�x7*�g�Y�X��)v55e�tҠ�Ί@���ĮW4�v"�%����b�	�V�vqyt4�q��ZM4@L(�~9�B)��-����PJ��Q74w4á��H�����@(�ti�e���Cx:����������2��r�mi�`W��=���J�4���� o��{y� m��WՆ�	V[Y�$�}��S�7
�J�#5���YK��&�h���F��ێ�������_���g��̎O2���$:��rs+޽?h��������E���(i����w3�����ԁ��o@�Z%տW!~'�[��v~�7����zU� �1�ax�"�����`�(	��U��D�Ǆ��?|�Ce�y�����~]��})fi�-
~^\_[���-d��&��d��N�O����!�%���F�u<����˫�m<����iX��&)�;�@�&�y�2C���:�7�~���{fۋX~G\�>}^l�4F߬2`q:��(Ac����4��	2vy��F��ڰæs$��7�o��8t)�]�t4V����ƅ�3���|�]������SjfxC��xW�A�M��3��D�y@��o�NΛ7��B�"�t0�PHu��,�7�
�*�@f�O/�Jߺ�����s�q
NC��7
��#����[([������p��|��M��px�KN&�M �  G;�4�m����g�>ݘ�Y�l"�z�RP�	K�������ǿ���|����,���O΁l����J+f{���	�Z:޼i41�/�;;�����"�>���c,�Ӄ|4��Ǎ8����~}��\݋���w�5�Gb@��w�g��'��������Ht�tA���YM5Ջ�B���q����w��lW���_92/WW�|=8�tjJ���1_(��tw�g�`����������~��aq�1�C�;ǇGb���(Z:�<�������F�����o�~�Y�{�onD�$1��pr�zH�|���r@Y8]�
���xlPs�J������7_}����Z>��?}�"��q����>�~ΝZCÏ.��>��W�My��t�']��G��R���_�,SF֖�p�{�dL�!��K~�.�7^��s��`y�Qr}s��O�[�s�n�P�nW�/�����oi�ވT��N��P�6�cT�|q�rl�9||��x�?ѻ��b����au��+���_�e�O��G�ur��I\��P(�r�8X|^\-7_P]>W�X�.��j���YN����|A"W��(����6�{/G̛��U��7'��3�?�U{q�x�,���Q�Y><,�'"��Z��M�ΰs�+m��r���T�������ϭ���_��7g ^�/'s�+q���'��ԭ�M��7�h�Ե��h�(���믻f-�����JL�G���� �
�.�����b����rj�1�'i(f��iC�m̗�=���$� ������cT�����R�0�Ab�C��U11Hn�,�NNCzQ�D���\�;x���+��~���,������,P�CG�L�h��7����[�{[>~�,.h�#F���ECg7����`�f�ϻ��.�<h��Ľ��_�q? 7�JY��+hqJ�4�U�6��_O����u�Bn�&�?r�@zEĚ>bi�H՚�GW.m�^`��f�^�M��(e�J*Ƚ�t=�@S@"]h��X��A����nd)���i6�.�s3/����YĢӅ�j����̟~��Ϧ�0ˍ����oq��$�~��9R1�Iʡ��s�sp&(�Dο���qq'6_>�l#����Č@����7��[B�d$�����i��lu��_��ث��tJ�}S�N߂D^�/.m����k���ű�&=l�o K[�b�����zKC�!_\ۥ�]��4Dձ��}�6]�������oS`O؟-��m��J<l֫�7��KL��5J�ۦQ/W$�_
����3ƍEbG��_�a�������z\fJ��R4�nx�c�E���4u��Ζ��C��������b?ցg�1�]Mam��������=/r|��b�>����/A��q�]�wF6 ֎:�]�`{�Q���c��GL����_R���tX�1�a�i�E����e+� 4�6V�	��ɜgT������&b�C��rI�o~5����rB��V��?������4��xu�+my�Eߥ���������A�8z
aƭ7�~�7�3��?9���J����d2���b�8�*ORh"�P�|q����5:8!���B[KU��͒������P���F���l�XVuȆί�C6�@֠Q��Tu\�F"	j��u�P���z�\�.�ׅ}�Ѧ����U��A��v�
>����&��yϖ��HJ�H��F0A7��.�h�f�pH3uv�H�ͦ��I�F�)0�l*�*x)�^P��6�J�k���Cv���?n蠥��@ߕ�Z[���	t�Җ���S);��m2D�hST>bS���x^��8tiIi�l��Q�+/勹���(հO���W�y�Nl�,:�X�\��ST��o�G��b��!�>�*��JF���f6�&*h��Q�Z���:��J맿M���y9J'      �   �  x���[o�:ǟ�O�/ pyd��n�4T��<U�\0!7H M��ӟ�%ĹР�2
������O�E,�`D��rl��֫�KZ���U%¾�@��}ö&�eY�e�p4�����,{�֬��ӷw��e�P<���C�
�#���M\_���V�[��b�� ���6���#:r� �0�d�P�R6۱�$�&.�L���EjtbO��*�w��c˗w%�:ٰ8�$m��[Q;�e#y�^����\���i1�3 ��<�.�iS]瞍u/����I"��=E(��nx6ƽtR���T���+�.�`i�?�F~`��s��(���G��k�L"*��B�¢��=6���������{�`�sS��=�S���r1����XW���m���~��mv��,��O%�~f�⽙�G3�>Ӣ���9(��yG ��sx��v
bg��E>�N��ۢ��,K7��넺�%g�?�9g�耆m���.��.=َ݆+ȧ	ߪ���a׏���P'\W�z�]�[��kլ�L"��3OO����x����"�m��Ü�ʣ�"J��
�� �B�N,�%�.��	U��}���*��o���`�Ƨ^*��(� GZ�0=j�L�*3/�Ģ1;Ye�G�ɯJ�_LEˋ�q���-��"
/�R�����9}��`���Z�S���N��NPL腎��4�ټ��0�>P�B+_Ʌ���O
�|$�u�` �CǾ$�{D*l�CA�&��y���GQ�KV�t�P�h6(����]6໖Z*�����k|;n��zR֦ݛ ֵ���I�[ ��K��Qqy,��(���۲;	@m(z�u��&҇�U.�P/Ŭ���}� ���}��y5�xX�N�dq�ck̶o� i��:��$L\��}��ix�-�&l�	!Y3�@ϫ+��%.g�!�A�x\u�k����n�����.��A�!�t�Oۊr��'M���N�~/Wp��=�v�@�s�������>��|xx�p^Ey      �      x��}[w�F��3�+�Wr�6�� h�h	r���k͢-��XG���ߟ����@�N�gD �i�cu�뫳��ݛ�����y���,yK=��������[�a�q9�˺J��=M��2^eβ.��<�?T&�s���9M�����3],�"^���;?=�?8���;<��l��������-ַ��������������zywq}�ّ�4O��؊��x��������m��0D�'�����5ߧ��m�x�%�z'<�LpN��n�y{��j}w��~���s�'�%^f�m~�o���/W�oy���,���*v�z�n�!�
��l'�A��8�e�g;�{Wi��m� �E�/�ݬXM��Xe��I�7���nu����������������//:?�`�rɤ��J��E?<	?at��<F}b�ӷ�"|���բJ��$��qI�`�".�jѼ|�/4aE���AD��G���D��#P*�^ ��iހHm R��S�U:��2.���q
"Z���㲘�ײ�Tc���i��&E�p@7$Y���V?��_ݹ�����/��q�Mܟ�����/?6
����C҅Q#oȾL�7P,�p>^ �
�~p'~4�����?����䗧V&�N�� Heќ�q�͜qO��$�<�&1\�Y1�K<۝�WJ�B�F��B���^�4�9"~�yQ�cށ�z�������*N�J��[�E�jT>��sl=��.��PjR��Z�P<:��-�D������On,9���,[i��J�v��<���H��8�2�	���os�ͨ�y/����M�!�fh����Y��l���c���y��w�r�&���Y�]>��t/ 7���O�pb�K��j�}D�`Fmp/�~g��&�T�Tu2�Q�I
%H"<k�|�����g
�#!ü��d^t 2�K��W�|��'X/����
1� u�8�g�!.Ѯ��+��d�D�������G�'h��-�;�����|}�~�Z�qpߓ}$�����D�q!�C�G� 4
���l�~��8U�Nd���f9�y{�{l�8�����;�����JL~^��q��VO��_�
��\��7�O���뻋˻�~���|X?uͷяD�}���w�ps>
}!�YN�Ǹo��MQ��SI�1���`�.�Tz�˸�@r��(c�h��o8�{�?�f}��\~>}#��� �vZԮt-���T�� ��<j��L�t% 	�V`bR���1>�_�)#� \�_�3���Þ�oH��		 x�sy�M 
¸�,3u�`)H9+��T:t�NЪ����s�,�N��!���#��c8���  ��u��]�z	GBG.N��� 4&5�"��b­�S�%��� 1]�b�b���G[�|�~X��v�������7q%=�]W�xȕ$��S$�&F��<2�3����Mc�	���ς p�/��ŹS�����m�p1���b-���%q�#��e����!�S�o�!��R����yщH� =p��R�B�����x�q���`���ؼ�q|��a^r�}���H=�������g#ߧ����(C�!8�!�]��Q4y ��w5�1]���"��.�'����=C����6f�w���cRx"
��YC�G����]ߴCk?� ���ƭ&E,��I6?����_�	01�t���P���}�#�v*N<:b�1��{�lǹ���r
_����%xA*[�u��	�P�1�'�f�	�#�FaH#s�r�:����ñctTĽ�M�넥ʜ�rsp;�d'�~�f�Ɛ���
[�
�S�"G��+0�_�wp�-�ސ!U��!�8�C
��x��z��4�"["(��n����ܜ�s��gp��/ϜY����8�h�6��l�y�L���N�nO��Vi?�L�?�I��'ƨ5���V>D�z�rKƃ$�ih�""@�??�t�581N~���|�c���oK&V* �8�RT��%%}������C+�Ԙ��bj��4x�$/~�{�$�R�#�p�@���dR�@iH�t2�r�ൈ�*��J#���m��[vdx�A5�υ-��cOT��G� �gw��/{�8E������oo	�����{L�"`��*�ų��L9�]bP�ڵ���bs��8�NA�:��OWp���ݺ:s���e~��d���f���,a���/_ev�%����({�r嗫K���b��v�4���0̞w��M�|Xǝg{{����i��e�ցd��-�麓�-7�;i
�S��o�O�|o3bg��Z3
߳Dۦ�"�Il?z�߬�L� 6U&+�[������.��7�w�M�����O$`>���~#�,�8�#�G�(�RU�y��|�y|��)�W���ۙ�6�]Fb4Ӎ���G��?~�_��
��(D6���ٵ�]a���6�v�%n�v�7K��N�c�g�����^�n���4%���<�3��.�����Q'~���n�V����n}qmkyj�mO_���8�������N(QN���ݴ��&�Q�2��g�EO2�60+͍!S�lN;	�������F�Z�3c��A�H��o��p=��BLO�C�?��Ȝt��������Ϸ�N]_�/֏�s]9��5�f��N*r	�K��3�2����m��ԻH,���h��$�Ā�c~hD�q�e����[�No�TЎh@@�u�t�eIf�y���ҁ�.d���0)���Y.>LJ��d��+��Z9�����x�V��Z��~+�~�!�cQ�.��g�s�Ň�i����lއ1����������Yųɡ�d�Q�����2(�W+p��1��u�6���o��&���e[�ݹ=ʨlK3%t?�p�fc�iא��5�������%�ވJy�L�����M
p�T)�=U�O0(�e����P���[�p�NX0
Ed��I1���B��$��7�,2��"�(� �;H��H5���0�
���ڰ��O������t{�����+������nn�����F���`�����qq���>��u���`#O8�IQ���t�9qyV��=(�8�
L������[I ;�̆c� �U��!}�����aè����\��܊rQ��1"���;�%��Z?����Jfa6�-�e�S���Y�VP�)F��r3��=
 ��pxR�i�Ћ�]��G-��(��}�MD����?�Y/'��-f�.d�G<r�I���?�K��y=~uֹ�5%��e�[B����c� �<��ڛ-˽��A��^j$"�S�?���v���o�;�X���✭o�W��[�ݫ�����u�If'��9�?wR{#�x���'�U��i����q�,ăI|����G�������a?=?�e!� �:�7i�(]U�o��U��jpڲ3,���7�f�e?��s-�*�����B�
Bz�	�E�s��i&�����h/��@�6G�0�;Z��0C?ш�1�E8��t�|�lwEf��VO[�]����	��A�11 ����⎍��1_�G$^�C�ƳZzvG�`�$����(� �����>����k�5���w�|K���)��S��$9w�����z���I�d��C��J�i�.O�����$�N�����h2!Ɔ�����L�������KF�}C< �<&/�E@�. �;��r�~�'��;�R�#�8w��I�\�����&`^���\�|x�^�1
��z�Ӆ��.�����g*:���ĉ5�������D��y;�{��<'�����Bʇf�i�yR��{��	������������ѝ=]�6���t��ݘ�|�w���r�+pJ�Ċ(H
�-@ۃ�:M�1�� U����	�)�N���? �Y���%�[�B'�HwAA� #��V}��Á���7��;P��꘹n�f+��Ё��;}g�q����<C    ���̋�˫��F�X��������;���@���ǫ���ݟ��h.1y9[����F�Ծ�-쁡����"�"�oBF<��h*��B��$�)Ì\����>�Yz�\�ԯ&'Qv'�_����c�3���00)	AI�sH������dL@���R6 m�%�g��+�J"ӞZ"d6�D����N�Bc�ųAS{*fQ������w�����C"�4�0�e�̱we'Z�Ԯr�1�ھV����_L�rPL6EԽ2&�6�56Ș��}g���|���\�_�^��eD�<k�K��7��2G��9�m ���cu�>Án�0sO�^(��'ӎ�rj����n�w���uy�CJN�B!�$�͓������N	���?�n��۾�"J�'�Ut��MC5ҍ	���?��/��8_��\��,��z�Ŀ��a�~c�5_N��v����${m��N��al&���/M�7 ����^3m3],����$��?��g�,ZRXw�~��ҺUY{)�]��D��]�)�9��GV �]n��h=i`M�����*!+�����o=b`��>�L��H�n���a� �"�:_��\ՀV p�T�?g��/^c��͑:se�s�|����Ҏ�V�����Q���vM���5	gCh������������x�cU=:�qU��:p�<�� �X4��0�Dk����$�`Fc@ )Xk:����Fi ��vҠi���đ��'W�8��D���)Y��׬uE��ZM��g�R�i���P�VR�����6��D[���prBXpWL��b/8�G܉����/����s�3�"SQm�=t�޶�@!}����t6���dVb@7��Q���q/#CkE�V;rfS���3���g�U�b����)�n,U��`̷��{��y�6�ےoDNMЎ����fL�L��zw����|q��-�g&��C�L���$R�NNl�o��R̠�2
��:o@ ,�S�[T@�Q����g5u����Q���{[3�~ym��HI4�ybodiϼð�E��\ރy���st�/��%呛�NT���x����y�~�)�ڔE��)E�@��� ��G�!
!Jb[��;JS�� �8�!��+E��E,�F�����Yg�&�O48:�S=����x֍~��C x�T�?������̥EwQ͞m�B�5hg�X�w�2�����GF�:@���,-�w���m����M�2TL�2x���O�[W�>>���~�r��B���3�Yx�+��?;`��ͯp��6� >�P6��j�%R�¹�c���-�΋�X�������;�lv#d^(����O�b��R`�a>Ͳa��"�ʷS�����jňJ�J3�j���5�F���b����b`|N��W)�3�<rH���!w�ܖV���D)Ic^Q�	`�$w=�c�&.��A����&&�!�8H.?^n�_�������}����׼��P��(S^�\"1v'�T�{9=��4��W?"�]=ش_A(����8���y�,3��dP�;��QdդI��c���lzt��F�
	2 �ǻW[o�!SǗ�N��gAɪ;��|��I��Y}\_�_�uM���\>^��r��y�e򵕲H+����P-\+d�����4���k�����Hev%�w$���KL��ЉV��[�E1˗�kp7��P�&�8����"�����!�����:{��y�C�;�Z��£�dm�_�ӳ��\4��?���y�I,����������k��������u}w�t��\_�9@S~A��Ksa�}�H�x��QB�G���q5���X,+���9�燻5ĶcA�I�X,��CD�G98�I��!q�û��4��*z����"����7gX�ִ����[^Ȑ���@�[�����dӐ����\SeCx;`qSp��2w�+<���3���1JG������s0����J�栣>`i2ճf�~>P9i�B�ԒI�,��^�C�b��=.d�16�v���0�6�:��fa��-D�6��/{�XGm�w�!�?��E��؞�xkY�G+�7΄��4nx����i2-�EG �>s�?����w�Mܳ_�eR�8��3abc��(�H�!bF��8|��f�;�3q9T�p$�*�fnJ�6Ԓ�S�l����d����WwP���2H���z�a�����42��嫔
jz�����O����=M�Em}�f�ߩ�-��Y��8�1��l�+'�S�2�P�c�{ݫ��n?�M%}�ت7�B�{H%B�8R��'6[):�l��bX 9:�U-��$�2��E��
���Dx�4E HdI���툢���BIs<�g��]���V)��U!�Q���3���'ERO�A~ �M#6����PLo2������� �Ppn�+ؔ"�e�ay���Y��!_/���1�:���0d�{s�cx�����έ��^!�����.XqC�i<�&@��l��4���(�i�m�F��x�|����v�G�}��~KB��<���0-��t��b#`s[k2�ż@q�H8gX5ꑓ��I�/XjF�w��̣QP� %���o�R�!�5װ߭ۿ��Υ�H%����yGQ��C�P%H��!u����wׅ��zs�R�^��Q��l�"s��>Ъgqy��h:����r�0E�VI�y�ջH�^η��8��dۦn�yHq|K����{Hy�A�v�!L(���G����D-\9��J��m��pG��6�i,�h�98�{$CC앙�	���P��4_N<�c$,;�5�c/�
ت^.g8��|�Z�C�#���b@�D9��1R�Y���6�Xy:��U��G;ke����c�ԣ,�|"�U�L@�A��Ya��e?����>����(ܬ.��n��cΐH���e}���C��՟X�z��h�;.F�9X@��C� ��Lk�W�h� ��
�0�X@�����٢(�(�Ӵ�����B�`�Kb��Z ߁0g%(޳�P(p��تs��J>���֟@w" �&��*Wz����Qw?�zĥ2nQx�'C^�jq2B���_�?���tu�^]�� 'g�~x�z~ �nm;H!���b-/���属��t ��$�ʱ!���#Xf�<��۵+!�f��>��p�"�g:����8��Y�)=0�,'�Q�R����m]?� ~�#A�������S �r�V��{p��Yw��~��ָ���b�s��PXq��R�Pb7������v<��#�쁤��7
���{�ك���A�L8�o)Aה�q�����Ye��P]7G|�@���S����Vu��o��j��A���@�	�0E|�4�W[|���	��R��瀔U*��/��ǋ�^���'��+{��i^mJrs킾��2���В��/}O��$4w����[
3�tu08X߂�a�{~ �2e������5�h�6��G+��&���,��I���x 5�@���,m�S8�(�X�wq���c}��ڸ�'q�� ��N�a����'ad��ʯ�ܝGL�F��U�+}MI)�L3���;S���T: �E�y��+���"X��:6���t�!�O�xƳɾۉ�����|t+!�g���T[9|��u�'Ww_^J��íⲞ�^���
J]vwsn>�Dj�Z�8�
�w.�Ϊ�WDf����`�v�I�p�Zre�-�i{g�e��2섞)��t����I��9v��J3�w���Q�`7Sۊ3êsH��6�s����M��;M�z�Fa�U�n�r^�KSB|%;�3e�x/�������>�6[ވ��D_�"�d�g��,�t-������zo{N�38K�>�	&j�\�6GL�"KҬ}��U=E-ҹLG�,C�߹|E����cX㭼^k�p��u��2��qd�|ǜ�?Ϋ�xX�U������͟���Z�N9s��'�c����������_$0�}B�΂ѻ��P��#�A�~�y�'�b���>��wt?F��,�L�PY��q1-U�����    ���i�\��i�~=��g+��=��"��(Ec`s}�	eHQ�����@MJJ�>�rǡT�2�^��x֤�v{��8S�"o������!V��|2��F?mog��G\f��mp]r��.���464�����g1��I®ʏ���l2��W���&�L���C8>���m,��]��QqV8��6���z]7ɏ���2G?�f&Y�C8�������0uE��j�.ݐ���M�]�k���Rj���Ɖ�����I�I9���ӽ���.x^��ш��ǝ�*�d��s�M*C� �$[Y��ќ�<��]}D0�;�ԥ1��۶0�N<�Vn%��:��V7��e����Y�&]!���ɉ��g�H����Ҿh��'|·JA���2�;�r>Q�����2C�����,u�V"�ȶw�ϩ5*>yj=����I����+6��uN�~�T!&���=��Y3�9�z?Ƭ��Aq�G���0����������'�T���G����i�״/t�J�ǫ��P���i�1n��N��.�P��Ll��!`��2��pK!�?�?"�;H��P�Xƀ!�܇�A\f+E�0C�и���p�Հ�[��������[,\���}ӷ�.��#|PB#M��(���y֫ӕ�.[	���\���>�1�����B� ��ϐJ�Gd3�Fy�'ٷ�Mtyd�fn�iQ~�z��w�����6��uϻ�t9C�훺�H}�ď	�~�~7:�)Z&H�;Hc6��r�)J0!Vˎ�x��VQ��f��G?�U����)Nv3��-�:�^38%/7*��⠳�Q�d�(Gn�Q2.3ٜ�xu�ပ���.���y�}6�s�[u�l63�W-Y�EMS���!���l�݊�����{�`�|���ۋ�g�:]����ϧ�Ν�����͉C��(.o!`�̻�'�-������P]�����>d�?���0�8�����Z�Hc��������ߺ���z�A�8�� ���G/�C�4G#�XA���7��4c��Iw��[u����� y��0
���
��b�T���q��Q�N�2�$r���]��٪�e���6��,@�/y,��YL{@4�{�ҐQ����.�R�U�g�y��:v\�E!�e�zg�ބӹ�ۥ}�Ý�"2<��x����0D ��P�\�2ܔn��(�Jq��W��c��{�?�;�40O���j.��Sg���X�%w��v��.�c��=N^�Ey��A���4�(��̘bG��z�a����%^(��ᘤ� ����H>�m<���Q���'��O��5��lr��y�?�oL���t,�)���e�/�g+�"��Ϩ� `���{G�����)5�;��pD�0�$g��X/;&���`�BV��U�����b;Y�uTwWL���[H��J�c	��a} ��B )ᛛu6�4f���#ŽVrɗ.PMcy:�׫0�8)s�uWࣀ
x3}!�<XX��>�e!��m!|^�셲aۅ�¥C-h`��qW�?�1�68� �Qr��M�[���!)�oA=k��j}���Η�6���u�h�Θ� �aKV|�4g/1���<�G̋O� �G��98�2M��}�fۭU1�r�B%CC�&��cDB��ΐpǾJ5�Q��_Uǉ���8��Kr.v圞Pк�K� �Z]�~&�A&� ^���yV�z��"�m���=�������G6���>ƪ?��x�ql��w�('�)N��n�N��S���#��T�;�Дbhk`�S�q5r���s\��j��²��1�g��W���+����Dp���)/����'���=g>���8�ٝ9�՘}��ϓd��@k�f��ӻz6����A��ù���>��Y��CF�0��6�a�!�o.��o��,��dc�v���������>J��26c�[w?�9��]86&YHV9p'3� ���23}y=��Z@{��br����^���t�)��зI���y�mV{������EY?�nu�����Ώ6e��$�>5�����v�T��~�"����ux�3{h�G`C�óW�:Mǳ��H��Й��XJ�]ɑu�c[���E�j����0�Xv��jJT��n��pMڇ�lBm�|�%ı'M<{��B��	�ԥ���TA��e��ܰdZ9��w�%W�6۹[�W	a�8m\��<���mꮯ�RO
���O!D����V��}�8X_���QH���7@�d(�.А���lV�٥�<&c������~ɑ�L�9W��Y�9��)n�Ź;O��3kB�����wР�)f������|?�oݹDң6E/�0��F66�Μ�ۍlv�����욲H����>�Q��-��k���K�@��_�MK�iO�w�ܛ���J������a{C7�K�;!�47�`;�D����;�f�E��𲪋l�M�._p�)1�mF���BM�R'��(��Km��v����3�����#����3!ǂIN��Y�����T�W��#���H��<�g�*���|�b\Jڗ#T�ŕ>$Uēk��n3��O�"9$��R�P`�:����fX�����
�񏳙dG@w.�hsI��_��;	�$�����~Ovl�`�b��41�����0�"UXQ�����4}�4��﫺،aCH˓��)W�Ln!�q�k���;���w�Ԣ( f�p��u	xM9	$�?,d�	Ti�&�/��C����e�C|8g�����^�����u�q���lG�l%w+m��B�bڞZ�ZB,�tO]n\U�-Q���FԐ��Ҹ�g+,�7cV����&��$a�Y\c9��&�q:9˦�U:(��b.��vꍁ(R��·4�ك�����c����^pcZN&:�:�b��i~�&�G]�6n�{��8_����ͪ$�ͱ����zAq=����5�6�!(X%����[|�j}�,=��z��D*�;�S���EW�����j�*��B���@p�h ��@�DQ�3�q��x�u�4��IT��8���&�����QRj �:����m�.�`B^d3�������Z�M���γ�Vo�@�u�U����r�R�ӌ�o�Ӱ��@�@��@yК+Sy̪�Y��tW �Oc�Ձ��H��D���DXF���eys���,���$z* T��9��Q�q���?���\��[ʅ=O�˙���xD2eRb!ʴ�ٝ-5��|�AA�27��
WX`t���ԓN8�I9���">mZF`�:�����s�sM6Ҿ򝥑fr���3���S~52��ʓ�'���x�A��)[׏�ϸ��������q��ʙ�\�2x�7���냝�����M�q�2����!������$@�᳡y :M����0�@���4�ȹg�k��I���O�8��S�8+-�i\�rI��<rd��c�M�Q`U�n��'���#�`�}Y*�P]T޴��V�7�G�>�	8��4Ǆ�$���Pdkx���G�/�D
B`�.�Ip�Ysk��W`�1َ�WU5"۞P[��p���0��mԋ���n��pߋ���v�'�	��4���~�g�D�X�)�=]z�#'z"�������d8a�qO����i��QG� S��4�\u�8!f�l�J�����C�#8���w+��c;�cL5�tQ�pB����a��Ms��|�
Pm����믆q��^������iwYmG0��V�Y�C�-`~�e�D��1���xi��v>d̵���M�r����c��1��/���x�0��	�q*c�b=iU�Ϸ�������˾V�ONz�ۂ�����������G�Øy�~��o�L.P{��F_�r_K���N������	�Ϗ�O�����#7�"�j��~���˃�%D�;�8�r��w?ֲ��#�9�#?��)�������!�rv�~�sO�u��eH8���i����߲\&&�x��d@nuE[���s݃�{�i�d�V ?b&��    P�K� �Z��2AQ���|s�v�.�֎Ns�b�[>��^�4�6r�����;��{X��Dh�Lٮ=��N�O|�EH˝��Y�Ъ�rv���w3�L�p�F����`7�]�}�p�y��N&]�y�'�
]��v��̮F h��N��Ҽ�eF��Ҟ�]��pÎ �yǝ��5EƸ�G�\i��$!4�)�"���aQLv�5�(��a�	LuA�VqvyZ�@�~:98���Rr��ג�	��-8��vФ�d�/�I����9��/b�L�>�����Ce6���T��W� xi�9Swd��pj Z�].�/����P7{2���g9W���f�c�D�I&���}sC�f3���H�f�1��6�Hr�:���p��4�<��+�mK�ի����|D�;C���F�{ܼ^���35�*���&`?CTv����(?m��}��M�s���I�yaC��c������뻷�A9jE fj�K#�}��+}s�9\�(3�8̫���M��9}kH��L�^kO f���hמ��->�<-���'����ܳ'cl��'�>j��%�XRÕ�\�~`�9�l[R������&�<GLW���DV�z�n,VO�V��@0���[o�>?�Z���{3�1��:�Z��'�	��\t��&� ?�Zh����N�Y��,N��v��d����/��C�[0�=B��f�Qn�#�,�{r�}g�]�X=�;�20b��G0��l��x{r���p�Vu.�g�n}�@8+M0u� ��g;���s��o�8����?̥ʁ#�S���1ƅը���颖��y��e��"fpc���u�gc��l��a(��#,��z����J���9�|�2�T��S�6�_J��y�L�Π�U
v�����N���7����͆��=��NW����G��zN(�y
4D>�<�+�K Ҋ���~OQ�R��A�):5�}�y�-�E"Ym��[�>�c&��Ł�(�a}ր��a��f�.]�u���F��z�<Q+�0�^i0�Yp<A~�Q��y'���v4f�������|r���P��k���3��y{ً����'ך����e��t����^g^V#w�^���12��C�~�u_�ZsI�U.��6�m�n��V��jx q?J������C8>v�JAK��<�zT<o�è���>m#�_N��C9�If�y<���ӲS;��R�%���IGv�L[*z\��?�?�e,�!V����J_��&�+zy���\]��p�ٰ�M�^28m$����g�lc�VC�jJƘ�B����rR���=� �Y�x���kqY�j������Y�䨇��O¨�����Lѝ�1Fi�E��:��/��+���Q����f����w�9��~X��p>"��2p�k6��n��2G\�r�f,<MG��5<����J�"��m��p��#N ���L]%gd2A%G��9��c�_<M!x-�*�'��\�c�K56<�������u,zÔ�Y�ih��n�:�rF���#8|��{������Vͽ!HÁ��
�����b����=Ly�E7�qk� ����������(�e�`U�V�ci���}�@4��"N�N���Mm�^��.�.TEj��YvS~K|�bW%Z�1f�1=3{}��;g�|�M��Y�F칗g�զ��ˎM���Dw�J˙���lzA��'f��d��>�f),���2飗C��V����	H0�I��X��kA�Ѽ+�5����+-�����Vz�A�5�7
#�X��ٶwbQT0(��7n���fB���fU;���9V:q�3��Y���ܩ:�qd�"��y@�*�5��i�����-	��*Q-�?uQm�ڇ������د��c�$���_)^}1<J>慃b�U�5��'w2��f�	e�Z?���x��]�q��CU�m���7��Yܿ5p7;cN.�=(����OE�F�!�wg#�״��>]Z�����#�Xq*n���Cgem��g�a�o��|����.�*��i^���B=\�~X�r%&<s�Kk�4b���U�b>�9��b��e��r�I��Rl�e����[d�AC3_$�Ɩ�Q_���	ts<\�h_��N��-$^��l����p���/�sZ���q#�$H��w;~��9z8��P����"��Ӭ&8�iV!"Gz.Y��iQh�t�H��e8��3�;��y�x�\r!��4bF�h�"��me�ߕ3ka�\u���W)Z����7���#�]���YF�\]�|�'k�ޞ�g�Um>�e*���&��;�e����������jp�zx�f�ç@G !��|3WHL}�*i�{"p�u�.���e�R���gj�r���(�;��r���ǌBnٛH��'|�ǵ�e����'��^���t���H�"o7R�&ZuT�)a��:��l�i{�;L��ڜ}�a�&���Ǻ��@Nha�^QY�▇���i��M���~�8^m#6�辯V�J�>��j<�����C~��U)����$~�u�%����a�,#q�F9	F�B��/4r�7�n��j�D��j!�3[]���<������uI��?�H��s��$�2��i���a��u� �:'<��m�=��$3���䔙3-�~�o�U>xb��!���'���Pqٸ�;���K����m�3��[_�@��i�Xl4n\Q�ۛ������>m#�9�܃�{�L�|�Fg�fټ1)#����
�����q�f
3��4��z��jԩ��q=�$��k'��Ƕ��E��cCZ��䇃���̃%����ӧ�|\ f(��B�.29������Ղ���6ҩ_�DN�u�� �5?�����m�%���%{�L�NGT��B{.N$�:���.w���Z�$��̝*NҺ<�� ����K\���d|��GƅG?_�6HF��	��̛rhR�e�86���+���t!��@N%�z��q������c����!خ��ؘ���S&]pS�F�n�j
�����ygQ�>8z�r���l�K�2x�<���`�8A�|��J�V���fC/"����l��y�)@���j��kEN��T��U_4�u���j=t���W.��I��gq���iȱ�J_�t�0��#���cY�mu�B�%�уA�*����v��jӡl1��������v	m�giƱq_����8�����d���������6��H�'�c��K��r��-=��`Χ�>M�����g �-f�_��̡�ltp�I\ռ���"��#/�d���Q�r�W�W��v	\� p�R�N�bO�\�GN���_>���OO�ϛ��s�j�΅(�x������>�E�s�������f��L���9*��V�gO�ބ>L��~ЎWx}@�&�p�B��>���aҀx���\����6ߏ�>���Y���&����M>�`	�i(L�Z�Aw��z&m�>��I�#j�(�6|��b
"n�2��֝��������,�-���d�e"+�Q��� �\cKG�O#�
O{��KLa:�8�ΐ�Qu�j��j��m*�*�l%��1Y3���!<(Glr���q+8o̲&�΃rzuup%`�a	�\V�����$9�|'N&���S��ASgt����^����a	?D&O���kǲ��2.!���\�X�Ĝe�1�Bճz�n��7�
�2�Z^��˭"�:]���Y.>����^.g�;!;��l l���	�&�Y2)��	+y�1�w�?�߼%�C$���B�aWR+fy]�Ҹ�_Cl���LG����,�jSiw���L�b#a�����1�U,8��(�B?H���~�|�H2^������&y��ɵc��B��V�L�����³:��i�C�*�`��J����kO̖�(v�����BB�"s�Gc���y.�,���n<�5�Pe��;��p�Kd[�d+��U�� f�49�����l1��ϊ3�H��{.7�nC~'�#���0c �5Ar�i��� Y  D�-x�V�i�)���R���	�\��M�v��DDDI����� �`����/�v����u��׬j].$/�SL���j�YT��PZV�ښm�c�.,�T���.x72�#ׯ�X�t��f��
1g�o��W�Xy��1�v܈Ď�Z�hm��ϙL�O&���2g�0yMM~�諭�/�=��Aȋ��f���X`:���bW譠����jW_KG�u/������C��|����ǧ�[�o!��0��4�.|�8��z����c�9D�dD�j���o�B�>ꅪ�7�MK��j��I��z&���s����I��t?�<?�~� � i_- I�q]�q�{O)��S���������WϠp��&��̡�s��t�"4��.�6:��#�(j$e)��Y_;����c�<����̡i-�u����f'b�|�n�f-h���)J�o+���Bf4:Wl������~���ן������@o��忟F��g"!�d[_}�_ �sI�E��1��he�.7Ҹ�9�"r��3\�dc9@ڬg/��r���-�6đ�U�̰s�WL����+6s��ݶ��觟~���>      �      x��}ksǱ�g�W�S��!4���%R$A�����T�HK�$R������o������^KtŊ%`�{g��O�'�0�G�S����jf������c�N��b��=���+j�|lq��0+&��=j&�,���9Y��s}�����������_�>}�?��hbf�������緟o�}X��}]?�=܇�~<Z..V�����dB��؆lj����O�LP�G��xQ�B�IǏ>�t��tK�)m��B�3k�err���n��q��n^�<Y '�f�|>��q��o/�f�U�\-���p��äa����g�r��Ϸ�O)l�)x1Rӂ3������|y:Y��&@뻧������������Ώ*�}�?��S��{�L��l��U�);q|2|2�������+ΑAf&��d��-�B*9����ݷ�O�b�����������?���FϜH`n�ϓ�±���������۳���'wӗ���߽�������_���e�K��̨�FN^������e�W&�YY׿�?�*�p�y�۽:8��,��.<�@C�6�f���i�,�����\�A�^�N�߼L��¹��Lˉ"�ɂ����Kx߫�ż_ 2@ `�IT)ۇ�-�
�Er�uͿc��Z�k"���p5=��..6�_�l�Ӌ�Ӄ��j~��/��7?�O��D���D�iu��mQHPs3�81<�bX6��P����@�0F7��s�!�&���K>��Q59}�Y׬�A�M�:ȍW���s�
^mtD�
��0�y8�Q�ü�%j��)���}x�������d�y��7T¸�����|e
��gGH��j~xvvy���`}�����������QQ�3��>AU$N��RpP���o��듋����̸g�-FȈ����="���<��K.#
*���+���~A���x_��_֏OӇ��ߞ�XPˣ��=9<9ħP��
��DQÍ%RC�'܉���Ne%Yjh"�(���7<(8� M��X���+��+�h��i7T����پ]�XT76�:jJ	zͬ�`�bO�֜�9�T�_8�ᨼ]{'�q���J�*��vdW�0<���)CI���f�����=8M��Ξ��s�-c[�<�N��(�%�'��:�6~�y�.�R��-���&xB�N�33t]ls;կ�]M��=q�������������=}{��H��2?<c���K`�����h���ֱ"j_��&J(P�j�K�Phelb{%WJ%�ՆN-{��0�2����;���t�?�\1��d��F�$�#���/�>���xW��H�����������RF���^~`���p�h�M����s33T����EK��l!{��-�'нy��Ht�$rČ��0�M�|x�q�EN��\[KMm�6� ���b��?�[���u�:a��08�������ųﮢ���w8��[�K�0-m����>?��W.�%���C�����3f�"iF�&��>ב��"��V��c�i��Jl;|7�ȶS9�lJ-�Ԇ=?�R�H\.�ʌ�E~Wu���i�Vp���F�W����Y���g#	��p��;Ic�@�K���-�X@��.�哧G�~��� ���~y�y��W�gr1�U����w�w���y�������8b˛�����|u}~����Q܈�!��5����˗���/_�2?��(�h�!�T%��6��%��p�	ЕU%�3����C��h�&Z�S>�VnP���Գ�Ez���km�[K"gh�������%,N����g���t�Gɔ��r��r_��8:����U|+/M���ׇ���+/�_����ctH�)����R����U���!i,8{��ۣ� 7пH�5�e���I�fϛ4\m{s('")h�#-.��k�Q�uAKTYL�m!��_���6�/W�O.?��~�0=~x��p;���W���� 
�/����e�	�O!^��e�� .��2�,���ץ7��
�G���gg�P�O��ǕO(�҈Ms��������_Ӄ�����6�٭	���:u+!���Ň���[��Mz{�LmEAz�x��p%����s��ҵH(\lD
L��_Χ/�����ih8pym]��)qw�C-9Ro���M�6Ko�vw���$��*cQ�,�I��m.�d�zw� �m&bՒ�Ѷ�m�hN�������<^[wKdw�'Ec0���Z�4}��p�a
���:1����j]^�t���tt� �[n{�H�3�A���!��!pm$���TRpFSc�n-�ۛ=��Ѫ�|q~���݇���v�^gVaMå(�te+"�-�bKp�f�*%���G���X��'����~&77����-�a�� [g�p�Y&�<|y��急�zx���o�_/a�M����B%�D�b_�x�q���,�8^*�k�
[ݶ��h���a���IG�-<8�i�Z�x�X�+���Lʹ�/Cj�]�C����g����eEC��f�������`�Q�����e�%�}�Ai%;����H�D��/[W~ؓ|ʄOP����D»9<R��}��T�|�������9�rۇ�ե�ѥ��H����.u����5��o������Ϥ�XK��L6KO'l�~6�3,��xxl�1�'��.�f��_�1r!U��=���Ȝ��>�?��(��z�A���kb�U�֑I�DR�a	(���i�k�J��\�=�-iW��m�*R�bJ���'��"�,�J<�Z0��̨m���m�!\%ؐ�9��fKS���hVf�6��b�Pl�N���4H99V��g�d%�3j�2�����`oD?�zG��^E[���њf��\���#T�x��wl�o��Μ@K|�Q$n�/�0q��;�ّ��7�'�w)w��C1)�����!ުq3<�]��t��	��x������S`!�f����NB����r��o"υ��r��v���
���q��@�-E�����>�ggs&�gBW�cs��2P	/;pu�<���b��`3UaN��8|�O�M��E���L'���i�M�N
\��#�NgZ�ʹc�r�q*J�Y�(՗����vrߕi�$�;�/����W�i*�&��,a4����}SU�{LN�µ��/�A<cE���|j\@��R�δ�%��X�Q��y>��Hģmd�dt��>�~DxN}��*�.�	��8�ߘ+�Cȅ�w5:��Z�U�+cL5>nZ|)~iJ�"5�9UT�)��)O���P�-w�͘��Ÿ́2��������^��By���!��`}��~02��ܔQ��%6x&����0y�����/b���c�4H�C,~�L��\WM�i
o�F����_:_5�>I������L�>�q���5rN��?�GRQ�z��-�e�_r%�;UW�/����5��BA�ޏ�E:ڠ����I����{a1{�t�|]���E�2�;m�Ó�ġsq@�b�a,2,�$tàt�"L��ج{���+�I�Q��M��3w���RL,O�g�t�^�&�{�=�t�\��Z���k��Z���$�'JiR�^p>Һa��hT,���/��栥A���dD]4�fר6��xըʘ/���}��>G��F���v}\u7�r��tخ1�nF����Fxs}rPu#h>+�VQY"���˺��GՏ@�9;���:�!]_�|����p�n��.�nu��.N3��6Yc8�V�6�[�4XK�h�M�j��*r7tZ�R\�{nV��+i�E*��aI�K��Dv��iJc�J��f'����|~p���i��+����X�d9cBP0Zw��U���$E����{�O�fY�S�z�xS�k&Q\���	t5p�M�U[ͥb���+�i-~lզ ��q�(����z��[���(P���^E�||�fD�%#���)��H�#: �3÷h��G�q3B��虔�ۤ9�e�S��g���Y�5�\�SwTP$�8ru_������e\z��z�~�v�D`;�.��pkL�P���j�-5,INvx��(:ïF(�)>k[��    �䠻�ѕKx~�W�J�6=	Z��(<Jad�ccr�P"K:�AM�O$z�7��q�q�d���`���H�5Xu �]����pg�h"}�	��6���>��K�1~�+S�5�_;2":�(�6��8���Dǚ<({��B��l�����$�AФ�c���{^u�F��~�«���~�tݒ�H�c���>-y�O���b�;�.�	��C
�����.Z+�n��8��Y�o~�ǌ�ѻ�u��#�~�zƩ"i�˦܇�̱"t��=°e�I�!L0�q@)�J���&j��_������q��i)ǻ������]섙ă��!�>�3�@�_��&�D.�9F{���r�q4�����س#$&zb�U��:y�z�>��oK�����X���J	\Z�޿o���B����r}����姐�B^�4<#�<�=L�)u�P� NqF�W���$�H�q�H�iV������&��_�͔�
�\��������r�+�wc��#g�,��^߯sk�ƪ�aU���u�N�epU^��X�Tp�:��©����9�ã��2��i�R	�F��̪����Cb�}C%����ߋC����f�뿧n~{7�4B"!%%E��E}J�:/��8U5rG��k��	�PI��Bo���aZ��~U��p��ٙ@7oP����8�/�ψryu�����誁�<�}�5@]�M�:":��4�>|�oW�NCS����� ��i����t��iZG2("p��,xs��j�`4����������������޳��n�xH�M
ϯ�>��&"�I�R��_�I%�J�DA���x��¢%�n�M�/��~u2`QA��o}s�"�c��}G(�D�6-4�+�����׏Q7��?Z��9@���y/Ju������-k[�*v[��f6ܖ��E�wvWoiaa*��B���Bc>@(�!�����y�"��e��9�v3�'K)�Ĳ{��@D�ڂ�� ��d��s�=�&�����������*���᩾��PW�]EYai���+JJ�gg����|1|^TZ�m(&0ץ�F[�5M��XEth�a��@�%�G����D��/Lw'���oԻ�Iǃ�K�~!�B��Q
GX����ŏG����ȥW:w�H��󉃪q���{�cR��4��H�R��
�Q�{�`�Z���Ɂ�p������ì��̇�?���VJo]��M��5����ԛ�wD=��� �e���������-��o�sÉ$T��S�hq_���uJGyg��s��'lU�䢘nբ{x<��n�]�BE���}�-6�(.ѣ:<V
�z��M����ְ����U!?�`�Dw!�zt�����+�(g���'��!���~{��4}� ��\f�����A���@/|�vP���'��3N�% i��l-u]���8�gg�����f$]E���d.�F���������"�Pڳ4�ċ_�����b� �G�*�#����B�6=֟ƙ&����\x��#���ߦ
��"��-xT���x�$�c�@`��<�����6B@���*|a��7�\�ߔ�p<˕��:vqL[������.J�En\#��6J# ���O�	P�5I�����K�C7���
1�0�/�x�����y�������ո�UiV8P�B8RMِٙE�W%1��;I�C��{ʆ�hha���x*X�,������.y(Ĳ��{1��s���"���j\}���ӿ����,�!��Q��X*o��&B��rCy9�3��C��#�2�#�Q�$>0�Jq$�J���c��UӝL!B�%�2�H[q��p���i��6�@�/�V��:��@K�Q>�u�@&N��AQ�tѬa�7�b]�v-N�w��f}>�I�w�GG�DX���K9<ޭ�Տs�A1��%���I2�����P�-�|8��{���K��&7T�9�(��jϨ#�`�S�8<���e�	��F��9�� #��0 ���h�L"�EŤ��\6-��w
�#;����c;k얍D:1<�*Sr�NOA�"�4e�4QY�HQh{tn�^D�����9s�MZl�����#�p�v�k�0��)BeKt�D_o�����O�w$a���Zn�e�>��	7�t[��+nHz�q}a�>�	A��E�5�Tl����t�c$ԿӐ���/�>�3���I��6	5D��Բ����nX��j���ȋl�B�1Yz@�B���SV�1;�e�0-��>�&mS^Dz<�lǞ�n�3�؛D�b��d�]�ܶ��a�k�v���\�z>��l�p�}}GD�|u��H����Hj�E�<�fU��,?���[ވ�v���V�vWY������B �����̥���u�����I^-�F�g�]�����w<��]���z��g�;ŴQ�v�ܳX50�t�j�̖�S�o��=`� L��'�ˀw� �q?-O�~��/B�E�㻓A^|��z�vW��U,�sM)�7��Q4x~�*2:ʗ�6��B����g����&qW��3�Q����!��w�P�h����A���0Di��yvdE}�T�C�%��[%EK�����/�v53K9F������G��`�����Bg�e/����������>q���`���ӫ����~�[�?�wbgNON��0cU�8��
.	8u}��q�����M��I=��!�E�1&�c,��c���/;�-�xj��oŭ~�O�{�K���iy�$]�����xɆ�A�n�
jKΌ4)�_?���+-e��7׫��bz�88��[~�G�
�+0wp��7����S|����������O�\#���M+W.��T\v��M;W�`_�-�u��9-_����6롥��������n_Z����[�\;\Z;c�0D�
��
�o]/�:79C�!c�NG�HGi�?�#��ȡe(�|�|?��1$k�m�ǎ9�p�6������Q��ڷh��w��|5=5�O>��ÿ�Ͳ�eib,���]|q=?��Ϗ!N_�]�>=�^�z�My,0�umZgA�AT����j���x�4�5~5����X��NN�S�N� ӓ��OR��_]�)cp���8�u���%�@�L��'\/H3���������
#�J0��)U:�۪v�_�U\�CT6ܔ�襯# ����'�d���G���DKD���F$���2cMYӦu �5�m��4�h�p��t�'��I�A��xD��IH�2�:���������]q].L>�01ʅ����%!�m4-M�ۉ���m	8^	�dLň��n�"��S��^������/������n�~�<����%��-�n���?Q-������*
�/��x$���<�5F@_�n�X�8��m�X8XZ3V4h�AK����|�
�p��D"K>,���yX��'M̞O�-KG�	=�b����QS�
�X\������[���u.��E���~�"�!h� e��V��vu��x|�Oϧ��'���� �КHY#��mW>�KNZ2䁰���?42x���a���F�>�3�+RnJ�Aꬕ���<+؏�8���n'-�
���Y��^�g�d�ۡ�O�p��BoC���nb��;�iˁ�&r ��O����]9�LC^�Y���]���
s���./���`��-��s�RIpLjw�R��F3�MuY*�R�Ezx1"�!G�I3W�ߒ̘�]F�M��K���/�n���$��2ZQ�0>�#����� �-�8b9G\�4l���|f?�r�s�8t����H>�����Љ�!	��i���hW��d�!�&3,3��0��wȑ�9�cM��-�`:8R�#Guޞ�����v�θ2n���~6e��e.e��mPm�'��)�'��x�(M��IԐz
�z��h���Ρ�ϯ���'�����N)���I��̛���j�7Ļ�c�|�Ϲ$��H����g
�lP��T@��Tǅ����hg� ��d���[ ���_���{���ԇ�[�?F    ��ՋW����	Ğ������@ԛ��*�l>V�8��	�w��\�����0	�Z.#�O��yq�����͗ƇWo���j~>}�`2�G#����q<8��#!":;����l+E�A�W�{������trxqu�MW�-���[V�c�#rWAFA���q�3j�Ғi^!b�:q��t\̉;�$1�
 'lӥ��V�k���'������2M~�̶�������~:
�](����������~(�ҩ��707��/L `��j����_���j����)ؐ�0(�f�Aɱ���q����Iz\-J������d�z�<��xu����p����j��v��DOi��j;z|���3JG����� MW�1M2�%���;�?Y��'h������hyt}yqq6qX�S����o!-���|L(�$tp��TB�Y{=��-	ѯO�/�ǧx�:K������(]��)��hE{aDU�}\F��a�-\�x��4�@nA)
���^yS�Ϊ�-؁����r�4֑����	��\�Q��<�'//V�ϴqy�e�y<FU(�ȃ�([�.�rP6:��:�lB�65A6��O�.�}�v�lh�g�����e��)2(HӄiJ
�rߤ���ۧ��25������1�;�T�j[a����d���#8__t8���>��qXق�������#	�_{,�><���ڎ^���Y�:��ZY���(�=㪥��p�QQ�!�نY�!�
�Z�Qn�,Y�������@+�&O��`���sF�|0:�Bs�Gύ��#�t��C��͈�h*(�K��"A�Zv.#��M��P�_@9"���(�ip�-��-T%[B`o( ��FkY��7��,��G�<N@:��c���x�,sqy@̆X�kH�������i������"�m� �E�2�h�8b��Ӈ'ץ�D��aJ�+����o�W�>.�qc)SY>��sZ�m9�����&i�Zm+|f�rx�D������
 ���]�"��*��ҡ��DgX�l=����(���ښ(C@��r�4 ���(w/th�c�[�CѰ������_%����eY����/��'��[�˘c�-�P���s��������Ò��}��NR��gE`T�u��"G�8ʴ�QI]ć/^�x�G����6�i�*5�����̕Aѵ@
'��e�:��p����)=[�},l$�i�?�_0��T��Wo./��������r�8:ZM�`�Ern��K��и�hExɮQP��3ݦb$|�"1Dsú�H~6�:'�����!in(<��lD��q�l�xWj8C��7B��bi�7D�榴VpD�4\���!q��
�YW��~U��5�޽ϑ�g�㑦�1(_�s�i}�4}����Ӈ��������]�Z�wwń:%���.��K�m$\�;�̈��e��V�ݰ�B*Kن��}]$�bH�1\�%K����2F����tU�8!BF�;l�3����n	�E�9�솣
Ë��1G\��}�>��Q��qsP2�v���/�D�{�w�Cۣ���6C���P?Z!�.�c����=�9�!c�)�aDQ֐yL��e~�aR	̋�X6E'K��,��p�t,���s
3��s��մ.�]]Oq!A����<e'���l�k��k��
Kn��Z�`l|FOw��)�XF�oBk�@[��s�POa\�y��6|��>|u�Gz��uz���q���uGM�c��R0�X��	��*4���*��Qx�L���b(7��A�#�l��m�������������*>�Pwǰ��X\ZM�fڰ�Uw*���D.���YP�����/"f=����E�����/�0��CÎ WZXl`�;�8]�M���pM1?�÷�~B�ŝ�ar�������I;�R���EҊS�q�mQ���9�����L���tk�!"��*�Y��c�$~���t�+Y�Ƶ$b��s鳩c(R��M
࢑�����l|��������f�}�o�K��w�G�Կu_��������E*Qw
7%�8��jȧd�lC�l����n�Z��7�Dd�C���jp���&��32��-�Ⴒ��%;AqSS�� 7A1�3?�ӕ,��]ӕ�h�,'׬lW�k!O���ÑK�G�3F�O�=9d&e�^�X�Uk�(J���A���C��"r�(�5��(����{Q$s�R�ۤ�?T��eܭ�T3���jM�{��~�D�F4�����+#�#�J�8����11=Y<k� i��UIK����˱R�|��S��!vA�s*�HQ��gA��ӎz���o[x�cQ�W�̯�<8�iŹu���>�3m����^>�������tDmb.T?dfF%�&�&�>��nɍ0�	�nt��9���L#��Hq�r`=�-bۘ�w���+��ޗbf5ǵi�Ks6à�fSvw1<�y��O�u��
�@���,*V��]�,�VG����|z|9]\N���s�C�͹�&QҲZ�4;�������{5�R�)���/�%d#'�Ë���H��y�a��@$"��ۋ$de(�I���I�1т���#�� Wv�^2�Ďh����Mp���.��q9�SZ:9X�k�Q�W��S��t��{*�|��텐V�j�����4�_�c��)�5��h	~���x������N��D�C|&p��
eY:�c�⇷6�oj9��&Z]��:b�ʙdਏ ��g��\*���C^���5L�u�i]��ֽ?s�PHM�;.~:ZM::Z�Q�����:�,S�aw��h�!��AT8td_�p���n���[]7�ب�+8洺kp��..�
v_"� ��C7�-0�%�����|u����_��T�q�����}&g�M���'��g�z�7TD��������򎊎���
�E�Ipk�����$�A����)�1m����&����'"�C��o^�&9~(lɡpM�ZIM*A��W�����au$��>�(m<8]rr�u�=e|�w�VĻѴ䴸���%ǫ9Fǋ�雟�'׹bhҖ�s�Q&�-��e&�pJ9U$���X*Ej�?!�+N
��s�*Pur��}_�=�'��o���bMխ���y�!S(��[b.�Pm�yh�8bQ��t7��K�H8���'����nGb������?�'\b�������a�/��NM�JZ3��۵�i�y�T�%�Da͘���1�t�yn�Yo
ó��ӧ�{@�/�����`�j�(6_��s��w�	��s�{e!���H���
��~�	�����)_�Y%���W���]Y���W�EPK���=ux/	��+R�����~����K`��7�,�-V�������ϽH���H��rש`d��x[�iol?p8~I�-Y����c�<kv��M�jT8#��L���[��]u�઻�ȅ�8���y�f�1�$[��&l�5�m�DV&�����7){>\,nB,� ->����C���mtѢ����]cઊwu"e�i1���qPJ�j�=	_��`;7��agOU��9;\�,5R���n���?����}W
�aDk��'v4�2��M��v��E�;��w��P�Y�������N�6ɸ*Z��h�Hml�w3�Z�e��P�P��X`Cx��&lB�I�?��j��#��Y������s�����1�}�����L"�yk�@~���h��ڝv���ߘJ���ǧ�q����I��MV
���+��Qs�+�ht4�"��ZV�����TL���AR���t��������	V#z�k*&�ٰ^��(qi��1�n�҉�������&r9�*@��$���v�<��^��Ie������8�P��j�i�*��&�*
1Œ�����!bR\6�e��!�w��X��5��ݗ���Nu�Lg�O�㞶�g��5#S�}�eB
.a�&��wm6w�
w*nrTqޭ���)�K����F&���'E���I2ٱB ?��f�e�D��iXIE���<�)� nӪ3j��|��eG�����x�y_��5U��    y�ގ�A�N�*)���	�羡��ᷧT��etD���������:�C"��_N�b ܦi�l������z��a�ƍ?���|qmI=�������? I��q���E�� ���+WX��S����U<xn�U�)ⴵm�h�!~C��KD���舾&�����o�����[xP�n��]�"o���:����Y�fRiĐ��ʈ.	��p��к��{V���҅]и�Q���)��
��R�-�u+ɵ������n8�$ÓR��X�����Z!0EG<�������""�ao~��SA��k�Jt�F[5d�~�p?���C��#���F#]��x�<��uy��&TݩA��n�AD?@���D���Z/���uލ���"T��Mx*�V&!��NJGVvQ�
���Ӎ]�H+Kay��5ݣ��5N��ay}<x�H�7hb�vM��	�]�g6$b]��*�ē���׷���FH��}�w.o�6�\�oc�]������t��P�.�@���$
)Pi ��ne�y�^�~8H�"����(R���JZtk�����T���l{o���p��6��B��߂@�A�ՄX��-Em�K�y������q*�(G���_V��o���Y�Q�Y�R.	��R4���T�E��\8�zSA��ۇHMzr���������v�?D2�����ՠ�&q5B��-�$�����.X����E�X��`�5�J\kq�4��f���2R(9�L�k�t����e~oq�j���Y��T���S��tj�xm���氻�S�vm͊&�7��8M�g���z�t�'�q�S��"16do}��D�Lm����߳f��$�M�JH]�/�<yɱ/A��,W+K^r�7�y���(>q�/�
�
Mz7�%��<���T�!����lZl#�z7��hoq|x�� �t���q�.������`NV��+�~���k!/pG��vƳ<�w�x��iWtC�\eR_�>|{��U�!�Q�iGC�Ue�7���d,H/^���,�u����{=�s�vmuu�|�C�*'jꮦ�����o^Ү�|KJ�cj��k$W�c�	?��݊w��vӈ11�����������X��j�FH��-ʛ��i�N{��4<����'�P�`gf�)o�g�_��*'hH��8�e�(Y���A�2��Dg��buy�r�#����#Z�D���v��$��ev�gi=Y��d��h�.��^��oc�(&٤�<_.�W󒒲��H�+��P?��(C_��;p9͔y��|2�,$�ݑ���|u���Ȃ�(e���{�6ێ<Ϸ���tf�5XN�F:dVON�O��j��P ����>�<-;�CCO�c�����mƩ�4�Ku԰&��=���I)(W/�Ë���0�����^|G����F�Du�%͌
	�}�:����tB��Ϙ,|�I{��;��z���ˣ1��a��b��4"�$��qC�.�Mv�%Q���|�<8vET��UE� $��[z�$a�-7��W�$�#����J����4��s1k�}K�s[��=�~^?~������=�����������u;� 5�B4B�x�K\��͍��M����XT|r~r}4��8�q���r@
�-�OЙVDA,����Si1���X�7�T����
2@��)Z�*H�Ʊ*"���huu4+<��<'~�X]#��R�8�[դ90�
�:)٩U)&6�,�c7�����,�q}O"ڏk�Q�ƪ�4�iFTKB�KoՠKKo-W$w�<���#N~{�a����mb��u���粼�^��i��~�D��ߗ���ɰ߷�S�~_��t���Z�3��*���5�%r0C���6G,Ȑ��yB��Y GƤ*�сw��(�β6�?�>=� �wߞ^p-|�3��ӵ��\8kMI�0��y�u���u�Bpj����,��jg�0a����iY�8=W�p��a(u���&�I<�x$H�T#�8oN ��4ȧ���_�\�{)���&�A��jxy�f�x�2yxz]ڦ��F�Z\�`@�p����<�A��8NP�B�A_��c��O0�&�K��2w�����؂���A�
#�����Dte��EGBB�l_}���w�����KƷD �;�	t#!:7�ϔp�JtF,�N���:yq��6��X/�����a���v ��7T�[<)=�g�Т��Iq�^�+$-K��:r�@�PC��J�s�j=X%��~���TЋ�GbJ���
!����Ն�&0�#���fޓ���\�`�l(�1±-������TR�Ht��R��n<�?�FE?����l�5�]G����+$&���x�,F��h"CM�,^]4�>Ņ�R�ԃ`��nvH���X{W�i���G�D����&�G��ϕ��mA��������WM���v�X�<��14�Nuַ��oG�d��`�M���0x6�cZo"�+���]�x�n|'��yNb�wB�T�� �s&�S]�\�?��f���ʭ`8<���d�����o�>-���__n�o=�F�L�z7��2���ϗGl_�YMr�G�m� T�AGU$>��~w�*dɶ��1��BO�#�n<q���nk��������$��xy����i�UR�0��,B���ѽ��o?�A�i/Y�G=h8�}�2�$4dL�z:�����c=b�7aW�����ђQ�1t�v��r�E�D���eXǋ�~�A���l�4�4g˒��gk�~�����~@(c�!6����lsu��;Gl�[<�~�P���?|x*P%n�P��5_�`L3Z�J�~s}R���-U��m�w�Zj�%v1X�Zȡ�~kQ�{��]�=�/(��=�u'���>)��zr�yiMH�����L���ԩ�%K���\A�}!f�[\��IES]n�P�Dmy��L]<���� qȻG���\Ph�g�U=�ؑ�Q��ʖ٤�dT;u5"�����#tUO�ƭdssõ�]=&�X�����j�u�
!��C\}y\����do7c�0^�y���������,iѥ��Pm�YyS�s�0��Й*k�oa������H��,H�g
L�b+�4�<q �`XN&�"(�*�iI�X(��AZ�:�J�>��̕����qO���^��_]v��\S���XSTƬ�!%n���=#��Y��F�+������b8�t�H�x��n�بv�!n��S��ZL����b�%��H����m���XRU#�����طlD�S/<I�Q�i�g�HF2�u�e\xR��fӺ��K�z�]"������щ6�0�oj{|W���X�mڹj���N�ӓ��+���Ӡ��N�Gbm3������q����Кnd�䗀�U���ư<<��VfW��ɥ�)�Ҩ�H�9_��Iڏ�aS3+��ݎ��,�>�K�0St>F��aw���s�,����?Ģ��:�=�%�~=�&֝��������������������9��΋bT$y���,���#t�p`�!tr�r�p�.�i���L���y�h���a1*Zʕ\RQ،�*�)
Y�!kV����
�x��ԚɆ����p��ˋ�i<�ά��SF� JU�G�H�@�����Ѝ����(܎B�j7�ǵ�����f��
K&p��*�D���~Nb��sA#�K���N�Z���qBP5˫��G�\]�O!��F*���b�|a��Q$�<>�$���Nh�8/q'tm�p�KP8����)b	��V�R�z�{b#Of-ь�rk��*k4�5 6u��]J���^Fv�0j��#��3���n�wDa�_�6�B�W�?�1Yj���_���V7KF���R5H�:+$U�YQE[vX��vV�ji��x��X�����T������}tR��,hXQh���	Bio9��Z��m��@Bq.I0��^�����v����RIY�]����� ^6SM����hZ�;r͘˭�S�}�5Z��g.�كw ����)5� �	  ��@�|Ɣv�*�xS�E��ڏ7�)��%�PKAH�J�v��������i�E#j��88����]���I>a�m��Ξڛ�L�B2L�.S*�Q�n��`��q݆�.�nP�nZ&D0��o�OC�������+1
H�D�׺��}/޵^�tI�ݳI��}FfW��$�<�V5I���z�s��Liwc>�(�����s�B�����d1���5�l���h�O|!���� �?���a6U2t���g7XS8����j�u�O�r���mع���7�H���nq\�8�p �dE#ϻ�:\oρ�y �x<>'c����5~�.(\%�㈔ä*s�6	��W�y��0��z|́�(�5y�tY��_�����<����^Z��)3�
����H����g������"ǏE&���}A���os�~Es&��ћ߮�%�PF�"wI*F٨&ka6��eTG�u�������"�5j9Ȧ9"v4�`���/�u<��9F|�,T�g#u�:�=����!�����^��<���~���??|��>޾�����ͬ#R�$B:'�i�]��l����Z��6�$:�7�D���/}h�k�8'�>ttU(������{(>/-���v����q��j#�&vI��ƒ�aWp�F��c��-w`�Ea!�� �Bk�n��c�Ӗ�p=��Y�w��&[���f�7���`T��,uau�N����
 p��[�����	-�x��ȃ_�І�� :�:���$+==�h�h��������c�gw��no�����1��hkЛ&��@HjF8�����
˺�<���<����4��RtY��P���dXDe�Ս�?d�dY�>�G�1��R���1���.�B�Azc�<�HA�F��$�����@�p��p=����dI�4m7���Y�zi�@��$�Ը�HW���K):*U�NzO:�'�d��������`�
U�lT����G\t3f;�)E�đR�����6��ӏ)R7°��Ei$�t�Dv���[ջ0*�8!7Џ��3=�G_���;�r^�Z�����t�B�V�CV��7��Ku�X4�XF�M�C�)]����#���b��g o�x��^�M����4��p��Z�b9l_�l����X/X�6���p[��'X���m ��&�4��v���u���1ҁT��$	����և���'�5�A^+�=o�{�HM����v(҂ut��z�矅�iiX�8�<У�Kb��I��ު�t�='�Rw��� �t����0����l�$�xq�V��d�*p[QE�z���6�t۰�}�0j�%�`������ή�:���
�Цl��t6_��Z�x��l�%��V�-dDc	Sq�&�M	�D�t��l�<Q8 �c�&����Q�@��X��� ��3MJ��XKj�7z�ƣ��ӈ�:#"�m��;�B�΃1���P��Z��k�j1V1�:TQ�� Ta���ZC3=���z��zB��M����'�P�P��]��R� osg&���Cv�k0���o�t�,Ek���+h�?{�e��b�5�:S�:7+p��u�zS�:�t|]O��|]�F 5|�e�X�`#l7����hp9�װ�I�M���+T}�U?⸂�KJ�@(���r�O�_�S�tR��W��Ozx��P�EdQIl�*�ʧT�QQ؄����6T9��'���Zr����%p[�a�������}��g֯�\��B�&J=ÉZ=<����c�1��z�� ��A)�Ì�A������:�n���=aOk��>i� "\JpC����G�	����/�;�!@'Z����ϲ�Hak4¢�6Y�|?��m��<
LJ� �V1�f lx�5ܸ?�-��@�C0��p�D�}i���]�`�K\᾽3�M0�ל�B��ha-�'A.p�4#��+h<�����@����?�T|�3������p�:���(�a�:��E��:�c����t4�:E*�����ك�znLt������h��2� ��4"�ͱ��c����4	�q*��1�2��l(rx�Fgدb���B|��.OC�'���
M���ɦ�dW��4w�e�7�����393
�r��
h��݉�y���H��)
p�v���rs��I��+	�R�yJ����>CKXc����%fgBADBvL��H�,d��Xr�-He�r?�_��0��u���-�\�զ�!��6��.���[��7-M۵�B�BT��R�>䦬���%�{Ga�\Q��Y��d~�T����m�%B誢Iءe߭��@�/��3"�GpF��Bu{Sն4��ch`R��4 ��TFm�@^uט���s��oF���5�V�/�d턴�����%{�������Y݄�y'�6󬝧D���~��Oc�w      �      x������ � �      �   �   x�e�Q�0D��S�	����g�L��]�Ʋ%K!r{������f�E�IOaF�T�ғd�>a�ohh7����a$u�h.J�3�̉T����a�,cv�H�mR27}�*y♂k5�%|��:I���^�L*aL�z��ߖ��r���i�JK���xsF����>	-ߎ��q�3o�͑�콲־ Ƀt8      �   ,   x�3�tK,�U�MM�H��,N,����2��J�rS22�b���� ��      �   5   x�3��/-JMNU0�2������lc.8ۄ��6�2��͸��ls�=... �{�      �   �   x�]�K
�0���=��
�7m�ґ�%��B��~Ӂ���|p�����~������F�3�l}�P/����p,�L� �G/j�P� �p`b��)���-&?����嫎4�%Dէ��!��q?� hhQj      �   /   x��J�I��L���􂱸��r�sS�3���Ē��<N7_�=... �x�      �   3   x�3�I�PHK-I�PH+��U�,I͍/(�LN��M,P(IL�I����� E�      �      x��}YoG����_L䞕on��vʠ��b�r%�b7.����/����H�m� {�U�y"N������_�O���I1Te|L����FeaBV��� [���T��CiY��\+���S����|���ś���]�m������\��.�l.����n�/7Xp�?3����ׯ�W������9o�6Q(�h{���Ň�ņVyo6�7�o����]��|b��߼����x��n.�\��:߰?`{�n.�i�w��׆ɍ�� �Z��6~��y��GKq���ͫW������Ŝ��X~ޜzw���`�
~����x�'�6?D�V5�;���S�/W����
�x�!����ԕxy�Opk��|���J�{{uIT�ן/���T����wo�w���x�ߡ�4m�i��l���i���G}����4g��e6�a����$����k_�=�d�����*_����t�y}	Kt�/��v�%2Q}�fu����&����_�2m��<��:�����^�:������/��g�_ ��Kd�`�4o�Y@��E��-?���`�	f�`�	�`,0�����ہF%���@Ri �<�T"H*$�
��E傢rAQ���\PT.(*���E傢rAS���\�\sD傦rAS���\�T.h*4���C傡r�p'*���C傡r�P�`�\�T.X*,��;6S�`�\�T.X*,���G傣r�Q��\p�3$*���G傧r�S��\�T.x*<��{�J傧r�S�0P�0P�0P�0P�0P�0P�0P�0p�**��ʅ@�B�r!P��\T.*7j#gmܰMp�6���7o��Mp7���7s��MpY����� ����C�shrMN��Q47���0Zr�hɍ�%7���@Zriɍ�%7���PZrSiɍ�%7���`Zr�iɍ�%7���pZr�iɍ�%7��܀Zrjɍ�%7��ܐZrSjɍ�%7��ܠZr�jɍ�%7��ܰZr�jɍ�%7����Zrkɍ�%7����ZrSkɍ�%7����Zr�kɍ�%7����Zr�kɍ�%7��� [rlɍ�%7Ö�[rSlɍ�%7ǖ� [r�lɍ�%7˖�0[r�lɍ�%7ϖ�@[rmɍ�%7Ӗ�P[rSmɍ�%7ז�`[r�mɍ�%7�V�l[q�m�Ͷ7�V�l[q�m�Ͷ7�V�l[q�m�Ͷ7�V�l[q�m�Ͷ7�V�l[q�m�Ͷ�=k���7��� �kM~ٚ��5�uk������ٶ�fۊ�m+n���ٶ�fۊ�m+n���ٶ�fۊ�m+n���ٶ�fۊ�m+n���ٶ�fۊ�m+n���ٶ�fۊ�m+n���ٶ�fۊ�m+n���ٶ�fۊ�m+n���ٶ�fۊ�m+n���ٶ�fۊ�m+n���ٶ�fۊ�m+n���ٶ�fۊ�m+n���ٶ�fۊ�m+n���ٶ�fۊ�m+n���ٶ�fۊ�m+n���ٶ�fۊ�m+n���ٶ�fۊ�m+n���ٶ�fۊ�mkn���ٶ�fۚ�mkn���ٶ�fۚ�mkn���ٶ�fۚ�mkn���ٶ�fۚ�mkn���ٶ�fۚ�mkn���ٶ�ǚ�knz����ǚ�}��/�&c7�+��jL��n�vs���ϰf�X�$u����]>BRw�I��#�
;N��#$U��TMK�*��R�Rh���h��Ri���i��Rj���j��Rk���k��RlA��h�ϸ���ʴ�A�j͈I}�s�g�J̈I՗�*.#&UYFL����TM9�<UPN�d&�1�����u�?Z����i	�r4��iD%K҈J��,K#*Y�FTj�N?P����Z�3,�dgXj�ΰԢ�a�U;�R�v�]�n�B����.pW�ש/pWb7�Y��5nڳ�]�m��g��߸��w����������O_'��w����Ì�Շ��3.Wf\�≯\}�q�������ͫ\R�@��8�R�p�r�J%�	�ʂ(�'Pj��@�)~jk�PW�׆N�TV�߼��#&��G�5��*(#&UOFL����T51�b2bR��T�T)9���$���@Wё5��cO�T:a�|�|��+�*u�'TjL��
�P�%0��STQ�P��:�R�ufUZg�u�ŕ�v~q%v�]�ak��:�ΰ밌{L��H���Tn��: Ru@���H���J�"�=D*q��i��ᶤ#$�7�Vt��3�ۂ��|�p[χן/޿ݐv&TjuN���P�5:�R�tB�V�J-�	u�z�
����ϰ밋+�3�:��6�v�q���ǸM�b�?V�P�U;�R�vB���J-�	�Z�*�`'�u��fP�����Ma�]�_ܦ0Ò�V���	�|����N����>Yt%�%��(�q�OM�O>��\A'�UH�>��\A'T.�>�\�yG>%�P��uB���	��['�uv�+�'T��P�BxB�*���N�밋+��6?p��w���
��*	\�(,p�����
��*\�8,yA��%0wb����9ߐyFP�:�rG��;������{�3�r�wFP����}����k��#(��������}_h�,4�r�A��	���w�F�u�����	uN�_�=���*�k�'�UxE~E����n�/7��N��Ç�{�0�r�FP����=xAW))���=u8?��ᄺ
���'T���9;�9@�O3;�
N>���C�I>�������:�ן�a�	��̈́#(�@GP�����/�A�_�9��߷|�����ś�+�»�&�~��&����&����&����&�廄^�����.��� ���������	����*���'T�g�O�܏�P���?�r?�B�R�����՛+�y��+�3.W�g\��ϸ\M�q��>�r�|�]�~�_������/7�_}%�73�r?�?�r?�?�r?�?�r?�?�r?�?�r?�?�r_�A��˜�J��)���gs��xC�����1���30���30�������L~ob&�:1�ߞX���y5�(����2�y5��߳{{u��FL�';br-���Ȏ�\Cv�\c߹v��ucGL�k���F�5�D~my]�K�W�G�5��~]���"��^�	�����K~w}�%��>��^�pת���.�["&\��D̼ S�����1��9��n>n�n.�ə��]�	����Jk�ճ	�+g,W�&X��M�\-������ȳw_�^�{���ٝ��;�0�6������u��o�,�v-\�[w.���	������.-��.߄K~�o�%��7���9L~�o^Mu�"2��-��T�<|�9W}GPr�8�*uǦ[]�Z�*�έR�ÄJ�qm�����jejC�gm����^�!
��A�σ6Ԯ�-���
�e���rYa���\VX.+,���
�e���qYḬp<Vl^��es�����s�{�?����&�\s\�9���1;o�tMWi�w�VmU�6�|�(����!cC��?\Ÿf���k&4i�͹���).7!����v|+�DU��J���)�p�h�jM<�?�A�k�f�jv(�Đ����lN�Ĉe�f[S�8���~�.�gp�ǵx���N	9�z���۳|���a��P���z�uՃ�q��.�J�_��)�Z_�h�,V���|����r�]�~���1?��?���Sv�YJ���1ZlZp-��IR������O��D�N�m��%��~����z�@7m�w��A���lSK�Y�i��i��$?$\��`�P�	�!��������p������y1�ؒձhM�֣Ⱦ��8ފ�(��R�>�AY?4/]>]�[ܕ���iq��P6c��R�:� WQ���%�U��U.�c���ڴFq���������m������p�l��RjU�q٘AK���x�,��T��XQ�0H��2���B�%ekK8]�6�n��j�Y�7(��X���\��!��t�V��Km(�F�USY�&�+�K��ۧ���(�@/Z�R�e_P)|*x�<I�d���w2
����͢�@��O�o������� ���Z��͛�F�P�7�d'���@1J������I�p����^*1q�;p�����(��:PF%�;   �6)ܟ�S���h�-]�%�B�01��!��.��r��kE/�Aɦ�>�_]Z(�P�.��W��U�2k�ۄ]o�}�?����ۇ� �qR��*��.
B|񶹈���t�@ C��i���~��7mޅ������-.����s�WD<��P�µE]k�C�/�P�{F�d�Jy��~�Ň���x��K��
�s��H�e�j��!�U������T���M�������d	��]��:��C1����v_��q�%4*'�l
#���GH��Q��AH��b�5�ٌ� #D�7_��f������!�ҁ݅6�:A'Ʀ�O('[�+��m�ń�
��u�$���PM�� nQ�w������g�PG�G�5Ї���24��Q�����+�"�hQ@lpT�!���M���s_��[�/�o8��!AۚZk��R���[�刖4���qh�T�����ݑ�������mܗ%G !��X-�[c����� �?PhW�]J	�5*��AvJ@sY\���t=)��"w��dt�A�hdo8�f�@� M��R�Q�N�&�x(���a[n�����[\�bǡz- ��m��,�ŽCzE��x"(�`.���^�䳶�<��q)䲆h�C�i���PjȾ�W���̓��D�GWi��$���I����n�]PuLM�Kˮ�9゠�HE��-7c��ҡ$��`[`����M������K���Wkwh3�,�CCI�ۋ�����-RP�
�¯xX'��`��x�c�q���r���<����3�j���:Z�`���hm�������̵�P�:;��r PJQ�V��`��Mv����&�������0r��*�\�iu���8��_w���e�C�+�Kk1A��2,�����:gX���iY��j�T����\���g���6�G��=�x�?���1���54��/�}�_�a��C�*�k�h �`�Z���g�TuhM�:���u���vY��[<��>�d*��h�l1hK�?Z`ٰ9�n�ƠZkG;��A��'�95�E	 ܨ�������-�:}�Ь�D�zhT�x�t��	jӲ��+q�
�q�v��������!�|�<�N��,t�)�6c�����R�KE�TS�J�}�w�n��5$	jU���ݔƈ��'�(���ʂ-��(�����6�DD�Y��x�U�7�4�Yg�펽���+���v�;5��&���)��s�mA�T���/P8LEp���U�r��M��#H���+	��1�sc@5`x�pj�i5���`�0��C](��,������
�C�}��9( ��2 �( ��U�IBl��N�����Su�}D{?{�����s)�(/Y�5{�f�� {$X�+i(jn%�+�:tWQ�B��c��Gg�P�L�Mb��ߖ�'�����So�hX^��(C�<�$\=�m:�r^oOϳl(ZBg=P�i����C]r(>�Q��!\�&�n7꠵Cd]2L�ߋj^X`TAxF���ݺa`�x���{p�~А:�� ���C+��qۓg|�y�l'1�G�Xu�b0�9%�%�R�V	�4�dL8J��������@[�4n�_q��x��$�ʑ���?k�{*7+\��?O4���2m��Kd�C�$9\`�g��~���o�y�ծ�@�z9v�0�#�fcz���}�޴`���S���wh�ߟ�ρA�)�A<xP^8p�U�6�/���<�U�0m%�Aw̋��v6C)>�mƄh�	��K��Q���,�PE��P�u�b1�d�s�;)��03s��X�|����s��>�*��aF`q�Đ�dEgS2F[�,��	t~�����!'�����C.�C����XL.0T	��1ŢUcS���?���Z?��[UҤ����7�O��^H�#r�8�ib���z�.f�:ѡ�b�o��+�ðn���r�ڦkܕ-f�#	@h������E%bB�(>��@A�`��	j�0��!Xܢ��ؚ��t	,�?L7�;(���uQ�&����K�Z�lv����Ć�� �D�6���]���V�Ͼ��ݗ��1�&��/l����r��C|�)�]��Y>���Q!xh��ܓP���{�?<J(�b޲&@a�\2�5et��<	���S��DڴN��ǟ(N=뱻>
���.j�! ���n��p�����u���=[��SZ�GD�,P���.n�Y��� h�w�e;��o��7:R��T}��"KXu0xoҹ]Q]h�`f��`���i���ۊQg�|�����q�]�kÎb�(�j\+i��k�u��wtzPV����l|1&`0�������!�.fт���������m1N9� w@7<�~VX�0�ņ)�KS j�H� �� �<��Y+�y�P`�4��)5
4�*�!ӳ	a��w��}�������v1��p�0��C�����Z����,t���|�z�7w�Y�+4$�\�gMW�{�Pi�O9m?SM�X�T1�i�Zq���Q����}�,�����n��Cf	L�}�	x\����<�c��"��4��E`i$�w�R�M(0s����w襱��r�ϑ�Ng�����Y�	;��m���[gH�0��� U{�:4+i̴vZ����~$�o�����	#����
��)4=tk,���.l����a�C����:u�8����v���L�5�S�}­Cl�;~<>d]���6>������0}�g���������!@̱�p:�� ���_�?�X����H �ۮ�G����{hԾ�۳6�:~�~d�`P����.�&�|g[T:abC7Actn�4�rh�,K��󬊱��w}�{α�V���ۻo������Z�>���c�(�7gh��e�B���Gz�l�0V	֪/���*)�g{���#f�*���a�r<��D��n��V�BaJǨU�����}��5��ݩ�ھ{�,��r�ƦE>�t���c<�C�����q��<2���a��0WX7L~�t`�a0g<���V!����l�.����%����f<&L�����I���.�Z�hZc,�=���	mr��*!����ؿ���y�����O?y[AtN�wA��la��|3�lb�Nt_�������!'2�t}�9T<�T��m0
U`0ڷ>�u���0�%h%.a��fh��yx�?Y����ₑ�K��Bߌ�<S����> �Z����{.�e0����8�υša�nX!L����a�p՘c��w�?4,� .�
����1��i�O�C\�ߗ[ޣ�>Q��p�h�R	��g:�H`��%ɮ*�E,i�H�{�Ѧ�x�w���t�����SD�/t����1�IY*F(yXҦ�����d�0X~���vt��N���@�haq;
����fؤ&U�0
��Vx��@[emL�T[��V�`A�]D��k�r�	��Aa�n�j�� �X�j�"�@0Q�.&Ud�\����������ԯ_�     