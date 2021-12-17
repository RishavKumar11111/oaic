PGDMP             
    	    
    y            oaic    13.2    13.3    �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            �           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            �           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            �           1262    30091    oaic    DATABASE     O   CREATE DATABASE oaic WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'C';
    DROP DATABASE oaic;
                postgres    false                       1255    30092    Paymnet_Insert_MR()    FUNCTION       CREATE FUNCTION public."Paymnet_Insert_MR"() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
	IF(NEW.purpose = 'advanceCustomerPayment' OR NEW.purpose = 'customerPaymentAgainstInvoice' OR NEW.purpose = 'farmerAdvancePayment')
	THEN
		NEW."MoneyReceiptNo"= (SELECT "DistCode" FROM "DistrictMaster" WHERE dist_id=NEW."PayToID") || '/MR/' || NEW."fin_year" ||'/' || nextval('payment1_sl_no_seq');
	END IF;
	IF(NEW.payment_type = 'Cash')
	THEN
		NEW.payment_no = NEW."MoneyReceiptNo";
	END IF;
	RETURN NEW;
END
$$;
 ,   DROP FUNCTION public."Paymnet_Insert_MR"();
       public          postgres    false                       1255    30093    UpdateDeliveredQuantity()    FUNCTION     �  CREATE FUNCTION public."UpdateDeliveredQuantity"() RETURNS trigger
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
       public          postgres    false                       1255    30094    update_invoice_number()    FUNCTION     R  CREATE FUNCTION public.update_invoice_number() RETURNS trigger
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
       public          postgres    false                       1255    30095    update_mrr_id()    FUNCTION     �  CREATE FUNCTION public.update_mrr_id() RETURNS trigger
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
       public          postgres    false                       1255    30096    update_order_po_intiate()    FUNCTION     �   CREATE FUNCTION public.update_order_po_intiate() RETURNS trigger
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
       public          postgres    false            �            1259    30097    AccountantMaster    TABLE     k  CREATE TABLE public."AccountantMaster" (
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
       public         heap    postgres    false            �            1259    30103    CustomerBankAccount    TABLE     :  CREATE TABLE public."CustomerBankAccount" (
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
       public         heap    postgres    false            �            1259    30109    CustomerBankAccount_id_seq    SEQUENCE     �   CREATE SEQUENCE public."CustomerBankAccount_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 3   DROP SEQUENCE public."CustomerBankAccount_id_seq";
       public          postgres    false    201            �           0    0    CustomerBankAccount_id_seq    SEQUENCE OWNED BY     ]   ALTER SEQUENCE public."CustomerBankAccount_id_seq" OWNED BY public."CustomerBankAccount".id;
          public          postgres    false    202            �            1259    30111    CustomerContactPerson    TABLE     �  CREATE TABLE public."CustomerContactPerson" (
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
       public         heap    postgres    false            �            1259    30117    CustomerContactPerson_id_seq    SEQUENCE     �   CREATE SEQUENCE public."CustomerContactPerson_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 5   DROP SEQUENCE public."CustomerContactPerson_id_seq";
       public          postgres    false    203            �           0    0    CustomerContactPerson_id_seq    SEQUENCE OWNED BY     a   ALTER SEQUENCE public."CustomerContactPerson_id_seq" OWNED BY public."CustomerContactPerson".id;
          public          postgres    false    204            �            1259    30119    CustomerDistrictMapping    TABLE     �   CREATE TABLE public."CustomerDistrictMapping" (
    "CustomerID" character varying(255) NOT NULL,
    "DistrictID" character varying(255) NOT NULL,
    "InsertedDate" timestamp with time zone NOT NULL
);
 -   DROP TABLE public."CustomerDistrictMapping";
       public         heap    postgres    false            �            1259    30125    CustomerInvoiceMaster    TABLE     n  CREATE TABLE public."CustomerInvoiceMaster" (
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
       public         heap    postgres    false            �            1259    30131    DivisionMaster    TABLE     �   CREATE TABLE public."DivisionMaster" (
    "DivisionID" character varying(255) NOT NULL,
    "DivisionName" character varying(255) NOT NULL
);
 $   DROP TABLE public."DivisionMaster";
       public         heap    postgres    false            �            1259    30137    CustomerInvoiceViews    VIEW     
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
       public          postgres    false    206    207    207    206    206    206    206    206    206    206    206    206    206    206    206    206    206    206    206    206    206    206    206    206    206    206    206    206    206    206    206    206    206    206    206    206    206    206    206    206    206    206    206    206    206    206    206    206    206    206            �            1259    30142    customer_id_increment    SEQUENCE     ~   CREATE SEQUENCE public.customer_id_increment
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE public.customer_id_increment;
       public          postgres    false            �            1259    30144    CustomerMaster    TABLE     /  CREATE TABLE public."CustomerMaster" (
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
       public         heap    postgres    false    209            �            1259    30151    CustomerMaster_id_seq    SEQUENCE     �   CREATE SEQUENCE public."CustomerMaster_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public."CustomerMaster_id_seq";
       public          postgres    false    210            �           0    0    CustomerMaster_id_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE public."CustomerMaster_id_seq" OWNED BY public."CustomerMaster".id;
          public          postgres    false    211            �            1259    30153    CustomerPrincipalPlace    TABLE     �  CREATE TABLE public."CustomerPrincipalPlace" (
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
       public         heap    postgres    false            �            1259    30159    CustomerPrincipalPlace_id_seq    SEQUENCE     �   CREATE SEQUENCE public."CustomerPrincipalPlace_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 6   DROP SEQUENCE public."CustomerPrincipalPlace_id_seq";
       public          postgres    false    212            �           0    0    CustomerPrincipalPlace_id_seq    SEQUENCE OWNED BY     c   ALTER SEQUENCE public."CustomerPrincipalPlace_id_seq" OWNED BY public."CustomerPrincipalPlace".id;
          public          postgres    false    213            �            1259    30161    DMMaster    TABLE       CREATE TABLE public."DMMaster" (
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
       public         heap    postgres    false            �            1259    30167    DistrictMaster    TABLE     �   CREATE TABLE public."DistrictMaster" (
    dist_id character varying(2) NOT NULL,
    dist_name character varying(20),
    "DistCode" character varying
);
 $   DROP TABLE public."DistrictMaster";
       public         heap    postgres    false            �            1259    30173    InvoiceMaster    TABLE     G  CREATE TABLE public."InvoiceMaster" (
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
       public         heap    postgres    false            �            1259    30182 
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
       public         heap    postgres    false            �            1259    30188    ItemPackageMaster    TABLE     @  CREATE TABLE public."ItemPackageMaster" (
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
       public         heap    postgres    false            �            1259    30194    ItemPackageSizeMaster    TABLE     s   CREATE TABLE public."ItemPackageSizeMaster" (
    id integer NOT NULL,
    "PackageSize" character varying(255)
);
 +   DROP TABLE public."ItemPackageSizeMaster";
       public         heap    postgres    false            �            1259    30197    ItemPackageSizeMaster_id_seq    SEQUENCE     �   CREATE SEQUENCE public."ItemPackageSizeMaster_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 5   DROP SEQUENCE public."ItemPackageSizeMaster_id_seq";
       public          postgres    false    219            �           0    0    ItemPackageSizeMaster_id_seq    SEQUENCE OWNED BY     a   ALTER SEQUENCE public."ItemPackageSizeMaster_id_seq" OWNED BY public."ItemPackageSizeMaster".id;
          public          postgres    false    220            �            1259    30199 	   MRRMaster    TABLE     K  CREATE TABLE public."MRRMaster" (
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
       public         heap    postgres    false            �            1259    30206    POMaster    TABLE     r  CREATE TABLE public."POMaster" (
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
       public         heap    postgres    false            �            1259    30221    MRRViews    VIEW     �  CREATE VIEW public."MRRViews" AS
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
       public          postgres    false    221    222    222    222    222    222    222    222    222    222    222    222    222    222    222    222    222    222    222    222    222    222    222    222    222    222    222    222    222    222    222    222    222    222    222    222    222    222    222    221    221    221    221    221    221    221    221    221    221    221    221    221    221    221    221    221    216    207    207    222            �            1259    30226    NonSubsidyPODetails    TABLE       CREATE TABLE public."NonSubsidyPODetails" (
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
       public         heap    postgres    false            �            1259    30235    NonSubsidyPODetails_id_seq    SEQUENCE     �   CREATE SEQUENCE public."NonSubsidyPODetails_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 3   DROP SEQUENCE public."NonSubsidyPODetails_id_seq";
       public          postgres    false    224            �           0    0    NonSubsidyPODetails_id_seq    SEQUENCE OWNED BY     ]   ALTER SEQUENCE public."NonSubsidyPODetails_id_seq" OWNED BY public."NonSubsidyPODetails".id;
          public          postgres    false    225            �            1259    30237    StateMaster    TABLE     y   CREATE TABLE public."StateMaster" (
    "StateCode" integer NOT NULL,
    "StateName" character varying(255) NOT NULL
);
 !   DROP TABLE public."StateMaster";
       public         heap    postgres    false            �            1259    30240    StockMaster    VIEW     Q  CREATE VIEW public."StockMaster" AS
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
       public          postgres    false    223    208    208    208    208    208    208    208    208    223    223    223    223    223    223    223    223    223            �            1259    30245    VendorBankAccount    TABLE     j  CREATE TABLE public."VendorBankAccount" (
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
       public         heap    postgres    false            �            1259    30251 #   VendorBankAccount_BankAccountID_seq    SEQUENCE     �   CREATE SEQUENCE public."VendorBankAccount_BankAccountID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 <   DROP SEQUENCE public."VendorBankAccount_BankAccountID_seq";
       public          postgres    false    228            �           0    0 #   VendorBankAccount_BankAccountID_seq    SEQUENCE OWNED BY     q   ALTER SEQUENCE public."VendorBankAccount_BankAccountID_seq" OWNED BY public."VendorBankAccount"."BankAccountID";
          public          postgres    false    229            �            1259    30253    VendorContactPerson    TABLE     �  CREATE TABLE public."VendorContactPerson" (
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
       public         heap    postgres    false            �            1259    30259 '   VendorContactPerson_ContactPersonID_seq    SEQUENCE     �   CREATE SEQUENCE public."VendorContactPerson_ContactPersonID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 @   DROP SEQUENCE public."VendorContactPerson_ContactPersonID_seq";
       public          postgres    false    230            �           0    0 '   VendorContactPerson_ContactPersonID_seq    SEQUENCE OWNED BY     y   ALTER SEQUENCE public."VendorContactPerson_ContactPersonID_seq" OWNED BY public."VendorContactPerson"."ContactPersonID";
          public          postgres    false    231            �            1259    30261    VendorDistrictMapping    TABLE     �   CREATE TABLE public."VendorDistrictMapping" (
    "VendorID" character varying(255) NOT NULL,
    "DistrictID" character varying(255) NOT NULL,
    "InsertedDate" timestamp with time zone NOT NULL
);
 +   DROP TABLE public."VendorDistrictMapping";
       public         heap    postgres    false            �            1259    30267    VendorMaster    TABLE       CREATE TABLE public."VendorMaster" (
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
       public         heap    postgres    false            �            1259    30276    VendorPrincipalPlace    TABLE     �  CREATE TABLE public."VendorPrincipalPlace" (
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
       public         heap    postgres    false            �            1259    30282 )   VendorPrincipalPlace_PrincipalPlaceID_seq    SEQUENCE     �   CREATE SEQUENCE public."VendorPrincipalPlace_PrincipalPlaceID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 B   DROP SEQUENCE public."VendorPrincipalPlace_PrincipalPlaceID_seq";
       public          postgres    false    234            �           0    0 )   VendorPrincipalPlace_PrincipalPlaceID_seq    SEQUENCE OWNED BY     }   ALTER SEQUENCE public."VendorPrincipalPlace_PrincipalPlaceID_seq" OWNED BY public."VendorPrincipalPlace"."PrincipalPlaceID";
          public          postgres    false    235            �            1259    30284    VendorServices    TABLE     �   CREATE TABLE public."VendorServices" (
    "VendorID" character varying(255) NOT NULL,
    "Service" character varying(255) NOT NULL,
    "InsertedDate" timestamp with time zone NOT NULL,
    "InsertedBy" character varying(255) NOT NULL
);
 $   DROP TABLE public."VendorServices";
       public         heap    postgres    false            �            1259    30290    approval    TABLE     H  CREATE TABLE public.approval (
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
       public         heap    postgres    false            �            1259    30296    approval_desc    TABLE     �   CREATE TABLE public.approval_desc (
    approval_id character varying(30) NOT NULL,
    permit_no character varying(50) NOT NULL,
    serial integer NOT NULL,
    mrr_id character varying
);
 !   DROP TABLE public.approval_desc;
       public         heap    postgres    false            �            1259    30302    approval_desc_serial_seq    SEQUENCE     �   CREATE SEQUENCE public.approval_desc_serial_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 /   DROP SEQUENCE public.approval_desc_serial_seq;
       public          postgres    false    238            �           0    0    approval_desc_serial_seq    SEQUENCE OWNED BY     U   ALTER SEQUENCE public.approval_desc_serial_seq OWNED BY public.approval_desc.serial;
          public          postgres    false    239            �            1259    30304    approval_status_desc    TABLE     ~   CREATE TABLE public.approval_status_desc (
    status_id character varying(50) NOT NULL,
    "desc" character varying(100)
);
 (   DROP TABLE public.approval_status_desc;
       public         heap    postgres    false            �            1259    30307 
   components    TABLE     �   CREATE TABLE public.components (
    comp_id character varying(10) NOT NULL,
    schema_id character varying(10),
    comp_name character varying(30)
);
    DROP TABLE public.components;
       public         heap    postgres    false            �            1259    30310    dept_expenditure_payment_desc    TABLE     �  CREATE TABLE public.dept_expenditure_payment_desc (
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
       public         heap    postgres    false            �            1259    30313    govt_share_config    TABLE     �   CREATE TABLE public.govt_share_config (
    sl integer NOT NULL,
    fin_year character varying(10),
    head character varying(30),
    govt_share_ammount integer
);
 %   DROP TABLE public.govt_share_config;
       public         heap    postgres    false            �            1259    30316    dept_money_config_sl_seq    SEQUENCE     �   CREATE SEQUENCE public.dept_money_config_sl_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 /   DROP SEQUENCE public.dept_money_config_sl_seq;
       public          postgres    false    243            �           0    0    dept_money_config_sl_seq    SEQUENCE OWNED BY     U   ALTER SEQUENCE public.dept_money_config_sl_seq OWNED BY public.govt_share_config.sl;
          public          postgres    false    244            �            1259    30318    farmer_receipt    TABLE     S  CREATE TABLE public.farmer_receipt (
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
       public         heap    postgres    false            �            1259    30324    farmer_receipts_sl_no_seq    SEQUENCE     �   CREATE SEQUENCE public.farmer_receipts_sl_no_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 0   DROP SEQUENCE public.farmer_receipts_sl_no_seq;
       public          postgres    false    245            �           0    0    farmer_receipts_sl_no_seq    SEQUENCE OWNED BY     V   ALTER SEQUENCE public.farmer_receipts_sl_no_seq OWNED BY public.farmer_receipt.sl_no;
          public          postgres    false    246            �            1259    30326    head_master    TABLE     u   CREATE TABLE public.head_master (
    head_id character varying(10) NOT NULL,
    head_name character varying(30)
);
    DROP TABLE public.head_master;
       public         heap    postgres    false            �            1259    30329 !   jalanidhi_dept_expnd_payment_desc    TABLE     �   CREATE TABLE public.jalanidhi_dept_expnd_payment_desc (
    serial integer NOT NULL,
    transaction_id character varying(50),
    scheme_id character varying(10),
    scheme_name character varying(50),
    comp_id character varying(10)
);
 5   DROP TABLE public.jalanidhi_dept_expnd_payment_desc;
       public         heap    postgres    false            �            1259    30332 ,   jalanidhi_dept_expnd_payment_desc_serial_seq    SEQUENCE     �   CREATE SEQUENCE public.jalanidhi_dept_expnd_payment_desc_serial_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 C   DROP SEQUENCE public.jalanidhi_dept_expnd_payment_desc_serial_seq;
       public          postgres    false    248            �           0    0 ,   jalanidhi_dept_expnd_payment_desc_serial_seq    SEQUENCE OWNED BY     }   ALTER SEQUENCE public.jalanidhi_dept_expnd_payment_desc_serial_seq OWNED BY public.jalanidhi_dept_expnd_payment_desc.serial;
          public          postgres    false    249            �            1259    30334    jalanidhi_payment_desc    TABLE     N  CREATE TABLE public.jalanidhi_payment_desc (
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
       public         heap    postgres    false            �            1259    30337 !   jalanidhi_payment_desc_serial_seq    SEQUENCE     �   CREATE SEQUENCE public.jalanidhi_payment_desc_serial_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 8   DROP SEQUENCE public.jalanidhi_payment_desc_serial_seq;
       public          postgres    false    250            �           0    0 !   jalanidhi_payment_desc_serial_seq    SEQUENCE OWNED BY     g   ALTER SEQUENCE public.jalanidhi_payment_desc_serial_seq OWNED BY public.jalanidhi_payment_desc.serial;
          public          postgres    false    251            �            1259    30339    jn_expenditure_desc    TABLE     �   CREATE TABLE public.jn_expenditure_desc (
    transaction_id character varying(70) NOT NULL,
    item_name character varying(50) NOT NULL,
    item_price numeric(10,5) NOT NULL,
    quantity integer NOT NULL,
    serial integer NOT NULL
);
 '   DROP TABLE public.jn_expenditure_desc;
       public         heap    postgres    false            �            1259    30342    jn_expenditure_desc_serial_seq    SEQUENCE     �   CREATE SEQUENCE public.jn_expenditure_desc_serial_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 5   DROP SEQUENCE public.jn_expenditure_desc_serial_seq;
       public          postgres    false    252            �           0    0    jn_expenditure_desc_serial_seq    SEQUENCE OWNED BY     a   ALTER SEQUENCE public.jn_expenditure_desc_serial_seq OWNED BY public.jn_expenditure_desc.serial;
          public          postgres    false    253            �            1259    30344 	   jn_orders    TABLE     ~  CREATE TABLE public.jn_orders (
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
       public         heap    postgres    false            �            1259    30347    jn_stock    TABLE     �  CREATE TABLE public.jn_stock (
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
       public         heap    postgres    false                        1259    30353    lgd_block_master    TABLE     �   CREATE TABLE public.lgd_block_master (
    dist_code character varying(500),
    block_code character varying(20) NOT NULL,
    block_name character varying(200)
);
 $   DROP TABLE public.lgd_block_master;
       public         heap    postgres    false                       1259    30359    lgd_dist_master    TABLE     |   CREATE TABLE public.lgd_dist_master (
    dist_code character varying(20) NOT NULL,
    dist_name character varying(200)
);
 #   DROP TABLE public.lgd_dist_master;
       public         heap    postgres    false                       1259    30362    lgd_gp_master    TABLE     �   CREATE TABLE public.lgd_gp_master (
    dist_code character varying(20),
    block_code character varying(20),
    gp_code character varying(20) NOT NULL,
    gp_name character varying(100)
);
 !   DROP TABLE public.lgd_gp_master;
       public         heap    postgres    false                       1259    30365    log    TABLE     �  CREATE TABLE public.log (
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
       public         heap    postgres    false                       1259    30371    log_sl_no_seq    SEQUENCE     �   CREATE SEQUENCE public.log_sl_no_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 $   DROP SEQUENCE public.log_sl_no_seq;
       public          postgres    false    259            �           0    0    log_sl_no_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE public.log_sl_no_seq OWNED BY public.log.sl_no;
          public          postgres    false    260                       1259    30373    mrr    TABLE     g  CREATE TABLE public.mrr (
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
       public         heap    postgres    false                       1259    30376    mrr_desc    TABLE     z   CREATE TABLE public.mrr_desc (
    mrr_id character varying(30) NOT NULL,
    permit_no character varying(40) NOT NULL
);
    DROP TABLE public.mrr_desc;
       public         heap    postgres    false                       1259    30379    mrr_sl_no_seq    SEQUENCE     �   CREATE SEQUENCE public.mrr_sl_no_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 $   DROP SEQUENCE public.mrr_sl_no_seq;
       public          postgres    false    261            �           0    0    mrr_sl_no_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE public.mrr_sl_no_seq OWNED BY public.mrr.sl_no;
          public          postgres    false    263                       1259    30381    new_item_price    TABLE     ?  CREATE TABLE public.new_item_price (
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
       public         heap    postgres    false            	           1259    30387    opening_balance    TABLE     e  CREATE TABLE public.opening_balance (
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
           1259    30393    orders    TABLE     �  CREATE TABLE public.orders (
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
       public         heap    postgres    false                       1259    30399    payment    TABLE     D  CREATE TABLE public.payment (
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
       public         heap    postgres    false                       1259    30405    payment1_sl_no_seq    SEQUENCE     �   CREATE SEQUENCE public.payment1_sl_no_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.payment1_sl_no_seq;
       public          postgres    false    267            �           0    0    payment1_sl_no_seq    SEQUENCE OWNED BY     H   ALTER SEQUENCE public.payment1_sl_no_seq OWNED BY public.payment.sl_no;
          public          postgres    false    268                       1259    30407    payment_desc    TABLE     �   CREATE TABLE public.payment_desc (
    transaction_id character varying(70) NOT NULL,
    reference_no character varying(70) NOT NULL
);
     DROP TABLE public.payment_desc;
       public         heap    postgres    false                       1259    30410    payment_desc_2_sl_no_seq    SEQUENCE     �   CREATE SEQUENCE public.payment_desc_2_sl_no_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 /   DROP SEQUENCE public.payment_desc_2_sl_no_seq;
       public          postgres    false    242            �           0    0    payment_desc_2_sl_no_seq    SEQUENCE OWNED BY     d   ALTER SEQUENCE public.payment_desc_2_sl_no_seq OWNED BY public.dept_expenditure_payment_desc.sl_no;
          public          postgres    false    270                       1259    30412    payment_invoice_sl_no_seq    SEQUENCE     �   CREATE SEQUENCE public.payment_invoice_sl_no_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 0   DROP SEQUENCE public.payment_invoice_sl_no_seq;
       public          postgres    false    237            �           0    0    payment_invoice_sl_no_seq    SEQUENCE OWNED BY     P   ALTER SEQUENCE public.payment_invoice_sl_no_seq OWNED BY public.approval.sl_no;
          public          postgres    false    271                       1259    30414    payment_purpose_desc    TABLE        CREATE TABLE public.payment_purpose_desc (
    purpose_id character varying(50) NOT NULL,
    "desc" character varying(100)
);
 (   DROP TABLE public.payment_purpose_desc;
       public         heap    postgres    false                       1259    30417    schem_master    TABLE     x   CREATE TABLE public.schem_master (
    schem_id character varying(10) NOT NULL,
    schem_name character varying(30)
);
     DROP TABLE public.schem_master;
       public         heap    postgres    false                       1259    30420    source_master    TABLE     {   CREATE TABLE public.source_master (
    source_id character varying(10) NOT NULL,
    source_name character varying(30)
);
 !   DROP TABLE public.source_master;
       public         heap    postgres    false                       1259    30423    subheads    TABLE     �   CREATE TABLE public.subheads (
    subhead_id character varying(10) NOT NULL,
    head_id character varying(10),
    subhead_name character varying(30)
);
    DROP TABLE public.subheads;
       public         heap    postgres    false                       1259    30426    system_desc    TABLE     u   CREATE TABLE public.system_desc (
    system_id character varying(50) NOT NULL,
    "desc" character varying(100)
);
    DROP TABLE public.system_desc;
       public         heap    postgres    false                       1259    30429 
   tax_config    TABLE     r   CREATE TABLE public.tax_config (
    tax_mode character varying(2) NOT NULL,
    "desc" character varying(100)
);
    DROP TABLE public.tax_config;
       public         heap    postgres    false                       1259    30432    users    TABLE     �   CREATE TABLE public.users (
    user_id character varying(225) NOT NULL,
    password character varying(300),
    role character varying(20)
);
    DROP TABLE public.users;
       public         heap    postgres    false            ]           2604    30438    CustomerBankAccount id    DEFAULT     �   ALTER TABLE ONLY public."CustomerBankAccount" ALTER COLUMN id SET DEFAULT nextval('public."CustomerBankAccount_id_seq"'::regclass);
 G   ALTER TABLE public."CustomerBankAccount" ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    202    201            ^           2604    30439    CustomerContactPerson id    DEFAULT     �   ALTER TABLE ONLY public."CustomerContactPerson" ALTER COLUMN id SET DEFAULT nextval('public."CustomerContactPerson_id_seq"'::regclass);
 I   ALTER TABLE public."CustomerContactPerson" ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    204    203            `           2604    30440    CustomerMaster id    DEFAULT     z   ALTER TABLE ONLY public."CustomerMaster" ALTER COLUMN id SET DEFAULT nextval('public."CustomerMaster_id_seq"'::regclass);
 B   ALTER TABLE public."CustomerMaster" ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    211    210            a           2604    30441    CustomerPrincipalPlace id    DEFAULT     �   ALTER TABLE ONLY public."CustomerPrincipalPlace" ALTER COLUMN id SET DEFAULT nextval('public."CustomerPrincipalPlace_id_seq"'::regclass);
 J   ALTER TABLE public."CustomerPrincipalPlace" ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    213    212            e           2604    30442    ItemPackageSizeMaster id    DEFAULT     �   ALTER TABLE ONLY public."ItemPackageSizeMaster" ALTER COLUMN id SET DEFAULT nextval('public."ItemPackageSizeMaster_id_seq"'::regclass);
 I   ALTER TABLE public."ItemPackageSizeMaster" ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    220    219            s           2604    30443    NonSubsidyPODetails id    DEFAULT     �   ALTER TABLE ONLY public."NonSubsidyPODetails" ALTER COLUMN id SET DEFAULT nextval('public."NonSubsidyPODetails_id_seq"'::regclass);
 G   ALTER TABLE public."NonSubsidyPODetails" ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    225    224            t           2604    30444    VendorBankAccount BankAccountID    DEFAULT     �   ALTER TABLE ONLY public."VendorBankAccount" ALTER COLUMN "BankAccountID" SET DEFAULT nextval('public."VendorBankAccount_BankAccountID_seq"'::regclass);
 R   ALTER TABLE public."VendorBankAccount" ALTER COLUMN "BankAccountID" DROP DEFAULT;
       public          postgres    false    229    228            u           2604    30445 #   VendorContactPerson ContactPersonID    DEFAULT     �   ALTER TABLE ONLY public."VendorContactPerson" ALTER COLUMN "ContactPersonID" SET DEFAULT nextval('public."VendorContactPerson_ContactPersonID_seq"'::regclass);
 V   ALTER TABLE public."VendorContactPerson" ALTER COLUMN "ContactPersonID" DROP DEFAULT;
       public          postgres    false    231    230            y           2604    30446 %   VendorPrincipalPlace PrincipalPlaceID    DEFAULT     �   ALTER TABLE ONLY public."VendorPrincipalPlace" ALTER COLUMN "PrincipalPlaceID" SET DEFAULT nextval('public."VendorPrincipalPlace_PrincipalPlaceID_seq"'::regclass);
 X   ALTER TABLE public."VendorPrincipalPlace" ALTER COLUMN "PrincipalPlaceID" DROP DEFAULT;
       public          postgres    false    235    234            z           2604    30447    approval sl_no    DEFAULT     w   ALTER TABLE ONLY public.approval ALTER COLUMN sl_no SET DEFAULT nextval('public.payment_invoice_sl_no_seq'::regclass);
 =   ALTER TABLE public.approval ALTER COLUMN sl_no DROP DEFAULT;
       public          postgres    false    271    237            {           2604    30448    approval_desc serial    DEFAULT     |   ALTER TABLE ONLY public.approval_desc ALTER COLUMN serial SET DEFAULT nextval('public.approval_desc_serial_seq'::regclass);
 C   ALTER TABLE public.approval_desc ALTER COLUMN serial DROP DEFAULT;
       public          postgres    false    239    238            |           2604    30449 #   dept_expenditure_payment_desc sl_no    DEFAULT     �   ALTER TABLE ONLY public.dept_expenditure_payment_desc ALTER COLUMN sl_no SET DEFAULT nextval('public.payment_desc_2_sl_no_seq'::regclass);
 R   ALTER TABLE public.dept_expenditure_payment_desc ALTER COLUMN sl_no DROP DEFAULT;
       public          postgres    false    270    242            ~           2604    30450    farmer_receipt sl_no    DEFAULT     }   ALTER TABLE ONLY public.farmer_receipt ALTER COLUMN sl_no SET DEFAULT nextval('public.farmer_receipts_sl_no_seq'::regclass);
 C   ALTER TABLE public.farmer_receipt ALTER COLUMN sl_no DROP DEFAULT;
       public          postgres    false    246    245            }           2604    30451    govt_share_config sl    DEFAULT     |   ALTER TABLE ONLY public.govt_share_config ALTER COLUMN sl SET DEFAULT nextval('public.dept_money_config_sl_seq'::regclass);
 C   ALTER TABLE public.govt_share_config ALTER COLUMN sl DROP DEFAULT;
       public          postgres    false    244    243                       2604    30452 (   jalanidhi_dept_expnd_payment_desc serial    DEFAULT     �   ALTER TABLE ONLY public.jalanidhi_dept_expnd_payment_desc ALTER COLUMN serial SET DEFAULT nextval('public.jalanidhi_dept_expnd_payment_desc_serial_seq'::regclass);
 W   ALTER TABLE public.jalanidhi_dept_expnd_payment_desc ALTER COLUMN serial DROP DEFAULT;
       public          postgres    false    249    248            �           2604    30453    jalanidhi_payment_desc serial    DEFAULT     �   ALTER TABLE ONLY public.jalanidhi_payment_desc ALTER COLUMN serial SET DEFAULT nextval('public.jalanidhi_payment_desc_serial_seq'::regclass);
 L   ALTER TABLE public.jalanidhi_payment_desc ALTER COLUMN serial DROP DEFAULT;
       public          postgres    false    251    250            �           2604    30454    jn_expenditure_desc serial    DEFAULT     �   ALTER TABLE ONLY public.jn_expenditure_desc ALTER COLUMN serial SET DEFAULT nextval('public.jn_expenditure_desc_serial_seq'::regclass);
 I   ALTER TABLE public.jn_expenditure_desc ALTER COLUMN serial DROP DEFAULT;
       public          postgres    false    253    252            �           2604    30455 	   log sl_no    DEFAULT     f   ALTER TABLE ONLY public.log ALTER COLUMN sl_no SET DEFAULT nextval('public.log_sl_no_seq'::regclass);
 8   ALTER TABLE public.log ALTER COLUMN sl_no DROP DEFAULT;
       public          postgres    false    260    259            �           2604    30456 	   mrr sl_no    DEFAULT     f   ALTER TABLE ONLY public.mrr ALTER COLUMN sl_no SET DEFAULT nextval('public.mrr_sl_no_seq'::regclass);
 8   ALTER TABLE public.mrr ALTER COLUMN sl_no DROP DEFAULT;
       public          postgres    false    263    261            �           2604    30457    payment sl_no    DEFAULT     o   ALTER TABLE ONLY public.payment ALTER COLUMN sl_no SET DEFAULT nextval('public.payment1_sl_no_seq'::regclass);
 <   ALTER TABLE public.payment ALTER COLUMN sl_no DROP DEFAULT;
       public          postgres    false    268    267            �          0    30097    AccountantMaster 
   TABLE DATA           �   COPY public."AccountantMaster" (acc_name, acc_id, dist_id, dist_name, acc_address, acc_mobile_no, "UpdateOn", "UpdateBy") FROM stdin;
    public          postgres    false    200   |�      �          0    30103    CustomerBankAccount 
   TABLE DATA           �   COPY public."CustomerBankAccount" (id, "CustomerID", "BankAccountID", "bankAccountNo", "accountType", "bankName", "branchName", "ifscCode", "InsertedDate", "InsertedBy", "UpdatedDate", "UpdatedBy") FROM stdin;
    public          postgres    false    201   ��      �          0    30111    CustomerContactPerson 
   TABLE DATA           �   COPY public."CustomerContactPerson" (id, "CustomerID", "ContactPersonID", "AuthorisedName", "AuthorisedMobileNo", "AuthorisedEmailID", "Designation", "InsertedDate", "InsertedBy", "UpdatedDate", "UpdatedBy") FROM stdin;
    public          postgres    false    203   ��      �          0    30119    CustomerDistrictMapping 
   TABLE DATA           _   COPY public."CustomerDistrictMapping" ("CustomerID", "DistrictID", "InsertedDate") FROM stdin;
    public          postgres    false    205   ��      �          0    30125    CustomerInvoiceMaster 
   TABLE DATA           N  COPY public."CustomerInvoiceMaster" ("CustomerInvoiceNo", "MRRNo", "InvoiceNo", "PONo", "OrderReferenceNo", "POType", "FinYear", "DistrictID", "VendorID", "InvoiceAmount", "NoOfOrderDeliver", "DeliveredQuantity", "InsertedDate", "InsertedBy", "UpdatedDate", "UpdatedBy", "CustomerID", "DivisionID", "Implement", "Make", "Model", "HSN", "UnitOfMeasurement", "PackageSize", "PackageUnitOfMeasurement", "PackageQuantity", "ItemQuantity", "TaxRate", "RatePerUnit", "PurchaseInvoiceValue", "PurchaseCGST", "PurchaseSGST", "PurchaseIGST", "TotalPurchaseInvoiceValue", "TotalPurchaseTaxableValue", "TotalPurchaseCGST", "TotalPurchaseSGST", "SellCGST", "SellSGST", "SellIGST", "SellInvoiceValue", "SellTaxableValue", "TotalSellCGST", "TotalSellSGST", "TotalSellIGST", "TotalSellInvoiceValue", "TotalSellTaxableValue", "PurchaseTaxableValue") FROM stdin;
    public          postgres    false    206   �      �          0    30144    CustomerMaster 
   TABLE DATA           �   COPY public."CustomerMaster" (id, "CustomerID", "LegalCustomerName", "TradeName", "PAN", "BussinessConstitution", "GSTN", "ContactNumber", "EmailID", "InsertedDate", "InsertedBy") FROM stdin;
    public          postgres    false    210   �      �          0    30153    CustomerPrincipalPlace 
   TABLE DATA           �   COPY public."CustomerPrincipalPlace" (id, "CustomerID", "PrincipalPlaceID", "Country", "StateCode", "DistrictOrCity", "Pincode", "Address", "InsertedDate", "InsertedBy", "UpdatedDate", "UpdatedBy") FROM stdin;
    public          postgres    false    212   v&      �          0    30161    DMMaster 
   TABLE DATA           �   COPY public."DMMaster" (dist_id, dist_name, dm_id, dm_name, dm_address, dm_mobile_no, "UpdateOn", "UpdateBy", "EmailID", "BankName", "BranchName", "AccountNumber", "IFSCCode") FROM stdin;
    public          postgres    false    214   �:      �          0    30167    DistrictMaster 
   TABLE DATA           J   COPY public."DistrictMaster" (dist_id, dist_name, "DistCode") FROM stdin;
    public          postgres    false    215   "D      �          0    30131    DivisionMaster 
   TABLE DATA           H   COPY public."DivisionMaster" ("DivisionID", "DivisionName") FROM stdin;
    public          postgres    false    207   ME      �          0    30173    InvoiceMaster 
   TABLE DATA           I  COPY public."InvoiceMaster" ("InvoiceNo", "PONo", "OrderReferenceNo", "InvoiceDate", "WayBillNo", "WayBillDate", "TruckNo", "FinYear", "DistrictID", "VendorID", "Status", "PaymentStatus", "InvoiceAmount", "InvoicePath", "POType", "NoOfOrderInPO", "NoOfOrderDeliver", "InsertedDate", "InsertedBy", "UpdatedDate", "UpdatedBy", "IsReceived", "ReceivedDate", "EngineNumber", "ChassicNumber", "MRRNo", "TotalPurchaseTaxableValue", "TotalPurchaseInvoiceValue", "TotalPurchaseCGST", "TotalPurchaseSGST", "TotalPurchaseIGST", "SupplyQuantity", "SupplyPackageQuantity", "Discount") FROM stdin;
    public          postgres    false    216   �E      �          0    30182 
   ItemMaster 
   TABLE DATA           n  COPY public."ItemMaster" ("Implement", "Make", "Model", p_taxable_value, p_cgst_6, p_sgst_6, p_cgst_1, p_sgst_1, p_invoice_value, s_taxable_value, s_cgst_6, s_sgst_6, s_invoice_value, p_igst_12, s_igst_12, add_date, update_date, "Division", "HSN", "UnitOfMeasurement", "GSTApplicability", "Taxability", "TaxRate", "PurchaseInvoiceValue", "PurchaseTaxableValue", "PurchaseCGST", "PurchaseSGST", "PurchaseIGST", "PurchaseSGSTOnePercent", "PurchaseCGSTOnePercent", "SellCGST", "SellSGST", "SellIGST", "SellInvoiceValue", "SellTaxableValue", "InsertedDate", "InsertedBy", "UpdatedDate", "UpdatedBy", "DivisionID") FROM stdin;
    public          postgres    false    217   �Z      �          0    30188    ItemPackageMaster 
   TABLE DATA           W  COPY public."ItemPackageMaster" ("DivisionID", "Implement", "Make", "Model", "PackageSize", "UnitOfMeasurement", "PurchaseInvoiceValue", "PurchaseTaxableValue", "PurchaseCGST", "PurchaseSGST", "PurchaseIGST", "SellSGST", "SellIGST", "SellInvoiceValue", "SellTaxableValue", "InsertedDate", "InsertedBy", "UpdatedDate", "UpdatedBy") FROM stdin;
    public          postgres    false    218   ؑ      �          0    30194    ItemPackageSizeMaster 
   TABLE DATA           D   COPY public."ItemPackageSizeMaster" (id, "PackageSize") FROM stdin;
    public          postgres    false    219   m�      �          0    30199 	   MRRMaster 
   TABLE DATA           '  COPY public."MRRMaster" ("MRRNo", "InvoiceNo", "PONo", "OrderReferenceNo", "FinYear", "ItemQuantity", "MRRAmount", "VendorID", "DistrictID", "DMID", "AccID", "PaymentStatus", "POType", "InsertedDate", "InsertedBy", "UpdatedDate", "UpdatedBy", "NoOfItemReceived", "ReceivedQuantity") FROM stdin;
    public          postgres    false    221   ̺      �          0    30226    NonSubsidyPODetails 
   TABLE DATA             COPY public."NonSubsidyPODetails" (id, "OrderReferenceNo", "PONo", "CustomerID", "DivisionID", "Implement", "Make", "Model", "UnitOfMeasurement", "HSN", "TaxRate", "PurchaseInvoiceValue", "PurchaseTaxableValue", "PurchaseCGST", "PurchaseSGST", "PurchaseIGST", "SellCGST", "SellSGST", "SellIGST", "SellInvoiceValue", "SellTaxableValue", "ItemQuantity", "ItemQuantitySold", "EngineNumber", "ChassicNumber", "IsDelivered", "IsReceived", "IsDeliveredToCustomer", "InsertedDate", "InsertedBy", "UpdatedDate", "UpdatedBy") FROM stdin;
    public          postgres    false    224   ��      �          0    30206    POMaster 
   TABLE DATA           �  COPY public."POMaster" ("FinYear", "PONo", "OrderReferenceNo", "CustomerID", "CustomerOrderRefence", "VendorID", "DistrictID", "DMID", "AccID", "DivisionID", "Implement", "Make", "Model", "UnitOfMeasurement", "HSN", "TaxRate", "PurchaseInvoiceValue", "PurchaseTaxableValue", "PurchaseCGST", "PurchaseSGST", "PurchaseIGST", "TotalPurchaseInvoiceValue", "TotalPurchaseTaxableValue", "TotalPurchaseCGST", "TotalPurchaseSGST", "SellCGST", "SellSGST", "SellIGST", "SellInvoiceValue", "SellTaxableValue", "TotalSellCGST", "TotalSellSGST", "TotalSellIGST", "TotalSellInvoiceValue", "TotalSellTaxableValue", "POAmount", "NoOfItemsInPO", "ItemQuantity", "ItemQuantitySold", "EngineNumber", "ChassicNumber", "IsDelivered", "IsReceived", "IsDeliveredToCustomer", "Status", "InsertedDate", "InsertedBy", "UpdatedDate", "UpdatedBy", "IsApproved", "ApprovalStatus", "ApprovedDate", "ApprovedBy", "IsDeleted", "DeletedDate", "DeletedBy", "IsCancelled", "CancellationStatus", "CancelledDate", "CancelledBy", "POType", "VendorInvoiceNo", "MRRID", "RatePerUnit", "PackageQuantity", "PackageSize", "PackageUnitOfMeasurement", "DeliveredQuantity", "PendingQuantity") FROM stdin;
    public          postgres    false    222   ��      �          0    30237    StateMaster 
   TABLE DATA           A   COPY public."StateMaster" ("StateCode", "StateName") FROM stdin;
    public          postgres    false    226   ��      �          0    30245    VendorBankAccount 
   TABLE DATA           �   COPY public."VendorBankAccount" ("VendorID", "BankAccountID", "AccountNumber", "AccountType", "BankName", "BranchName", "IFSCCode", "BankDocument", "InsertedDate", "InsertedBy", "UpdatedDate", "UpdatedBy") FROM stdin;
    public          postgres    false    228   ��      �          0    30253    VendorContactPerson 
   TABLE DATA           �   COPY public."VendorContactPerson" ("VendorID", "ContactPersonID", "Name", "FathersName", "MobileNumber", "EmailID", "Designation", "InsertedDate", "InsertedBy") FROM stdin;
    public          postgres    false    230   ��      �          0    30261    VendorDistrictMapping 
   TABLE DATA           [   COPY public."VendorDistrictMapping" ("VendorID", "DistrictID", "InsertedDate") FROM stdin;
    public          postgres    false    232   .�      �          0    30267    VendorMaster 
   TABLE DATA           �  COPY public."VendorMaster" ("VendorID", "LegalBussinessName", "TradeName", "PAN", "PANDocument", "BussinessConstitution", "GSTN", "GSTNDocument", "IncorporationDate", "ContactNumber", "EmailID", "ApprovalStatus", "ApplyStatus", "InsertedDate", "InsertedBy", "IsDeleted", "ApproveOrRejectDate", "ApproveOrRejectBy", "WhetherSSIUnit", "WhetherMSME", "SSIUnitRegistrationCertificate", "MSMECertificate", "CoreBussinessActivity", "Turnover1", "Turnover2", "Turnover3", "Password") FROM stdin;
    public          postgres    false    233   f      �          0    30276    VendorPrincipalPlace 
   TABLE DATA           �   COPY public."VendorPrincipalPlace" ("VendorID", "PrincipalPlaceID", "Country", "StateCode", "DistrictOrCity", "Pincode", "Address", "InsertedDate", "InsertedBy") FROM stdin;
    public          postgres    false    234   �9      �          0    30284    VendorServices 
   TABLE DATA           _   COPY public."VendorServices" ("VendorID", "Service", "InsertedDate", "InsertedBy") FROM stdin;
    public          postgres    false    236   �L      �          0    30290    approval 
   TABLE DATA           $  COPY public.approval (sl_no, invoice_no, fin_year, dist_id, dl_id, status, approval_id, indent_no, approval_date, ammount, transaction_id, deduction_amount, pay_now_amount, payment_status, remark, dl_remark, paid_amount, pp_id, pp_status, dm_approved_on, bank_approved_on, items) FROM stdin;
    public          postgres    false    237   >T      �          0    30296    approval_desc 
   TABLE DATA           O   COPY public.approval_desc (approval_id, permit_no, serial, mrr_id) FROM stdin;
    public          postgres    false    238   �\      �          0    30304    approval_status_desc 
   TABLE DATA           A   COPY public.approval_status_desc (status_id, "desc") FROM stdin;
    public          postgres    false    240   �^      �          0    30307 
   components 
   TABLE DATA           C   COPY public.components (comp_id, schema_id, comp_name) FROM stdin;
    public          postgres    false    241   _      �          0    30310    dept_expenditure_payment_desc 
   TABLE DATA           �   COPY public.dept_expenditure_payment_desc (sl_no, reference_no, transaction_id, source_id, schem_id, comp_id, head_id, subhead_id, head_name, subhead_name, sd_path) FROM stdin;
    public          postgres    false    242   �_      �          0    30318    farmer_receipt 
   TABLE DATA           �   COPY public.farmer_receipt (sl_no, receipt_no, fin_year, farmer_name, farmer_id, full_ammount, permit_no, implement, payment_mode, payment_no, source_bank, date, dist_id, office, payment_date) FROM stdin;
    public          postgres    false    245   �b      �          0    30313    govt_share_config 
   TABLE DATA           S   COPY public.govt_share_config (sl, fin_year, head, govt_share_ammount) FROM stdin;
    public          postgres    false    243   O�      �          0    30326    head_master 
   TABLE DATA           9   COPY public.head_master (head_id, head_name) FROM stdin;
    public          postgres    false    247   ��      �          0    30329 !   jalanidhi_dept_expnd_payment_desc 
   TABLE DATA           t   COPY public.jalanidhi_dept_expnd_payment_desc (serial, transaction_id, scheme_id, scheme_name, comp_id) FROM stdin;
    public          postgres    false    248   ˔      �          0    30334    jalanidhi_payment_desc 
   TABLE DATA           �   COPY public.jalanidhi_payment_desc (transaction_id, farmer_id, farmer_name, implement, make, model, serial, project_id) FROM stdin;
    public          postgres    false    250   D�      �          0    30339    jn_expenditure_desc 
   TABLE DATA           f   COPY public.jn_expenditure_desc (transaction_id, item_name, item_price, quantity, serial) FROM stdin;
    public          postgres    false    252   $�      �          0    30344 	   jn_orders 
   TABLE DATA           {   COPY public.jn_orders (fin_year, dist_id, cluster_id, farmer_id, dist_name, farmer_name, status, date, system) FROM stdin;
    public          postgres    false    254   �      �          0    30347    jn_stock 
   TABLE DATA           �   COPY public.jn_stock (fin_year, dist_id, dl_id, system, po_no, cluster_id, farmer_id, farmer_name, implement, make, model, engine_no, chassic_no, status, receive_date, deliver_date, dl_name) FROM stdin;
    public          postgres    false    255   ݗ      �          0    30353    lgd_block_master 
   TABLE DATA           M   COPY public.lgd_block_master (dist_code, block_code, block_name) FROM stdin;
    public          postgres    false    256   ��      �          0    30359    lgd_dist_master 
   TABLE DATA           ?   COPY public.lgd_dist_master (dist_code, dist_name) FROM stdin;
    public          postgres    false    257   ߡ      �          0    30362    lgd_gp_master 
   TABLE DATA           P   COPY public.lgd_gp_master (dist_code, block_code, gp_code, gp_name) FROM stdin;
    public          postgres    false    258   �      �          0    30365    log 
   TABLE DATA           �   COPY public.log (sl_no, date_time, user_id, action, status, ref_url, route, ip, browser_name, browser_version, fin_year, remark) FROM stdin;
    public          postgres    false    259   5d      �          0    30373    mrr 
   TABLE DATA           v   COPY public.mrr (sl_no, mrr_id, dist_id, invoice_no, fin_year, dl_id, date, items, indent_no, mrr_amount) FROM stdin;
    public          postgres    false    261   <�      �          0    30376    mrr_desc 
   TABLE DATA           5   COPY public.mrr_desc (mrr_id, permit_no) FROM stdin;
    public          postgres    false    262   .�      �          0    30381    new_item_price 
   TABLE DATA           �   COPY public.new_item_price (implement, make, model, purchase_price, taxable_value, cgst_6, sags_6, invoice_alue, selling_price, sl_taxable_value, sl_cgst_6, sl_sgst_6, sl_invoice_value) FROM stdin;
    public          postgres    false    264   �      �          0    30387    opening_balance 
   TABLE DATA           �   COPY public.opening_balance (fin_year, date, system, dist_id, transaction_id, ammount, remark, purpose, reference_no, "from", "to", head, subhead, payment_type, payment_date, payment_no, test) FROM stdin;
    public          postgres    false    265   ��      �          0    30393    orders 
   TABLE DATA           �  COPY public.orders (permit_no, permit_issue_date, permit_validity, farmer_id, farmer_name, farmer_father_name, dist_name, block_name, gp_name, village_name, implement, make, model, status, permit_validity_1, permit_issue_date_1, fin_year, dist_id, engine_no, chassic_no, ammount, remark, expected_delivery_date, delivery_date, c_fin_year, date, system, paid_amount, order_type, "FullCost", "PendingCost") FROM stdin;
    public          postgres    false    266   ��      �          0    30399    payment 
   TABLE DATA             COPY public.payment (sl_no, date, reference_no, transaction_id, "from", "to", remark, payment_type, payment_no, fin_year, purpose, payment_date, ammount, status, system, source_bank, "DivisionID", "Implement", "MoneyReceiptNo", "PayFrom", "PayTo", "PayFromID", "PayToID") FROM stdin;
    public          postgres    false    267   S�      �          0    30407    payment_desc 
   TABLE DATA           D   COPY public.payment_desc (transaction_id, reference_no) FROM stdin;
    public          postgres    false    269   �=      �          0    30414    payment_purpose_desc 
   TABLE DATA           B   COPY public.payment_purpose_desc (purpose_id, "desc") FROM stdin;
    public          postgres    false    272   �=      �          0    30417    schem_master 
   TABLE DATA           <   COPY public.schem_master (schem_id, schem_name) FROM stdin;
    public          postgres    false    273   �>      �          0    30420    source_master 
   TABLE DATA           ?   COPY public.source_master (source_id, source_name) FROM stdin;
    public          postgres    false    274   �>      �          0    30423    subheads 
   TABLE DATA           E   COPY public.subheads (subhead_id, head_id, subhead_name) FROM stdin;
    public          postgres    false    275    ?      �          0    30426    system_desc 
   TABLE DATA           8   COPY public.system_desc (system_id, "desc") FROM stdin;
    public          postgres    false    276   �?      �          0    30429 
   tax_config 
   TABLE DATA           6   COPY public.tax_config (tax_mode, "desc") FROM stdin;
    public          postgres    false    277   �?      �          0    30432    users 
   TABLE DATA           8   COPY public.users (user_id, password, role) FROM stdin;
    public          postgres    false    278   ;@      �           0    0    CustomerBankAccount_id_seq    SEQUENCE SET     K   SELECT pg_catalog.setval('public."CustomerBankAccount_id_seq"', 36, true);
          public          postgres    false    202            �           0    0    CustomerContactPerson_id_seq    SEQUENCE SET     N   SELECT pg_catalog.setval('public."CustomerContactPerson_id_seq"', 141, true);
          public          postgres    false    204            �           0    0    CustomerMaster_id_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('public."CustomerMaster_id_seq"', 177, true);
          public          postgres    false    211            �           0    0    CustomerPrincipalPlace_id_seq    SEQUENCE SET     O   SELECT pg_catalog.setval('public."CustomerPrincipalPlace_id_seq"', 202, true);
          public          postgres    false    213            �           0    0    ItemPackageSizeMaster_id_seq    SEQUENCE SET     M   SELECT pg_catalog.setval('public."ItemPackageSizeMaster_id_seq"', 19, true);
          public          postgres    false    220            �           0    0    NonSubsidyPODetails_id_seq    SEQUENCE SET     K   SELECT pg_catalog.setval('public."NonSubsidyPODetails_id_seq"', 1, false);
          public          postgres    false    225            �           0    0 #   VendorBankAccount_BankAccountID_seq    SEQUENCE SET     T   SELECT pg_catalog.setval('public."VendorBankAccount_BankAccountID_seq"', 90, true);
          public          postgres    false    229            �           0    0 '   VendorContactPerson_ContactPersonID_seq    SEQUENCE SET     Y   SELECT pg_catalog.setval('public."VendorContactPerson_ContactPersonID_seq"', 111, true);
          public          postgres    false    231            �           0    0 )   VendorPrincipalPlace_PrincipalPlaceID_seq    SEQUENCE SET     Z   SELECT pg_catalog.setval('public."VendorPrincipalPlace_PrincipalPlaceID_seq"', 99, true);
          public          postgres    false    235                        0    0    approval_desc_serial_seq    SEQUENCE SET     H   SELECT pg_catalog.setval('public.approval_desc_serial_seq', 107, true);
          public          postgres    false    239                       0    0    customer_id_increment    SEQUENCE SET     E   SELECT pg_catalog.setval('public.customer_id_increment', 177, true);
          public          postgres    false    209                       0    0    dept_money_config_sl_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.dept_money_config_sl_seq', 1, true);
          public          postgres    false    244                       0    0    farmer_receipts_sl_no_seq    SEQUENCE SET     I   SELECT pg_catalog.setval('public.farmer_receipts_sl_no_seq', 639, true);
          public          postgres    false    246                       0    0 ,   jalanidhi_dept_expnd_payment_desc_serial_seq    SEQUENCE SET     [   SELECT pg_catalog.setval('public.jalanidhi_dept_expnd_payment_desc_serial_seq', 12, true);
          public          postgres    false    249                       0    0 !   jalanidhi_payment_desc_serial_seq    SEQUENCE SET     P   SELECT pg_catalog.setval('public.jalanidhi_payment_desc_serial_seq', 24, true);
          public          postgres    false    251                       0    0    jn_expenditure_desc_serial_seq    SEQUENCE SET     M   SELECT pg_catalog.setval('public.jn_expenditure_desc_serial_seq', 36, true);
          public          postgres    false    253                       0    0    log_sl_no_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.log_sl_no_seq', 5223, true);
          public          postgres    false    260                       0    0    mrr_sl_no_seq    SEQUENCE SET     =   SELECT pg_catalog.setval('public.mrr_sl_no_seq', 229, true);
          public          postgres    false    263            	           0    0    payment1_sl_no_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public.payment1_sl_no_seq', 1354, true);
          public          postgres    false    268            
           0    0    payment_desc_2_sl_no_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('public.payment_desc_2_sl_no_seq', 93, true);
          public          postgres    false    270                       0    0    payment_invoice_sl_no_seq    SEQUENCE SET     I   SELECT pg_catalog.setval('public.payment_invoice_sl_no_seq', 114, true);
          public          postgres    false    271            �           2606    30459 ,   CustomerBankAccount CustomerBankAccount_pkey 
   CONSTRAINT     n   ALTER TABLE ONLY public."CustomerBankAccount"
    ADD CONSTRAINT "CustomerBankAccount_pkey" PRIMARY KEY (id);
 Z   ALTER TABLE ONLY public."CustomerBankAccount" DROP CONSTRAINT "CustomerBankAccount_pkey";
       public            postgres    false    201            �           2606    30461 0   CustomerContactPerson CustomerContactPerson_pkey 
   CONSTRAINT     r   ALTER TABLE ONLY public."CustomerContactPerson"
    ADD CONSTRAINT "CustomerContactPerson_pkey" PRIMARY KEY (id);
 ^   ALTER TABLE ONLY public."CustomerContactPerson" DROP CONSTRAINT "CustomerContactPerson_pkey";
       public            postgres    false    203            �           2606    30463 4   CustomerDistrictMapping CustomerDistrictMapping_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CustomerDistrictMapping"
    ADD CONSTRAINT "CustomerDistrictMapping_pkey" PRIMARY KEY ("CustomerID", "DistrictID");
 b   ALTER TABLE ONLY public."CustomerDistrictMapping" DROP CONSTRAINT "CustomerDistrictMapping_pkey";
       public            postgres    false    205    205            �           2606    30465 0   CustomerInvoiceMaster CustomerInvoiceMaster_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CustomerInvoiceMaster"
    ADD CONSTRAINT "CustomerInvoiceMaster_pkey" PRIMARY KEY ("CustomerInvoiceNo", "OrderReferenceNo");
 ^   ALTER TABLE ONLY public."CustomerInvoiceMaster" DROP CONSTRAINT "CustomerInvoiceMaster_pkey";
       public            postgres    false    206    206            �           2606    30467 "   CustomerMaster CustomerMaster_pkey 
   CONSTRAINT     d   ALTER TABLE ONLY public."CustomerMaster"
    ADD CONSTRAINT "CustomerMaster_pkey" PRIMARY KEY (id);
 P   ALTER TABLE ONLY public."CustomerMaster" DROP CONSTRAINT "CustomerMaster_pkey";
       public            postgres    false    210            �           2606    30469 2   CustomerPrincipalPlace CustomerPrincipalPlace_pkey 
   CONSTRAINT     t   ALTER TABLE ONLY public."CustomerPrincipalPlace"
    ADD CONSTRAINT "CustomerPrincipalPlace_pkey" PRIMARY KEY (id);
 `   ALTER TABLE ONLY public."CustomerPrincipalPlace" DROP CONSTRAINT "CustomerPrincipalPlace_pkey";
       public            postgres    false    212            �           2606    30471 "   DivisionMaster DivisionMaster_pkey 
   CONSTRAINT     n   ALTER TABLE ONLY public."DivisionMaster"
    ADD CONSTRAINT "DivisionMaster_pkey" PRIMARY KEY ("DivisionID");
 P   ALTER TABLE ONLY public."DivisionMaster" DROP CONSTRAINT "DivisionMaster_pkey";
       public            postgres    false    207            �           2606    30473     InvoiceMaster InvoiceMaster_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."InvoiceMaster"
    ADD CONSTRAINT "InvoiceMaster_pkey" PRIMARY KEY ("InvoiceNo", "PONo", "OrderReferenceNo");
 N   ALTER TABLE ONLY public."InvoiceMaster" DROP CONSTRAINT "InvoiceMaster_pkey";
       public            postgres    false    216    216    216            �           2606    30475 (   ItemPackageMaster ItemPackageMaster_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."ItemPackageMaster"
    ADD CONSTRAINT "ItemPackageMaster_pkey" PRIMARY KEY ("DivisionID", "Implement", "Make", "Model", "PackageSize", "UnitOfMeasurement");
 V   ALTER TABLE ONLY public."ItemPackageMaster" DROP CONSTRAINT "ItemPackageMaster_pkey";
       public            postgres    false    218    218    218    218    218    218            �           2606    30477 0   ItemPackageSizeMaster ItemPackageSizeMaster_pkey 
   CONSTRAINT     r   ALTER TABLE ONLY public."ItemPackageSizeMaster"
    ADD CONSTRAINT "ItemPackageSizeMaster_pkey" PRIMARY KEY (id);
 ^   ALTER TABLE ONLY public."ItemPackageSizeMaster" DROP CONSTRAINT "ItemPackageSizeMaster_pkey";
       public            postgres    false    219            �           2606    30479    MRRMaster MRRMaster_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."MRRMaster"
    ADD CONSTRAINT "MRRMaster_pkey" PRIMARY KEY ("MRRNo", "InvoiceNo", "PONo", "OrderReferenceNo");
 F   ALTER TABLE ONLY public."MRRMaster" DROP CONSTRAINT "MRRMaster_pkey";
       public            postgres    false    221    221    221    221            �           2606    30481 ,   NonSubsidyPODetails NonSubsidyPODetails_pkey 
   CONSTRAINT     n   ALTER TABLE ONLY public."NonSubsidyPODetails"
    ADD CONSTRAINT "NonSubsidyPODetails_pkey" PRIMARY KEY (id);
 Z   ALTER TABLE ONLY public."NonSubsidyPODetails" DROP CONSTRAINT "NonSubsidyPODetails_pkey";
       public            postgres    false    224            �           2606    30483    POMaster POMaster_pkey 
   CONSTRAINT     p   ALTER TABLE ONLY public."POMaster"
    ADD CONSTRAINT "POMaster_pkey" PRIMARY KEY ("PONo", "OrderReferenceNo");
 D   ALTER TABLE ONLY public."POMaster" DROP CONSTRAINT "POMaster_pkey";
       public            postgres    false    222    222            �           2606    30485    StateMaster StateMaster_pkey 
   CONSTRAINT     g   ALTER TABLE ONLY public."StateMaster"
    ADD CONSTRAINT "StateMaster_pkey" PRIMARY KEY ("StateCode");
 J   ALTER TABLE ONLY public."StateMaster" DROP CONSTRAINT "StateMaster_pkey";
       public            postgres    false    226            �           2606    30487 (   VendorBankAccount VendorBankAccount_pkey 
   CONSTRAINT     w   ALTER TABLE ONLY public."VendorBankAccount"
    ADD CONSTRAINT "VendorBankAccount_pkey" PRIMARY KEY ("BankAccountID");
 V   ALTER TABLE ONLY public."VendorBankAccount" DROP CONSTRAINT "VendorBankAccount_pkey";
       public            postgres    false    228            �           2606    30489 ,   VendorContactPerson VendorContactPerson_pkey 
   CONSTRAINT     }   ALTER TABLE ONLY public."VendorContactPerson"
    ADD CONSTRAINT "VendorContactPerson_pkey" PRIMARY KEY ("ContactPersonID");
 Z   ALTER TABLE ONLY public."VendorContactPerson" DROP CONSTRAINT "VendorContactPerson_pkey";
       public            postgres    false    230            �           2606    30491 0   VendorDistrictMapping VendorDistrictMapping_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."VendorDistrictMapping"
    ADD CONSTRAINT "VendorDistrictMapping_pkey" PRIMARY KEY ("VendorID", "DistrictID");
 ^   ALTER TABLE ONLY public."VendorDistrictMapping" DROP CONSTRAINT "VendorDistrictMapping_pkey";
       public            postgres    false    232    232            �           2606    30493    VendorMaster VendorMaster_pkey 
   CONSTRAINT     h   ALTER TABLE ONLY public."VendorMaster"
    ADD CONSTRAINT "VendorMaster_pkey" PRIMARY KEY ("VendorID");
 L   ALTER TABLE ONLY public."VendorMaster" DROP CONSTRAINT "VendorMaster_pkey";
       public            postgres    false    233            �           2606    30495 .   VendorPrincipalPlace VendorPrincipalPlace_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."VendorPrincipalPlace"
    ADD CONSTRAINT "VendorPrincipalPlace_pkey" PRIMARY KEY ("PrincipalPlaceID");
 \   ALTER TABLE ONLY public."VendorPrincipalPlace" DROP CONSTRAINT "VendorPrincipalPlace_pkey";
       public            postgres    false    234            �           2606    30497 "   VendorServices VendorServices_pkey 
   CONSTRAINT     w   ALTER TABLE ONLY public."VendorServices"
    ADD CONSTRAINT "VendorServices_pkey" PRIMARY KEY ("VendorID", "Service");
 P   ALTER TABLE ONLY public."VendorServices" DROP CONSTRAINT "VendorServices_pkey";
       public            postgres    false    236    236            �           2606    30499 (   AccountantMaster accountants_master_pkey 
   CONSTRAINT     u   ALTER TABLE ONLY public."AccountantMaster"
    ADD CONSTRAINT accountants_master_pkey PRIMARY KEY (acc_id, dist_id);
 T   ALTER TABLE ONLY public."AccountantMaster" DROP CONSTRAINT accountants_master_pkey;
       public            postgres    false    200    200            �           2606    30501     approval_desc approval_desc_pkey 
   CONSTRAINT     b   ALTER TABLE ONLY public.approval_desc
    ADD CONSTRAINT approval_desc_pkey PRIMARY KEY (serial);
 J   ALTER TABLE ONLY public.approval_desc DROP CONSTRAINT approval_desc_pkey;
       public            postgres    false    238            �           2606    30503 .   approval_status_desc approval_status_desc_pkey 
   CONSTRAINT     s   ALTER TABLE ONLY public.approval_status_desc
    ADD CONSTRAINT approval_status_desc_pkey PRIMARY KEY (status_id);
 X   ALTER TABLE ONLY public.approval_status_desc DROP CONSTRAINT approval_status_desc_pkey;
       public            postgres    false    240            �           2606    30505    components components_pkey 
   CONSTRAINT     ]   ALTER TABLE ONLY public.components
    ADD CONSTRAINT components_pkey PRIMARY KEY (comp_id);
 D   ALTER TABLE ONLY public.components DROP CONSTRAINT components_pkey;
       public            postgres    false    241            �           2606    30507 (   govt_share_config dept_money_config_pkey 
   CONSTRAINT     f   ALTER TABLE ONLY public.govt_share_config
    ADD CONSTRAINT dept_money_config_pkey PRIMARY KEY (sl);
 R   ALTER TABLE ONLY public.govt_share_config DROP CONSTRAINT dept_money_config_pkey;
       public            postgres    false    243            �           2606    30509 !   DistrictMaster dist_master_1_pkey 
   CONSTRAINT     f   ALTER TABLE ONLY public."DistrictMaster"
    ADD CONSTRAINT dist_master_1_pkey PRIMARY KEY (dist_id);
 M   ALTER TABLE ONLY public."DistrictMaster" DROP CONSTRAINT dist_master_1_pkey;
       public            postgres    false    215            �           2606    30511    DMMaster dm_master_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public."DMMaster"
    ADD CONSTRAINT dm_master_pkey PRIMARY KEY (dm_id);
 C   ALTER TABLE ONLY public."DMMaster" DROP CONSTRAINT dm_master_pkey;
       public            postgres    false    214            �           2606    30513 #   farmer_receipt farmer_receipts_pkey 
   CONSTRAINT     i   ALTER TABLE ONLY public.farmer_receipt
    ADD CONSTRAINT farmer_receipts_pkey PRIMARY KEY (receipt_no);
 M   ALTER TABLE ONLY public.farmer_receipt DROP CONSTRAINT farmer_receipts_pkey;
       public            postgres    false    245            �           2606    30515    head_master head_master_pkey 
   CONSTRAINT     _   ALTER TABLE ONLY public.head_master
    ADD CONSTRAINT head_master_pkey PRIMARY KEY (head_id);
 F   ALTER TABLE ONLY public.head_master DROP CONSTRAINT head_master_pkey;
       public            postgres    false    247            �           2606    30517 !   ItemMaster item_price_map_1_pkey1 
   CONSTRAINT     {   ALTER TABLE ONLY public."ItemMaster"
    ADD CONSTRAINT item_price_map_1_pkey1 PRIMARY KEY ("Implement", "Make", "Model");
 M   ALTER TABLE ONLY public."ItemMaster" DROP CONSTRAINT item_price_map_1_pkey1;
       public            postgres    false    217    217    217            �           2606    30519 H   jalanidhi_dept_expnd_payment_desc jalanidhi_dept_expnd_payment_desc_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.jalanidhi_dept_expnd_payment_desc
    ADD CONSTRAINT jalanidhi_dept_expnd_payment_desc_pkey PRIMARY KEY (serial);
 r   ALTER TABLE ONLY public.jalanidhi_dept_expnd_payment_desc DROP CONSTRAINT jalanidhi_dept_expnd_payment_desc_pkey;
       public            postgres    false    248            �           2606    30521 2   jalanidhi_payment_desc jalanidhi_payment_desc_pkey 
   CONSTRAINT     t   ALTER TABLE ONLY public.jalanidhi_payment_desc
    ADD CONSTRAINT jalanidhi_payment_desc_pkey PRIMARY KEY (serial);
 \   ALTER TABLE ONLY public.jalanidhi_payment_desc DROP CONSTRAINT jalanidhi_payment_desc_pkey;
       public            postgres    false    250            �           2606    30523 ,   jn_expenditure_desc jn_expenditure_desc_pkey 
   CONSTRAINT     n   ALTER TABLE ONLY public.jn_expenditure_desc
    ADD CONSTRAINT jn_expenditure_desc_pkey PRIMARY KEY (serial);
 V   ALTER TABLE ONLY public.jn_expenditure_desc DROP CONSTRAINT jn_expenditure_desc_pkey;
       public            postgres    false    252            �           2606    30525    jn_orders jn_orders_pkey 
   CONSTRAINT     i   ALTER TABLE ONLY public.jn_orders
    ADD CONSTRAINT jn_orders_pkey PRIMARY KEY (cluster_id, farmer_id);
 B   ALTER TABLE ONLY public.jn_orders DROP CONSTRAINT jn_orders_pkey;
       public            postgres    false    254    254            �           2606    30527    jn_stock jn_stock_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.jn_stock
    ADD CONSTRAINT jn_stock_pkey PRIMARY KEY (po_no, cluster_id, farmer_id, implement, make, model);
 @   ALTER TABLE ONLY public.jn_stock DROP CONSTRAINT jn_stock_pkey;
       public            postgres    false    255    255    255    255    255    255            �           2606    30529 &   lgd_block_master lgd_block_master_pkey 
   CONSTRAINT     l   ALTER TABLE ONLY public.lgd_block_master
    ADD CONSTRAINT lgd_block_master_pkey PRIMARY KEY (block_code);
 P   ALTER TABLE ONLY public.lgd_block_master DROP CONSTRAINT lgd_block_master_pkey;
       public            postgres    false    256            �           2606    30531 $   lgd_dist_master lgd_dist_master_pkey 
   CONSTRAINT     i   ALTER TABLE ONLY public.lgd_dist_master
    ADD CONSTRAINT lgd_dist_master_pkey PRIMARY KEY (dist_code);
 N   ALTER TABLE ONLY public.lgd_dist_master DROP CONSTRAINT lgd_dist_master_pkey;
       public            postgres    false    257            �           2606    30533     lgd_gp_master lgd_gp_master_pkey 
   CONSTRAINT     c   ALTER TABLE ONLY public.lgd_gp_master
    ADD CONSTRAINT lgd_gp_master_pkey PRIMARY KEY (gp_code);
 J   ALTER TABLE ONLY public.lgd_gp_master DROP CONSTRAINT lgd_gp_master_pkey;
       public            postgres    false    258            �           2606    30535    log log_pkey 
   CONSTRAINT     M   ALTER TABLE ONLY public.log
    ADD CONSTRAINT log_pkey PRIMARY KEY (sl_no);
 6   ALTER TABLE ONLY public.log DROP CONSTRAINT log_pkey;
       public            postgres    false    259            �           2606    30537    mrr_desc mrr_desc_pkey 
   CONSTRAINT     c   ALTER TABLE ONLY public.mrr_desc
    ADD CONSTRAINT mrr_desc_pkey PRIMARY KEY (mrr_id, permit_no);
 @   ALTER TABLE ONLY public.mrr_desc DROP CONSTRAINT mrr_desc_pkey;
       public            postgres    false    262    262            �           2606    30539    mrr mrr_pkey 
   CONSTRAINT     N   ALTER TABLE ONLY public.mrr
    ADD CONSTRAINT mrr_pkey PRIMARY KEY (mrr_id);
 6   ALTER TABLE ONLY public.mrr DROP CONSTRAINT mrr_pkey;
       public            postgres    false    261            �           2606    30541 "   new_item_price new_item_price_pkey 
   CONSTRAINT     t   ALTER TABLE ONLY public.new_item_price
    ADD CONSTRAINT new_item_price_pkey PRIMARY KEY (implement, make, model);
 L   ALTER TABLE ONLY public.new_item_price DROP CONSTRAINT new_item_price_pkey;
       public            postgres    false    264    264    264            �           2606    30543 $   opening_balance opening_balance_pkey 
   CONSTRAINT     n   ALTER TABLE ONLY public.opening_balance
    ADD CONSTRAINT opening_balance_pkey PRIMARY KEY (transaction_id);
 N   ALTER TABLE ONLY public.opening_balance DROP CONSTRAINT opening_balance_pkey;
       public            postgres    false    265            �           2606    30545    orders orders_pkey 
   CONSTRAINT     W   ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (permit_no);
 <   ALTER TABLE ONLY public.orders DROP CONSTRAINT orders_pkey;
       public            postgres    false    266            �           2606    30547    payment payment1_pkey 
   CONSTRAINT     _   ALTER TABLE ONLY public.payment
    ADD CONSTRAINT payment1_pkey PRIMARY KEY (transaction_id);
 ?   ALTER TABLE ONLY public.payment DROP CONSTRAINT payment1_pkey;
       public            postgres    false    267            �           2606    30549 1   dept_expenditure_payment_desc payment_desc_2_pkey 
   CONSTRAINT     r   ALTER TABLE ONLY public.dept_expenditure_payment_desc
    ADD CONSTRAINT payment_desc_2_pkey PRIMARY KEY (sl_no);
 [   ALTER TABLE ONLY public.dept_expenditure_payment_desc DROP CONSTRAINT payment_desc_2_pkey;
       public            postgres    false    242            �           2606    30551    payment_desc payment_desc_pkey 
   CONSTRAINT     v   ALTER TABLE ONLY public.payment_desc
    ADD CONSTRAINT payment_desc_pkey PRIMARY KEY (reference_no, transaction_id);
 H   ALTER TABLE ONLY public.payment_desc DROP CONSTRAINT payment_desc_pkey;
       public            postgres    false    269    269            �           2606    30553 !   approval payment_instruction_pkey 
   CONSTRAINT     b   ALTER TABLE ONLY public.approval
    ADD CONSTRAINT payment_instruction_pkey PRIMARY KEY (sl_no);
 K   ALTER TABLE ONLY public.approval DROP CONSTRAINT payment_instruction_pkey;
       public            postgres    false    237            �           2606    30555 .   payment_purpose_desc payment_purpose_desc_pkey 
   CONSTRAINT     t   ALTER TABLE ONLY public.payment_purpose_desc
    ADD CONSTRAINT payment_purpose_desc_pkey PRIMARY KEY (purpose_id);
 X   ALTER TABLE ONLY public.payment_purpose_desc DROP CONSTRAINT payment_purpose_desc_pkey;
       public            postgres    false    272            �           2606    30557    schem_master schema_master_pkey 
   CONSTRAINT     c   ALTER TABLE ONLY public.schem_master
    ADD CONSTRAINT schema_master_pkey PRIMARY KEY (schem_id);
 I   ALTER TABLE ONLY public.schem_master DROP CONSTRAINT schema_master_pkey;
       public            postgres    false    273            �           2606    30559     source_master source_master_pkey 
   CONSTRAINT     e   ALTER TABLE ONLY public.source_master
    ADD CONSTRAINT source_master_pkey PRIMARY KEY (source_id);
 J   ALTER TABLE ONLY public.source_master DROP CONSTRAINT source_master_pkey;
       public            postgres    false    274            �           2606    30561    subheads subhead_pkey 
   CONSTRAINT     [   ALTER TABLE ONLY public.subheads
    ADD CONSTRAINT subhead_pkey PRIMARY KEY (subhead_id);
 ?   ALTER TABLE ONLY public.subheads DROP CONSTRAINT subhead_pkey;
       public            postgres    false    275            �           2606    30563    system_desc system_desc_pkey 
   CONSTRAINT     a   ALTER TABLE ONLY public.system_desc
    ADD CONSTRAINT system_desc_pkey PRIMARY KEY (system_id);
 F   ALTER TABLE ONLY public.system_desc DROP CONSTRAINT system_desc_pkey;
       public            postgres    false    276            �           2606    30565    tax_config tax_config_pkey 
   CONSTRAINT     ^   ALTER TABLE ONLY public.tax_config
    ADD CONSTRAINT tax_config_pkey PRIMARY KEY (tax_mode);
 D   ALTER TABLE ONLY public.tax_config DROP CONSTRAINT tax_config_pkey;
       public            postgres    false    277            �           2606    30567    users users_pkey 
   CONSTRAINT     S   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (user_id);
 :   ALTER TABLE ONLY public.users DROP CONSTRAINT users_pkey;
       public            postgres    false    278                       2620    30568    payment Generate_MR    TRIGGER     y   CREATE TRIGGER "Generate_MR" BEFORE INSERT ON public.payment FOR EACH ROW EXECUTE FUNCTION public."Paymnet_Insert_MR"();
 .   DROP TRIGGER "Generate_MR" ON public.payment;
       public          postgres    false    283    267            	           2620    30569     POMaster updateDeliveredQuantity    TRIGGER     �   CREATE TRIGGER "updateDeliveredQuantity" BEFORE UPDATE ON public."POMaster" FOR EACH ROW EXECUTE FUNCTION public."UpdateDeliveredQuantity"();
 =   DROP TRIGGER "updateDeliveredQuantity" ON public."POMaster";
       public          postgres    false    279    222                       2620    30570    InvoiceMaster update_invoice_no    TRIGGER     �   CREATE TRIGGER update_invoice_no AFTER INSERT ON public."InvoiceMaster" FOR EACH ROW EXECUTE FUNCTION public.update_invoice_number();
 :   DROP TRIGGER update_invoice_no ON public."InvoiceMaster";
       public          postgres    false    280    216                       2620    30571    MRRMaster update_mrr_id    TRIGGER     v   CREATE TRIGGER update_mrr_id AFTER INSERT ON public."MRRMaster" FOR EACH ROW EXECUTE FUNCTION public.update_mrr_id();
 2   DROP TRIGGER update_mrr_id ON public."MRRMaster";
       public          postgres    false    281    221            
           2620    30572    POMaster update_order    TRIGGER     ~   CREATE TRIGGER update_order AFTER INSERT ON public."POMaster" FOR EACH ROW EXECUTE FUNCTION public.update_order_po_intiate();
 0   DROP TRIGGER update_order ON public."POMaster";
       public          postgres    false    282    222            �           2606    30573 ?   CustomerDistrictMapping CustomerDistrictMapping_DistrictID_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."CustomerDistrictMapping"
    ADD CONSTRAINT "CustomerDistrictMapping_DistrictID_fkey" FOREIGN KEY ("DistrictID") REFERENCES public."DistrictMaster"(dist_id) ON UPDATE CASCADE;
 m   ALTER TABLE ONLY public."CustomerDistrictMapping" DROP CONSTRAINT "CustomerDistrictMapping_DistrictID_fkey";
       public          postgres    false    205    3480    215            �           2606    30578 <   CustomerPrincipalPlace CustomerPrincipalPlace_StateCode_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."CustomerPrincipalPlace"
    ADD CONSTRAINT "CustomerPrincipalPlace_StateCode_fkey" FOREIGN KEY ("StateCode") REFERENCES public."StateMaster"("StateCode") ON UPDATE CASCADE ON DELETE SET NULL;
 j   ALTER TABLE ONLY public."CustomerPrincipalPlace" DROP CONSTRAINT "CustomerPrincipalPlace_StateCode_fkey";
       public          postgres    false    212    3496    226            �           2606    30583 1   VendorBankAccount VendorBankAccount_VendorID_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."VendorBankAccount"
    ADD CONSTRAINT "VendorBankAccount_VendorID_fkey" FOREIGN KEY ("VendorID") REFERENCES public."VendorMaster"("VendorID") ON UPDATE CASCADE;
 _   ALTER TABLE ONLY public."VendorBankAccount" DROP CONSTRAINT "VendorBankAccount_VendorID_fkey";
       public          postgres    false    3504    233    228            �           2606    30588 5   VendorContactPerson VendorContactPerson_VendorID_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."VendorContactPerson"
    ADD CONSTRAINT "VendorContactPerson_VendorID_fkey" FOREIGN KEY ("VendorID") REFERENCES public."VendorMaster"("VendorID") ON UPDATE CASCADE;
 c   ALTER TABLE ONLY public."VendorContactPerson" DROP CONSTRAINT "VendorContactPerson_VendorID_fkey";
       public          postgres    false    230    233    3504            �           2606    30593 ;   VendorDistrictMapping VendorDistrictMapping_DistrictID_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."VendorDistrictMapping"
    ADD CONSTRAINT "VendorDistrictMapping_DistrictID_fkey" FOREIGN KEY ("DistrictID") REFERENCES public."DistrictMaster"(dist_id) ON UPDATE CASCADE;
 i   ALTER TABLE ONLY public."VendorDistrictMapping" DROP CONSTRAINT "VendorDistrictMapping_DistrictID_fkey";
       public          postgres    false    3480    215    232            �           2606    30598 9   VendorDistrictMapping VendorDistrictMapping_VendorID_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."VendorDistrictMapping"
    ADD CONSTRAINT "VendorDistrictMapping_VendorID_fkey" FOREIGN KEY ("VendorID") REFERENCES public."VendorMaster"("VendorID") ON UPDATE CASCADE;
 g   ALTER TABLE ONLY public."VendorDistrictMapping" DROP CONSTRAINT "VendorDistrictMapping_VendorID_fkey";
       public          postgres    false    233    3504    232            �           2606    30603 8   VendorPrincipalPlace VendorPrincipalPlace_StateCode_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."VendorPrincipalPlace"
    ADD CONSTRAINT "VendorPrincipalPlace_StateCode_fkey" FOREIGN KEY ("StateCode") REFERENCES public."StateMaster"("StateCode") ON UPDATE CASCADE;
 f   ALTER TABLE ONLY public."VendorPrincipalPlace" DROP CONSTRAINT "VendorPrincipalPlace_StateCode_fkey";
       public          postgres    false    234    3496    226            �           2606    30608 7   VendorPrincipalPlace VendorPrincipalPlace_VendorID_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."VendorPrincipalPlace"
    ADD CONSTRAINT "VendorPrincipalPlace_VendorID_fkey" FOREIGN KEY ("VendorID") REFERENCES public."VendorMaster"("VendorID") ON UPDATE CASCADE;
 e   ALTER TABLE ONLY public."VendorPrincipalPlace" DROP CONSTRAINT "VendorPrincipalPlace_VendorID_fkey";
       public          postgres    false    233    3504    234            �           2606    30613 +   VendorServices VendorServices_VendorID_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."VendorServices"
    ADD CONSTRAINT "VendorServices_VendorID_fkey" FOREIGN KEY ("VendorID") REFERENCES public."VendorMaster"("VendorID") ON UPDATE CASCADE;
 Y   ALTER TABLE ONLY public."VendorServices" DROP CONSTRAINT "VendorServices_VendorID_fkey";
       public          postgres    false    233    236    3504            �           2606    30618 *   approval_desc approval_desc_permit_no_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.approval_desc
    ADD CONSTRAINT approval_desc_permit_no_fkey FOREIGN KEY (permit_no) REFERENCES public.orders(permit_no) NOT VALID;
 T   ALTER TABLE ONLY public.approval_desc DROP CONSTRAINT approval_desc_permit_no_fkey;
       public          postgres    false    3552    238    266            �           2606    30623    approval approval_status_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.approval
    ADD CONSTRAINT approval_status_fkey FOREIGN KEY (status) REFERENCES public.approval_status_desc(status_id) NOT VALID;
 G   ALTER TABLE ONLY public.approval DROP CONSTRAINT approval_status_fkey;
       public          postgres    false    240    3514    237                        2606    30628    lgd_gp_master block_master    FK CONSTRAINT     �   ALTER TABLE ONLY public.lgd_gp_master
    ADD CONSTRAINT block_master FOREIGN KEY (block_code) REFERENCES public.lgd_block_master(block_code) NOT VALID;
 D   ALTER TABLE ONLY public.lgd_gp_master DROP CONSTRAINT block_master;
       public          postgres    false    258    256    3536                       2606    30633    lgd_gp_master dist_master    FK CONSTRAINT     �   ALTER TABLE ONLY public.lgd_gp_master
    ADD CONSTRAINT dist_master FOREIGN KEY (dist_code) REFERENCES public.lgd_dist_master(dist_code) NOT VALID;
 C   ALTER TABLE ONLY public.lgd_gp_master DROP CONSTRAINT dist_master;
       public          postgres    false    257    258    3538            �           2606    30638    lgd_block_master dist_master    FK CONSTRAINT     �   ALTER TABLE ONLY public.lgd_block_master
    ADD CONSTRAINT dist_master FOREIGN KEY (dist_code) REFERENCES public.lgd_dist_master(dist_code) NOT VALID;
 F   ALTER TABLE ONLY public.lgd_block_master DROP CONSTRAINT dist_master;
       public          postgres    false    257    256    3538            �           2606    30643 +   jn_stock jn_stock_cluster_id_farmer_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.jn_stock
    ADD CONSTRAINT jn_stock_cluster_id_farmer_id_fkey FOREIGN KEY (cluster_id, farmer_id) REFERENCES public.jn_orders(cluster_id, farmer_id) NOT VALID;
 U   ALTER TABLE ONLY public.jn_stock DROP CONSTRAINT jn_stock_cluster_id_farmer_id_fkey;
       public          postgres    false    254    3532    255    255    254                       2606    30648    mrr_desc mrr_desc_mrr_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.mrr_desc
    ADD CONSTRAINT mrr_desc_mrr_id_fkey FOREIGN KEY (mrr_id) REFERENCES public.mrr(mrr_id) NOT VALID;
 G   ALTER TABLE ONLY public.mrr_desc DROP CONSTRAINT mrr_desc_mrr_id_fkey;
       public          postgres    false    261    262    3544                       2606    30653     mrr_desc mrr_desc_permit_no_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.mrr_desc
    ADD CONSTRAINT mrr_desc_permit_no_fkey FOREIGN KEY (permit_no) REFERENCES public.orders(permit_no) NOT VALID;
 J   ALTER TABLE ONLY public.mrr_desc DROP CONSTRAINT mrr_desc_permit_no_fkey;
       public          postgres    false    266    3552    262                       2606    30658    mrr mrr_dist_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.mrr
    ADD CONSTRAINT mrr_dist_id_fkey FOREIGN KEY (dist_id) REFERENCES public."DistrictMaster"(dist_id) NOT VALID;
 >   ALTER TABLE ONLY public.mrr DROP CONSTRAINT mrr_dist_id_fkey;
       public          postgres    false    261    3480    215                       2606    30663 ,   opening_balance opening_balance_dist_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.opening_balance
    ADD CONSTRAINT opening_balance_dist_id_fkey FOREIGN KEY (dist_id) REFERENCES public."DistrictMaster"(dist_id);
 V   ALTER TABLE ONLY public.opening_balance DROP CONSTRAINT opening_balance_dist_id_fkey;
       public          postgres    false    3480    215    265                       2606    30668 -   payment_desc payment_desc_transaction_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.payment_desc
    ADD CONSTRAINT payment_desc_transaction_id_fkey FOREIGN KEY (transaction_id) REFERENCES public.payment(transaction_id) NOT VALID;
 W   ALTER TABLE ONLY public.payment_desc DROP CONSTRAINT payment_desc_transaction_id_fkey;
       public          postgres    false    267    3554    269            �   �  x�}W�n��}�|�? ������[�AXi�y�v0vd썸_O�1a�M��R&�ԩ�s�k]l��ݙ�Ή��b5T+?,7+�y���:f�σPȈ�_1�ݬ�cV9β��T���j>TO��$�|x,�ͱ�2�;����ur�u�d�:�n��>������D()I�RJ�yH<�;F�<�P1�A�]
�j<�o����Z;Ӥ�-�E|o�G�W���UvL��z�+d,���'(Eq��i?���E�t����?��p��)��zZl�Q;jW�NWrtFe�^V����y�Y�lo�}��z�o�в�w"�2q_P2�>66����Ɠ�x�b�DhD>��UY�N��%E]�%�״,s�� Sy�nH�q�{|�����0x�S7��8�j5a�Jr��� ����@HJ�+5s���U�*H�ң��z(�.�?4�AM�R=?F�%V��n
���*I�[g�A�ާɡ)�����߁
0�G)����R�[��.���!�7�X�\=����Y���a�f�ֶd�T;m�"3�HIՒ����&b�����	a��T�МX��lv�'���M�n�:+ΰ�DW����+�;������/��>�[��0"@(C�����_����c���>��qf�v�g���OG��M+)&��j�Yz����}�u9�<U�H��\�+�i���S1��fa0��T3>ْ x�+!4m�a��cj�A[7�P ���ג���TEV7�$�cSi�
��*vR�
Fa�I.y�O�=S��/�6�b=kH0��U�L�2?��%>w9ׯ��W��l��g��9��.k���AV�j�}��=~���
2�g�6���z��'�KlA�ܱ�܅{i��},��4�S`�#������A!����c�0i����`��}Sa�?K,D�h���Y�K���aY�����AB��F�]+T�^�`zPݶ���ԌPN�0��X��N �)P��To+�7�3hP�!�_8G���?g�>߫���u��f��
IX�gI�����l{�';,1:v�'R�>e����eE���/����@�!i�IG��g5B��t��w��,� 6C�Q�y5E#-%��Y�BD_&�n_�A=��$׳� [Vs�9G��7yvm@�JL�I��#���7��
.ї39\� ���J-7τE�-��ؙ'����_�';� \𽩑�w��jg+P�J������t�0��\�z�]Wcu��Ub5� (� $e�j3ݲ��З��0�I��\w���I4������}��#kSX����R���V�hf�8ph�"��4�{p9�����YY�+�	r���g�y�.�9���O�&�l�8ü|�_ieϜka`�EP� 	��1:`��� ��\=ͬ�}(�z2����U~�#�{+���������^Z�'\t:8�^��g^���Z8�"�sd�]���V��	g.s������W��f[���hf���<l�9�����}�LwN��o��΅C��cc&Ɯ��ot���?W�y�e�<����1�v���z�*����qe�q�A:���(��}1	r#�_L�=�z۴�&���Y�s�ŧ�f;t0D���n4�%8�p?��z|ߕ��3�b�Z���1C�Iv��̼e�ߧ�q��B�|��׎����f���1��1s9��R��ۢ��6f�Cb.m�����%H1o|���܈�g�&I��_2�Z����˽���?�)�!      �   &  x��WMs�H=˿b��[����p��\r��&&������!c4J-U[> S3�u���K�傳�[���K�(P��*Y�ߛ��?^��!Y6����y&/��YmIj�|ج�/�dYT5���0��#�>�"4˹ȁ���E!�����`�����N��x9�f@��\�T�Z�>x�����)^�����O����$ܶ�����v6�J2�f�x1&�Oda�
;�_�I1�uy��/낶���" g�Ȣ����Y��޻��d1BUNE�!͠O�e$#���@Rw�usxc�8�ú_��z�6�ݓ�&_%J�J���sfR#�dȀ,�\�$�g��{8�'�_�v�!])�J�{|�(�\�T����ƠBۗ6�oCf�׻���O�fuܽ����5?��jVX��_��S9�T2�i�?�#� U2N�`����b�y9���V5����T
P�TO�䂧0Э*�0!�2�IE�#qWNI�~��|~�_�ݮӄ�\����U)@Թ���?b�t��A�$����\��j���<�'@�D�`<<��w-.��5�]��n�1=��Kp�%���\��%��i��̃�`�F�5##�e9�`�uͣ���Q<w�Ax��2Q��Z.x���JǍ_�îk�s�����+)}������ji���3�o�Ơ���V��{F�$�(��%.�V��D
������ �Zq	R\�;w?���=�ѹNՆA?far`��2ɨ�j�N�ϩ�չ��^�{;�]y����(%Ns&R�#5�`�&�
�.��P�Z%�&�`̵���sK��bV�{�����9��i-�d2���P#.�x���,�UWm#4��3l't�8�`h&;EOPÅ�:�	ke����8z�=>W����cY;\�f�+��볏q�_��M�����,�&�����e�]���7G���K׸�;魓[Y�o^x��!'H�"F�1\��r��R��~r?���� g<X����-�Q~`}e{O\�r��c7����}�qjdi����g�.�\kT����?�r�^m������Mc������r&ӌ����!�`:[�B���S&O���m`�cx�o��<�<��vW�^����q�^o_^y�S����}dQ՟o�iw&��?�r?*���׵4�~��+8zK���Epr�J�� ��};�T��Ϩ��xn;l���a����2�֒Y��<�h��
�j
$R����aL
[O��^գ
�Lfw��\�������d���� zIG�tZ(~caB2sݏ��_��]I�EEm=�Hq�#�4�V���<��777� s��       �      x��[ksɒ���+��1�~��-È�R�G܈�����3����ofV#�sw�#��>]U�'��,I�|�M���/��5�1Ó�x�)��|��>�.�r����M�	�;�s���e���{�_�'Y�!�g�&,=����|�y�7�GY�1�:��3��F��xټ���0��պ*������0M�S���P�V�� �g�a�(��� ��7N'�b���J�O�d\~�zP�4��<��D�� i�Ų�6�w��j #�^Zέ׈	���m^Ϯ.�	�T2�G`��~|�n�a?��NK�C$K���%.p3��7W�I�d&��G`��<~�gw��Z�԰�w��Iq�C#�C��Ќ�pt�:��v��O��YB�,�E�-���ޱ�pp^��X�����b��0�O����B�3�<���tW\��ڥNE8�pl���Oٰ�%m�MY���^+���������/�$o*�/~���C8
�A'�3k�d����q��E����
��˒��M�\�	(���!��p^�nN��g���n�(�%cVuL��`)��&j�`&�F6�������.�)�����0�ת�^̥��b��!D��"���w��g�V�}�XƜq@W,Y��^v��r�Ia_�@Ԭ�|jU��hĈ� HH��h0�B���\�-�����c��@j�T�(�5��#H8��-�q�̸�ؔ( �	���SD�
A
�7�#>q?B�d��r��,��i�*d���|/�%���6�J}̖�h�Q1�Ɇ�=ld��5zٗ��i	Ģ���q�(��#4 1eRge�F�Յ��'Xoh��A��I�9xK�O*`2��ɲX[X��@h�5�H��Õ���e7�v���Ҝ��Y���p��gY�K�� �m*�!�qDl.��u�����L	���,�f#�>dy�W��4Vt���1�6�h�&�?ʌ��O䦠A�@x.��k��6�x��E\��n������7����A���E)�HRG���xb5XM>�z��N6�牅����9_�$e�y�" ���!�����{2��I��Z�/�iu�(�<����x"�V����7ZX�0B�� э'�u1sn�)p�FE#�x��=��/�oŲ�Ym�X6��'�)���P��4�H������I��g��iH2+�Vo�23��&SM�S�b,"OdI��2�Q�0ɥv,�U	�Q�A��P�	S �G�i�G<��m�C
�n�>UZ�EVjk��b	�5/fS,��
�P�E�J%�%6��&��	wY7o;@�P�,<�H^�-���N�4��� '�cc�R<QJ�.hz�	
䭂0�G��I�!���#V��*w����_�vH��!�?���x7/�].��U�p��Gk$Pjm'`R�!)�e�jy��MJ�T���8WAvs�}���B�0й:)^�
�YQ��%����+��r�3 T;�S���͂ʅ������~!�y����fZl����4��'G�N(��	ml��~0�$�AH��C��fk�4���K���`:��5��J�c>�jU��i�f�2�"�W�YLz��EKv�+��Vp��I����f1\�b	H�Y��G$��W|���-fi��m�y�Q@1����b1Ne���ְ�����8�'0A�)6��KYl'����9��S�u8�e9q�7�#ut;zRx:�#�~�9y���a_�m9-���:�����S�ss�,�����N�d\����u��N�QLW���*�&�fN��)%��z��!\���#�U��tY�L!?@�"�R��K�¤q��S>r����$�X�? ��v�h/.�������(]8e'�<}��#�#�N
ěS�|���z
��-���/	��9T�<fpJK�ߍd+�L�Ǽ��7`����wpE�,�QQL=�7�ԍ؛�N��՛��Z	�{��~O���+��i'��!�)�$��X�����޴\&�5 w�FT�
��q����Q|�kj0RQ�
"�+�S H��/;��<`,�"�/��9z�f�ݬ�9���'�q���z)˅7���3������~~�i2��e�p��_?�w�^P�(��d�ef�f�^�+0I�o�9z(��WR�]�R������H�2��Z)xe"���+b�pA�q����2X��M��A@v �3�k��d�)�?`������?
p
�.��NR�J
�A�J"��=.��}���5�T���I:{�_�mS`�3J6Ia-u �m��������8U��~.�bw)��<�LmX�_����/��������I��bx�MmLW��V��	E��Y��o��f#�<51H*(���ݱD�Lv��r�������G;<��|v�5QG�?��f�s�_��xO(�U�S���^ZcNv{�+�� 	|����bGa��`��w�����on�����̣�W*���)x�q����E4�L�?E�hSh����>qh��T3���O��ۋm�c���Nxkpd�s��НR�Ql��=��50���
`�ǘ�xak�O�s?��և�q�}��b������]�,�F�1N7��!��>͜�&����6�4ה6�q���`0"�n޻� ��w֪����H�,R
ݮ�{�.�kF���3v7ؾ���N���>,P��G+s������ˇu���5Ec��Y��^W������P%9P�B�#����~���xȻ�A�O@\N&˲Z�|�,�Ŝi!D�q2`E�~.0Lp�O�0{ �i�Q[�@y�ɺ�b���N�m9/�=�.�S(N$Rw�] NDSOY�}'�4Ȓ0H1)�!j����p��2�
���O�~�g��S*�Ap$�r�a����p}���f.������y�<�\��].��cFeH��̈́�=��{2ԛ�m����Z~��X���H���{�&�zR������-�f�\��~�9V��k*A�{��QMt�s������bW�[Ş���������`h�+Ra�VJ`�`�ar����b2��]}��l���=VԼ4�j}����>R�с��Rp����N�H/�9�i����(��	�����B��Ȃ(��1�|+�Zr�B;S�,�=$&1{p���Pɶ*��L�Swa|�Z�}Z�'��nv���=(����}���Ò���s��N��~�tk)K1��,�����o=v3�2@t{�cldH�ı}�[XeT�|�`�nhp2�Z0uy�\����f[T��nS.�e!�E�0fS>�����B[��}ٷ��+���WB�VKy���
�Թ��|��;���M��~북I�X��7��`_���bb���D<���@C��߀��y�`�U�ÅUn��U�ܮ_�e��:���8��n�fQ�F@����O!IA���=���0.*�蘞�f򭸆����	����)jq��nﻌ!I�Εa���l5){��o���;Lzu�+6 ��'�`��xZV�q�����W4��54U�Zy����n��$�_�S�{�"kl׎Q�8s�$}=�����,�O�
� 1��*mѬ�@���z-��/�� ��
���VƑ���Q�����9V���P2��Z��Kg������(�ãL*O�l��p�r�Ԧ���.Y7{�:Y+�T�kpA7�bZ���03�;Z���uK��3]_xH�@�d����V+�P|j�����q/��'�}w����=�4�'��dVn�&/q8:jc��@M��Lq���� �Eq4��D�R)d^<�Ǟ�j���p�6@`E������"����2q�z̤ć �j��pS��z��x�ؤ�%����J���)�}�g�������E�d��l�%WG8�4�.A���&E,���F��w�PJx�O��m�S�k�?A�F=UR���7��{��2PQ�/��G1�7�gJ��EU��e�E<^�tK��o};���:�9�{+��9��ij�B��?>��� �  ��	�ni����M �����õ[�/���A;�bu�è�k�g��ھ���Ns�{���׈3�9*6o*ى8
���M@l�?������Q��E:�!ޞ���bQn��%�v�3����w��c'L�}g���l)Tt+B�jK��s��;��ZN�5̧x�����%�`M.K0?,K��s*����Z\����-�!^<>�ݏ#`	���nK�f��QO\�k�w|׌�I��;g�/x���L5=����� ��l�}	���Ȋ��<�a"���g��V'���~tD���	�ZmIa55{���5v����E��pK|�:H�FX$�V���fz|%�_��by��"�T�=��Yg8G�2j�;������U�ى�lnG�|��ǘ�P���Ω�cR_��W��9��@��gxeS%u��	��Y������q���6SJn�Qsbd@R*�W���R�]��P��lJ��Sq����]��������P؄�m,�ӂ�^���\�㟐�a<ɍ��&?��u;0���ȸؤ���EH��B�S�񸬗I�x9��?��x����0��v�����Mt�nts����g0���\~}9z�8���ϯB��J}�
KX���7/��u�e��wۡ����e�gPq?��aa��i���4I�ȟ;��'���6�13���� �-�C���er�܏�h@/�;����_�o������"?      �     x�m�;r�:Ek{�3�  ���,!����AYDF.����o���!$���o�_,WɗjjU�����oF����~iK�����3��Er�H"�F���i�Ty15D����d�����1�(u]�� �W�-n.H����K@�E0e�ba��a8����\]��v	%�����fQ����M_�H����!ͲG8d�H�.�$PG���K�×H*\���sB�E�\��2K�٩���:K1�O��̈־�Ɂ�R/����9�S��(W�4x�4���&��YCFzbu���R⺊&���ӣ���,�ڊW���>\�_%�]e}'��1����3�_�,���DPl2������MF:��C��O&���WƗq"�g��қ�-4���ɠ'3���H�4k���=�OF���LK@�Yc9��f�u0�i]�)JK�<BI�3�N&�U�ip���gƉk,��ҦR��Y}uš��(!y�|I���0����&�ɦ \����r-Ӭ˩��2aYES��@Akqm#֘�8���[M]�03��ͲQ�tK��27>�2���0�<MNi���{Cm��
�jy����X�P^����JE�>-��N���9t��L��:wۉrK�J;t�-��j?t�ּ�t�r�2w땂�T�P7S�������Ʋs���b�����р閪�XǏʓ�b���l{z��Y]�>Nƺ%��U:(`���N�!'�j�(��5r��島e�(o�m�+c���z2�b�}w���"XQsv�Z����g	y�]H�?	�:>����!!�P�7����'�XPC�o�ڲ�j��`g:�f��b�iC�Ԩ��uD�hm���x|����6(|	C�n�[ �2����O(7�h'T���s�)����M�'�ynR�[?K ��k��ǜ�v)�.'�p	�j�˺��'��]��ҡx��^P��K��بfbVo�̇��R��V0��9а���[�@cz'��m�d�;s��.�[�G>��Ӟ�wS�Y=\&�~ސ�!���!���nn۹@c��]v �����D����\v[�0�U�j�ٙ���T�����P�~ډ�:���Z���uBӦ�n8N�R��S�i թ��_]�!8LtUʼ�����污��2�Z���yCㄬ�b~��dgV�? �J��Sܻ���]�	�1s3�ʹ��`ʆJ �ů�'��%�Z# ?`���\�F�P{Cb��Ӗ����=1�&��v���8+�Z�m)^7��.��`$z@@�f����DiZ��L��w@�}��G)�}d�.��?O�~o)�y_=tv�L����:�O�|W����y�k�N��6Ě?,p}�}�u�ry?ʽ�5��	gx
�Cn���5�_��?v�;-����NK; �V��Tww��ٝ���]��~�rh���`�CfKK���7�
hB�NHgk�q7�o�c���j��� ;���z�P�9}瀺���C���[���$vC����l�7T����^]��[8��Y�|��_�����%q�      �   �  x�Օ�O�0ǟݿ�{�T��]���[�	BՈ=��R�,�xrڡ1�ߥZJ�T4-��|���ΩN&��r�a�8v:��~����Ov\���n�M�,�m��+l��vQ�����J%���  CEE@}	,/�A�������s�� .�+� ȸu��޸���8��8 �g@0�4�F$�z��P�� с��4�E���n�A.�L�,��1/E�i�h�t"������=�=�fpO ���V��Ϳ�fu����5j�G�"�t_ʗ�
���J�/Ϋ(fG_"6r��a���vdog>�<����ep�^6l\������=`H�T�g���az�0M��#Y*�1��4�Sm#�7�
��zm�Лn��.^�wxiB��n��4����ݽv�n��ƓӔ�+�����M/�6�~�k�������Z�b���G����ʁ�rСH$�q�-1�@
<��tUg#^T��X�p!z��/��R      �      x��}[s�8��3�W�ib;� $视$ڢuc���������T�e�$wo��?� ŋ�r��v� 6�m}�L��,硓�b�ޞ����7��\%S5t�8�I��ۍ��,vz�~����'ݾ�n����v�Z�:��4:9Q䇔������s����s�~��_�F���ŘK�&/��QB���ꍒ�?��Ф��N2͔�����0Ž��v��9��pt��i(�|�O�������n�\�N���	<"dN��DN��g�[�qո�v'N<��yxu����y�Q��w*<�$&N/(���5&!��O�K����,�N]u�l8�e�;���������U/S�߾���]n���ɽz�s���|_��g�q��n��-���7�{o�� S�R
+xA�GCV�[*���L����p2�ʅ�Wj�\�8K�$�s`�)l#�~��r��n���x�D�잁ݶ��g�aҲ���]����=`�%F�2�v35�:R㱚���8�&C��9��*�D�b���9q`�� ����۾��)9�	؎J�QӘ��+v����4�ej�8�|��ڽ\n���/�;��n����������H;��dx���yOK	���S����~۽�=f�'AseE��-��e���w��)m��U�4#I��htδ�E�	q�_=���].��q%Bx���\/!w��0��x^e߁Վ(ջ�$�x��v�YV�VS��p��CPm�C���x*�oO�m�|z�@��a�+@X���U�O����g
W
~�1J��
d��gi:L�T^����"5��1*%uv�^y�w��r[�H��M*/h����S��Й��@��
�o�S�[ªz�iJhHb����d@�� r�_��0��*� £M���u�HUQrY�Ij�͝N�*M�CB��4:���<p��� Z4
N��Oak=Κ�����,SY���^�ҩBY}��5�_:�;J�|?��E4+��ݔT2�[���]����z�^�O��N�N��=X����f%�����j`вt�Zf2v�h�^��lz��ѹ��� u맧����뾐��_���ņ��|�T{��`d��?�7���}��: �נ�;�n��y䓨gc����jM:�۷�jSܯ�	���  ���������T�4�x�^�ku�jxfn:�I}��W�Pn�XQB^"#��,~:p�6z���@��x�6L.բc��\˯�x��Y���*Kz����l��'b��BF���%��O�\��k@L[Yֲ��{F I햐�L0�!Q��Hz	pX�La'Ls�ԛ�\��Hd�!��� ��	$w6˿v{0��#��{�ēMie��Ø�:�xܛ�����Vu�Yv�� ;=� �.-�V��|h�0s�;?_+swwr�(�e�q�0L{�06��^|'�lC�R��j4F;�ۗ���Eǀ��E�X�V_4pa�y��AY����?�S������ȁ��~ʍ6���k��LU��B�|wAǸ�	��c��o~y�X�!��h��Zwm�`�`�'����Nmv>�
������w/�'؆�_�����"�F�����ir�;t��c��&��G����o_x�L�_.��\�������<�5��fFX��n_l�-$<����V~{��3�za�����r�~ٺ���:`v�5h6�f��ظ�%�p�aX�7'��	2I7�� �T�v7�R�X;g��>���,~x��F�^0�����uψ�w�3������ ����+�.-�iP��W��	�!�KB/��\��D0^%��U�@L74���xڟ9�A�D�G� �5�λND����־X�˼>i'�B������C�T�����ͦ��� �rFE�����r�W�]��m��Aq2J{�Om���F�
�E|�w��n�����8!k�i���������+Ly>����xy?�M��]0�	^�-�Q�(�ǂ@��}�/�����I|"�`�e��'0�*���+�m��v/r��n�`7����NA��T4:���"�-a{7�m	��)r� ��hS��ւ1��8�ǽ�(�	��JMg�2��ԧ�y]���y�J=��o��نQ٪��;�;���C���^��{�J�t��-@/�^������o!�|��\k\� ���g2<�k4�>CgE ��{l��'����4t�ZƖ) �6�Ǫ�n�>��B��D 7`j���V�O������b�n� Գ����`�O��
�	�$���|�1�G[�AP0�4 ��
)Vo�zؾ�b������b�v��9�����G�]Md�� 6���)�w?���q,@/^n���:�U睯ԭ3ی<{����O-�pM���u� 
��Y|�.g�y��'��Nh���<0[���t���r�����1��Ō�zj��F�2�`�`o#��ھx� �:q����s���
��8~�tg#7�|��8u���5����j�
��o|(���B ;?W���1ߕ��I���)���!SЗ^��1���H5�߽=�-lG�����H�j+	c?�G�y<�'���i��2,�ǚF���#�s��dܝ���A)��j���jH��YL;򠹬Z�X���9��������7�yP������f�N�qޔI�2`<p�ag���a4a���G�� K
�y� ��,��NC��h�M},�	�8��3�b�|�'�)~��wN���,����
�@L���#:��1̀�g=��n�S���=k�9j�OS�8�iɊF�7ƅ�DUC��vB��~�O��ss�����J����C�E��p��-OSN���`�hx6�xD �����a�-Z���iX(p�Z:[+A�n NSY2��V�2��o��j	�jZyvN�H8��;�ʹ��p0���Ӟ1��l *=�g0���5�]��&�@�c��0�j|��|�%��it���Qa��}{|.6kBPM��ə6Ĳ��m�a���81��Jij궟��u��Ēj�i:�
����o��#Y�����хx�
ֻ�N�a�ٍ��aٮ�k�=n	�9r�to`C���]�<���8Ͽ/�o� �;��$DA��HX�|���T�s�ԧ�����xܽu:�JS	���d�����PP��%�;�=l�	mg5%8����R��PpN��9�|Z񴳺>jm�$-NC����2�U��Z�A�og���V���Kg���/�lbkK��X���F�A�^;�f���ޮ? !`�L���=�I��f�D}�z�<�����Ӻ89e`��3���O����,Q�t���g<�H��N����	�I6��~��5}پ|����w�M��џ����X��7�C�>o��6C!i�a�g�j��V��k/����/�J�49i��6I0�����p�\���-���LD��N!;��k�����V�?��dS�Cm�`<��K�:�տ���	����m��}t�U������Q�F��l�mU(��t�1f�s�^�[H��=?h�6Rap�:�����-���鏚+jj��s�^9[���_�)/�i�/^i�MS(����,U�s�^�[Hمz�Ul��S��J�	#�j������ǘ�5���V
�C�C?Fc��\&Ӟj�ų^:�z�(6[�-�xf��6l��JR[��(mnQ�g�|�b�o�@w���.khW���1��d�g�q�^�qA�4�u<ߝ`nZJj	�j�"� �� b���n���~ǸΨ3L��q'�}�QM}�B�Q��c��F�	E���t�sZNk�CF�4����ܻ���´U������d�˓�0��QSu�"�[5pt��]�j�c?`������)�p(��������$0N��l���B0fj��W�j<V��5Oze�t3w��v�\�<��j��J	X9\�m񼄭]n
S�Y���Dk�e����Qu�	����ʷY�|�@�ȐY�kk����@���    x��"���܎sI�c��Fj����Z}������ҜS�l�����F4�!ጝ��&�JB
�Ԅ��A:�d��zT�\���meo{i7�5�U��<׹7N|;
"�y����"�S�Dj{cg2���x6�6�w���9���j����2�QH���Z%<Z!��i{�#� S���ǣ���;�U��!�0�4:�� ���?[`�����-�=`�D�7���۹�N:H�Bpj���F�}S��$���#����P�P ��
��ʇ�ǩ�=L��v�<�wҞ�K�NM�%٘�Y ��X._�G��Z�j8�M`K��LPEZ������t�����G�:K�D���rMC|�`��#g���Է&m�<�G����0��LaE�^��g�_�a�Y�bM����� �`���?�`~xpBob����#M�i�#(�l��O�uBݾ�ɒ� w�qon������o'{ꀦ��Ч� �kUl�x�U��h$��x��Xn�П���0��C��R�7���u]}���T�T{E��+s��⁇b��x\a�8u n 2~�K�MU�U<�؄8�V�ĝ��@:zl���B�;��r�N���+֞��e(s�{dܧ�~��V�^B������iE���ɕ�۵��;nQq
2I��¾�ѹt$C����⮸[�=��~�x}��Z��lh#����P��T��N�����b�j�_��"!����6��nb�-��G�$��jz�v� Ҷp[$xd�1*�y�y-�i6L�r�W�[ng'���C�^~n5�����`O�T$����ݽ�O�P���SD|�o��T�SY�� z�� r�(5C��kY��F�q08�>qv�5�.����Sqo+)6�2�Ք�F;���u�nZ�d�*���J%9�`c��ifC]ʈQ��e�xBeg=�1�8��^�j�!�&�֫��_�J��X��k�a��ט��cy�'��4&�>�ML��a2�҂̔���Y0��E���h��Y
���?��5�z�����L�L�	8?؈�?��Kgx�v��؎�k�.�"�`GC��DX��G�i�"�Y�:9��V�����(�AD�6��@��t$�A�I��r[�n_�X�Otj��n�hkMcL����ͰM~�����X:fAW��Xj�JA�hA%�Uo����i��_>��lU��B4�@V�1Ô����w��lZ�g��Hx�f����i���� t^�\>�-��Mǧbxuf0�!����,�a�>�KX8	7��<���|�to t����4:�5�&L
&�@�C��۳�Ѕ�K4�c �Fcz,��{�{�����Upfm��h��3���GX�Gt�
k�` �x.5��(5� &,7IʥÜP��d��	b���c�!^G@t��h��Ҳ�&,:q�Zt�6����A����n�4��|5M��n�c��j��n&��Q3��K�r=��\��0��^�#����[����kM7 �h���s�/`���Ϗ���am!4��|Vg�L;i���3��+r8I�Fl]5M��COC�������G��Zt�X�k��}�05����Tû�#�[�IM��?�@  ���b���yNn0��n�d����0��0�	kL�$bC�ҝ8l��]���������)�{����>����V�x�Y�F�6\� [����7�C�IS��9�5���$��g}Ħ�M���ON��L�	�4���M3�n�i���'��-z�����Vw,�;��z+�(v+i�"<��m]�alLC5�c�D�d�G�<R�s9�V����t����c�Ta���e�B[����Z�\����t0�7*]�M.� _S���I/v�W�i�s�ly��F缩���̄�&J�����vM�e�sq��ѹ�\�\S��ӨOe�9�)�@-^pMC{��2�"#g�/��Oo��f�.9���x�skk����d o�����$�xy���ϱ#@Kt_��t[����+�̍0��-��B�7�f�5��8峡����L�17���]�g���d�tNMch6�sE���l�ݪxZnO�<�&B�V�5��zjW�U�~]l��_�s��Y-����Zoc F���o)c4�-.���<�
@�XV�G��9
Z�jl	Lu�.�,�F�k��w���ݼ[������f�0ǖp�uc`XtT��k�(D� ����u�ܧ��wW���^�:i�P�(��:��4'\[^���9ՙ_; �;𴋭�ٿޗ��dZYֵ���feZ�p������؇G�b�i�������	""�B*�{]u�n�gq�ّe���^�J#��\��.���hmy�~���B�l'��P~v1�A��ˢx�B�E�-G�t��T�Z�*���R�˱ %�92�������~(��b�Zo�65��;\y�>�\�{p{�;����^����No�f�)�wSѰY�a$yE:�|��cb���gQy�C�*���1ͷ8��B'U��.�M�1�!MӔ�js+�Bl�fDB�_<�__�`M�D��$-�2��6u9Uu�H� ����ƽk
���TJ,׶�4�vH}� �J�_���	���e�X�b8�ynx,lZi�C��,5�Be���\��S�d�Γ�����@X���F穹ʐGTP��z-Vł멐�(���o%L�2N���5<�"�j��j���8c{�-X���<^��].���,3;��b��U'>�a��C�`cL|}kP�D[{� �� 4W�i�:�o�,�>��=M'���������s��$JL���/[���A�$�.��1���H�h(����1L1?�����?�˫NP�s�oVDRn,��[����7�9��+p^}��ъ���a/�g�����x�^B[N�+P�}��X�ji�JQ�{�8a�����wM��MC�Q���z(B�Y����#��֊�L7N����U����h�W,�˥�Қ��x�x͖��n�_��rZ��ߨG�U���7rGe׳q�@�r��v�;��bM�״C�S�K����1����bx#6��S/�4��-��f�ҽ��T�.d�h�Q �#����o�_�#x	��R2 �!��LiE-�n�软���o�K_+k,��Vٲ&�X��X�}7��2a��5v��G����12,h%��iɭ1'x=�{7��4���?!�-<�H;^2���t�j:R6 �����'S�/B�#>�@�i^�7^�hL N��k�g�����&Ј�V��h𨪼�4S���N:
�����S��*eD#�9�u'�{�CPB_��9��V�ϴ��T����ʵ�o����F�Z�yM�]�x��#P6�����d.�5�V�0��2��K'�;ꌨ����HM��5���ڊV�p%�9P>��O0I;�4���n���^5=�8�{�F�^j4��Y��x�O.x�q��0:ew���kYʚF�m1}E`1�ֻ���5p�3x��o���i�x)	Z�\�A*�eRU��A�7��<MI0�|��{ �@
��Bf,����տV�E����i��i��Im�o��(Wɻ���&��]�Z�4�V$�_�5n�qL]A�8���M-fz��i�b�t�2�FCo&[§Yܵ�棹��F}��r�~�>�#1R<�-D��>35�8�jz���e$}8��<�t��<$���kځ���t�#���Wh����?Y��&�mݵl��q�����ST�f}���i��N�+�.�Л,�&�c�Zo��<QB�����h�77��y��XO�?�� ���͝,U����Դ8P�掫��e�jvzӏFx��Bc@`�g`F�7�MgJ���z�u�A�#�ż:�X%%�5_���ܓ��tz��i],�e�E���.�9����ȡ����R@�~��s��Y3�6]�8�zwk}��K����闟����nj��Pb���;�|�.�]a�(,Ɂb������Ʃ<<�K�n<J;L�6��}\D�;�9 �  �V�5>/�/|�l��10����#�_�?.��W!�C~�G4F��c�����~U�
ՓX�no�	��YFÔ�N҈^�R�=�Pt�e��M����tA�E�����Z8|p�t�nQ�b��	��t���ˤ�iu��PԠ�f�Z�gO�X[��&�*�='���N 𬃕����'!D���}yy]j�t�{��K�A/��=z$ P�7��揣��
��k�o_�m4�?�ꓳ����t}�.������S����y���
r�l�֌��k�;��p������؞��Ē�PF�s��[9�Bg
u�F��U�F�����J���z\)����2��o���?�WK�nT&Lx5���2F꺟?�̿��M#~�-�o�-�˿���2&�X�Q�0}&�WWW�&�G� ~,(��&�-���<ݩ?֨5����eԁo
��{a55����߸eV� �ݑJ;�ё�a/Q���w��/�Hux��(����`j�4�&L٘�`˘H�Gg�X��#_0k�ME;�,�(lW��!Z;����aX�w?���_�$������3��c?�ܛ"��R��G
l���G�W��@]�a]d9�e���f����rhb�}�@�s�c�B1�q �o�����*��      �      x��[Ys�H�~f�
<�ĐP�8�Vi"0 �^w��c�m�eɡ�"��ofx�
p���D(lQ�3����ˣ��ܶ��'��I�t��0|�~������eG	c�?L�Kg<
8�s9gI�����Kf��K���M�$�������o��󏟏�3�����������ׇ�߃/�ׇi�|{�{�yx�~���s͹5w����+勯�����I�9�r�5�][�A]��4XdfY��I����0�ܑO��������Ϸ/o�ܞ�b����t;����yO�H�J�\+G�"%ɨ�h�6�2˃۬�������J�6uO��s��G�&E鿤�1Y4�ղ	���m;5w�����T+���Q�j�~�����3(�5�A�px	v�/Ϗ����OP|�'UP?�� ��hL; ;�|lLL.M���������|���g0���z�)V|$��U��b���8��4���Q��b�ŋ�����
�璅*u��0R�~���÷oO��q=��i���$���_�� |�%�E�n�DG���xx���+FTg���Lm�������섞�$L�t4��xD� �*̶-���kUH���j�:kDg\��b��J��[#\�����~vR�f���	\P�W��NG��L�7���%悅\:��xDlX��&�U�3x~�C�=�1�b���2D|�~��03{��w���|WW�>���.h +�1k����7�I��l\��H8��SvE��
�&U�4�d�ܔ��d�9��`[�����0��Mc��:��]�:�p������X��U�D��p%��<�?�_ ���m@��d7U���G����Y�BJ��a�RL�;S���v���� ���ؤ�8�ܕ��T��#�F��I����~���s�)F�E��H��s��\9D&%,��ѥ�MU�H�v+�+Sr�(]�H�K-�C%g���J�	p^{�4� �\O��c>"���)G�J�R�,rŒ����2+�����)9X<�`Cw����0��+q,�9`�Z!��uŒ_�#~��I����
�X�J8�3�xį@'s��Z9N�� zgz�"<���S�#2�|���+�%��#Z�RNp�7UјƔ �-��9/�\̙@2'�3�t$|(Ӊ���24n������Ê�x2q�����uxz��
g@Vp�ֿĴ����v�z�@_�B".�{�n�6�'��t�)܇�)�Qw�l�dL�����Y���&V���������W��;������/����P��%��ba���d�������St��%K@�0Js�tM�ߓ@X�0��H����9k��GG�`��� G�s{�媦��&k���E.���!<�b̝���-(�`�u�8��3��.Mˇ�L���[�������>��G�JB�5M��|�@�_"���r$F9|����O>�H������9�~	Wzg>p-�B��!2�f���q(S�,��2���ݕ+ L�p䎿F��?k�)Ra#���_�<����qe��2qP\��%�R�e�vB}Dp!��,�P	d]W�!��`�Q�2�}`���l{�$+�#�U�	��G�xz	�<�$Wî>,R�eQ�5a�i1���"%�"�l>&��N=,R�H�)2�K��I`%N�t�rس8�������Wk� Y�r�L���k[���r�(�L��㣗�3�M8xWTU�l�-Z��R��jo5�������V���00��j�u���X�w_{�2uPoo���7�}����\e6��*�/��ji>�S����&�2k5����j�����-(��As�����jx�<ج�w��M{���J�T�=�*ȴ�QA�:/�0�35D�Kt���
A.q�VR����=��@r�n�V�dD,��Na�"�9�����V�c���s�(5��.{��i��{E���&���X CX,w�$�V��G�廼ȷ�Պ��Ly�@K�Gj�X�P��|-�3F!������B:�Z�ƮT��8���J���G�`��Z��b%+E�K����r���(&�L�b2Va���m�pF��\�������A�Y���
y�CQ�s
��k#K�l�ԛjV曶�Z�7Ymy%)k���u�ׇ%#�:R i"}�x�����|-Ќ���J+�s��Yu`��0q�F4���3�Z�B�.V��f�`;iK�K���-P���ĪM�V��C�9'�K��|�IcEho'+#}���Ї�dd�}����N�N�T�sr�$�
�Lb([�Y�K�Y�����Cck5v3Y�m6��P�3�VӾ�`8�����R*�z�>�<>I�4nߞ����$��oL{z�#�B�9'Hٰ}�1:��,lz�138���N�*�bU.a��j�*o!�({��?a��MA�����_1� ����)!
fOv2�=@�al��
YJ3�V0�4-�ϟr'�qNH�����T�
�n\kl�+��9aQ*�vK��w�9mW ���#F�����(Uc ���M^�3�|�%.��
��(�����!��7�8]c�S=NZ.+������/����U�G��MS̞q#Ф& P)KPӉRBo�����H�D.���)A'���0k/s�zTW�W��Z9�R�(Ja�c���j�����ْ��@�@I̠|���\tսL���.�|�}9ak�y �c:X��a6��1��H;����ֱq�8�H�M����k!��S[C�!��ˇ�	�d���
mA��`�������_#��M+p�ء�kھ̳�`�Z͕��#p�ݡ��G��� �N��n3;����<�����GS`U����Ji5� �:��6U9��ŀ��|Ʀ�Ȩ�ē]�,����,�"�8�"#�&�H����4+�;�$!6�|E�ڃ�%,�lM�g��Ѝ?���l}X�^�ul��w���� �}���35��i�>7��r�!�rWd����Q<9�����i�e/|^���<0�i9F�?��#�v+9E;�7(<��Fea���П�)
��3̋j������nH�����=��@�G��@�n,� i���K#��xj��r+$|H�V����$\Q��b��) |@����qR�j��i
u�Z��.s>�G�.3����=}�+�s��bD����:.�*���6x]kG���dյGA�ߣ�1N�����U;�,8�p�p6���������V(�s�Z��bn�^_��,���1�?ꕒ�ܶ����\��$����X�-r�:3:)n�6�̔�A
���ǅ��2���HE:5�$n��k(��ͅN���+�*����3�
����,��ͦ�1o���GhN�C?�!�^��ɈG I7����v�1a�R�'1�S�����!�µ<�EH�B扖vR��z>�����Ra䎤p;~��wPn���o̱�_��ma��Յ���=X��5��ӗ�GДR[�z�d�y�M�r�^��nfI2�f,:���`�Д��� `�fX��j�0W��I�M��Z���?? 8N�28̊�T�[���l�����S+�&z���� j�
�|��.�4��>(L�ÿ�:3[��7�+��л��^��bg���VT��F�I" �(�`�BqO����P2�`t3
���Y1���FH���Dv>5$h-��h��~�\-`1�6�
��u{� �l�.�<F�x�M9�Xucm�:��`ZK����HXi*xss���jS��M�v
��^�\�@��f�37:�S�;J �fďC6�V�&k륳�;��8�v����mK�O�F�:���LbQC1��fo��"c��P�.��2���vo�a��L��	��:%#zG�3q�܎K�^��	O�M�(K����Q7�0���u��`�C���0�0�����S�Xkl:�f�Y�.�6L�K)OQ�����XN$��`�J�ʝ��v�Y�/� �,�p�Ә�� ƪi��ߠ��� ��fp5���=<��k��o$ 5  �/�鉈np���?�����הq������Ū�{X�%2,7�ͬ��Z}��5���S���fù��a`@��M8\KW@���]�4��S�.��c$�8)TH������%��g�>mȈ4&C�}��n 59�0����+�ʎ�_�˲���0߹[,�r��l�xWa"���~:K�h��v!I8�4BWlc�$�������+�C��\�Ɏ.�c W�8�E��e�'����h��O�
���4M��T�w��B��?>�X�E�[��l�rHK��y�;��,�Ң&�f�"��r ���Q�c#ʲ�X��J;��Ckq�����y��U���O�x�-��&�d���Casnv�׃�p@K�h�7�<L;��uٵ����vW���_�^Fr��;/�.�t���a�S瑡_m+���0��;O�.6��I0��5���v,էHYF���)wި]��_��2}�x��O�fs��;/���n�y�WK�E��f��w^��@&��3�v��<��Q�
S��Ypޟ���N�@���no�~=���Q'�w�gn��|���o1߱����hk�Iq���x,��徆�s��1%>��3������p"_��q�k5�{VvV#����
�����ry�yِN��x�=�gߜ�h�qz�
y��l�{gmA�.x���s��jJz[��Y�!�~m[m���67���%l��?H߬�e��c>����{'8�s6��c������x]��u��ӱs��Ћ#F�P�Sh=<��p���������.::5%�1s�:��ǣ�Q�b]W��AV5;H1�s�[��e��*��߆V��B5$��]��x�ZJ��{�;��6y���b�	B�ҡB���i�"��	�Xnp�rD����^_�E�ޣ�� �n�h����tl/�gBE��;
5��J�y�Q��E��<.����lU�V50��w��p4�Q�,��{����BR$�\Pe��K.z/�.*k��u�˱*��B�Y��uҦq�2q�G��|�7t�c���D����ɰ�{��S��o��/��,�      �   R	  x��X�r�L���B`�4�W;6���^0_6[����`��)����
�-��gL��������Kg�Q���_�X����2�,��S�����"Hw����e�$��LJ��(�$�%�A���Q&"�t<L��[QY�c��n�y)����͛n�6�L��?�a1�M����h�!��+�M��i��S�F�Xߏtz;������6�i8
��ˋ`lVKS��e<�5���T@�g=��2"-����,��a\Mtz=���1B��\�\�4¨�)�����@�w�OvsD�>�w�m�g��z]��K���Ep����lna���S�^��2��(�(�R�(J�/ �{L� F�輀�1g��+=��b�(����1��O�7z���ٓ�vb�f���i0����Y�j��d��w[E���("#Ջx��}������1Υ�B*�OMJ|�x����n�'ȩ��^_�I_��Ax&��b�Yt���d��uaJ�H�I�["�:DG��2$t�emz��#e	%��=�|����w)k�\�=��y΂��l<�n��M���D�J7DJ
�3Po$E��X��+ӳ����9&#�P��3��>��h0�T�w�R�"���	R�bJ<o��n�l��ń�ZI�-�o���1vn�+�d��~��S}[�$N�d�5����P����	��څ�:�:|��?��:�u�A���u�*��H*���6=�_�8������/q�BD""����G.��@k��9$��tp�����,�X����AWZZ<�ͬ�&�͠<�B"�Oey.�J�G�h�Me���-�,򦳴�'��B�t7�I�45\e������|W��6<@�Mw�<���e��I�Q�� *%g�H7��	�܀��_b֖6��1��'ĻE�c�h���n��M	����X��¼�� �=ļ��D�I����a�l��p^��YP�i6}��}�L�8�f2���j���qfL�ȡsH���v�ߏ����k��1�W9~﬈� u-�X����PvR�ϓ����=�B���Lۂ��#�!T)􄾷�~�i��{����>/��ՅK4H���4��E�t,��Kb��"`�cI ��v�μ1:��/�XD$����#��n���ڊ:[ ��c�u��h��K�2�m��~�~���͇�
I�(V�b "E-�	��lmz�p@���kFbB%M�1S���yw�Φ%0�l���̝y�ox.�n=�	��Iz,
������,��S��	���N�T��\=��.��ݜ��o���?�3>lկws��=ɨThd�z-zQҤ�s��y:s�4��U���@H"p
��@C�������
��r,5�m����ݮp�o�za~�*z[���.,U۱��8�c��kB��8�վ|����Q��/:a?�v\���4$�#&.+�srB�cޫ�NL���}��6�N����VUL\Y��P�����`�"�va�Ꮂ6={�)J䐲ʫժ��ɮgOO��Ɇ�N?���#���|� ^���VK��"G����<��.[ϕ噙��!�п�'�n9�����ୌ����;��-��m�k�Áv����lʺ�D`Zu؛(Ȝ�,���J�8k�W�p�^;i���N����5����7���_��ȷ��K��P���n���=��U��ZL�-&c��B4���&�az;�5�TΡ��z�j�F-��#Mn��F�+�sb�c���2˶v6B6�E�fϭz­%�"T,[I$^|�{c$_���#�*�?���b�ף��xfC�Ĥ�	�̀-��8���*��tg	��qE͓��y�����fgi���t	�(G=�ۋ��;Yk��3a�Q4!�1�*e��;ݤ���ɍ���wc/��uioT8���� (f�C@҆Pr�כ��>��;�(s�:�;�����WhN̞Zw���b��۞�v`աkܖ�O�*--'�<f{�[?�OӲqQ
H�I'!���O5��Yk���f�-Ř+$�Xr�#$L:��g	�8!����[A�ǘh��>�t�M�o��d���N�N�����N�p5T���Mc��p��07S{we�/�o���j�)��!�i�/'Ȉ��.ڛ���*�˶�	�	9�eU�B���tSY��%�h-\@�ʤ�$��G)��~r��
���03�h�+��0N,����&/^���N�2�J/!\�PHё��ߜ~���8��� <�cd��<4z�xIN^��������|ٺ�lC�ߊo��R<��a��Wҽ[�W��M~��V2��3����B���j��A      �     x�5QKn� \�Syߥ"'���R��:i�1�3�`,XB/j��Ⱦr�ד0r\#�8����K#���u1�H扩O�1�y����uE[,Uy��>ΒY���A��;��@�i%�8��	q�U�F�馽��!E����)x�wd1��S�<��sed���F69Y�~!�^��uS�F޴� g�r��Ȫ�¯^�0�:���k(7(���e�ҵ�����ݱ�^F�S�%,�!�D�HZH�ƫ��kE�o�M��N�A���?����~ ��a�      �   A   x�s	3�t�K-J�,N,����r	3�tL/�W�ML���T��!B�y�%@�	�[jj
W� �
�      �      x��[W�҆�;�"�{ѨJ����p�fMf��3d&�������ￒ����-�0Y�8$v�I�����s{{sss{�X�ٻ�����O�;B�{�|������;��
1_��X��;9Q$�5�!����P"�[,Nv�Q���oo����Uq�������ЪR4EY������\^}�}w�ߛw���e�KJIg�۫ߋ��_?�����_K}-rG�S33�JB鯧~����/�f�Z-�Ղ?�꿎}=�����ae��W��G�����=TSk���OW�kX����sp=����X��V������4t�	�Q3LX	TzUwȫ#�p��廫�4:�6�HNA��%)��4_�?|���D�zX�֓n����5�_������i��@�'�2R��ɀ$PS��dIRM`�����vÅ/A�lN�e'��6i��4,ҥK�*Z�o8���yG
�->���C̤�x:��$i>47S���~�������V��7�����Ѻ�J[Zm	�c���u��xqvt��h���Ù8- �L��W��aw�X�e�nC�&`�E��� �	a�C 1ʊA�`	:!�nnon�??��1X���ّ����7�B�_?��R�I-ȥ<��B���
��"���L��5�5����T����V��K�%=-*��}��D���;���/�>-���E6-+�~�=Z��E�(܀���&T��|VmEj!��c���QQ�jcu@�Q�~u�H�o��*�O� ��9������9�z�z>���Ͽ�Xic0.�q��3�{p�2��Fȼz()�Q��<,����(	�a��
�T�[qj�v�X81�Jd��z~��s'�eV:��X,V���vä��W3��� �X.Q��ݲsw�Ox�$+u^1ԁ�<;�6���w@��kOSj�������-��Y�at�k�
��$S�A��Bo٤��IȐ"����	)�*��8������<8U���pt�G������¤ua>�T�AX޼u��Y-�j��j&��N�:����
#�'�#)#���\Tl�;�QT.�"U:���Z��8��6����~,���Ϙh�K�ieTJ 4���%������y>�ur����5}D�'Iֽ��I2���,�+��ʊ�ؑOA�=6��9�I��JS�TK�1�OG�h��[����_0���g��C&�`�XȵmHlǅӋ�'-��8�,�K��(4c	�m#'�I,�4��>��	H���#��e7�v�����K��aG��Bx���o�Z�2vӁ$�"�#�5st��u��"���:X*��T�������Ck>o���[����y@c6"�ۨj��Ka�R��A-�*����,*m_��׎��U=��;�4�=����L�Uz���LVD�1�k�P�.C�S�Q3�Kg�9�?y���"G�����b7\�.~T�������5�]������E�в}Z��L��i�<!b�i'L8�Z�s�h>
�����G�]U���nE����!uq�w6_�_�<?=��x���������\�=�1��*ejP�u��gPX�N�XEmo��D�#��%�<�ǣ��0����|~����� @�GV(W�>Y�7�w�F��y�AS��"���,�3ù�'+a&m��q"f�U̲�j��\hai�lK�`��ɞ/'4��vAjJ�pʊ/�V
�2E����Pb�Cȋ6�FѕF%����/���g^��]�����.?_N6<�(�B(�G��q�JDXa����DL@) ���J;e-��
������u��D���R+�>+�2q�j/��*9U���|\1풿%�|M���yb󆯆g��I�ә�0`�˫W�d�ֻ�������)A&ړ�ּJ�D�����1�"A�9��7yON,x��}��Vj��U��E�"�)ˣ	.<;x�I�� /���o�ў���J4����Ms_�t��F�(����(�"�����%�h"�	;�e�����Q}ue�o/�/]q�K߽GM{�k�!)+6QEm��e�XN�y���WH/�TK�	9�Zh{K�6J	B�<Z� ���PG�Y-A(��-��Ħ��Mb���OurR�Z�t�
H��,�a��#�S�N�,�<�`�D/u���钐��*5�>����~�H�%�ғ`_��A�{q8�?y�@,'���/|4�<lk� �_�M��Ew+���H6�zŤ�!0�u�[Hd�bh1��j(�$Q����ȏ?ކf�p{����LH�4�u��링���JN
���-��ꐙ����p4Y�F������rB)b~,B`��ê�&�=��7�5N�j�1�|*n����z�MN:��� ғ@π%����,�����ݮ��4�#�y�����NYVF� &0��7�b����:$VCь]]	�c��Х�nTT4
-�:��|][��+N.?��04bdjؽ�y�de6R�֡%G�xYE�W���g+�}��P6���()�0c������3N�����ݧ?`��䔌E��i�ve*��}�d��o�i��S�mu���kljP�����9P�=-�6�/��؛�z�T_pғm��B�ف�6gG�cgk�9��ؗv��ͷ�����I�۳x���z�;��w���F}[�j��Htİ������Y��в���`�$�H������
yaBś�W�<�����jX�x| M41l�.��+����m��R�x�k[�!�v���]�Y���K?pW �2��/k5�-��_{;nzn����L�.R���F>(�Y�h����V�:Q5�YV�h�*�����聯��S���饊	��$��펓�=�g;
�q�Ԁ4*s��Yay��H�T�/үe�_*D�fu���٫�~����b~:g��>!Se�oR��~�/�I���y�Ԡ�ԯJ:�����ؙr%�.yJK����}�Ն��U��A�$ܗM��M�G�����p.�"6fR� �`t]m7 qXѠ_Dqv���Y��:�M�7k`��f�T{�j���n��~�RnKQ�G&��W�G�9���)�$+�?�&��b�9d�u���
^�u�]��*x�ɝ{w�ީV�,�t��W@iM�����
�NM�Mp�RШ���C��nA�����.��.p䅯qC�[�{T�`�B5\���#zcٜ5e��S���j�7	^��|��1m.N�-�K�T���/:s�s�阁X������F�Z��K�JRl٨���͔X#�H���3_��Fe��F����Q�,��|dI1�jpI�k0�*X�AS��S�	ߝ=��k�ɥ�<�F�'�P�v#���oB� f�`����[;��toZM0bR�
�5L���s1�'�E�#'����N}! R����y����������M�JV����zMl?5�Ԍ�p�ӯ��F���!p3mk����)b7JL���!V����	Ә��$�m�L�B*>����b♕ �@�oP�j�\�䡣�U����3sxZ����������rx�t��2�${�F��z�$H9g����Db����T9�	���YW��a������!�����ۛ���,��Λm�&���W3N֛��z���-��7�x�Ss>�D~z��D��ȱ#g�-���G������*�
�V.��]��2(a9��*�4`����(A*�==�-d����Ӌ#iH���F[�AY�Ԫ.9`Ĵ��|3�.m;uvV�����g�q�v�.�Ih�M���(�:�0��e�T��`��G�A��ϙ��c�m����1�]v�=Kc��g�;���o�����!mY����A�n��ꑵ�����m�=w&N\Qqv�y{�X��Z������t�vM:��6&ʪn��dD�t�?oQ
�hB�p�9�ӭ�Ћs�9�ޘc;�i�N@����hY�Z�w�MZ^�h�����.鄡�&т��U��i��;�xԥ�-'��wN�������HsR�lqX^B��|�B{�T��--:[��hlK��}D*-d��� �  aX����z�4�y%,�E���Һ-Bp{r��R�A�P,���k�m�.b<�QhQ<�~��I��PjJ��DI�P�2~�3�U[_���L��~�I��g�*o���f�,a���ų�NsM����Ve�C��2� ^_�z�X0�H����&��*�7�� @�e���`�d��$�J��r s�K[����˂������ޢ��s��8�e����-J��/5I?�Fl_���#L2H�Q�z]���;�;��RVN��n�Gnn�������o���Q}<�<� � ��E��� ����*((��H�R:M��-H���
,���������o� �B��wB��d�H cUdA�w�Ȱj2�3~�*�l�Q�G�_�IE�/!�D��@7�
�$x�Ϫ�~�m��i �F�N�f�*�_4���G���$�G�~^3-�(�.���BA'��e:C8��Wj�[2�KhR����U���<
ަ�p����o����Bɰ��9��
]ך�@�I �1V��Y]NX�9�
MsS��*E��k�6<�`D����jl!m�-
-����%�uE8�� ��V�)�����8�VS��s�%=F�����܂?׬Qc���B������=i|6g-�1$��曵�O���m� �8���'U��ݤV��dd}�9�X/�M��	'oXT)N����P�Z�)q��o��t�>pbE�V^���O|�3�n���c^v���x��Շ�Lb������91������"�������۩��P&��{,��8|��������v`��KԞ��|����;�����4!YZ�v�
-�U������O˥�ag�^��T��!����� �ն�y�/s��Yv�{����)��F��t�xK&uʫ��;�9�E��6�ɲ!�܆�jq �A��e��]�7�ɘ���ջ	��w�In_~�x���}H��Ɔ3x)�L�.�p����!C=ή[8���oZ��֜U����s"G�����0�
���8��)�P��T���1��(�Y4��r��PW�r&K��ͺԀ���V�Fg��1�·>�܍T��.o�?���Ei��]��Z��}=klR�� ��N�j�Q�\ْ}�pa`}�۟nq�Co��=<� ����w)�������^֋�H��m�A#ǈ��S�uy�QKH�IɌf_�����sL}WD�%7����[�4�n�}?X��W��ɓ���x3      �      x��}�v�8���)pS���2�3A���ؕ��XNR��alUY]��_�+I]�;�Γ��8��(��%y���&������������q������I������_/�xbtOe�J�3K2��1�P�cBQL+�L�2�u�����?��|>��{��v�c��~8����w1�������&�:�.���ʇ��m*�|Y"sefh�����S����c�0����䉠��?��y;�·��߃i�l|;���m>��K%�h2yL�������|pK^��}{��u�����Pe<��r�����k�E���l�)B�}a��IR�3e�\0�(Ͳ����W��v����^*E{�� I�{����L�pW���i�p�@_G��������g��lp3�o�ާ������t�����0�����������v ���}%�e���P0� �v�?���̔�b�G�:-��cp����\f���+�0�MH�(���r��v:��M���(�������y�/�C�����[����9�c:$���`|0\�5G(zG��?�Ç�ɌpD���vK�/t"���5��*(� p=�o�i������w2���YBE>��)�*����	I�L�)2X�S-���Ӝ9ڀ��7wC�m�LJYơ�b~�9�h��#*��z���{�����$������Ì!=.��:���H��MVd�,��HSn��6E�u�P��V;l�}��l6Е{2��r�R�@'�,��O����`R�]��l��D�D����?�xu��=�:��:8"G��g/�[ޓ��V2�NS�HUd�,IeLS܈-�ۮ㈆
e�Z�$��� �
J'_���.�{�����ܼ�)�%|@踂2�͊�%���T�:�v �m�qDC�2[� R8A3@v	������_{)�����ӛ�|
�E>�N�����Й�Q�3�4AD�,KXSɄ�v�*ڮ㈆
e�ځe��Khiց%����`f�.�A�Ԃ�7�,K�,ҌJ�&�Ӈb�u�P��V;X2;�D�����ү����.�1�e�x�TR#Ė����:�h�Pf�< �|e���:��V�%��|���=ʀ	ʀ�{\J BHF��8L�:��`~��Ͳ--pE�u�P��V��}*��I�Z�����HE9>�i;�4a�͌�Qb���4��"n܊��8��l��M��d+c����=�*r|F�ߟ�W��||K.������dr?|x�OsX ��k�t�0���t���D)� �mI�,ڮ㈆
e�Z��})%x`�Xv����0 ��D�|Ų��.2X�)H�tK�^�vG4T(��#ؚ�}�l��ٿ>9�@Pބ9�+'�0�n����2\rb�I*�!���JK`2��Ϋ���b�[�X�G�Pff����#���2�*8.'�SM7D
�|��p�Ûg)�<+2Xf�p�*%A�����T0] (���2�y"R�X��̬v])R/xl�L|*��Ii)�QJ,KtS�8�v���0TqG�bg�%|���-��AC�23����
��!��ׯ~�܍��`0��C�C^]�!�G��N��/�zA�ʮ�"���X��2��4�W�ڎ
+4�ؕc֡�=�:�J-��+��Y%l���upt�����(I.ޑ/� Kd���� ��~1d��dc
3�t�L;o�,O�K%0(cF1��c��b4T(3�J���H��q ^�6R�4}�'��}�$
�"���n�2X��>5�7����!�����.1���a/)�X��̬v�)R/x\
�� "�u���]��?��MI�y�9����5Nm,Uv6����A~�`�!��S9Q~�e�O�i�U��ِ5�*�X�G���Y%�bO��q���i�.	��k_ra9����DXF�ZP�(A����|:�!דqYƁQ%�C�s�Z�Y�(!��,IӐ(��9,�[5.Th�["�gi���1�����ɧ� v)�{g���-	["X��E�8��O)�&G^9��Q�'~P�J�=�˔��׾���.)�"O�����ȧ�y�?��CB�Y��ۣ�{�o�-h��2�\�3�(^�4�V�b)�ߊ��"Ոt!S��ǣ.a�
pSW��o)s�/�20�]CV�r��T
Y������;W�E�+ '���n�O��a^������`�ZG�(�����!]V3Z�U�yu��YAܿz	� �c�D���C\O'vD�&q�c6��䕅�=�p*�*�)���I�u�$�ژ�%�H=[�=\ޤ�N5�ⱆ�S�| ��$cE��b�A$϶��(ڮ㈆
e��m��>��gu�~vq���v~ 9 ��8E�^�1������Дo鈬h���J�ZA��>l_�fU�$���,�Eo*w&�A�OR��0(�Č���)
���a���)ܾ�%\X\˪X�"�k���B��U¾����BdU�8�`��FK{�`t���(f�7�!��!��0"3&sg�.d@�3i��|�b4T(3�Jدށz���h*�L�Y�T�ʜ��g���7!5�g�S���~I�S)�ƌf�֦{��b4T(3�J������
4Ƴ�l�`��ܿ&���%���jֻ��BE�S&���)�,�U!URR/�k�NϙDE��9���VN �\�b�B��U��<1P/x\F�j2��ʱ�a��	w�X��L�`/�#�O���z�zlsˏ���!��J>�Bh�U��K	廚O�٦���#JK,�s�*�l-cu�����rrr|r�p�3D�e0 �� ~������\]�i�K%nTp���*U|�'sмO����4Muj�(�!5�oG��:�ԗ�8X�g�D���8���m��?8?��{~Hp9eҞŉ�g���Иb	f��C7�3�Qf	eJ�y"�,5�(����ˌ,u�"傻e��� p��a�A&s2�,�1@I����v';I��_H��|�p/��W�P8|%�B�߇�'�*nEL�p���}�qs���N%E�.��.��sJ˜�C�49
��;ϧ�srjw�0�L��p2&��DFF�)�7��	��7��/�ߜ��|�x�g��̸D�$SᙅCK���̚�(��f��v*)��.�]$���'��y;��#<��� �G@iH�E����7��(z��y_:��%h���S��ց�S���>� �6�!�SI�d����hN�6q�8��?���F����R9�|xLi��\_��7��h��<��	���I?n��L��}����D���TR�&�]$�Ǎ�s�����#�{�9�|sz������d{�	��ÿay?�f�͟�|8�����{7�����v����{����!���R�4�n*$0��O�O����,(����)�xj���TRt�J��"��xZ��F���� _uF�g�|L�RM~��y��ׄȆ$�З��3G.�őO����TNW$�7V�5Մ�.���o��b^��"����I�9x�m8�#�Ǘ'�:�	�0������gxLc�����j��������2�b�ߧ?����hn�,��$C�����C1�Ϭg�{2�|ر~���TP��|A�L�z:���x���¡����8ͭ6���'�#�?��`�ي�`�U�=��M1���Rs0�H�I�BO'��ë�͟���x�@������ zs	�Jh�o,���jf��MD�lT���N%Ew�S"�H�{Z��F���:������2'0�DX!�?�[��pݖeƎ��p���&�SI1�u$�Hƿ5]�d���T.G���������c�]u������kX8��?J�]}<�x�����5hپ�� ��t�T])�+�-��s�e�w��Gi�'���6Ia��Ӑ8D(��n
���q�\-��R)���0��)�:i��{�(2�����󴪹�8�#Ko��ݛ/*tf�σ) [��l����>:(��ݤ��Vǃo_'ӱ�Ӑ�G�V��|�l���V��[��z+�3�L d�dE�8nR�7@3�2wT�3Xfm�|�8�LK�    ��I`�*裰:͖
�H��Ӱ�Z`���ca(��ѐF���|����ۃ�+w�|gC��f�w��3XfM�|
����rS�m�qDC�2[O���$�����Y��f�O�2�o��(ɇ�%�H%�^�@�L�vG4T(������:�	�'�����m2E{��`YbTL�i�-��vG4T(��G�V+�xkT�q/#�z�I�dEƚKZ��Z����`�kt��f��b�4T(3ۈ;����@.��Xק��.*�(wf���n��3Xf��|��Z9��T�*ڮ�(V(�ծk([�&:���:^�|��H�"'0���Y�zåPI&������{�ϡ�	�����·@���X��n�����p�����9�מb���Ǜ��鄑E˒,-�f��ؒ� �,�1tB��-Ҭ㔆
ev����j��/���2��]q]"�����Y+Z�ړ�L,õ%��;�:6�:Ķ�8��B��VCX�VX]�x]p
�	��Z�d��,��
>��i�s��=�F�R�Y��VЬ㔆
ev��_��E��JC��U���^k�%����v��'��`Zb�T3�F��YBb�u�P��V���"�0�RV�pv���Ӝ���gX=���Q��f)2��,s�K�d��V0��vG4T(��!�O�>�-��<旃��|���������o�#̱RXsy*a}Ң�`Y����f@�1��q�&� �4Q)�	��S�Y�)��6l�}4�gq=}����q��l�|�'����1�{̸�:�t|b�m�}�+s/�P.!�,m�щ�TR��� �H��s�V��z�d|k�o�n�X�o��6Z���'�6 t÷�д�yh��"uE�E2���
��{��j>�I�sro;�>9�מAS
T�Yԯ������{��J�~�T�}�r�\Ʈp:��΍� ��t��ۄ���ɟr2��	��B��"f���z@B�&.�%�L����3r��$���$E�F��v*)RWT�]$c����Si��#y�������p�0һ}��	�tak�3K�!��Z3Xi�.Qx ެ3�v*)��R"�H&���IMg���	e�EX
�������_�B�<��t9��'c2��*(8Wf��Vh��
lt�>���|�]�G9SX�Ux��6�j��TPsSq�d��+�t�;Z|Q��2%F��[��|�_��=��d���J����oo�?y߮�yaq]P���&V����ɠ�C��-9�OB����	���ϞK\t{6���Ϟ��u���&'����'��W2������=���h�x�����|
����|6�m�2�`�%����oLA�R#�>�>)���t0��TpB������S�� {�cD��g�px��>	m�Ҡ+` ��T�mܪ��nb�z�؍q���!��ȕ�r���P��hZP���ZV���.1�a,�0�G�vM��L �>���G�}�T��9<���)��9ƧF�`�}��@���ۻ���Or}��c��t�F��pO��{�?&����,R��-���+���@$R�@��IM��v���P�َ;�.(o ��C�N���v�8���7���txk���}/I�yO��3��%���x�4�q�zɱ��)�L���c�����q�� ��ۜ�����aq��G�� ��F�D|��� �����\�E#�p���*1�Ђ�ф�]��6��jp���Jǯ����6��O�M�h�8��s����Na"h�q�S�oq�=t���E�yz�"����:�uؖZ�჆
efV	�j���2�5��/�#d���w��A�����uƭm`�`Z&�TQ�}x$�Ip�0�~2�Ʀ�cC��>h�Pff���1R/x\��J��Ů�KT��sF���zVd�-)C�����e��2��R�9]�Qi��� �����B��U��H��qH��O�d.JO�����,���|���ʝ�������*��(�i�p,�Z�჆
efV	�������:�����^�"�q�f�,%f�����T����Ӣ#�R�ۮ�(V(��K�1܊|+�ex农���@@T$b<t��,Ø:1�ҬIX��
;ݧV����f�i�qJC�2�����*va�2�bo��xq����9��>��8�>�?��TN�0;�wc�8�
����¡v���v�`�;Fw���n�b4�]�Q���j�S �,1���T�E�U�����I����5F���l��E�9�3X���1M%-A�[��M�k/�4�8��B�݆�4�W�K�}�F	KW���1\�ES�4#��R�z���2�	��6b[񘋶�8��l��6،�	W�ڨ����Ǔ�'3��]8;���$�A�� )�z�g
�wz�w�_�=�'�6���L�Fg��͡YbN�� ��B�]����rw�&������w҈8�#�·7���+rz�����)wP-Fz�;~�8#��i���"ܞ��S�pjW���TZuP�A������:��3�������;<c���O�*�����kr>'������>��#��j�y����t��e3��n)��v���Ȼ��:M���񀼺|w��|�_a%�F�r URg?����x�#��f�(�Ç��X�|���>���� �їS���c���5
�gggx������HPUf����QLS<�ڒۮ㈆
e�Z�Ӓ�Uv����_�_�����Nї�,K��)�͒[�Y-ڮ㈆
e�Z�݊��$�Vv�����"���A$7ƅ�f�*2X��4ス]��;Se��~h�2xQk���b4T(3�J�V+�<�)�Ĵ:3#룢��6������3����팻;�����A)���!��B�+�ܩ2�SD�����O�Ujo-4�Y&�*E�w�@��>?��:<럞�����r�������C�1"����U@7�����K`�,R�!��Zxq���S�Bo����Zh(.3�Lԃ(�Ղ�B��?]�\ᾔ��=΄���C�% �)l�}�P\�@�֌)�̄�p(�[��eF���J�r��2[�w�NA|��+��W��.��w�3�8�����"uw�0c�4������t��۩��ă�E2���
��s��������5޷��t�w(�*1�:�F��gR�.������ 1H����Dk{ch���/(] �=��ǆ��� ?�#E�\��̪��8�i��lg�,&�4+��J/�U] ����X֓���
���'��F��wu�^*B��,&L�VQ)�^���fߥzES���/+Q_��*���]u�_A������w����]f9pO����?}dk��,�I�`ܓ�����*5_P�,��SC�2�g�*��p�������.Ѷ�"�k���9��A��N�k_`aj^0P��8 7e-쌅�R��'�Ұ(�Oz�	S��X�$T���~RWIq[�]��k� ��mhUaf%�� ��!_M~ ��|���9��?;�!cP}��\W�!��<l�9��Apa/V� w8޺���������g�f#Yi/��+hA}��������i>&�'r���k��d�&Pۿ�!R�~S���a��P���S"�M��2���1�mj`�ٵ��*(o�Tnc�)^�)1r��/N��#Roȹ'9������i�&g�C"�.I1cC^�]ZH��˖K��چ�m�q+��z��}6,��\q�/�Η����p.��1yC~= ���4�_GA�	�~,�����M~�N���(��f��Y�)��6�OE��;S�F�
���ۓ��[�%��J�͑x{)͊�٘U>՜ڍ};��)�n18"�:Ni�Pf�!���j�}e��eݓ}@84�Y)7.62�棲�`���SI�Z�AtS�h��#*��j5�)�[�3�b�rp��Q	J�����	H�������'-f�2�m��0b��b�`YBuLlqhK�6��"1�H��b�:Ni�Pf�a���UQ�c�jt�B��ƔoݖB��v��c����2{-�O55*�X����    �Ḇ@��3*��k�Y����߬L�w1�ۇ��x�*���PƸz!�e�PE��*XkK�,llx}���=f���m��>h�Pff��_����2ŶJ$���.�����A����oAIqL�1�s���0�b��!��/0
�U{�L���d��*����XY!�E���Xm�(���b\]��#j�=�����%�b�k���v�q�'\6�+�v*)����"W�iNZ����-v��{�p^�?�\��>��/��w���?�=
{o$��$��L�'�E�?u�՜��;����'K�F���TPs]�D�L�z:��u�UŘ�;z�'w��0���?�F�F�X8�Na��Q{S��%�Y�6�0�.¯��jS�'�[���W���TR��gAv�Lء�2'�8=�8��}���3��*w��{��̙��h�������7Y3J�G��&ѥ~�S�a��6B�O]%Nul�!�r��5��;�����~��=�.N��=���[�Y�|/1���	ߺ��Df�J�.�Ӝ
�h�����:r�z�ͨݾ	�`bt�g��x��5lul`+���H���:�� �3�+/�?�w-ob��L��K�N��{.)����b��	Q�۞��#\fz���s��ܹE�;��7}l�;z��})�����U�M�H�౭���,�dǶ�z=(W�h4�����oc"���{��]�Ep��%U;��b_>R�d�{�y���کvǅ���qx?���*��?@��`�
�k�]P�\ԃ�h�e�q�o����y��ZÕF���|�����xr3��.�B�#����}T�(v�)o`:(y�u��������b�r��"R� �a62Y��9�9�њ&�˸��o�
�����t���]8=��ij�5pg�PE��b�s��|� J)�_y�8�P����OnѲ��_1����[K�(?7�ت��Ck 8�~�-YU@l;b!+���Q��Ϗ��>�<Na�$\$,d��Y�w̘�Or����v�&���$���s��8����Y�	}�Іs׾�������|{��W:�>GujWolk�s��,ŭB��x��k�j�"�W �J"Hj�	�t��݇�u8�2�賶�[.���8��B��'�X�D�,/Ԋ?ܢ}���q/ūҬռ�xR��C��R��fJ��� ;B&Jw3�(h�qJC�2���S�*s�b����5��B�b.�`QAaR��p,s
�b|��A�n�.�]��l��v�M��Y�B�Ta[p5��5L�.(�)����!�����C!��N+���/{�l
���:�h�Pf�d��+��Y� Z����.�˨��U�*+2X�Nz15LH�ϜE���nB�ס4�N�Z�჆
efV	�j���2E�x���0X��̽��������0А��y�oo����q�p�`�-cʬ��O9UB;Ǎ�����z1ÙȚ�.K-��AC�23����<.#X�5w�ސ�����9�w9�H�}�^���G�F�[(9K*��u��Ič���'
��=�E��
�~r*�.�q��
�4�����Oۓ���2ӟ�r�$M.�Y�X�~�JfMF��B�h�����K(���s����.Q���Nl�����%��d\��8Ye����w�A�����q���a9�e�3��-�l"�ΆŘ>��)�9��6;v��"��{�)�Z���F�~u7�{��r�A��&s�xU��o�*�@���
�	�:@�^'p8�`*<]��Q���Sd�����v���g�Cm�� �
�o�{�Hy���>�
��2���"�VCJ$0����/�o@sp<�z<5����5�p���rպ���*����Hk$`�)� X[���S~��I$��m��������xK�H}���H�jM�n+�ng���w�Ã'�Nwq��K���EG��|"��W��}f�G��S���`���������G�x�0N&��|�p�8624*�H��"��7�x����8YY¢�����{#��l�)�̞ZʝGip�z�����=�߀F��S��&jSx�W)dnY(?��)|�vOb�4tR9�M�%߱���O�R��6�+�����/�+=q�Q2�eI��p���RҦ�6�WJ�ĝ6��Q�s��!���_�)H�_��l��s� 4�F.�+¾QC��~jy$b�:(CG	�"
�&�F�e��ض(�7 h�w���?P��x�1�3tdЦ�Dz1��'�X�7�<�n �s꼼�;m4�s��6<��p�ۻ]`�b>�}�x��c1�L��vs�Au�ND��������ک�|����ۃ�+�낓��贇����v�,�a�C�ɔo�P �]��l=��R�f�f�JMe�����gW�D~�K�8Ө���@��`Y�ҘJ�e��\b��Tv�PЬ㔆
ev�
������N[1%��:9�&=�d�G�z�3ᜳ�@�j�}��/;�F�}U��l��:�h�Pf�Eg����&&�\���K`��ƀ��lt��^&�v>���	�iH� IiH�R;k*�Ӽkx�rʘR��r���2@}i��e�t�l�Z���ཛ���R�y�d��_��5�A��!Q��H�S)�.u�ެ��t���N%E?id��O�hN��0"G����S@��=.%�V}��t&�Q�y�J�4��J:/�=�B�t��ס�j�t��"�Z�	���xǃ,�ş��S�ny��/������h�a������M����ڿ��<�_�'J�#1�SI�!S"�H�!�iN��ٜ�|?�#���[�Jޛ��qS��ϲ�Y�{�d�����I��㩴{k�QĤp?b��-3�*º��BTr"T����\�k�E��J���/-(?e���"����d:����W��_�CV�.�L�Q�^
���� ^m����Ia��l�Riɳk4	��N�][kD�Հ`H�$M��"�6�0��)�K۽�F���轫��cXc�#Ya`�:v��L�Qހ�`�,�w�W+(���]ͨ*R~J�~����'��w<O�ҙ�N1`�&���x/5x�H}��a����g�CG��ue܈qz~��B��z�B�x����e�%1�0hK��o�%4҂z���^�^B
b�/��Sބ������P�	�^�<!P�nŴ!�4���U^��\O�ٺ���7^�z�/-�M��e��`�%�,R_�ŗ�X�|ؠ|_ �-;�?��F�@�4�	�(׭�4����tG���i�!٨�'\}��8��cs���Y�Pb/���N���|1��MnA���_C�7c����cE`�]+R}Oԟ5�������w��p�cd���8�y�y�%bi��z[����oC�����������=�L�?�_5�g^iK)�sQi2Xf��!��YP\୩�1aRdVg2�h��s~J�?5�Z�ɬk�)��c��
xEH��*�,}�"L��x�&��B�y�?�xu���@�h�D���	:�s���>�	��>�e6rnH5�o�5����u�"��Y�)��6�O�U��a�:�ي:y!�F�N��7�^n�ʬoȸ �&�
��Sl��}��Ŷ�8��B��'�X��� ���ko�a���5��/=��>��l��C�`�U��������)��;`:u��f��B�݆$����W�D�_M�;B0�
ˤ�6M1bp��2���,KE�;V���4�LG�H��S*��mv�2ȉ��.+c��T�
J���hG�)w�Dp�A�W��a���J���m�qDC�2[-�}�N�ts��
r7�o��������o��r��`0�K;��5�A�Mz�������Uf�.��S^v@E��o?y�.R
��"y�\8,�����W�U�� ���_����p|C,8J���<h8l��=�"�+gO�;�l�@�y��[G�<��*֍b�o��[ #���D���y�X�#�́�ԟ}l��@���`Fw��vpD�up,��~v�M�֜!m͚9�l�#�'�T�t����[`b?w�� /  �����J�?]������6�qb�@ ��@��t�;�K=��Q�!?c$��߃�D���\���h� ����uݛ��*��Nc3{\�:`���2�OH9�w��j7�m��Y�~w�7��Q9��$U]�x�M�]{��y�Q> �t��U3��=���|���ԍ��w�?�O���)�O���
z�'-6���o3M���7�q��dd��� 7e�=3ݩ��{�H���_x�����{g�]i����?{V������BIp��lס$�w�ԟ��`����?FD ��qP0��'�K̊YA}sP쑪9���q�������&R���i��K�#�G���m��K���TY���"�`�� ޽�r�zuQ,�I�J��'"�͂�ep�|��/4�F�u@�Z��>�F����i\�#P��+�����;�h���fT�)�����!���P O�s� �����ԋ2�zazC/�md���\gG��ś�'�
Mq��Q6�F��l4>��m~��f8&�M�.:��d�,1;�^�8��^ 7����+��.�I�X(W�=�F��8]k|y7�N�'��b��9�{��=�)��o.h:1�j�q���������������b	-ҵ������\�r�?=�0d[��;�U8�2D�����!��n׃�5�&����������Bf0��9���߹��/��`���|O�?:A���*���2t��:�LD�[����gL�@�����qSX��w�0��N�>'d���On�B��ʠ���C����5�����0��������eL�u��~G-;�#H}��?�:��g��t��2 ��Ӌ������7�PT�]����e��q��:��o�ľ0	�tc��G��?��_��<d�g�[~�@��g?=�z:���VTjCo(.o*�An%�刔�'K{��i/����.ZU횶^��<��V9��]G�X*	�����h���O5�zq��$���m�/(w�f�<����%Ȁ	�v�O���_���tB+]ȷ��r�����&�æ���aք���������@�.O��F�-#(w� ��������������������JR���D�����Ǜ��a�T�_��G��?�3_��t��x�@��'�1��w��B�ޕ��w�H���/Mt�5�[~�@��g���[�����`�0����� ���-�(w��A�
7�/0D�]uc�4Ol�./�z�DWZm��=�gH��}w����l�"��3�>t>5��D���r�o��W�x>o*�����r�O>���Ü��f0���t
���z�N�)?�xc �k�/u�2�r�n�0�����&I��7v��3����/�Lh�k��.(w����s<��,�*�>��T$�r�o���q�w?�#�q̮ޞ���F��`���UT�{W�aR�,1�e�*Rŕ��)[!Dz��7IÎ�mT�@��S*��mğ*����dl�U�i���.����pBT3�<�D�gJ�D�"�e08c�kt������4�D5Ҭ㔆
ev����F5�C7��D>
�r���Q>�H�A��ÿ���L`(	!8G�����$�1՜S������v��:Ni�Pf�!���ʀR�^t���ު)�b�V6b!7&�0Pa�`Y�TL�Ȥ��QV�4��E�u��P��nS�P�2��/���t�Tf{g�儖���(83��E���T�ۚS����v��vG4T(���������%X�c����D��=e��i���A&񂢐�2�8�ZICt�NŶ�8��B��V)������W����$��|      �      x��}�rG��5�)��v����3q�Ŗ}Zrs,��qn 21M< i-W���IοdfU%
d(��p$Yd}���/�~U'�X�>[.Ϊ�緋�ŗ�����߷���b���7'���W��������D�'_\�~_ϮnN�����5�Py����oB����57�����xV�g�T��=5�࿭���Wo���?񿿼��i#��ؚ��fM����n�ᇢ-� �������e��b�������jy���Y��P=���]������շ�ts�X/./wW�|��E�����-ο�sTo��r��oÆ�񴉉6��&F�-�1'��w6�����8�������p&���B�:�-;q����=�~Lg?J��+�p>-��e�!�~j�����W��W�e��������v��/ow������z1��'z{w����{F.����F�&��05v"�|�mȴ��5�y�Ǹ�W����B<�.Lڅ�(���I?�x�'���J�:�W��6ļwb/�W�x��(�_ݸ�&L�����<I
�|�&/�w �DZ��|B���KU�ާ�Cĭ��rx����n}Ǡ��>��zZ˩��`���t��|���	d�S-&J�4:�fdG�t0[:�tP��"�QZ�c��AK��.�j`o?����ŗY�����~32�	�Z���Ǡ�P��w��wA��r��g����qy����I��J3�v����g8��{Ty�IC&�|LR�OME�F��_-����T����ZĮ��EX�tf֧�u����j�V�p��@,�*5�W��TZ�1ډ�B;��k�W�nj�T��s��˛����lq>U���jX=/l��g�����z�8�d]}U�;ŷ9�F��I�����w�[���8�˲U����2G���*r8��rh^��Hd���;qFNl�7�_֫k�V���|����'*��:��vR��=�� ;�X/�pEq��ˊ��!88�ږ�N�;�%�q⛞�4-�J�@����b;���uQ�;B=����@�H�!Y��5}G���D�*r'��*aB�eCP��
`�W)�j�ikO�s �UZ��ye� �4^1��k8QB���×l'�J�F�b<�M�̟W��d�����X8i�?�����,���xw��Շ��g�B��l~}1��W
;%
��%kK��%O{�\�m����@�B�QS���qQ��?;>]��^�/1{{<�� �b`_��3�WWw���t~��!ς7?�ڰ%�|�D�z�:�dm\�c�D�]S���a������vd�q������@������,�����t&ϼF~4�- ��ţiqߵ�S�`���j�e\#Cj4O��I����X���>�m5/$Du��%>�(��$5O��w5����;�v�/g���w�ٲR_U/_��<�JybK0�l�Ѐg��nQ:9��� j�y�H��Ж�QI*M<}�&����$$�>6
h��R�xog����׫����U��DŪ���+�q���GO9o¡��}�[��
J��5:G�ݥd�pV����N}d��DN�(�'Z�F�t���ԭ:�t��7�8P����B/82j�`
(�:25��R������É$v��4�ހ$RlH|N��? =Y�`�-="e��)�L�؉�1?F���xGE��/P=�LUJ���+������z�syڎ�G�4��^"O��'�B�i&�
��S�<�q�.n���IU_�%EV�̓�	_�4z�J����{P�B�),�tr�ش&A�#�Ѡ�I���E�Q�>Lۃ��^�� ��n�2�$�.��A@E��ސ�Q�_RWO�y�Z:z6�h|���Vi�l��,`��n6N�1�gW.��4�e
n'�l
��مReV�L�O����<�L�l�h���$0^�l�Z	���k����zq}����������՜��W*��4���~,�:p�vc�P|`u����v#PU���]���� )���A��k�E}��V��=^�?�VJ�TQH}bHH
58^��L � `��v߽�+������&΢�b����E��4�T`_A��Ŕ�����3p0��:m���[+�5��CK��T$��;�Y��s� � ]g��<�=5�p�n���jM5z�X8��C�!N�d�X��䠎
�9Z4�$�LȬ�K|4��^�f]q�����[����!5�L `�O��#o��C@��	ڐ���Oq@@�Yx؅u �Lt)���\�D;(��9(ƅ��	w��d��TcQ#4^#7���"�e���/��tl�G�Vͮ�Vc��`v�ժ����VO��c�&�
�����`���GT�e���DB��\Q=���ـ�߀D#�M��q�D�!�њ�uG	�X�1����
�{3�=q�f��yl��L	[�L�jRcE�{ġ@�L�XD�Nˡ0��	�F�~��D��f�`������$SGPZ�����4}�j�i6��i�t�m�^�tr����-v����9�/qܯzE1޺���H��'!��u\�߭��΀����g��cM��L�M��I�W��(��פ���'��`Gԧ?b���f%��p���ru;�����'�&@
�k���R��}
�bj�a'�.y�QS"���e��R��aɆ���֍g[��e8⧃��?v����n��w����%條��N`���]���Ջ���{�9R ?P�e�j3����1O�b~��%TOaT���m����Z�
��Ӈ50&�̺t6�4h@
:tiԁpFu�������d�8V,�Z�p\�R�Z�QagU��>l���, H
���(�9,�MVT2�w��n6]����8P����J./�%�_���d	_M����E?�./1���z��ղқ����L��g�{�^�%�Ĕ(�E�
g:�_3~��Lon�p�
':�S�1��)�ɱ��t�О�L���+����A��!�҉��Eƻ�S�b��ɻ0�ʾ��22x}ZS�/y�0��Ra����@������A\�|k"�Xlt��]�|;Q���;B����K�[W�W����H��"	v#	A~�8�e㱳� p���uR�z��p�]~�l���rLquq�
[��HU�c��_g�T����=��59�l|�_9Wc��"��8�rs�c5e8��	S���ךT=!�ԍ��}^�����rqY����ה�Ņ
Ł�y�*h*%(��A��g>���L�!=M���iM^��7`�m�=M�v�cY�0���糳���G��-K&��Dh�o4q�b-�	mS�҆sS�2�$l +�����y�����ɜu qd��v�-P��̕>��U�J�C�&��k��?:�қr�'|ȃ��rW*��KX��������X;"Op!Rm���kRur150a0E,����F:��B`��]sD�6Ou\�c��gV��K@i���Iw߂�P}F�:��t{���n=�n����H�#��?�X�����C��}���XT?�nf�g�j�Bֆ#O
��������r��$� �(Ajr���A�.I�Qh�a+ؚ��I�@p��<а/����|�l�F�o�[��b:��>�4+<�4�Mz�0�yM�)�b����7M��Hw�\	���ű���r]��q��w/;�5�J�5��v@��V>�fv��|V����������U�Lz-L�Ƕ���8K�����^�l`Ii�]�BN)A�x����BC��U��%e�Db� ������x�H�$�+X����Q��LBa_	�8�t�T�.k��z��k2�t
ˀ�L�ζ�`G܃�-{Г {x��,!�h��IO���l9�hHm�D9v���g)��}��f�$���)&!�J:�@XE�(�Q8g�����	&�n�%+~��u��+硤1�Rqͮ+�\W�3	%�4G����gkM�[�	    ؠI��O��U6l�Pb��(��F����]��P��O�Ǹ��\Q�>Y��
#/Lk3��e$��>�q��05��e)��ے�j�%32���]Y���4�+��.���oW���zu���,e���˲���ML���a�~���*︝��,	�S%B�҄�Q�;.��}"��-�qM�:���8�Q�ű���h�2��Kx��{��Њ�;�����˻�jYU�(�����O����=H�^����'�����po�=������F�^eld[[W�� j�;����.�6e5�Ԥ�լ��-�M��@�6f9�Ry;����`������&�)�G��\E�t(]� �*EՀ�۽�
�BPi���(M�1�ɒA֔���[��G�V�5a5�T����'s>��Tv+j<x%�!1��X�l�H��'%v�Ҙq�{X�`����S�3�\} ��׽�ai��Utܠ{�e��[j�yi�#iY^��L���P ��OJM�#X_�Q����� RVSk/)��G&�ϮR�${�����t�����-��K��7�]�@L9�3��6�ˆ�k�&���- 0uzr��_.3�R�4��I6Vd���X�w����pKi�dbY�@M&���Ք�^l�Mv*8�T�k#EaI�6*���b��Db����W��b/�%�h{8�mܽto���V���}�[ʸ2�Yo2�¿�)j���K�ʯy<��^S�:gցiA�MQ;|;C��*o��&���,P-'��u��lJt,%�`�����͒-^�0VG�^�M 6��2�,��5�4ec�
�nػZ?�ߢ�\���
�$�K6��~ҽU@
N���un=�&[;��Rh�a9^�W��!��-�c��r��=1�Y�sLn�|z�6����E��(Ô��=��ls�,����Ӭ����̵1[�!(L)�(��9aN���d^����D���=U��WQl����o�uK��bF���� y�Ju�
(ժH&���im����w��4w9<��B��ou'�M������D�⟪u�(��
kP�Mɉ���)��,;ٟgI:�ʺ�hh�l+��G9t
P�����n=�N*:h���P�����T���e��U��5Mv-�&�ζc��"�S��k퉱3KIi��(ݣB�4����Q�~e�;�a�߳�V� �&R9�ܡ?���E�4�l���V8Y�w�#�A�?(ec���D�B���P�T's���m9��Г��{��Z5?���wQ-��W�,�s�|�[�}��6,Bh�G�3����%"�v@�P���Ŕ��z_��X[��w6� ��4xq���ggջ�9vbG�ٻ���$����R��V��;��Y��}]�M�F`j�ֽ�q����j����3�7����8/b�2L��N#`.
��z���kЍ���:���N������[ �;����K��9
U7R�E6+�l�h#h���F(������C���*���03T�Q|���P�3�,	B�H��TG�Bl?��l�|���ru��0_Vh���CG�Ԡߡ<�3
�ҵ#������2��%5�I5�h�/��gTf�B���f���V:�ݥ�m�1�v%���<��Q�������w@�z��6h��h�N%c0���v�:��[����j}Ң��ÐV���p��������_/>_�$����,�(\�]�y�O�<���������:�kwg��/���+�1��U�������ꛪ�i,��K�X&�Xʎ5:{Zw�ʮ!�Qq����nt=���^3�1vS�>P�[��T�M�����6'��5��6���J�t�uZ��m{��Z+��wk,"�����a��'�%��j�\�bW8_䷿�V�],'���9l����r�VP�֬�v��ԝ䛤��}yK��^���y�#���a3AZF�e�K�3 �6X�a7	����[�SgdF~�譹O���AvS�H{�:����N]�������wہlΠ���~��766��3��(�������o[��3��^�@�����|dr�\h3�giG���aS�!��v6H�������������f1[�*tb9�i�u%>��꫗���v�*�)N����9-@��B���~$��}�[�;uMx��ZE.���z�+�O�7T�o���'�E����S�Vgy�f3�F� PK��§7`+��-��nv���+�����:]��/�:�e�8�X���W��M�;r���C�M�{������H@�o�Dۣmwǔ)��0�9w��k���v���@[�H���^΀T_�Wo/�V��r^}}���o���׋��������z_A����)�D���A0ͫi�$PQ�����p
�B������B^C��"�̧/�r$�DVHP�=���G ���S���v���u�=l4��	!Bt�i^�)�4�5� */Žٱ����&���Y�V0<G��G����Ȓ�HMs��o�C�dYP�(0+�wNK�,)1@S��>1o��܀)y;�kd� �Px�~I�L+�kRU$�*c|�)GB�4�����"�W5F�ҍ���@/J��h(G���0�]c��׳/+���xQs$�SSm���5����]��Q}B5]U��"�bҟT�vq�|+~R��[�5n�����G��T/V��'P�$��x��4�vP�{�V[��e��zx-�*P#�n4�h�|���Q�_Hf�]
`ʴƼ���i0M�Q�� ��0{�k<�<���yl1-c����b��0`�b>C��tDp �S�jD'6�mS�L\��	�8�B����� ���;b�&�V]��gkM�f����:3�▗\m�Yid�����%\)���{N�$������^}&���*Q���h�*N3�6���PWB��x/{]Al.�p�d lyٸDB��,I�ڐ��yv��A���bV�/s�>�J��v
_��8;|�[3�n�GN?��@�$����ͅ ���&S�����a7da��g��i����M@C�[_���k+�9s�Y���I��"_	�-�a��O�H���ˑר��>1]Y�t�bm�z}��]��ϗ�Vx��v����ɻ��닻�ׁ�B��VϩuL�M�J�4�d���!�f�&^0`Fvd�}L��s�Z쀍Jl��꜖�.�G�4�x���'!��8�y��b�=e��"-8 ��:χ�
]��y���X�Ui��a~�&e	���mBQ=�Y�� �hE������D�ku�i�;	��������^tl뻂
�-�F��kR�v�$�J��������Yw�8�5Ð<�eW^�ϓ�tH�P:b3򩑏��<��'Y�)�3��</(4���46����Bv��E�5!|���YX���҅j4�EEv�I�h46g�5F_�v3�wKm/�.y�c!/��5�h��xE#�ye:��$rt�F��5򏉼���*k&ˌ��L��cs����΅R=yDj鐋��� nb���o�GL�1-_�#/�0�)����M]��8��M[s�I-ya�Ѥ��Y�����@`�?��+��a�é��h�F=��ğӈ'���Z�c,"ǆ페 <`��n���rPqβz`�g�k�l��:}����������7��!k�5_�t��V�o���`V��R_�^]nwlE��ځ��oζ�k���jKv42�r�5��!*��������ڴ�v~���^�?�_��lI������/_V|���[V�h� ���?��ᄿ��4��LA��Ț�x86B1i�G�2|�5[t@<�V��z22�~I�T���@ۚ���5Φ:ED^�c�h��6��k�!l��;[��/�g_�M䫪��K�V_��+�b�D���Trez��Բ�l�H�Ϋa�h���*	����x���"����@�`O��a�B�^Š�;:zq/ѣ'sCA*��p�zL(ö����#��1�Ӡ/-��B�1|(��#}U���Ʃ���<O������2��(烻���4Ԯ�rDE8 {  j_2*��6^ST-b��'�I��/�ϝ�h
��]I�-���w�ոbX3�\x���]�|�9� 	+�5S����߫[l�P�E�BUR�}�}�O!�P��u4���B.��y���� 7���Β5,I�+�ʶ��Y>ҪR�j ��E#A�da,��}b�2�)�"3�i{��L�۵hǀ�����+�U��s7;��8
�`��C�����W�O3<X�U�g�.%;�n7����e�G�䧁%��,p�)���{����fg������nX�8�O�Mb ��T!'�)��Fk��+��	F����pzl��_���mrP3:�!_G�U�Nd��ic�=�qMi;�����ܱ�������ơ�k����k��$�8����=��k��Lg�����Eέx���"e9�%����I&��K�=[�SVoO��p���a�)�t�k�m�b,�&.����< :�s�$7]��<����س��Rk����ifu�ku�mc�)�`<A�פg䶤�c�V���Cm�ĉ��1� ���|���ʍl�hW#��vv9����R�]N�/؈��O��8�����l�8���X�f�g��Q1kR#c�3d�.sK�-R�쀔u�?:�F�<p��c�mtJ?��)pH�֔q�D�Q���A��Yէ��:�t{ [�b�0*���	u3[�lxh�8t6;t�m�V6\���1�5��5��B�&�*��İ�)��}+-�/�NځMkJ�J�1���ٌ.ԭ'!�D3���ƹ-<��n&�P��S+����A:OL:�r,�1t�e�'�`�� �p_�y�N��I�����0���nNm�E��_���1xr�asKW`F3��9#`��:���r�W�k�|9�ſ.����z���r�zIǴ���0������iu��P�5̿�ok9�V�yOL�d/Q�O����wT������=�����&*�̛Ď���o�?�i'[���!�� ǂ(Ԟ�-1:��T�w�:c+#U���"i�b3��d5Ă�N�N�	�޶���w�{O� 7�*j⛜����x��|�m 3s4��Dj��5�]hC*�0�����7%��|��SM��>Q���K���.S}��� A�0����K�k&���JE;V�x]��� x{�������e����X�,�R)�l
^ҥJ�0�6�m�j�4oן�3�0{�5�7��0U'bw�]�X}�DSyL���u�C�G4�~��+�O��*JhmK�����Ї��.��m^��J��Z5�nc���)��x��ƛ�j����$Js��?2�,ЖwX�����믳�������bY��**�o�њ*h����g����#Ʀ�o��F�n���r���&�bp�H�>��5�&L�s��ذTL)+�8P��	,T���KA�,��6���e.�0GL���G�ZDc���[�fjj�+\RDUZ��&�{.YM�e�T���zv}S� ؛���Vywp���MuI3N��'#n�ڗz���u��|��y)����SL��7@���W���,�y����^B���1_Q�^��z��]c�|,HBM�{J9��m;��QT(j�+��ԋ˻y�Jƿ?WpY��ZU�߽}&]���n��ݫ�O������|����3e~�J���`GYl)��;�>�'�E�����^���|��5��^-f�@{zqu��Ѭ�L-Φ�������&.mr�S�p6Z��~�`ţ;���?�����D���(��POi&To,y�a?�6(�T����[���l=��U���bEo]�p�5>.lH3��#.�����Xp$u��0�Ĵͺ�=7���8OՐ�	��x������:��~\~��9�������k������eC����[`��c�ú����52����z}P���l}w6 U#Ӕ��l;��!a��I�����ۋ��x�M)2�ӒG�3��S?�� >0��w�����[��Gc	��d����gvD�������x�~��z3"�Sl��n!���:;���ӻ���z4�[�)��ԫFƤQ؄�����4��]-f���z���Fdd�|�qMjӇ�Z�W��H,���~����R���Ɂ����~]ܢ�7����`��hjtT�7��&����/��� �aw?      �   O   x����0��0L�8q�����(�KAL�
T\���6*x�A�gC�G�c -hZ3�*���r���w8��>$?�`      �   �  x���_o�8 �g�)x?f���[���/�O�j�V�N{����7��8$���[	UUh�/���S�	�[��w�tq��Iݗ���� 
I}.�X�W�l��g���T_�j��<�������?������?A��#f�3�D;���?}��./�#�'��п;�t��U�},4V�l��'���	 �������׸*�S��\6��*/��E�h?�4C�$hQ��,/��J�r���VS��L� �������-�6E��0��q?a&q�ڂ����}ߨ�z����G��$�m_�9𩅯k�oK�w�	�[f<�;�f��m֧�A;�5���9���"��Z�i�����C#�����Ԯ6����=3�]b����ѿ
�����6���Ք�M<������ج��0�W�]����߶g�3��4'|b�D�b5}���GU\_.^��};��
��_��|v�.c�����7Qˇ�=@�q�����G��Xb^��{A�GF�E��`dA��L4��}��y�&C�L�X�:�V�2l@��J�Àv��/�D[lr�Q#G��#��2y����g��vďC��<�&/>wH����G�����_*���#7�Gc��{�qR�"����CA8j-�N��U�b���{��/�B��	��_\�E��v5�
.GWp���;�k'MPGMɿFR"X;8�R�&NRn-j���S�<�g:W^N�t�����ə�y�yÂ�1��,��ΛᘚJDc��a�pp�	��}�:��A/�����bY,N�һ`����%�9��n�΃e���~u/�yd3�7s�6,���⪨dؐ�6w�����	��1��%R�����#C����������N�1�� 6�8��MF}�u��o��w������mZ��	�=��`����%�F���l      �      x������ � �      �      x��]ks�H����
}ښ�)+}��M���q����r��I̎y1ީ�_��n�n�������0�p�=�Ϲ�9�	"��ox>x��=�޾g�;MG���BH�?:�KF��ާA<	fQ^�w0{����j���N�]��`�/�������1����;��2�G�G�/��z��������$ �a�q-4���hN�<�����T��_.y��a�~���'ӛ�tq<�����Ƴ���R>R-"[�Z��έ�}��|LZ��R�A�|�߿�g�]�Q�
���Ɵ&�`������%�H��;RL�z��u��T䰕|#��kOf��x���M�Ͻ���ϳ����g~�q1��B=xö���쯛��W�lr7�6�? 4#xy�Ep�k���b)A,"����u5s<��WBT��G�ET��r!�0<�Z�0�.C4�Q��L)SnD��iTL�w0���cXA���\�������q���#Y"`�#�A�*�������Bb�����-�)�
��'s2�-��J�������E;�y�ZZ�YZ�Hv��]���`xu|�\�����=�����ݏ���lv?�\8*��1�i$6��<� 6	U@�8���S���ͺ�}p~D��!� uz�~�Oó���L�f��t���19�,'zI��&�\���-d%J�,ƐT ��W�ń�ɒ�%�d��/엏�҄2�g8O��_�y��K���C��w��;�9C�jXhL�E)�h j�"���D
���u԰���l�4�Ѯ����G�����(�If6m$;��J'�Rx�ۛ?W�,�Α��!+/��� <������@�S�z�q���L�G��C"�R��0��-�k��r��ǰ*���/�K�y4Z�E�Jԁ)A�k�ٳ���5�ā*Q�i�8���/��۩����_8��n1!P	4baRk+h�@�ZR'7d��uI�u���1����� ���� �pR����\3c����oV~^3��0��M�BD
��ʘ`�jt"��F��7ѪW���;�&���˭ӊ�~͞r�x�炒�[(�n�a(�?x�[�7��֦Lx�^��j'
�d:YL2
�`k�2TӼ��ջOo&�o9���.Q�����M<^�E���w#����������?�o2� "�#�%�����=�2p�����kBނ�>W#�嗌"CR�!*'~�M'_ ���џ�����!~�7�>��nT�+�_�خ86`)h.��*ç*f�:1)
r&29�k9��G�e�� �,������BM�#�;���a�d��Aw�O`�u8����x�g��g�b0	 �D�Cn�{�o���UG�Jhr��e�q#{n@t�Г��V$y𹒵1��m���U�sӕ4]ɘԏ��1kLY!Uh��ㆤ�$բ8`�=�X5���aJ��[g�x��ʹ�Fu�\�RX������!`��·�yE��V��|��'g�ҿ<����\ɐrr2�{�#f�ǔQ�ịH!h��D2������x�g�X�X-[m���B����G�~��[v�����]"���u����^?D�,��w6�2���px�>�)q@�9� ����?#� ~y�;�8�0�ව�&`Y�
�q,9 �k ��׽���v���=R�.zU�xL`��R*����pjk����w0���s�{_ΨZ`]Mꧭ�����8���ufӇ<4�g_����b�he<�3��O擻���=���sg4�����������L���Ҋ��.I�<6�"��� ȁ��4�� |1k�K���粈�����ͤؔs�\��͹a�I�8�9'�77�$��sk�$�Cg�j�s���Y��R������~��NH���5T��w�g`��@0Ҹ�ň7O�i�s귥�;��a���cXD�t`�c*�ml�#|<"�»^~E�ǔH��g��Y>�Xm�f9�=�S������q�?{��/o_3��=����"�,�TG	T�����+RY�V9�TP��+�R�U���t>ކ�
������0�~���_>���t�����B����)�R�=��M�@�G��}�K�  �!fF������[ʆ�Q�O�@Y���U	ҵc���������s�xDFc��x�Os�y��[�?��Y����b1$xW�ǣTIh��Xdj<Z�̻��응�N�Q��ax�{�78a���=��[��͐
�h���+���˟O�~'�$'���E���0H�DJ�X~O�~�gd, �������iQ"|�V�")��68��&$̔/t� 56�Y�:�{�.d��_�a�J򤝐����K�m.�������߳�&��&%j�s�Y�\�d`U����m�G�D�$Т�-���c��9r��V��β���5o�u�D��eƉ,��N]��s�iW���6���kZ�����Sq�5�$�B������B�=��0��O�����W���f\otK8�\}��G�8�&g
Ev�2)�&��r$�I{�o"S���5$���f�6e���M"G�l�+Eʝz�d��T�����w�4S�F��meE�j���I�������s�L�d�MɃ�� �ɓ^�D|[��:��κU�x�ȧN�}s�x�� K�)��Ԕ
w�*�.�n��:�=���T��]J��Ҁ�u�bej*(��q3<1��'fl�����J�.# �@�N��\��އzM ���&K��Xã�b���9PI ���zת��ã���d��)��`
�x�WɞLqp�bCA������$u�E/����?(Q[(b�n��~�	�D��������P
6��I�%&���$���Q���Q6a�<�7[��!yq/`֧@��6�M[Ll��Ѥ%����9��뷞�fR�2u!Ie$��ĶmS1A��mz���莔``Mm`�e�L$׭E�2�cU�&1]Y���c�T�0gi	���]�y�ɂ��7�VJ��+���?ׂ1����@�8��`�g��l��p�{�_�tx��@��_N�+��-riB�,��NY���[E��)�W�%��r�m >cD	��⋃��#9�
�4�w�./�N�߰�/I���h�??�V� ��#��L�h�(%R�'7��S��:�d;k]�T�'�2[�"�����	:���}�-[�d�4�3I�T濵l�(Spٓk>2���U�敦�J�!��l�5��mH嵇��n�s��M����ӾiŞL���&�?�PXuB�*]'�!�𕙋��iD�*�Kq���D�Z\�ĝ���}ӟ,�=@�!Jӈ�� ��,���}T���T��T�x��P �tnh6f���o>�ͧC0�h��h�p�B�)��B�5���+Y��[Κt�4�W���oYr���������
L���|��E/D���Ҍ�O���F���I)9��$ɝ� ��C�#�{�U+��F�P���݁(����e��oKZT��	\(��*jPX$���y�)��R��������l���J���q�|j�pe��7�U����(�mK�wEv��(U�W��,�����J��n�٢M�;��ywٙd�U�β��j�gB�r�h-0�t�gϗ�˗�y���#g�=�E��
u�i��8u�3���}�T�s���6w�w�8�+�����C�nڅ��mN"�߼�m%3J���'�J��Y�H� l4�2ǟi�x���ٰ?p�9G��z���YZ�ԐV7��2� Yy�`�"��,��.�L�*s�*��v�D�%��Y�*Pd��rV��K�Mʃ�L��ާc;���;i`g6A�5	;l`=�c�|�݅�>��mse#v=Iaףgm�S�!�> �0�X`Va\MR����~8%X1�zϒsB���#YL�����uT�u����B 3!�8�^�_��F�0���*�e��3�6tU�o�ڰz�K	���bP��{$K��+��]���Kq�E��No���cJޘ���zO�Hj���4Rɂ������lR���K �7:�����5��[T;cQ�LǾ�l� �  �~���6}ͨF�(ikf�67�����/o���l�Yv@i��Fpf[�ww��,� �:E�SF�L�&17=7���RW�kD���S�/3w?ש�/l�)�����W	��Q�Q¯�&�΍rvt
4�Z�VAY�k��eJg"XMw��m%��ɵ2���B�? �P��zW9��#];��18�؆ᒑ�a��� iT�o�0S�%^��fv�� ��_h�������:f� �h����f5�$;� ��(�l��=��X�q�R7��:�@`��|����S����&��������7�p>����ͯ��dϧ���^-��.�lRۼ���{e��2���Fs���#ZAS{�2���&����a[�`T�#:�#�=D�9&b�ߓ,Oo������4ً�#��>%�"�<-%,�%�2S���K��Kgi�����?���2�<!��T�p�}���\���T�뮍Q�Fj�=2X����`��:[@9�#5Y�v��jJh�����xj�����ݾYy1+:k�G�ny�1�m�Kt��rc��YQU��cc��I�3����*ۻ��)�����]�lw�d��2��WHp[�j��YI�b�|��j��j��t�	F�����W��u]�n�ٓ�G-�_z�T�t��B�Tq��",,��E?�=���WI�hN�:Gr��j	�A��"ʏ�wo��.������T�]�4�U;�����9n���ч5z�y�������1���4B�3�>�`p�Ͼ��߳��3�x���ۣr����S^xdVE�lbAS?�lf�w~*6}�	/8?5/��p�����3��dvi�9�S��*�/1+�9d*#޵S���q�:���H� -��`�Ub�����R��֭�׹�u�!�ɒ�`��^m]�w+ ,�8����e��e��F��#YHK��ux[�j�^�le:wa0���OVtr�w�i��:�>���ݻw��HlC      �   >  x�]PIn1;K�����ȉ���K/R���&9��"%S́P,2�$�T��6�N�%���yk���^a]�4����G��2�2�����d�ذ�z�Z�G�,���VB���ۥ��@36>�u�6;Zn`��e���|$��D�|��ъ��K&��*���%n�X_(�tD��]E��D	ѳQR��a��Yʰ��	B��=Q���K���J:n;x
�~nu��vlz�Wt�A����>�zW듍��b�3U�h]ܲR�B�!�1ԑC���`s��Dn�RP�|�ѻ8{�zy�O6z�֧���Ŀ_��̓y�      �      x��\�v9�|FE��H��V�M��R�g{μԴ4k�ݲ�,�^�~#Q��<g֖��Ie���?�~&I���JhARG'��!������������~�����/g�n�L��BL/�٪[��l>�RN���緯����~�k��i�ٗ���x|~}�����~}��H?Z�wJ6�&�L�lc��"������)�%�~�p�^�(��V{��0����es�K�����?����n:_"��|<���:)��U�Re&2�R�}���WAXY-���(�u}{y���}�_�)"h����??<������Y����es�-g���nu��@�t�<*)�	��q��ab��B�MǼ}bh����Lk��f����	��q�J+���Tݒm~؆/�Ŵ[Me��?��J�Tb���� J�lj�(��I6�N�ed����"E:8��WTv|i}y{�ZH�)�蔑�,,�H,xlu��U���{I�Ӯ��J���|������6b�Ɍ�����lѹ�[��q�C�t�B�u�!�3u��vC����~��q�[�w�����\Ȼ�v������Z;(��V[+���I�VB�j~�]��as~w���q�,�v,�IO4`J�!��ި�S�;��L�y*� ��^��V�(���/gÎ]�>�bzs�������!����U��X47�����F��G;@�+[4V%+��"Tj�ZЌTY*�=};He�-�;l���Xߧ)��16��d�GOd� FЍ�R�J��Ĩ�΋o.O}�Z�V�ꦛm����1 ��	�� ��	� ��*�.�DJ�R\4�Y]��~~��w��x�\���cD���k#�6��M��V��umX3�X�<�y͋�oߞ���,�W�����W�Nܮ�Xn�os��݄�g�MQk�2�G�+Q[A$$�� ;�Sr��~�Ȳ���k���S3}���L?�!��o�ٿ�'���� D�o�d�� J	��-��'Q)udL!�G��|o�V��z9�<�V� �?��Q��ڡG�ȹB10̄|+�E�eAЮc]��>���}�~�^���I�M%fL3�¨�k�
uB:���9u���$�m�궫��7 9rk�ױy�(�)�;��) ��!���%��O��o�?���~�	�<�=��a�� .E41������<LxF2���4"��)ӨW����v���=�eL�*k�.)�\��~E����il�?нC;2*���5�C�j���D+E�N������8=R�%"����]��Ns��9�0_�>a�\}� S%�7�X��NӃ�Xs͈�,׷�ͪYv�[|s�=�� ���+9���ou������
M�:��[�!	��`1&F%��"FǴ��V�\���l2^(��v�j�1��*��n���Ew�]B�̷�
0�Q��ht:#��n�X~�\�\\%/ ﵎�x�~�S�*�=��n}�F����,��[w���4�`n [���d7�(�c�2u�%�Ғ>��y�6�����/`D/}s�?=og����R�IhT��?�H�C��L#�OcS�i��M���Ε��;�ys(��qbc2�dх���Y��:U[f�U R ��r��Ҕ���q��s`����
~���#�WQ@�5z_6�p[��'˚$"�%e�nG\͡�S����ﻳ�f��b������D�	�V�Ec+���B�K�ܗ+~�?s��e(���j�|S�1�vE���J�F�V �
]{cQ��:~��&�\ U����%���#�A�������`v�I�)풔�F�b�������O�[#]��AB&�J�c3��C1�ʒ`Xҭ53O
+5`ͳ/S�Q����	x����ǙP�M31��A��+��q�Q[�*���n��c��E#+�]�J7���,�7p�V�����&4�j�l��&K�ɸ4�L<���������Z]�}�_\�}���Ar��WR�Z�̀/��,˃��V/�}u��n8cC�%��L<����sn#��P��Cz�I�}	�C��/�N,�4f�/1O$�Y��L�@����h�
�M� �ؙ����i��F�蕉y^�?!/ԡr��G��9	����M "Laȹh���{x5�6;#ow� G����IhF�d�����Q*�� 䅼�����M�^�����&uo/�����#<>��jt(`Z�A J�u�p�!.8�F��f�['�=~I�^b��Bf���eky�(>��dG�ρ�<�R�m(�z["`\�E�E U���A��"��((��,�6�@��+K��A-2%-w�B��c�Ҟʑ��x�\]�_�7:������~Smx�1�2�$O�*�&2������`+z
��[�� 2m��߁�E��ܿ����
[uw����
��T��K��<*�Ȯ�*Rb���$e�S�x��.�����ɻ
1�e�Lmڃ_;"�`Ik��� IF�YЭ�s���w�>x���K�#&9럿��]́�AI� ���j1c��;���*��)��`d�
��q�b[��d�;�ކN,�=��h�x�y~k�3Wq2�%�&`14J�P�6C5�S�@��$8�ih�����Nr5@UhpW�N��"|>�>��f��^tW���� ix���8�Q�;
D�Q����]��[&�0. �tr�ZKug�#���������~���0�N'=�E�c�t"�4����l���=�w���b���	͚,�`��hz�(����}�{4���]w=��/���U�-�sT�Éd^�b�:',Fh��ɖ+�{n���d��8ut�ɨ2��'##,��H0,;���`�#������0u��<ɧ4;] .�qxL7�L7Yt|ef� @�7���V�k������GҐ�/O�����b��$vq_b��xdI��'K�hH[]�Ɂ��f��Q��7�m��p�|��_�w�v��͇�%�/	�������$�q���A�-���{�BÍ�-Z*J�#� ��)�Y��__�x=k���lu���k  X��|râ�9�WG�0�C���U��k�\
rsC`0��O�f�A�x�o,.o�1[�؇?�d:���"h)̥<%���7<ut�.�'ʆ���HU����f����e�izu�M/������l��F����6�x�P�(�`�ŧ<+ʲ�c^����tS��:(d���8°��澻Z���6A�z�a�,�:I4���-��oP1�N�n��I�?NT��ֹڼ� �<_�"v8�����-봛�[�w<#N�cB��/�Awy6/Uq.�b� C�v�o�V0iP�ށ��[�7~60�ן.C�!yt�8&J�.�k�s_��Y��RB�cY����۫��fy�̚f�>��/�i����6(��T���6��:*�fw!�ؓ�a���ĞJ�g:#�¹�����	h	�ڶy����z魡���S��}:#3F��0M��L�Q��ڐG;V!>f�YR�*��8������~��?z���!~7�݈�QdÑ��̾��c�Xj_1 | }�E@�?�2�l���޿�����2��(�� <`�E�|� f]�������&�F[A� *Jze�O�/e���k����?>��Tg	�|u.��tq.��ӋvDz,O	��xG�L�	-�!T삠p����k�*��k�5�<_.�%j2��T�C���@K����;� %�����,K�*^�(��(h�M��X�}@�ϿO�i�A����9���C�f���g*�b~*fh(�)�떳�?o�`��P��-�SOv�b#���67
���B�F��@�`ՙa~ʺ�q00��uw�]�H�|T���#�܇YӀ��!Wμ�`�|l C�m��eίn��~Ȫ���N��s&&O���v�X&��Bg���N@�H�Uk�ٵ����������U�<����g@����S���#@=��?p�O�5RX��I��4�`GX+�o �����E��1T&0�3����%��O�̺���G#�6�#��YYFI �  �1*V6F��t:jc������G�i@��4��J3�Y�P����|�e.�BȞ��+
ڡ2z� �l�6��\��7]vwsp�nw�i��`�F	.����E��[y������G=�+P�����O�;��������)���I����;H!����[�p(>+�7j��l��;f��eQ/oV����j~w�5������n~��nW��j5T|�<�����G��B��AI�!�>8�~�#q�������g����p�6>Z+�]`��!�����W��\~�T.E#����d�̉�Nk��twT;��'�U�Y$q
dU�|��2�!�>�V̅�Ghk�#H��C�4�e6���y,¦���P������M:�WN�w�h���ӑCr�O��JT�� ����v:���T*S9z�1���9u��-��	)�K#"e֎lqL����'���!=+w2b�g�m�/?��O��z�-��xBC��ڳ��:*�����E�{�L�m0r�#���+6i>�FtZ�X0��?6��?l���/��F +Ť�ǹ�`��}W^/�R`��,�}��\��.����S3����U`��C����ҡG�����HG�*¤�?���@��S���������7���Z?`���E
�a����"���k� H3.H3���gTrT�G�`uP����5���)���؀�uE�t�L�:�Z �N���駟��lf      �      x��[ko㸒�����h]�"EҟZi��j�N�G�X`���X� �3���{�����i\ܝ	f"�	�YU�NU1��H.�')�!�f������I:���$f���ɰ�z��s^v*�Q���l���J�Y*��_Wi�^6+��o�y�����vn?	���U[D��濸`�������g?����>mݤϛ{H�/�t���gJk97�0Z���*]m����E����m��(�����������l����K����x�\X!�����=<4�_l��l�}��۷�e�����6W�����wq+��Z����poc,|�2�B���c����]�*ǟ��u�m�V6��<P �	����[���2�!7���R2�,���m��=]l6Wv�a;t���ygw��d���!�^:���'=��t[_z�ngZ,�H[��!���t��F�k~��8~���	����Q2)�鏒qo��x,�d2��
n�pl����gl��x�������(�M�Z�ӇI��vǽ��qc�/�!|oqXo���Ŏ���w�L��k��S���<�+].S6���-/V�1�6�k�V�������?�ϛ�lq��h��U �����q(6>����`�ڿ#
W雧��
LF�|���a�����o���!�Ь��>��V|�~��o��!�C?�%���?��c���	�<������|>˾}�z2L���
��D�ƽ�?I��a>� ޽�s$l<����xz�>06�\k��f��`�`��^�EI��#
O'�PXf2q9L��xG\�D���%#R[I���n����@s�OB�!U[�_�K��B��`������Mo
)V�>�)g-���<�T����l����k�2�QxBVA6��j(��b�A���v�Pt�|��� �f²�dx"��@����Nm��	��{KW��|}(�\����;�Y\ ��H.!T E��ܟNat?���x�$�x��>v"��vi�����e��ޯ�"Xʶ��s�%�@1�1�e�l�2p�S�%���(� '�����G'8ʶyH��
��,�	��$$0��Ś�"�f�<#a��9[�w����(Gl�Kqu	��1)�[�5�i�����^2��|�%� �9�z��RF�m�f������ud?���!x̢eR%��������)>r�C<!��A����֊���*ۧ��rWU�"~	e[ 4|9�$�P0�Hq@7����������X�����͑�v��y~ȳT8˯��n�u��(LTw���!� ����4�1�����僧�}���ߟi����C48�@����J��!�`��ky8���8A��`:ݓ�<������ڤ����ay�b���B�\�TM�I_7��m�m��n���-H�̎0�QZk���k�^C@V�LD�B�!��@���*�F�6��VH1	��^)���Mҏ�C*�H_Y�QT�rv�_O�}t�mn� T!��0ڤG`���c�.~�b�嫾x0�Y�ry'�"�Dd���4��/���P�DDJ\��	x԰`�%C�v��:&�!�IZ�t�ܜ
)��1�,]���?�K$Qp7x��i��G���<�l�*4:�R�z Q�ɎV-W�"��,����UK��*I�\[hȞz^+$�8� ������D�|�)��hꋖr�i�O�����GDk�^}�V2DT�+$Yh�j`T�#�`�Ң	
�n�;����/��&uNZ�V��<�������w�j����M E[Q�EdlD����B���G�c��	��7DŰ<,6�TXu�	#J[8	�������	z^�yܧ�jj7S�@Ζ����;��դU`�dx=��
++�߀��Jܻ2�ؗb{8�-�}8GN��'w���a�9���%��QVF|�g�ӛ�"�5���C1vz��ڲ"e�6{ �n+C9�
*[O�B~�0�,��(���(WKQ���F�{!6�/�||߽�(�BH�0S��e�Zr���\��Y}�R�Y�������SF�暑< ��UD� T�9���x1[����Y~�~�![��hi$���^ܽ	g�51$$�'4��BTUMs����GJ��i��S>�f��(�Z� 4�#?�
R�&�6YW�L��X��;d�1�������P�l��6�>_��Y���p$+���+l�%ST�'���R8&B'��ç��s�	.��v7��C�P0
�(��U5��n:d�������8�NQ8U�̀�!�tĶ3>��Y/��2
�l���V�}�rmH�H�bj���3Bj����|l�7C���u���Қ���A29��c��k|ۡR�=q�E���pX�7/o�l���!%\��iCEL�\.$��u�� obO��NDZc��,H~��P\�WK*�*nU�P�Pm�aS���
ߧ#]<�sBx@-߸�+N_�VZ
V�Zu�+���}����h ���(+�?�ذ�1l�~�W3ÅR���
A�O��=�B��1ą/����B��q�FNj�}ɩ�?�G߭��<֒��Gt����
�F�!V&���~9>ɳ7�?���9�jV.���Q�������L/��R?�AA�G9f�LU�e��v�B�5N�o@���g)|�{�iCku!�B%���Ғ@��+�DH�HW��Q�S�ntT+�Q����dr)���.�P�� ��R{*��_�6����ԸA�:j��J!�n6LJYV�T�"-�5�)!C σ��/n�w�pZv(�C*h�d���o*d뮠�ҧ_|IT6u׍�:*ǒa��8++��U6˪���b��a�_��Brt��G���t��c��:-��oD�$8wM��o�L�~6����ɶ�Z�S��i��B�fO�{�=>��!�ȧ�2�uO���3*��c���kg��cR����TRQ18�(}]<�|��n��|�B�|�� %|�W��Oy%��o�(��V��͕�׉iX[4}��"#��vX.S��g�bه��Z@�C<�/����ڙ�Sv��TT�J�ep�Q��X
���3��;j�D��d_?��'�P������Jr2��k��LG�qkwH ��}���Wƽ�x@�fz�N� _���g�����~|-i�O��/:��eC�����"��y����1݉��W>[�H��sl3���}�l}匀��׷�o�X*��(j���j�}�Yp4�Bݱa� QK��P�
����\
���F���4e*tc$��*�=:P��a�ٞ�7p��
�d��X��<_����m��g�km��A��-80Ճ��:&A;}�G����hCc�wV���# ���:�j��:�
�����E��x��U$�*5�#�&^�<�[l���o/r�/��,2~�t�STM"�B�C�ƣ��%��+a�45x߼��,v�+�[��t�Du�Aßx���kez�Zܩ@�O��W��y��O���ij�Y��W!���p����=��ԓ�5�i���-��+�{������e�j.��:\OD������ie�������[�!�9I�N`v�u���`�.���9�������u�ժ<*Rt�m�/���e�~o��/}6t�H�z^7��n"h��	�`�Ã{�R=6"7>����5�JZ���Y/�鷳$�	�G�|�F� ld7S��(��5}��>������oȇ��^�)'P����t�.ҙ�6��DDyi~�ԕ�o,�(2{����=c���9=>8��D���l��t��b��t�S
SM�<Ǟ6��7�eF3��5&]�9.���Hq�-[ρUg���!��S"(���KSq`+!�	o{H��7k��:�dKR��f~�g.�O�o�Ԑ��5�ą�dr���&��dvM��qȭ7�'U���+��U��b�� ��������xY�W����v$�xc<a+�h,8�5,��~<�$��FH@���e������mR�i_���j�Q[	d2�$��q@{J� �/�d2*��u/K�N�:g�A����=~Q�{��n㇇8�r?�	>���1Ȳ�� ����&� C  Iw���E����,�x�r��k�$���j�G��>�H/?hS�O!��Eѱ)Km%'�mm�v���z2읻|��bD�����������>[ϲ��V�05$�#�@S&iZ6�N�x�w����b؋Sҙ��u���Ķ���b�.2*}>��Dt#,�ƴOױQ7t4�н�nw�$y�pӋoc�^'�OF�Ӡ�A�P�팻���y�V<�(4↣�)/i,��A�+��a��EQ��6�o�ԡ8���SS�������@�Ȋ(��F�*E�R��~��31�8�VFľ�t���2	(����.]�Ѕ�"� ����82��&ˠXb8�өc=�mR(�a�`"22R±�y��������.��t�BEJ������`qq�*.��n�w� g�sx��'7=�u~X$�*�b�̓��ɿ�!/�F��#r�	�i�nE?�.,')eS�ϴ ����Q�D�P�!�,��冊�t�����ha�1Jp��E��t|���/o/p���5�[����A���08�f=��NR�X�5�%�F~�Vپ�Gf�� Eov�������S��HX4.��r�V�ld�r��}��鬟���z��b�\���������*�a�z���9N�a�u�T���w�N'��6��'�?ǱVj!���;ݹZf�l-�����Wq�Rz�飜�u���&9�� -�٠3�����~�R?}�Ȃ�j�ng	H�e������Q�f6�oK�9Kwl�����n��(ש#��8L<n���P���N=�kx�H8���G�?�9��t�����oh���s��al?8_�B�h��Q��\E�"� g~����_��T�Jr��4Ia{C>w�Ϸ�8��:�Nx ��ಭAx��"J�K6��/�����R?�D%@=�r�Pv�h��������q�Ƈ�t�\Se^ !�%�:�Q�vB��WJ��NB��%w��Ǫo޼D�CT�wBu`�ә*�������� 8.n��V��V)0��|��tp���~�0}��}���x<���hQ�i�l,���fyZ�,�ή$Q�dJ���_g�@�OS@+/���pqP(�$���� �.��O��Y��%��=қŊ7t��QI��A��\Ilh�������8���#�)��<��blg��"__�]��*�o�!�`�Q|ۛ��fѦ�/[��%�B9�0x}Y���W	Cѽ&�������2�?��M�ӟ3f`�<��>�@W��=��$t���������U�toA��_�xT�/+%@A��jL��i�U�F�Y�"��5ɝl����W�Gx=�i6�m�9� ���;�����
q@�      �   (	  x���͎�(F��OQ�Q����c̢W���1@��>�6%E�c������~1���ʏ񟫿��\�c�]������`���'K�r;�J�6lZ�``�f�- ����Y��(��}�1ܮ\�f��ϔ5��C�f�}�|��j�2�����mĒ����v�^����!��#�r4X9&1��9\��{��Q�X��r��.���'ԍˆ;֋���6Vq�r�v�z��n-}V�`ۭ1�[�E7k64s�⠦��A�l�]�\cmn=���Aޗw�tyn�pQ���s��/�Zjj�~�(��X�l_=V&S�����}�6^�=0���Ovze��!�0��Y)rY�6aib�ߗ�"�$���-R_���0Oݯk�2_.*�h�]7�+)���$�zSl+B�Cp��;��m���P�)㤾|�p)]T�K����ܲ�\��,�g��$��1eI�A��tm��x�4���o�=��e脬Y���Ť�l^��� �,��ʐl,�Sv��ܗ�x� 3dtS��걧�2v�c�2X��C��t�XN�,OK~�!�8c/�7z����S%]���� �Y�+'��c�R_�F�̬�4���SIoK�%H1O.J�ߖ�chiG�Y,ӽ�1��YRO�X��V���!G%�ɉ1t��������D���kHe�Բ�c�jG[�mb��H��2�(k�2���>����`i[��u���+��Í�x �������ms�^@�Yz����~/ 7����|���I�X�S��_�zNoy�T<�O�@�c�Bw朜�����`��J��I?b�f�- [����W�o��⊀���b�������������O��ΞnQ;xc���ƀ7�1��o��[��I���Rۢ���ݠ�����A��*5lPia�ʠ٠җ����=����=��R�=�,�7�X�7�-�7�eK�A:k�Z���k	[���k)[���kI[����r��f�����F�epvm{x�g�c�S��+����H���k_Y��	`3��� [��g�}eo�/��� �8&�1��ƀ7�1��-oj�����Z�V��m�Z�V��m�z�ۢ&�_��V9�b�r|��8�8�8�8�8�8��I<�z��o��K9�����6�z�����- �����텵��Xk~W��m�Z�b�9#�1�	pL�7�1��oxc����&_�t��� ��u�x��I�A�;^X��	`3��s4;6�ʩA�=����xa-o+֚�ky[�V<�X`��r�b-�+�r�boxc���ƀ7�1��oxc��?��D���ۂ���M��۾�7\�J�s{������:��6�+��6l��`�9�L믬�M��sC�����X+V�5g+�r�b-�+�r�b-o�-o+�ƀ7�1��oxc����O�����8��9V�����Q� h�0Іa��@��6m�0�a�i��g�����q2O;�O�<N>R���ߒ��d��{ϫ��%=O���`�`垠��ɗw6l����}��yg-o+�_���X+V�1g*|ӳ����W�!x��(�V�al��V��k��V�-�l�#y�t�Y˗b�t�o|��kO�U�a�N�M��``�f�- ���ϓ~���m��K�7⁀9#�1�	pL�7�1��oxc���ƀ7�1��{�:M�o��dQ��*�mPTzؠR��6��*}٨J��ܖJ��ܖJ��|�Tbܠ�bUZܠ�TRܠ�TJܠ�TBܠ�T:ܠ�T2ܠ�T*�P��6��.^^W�n�mȆU]��� VuA6��lX�ٰ��aU�f��!�mX��>D�ao�ц��CD�mX���:nX���:nX���:nX˛*�ݢ�a-oVw-6=��/�C��l�_�+�o[K�}���O�%aI���P��,�!����'����_�o��b�uj���'�uW/���l�{��z�Y���`�5WT���i���v]�w̍U�67_�x'�{�8x5gy��`�8�z'�<Q��omԛ�a��{��'lc�G������#�Z��3�jz����Y��`�F�����	��Z�V,0�x# �3�� �xc���ƀ7�1��oxc����7rN��g)\Z<�=��R/q��N�?���>7�<���b�͂X�$\��r}�U�6F�zhê�نU����gV��6�ڟmX�?۰jf��ڰ�7]mX����6,�M�C��x��І��zh��t=�a-o2Iu��b-o+��b-oV�CO����ϟ���@>      �      x��}Ys�H��3�W���0��EO�Zhkሒ�X1'
UKc-I�}~��$H�Ȟ�n�MB@ID"3�/��z�W��$�-.������������������pǏ��������_����5�z�/���X�5��~������������|q=�?_,q6�ݰg^6k��'f>	u���d����o��V3͊�~}�>�~<����_��oߟ��� �>�ϟo���T��Kz|�^4���O�p~(�!3miůWÛO�	��w�<N8Tlत����誸z��^���[H��P��.���I�V8��5g.eCų���L�Ȕ���lt��BR�J�g��ȫʘ:	c�_�.��U1�Lʫ/����M9]�m:T�N'LI6쑒1LK��&)ͯ��w}R�5w�����p� %�J��K�3��������}O�0w��J���p:��PCFv��R�* n�Of��f�1z%�{O_ᾧ�D�aLk�+�]�YL:FQ�Rm\b\gˢ��s��*y#��ˢ������਼(?�H0Ƿ�7�-G���O'�u�]^�u�s���j����=�j��B�V^�ӟ��h�3�1�sm���s�¿?�B��>B��Dw����Ǻ�)����Z�?T?u ��,7|��^u��:�\~;���(�F�춞]]�n���xh4�g}�UrŴ��������1�:���%��q��2�����r��eMP���EzL�/�2�{�BsG�8b��X�����Pځ�sG��w���p9�<9�o��cy�3(?�3��!�FÔ��V��5��?ٶ�b|SݖP��������)/���F����s���Y5魗l�8�K���^���BQ,�ɺ�"�s�Yn��^�[x�q�׶Y8�t $_���|��·�rK�`ǔ��4�Kx")ğ**Yܔ�O&�_�.�t����|�����%vz4r�DZ����&����K�6�(ܨ�2	o����{�+R�mf��g�����:x|�UBh��R�����^P�H�^�9��\CǦ/�Tq5�Ab3w4�8�l8R����5��*+?i������z~?�.����Y�{�q_?q�Ev��lx���-���Nx���i/�2�=n�lc��c�d�C��lqB3qY���RV: a���%4E�C����眔U!Kι��l%�y�����Ny�k�#N��t���u�Ŋ��b38�c���rtz�[$η��<~!�6���~أS�5�o��`�p�[�p�x
O��U+/��";(a<�&�U$�T@����iR��+
��\��
�Lȑ�13l�r�U��Aj�ڥ���Q��q�:223�1��9+N�nOn�7���d��<;z�՗>����Zˍ2k���W�� _�'�F�܅�S��~�}��mO#�����r�b3k�>��T�/6h�Tl���� <����X��(�ދ����r��s��1�ie
ߔ1����r�	d|)������=���0��χۮc�Ý�v��Z,��OzD6]�+т��/�.�RV�?���0%���S�K���> "ۈ�*�*5����ӡl��2���r�2^Z��B;�h4��%-��D����+���[��+�tA�!��8+:~L@���Ayvs} �z>�:����Py|s:�n���4��5�ѓͯ�gS�@W���n�X�d�J&������>�������^"�䠄 _�ۼ"2��hL*��Cx'���0�K\S88vPyW�ZX��OZe�d�,<�Zg��IN�2u-D�\RU4\�[r�#3[\���X��7�(/.����KyA�_Cb'�R]�I��tp�E�K���^�a���
m%�� ���], ������G�{4�"�'aժ��zd�!�����RU��t�BY�*R"�+Q�p (���!jgW)L�B�VEak�Q�`:$�OI�� 7�`��������7_&�Qȳ����rMY��%U/���\o���������Ybz7���˼ >L�[[<P����pJ��S)u��@-q;7p9�ޙ~���~�}�`D���98D���6�UU��y�2�
�W��:�Xk�>��	N6:U��]|�R^]���:��hY^�~��G}(���n3�i����(�	�%��>I��R�B���.�������������Cy(����Xܠ2����2�Bल��HW���gL[i�bf��К�,q�Z����
e�"�:U�� �u���u��R��������˓ϧ��ܣj^��i�7	m~���=���͌.�Fպ�`���;@���1W4�GX�ׇ��B-�qE���!�CqE��Yh�z2`�G�����\��+@��^�_�Ә�!km�����:���s5�Ԓ
����)��-�Ǻ�/"�9�j`�\��UDJm)����~	��V�kgIS&ƪ������ˀ�*��7x SB�*W�:2�����Cι2Vu$���My�ol8V�O'���'t`��|#k�_�/��n���t἗`��0`���G�.�?�4<�"X�U���S$�q=�_t�E�_�`�p?BU�%N�"Ff�a�\�>k������ �>&���O#	'ON������<��.��˛�v��_�nKB���	��n�_�5y���<8_B��%_���
�ϘR���3�1�|9�<~��߫��>{�-݄8�a~ _u0��CJ5��1;0�6
U=U0!�\S�X�Y��1QU��0���M��q?�emr��1Q�*j$���z��htU~������R^�O��ZS�7G��	���(G!��	l���?�S�f��Rf�7��e��	�A�~����_~��̞�<'-	��U�	����5���# bJ��0ܺBj�=�98��VG�9�*�M�A��3Y��*x�3��z��j_��b�
��Ԣ�<��/���u��ƃey~z��W=�3 ��0�ѕ������~���<�*���}�����=����8 "���^HFQJ~�}#�ޙU��q6�܊��ɖ5��ÿu�e�̿�����,�g��BX�1�EUs�B�a!Ù�����=��TM&�j%�\(�S��	I ���hrw5�^Bb#������jS0ǣ���@�}X�*8�-�t��?��t���Z7�t�  �@?aJ��A��������T��Ԟк\�`�\���f�䖒�mP��|ts�f�Vߗ?-5�zӣ3R;@}c7�L{���ܧ3����Yc��0�x~���*�?Pc!X5���%L�ְ_Sf1��q]i>�RSH4��j��"M������v�,��^zx���.~a�n������쥯Xt�eB��5��z��Bc�b��wC:S��ܳUd�m�&���vt��L�"�N1�ԦLFZ������Y峴�|���?�hȆ�b�!J浓pr�3@�h�*�\�k�d�����
����xw�yC�e�l�W�xfl�������vk�>�<�+��!���y��%|�/�1�/|Ӟ9C�.�W9��u���m�������30�!"�)�Ȁ+���@!6V+�M%��1�`!c��6U����0A�:�XW�_u4��ܲ�4/.��'7WM�}�RMxo��ߌ���'�����p�����R�%�	�C��3F����������GNǯ��"�7�n����O��zjnT��3[+,����j������Kxz����-q-��� `wE�z=�"H����>g-/��"??����l���B� *��n�	2�����(*����àj�;*)���PA"h�׷eALNN�S�5o��_��
&b�#@�~E�o[}G���ϖi�ֶ���aSeQ�z�������UN5����ZUN�nI���wr�G����%)Aê�kx�I��SL� _4)0�*|��:�J�Z]{�����#JZ�l�%g�ã��F`�����jx7�%f}t=.�}iMn-n���$6_����I�Y�-'����	�0k�֮̈́�2���A��i@�T�֬:?���T�K"�Q�!�WV[p�����    ��E��T[�Ç��P�r��`IyP8�9����()\SU �cʊI�;?c���vD���o崂�lfQ��c���8w�b[�[��g}�j��j^?ՀMr����^X%)/�:�Ⱦ���}%���Z�V=�^�|c$1!jG�ۊ=lCX��)�V&���Mt�r@-%H���t���6��  U�7�U��Nt�%���/7��-�FW''0�G����+��W��v��+s��wH�ր��3ݲ��MWJ<91�?�����[x��/�_2~����J�J���u��-e�vzP|�͢VV��b��,(7�RvZ�B� �Ц69�R�h�7ȰAZ��ɼ��Vs������c�e^�x5)��b���������踼88�����;�]_G���C(��3��p�m���/�C��2Ұ%��>	�*L���+Rxy/���X��^���+hN��c�+�5'���RI0�o�=�|����c��R�2�b������ב"ye�����A�ȴ�E�Ypz�A�@%�ϩ�Z'�q|�8j�G��q��k�=O�|�z8�j%�f3�%v`뀾�֋��,I�A	��NR�s�����I[us��6ؓ�ؑ��P�Y�)��i��"�������2$� 'V몎N%�t
�Y���B⢮s]Q�2:���-�])І��N9�����=�������ٖ���ޞ��^�> �D�<���9?�7\����w�_�����97�z��-Y�\[�_�C!%�(W܉�t�*����T��.�\)o�յ	L��Y_YPv��R��<�hj���h�u���d4<�����J.��v�P};�H�U_A1��6������s�t�28�ɒ.�O���t�xL�M�#a��9��$L!V��W��8�T��эD�j�Qk^P׍��:[��,(�5�SR1�) )+nBf1@��R�������l9�.�S�@�Z6`�E�n<3��BHN1�-ѱ���u�5����&_��o�d��s�����F�Z�:�(N�WS8j5���L�J���|�+潝�N5{ �X7�U
vU�*1 I˙NYT.CqkY�
��9����UA����l2�_`ρQV3ۛ���ϧXFW�Rqc�#7�Sͯ�}�����4��s���P�NI9�y?!��_A���71M���W'�8��#[:�k�����Xetet�4��+)�M��A-U�ՙ�?�!��G�cji��V��9+�E��4��qyS�|�,oN�zoT_]����RW�^�[�:]C��/%Omcߖ9�J�?��Ӹ�L�Οa�p'��쵉��}ZcMe��Qg��T�U�TVa5�U�Y�J���%�ͣq�ɚGx�:0��A;G��#9���h�e��b����i)�p��;�-W�o,��_����JZ�� ��j���iEx������VjM�����*0MM+���Q�`�J��l_@e��x�� ��ڛ��9dUq�%���<���g1�*�u��qU�g��������F�K ���CGW��rNn/3�����\���9ZC
��Y"�Ȥ�QE�^��g:o_ "h _�Wk}��73T�&���~]����3'�4P���\�y tae�2�����4��4��mȀ	����7+�:2R���Û�����Z{_�'�{݇8�����g���Go|��U/짔ȩ��s���9����Ƕɏ����Y/;�4I���E�u�5zb~��F͓U�����	�"Y@�>��aD���d��9I��ʤa�F�m�����]]]9�\�W<��t!�(���Tϗ��g�2�̣!L4 C�5r¸kj�����R��Kj;Ǔ`��_���M������Nfnl�+ �E�*ʬ���N$U�$мHu�dUM�<x>}H�<la�����N?�� \g/�~7.O.N'����rApjs�c{}��Y�J�jm�ؗ��x*VS09�o����q����K���!���@��(���&��_�5E�$�&
yU���l�GY3��F�\3K�;�&]���S<g����D=�ݞ�o:Ԍo���'E�	�cse��z~?��!��'��,��2T��(�O����?r|����_�
�$D�K���_������m뜿h���ٜ��Q ��-a��ɀ^��{^��I��X�J��z�c���-ή/J �6�vDѪf�Ĉ�f?G_�G���b�׀l[vf���{��hJ[t��Z�J{2B�Oa�K�����SxI{
nڿ�������� j�;x��5vZޢwJ��l�2A�	pVU��d�T3$a��#���V�T�'��4���ʣ��i��z�i�=���z����j�E�_�O��5�2�	k�Il ���?��*|L������9tM�Y��6lMըk�ԎHc[\@���՜:��˧L�qc+V1Maʥ�����X���x��:%:�f����貜�Y���z%���G��	n�鳢���<𿵚d��?��K���k-*���O®U�H%9���c���P�д��R흓����斎R<�{�;B�փ^�r)��y�Z6Օ��*˪��W��}�쬶T����lZ+^~��Q��IG@�~�X�9\~��u]���JFh/�&1�Ć�c�'%���%�~,�U�����0�`��BV&�0*��;��"�8dTJgCd\�P}V�#K8�m�9� ��u���1M�n Q:��IyuF>���rs����?���k��%�Qw�6�.�˟Q΁��j�&�5u̽U�Cщ���f���W��z�7�i郱7�_gxSҸ17KZ�Bώ�0�*1+�\�#:��O ����*C���U��ଁ.�(;�_x���ݴdQr[^��/����Kh�}G��cj��̼7��gۄ�.!z�2���;�Qt�$a�%�pq��U�=?Ƈ����#�n�r0?k�l�҉��)Ҹ]C��s��5����*[T�^�+��0k���N��uS�-�V hԬ�����M�"> ��TGJ����5�kR��5�	֚�n/�����..�h5[������M��rY\v�{PHj�&���>4�W�^�&:(�c�5�h�cSB�*�����=�ȧ�� �.�\X���
�)
�y�a8�u�`�	�ߙ\��hf@ӭ� v�Vx��B)*%�, i��A͍��,�����h�ʭh�(p;��� �@Q-�f"�^ߟ���`��!JR/
� ڷ�����q{�PONJ�{��hU��9O`Z*�2�L����nH�d���"PV����<�cT���+I�Z��TӕE���2E�@�:@���lr�����e���ʿz��u��&��0+������i���b�
�CX�O@PԹ[��U�~���\�����jQ��$��=��A�����ـL�c,�f����&����y(�C33u��YA 1;˨K��S�.�b�x�K5ࢩ��/naZ*0:ݠFΑa�
�=ح�zz.їv1�[�_zc�e~=�m���� �Tγ� �/)7�Z��TB��%=�Bz*��k��,�8��U(
-����~δ)�y
�s���Lk��NI;IRB���+�+08.E����CN�H���tEy�mQ������1m�� Kx��{�f=���^�]Êyٕ"뷡��8�g�� �=��C��S t�3�&�vl&�Mc%+I�ݾ����ˤ�g^�S�S$Ĥ���T�DUg�T]b0�JY�lE6�s�V��6�6VK]S�����&�,Y���])1�|�<�<�P��V�kN�����!���R5�5 7[RM�!b�����S����C|����^�7-BfM�]sl�.<R�WU�8�#�&Č �������˨�0PBh[�Lȁ�JEe-�Jg�7�W��uUck}��j�<Y*�o�\#��&U=l�?O�CP��dR��JW�t�5�9_�/��.�X3��77��*&����)[��>-�~��F?�k���/i$�{j�i��-CRI��9&������M����A���/�*:�d~������MpjY�i��IT��Qa    |�6�	�N.�h2��A�KN9W:��2�((ש�A�N��ߧN��6�s�]�|�׼������<?{��VV"	����y��F�v�^-����љY��Y+$�T����K����
};�N���k얭=<�5N��>�D��τ���xH��`Z�aQڃ�Ti۬<%�c� f-@a]����m�R�뀇���]Sg$���Z_@�d.ﮮʋ��`\^���ttuB�aL��Q	3>�-X�֖	�m���Cy�b��x����a����f%+3�P���%C�{�}S[!����r5Z`;VA5D�`���_V��L�nvZ�٩bV�x^~�xp�5�1�3;r�h��:�z�f��A��$h�1��i�L�:��%0"Yemc�r`�?��,;����n<��F������尘�Z����pe�v�AU.�0�N�]�z�/�7x�� Dk��i�@�Z(o�������R��s� ���)�n`��.?S��̈�Y�_[���6��ע֬	f�TJ��]v��,�P��2`���[׺�@�T��SL��ZY\G��Y��"���4T�Z�mGg���Lhk��醡T��E�x�v�<�a��+)|D�u���s��������{a��RP+�l7�ʤpŎm:�V �j5h,/��MU=� p�f�j[bԚ	Ý�����<E^k�='�mLc=�h���nY��=���X�poFòm�>=��]��6b�LnGǣaS�{?kƷ'(%Ale��^k�.�Wh�.�E;`�m���Ll@�x~��{�a�?^�����-Yj�Y|�{�V�(�2�#�"��k�����.�n���Qy���D�������x��+�]a�j��4{��u�� :�v�#GU\��O��dDMGӎ��rx^Q�����|D�h��ꝸ�����ri{-�oL�d����K�M}n�1z�Y��:Z(ba��%=��&����{f�93��#-V�ܬꊑJ���A0=��قS'��F�;�_���	�X���^x�u�pw�;��?h"S!%o�c>7�o�.�\w]�.����7����<s����RR�3&a���"�K�Eog���.�I\�N�hc����!��&6߀���N4�ތp�k I/�kz�8T~ w��I��hRɸS2�*ǜ\���\T�xi���&B�!-�LM��)��t�����V�5�J^o��i�p�T������Qfk�w��� $�Ң}y��|�ߑw��B�fއ_�,�f ������eԪ��/|��U^�:r���0}��`����D�,��>�J�[*�������\�/��1���'��M;�|�<>?�(h�v���6�i:������}U��xw��:啧����x���zjw#�ip�53]�����s�%��N�!4��:�a�	�~<�&�$!�S�le��@��	�5Ryt����B�hW,	����IL�]j�����>E8��50QUE]I���bW��9A5�-uRl8T��8d����D� ��hl����{��Iik�� �Z�.�ƃ�7�������a
��1�JC�W�3֭�SK�=x���
����#kլpI��1��9*����� 2�l-X�=�gó��y�r��ҡ�"{�;e"�t�-�3�zyM��g7''W'��ι�N_���s���۷�v	ދs�˸�`-ބ�W�tTj-�������S�"I�F�u_��L�z ٚU6]�I�C���#a�G����I�kj�׌�~Z��kJu�j�
aU���$��+�6٤���oRD�w�&�:V�j.kF��ϯ'����d�
�|P�x�i��!I)sp%f�d�W��7�ۥz��匞��p�i����?��P���ϧ��׷������v��Юմ�q5�����fv�
*9`����
�cC[4ԸW!�%��%��KEE��yA�ⲂNVʙȓ�dM`ꞁ�R��%��r
η� ^݉�N�g2�3ݤr�����n�i��ݍ����JH��4E�m
9_���(l��jy���A픫�Ș��_o��������<����GoW�՜ꊏ2 �ij�����m>�dv���r�6��>�'Âs�V	��w�(U�JY�oi�2�Щ�Ad�/����u`�k[�9U�j�L6YQ�D�d��ޚm��L�9]Oc�Mf��l|�`��֋��01�En��n���>�]�q�G0X��J�ǧ���{N��	1M��t-T�������f����y@��	fw�f��;���h#-�Zz�4|�*s�h��WM�$�������	����	�NOig��w�����^�f�ۏ__f�a���kă3��:�^�8�f-ێ����Y���%~f����?S��7<'�o�>�<zM}�r�ƈ[H$%�4*���uT2�m"��f����툣 V��1e��M��zӴ�XIC_���(aX�����u̝N�C�'��m<��<����0�R/��-f�{�v)~?��Zΰ֣S��4��k�q4�!U��������
�lG �`����5Q�yp	�m6���l�\.�i!�=G�6o4���*lJ
�i3��@��6�����Ř3�h�C���H3Vl��F�I�;Y_�\_B'4��}t}U^�%����1��C�E��Y^�h�K�&of�y�Z5�[6q��*b�D��i���-���>����� ��ϟ{��Q9"��z�����6Nݶg�Ò�9��$x�0b�N�h�ʩ�ZՒ�w���WF�AȪb2����Û���א��1i}G�Tp|^~)����ځ��>=0-�Y1�,/	츑����T��z��R�km�ڴ|�kG����i�ڣ��Ӕ�k�f�\�u�LN�7�vzqtnOU~+���BEj�.� ʨ�w��"('����xM�w�7�֡�)[U;��Prve��������s�q���7�	��m���6Y�f�l�X,1�)Vl����vx�_��-��4����/ڄb��ִ_�f��ڸFg�t�
���﨔?s���e��ne��ڑ��^�{���H�2�c~}_�o��5���u�`$���o
cG��h\˿�]������e�h�a��X��~�ϊ��5%Q��ب�ʁeH|`7%�4\p�N^X���`=|Zb��Ti�`[�P�x�Y&i��#\ber�V���|�YҀ����U��l���l�:�O,3�[�$M*�e�zK9�b��T�lg�.��%m_��\�a�h�}��C�K���<��t�Z�������^i����"l9���$t�@h�:i�LAU�k�KɧZM�,5$M�ș�9 	%^K���)N A9��;9 ȼ��vߔ���3Zn�"�\��⛃���}���k��.�|[�!m������$��K�{;��Yc�5�2جU��-���|�w�<-����P,~���4���w�d���}W�W������c4Z_N����^�C\������h�`�(z�kh��_O�}�B�sw����k
 ��9ί�J4!"hB��b��̠'��]Di50mE1�JiH��P7��>��3KC�R�H�F�`#x��
��3);CM�,(��N��|����yI-F���9}Gǣ�}���3*ETLnIU/��k4[F��X�-}�N�f'��x<�}<<>�?vo�:���F@H>pbUv^�Dmi&ˮ�ڬA�y"!*A18)>\M׊��
 /�Z��$���<pa�^����q5�\f����;ѳ����K��rrU�'�_(a}U��ǟp����os�%_,!zk�e�[n�3�`��	mJD��!?=������`چ����>�+�S��t�Hv���c�|F���hS63��Qĺ+��/��#�!H�
z&0�$�Чc`��m���.�[$;[F
�&��6ҫ��������g�������5=�e���v��r����r������2h�=붗o�A�q>M3<lq&��R�'��a��O��������$�D��ȫb�H��<�+���vf����
ݿP>���u<��=��h�uJ?mS�v	~o������q �  �2��f�o��[��DnޱaZ�W+��^��e�Ԫy`C��N������@ ��==��*xd'�r���J�:Up�^TA���N	��f#�E��t��y9.oi���MS�ܴL���Ɨ0�r{��&\K�n�\�/�C`����������o��M{������U{�5�_�)��g֘��25B��2���wjJ hڮ�RO_(OXE[�Ɯ���2��{���/V��	��)��i�9jmC�T��;�k*M@r@^��48�K��D�@�f/��FWgs�}���Y9�(i�֑$��"������2�[���zSh�Qa��\}�i��
Ϥ	Q��Pn�����i�N�Qձ���V��W��߹��j
����H�h�h���ë:30򐵫�����z_��%tK{�h�s������#�^٪u�<��I���B�Z�U����bxY��k���	��+��&-�ԝ�s/S;M������z��l6)���9_D)��lb��<MٙM��J!��l";�i؅�����U��vm3D�"(;K�õ�:�a����L��S;����稣�ם�w���ey|�����Pyr|:����i'M^("�1~=��o[���ϧm� ���l��[D�.��9ćG����d�x8H����z-��S�iZPv�n�h
]kC"�V��a_S�*J��(N������w"��b�d�$���񬂫lf�O��&�҆yg��������S�� �����z~��}¢5� Ue�ib��2	�]|���0���������Z�:ݏU��X�H%z��7��UA%!�6t�RR���b%�L�-�E�5�W&qM�\�j4u�R�De�J�2�YU��4,�u& ������6�KԄ\��uq<�ݭ��=�ā�6ӆ7�������2��B P?jR�hr�/�O ����~�����r=7$����ܒ��@)۟�mBTM��(
�)
W!aٜ��D�4dD��*���*�x��6���?��_���C$      �      x��[]s⸶}��
=���F�m�&� �tON��}��0��.B����wI6ز!�N���L����X{�-��| ��}!�H����f��{��3NӾ�ћ���|iz���{�%}�(C�
B�?x��b���/��3�jo����������O��vw�O=��x��e�������'w��`������o���ZNY2dlȣ �keXK�������t��m]�w�q�x.��x�l__��otu,����V�=�g�(MT�0�������'۬�ޙ[�X����ss���U�qw�R����8�8�G����~��@��s,�g#�����}�hn���[�-���r�.����&�[.�J��nM�=�j�{1󑙕[I�i����,�,�t��5�33��S�ݔ�2HDT�&��#��_���<|>V�t���|�!�󡊇J�'g���VBTc�7�����<��s��e�E�ZE=����!wxԫ�,\>ݴ0�|(tqٶp�mZ��Z�����f���UP�OF���UHo�1QD����.7
�gޙ;����eֿ�~�����G�{4����U/5���0���@������s��jM q3����*qoc��b�m����=ܣ��`���o�tL��u>���|����&��[|���!Z-VW��b(�@붺"�ԍ����]d�O%���Y��Y��̸��f���Ι�U{�^�T����LU�45��J^<��qoF���M��U��fm�&��(	%+���xܥ�Oy�X��l���![�t���냁�Rej�f�9B����S��Rɯ�_��ڗ2�6�?%4�ҕ�`���O�����f=��͊�ֈ@�)yܝ��G��á�@+Ֆ����pZ�$=7w3��<�f����(E� �7�i0� _�>��"d�?h�[n�l=~���7T�)@�����@R�'���w��:q��@�F-DN;�V�����Q�l2i��d_�.K�b+�"a<	��/�)	B��i���UC!<e��"G��q7�����K�HH�
@4iQTȤ���m��)�����RT"E��w��:����\��-4$Z�冞\Ed�Ps�n�L���[���jޏ������7$t{~�7�?_����#QN*>B?������U����붷Ē�����*����P��w�T���L6L��Лnf�|�.n��hP��P��P�a���MR��S#Ι+>ȇ�t�Z6�IW�4[T؂����o5u� �q�*J֔�����;��js�q��&�j��%���Q��{�j��Ko�Y�x�Zso�e�R�}��!�7�5 pF'����X��VR,����<䓚��z����}��LZ�@�(g���ٲ*ߍ��\y^����Z�\w|��MȈTW�V��n���S����~�/�z��a]��״ĂM-�0Dg��m\=��j��*[LN��f>�Nr:Y�'9��j�����hr��,��H��k��Iٴ 4Ϥ5�i��RTI[.�TX�pE!X;\CVCIdr��Ǆ�X]�Ͽ����d�_=�� �]�Ĭ]HBUÐH}U3��-e8e�4[-SP��e���y�x/~OE�d��B*�8�D;?BnÈ���#ǩU�qA��c����fbC����c[���m�n�1	?�3�2jn'��QS2R�{����U~<](A�M3h�h#���}�%ÿ@�N�{0&$��ԭ���+�*li��ubǃ�P��:(��'N��#"`�Ԉ��aS�4+��"u��L��D͑��L�S@~=m� |�� �a ;���.�����6��[AΘ>i��A�YM��Gj<m�t�i�~C+n�Ė��c�!�$L����l�c>n�E��wp�I�4��|��a\G�) I��*�9���@��t1��g�ebS(8%O�J�z��G7<Q�:m���bE�ځ�t��Q|��Xv:^��	E�nzC��.u�G��O%��U��BPN����g�4�H�����~3�Hs��/WF�&/��^�p��_'��Y�����l�t:3o*"J\�,B��:^8�{�j�P/o�"lg�n��X�t5I��Q>��w�]a�?�N�%��3�a<4�$���ʬy���韖��[/WX����,t� ����ه 2n�_(�ї-R+Y�\i�\~R1_�UCE	��r
/�o�M��QZ���/|����<G$mdӬ����u[O/���ҩ#�m��9E��<?���G�A������&_�2&����ņv���jxf�!����Bb5�ElJ��!�U��@&|�^p���?�ݑ���?ۿ��3�����{;�'����R��������x��߆��\+���Y��ǹ"FTt��3�<��������[sg`�ꤍ���.'*��= �]W��t��]���N*���N��iy2D%�?t\f���"�����w���Pv���~����Sm�B�`��&�+��>��.P`X�;�8��-
IԘB��/ŏ�0�٪��#F�����v��E�{���<�p��~��O퓐�b��+�t�!1T���ҏE"~5��P��MQ2:�k��%�~"[.-H�'Y:sS��4���Y�Y�Ǩ���x�Kae"��E�(}=
q�� �[����ka�QE��#���0-�H�@�?�?�'�b��ѡI�0X_r9�<9״��.x �'��6R�-w�ύ�B�n��p�ȫ�QL���5��E�w
p���@#l_tQ|Cp���mwύ�B��?�'��Wk��*�5��U�6�F^ϣB�.�(���q��#�?4^T!���N}��B52��v*/�`?�R�%s3��e[|����U�:�FZ�N�I8�R�ީ<���^�x��!�C��s�$|}9�ѕ��֞�^udG�N���s>Zn"Ȣ���5!Q���� ɜ#l��ǝ=�uǚt�="�ΐn1�����*�N��z���3׊ �d�E���5I������S�3�Ȣ�"Bv�����fh��1Ӄ����fGw�.N��L��*{��9���S5���ERMn��lb�h��Sz3���n�g��Y7U�Q�N�t�6D�9&�$�!�hHi�� Þ&m��7q x>�t�mc��3_�=D���˶q���4��C���D�LaS�[Yel,W��?������.X΂N��^�EpD���@�\��!M�hK������*�0�]���g�%���y8��D/�_���ۿ��Y��DU�!��vш}��I�.*�b2Ko��ɍ����1Y5�>��8ƞ�N�<��&��e5�N�;h�;�ě�Ċ���N�6l�dbϜB�Ou���8"������gK7�Y�Aȁ�f�I~c���i%�������>��E��G� ~}�"=�� H�PvP&��g��yoñ:+���B��Fb�_�Dl]��N�c�Qy�u�@�Yq:�����x.;��g����G�����g����֝g���fj����ȶ�zBk�yV�t��@w��> k��FL�g���	Ce���66��H����Dݼ����>�~��z�t(�^���_�K�4u�a��_�((�^�śM������j�nv�#MӴ��5Y�1���
W�x�T��2�#�$n����y�������}����-^����=��}�����n=��ؠ�2�.eg��x���$i$�]�.Q�ͱ��;/���e����y܉U�͞[��:=m+/cm{$^�KI�}|*++Dݧ���`�;x��Y��[Gz���K_a�������7Ui�q��(���马B���"�U��'�$�BB⎷˸:G��/xU���o�v�߭wOz�� k�P�&]t��DB�8n��)����~���<��O���H0v̉2�9�Z���D��E'��)�%scV�7T�;��(�8�L+P?���je,���7��:�ԧ��$�:��Q�����i�;�[mf�`�ۨL	�[&%=�:*^���+�Յ���"��d��I�e��2�7f���w��$�К���`�J= F  t(ڤA5�G�˙�����~eS�^��?�-ܵ &�at��D�a~�I� Us���=�;hW������xAu�G�.���&�n��LSz��l�����c�z���dOY���N��0��;����f	��>���]�8]`�T7y,\:U�z^�����%�2��W�a�D�g5cT쾿��6�Gq�|w����Ӧ$}ќ$��5��;�Ygy4ª��;�ݎ#+*I�ͩ�*�$i�ż����l��Sh�/�Ó����Ö�';7Wp(;.�o�����.��C�'g��j�l�v��:���0BK��G�Y� 1)��=�~G3���K�~��M�����"�P�>:H����C�$����q!�Ǩ1^K ��/�3nRz;5���vA/��rvt!b�}�Fu�k���:$�����hu��O$䌠���Ό�9���D��;���]+�5@q��(j'��8�VD����VP�g�6�|d��؋�������P!Y��hy���Վ~���q�݆H����Բ�k�Pmu E{ ��D��?ڿ�Ŝ�.���ݵv�:�+�m��R�h���j�\�u~M���+�y|���[�si$�z��_�yR�ĚH۳��w�ث=Z}������r�ָDO�Og�<]O��K{y	�Y����������q��+�����]^�z��j���{�M�K�j��ڿ�n��릖d��v"?t��,BP��B�/�ݬ�������瑴�j�-Q�O��@$���lkoĤKp7w}��s�ju3��qR�p�'�4��,P� `�0_����"���J&��e�z~��x�UHeO�T�k/-�����_~�?,@      �   O  x��ZMo7=���+%�cni�94� ��b��dQ'6֛��/�����H�� xoH�|$�}��h0� �"n^|�}�__�l������æ��ї�lu��M:(��O�l�����������������Qn����Qـ����__����������x[Ê`����1�AB� ��A09� ���٤+�YtB�ڦ��������@/�[���ב���|�Q�.�~����KS�t�+Y�q�t���pUȌ�<�x�_�9~=춯>���>��q9����c4oo�W_�t@e�W�i�z�Z�3O��=�l,����F�G(h��43ߴ���)瞐�!�O���#�[69���OPǠ�'��v-�t1�M����bk��>�T;�0@�[�Tr8)�� 2���7����a���aw�iw&��ܠ�ȩ�b�p��#n�ӄ7��U���A`�e+�i��I��H���Ԏ�#����'{���i}�����p��pA^	�&kr9%לcb�- ���,H�M(,��J|� �X�F�
8�RR�*kXl��L�6�XF&����O7\�w_g(CV�h��BiTx^�l��Ѭ����N�b��dR�!��ZA{il��<�z�.�t�`!��4����]�(�n�$0��F7A�|�=�u�}q��Hv0r��떭t�
�u�'Z=H����Jj� 5���M����UR���y��@�8��r�	@�>a�|�u�����@�g��.�����.k�Ǭ�F,��MɚFY�b̊�mk� ��n��P���N�"!�_�j�Th�z�|E�G��L\������G�A�d X��Y�L#7�����d /�m�È)z�9�JoQ��P:/���2C����#0b�\����#��M�D�/.\h\t��@��Bi=�1��?��k�^5�+�DA/C�d;X���L�����`�C���y�O#�!� �l;xAb5��0��<
�1Ү�$V��s�|�K�4�3��9�%�L^M�n�^�	
bs��{�4�5����br�S��- p�}U�^(��-��}7�W���INk��� \}U?�����J^@�* �ز��V^��J:�&�P�)=2x[;��Mu��-(۠���BsU�������]���%�.u�QB[:h��*���^ N�>6e��w�XV_��x^5L��Z�T��1�z�$�EE�ap�Z���`�{zb" ����X�nL���EU�}�*�r�ov�������=c���9eOw���ң�E����j��A�SCLY���ɜ*eLV��F�jT�ͳ`��ɵ��ҀڒU�d��gOB�G5�i ��TIP�-<�>r�9;s�Bv������o?PY����KҾ[]/i�043p�N�`�ś�Y��JYW�O�q	����c�n�Sμ�~��ÂA�K����ރ�w��s�f���[�4>t�����!��N2��m��}�z�J�EU'p�>R���Ig�<�@�'Hx9?:V2�����s���[��U��<�h�0AA���k��5{l^&���$�j�)�rA�z�?P��#�Ŭ]E���*�z�v�p>Z.�U�|��8v(���sn�p��,��i�Τ�A��L����v���~��i�LO~!e� �I߮�|���n�Jrt0,'�*Ah��P>�ZB�B`��#[I���3`Y��9�͜� ��^��+�a�f44aN�h�n����7 �Z~�JN KX7Eho�N7��R�)H3}juL)$�+���ǔl��
:�����r��l��O��&`���-D@m	�E6F�]j��8�+�|���/lA����������З      �   w  x��Y�n7��~�}������j�~�%�n� 
�R�[���? o�!w��h���k����9s��ɼ�r��͔?R2�]L��}]ޮ��y5r�a<Qɑđ�9�BR�Jx	�e@h5��V#��<-�#dϓ�F�K���o>�����O�����77w�w��z��	����u��e�{��>\~��w#�
��^�q䜿
�mߌ@�����Y��uJm7�1�r��"�g쇧/_�/�l<��?�f�ة����|����?�^(�,����˛�v=ZX?�n?��|�c��)
^�R���X 	4h�I5ޑ7CJ
d�2(������'�o��*��^>lv��Ύ��� z�J�]C�^��쬾E���������wB̤m���V5����i^{���5�֢��?@ c8����Nԩ��gcQ���l��Em�#��"�d:� d�T�ՠ��m>�ͭ���˧����䊷2����G�='���\I޵�FXc!shbЯ�
$�������V��8�3�}��]��Q�p�tI`%�>p�Ba�\Ű��k�#�ό�|C� ��H�#��A�r�xT&D�J���Y���@�;m'c���o���r��^�M��5�V���F.�[6-�4�6����ǵ!{V6�@L��T�v=������� ��-f��?s41�>f�Y�j�ƵJ�-8/���c�^ԩG��&l���-<*�A�hV�����ȿ�Е��[�O�i3wܔꆆ�3VJvI��9	�	q�z��ب��Jz<��L�8lӽ!�KR�֐�ǓKn�)�]X(-PrY�3+e�CCl���D%���=�6I�.�ho4u�8�D\=`�<��n��:������$�y8�}�'e��L6���rD0�9�!'U��ǎ�7��t'y������@6đ�����jU?84/_�]�W���>=�����!r�W$� Ʈ����֐+,�*4w����������A0�cDgj�e�ۃ9{�>��-���ٯ������/g������j6�8I���o��%n;uA3�mQ'_�<��* *�yo�y�;�J��t6�1�L����d���䜴>�X�*܁R�+U��zMp+�8��6�M+��7ܫ�������c��:��aOz�8uJ]�|c�����Zڐ������#G����S�,�A�a��{��s�ټ�������k!Dz��3|[��j%��a�I�����_�r`/�BqG��YP��p�pH=7w7wQ1C3��م�1�ZXp@��\Շ1����Ƈ���I���v`��۳�+�����(�����FX����6y�r��L�H�LH!L;�Tև;+�I��.-9�B��{���_���e�M�o	 (:��Y�?��TDF��U�čl��Żg%��\C�|5�x�ی�v�}5@Vka�v�rK������XlL.���s�e�v(t'�x��e�}73A;�>;מP1A]�rb���;@�p'��,�"�p���=�W'����"�H�������	 �ygȱ.��'��?�at�Qt�H�ݧ�7��H���:h�Vr[4I�~+#\�\]]��h9��Pۦ�|\�\�}�	˧���l���i���&�&�/m˅@^��z�
v����n����$����ǟ~�\^G�K�.esnȇ.�KD�cl��?58:�Nn-�Mvpe�M�%���QJJ78�.g�A�������҅#9b�jy��Zh�T<���mǜ���<��n�ߖ����e����v�ވH_b�.}&���&�~i�����Y4�P���j
�4Ν"8�%d�A���5��Kn0j������:��H�X˂�8�ۜ54Ή��'��l�sz(�Vs\V��X������~�ϧ&�6c�뺌�XU�t̝;F7�ɂ�By�Qe���Ph�`�s���M���j =w	��"ឱ"o��9Jb��OAa׋�׳�I
+��L{E�U�1;K;x��!��d�׊]�\N>F�4�?v�Į�ח��p��Y>o^?����b#�=�+�q$�Y�z{�E�ub]c�����/\�����x�G o�P����~I��~�/��,`;��}p�����]�+
k}������������      �   �  x���Mo�0���q#����ˊ�`X{��Ê�ȚF���i]��c�GC�c�"E֕8έ��z�nu�������%G������0WpJ���ѲL+���۟�HҾ���LR�J)L��~��d�#-�^���۫���dWARC���PWC�J.�`��|�����>��I���L� z+f�1��,��$�T��|Z�����.��@���c�4_T��t������i\�no�|=x����zu�H�CO�@]����"����<iqp&��9xS�)�t�[2�ս�R�̲~�fb���9y[\b0����H1<�wu�C��+~b���(�i�6�80S��hF{����`�F���s�{����)�땁;4��/øO�2ٚ�)9�̲�~��u֦��6e*�����?�exfM��~�4gzk
��B�~��3���;0�:�5M]��d���_4M�uN��      �   U   x�+H�K��K�O,�O�����*\|�
rI�y�ȲN@>WAbf
gpirrjqqZiNN�BAbenj^�BI��KjbNjW� I�#=      �   j   x�U�1�P�9>L���ܥsU�?��b|r,+4���]�G�ü�ՙ�c�E#�l\� )%薭��|i�h�GS��U���fk>�&�ϋ�~ ��:E�      �   6  x����N1��g��/���/C�(�-!U�&4�D	y��z����R�\���?c�o�
��q����9�Z
���E������㦾~YԌ1qr��9!����i�K@Lv���,	H<�iT�|y��2m$�I��/1X�� ��"�|Ju:�h�%�Ғ4+��MUEx  �gSv��ͥ,�t��MRv5g�X�Ad�T��T��0=���q�>���xfA�6qz����zGllIxX-���ݗ��=o�|�Z�wE^�x_�J��&��F�/�"��)b=���T�H	��,!��;�HX�Y�J���tV��?�v��A㨼�R���	U��Ҟ��H� 3J(.����x�ݘ��[Р�bD���~�d�J��H&�L�<<%�(m�����j�]�VO�׎�c���3����rYX}�7�#���C*s'R[��, t�kߚ�3Ω�$��|��t��}3��C��a�`
6����܊�Y�����&	"y��a�.�}\<8��t3F"V�����"�gySX���̎-�1y<�FÏ�ۮ�q�cۥFk��\��f:þ�q����q�r]�X�m\�&�8z�\*���C�w���z�Z֎K:��-��F��lhz;5���cO�O��|���=��<� �d7�T��T2�����Ψs�(�Ry#P����;u�XÁ���QP���Q�=�}z� �����DQ��7wƚ(��������������J֧{�3*���ƪ�P�>�����u�S��X8莓���9�M�5�%:W$^t>����| WG��ۯUU�}w��      �      x��}Ysɕ�3�+���U�}�[���"6F�G7�ji�lJ��"����='��̪,,Ǹ�n�*��=�6�Uy��������F�e��|���U^���ȋ�x���v%4Qz�g��&����w/���s�����4�?���������a4�����6���~F����1e�T\s�)ʈ�#jF�������;�m�����u���|}��ǫ�<��we�_q%��H	��M�^��F�7�|O�y	O������ܻ>f)3*=��=S�!d���'�v?�M���d?��@����zwx}���_9OyMU�'���S 8���i��^8���<_;�J38M���r�x�|���i�k�3B�҃��bĬA��׻�v>���3x���F�����6�D�Mt\Bi2�3j�Ly��7W�zS��6�o6���;�Jj��P<�-���Ɉ�*q����h��wŮ� �MW
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
�K�M}��U�YT��e2/0�Y�¯ec%ֲ^͖+�4Ն���3�;���(P�ľ��&�Tlcq�3�k�[���@ﯟ~��D�b��`�����N�=w 1^����+��O�kش!��3\�=8-#8t��D��4u;"�n��5�P	�aj1��`�)1X�jx[�1�����0�Il�^�o#k�	p,i�����5�� ��*�H�r�|�E^8޹�xy�v�y��Ô9c j  n┸�����K�g�ߩx��
��T�>�Щ+�}t�R�9í;>���=|����Wү��>�³̤�_.��C��/ؤ���
�r{{�A���u]�<<���~~��y�F�'��V���M���>Pc���L�	.;��w�2ǢRm�_O������c�����.Y�x�R�i�h�ޔ����G�2�׏�]U�3(?[(vL\IW(��R7��>�c
��ΰ��~�l*�ݼh0�[�C�|s%���"�*���|J?GZc�Y���_{�B�8���K���*������e���L�~=��SR�����߬:DI\W~��x}{sF�"�̷��c8]��f�-2M��?ٻw��?�&1�      �   &   x�3�420��52��J�I��L���425 �=... |�%      �   6   x�3��HMLQ0�2�0L�L!S.CN�Ĥ��"�Ģ�T.#N����=... }�      �   i   x�U�1�0���á1�g,���H���p��� qC,��X8�#�z��dKRI�$AR��H�$ �I��L2�H��y����r?c���ʄD'Sz�ѻ����9�      �   �   x����
�0��s����I۵=��@elz��*��W)XX'4���{�Je=,�1�<M$���q{ޡk�4���ξ2N *�z$�>gX�sæ����J�eTѐ�aE�a��é,�FC���2\4�����h������{I��v�=�}p��١������.5t0,�g�b�W!Fh��]��mC-�f)W���.��>��H      �   �   x�u�1
1E��^`���fLzO�Ղ�����GDa���̃�߯Z�/Z�˭�R�����:I�ZJY����-��$�Oj�����=9��{?�?Sֶ�@���A�#�1)F
���uuja,�ڄ���6j�&X@�	��s���M-�M,�	�P�7���-��)��|,0߀����b>�;U�gl����.Ղ|t��cK��^�A�J-�|�Yx��9���-�      �   �   x����
�`�����������$�J�мD��,���I'I!:��c�a$1	"FD�(�� ���!*�A6˃�	��q��u��&�Iތ�O���%�i��M��չ6x��l����kcː���E�	,�����MU�W��l��K��ncO�~�u:�u�����7�M@��a/P�}i      �   �   x���ˊ�@Eו����[I&]�	4C��E�4�!��?�0�ѵ�[��Uah*L���~���p:���vj� ̬��?�T g��ml$�r�_���\��~|����SF
�@YRC��Ӕ\Ś[:�r�v�&��'��Y� ~
F��ۥ;ޯ�ˏ�_�rS��˪45�Y)���!K����P�      �   &	  x�]�Yn�:���Ud}ak��HG�Ek2(�������*���g�bMTYU�,n��kx���T�f�1.v�ݔPk�v��e�������e{a{1�]ݘ嫙�>n~X���D�u�7�f�� ���I*�9�+dPC�ٮ�IC��VYH��܇�e}���a�5��<B�g��4��ڣ}y;�ۜ��̛���ȣ
���P;*q�C�6&T�Wp+�Hmv�Is�c��v3G��4Ƞ��&-O���}�+�*/"g�^�\A��&�0�q{x�(͓��֨xz��ڬn����l!޲�7��<˭���F��7�A�A�^�]�j�AWx�aﺩ�i}4��� �r	T8�=�2�a�aM2��=�7��y8i�s�>��m:Ó-�i��M�XT������u��Gg	+�]J@ԅ_z��`_��� ����� �8�Gv3�h��FX�]�1e8��ˋ��[���2+G�/$#��	��=�'��!5�$�*��6��R��󺗂��	�ҟi�z>�V5P�QԙŎ���� �XF�(�Tz��ET, �?#��{�����5��	r�����ͪ �G��W9´Ct�h,�i�y@��ܭ ��� e��#�v�N���!7�$���.*�0̂|�.YqE{MX�{�;X��O&��C����B ��mW5En���&�ê�o܈���ecrI2����z�k5(,�'�a	��>e	�2<�꒶&d$� ���&��̧���2���co�v�n 7��%pe� ���w�����J$�$��<�Hp��j�F�Z#(�܀����w����0
%"�e�;\>L8���=���IP*_ی[��(��9�\"���H\�zp��9����0�mP3wT���jBo�kʍT�)�	�w,��ܚ��_�N�r�B��U3D/>d�ZT�1��{*���Eǌ��Dg¤#N'��ʼ�kC���_��g�����yfB����
%�i�'Y�K"���| S�ɩ�o���=�����_��)��ls,qJnfFaޠ���^-���P��"��E�|��B�����GQ���ڏ�(�a���3'ݭ��������m��_�P}��ym&�^���[���45�v�9�[v�����R2LL)�T�eI���-�6���%��Gۚ���}\LQ�ۑ�$�::�#B�}�a��@���d�G��)r%�����Ŗi9���
5�S��n���bEP���iUY+u�Wy�� �#���	���0��v3��O��S�Z��1����x�5QMI{�k������m�D����nD��%-��3FoI�>p����9��J�s�T�i2U`�AZsI**#5ZQ��0�Ìv����Fv,�܄ĈR�O!UZ@��^0�v	��V��|K-����l����X�6����c����担��~�1�\e�w��>F�Bh��HK�HS�"͙����9����܈G#EBQe�1�+���r��� �.�McNn%�&���;_��E�8�t�2l�>����-�vRr�OUC5�a���<*�#>�l#�B͓<4]b5�1Jߩ =�&�n�M�hx�KD�os��t�X�s`O���T��B�&ñnGR�Yc���=�۷<�BxYu���ۙ�r����xB�V���؞�gV��#�=�\_X�#��a�K2�ɛ�K�6��L޹F��fe�k���U�4�1�4���o�%h�N
���>�Y�H�S*M�|�q
��D��;7��2���B�t�l$���a�G
f��k���Ť��j|��F���!�'L��f�|�C�q�8`�� D����ȕ�=ҷSP���e�1ҹZ}�)���)w	i�� �G@�G�	��9�ɖ�	P��*F^�6��h��U+��P Y�a� �Hc��#>C!���(���<�c�D�b��=�"y7�=�Дm�jӣ@q�'�4R��{��_�?Z�D�;�V��Z ��;�<��n���{A�|���XdFԜ�PS�)�]�	��;�y^�v ߡziBUR��r�����Ө��5�J��,vl[�yD��{��<
�����*����J��TN��=�t�~`+���D��A��+A�����Q���g��@���yX�%�8����{����Ǵ��9>�PJ�v��gX�.F���N�����!�jE��2��	J�?�|	UYzsycV�`S�S�4}�]Pg���^o�Pg9DCF(��k���w�+�s<)�)C��~x�Y���v:J"k{�����������      �   �   x�-�K��0D��0#~	�,:�@�Ѩ���9�����r��h�ӻhZ##��y��a:�/2u�8#z�^F���X5���u�Ū��M��6�8?i��+L#3V�BK���3�s���H\i,K�Ww�zē9���P��$u[�`K	�2݁H��nL��TK�{�����Ӗ.�V���9��'E��+ъ����Nc;��}�M\�s�Ah����x;r�����ϼ��Z�]�G7r&uߏ��)����[�      �      x�t�۲�:�5z�~�y�}�*&g��
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
&%���w1c�='�an���~# 3�Nv-�� �T�]`��>jÃZK��e��mV�N��BT�`����s�x���{���X��������&2x��*2�)�6�-�a��g����A!=� �l~�|�,f�i�A�)}�T�Ђ�����"�;�5����\^   �^�@���Q"�Q�3��	R��A�Jk&�R��cT�ń8��i��!��wF���6�q�\��"}n��s�5���/.�|=�Y#$��LW��2��N]��wwI��r�|n�S�sk�z�n1�Y��^�D����a��\����3�Ξ��ik�����_N�0s���[�K��y�Ї��r�}�y\1<��(G���&-�`�sȐ1�3�g������%1$ϘsJ���v�B!���_}���9hJ�Ϗ����Q��l      �      x�ܽKwǑ.:���TΌG>8��v��-�K�;�	D@o��HZ�#��ި�,�v=r�}���% _dT旑����څ�]�r��;�)g������7_�����_�r�����ۯ������x������w�_%�\G�a|�g��Ӈ���77W��>^�r���M����� _8z��9��C�������S�O�]��s�!�h���q����w�7W��|xw������F��r !~�������Oo�����J�����C��O_�w����q����߳�o���J~��C��8u�`��EI/��\ȉ�kK5����hm��dߥ̐|#H�,&�@�|� �́�~���b�f˄�]Ǒ����_�Lx�#�.�W/������O߿z��*G\���/(w9yVl	�8���LQI�!p0��t��Q���8Z`�%eCe��-p������vseL��bn�bp�_������n.�5�|c�����z�$�ma��e��(FXj
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
����l(��CZP�Z�ͰP�\4�|��!�<RW��s'7B�t�3	u38+�!u5�F�tKL�0N(�y�%:2���o���d� ��F�Q��D�.��gH�7�?~<\]�p�p��7�����&Dљ�>���,��^,�M���w4��{����i�E���?��n�������g���W���<�כ�964�[ɼ��������KHO�ՃN�v\3�������q� ����Z�4=ߍk8��k���%�A �H��Y�;2.��c�R>�j�6�u\�����0��Qo^�$a"�عOfO�]r��?��u�$Ǎ�	_s�������q�U�D���%��1�5K�Jbm�U���z�?���LF8�2NH�͎�H&�p ~���^��9?�9��㢉�Ɨ����s#M�NW�z��6_G�Ly���S�mֻ�����%��=���Bٲ�����7d�f�i��J_�z{w����4�l�	�P���/~���{�}�s��H]n�9lk���=	=E����U,�dzZ�'K_�"�|}�ӎ�tȂe ,6�	�4V�S͒Wj1��Bѓ�8|X]_�g �;��h��������W��][Tc#�TU�����؛�#ʊ�"2���Irͻ�b��S���9�nߘmy�N�ܑn�XBS�J<u��l�'o���E&�n1ێ��J[a)�kW��i�����#:�5�OJ�F�����n�u���љ������N�s�":)s0�_T:���`hB�s.�8�9M�o(X���a L��ڭ�T6_��5r�+W�D�E��i}�0�>-��?{��I�M|4S
6W��j��"��)\ۂ�BG�Wp+�������ؼ
"�pF�\1�ky��:�����"�5τ�"��	"� �jv��<���T���� 9R��T����i( r��3n!�G	���f��g��M�7Z8�(�^\Dn� 0ß?�bf��/��?B��ά�h�UJ:�:�]�t���":3Q�쬜�A9�eʣ�D�\G�DN�a}3� �[*,)w螞�Ԁ5�Җ)	s����m��廚Ӟc!n� K&f�ޘ�n�z�P���q bH?S�n6r���5�CTxuE����FWFUZ�C��K_�� �(���,�h����8B��>�g��9D���G��?��y�����d�+̄,������	ej�����!-����z�sr�t�|'�r=����A�z�[�z|��<�%��eK�]�C�#�>xifT�����L�k�C�m��CH:H�9���!<s�|�8�%j�_��d����Փ����'/<,�� b>�nNe�:��Eߎc�	��dv�}��������(���8~�aah&b��}�V�� �4QQ�`1���}�]�goʾ�k�p �Q�Y�@+���!@2
K��<U������.��X)��C���M.�����^���\L±d�\_������L�<˹r�S����U'�c>u�s}��l�H0�g���9���u���E�´����'�.:g�W7�(���8�R�����k���������޽�=޼���:]����E_v?�����"C��}��ea�4V�M�6ph��/��x3	,�l��K��:�x�    �|�lY� �W�{vu2K=�S��U3ME�1o��Xc��s���M\2 K�Io9OC���ם��p2����C��s.m�.��^�&Y�~����[�9���\Ъ�䊊�o^�vsw�@�i�:�z����������^}�fSr������O��C�8�TeB�p'#�VFs��ӕ[$�fi��-�����q��}\hn,���R3�l�K?�6��{�����qI������N?�,Wݸ�a��:����ͭ�tB��sR��q+c5�1���"�v	t)��X���m�5+!��Ů��B���{�Ef�"�8�P^M@��4��!��Ó;�c)�H%6"�n#hh>�	�mf�P�"�T<h�H:;���-���_9��a�B��=�[ݨPl��Z�ח�0MVU����qT��v��3�y�ń�S�����Ec�u���v�9�d��c�
�!C�^�H�,'/A�X&���Ǜ���O��3���+/5�dis��,�������^���Go 	O�r9c�,p���'���^B�>X�v�"���]ӊ�ޞ�8~T(=�d>�����j�g%p0�H�OͶ8*���HFє��^I"�"��^�(��7�>Ƃ�"��98|k0cn��pu��W�#7H��k��i|�G2�4&C�	^ܼ���_摜��3r��#b:��~��:�X�U�7�݆��j�z�P��V����@�@�/+�!��@ ���S���͘��"��O��?]���H�d��iJ�X(����ka�x�����=�i-��a�<���d�#��wfs�M��݃��DB~��H6�� ��N�8*���T@%��k3���XشK$�9��/��-ԛ�������m�q
ό.�w:R4!O0Jq�.tz��k��*sM�B7tZ�ZD�&R��Zy�@`{�6nI97
o���w��Z�� ) ��i�.uZ���%D�4�!�@��z��ek���q"�`�ax´%yEA�U-UT!I
���h�ȡPe�_Za6N�d؞����������յ��U�&�9d�+��j��F����|�:���������(W�[��j~�����^�#N3���������h~m ��2�$� !yݮ*���DnnL���?��������_o��ݽH �8�{OB�Qp�	�}_�����;.���ts�lߣ�Eb���8Dn�.�.�'��Y�7�}FD��'����w�u��Vy���R��"2q�lբ��E�0��Z(��N>��XKV�}S�z��X�@�����b�gĒ�E�65��O5{�Hr�i�t-��Z-�KAb��O�	�q�p��U2#��C31�ꭼ�ڳ�?���LV�q]
M�Q(����:M8R$��_/omW��v���%u��z�dY�܏�Tz�@��Ë?n������O�O�w׷����'��.pD��*d�=΅(�PFI�>�������!y�!E��>����!�u�|���	�I=�XCd�"���fH�r,4[|0ϻ����qD���ߥ�E�rH�V�ާM�W���*�I�x�M���̆�jS�D�bύ5M�Q���܊;sqQP��h9O��58(+��~��L���SUq�r�"��̮n
&�b�@��P,��`��P�a �>5�h^|������᯻�?n���Ɇ2��的���nn~���Q9"���ŒOt��:����s���/Y��v���i�sgZ�L�E�AШ$;��i5���ܿz�f3o��<��F��z�r zj�z#�TC��tU��J�O�;��x�\����?���`��*$�/�ߍ�kF�2#���8��ǀ��K��4�����t4�M���!ߔ���@�zX�tD��4A�§#H�� ���{���Ru14��'Sv$�7�dBArS$,��A���+��3�u��ѫ4�Xk����o���H��W�Ro�AA��['� ��(��~������W߿�?�E�K�V�s�*��C�z�@�x�1_<�&�����R2G���)�!�ġT�����5b�=�}�ꋠ2}욮
�[��H2]��´զ�g.�W��:!c��<(����I��g?*�a�'�#s
����+U��ɓ����6U�n��-s�հKZqp�!d�n��Dr�R4�u�Dc�&_?�`�N@��^8}]Ky{Ե%�]A��m��JkE�U�?�O1��1 ո�}J��?�|h�m��ur`��L<��pX$b�*�`$_�S{eW���j
�E�2�K��sH<K*vcr`���$c���o@���� ���H�=�_kS�����d>]�l��T!I/R����D����p�������B	��A0�0p�0"��7.;_��s�b.��t���H?&����]-�<3N��Q�*���3�J���o� �@L�w�r�Eu��+�%��D��������q$�!1'���VS�t/�g ,M�	CI���8��c�qV�bqs��H����E�o:�A��dX��"#�@$�` Qj�*���,fQ��b�e"0|yz���E�2��U�t4O�ӏ���OB�uJr�q��0����N=w<_�#U�Q�qǅ�S�
	h�*C�	e��
-2\��h3_��z�6��x�pn҄HqC��msD�@���W�Z�8@a4.!͡($��C�ޓ$2OW &G�~��S�(Y( ˡAS�9��ω'0��I����������vȱ�%�~�Y	�6�qT4gM�3�~ϡ�j����f~��ͳS�ҟ5�1��c������3M�����ɶ.}�)���Q�b�����mDk����k��Y��p�� ��G��lB�\�w���5  �����o˼�n�Y�<U0�.������Qe�!�+]�nZ��y���o���`Ĥ��۳R���T�!.*]$��!D,�AW�����k�g�h��0W�	�N�fc�V\���,)��p����g p�j�\�.�g^r8׫��Ҹ	��-�}�*𥶤�}]��<y[�,�t����W3�8����N=ot:��GC�:�u	74�uNU�Yv�T�ah)0�?��j�f�
ha�=��х8��Q`��q�͌���!�֜��c��FͰi�6������F�>�(��m9,J��xU�Y0��{�Û�w7�����{���������v~��޾V���sҧ��?��)G�[/i�o�>s{b�0�F{I�-z�ɵn粯si������y
�<a/��Y�[z��I�L\���O�ι��׭��b`4n���'�xN(:ǁ�LJ��ed86�6��	gЌ��Dis��N؀>.� 
B�SO�x|}�$�0.���H[�m��%���`c�x��\_���3�#�߀�q��i_솎�}��Vu�>�g�g�RQ)�@K�3pF�u#� �"���t�
��ÿ��P��Q6���1�}�U���Vh(���@C�>�%Ƚ�z�4��f5�k3Z3���)�������$�#2pX!
Ġy1�Cs�f4zG�x�2���F�]W"�b�Ysˆ㴃0=^�ڥ�-����K�n ��9İ�g�q��[.�ik���-�ngf����W%�b�?���O�����۳�fx��{}��J�w3�,�ʉ�/;6��=���lX��3�A�C޶�Kn��]����@�)���o�E�WҁK�X����VK��*0��@��XT���:��L�ǌ/��z���%�����ɵŒ}$�X�x�o�F*eӭ�k\|�� #�{���_~�}�=ާ�8��Q�F+s(3�M�����O?����CAWs֞�9�����茖�kr&Y�\��o�~�*%ˡ`ߵ�mdʦ����x��Z�:ŐzW��0z�n�F������'l,�m�Q������?�|�U����3�G��Y^��B���d�y��n���iw*3�m��߿�z���o�Ri�ix�u���Xͦb�Լǎ.��Ӆ��Tx�©58}N�����of,    ���X�.�Mw63��ށ���HD���m����������f��|xh��H6���D��ئ���)���M	��q����k�C�J��� e�e�yǭ�j���S��{����f��ӕ>#���;�ܱ/�7<ft�޾��D>�q守����t�7�^�T[���Ƈ��x�4��>�M���	rബ�Eu��	
R
_�����0T
�6�����)����M��gv��ht�L�ڎ10��]�,}��K?��@}�ly�}�᩹�3׿��1�S���m�L2=��y��������۳��������٥ �LI<'�$�Z����2ȸ�.D'qe���&�΅~7�N	�&q�>�|�F[4�(�K4<�b�����dB�@bm�ު"�с�}M�d�Y���e>J������pW��H E�]W��*��4դ�"��J\�#���4,HȵT%I�.����q�${�4j,�,h���B_70�����23	D<�3w��0Qh�Cf �W�t!��L�7>dVVT��bf�2jSJz�mp�y���\z�=q_$eg�W�W	>3E��+@_��3��i�p�&�J���)��R���g�
gB�h489���yl��)�݆陓Q�!f�/��C���7�J�̀!��q������u[W)��pF�G��w�ӷdv����o�pIk�E�%V�J2
V���E"!�"N[�0�z.��'&�Y��Gwxn��D��k�n����
w�zZ�i�v�P��UY�b;e39�1�j7<�5�'�T�����g�B�Xq�  q��2;� xF\�EDD��_�ؓC�4��Jax!3��ȱ���(
��*�~�ѓ�i�<2��+����
�P��9�\|�=<���f���o�o�~k/�j���G�~��5��!O\-�Ve�@�L:��'/�>��0xIa~U��9�Agz�Rm�V=ۙ�iwi��L�[�%ח���vX��.jC2�H��tV �2���L� uf� {ͼ��Ȭ1�@�&��(|��X�Й�,-Ձ��r	Jf���ջȠ����<\��~Q:�M�mff���2�U��gMf�RJc��)Qڒ�aze���d�/P���Y^��2��x���77�Z���g�F�ȁl~�V{yM�)a�[D_���r)��,|sJt�M����p���R�4������:j�[��IDO�<d0�r!>-�a����qs����J�q���3��q[��P���^��3��3��&��q �E�Ys��9��\�:Ϻ�?K7�y��_��{K].^W1�G���u=OY��m�oS�{���v���!��w�L��|�g���f�qo��FŊܶ��
�CMf���}����ONGd����]pP�7=k÷�~l��h׳6��jἫ	df�,^j_� 3C����~���d'ߛ�{��5c�l�]�cΌ`��Vt�3�dC�y�hf��&wU}D3s��IWԋ9#h0�� �q�3~��*��`+���@¬�_1��t!�H�[��&�<0��)��6�C�y�z1g��{{d���+�h,=3����j�2�t3ذ��6�'@��z���$�Z�̨l�B�`�V�7� Z���zHz%�Ă��� }�J�wV�������t�l��7�	�����"�L�����)q[ �r�~�"�	"a������
��j��.J�d@�/RHݹ6k�Qfߩ��(������"$��(�)�I�2��ש�ɸ�P�o�����U!}�+z��D�=XԽ���xc��Z��ɸDHw���-,����xq2e�����&�,$���T��Ld4
 T�Y��� �W��˟�)$�8,�]�����a0fL�N�(��1$$ƋP.��� ·������.u9�"���(�Jp�Ur�p�ǳ�C[��e\�il��@3�ZHߒL��у+TF� 4e�C7O��:d�ʙ��V�B9�4ae�3S�#�e�WfFf��!T�C.��(F��� pR�r��Q�u!�(|�s�ރ�r�F_����y3"�K<J1���s��HɧR>L��V��Y�#^|ܽ����o�v��[�s����T��b�,�Wg36�)�k����������������#�¼����Mރ���9AʌPjK]��R�5�&۠s�j9��}qVL�L�;�Q-!r֔��}xn��R��v8�K+_F�f�p�c����,"B.sa�\5ʨH�9a��X�\<�p�����������;ʇƍ����ϛ݇��Z���ËM!� tf*^Yd�+K:*�u-�Jg�""�2+~nܚ�wBG��ՙ�i��.0��tf�h:�nIc
��M2���è���l�wq�Rin|T[�Q�Qinz��K^���͍�"�#�Ǵ�R=9YMВ���l$-B��ތAinrp�QB$Ui�y��!��T>��߿y�fK6��&�L���VnYl�,�7X��On	��?I �No&��w]7	:��쵤�M����/���̈ ���BcF�2�� "~��9�&3'Dʯ/�T��Q�rz�T63?��WS)�lft�Z	3H�p��1"�l�Y��K��$�����`3�����VoZmf�B3��3�m�\���Db�f�9����R���a4߾�뼲��i��Z�h.v�����p�2{B��L�¡*p��%X���Dw
���4�Y�,���&7}���L�+����V��V�i�9�5�����g��AS����� �m���� ��RZnFZ���7>�����(��H�9�ٚ^�K�]f��[�4����Y4�>�P|>�r�E��ʄ-|5�H.�^�s�ۦ������R
|�Xw(3�G�X�]���ef��w�12F��j�/@5�Cq��#�Y}c�x�7v=]fO�n(^bɤ�L
`����8|fR浢𣷼�>3*ĭ���ō�ό���k%�?;K�̴x/�%��l��� #/�!A�� y�7���>�E�f/pfز��I>��ۏϬQ ��՞��
z���!ϩ��"�+�&�밺�	�x�\`���Ƀ�����on�?��������7�_�>"̗���g"�uG��&ݨ�݇���_>,�9z[�Ѐ�~��~"�ln���uX/'���5��R&���a3{0ZwyAb��0}K�i�;�+ߤ�+p���UtЧ�۴�=p�h&Rb��||���%
	��1kҴS}<?��ı��ڊ@FnNMÛ�LM 3;�1�LM�3��q��.����M�N�X>3��Q�yuy&%f&E�=��3J1�F�0�w+��ݽ��І�����_Yټ�;9MV�e��n��-fv� m�>J�mf�(���7[�̄Y�}�l�֌��[�ՙ��}z�q�jk<�ef���|�VI�u���,r('��Y��f��;�r����V�e�����TE;}�ˠ��	��WѴ�CG�y=:#60h��w��?�-"I��w�57������3%�U��ػ����51Is�ݝl����t�q�w�SfuƟ�����Y��Ng4
�B� ���]�1/�H�r|�Ȗ�+#d�����c�5ի�ӡ�/������k���B'#}hЪ�{Q=h���������̀�Ä�X'l.��Ϩ&𣢐�7��ƹ}:c��y�8��ذ��7]댚�9�<Oӵ�X)px����tF,��A@��SUӵΘ#ld�x�.A�GX���m�z���K���NUc2Mg<8f.y{�ؓU�{��;���ι�v�wv��_�����|F\a=��ǹ��xf�"�m�M�$E�{�`$G��hU�"����lj���,� �M���R9���?Ȍ����"HG5�I%�3���(8��q��9����ˠ;a������.��uFH��6�вt��%�մ��<�'0�`e��X#nRp�U	7c� zT�^��\��8Y�t3;`��̦<�?-&J��T��a�G�:E���~�cvuh3#c�yզN��Y���-��nf�,��B�`3�f1���FU����D��C�s�(�����y 3�DR]�gt	��B����,�I?Y���/    \������2X5U�=�C)�p��$�PM��:C����b�z�h��:CFQ�pC�P��bNױ�Ð�]$���:CFs�p���̨�&�i%2����*�fF�G_�Y�̨���:�fF�*��Y5@>{���e��f��:-tƴ�pA���*�f&ϡ�V�΃��o�TYh�����lOOr����x����}ݜ~�&?qf���%;��g�8U4y߱Wַ�|p��%:�4��jًޤ��IUe�@e��u;h�?���3F�xl���7�L3v���B�<<�̤=� �Ζ06Z Ŏ�Ж0^���E�o�IJJeQ+D�!�Ic�U�m��c�H�Mn�閜l��H9��02���t��p�y�pN6(��!�4�/����ܳOP
?���O���};�E|B�`Q�.�"�G
� �>֌����0r��)�.��d�?+B	Kpp�p���D��-��ME*n��Sɭ"2��g/��Q�
KI�m��	�L6��{"���n&���Rt�g�+��O��R;���zvu���%r{�0Xd�釔��s
�1I�M����F�"3ˍ�N{,��	o��<ITS]f#�UL�S�ڲ�ng\w����1}�Se)D#3[� ��Y�cdf�B�e_�����k(`m�o�Ff�U���$���h��o�طh�Q�5�u��3���]�(nԌ�
��.�(n.Ug��Q��!�t�L��Fq��Z�ש��p�b"Fd���ٽ{���Ok-�#��v,��^���.dVÆ����Fq�d�N'���W>�Ȼ��w7fҙ�%u<��ۣ�����uV�ŭOC�����9�	�7|�2[BS��� k��t�Ӎ�ά
P��<������JP�"	�y��~�M:�pP#��0�vnt����I�^�mbH�ix��֗�^�zs5�Qq�h�A�)o�M2&<��O��u\��vy�iw�A�m+���,14:S��5���t5�1�)0:3 S��u�l64@:��[�}�FsM��fp���W���-M���.0�c�]@:6���ǀv�C�[�#�ci0�4X"���C�6!A���7h�4,��p���ZRH��>oP�bW���d���L��po=�G�{��D�cܔ��\�7ȭ��w�6r����(��	��V}�,��`TU����8j��	�ZG|6S��H��.��Lg7�KO�V�ild/K&��4��f�<�cl����ID� /��L��n4�m�G:��XE�A��ù�:���) ࠡv��%�ԣ�t��m�C231'�o��ހI�)�Pb�R����k��^D�z=���K�����ۛ�w�7���.�:���9�u)��h�V�H�Ơmj�[ $+�2����FhF�Υќ1�rW�M���n
p����i}�v��=��\���r�OMOq+�������y��ݣ0���Y�7{���w�7tH��t���s0D@������[�0ی�����gڬ�		�)"�3��K���ނ��c
�_}���[���*����$�eh��|��ʹGuXhq�^��M�����S*߄��ԝ��09���>���Yo��`Щ鷻#�����?�C��XB��j�cX����!bj^�p�����
��L�����F�=��q������ȏi�ʍ�
:9�#��8������E�,]s}�K9����Q��
OH��<P�M�>Q����3X���:�#ufa�Xǿ@����X�a��$�8��>�ws'�����˄������ �t����Jc��8�N��c+K3��AA��8�ˣ��{	��~l�K"Vm�n�D�%t�g^���e��:��2�"�m�����čJ$��(lEj	~T6~u����������t�c>�)�Y�b��Ż��{����px�NG�v[���]�e.:��>�=�Q��ò:���tl�q�O��Ľ�E�������'�9N����$�?8�����8��K�?�^Ս �Æ��`����e��M��Vۋ4���z(s���Mv<�� ��]��,��>;Z��>b�������Ǘ7���������������S�����,����7�R�2Ä_�-�U�?O�����:��J���%�XF9=�i�k�-�;���b�a�]f>ӁtE�z���_h+n�S=�aAx�к��x��O�� H�q��'�a�d<��In@����3T���������·��1� �vZ�8�`�컢��7@�c\p�س����0�1E��R��J�@T�B��[������c�]��k��}�����S������%!p�������.Gh����[=�h������\kcc[hX�j��u�A�.���,*����,�j r#`z,>�z r� % �0��[|�NΛ�Gs�̶`!� WBn[�5!�k��p�b5��t�qI�	WDn\��"+:�ܸX�������`n�)jn\l��.�|�N�T��ܸX�J{��ȍK�;�+bf\"Ml��(r���F�T5�q�����h͍"����in\p�pLg�V�p�3�p�I=g�p��@����g�qJl_O�j�q�W�ntE͍DꋕA��%A|�a߸x��W��SD�C���z�h8D�\3����DQ���G�Vr���]WQ�Q��K��I�8[�Z��AT4�+���h9D��`��s�-���+��ܺ4��ZU$En]0����w�U�+#��r�a�7?}d��@$�Z�s����@IƊ r� Zl@�!����hS�S
�>`��JV���>�lb�)(:7DP�j�ngd���
lF�!Up���ZQX� ��X��'v�	��\W�8}{0"���P�FG����~&�H��	���v�C��ڊb	�9DC�>���� hV��6� *�/�P��J!�h�04�o?h2S���j#7���q��8��h��)Hq|�~6
�F�.��t�c 
x�"J�5��2���Ǟ�g�|�x�� +¾��=D��Y�9���j	����19�.��_�/�a�d��s���d{a B#)b�x7�4e�4��!��4ګ��ӦM/'��dSq�D��M,�򑃠�L�y��tR+x�5K�����h�/;���d�x�m�/�����iee��d��[�l��� �@�@GҜa�D�9�&�
H'�UOѭ���wP|��!Y�Ͻ�fn��>@�������N���^��n߉t���g�t{7��n��z̐FK�8���&&�4a;��-vl���8*��:���_�3�ro#7
���s��50&c<:��Fn+T�V %n��Y9������.pǑ�����F�9�4!+����D4]aX�Ac�$�9G�g�C�C@�q�|
�������D��y[���h������{��`�lb���Ec�
�K�ԣX
��O�m�ރGA�e.Ų�nGt� g�|�݊���6i�v#}��93�� �!��+���4���-�v{�1uu`��@�YV�x|�j��t�G=��`�{���ʐ�]K21�A�׺A⑁u�<�@4\%52P�{�|��PL�H�6H�!��Pl�Q����:c�TC�,��"����t�xj��);[���#��i�^ƶ�XHݎ�
V��3��a��=��P+]�F��t7�0I�`#d�Ub�U�vO�髚d������Iw��N���?v�~��
����gE���e������_�g9�Y�vƵ�//��<�,�4���T��-V�*�H�)��7���M��bŇ_�L5���v66Z2(M�rl0Sn�ɚ��V9tʹ���k[�5�#79�t^dT�C�zĮUTi�A���b\8 p��w	&��q��sQ���9��k���7w#A�����ׯ��EM.J���PQ
hnH�+o�������o��}w�p��RD��i6u�G�.J����P�n)��B���m�Q4�7$+@���'���Aq���6}�{����C�Sm��6�z�ӽ?�d��64.O����2��J�X    �w��f[Sb�BN��P�3nW���"�s��
�8�?;�S)����r�mh����D��q��������϶�j�j�m�b�M��2��5U=g���+j� cvuS1q%݌���텽k�5(��w�7��g���K�P٧[�|�婏U�N0"�T��i�׳�6��v��51���o|�:U�t@P��^	;-�pM���M˞N;��-�$���=!�i�m�D��F��@l���}H{HCx�uq �i**�v����C
	�Y6A{�8�Btf�QT�] �(��o�'s( "���!��S
��4��}([��9
T�ٛ�o�~�*Ӵ��Vj�p�W؇�e�!8ˑ���~nWQ� ��0�C�����u�ۖ�����?t��.p���tKl;����՛��~�H"GX��@��X�́����H.�wE�ǁE:m�cSQ�uB�38�+V��0Ml*�V���:F�"�s����Fɑl*��R%��h*9{��jqx�DQ��9�M�rI�ES��|�@��Dy�C��0��1��Gkp�~���ޔ�0Aq4�hJg�l*́X,���?�����D09��N�rAM�
�m[7������I�E��x�u�u�����5C���CA�*�����շCA���a�԰�\}[G�f��ֲ��z< )��)��4ʍ*Ǧe�?l�5�Vm�'�>�&Go@�y�`�<��0�ZQ+�g��"��ǳ�CE��h��K9�����W�?&���������p�Vii���+��Ut��S {���ځA��Z�t-���!�"�3�la���9xd첓��C"��n��6;�9��)��T���#���c]�5�:'�u�hQ�!��$�&��2"N2PCC��}s��0� ��Tf�$=æh���g��N&�������}���ؑqI�����$�/n�" ~w7�~K�6�R9x�N܊�c�\�)�aPEW�'g��Ná`%���e�Xҽ������~!����F
��c�(���`XzwT�\���/��I���]�	��M��[��K�`6�`Ʒ����>���m��L%�r��(�������L:�����'��*��l#,�U�9��afH�i	(&�슮c4t�e���RU���8:b�u��,Gp�^�@��v2[0�j����:�,&�1+9�UX>a'�'�� �p���+���J�*��1t���$��Ƴ������WO�A��z��� ,��k�R����7���s��ts�h'�Rd��9��G��q�3oGbP�y�G�Z�M�x\�ˡ6� �Ӆ5��x�s"D�<~��qpą��I��Q��K_��X����p��-�����^����������r��� b��V�+e�1@��܌X"��KHK'=;�'&=-�C�*�?J�����8�U�����44��OG�c�X���U�rC��+�q��J?��-��+m�����7[��./��i�� |���+����/TX���qx�0b�Aa�b�ʥ� ɐ a����MM�i�=EP9�W1��F�� (��ʞj09ԥ�lA65���
�ȝ�J��� 9<Kɥ����������nK�q���/��izkDĕ:6�F"��"�jw���C{����;�+�Pe=��E{�����kͭ�B�i\���u�YFS��V$��S���"���
�Y�8�趾,.��?�~N�Ӹ.���B>k��\���:w j>ЙI�uǈ*����t�[سH�a��/f^|�"Gb�.L�l��d�m�n\_r}O�c��DM������n�yIC|iZl:h' ��"i�=( P��d�@�(��f`�3�'�'#�w��	5�6�<˒Wjਉ�I�g��@�j$'F6��P'���ZԾ����^.|l�<�Yt��B���~��x.�ۉ��nL�`�-�{���T�`U��(]#X��"W���m�s,�_C^G0�*��Q[�:6,�+(æb�xKr�l>a-�5����ґ�l���Y���� u��G��`�,�	���%0i捁p;��������_��ȭ�ir~~�C��3��?b�A��S�Mcq	����^J�e4f2J�������t�6��u��m��W����uHl�E�*7�u��8F%���z������P��Tݖ���O��@R��#��=�QaI�$�#+(<�ݮ�\����{H��Q9�d.d֡7M)�3W��!�3X4Â������
K4�4�BgGnUp�,g�DS\Ω�~�VV�^rU��Ҍ5h�P��%��b7�1Ü+��uFN/�)��f�*�k��}���+�����;O��&��E��i08	I|�;�h�q�$:[
�� 6l���q.|Ħ�rB�����s����F4�eu%����m���(�t׾�����wC���ߵ�+u9�����O1��l�������W���9���q��Tc~�d�kſ��(��p�fX��X	��/R�����t�yms��E�}c���ài���l$^;���%�� 6�=O�CF��l$^���jH�hn^�AH���U����%�z��a���r��0�(��ۀxkt�718�8����U;nAp^�1r_��͇d�^>ݿ|�v�����uZ���?����~z�=����[�_M�с�7,X�"����~��$1�AR��3.��{Y��W��8�v��Fe��r,�3]�uu��P���Y$2�8=�Sӏ~�%E�2��y+9
!B	
���d�e��F�vU�V��1���KL�� <�ΑF���јyL�Y��d�r{��V�!.�M���L�%�	%S0�ow"�Bj�3��@���쎒��>%�{QD0���Dr�b�d��jrPί�A1p�bg�,�R8�IGO;zWԊcֿ<L?�ݞe��]���e�A�.S���_����dp�mDn`hd*�X[r�����._��v�{�98ꃶ�<Ko&p0���\;���8.r2�[V؄��o�7���ϋ�<�1��h��fp?�k��,�$a���$O���|��6�h̶�3`Q9��'����(��X�7�q]����ض<Hݓ2�j��Νv\��H�m&;���#KoW�H놴E��mq\��!}���+Wj^B3�$~����{�����c��ҪYB���m}�?��������S]ǐt���Ԋ/Ò�q+���V�KJ���n?��e�8���14��{���X����-�c�)$&(�a�K�u��r���B20qD���Э�`����B��o(` l�^�6g����21��C&��
�W�1�64�O7��W��oo_��4��	�mD9؏�n�:"0$&b#��E/Hd �����ݟ��v�';Xghk|�ϷfK�9*%l�i����ꛫ73�� �9���7q���
p����u	:__{�Xv]�`8
�d �/.^�+�覯=w�6�vpDӪ� ��v�qT_e�v#�����9������t[�?B�q�t��9���R2&�P�%_����������y}��y���x{���W�̴��k���\^���"W������q/�~��{��x�t���˧�<�W���GA���u��Xz�[�|�����/S���9���i�[p�"��X>�?�p?��V�s��i�7+<�$��%�*\��jɉ�o!W暜�C���MQhU�i����~1��+��	+8��k��B �⅌P�"Ⱦ�o��B����A��v2�~���ߴa�8���\��>��]ܽ���~��������Y��2��Ur^�t㨶p@࠿n��T�/H��h�3����w,{.<!�c#ٗ�7>�������N���_�v�0�u����a�s�*"���$hQez�c*�εR������Gp�����ݿvw���}|��~{���I���B��W�}�c����+�s`���_���*��p��Ԓ꜖��X2�H�GP}�l�)�P�n���SμR
8$�.Ē,�8��$MP�!��*���r"�!<�1�c ��    \��<H��|y�.j&.��@��O�/}m�' -���f���^g��	�8�O_�3ZY8�áF��>���&�����ڴ�Y͵���C]E��Y�9!iA#�7����j�.��^���S���m3��-�b@�l�8�g6�s$4�.(-������#aI���*�#a�(��Z��s�i��C��\# +i�tr����l=1d4<��P�uq>���ۺ��HՍ�l�L�p����C�eB�k<]��������;���A��9���:6�ۦ�Gd�'����x�B;l�R���[��U��Ӡ&���_����ų�4���U��q��ɫ����3PuNM�/ηT[���dZ�_Vq8�@�=��՛}1ǘ�iNl�<NN�]D�Α�k��#jzH�
e�g�b8�iJ�A�X�]���7o��86
�6I�+mH��P 
�)ϡ�d(ψT�?�y�&]�9�Խ6���H�s��%2	�t�tax�(�9)ų���c���~܇��.ژ�I����񱀫\c0����K��'L��d�b'ݘ��=�I- W�8Y��+�0pl�B���N?�Se�9����%bN��-p��C�T�� \�e�dX6�k�y��J#�
���=��J�faZN�L#.�)��4�7s�����N2��otҴg4�N娐����X���Ns@��1����?�>==�St��{����v�j+ߕ�����������"��oث��́2�;ˡ`�x���� ���vK��w��r}sߩ��X.�b�mYWqp|��a�bу��s����ǫ(��q�GX[�4U�x����+�|K�:NޯJ{�{�Bb�VW�s�l�K"��QH�W��X"j>qElx9Pg��V᳂\Ѹ�@$\�f�˹	6�W�	���+[_��s}��:8��Y���@Es�럯�E���ҿn(gK68����D�Y�n��$��Q$O��N�['T�h"p�lr�ٖS��n�Ur��[�����S�	�-X�`�;2?���I_�����G�M�4�JZ.9�3Te Ȣ�c���^���{�ǂscV�T�����{(�V	6�`1X���+J����F^tt����R�2ǀ9$�Q�wc�� ��6��b���'ݐ��ڪ;5�o"A%����-G�پ��C�8O*� ��9�]I!:�Za�!n�#��c��<�{�%�q��&�'m��%F�Ps����G)9X��r)���k��0�O�լw-J� MT4qA��s4�q�E�����Y��"g �
��}� �9X�H�a��!@]��G��H�Bp|}����|�W�(=�B�2�dP6|��20�aa��5`m MZ ��VM�Py��Xo@j�۷o&Vh�^�8�(ݍ�H����dp�N�o�����嚣RH���}���D4�Jh��^p<��1���)�q �+���S��M�}��矯��VEЮ�N���#	�����x>�`��z	����ƣ1���b\8�� ׌� t��i�ȧ$E��f:�
�j�b�Xc+�pN��'��l�I/�u��
�N䐟��`=����>����Dz>�r�$VñҐ1�f���8Gb��o�����f�OW���=Ԙ	(�U5��U�E�8�H\�-����߼���l�4�:T��@p���-��86ޝ���
��Ǻ@6=�\�'�>wj4\�Ք�-��\&�u3Vȫi�օ�R���ȃ�m�MM�á���p��h����l��\Q'
�Ǟn,ΌM��b#){���N8P��9�����+h��&��d:����	,�\�@�F�������Xܝ0�'�2+9b&����W=t\v��m"�l}�U}�9g�"�k^SK�t�"��^c�T�J�[�&�PUX�`��*�:�^����B�ܺi��i�c}`�uK��z�������=^�-7m���0/��iFѠ�Y��p��.���v�JnfR�j�~�:�`���5����L����?gˍ���t��
NN���lNUuyZ���4���N�r#ci��!��Ko�n:K~A��[%�������+����J�f,`�+V�T6�`��Q)k>�_�2��k��u8n��fU���V�uOV�-Px�����:n�@��#I�3I�,04��=Pύ���Pe*�sc�:��7)	�+��4 T	�+�ڦ���ʍU���k4V>3V4i*N�:*	�o���0v�d˕Hyϰ*����(��a�(Z�`�|[�����qNq��D24ҥ�jHF�u������dy��ڣ35_�oH�� -uf�a�?*�N.0(�>P�������Y �&�d�j����1鿅s\��xF=E�������%�-1��Z�UCh� u�hO�b�Y$nz_Rk�����-�*1_g�� P�p���n�)b���>�͘�e%a�+{vԅS�̒֨�8�H���ԛ�H�l}���܋�#Ş�T�IL]ѽ���͗2���8��C�YȘ~��?t�B��Iv{t�K�;p� �׷������Ts	|���8.iI�A�i7c9�uK��P��N�C�c֕q�6FaV����=&���~�.�2^(����)�C��	" �B/us��ps@v�k�,us�l�ns-��D��I��Φ'��a�^�_����	�@v�p�
Yr�2�%�������r(�s�k�-�QZ������f����A ���%���U�'/x�C����"HZ?��c{�]BH�V�(��y�*cf����o,��z]P�*�R���g���z�dv</�%��z�8|��P.��s�����?�W������!i�q�1�F�s�A�t+c��1�Hs!.�����RI�h�M�%b����R���Yz��O[����ibʪH*E�f3B$�<'��ӣ�6�S

K��+!���E�}bI���`c
2D���Y�g`1i��O��ǧˆ�L�4�������+N}�����l�ؔ����h��KAɁ8�.�ޝ�(/����=�	��8�9�l8���b0�꼀X������3fM7��} ���~	�<���Ի�����O����ߴ���ST=�Q"as96�GI^���y���\S|�9?���a�g '�r�b9VG�ɶ\QH�����RT�*̮۞��wu�U8`�����  ;�(�N�Y��j��F7������/��z��9�=1P�r��,C����=k,���Z���,r�)��v�3X�b1}��}?�}���Ƀ���| ���YV ��P �}l;�,��c�T���q�ӑ�62$�(!��+)H (4�VN��u3�/@��Uf��b�lͯ�KH4G��	�`���t��Y��Rjl�Q8A T:r�tr�\"˱h�ղ�-���+�� �`���u�	�c L�Ba
]?�<�@����q��xQ�9M��<i�Nwk�
^���r���^8��2�^�� ;ݨ�R��t\S�0�� �w�*�1�e ����:[���*6`"*�X;�p}���*6�x�w^�ѱ���#�6�(�P��]"�0��
#�9�[���g��Yӥ��/d��U%��ωW��M5	�f ��FzMur3�j3�/�䯾�����7/���{�}��z��䠄��n��E���'��@��̤�~��ơ�7wO7�no?-|0��?z��8$մ4���U� bb�-Q�r�Qɶ�M�f)�����VJj)�(���m+L
��.��}`�k�fe�t���T|@$*�`ԋ��}||��z3�ZHH�����S1x2��8n�KAY��0D�
^�ߋ/wv��i�9�U>�/��W��/Ra؋W%śrIG�:iB/ܒ��i�D�3m�b�p:��г؀ <�əv��k��rhV܃0+��*r��y�L�zhUl@8�v�w�re�.����A�P��Ч�D��e�LȡQ񰾣 �E�~�R`BE��ċ����h"�T��=�}�4kZ�,S�fľ��$˄ �  �r,��+�Q\�����kw��0Os%5Kr����u��}��ׯ�q��j欇��:�8�Ti�(�
�ۣgX�e�aY>u���%x�*�-�s�l}���y&���0 u��ƙ$*���A�_�ӷJ�CA�@��]N��@ �����iO�O�[-�CA�_����T �QD�C�ǵ�W?N�׋�+c,�"��K(����Y��#Z�l�����J�8��.2$���kR�PѶ�_��?�W��E��^jTN�������=�Ar�+#�R1�M'dǦ���4A��Psz�W�6�A����ɦ2�*5� ���oR(v�}�p�j��G���M��Uj����pu��b��TKDd�����dSqp��@$G��F����W�!�JCsm�C���#�Ȗ��\�Z�Z�g
y����ޔ�/��ӄ�C�@��X�V�C����l��4׫X��r~�ו�+Vl ����E�c �&�S_ �t_�j�݀��	g$���rF6d�K+oU�b����(s,�ӿ=#9��uH >���QĚ�)��`�T�@|	���+X�g<�(cz(�!�ܷ��X�����
����/���g$� ��B�2t��%@�K�q$��N�ySƳ��_"�D�S���qM;��*?/.;����ұ�t3�2��,
���~���O�8����?�o��tOqo0��/���=��/�2��q>�m��I'��y�nKdfUo�fbR����:�i�f%�"��W_�0��{��_�Q/�q�q�e��l��e����W?����s=�1TY7�0�μ�pa�[8Ҥ��o�k�/�L���o6�a`q�ĭ���#:Z��|]��"�׶�=%��Z�� ����/�����z;-��"�8l�/�%��.m�҆��^0g|�����c�W>�胁/MO�敕-Z��=>���-e�٪Vc��5�{B���_�#O����j�8k��Wv��{����[�d��S��&�P�}�Ek�M.[�����v�/�Q�NȤ�E�B�.g왥�u�ܼ�����寻tw���������ӳ~�͟��p}�@����,_���/���_>���T�9�����Zh�-�,5%H�X��"���m���Z�)��j�����\�h�B������;�S�ܝ!Bܰ��_�c�ҶU�[i^ز��H�,6�� ٺ�`)���Z�������V�7�kKԓ��}�dY~��eͶ��[���S$�o�A&W�MWt!�+�(��>��-_m�&N]�<�}*᧛�?���yx���W��=�a}ت&J�Fk���<hGC�Ay�R�α �z�}(����ǎe��a4�<;Ϡ�aW4nM��.���	�٩0�&��S�Ĉ�ם�k�ibB��9vJ��)6H�������&YK��qpQ�'Y&���s��6b
y�UM_�+d�œ�ΡᴴM3�7�E�=��
F���7���A��o�/��*�Ϳ8I�	��Ա�|ݭ=����N����;[ܭ1߯����y�� ��s�E�4^0E�84�%N�/\*��;����:�=t�ɤ��������W�r蔞�m�T5t`Л^�ֈT�1膨����>Z�]{���j����p���J��jbsg$r��y	7SK�c�:7�Va`av?�toAsˇ����7�4�[�T�k7��W������C�      �   �  x����n7���O�=�r/��@�"@�"��C����3�J&7�q$�Z�w�3s��p{�~zf\,�������}�|���K�#���u�ǹT�A����>Om$JY�B{ ���DW���G�&��N���OsY-�ZT�EθF#�����۷��#�㵕}5-D!ʋ_x<�<y�?��ߣ�"��V�U��&!6e$֟"Z[E
s��[	����������梹���uG1�7#�G`6|��_���@Օ���x��_~�8{�*�F9g�<���F8^@�}�;>����an���_
?��)?}�ة70cپ����t��H��
~�t��>!e����J��`�Y�3������d�vΥ���Cs:OL�1�M��}bȍJU���)�g&�cf��I�ub���0�2.�K4����\\���\]Y���h�PԢ��P�aq1R�&�����5�m���n��#V~�d&V�"i�BLUh�*�Mp�`J۷�`�E,]�<;���vG�Ɋ��b֌��j��
��.��oa��a{+ڑƺ�0o��d1�%�H�3�b�^\��o�#֖��f���ױ�q���Ahr���o��v`Y�uQ�k�2�3�A�(�,�H���Q����f`��(p��j�Y��-��i��\��>s�&���U��!m��	[g�=��i¼�V�XX�JR�D����9T+os�Qkdmc¶+��X�W�ö	�g,?���9�:��
H[�xm�����9V�y6���F3�M��?�eYԼ�ٯ3��S���c;,۷M��K3@y�jB��h(ݤZ ��R�W�)h%��j��+�$��/"7Y�Z��}�H�q����/��.l9Հ���*�a�w��6�k�?��y�D޷>�@AbU��`��|��������aH3�k׸�	ٸ-���`C�3V�Ou�������嚈�W4��i�l&�8�̌d�D�؞"1�ȏ"
������8=�y�/"m�A�= �:�=�A���`�Y#v-���v
��w)`�s+G �YB&���DZʮ��"�+9HX2�m'1��	�C����������Ecr�)!�u�,�O�V�c�y�1���~���J8�q����O2j����h8,X�%�����']�R�m�ǩ�ָ?��Na޸�4���v �ޫ������+UL�ĩG�~�8k��������Ñ�v5������.��o�r�>��kW��6���o_�����r�k#      �   �  x���Mo�@�����,,�ZcS���{ٶF��6ӿ_4;����d>ޙ@(!�Q ������RJfO�Z��"19��Kx̎�XV|�S���|7I�m�H���c��T�NC�[`��b��W8��`�oڇ��4���-�Yc���@�pz�4��P����g���C"cW��v��tg,�r�F9��0.'DN������|���eU�N����kM��r[�<��2�77�����t�Ҟ�DG�5)70ޮ�H8��S��[3@����<�#X���6���i��P�f9u;wS���9����#��v}!������[�a��X����h6�";}�X(�M�qb����C�����a��Ƕ�Xdu���Pll�3����P,���B"��P:1M0ఔ��b�?�����Z]~�S,�dI���Xm�;^D�קH}1���>vQ�����W��)���<���j]      �      x��\�r9�}��
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
>����&��yϖ��HJ�H��F0A7��.�h�f�pH3uv�H�ͦ��I�F�)0�l*�*x)�^P��6�J�k���Cv���?n蠥��@ߕ�Z[���	t�Җ���S);��m2D�hST>bS���x^��8tiIi�l��Q�+/勹���(հO���W�y�Nl�,:�X�\��ST��o�G��b��!�>�*��JF���f6�&*h��Q�Z���:��J맿M���y9J'      �   �  x���[o�:ǟ�O�/ pyd��n�4T��<U�\0!7H M��ӟ�%ĹР�2
������O�E,�`D��rl��֫�KZ���U%¾�@��}ö&�eY�e�p4�����,{�֬��ӷw��e�P<���C�
�#���M\_���V�[��b�� ���6���#:r� �0�d�P�R6۱�$�&.�L���EjtbO��*�w��c˗w%�:ٰ8�$m��[Q;�e#y�^����\���i1�3 ��<�.�iS]瞍u/����I"��=E(��nx6ƽtR���T���+�.�`i�?�F~`��s��(���G��k�L"*��B�¢��=6���������{�`�sS��=�S���r1����XW���m���~��mv��,��O%�~f�⽙�G3�>Ӣ���9(��yG ��sx��v
bg��E>�N��ۢ��,K7��넺�%g�?�9g�耆m���.��.=َ݆+ȧ	ߪ���a׏���P'\W�z�]�[��kլ�L"��3OO����x����"�m��Ü�ʣ�"J��
�� �B�N,�%�.��	U��}���*��o���`�Ƨ^*��(� GZ�0=j�L�*3/�Ģ1;Ye�G�ɯJ�_LEˋ�q���-��"
/�R�����9}��`���Z�S���N��NPL腎��4�ټ��0�>P�B+_Ʌ���O
�|$�u�` �CǾ$�{D*l�CA�&��y���GQ�KV�t�P�h6(����]6໖Z*�����k|;n��zR֦ݛ ֵ���I�[ ��K��Qqy,��(���۲;	@m(z�u��&҇�U.�P/Ŭ���}� ���}��y5�xX�N�dq�ck̶o� i��:��$L\��}��ix�-�&l�	!Y3�@ϫ+��%.g�!�A�x\u�k����n�����.��A�!�t�Oۊr��'M���N�~/Wp��=�v�@�s�������>��|xx�p^Ey      �      x��}[s�H��3�W�i���5���7P�I�$��5����Ԗ%�.����df@��"���=��l�������b�|�f��~�y{�.K�r��o���w��M'�[_a�L�b4-�r�'��$�/�U�,�"O�.O��S�CE�8�*Ϝ�	|;�wƋe�'�	�)��O����?��4�O���q}��������������ǵ��������C�4/z��΄w�y�w�]#����ðH�<1<�6���>��o�Ɠ.�g�;�� ��������?�^�Y��>��o��ѻ$�L��߆���Ȁ◛��2��Y��d���j�n�!�rN��,IՃ�a2� �<q���&	¶��,9��i�f�j��*�N����-~q��ޯo���?;�ן�o�u}��y� �o��H�e�:e
���������q�Ȁg�	�3��� b��I�Z�w8������~�e�Y��_������b��� "~�|y�
��Gp�@\��i"���#��")'��-��"��O@D���q\�#�Z��jLWI>Μ�(O�4kМ��꧋��{7��~����=黩�Ӳ�O7=��'&����Ϯ����D���/��K;�OW��B����x�.Mp�����d��s#��g�1� He^��a�͜�$_&�d�%� �p1��qR��n]�RBr<0*L�cz��4�����ݎyR�1<O���Z<�d�X8��2��e���F���`�a���|��r���0���Ɂ/eg�d����ho��0����I.��NЉ�$�lgp�/}�����*ß ߺ�>�݌���p�:����h�6�,Z�\���hٜ/�6�-�n΃�}��9\27�������y���{��l�>~ʆ3�]j�e_��&#aԖ�� n�w��+m��#&��JGC8��*��G	�Ϛ�-_r
�e`�3�����a�W{
2/> ¥@�*u>ހD'Ԧ�W�
1� u�$Mf�!.Ю�ٕ�p�y���N�+����O"� �[�w��e�����f�t����g�H2��� �d�Bv�R���Ah@?�d�[����.$s�
��ĝ�yͦx���&Ӥ� �A�k߸��n�������׏n�� ���-��ݵ{~����ƹ������������s�|�H4�N�x���Џ"f�S�	�[�sS�Hr*B�3i6D��,���%���Lr$w�N21v ����>�#��Cd`v�������7�ȸ�hO��%�2��L� �"�֣�Ѹ�AW��h	&f����?ŧ�wb*�  �:��?���gz�7,n�<VS:�J��a\H����$�� gxJ��	Zur��Pzn�e����Q�cps"�Ǟ~ ����7�����1Get&I6�И��c�,C�	�jP�O���$O���Bň��4�l=ڲ�����í3}x\�^W�3�u%��\I�����"��h�P��|��9���:c��EN����d�S��s�6B���A�`-��Х�<G�ًl:�y���|Í����N��ϋϼ�l�h���NJ��
ٲ�*��m8Ƶד�	Kc��y�U���������Gg��>g-LK�q ���T�����UǴu��ӊ��I�@����'_z���9��sm��b�����6D>w��=���b���ik?� ����-GyB��4���^Q����E`b��6L���l��|�c�v�y| ���wٖsPE��<�|�'(��K��T�r?��^�_�!�1�'$3n��NÑǃ0�9a����~Y���2:*�^�$�u�Re���Sp;�h'�~>�-�!1�6K��<�i�o�(���*��[��9��#zC�T�����)�3�B���3�؋m���b�E��:FssY��"_���<sf�j4/ਣ!�<�K�%�I:z�d4t�d��J��d����X$	V��rԀf�{[��S�E\Z2"`�EHC�g����@�\��Lo�w�O����m��J����U)xIi�������H#7�&ILM5�/J�◤�Hh �2�'"s���LF6�Brg2�o�F�'uw�?j�lw��6��m{�}PM��Ȗ?���#���8b1�fwʗ/{�8G�������o�����{L�"`��*�%���B9�]bP�ڵL��bsQ�8��A�:��O7p�e�Uy�|[�R~��d���a���?�	ہUߧWʮ�L�q���� 2�8�R����2��k�m3�av�c��0{�#'9�ÆI�ٞ��j7x��:g��u ��bu��dh�M��N����Tk�[w�>_��D,�g�ւ��,Ѷ���p��ۏ^:�7�I�� �2���V��������V�8���	#>�C���� �s���72��K?� {��9 UN�:���C�>O.&`@���k��v��f���t-�/��$���_���tT���"�����Z�0F�����v����:;n��g=Q�	�9���^_/���ݖ#�������:f����"�/�����s'y���~햿�o��~}uk+:�K���Ǭ�)�adK�D���	ы��8pɻ������Fi�8�
���l�(�Q�f��1d*�ͩ'1xU�b�A���[k}f�8�9:C�P��_�� ~h�C�q����b"�a�Bw_���Wp���o�W�'��n���-�f��N*r	�K5�fhe������w�4X]�=�P�Ix��'�Ј��b�6�廷���©�-!d Ѐ �u�t��$3�
��1Ƣ+90������̖�r�aT�F�\����Q'�������T��b�&��X1�����h���zp�<'_|����o�9���}���1Kc� ͊���e2
Hv�+�8+=0I@AI�Z�[w��n��+�n$m}c/6�ߗ,����IFe[��)Ѡ�)�;6�3O��\<8��՜؅O�N/��FT�K�f��(�6mR�ۨ���S���KG���^����^G�L�0�m�7��į�(
?&��7�"6��QQ�A
w�}��js�a���)`5a�?�����������r$�WHrI	x���������F��`����\4�2�`����3֭:�������J56N��U��kЃd(�@-����*p��_�Kř�H�p,S��L��O�Y�{!l�T��0�Z���3E��XT+g��@��t�a�֏�1���Y��r��{j�Z-#��
��3�hYXCn����Dy&�3���јV��ٵ��W�r�� ����_��a�����٬������'��������r4���ߓK��e5|uֹ�5%�Ȃ��-!F*Qщ8b�<��ڛ-����B��Zj,f�S>�|�c���_��n��c�ŹX߭�n�;V��W�9:-*U.�"#f'��:�?�R{#�x���G9�U���$���I�"ă�|����G���Z�%ϟ5�~zy~+B� `u	�oڜQ�ʉ��1KV��P�Ӗ]`	>پ�>s-�ᬞk1V����.d+�&d��Mڦ���C�2�ɼ��"tm��f=��V�f�'Q5���w���/��n�>�(L� ��i���(�}Н������ݼ=Qܱ�:��0�vD�8t�dV�gwRfH�(Kz�s��8���ɱ��z/z������o�3��"j���饻x�W3���4�m�+1���iy�>��%㑓����M&���3�Aĭ&�Fb��|����l��1����;
H��K�]R���ϓ���~Z�~�ۂ�5ɖ�)����W�a)��߮ߪw�B����|�L�qϝ��g*>���ę5�����Ą�y;Oz��<2'KG*�Bʇf�i�yR��k��	������������ɝ=_6��������1����>����W��z�Q�9 ���Mu>��(�T����'HpN�谵�d���f��v��Xn-+��#��F ��~NX���j~#�N���݁�6V��u�X7[�������    ;ÌӞ���x �e^�[^}w�6�!�*o�o?�����BXL>��~]�������E��Z�g�M�����k��GA|6�a�����"�.��O�2���N�T��B�G�ձ~5�Dٝ�~��:��)�@������rE����L�;iO!"���"[R�&]Bw[�^YoTi���y ��%�3��t��,����S10�C	v�AMո����fRzR�����3�ޕ!�hҩm��;c�#�}��#�nq��6piP���b��N�y�(��aq��?�ܭi��������1E����t*{3�.s�O�C��|��=V' ��	3���b�~2oi�~)��Jr�{�^�w
1���L�gBL��<��~�����~�����۹��EA̹�ڢ�v;�i��ܘ �},����B��������g������ �UW���;��4uG�>Y>���-g;�wtc"c3y�Y��ȿ�#L���6��"�`+�K�;�lzfȢ%��ap�q��>�+�[��c��4'�$蚏����E?���r���G��k���~S	Y���믿v��՛��25�!M��w�� ��+�rAݹ�-���4���_��D��#u����"���a�٥a[6���ǁon��5ѻ�W'���N4/cl�˛��$�!��e���e������8�b�ؚ/�;���׼SE�h��ǂ�ڡS�9m���h&��NY�{��J���@�������p�ZW���j�\?���N�>��O��"����M��'޲$�L�3�%w�dj8�� �]Աw����X����?�<�Pd*�M��C��m�	�� EU�g��1EAY���VDuқǽ�t�[��̦F��G��.�9� ���D|O;r��X�d�H��3�5�o捛�oK�a85A3B��̘��jw���#�|q��-�gy��^��	�nI�+Y��Ml�o&�w9fP�^A��7 �,�S\ZT@��H:���j��3��a7��f>���Z#I4�yfodiμ#��E��\�CxLt�s��/�(*��b<�w
:QEr8^�O��S̷��q��kS��&��� 	��LE�CB�Ħ�����B/�=p>�CnW�JՋE̍����m���M~9�hpt|�|�xs}����%� ��)���?��n�'�9%���j��k�֌���eM��#�GF�:@���,-�w���m�� ߦn��o�������WW�>>���~�q��BOF9ff��,����v���_�Tsm�A|��b aծK�F="��^P[���X�]K3@wZ��F(�0B�.<̚?�LtwK���4S�n�+D��)fg=Ԋ�"'3sL5rl䀀Zz���b����b`|ɰ�9-'��l��!��{���s[ZIB�$�yE�'�yH�z��VM\����)&_ML(C�q��^����8�-(����U�dשѯӪ�B�w�LQx�s��؝�S5�������_݈�v�`�~��[��̒_�ٲ�@�@u� �G���:!f��g���ݓ}(W($Ȁ �^m�ևB_��fj8�^�%�2l	^l�m"/����է���M[������맛]�[.R5��L@��R�=ie��3Jf��k�L�������Q66c�K����̮�ɖ�	x{�DY�h���%���t	�zw��ucr��Dg>x�U���оa:��}���#]/���v��P�d�6�O�������arz6�\��F���ꢚW���H�_�-�m���%�xY�_���Wk�����ۖ抌����
�N��_�E�oa�g�e\�q�o�Q�(�i"��2�e�q�{����~���D��C,�<��%�qr�H�(��4�t?�n{x�8��C�QE'���q�ԁ72����akڑi����
d@75�m��m�/(Ün�y�<�k
��/c,i
X�n��`�g^4 =%��.{d���[�{�P�Y^�t�,MN��Y��TN�(W5�t�"K�S�Ц��#�F��r���m��0����!#�a�0���v���/{�XKm%��!�?��y9��=Y�VT�G+M6�i��$�yI�Sc������N�n(|��Ƚ��]�����-1�LlLZ��	�G�xp&���o����l��c�p&!�
�d��EV�M)چ��>��F��N�d��+~u{�(�$1[����&/e��N�0�_�J����A ��~���V\���dm��_�Lb�{B�e[�6�"fSL0�����̹ T��X�^wj���OCjSI�1��jDC�R�p��Ժf���V��/:��@C��uY5�Ii�i�W�A ���(Iā́��A�Ė4:Jݎ(hmg���%3wY��[M���r"F��6��Жb:��j��=iljᰉ��E�czS8�7��7؀���湂M)B]6��{��
��Blm"��D��ս7�8����b�#�sK��+�S]�\��K#nh>��(��B�\������n��A[���`�9oE{��u�Gn�}��~�B�ü���0M`u�	�Q����4��b����D�V�:���j�����#���x�\
F��K�[���x�e-5����o�uI����~�R��)T��xH�`,&���v!���¨7�}���E�r��r�Chճ��TC4��h�X9H��G�Dl޹f��Ӥ��m?4�")ٶ��~� G��8���R�P���&�C����qHrDEK�}k%�[�6jb���b��8�)���=��>��L̈́Z�r��C>]�<�C$,��%��C/�
زZ.g8��|�Z-C�#ʞ�m1��M�`�)aX[���6/_y>��U�B�;ke��i���Gٴ���wVY:��C��Z�nnzޢ�B�b ��g�p����=��]8C ��˗���Z!�7`i�����Kl��O�buB(��δv~��
@h� � ���$,1z'�-��y�R9�TTm�]/d�^�/� ��9C(A�^d�B��V�k�U�i.�7���(�"p�G8��u�� �#INH(�eD9�����4:��d��1�Y�����=��Y?N�r��t����<�v4�B���՚.����TO�:��n�ilH`/�@��=��-�v��X �Y.��}4���T3�vRLR�f�Ȕ���#�(t	)��l낃���F?���A�O������S �4g��	�=
�rꢽja?��T����b�q��PXq��R�P�nX�Q_;;��x��#������7�X�{�ك���A�L8�o�A��a���r�2\f���#>\ SV|�1f�@L�*�ҷ'x�?��|`@gn�b�e�yǫͿ]��؂L)��s@�J��R×���ǋ�^���'5��+{�ԩ_mJrs킾��2���В��/}���}�;w}��-�9}�ts08X����@te�8��JS�L�پ>YY�6��`Ge�}M����	z�Omeis���EQ�ʿ�k=0x���}��&%>I�t'�7uz
n?𐔅$cspoW~����<a�4�#_�Q��k��3^̰��LQP�d8S逼�S̫�^a�O�|>ױ)oǦs	~j�3����N�t68���[	�0�X�cPm��X���2���9�&c��[%E5�-�:����h���|)i�J�8�
��.�ʪ�WDa����`�v�O8r-��c����3�2FPvB�[�d���ϓ��s�J��f,R�H��ʍ��Lm#���!������΋�[�xRT+5
�v{�J]��+��ϔ�+��P�����g��l9x#>V}
d�p?�՟�ĳ� ҵt�۳
7��9���b�����0)P��b�as��ϳt�5O�a��ƨEZ��.� �[���4��pk���k-�1��n�Y�d�<����3��eY0��QY��>�|�v����Ϛ��U��|��{��B�>#�~��p��f��8�Y0z��j�x�qq��8O�dP����^����S�,�4Ӆ#TV�s\    L�F�gp D.f�||�x�$�;N��/��b~�����u@�O�s46ׇ�q��11�̞�\�vԤ���-Wp
5*SHfu�m���)�3�(򦤘-�|]��ꂠˁ��<��M���bAp��Y�+sk�@�\&:����F�׍��k`<�����D����d;;�D�LF��հ?�I��0RJ�{�7ڍ%6�ypT�Ψ7$U1*_�M�g|}dY����0�,�!������w�l��"�`5q�o�ۛŦ���5Tf)�vEЍ�����j�}&6)g������·.x^���˧��*�d��s�u*#� [Y��ђ<��]},��pR��H�n��X:�<[�%ŉ�"�Jݘ�[��Nf՛��
A?^�pN.p{��ĝί)��y�/A�VХ�H��������Ų0e(�x4{r���g#�Jd���t9�F�G�֓h�A|P���,_��b���Q紷��vNbz?>��9kf?�m�ǘ5S>(��H��% ��0����^�|4��߉|d��k�V��ฦ�t�3V
?ެ߆�2����a;9j���B}w3��
��Ur�(��-E��y(D�c�?ؑ@�ԅ����2�>��2[)��Z�ڝD?|�3��|��·�H�|����훮��v	=�k�m�� �̳^��lu�H�l���X
@��� wp��
� ��V�?Cn(5��@�l�������؆����d��<��D�í�Mܿ랷�,4J���7u��?,�����ȦhE�B�A�y��NQ�	��:��ͳ#���#2�r��~p����[�8�-<߷x�{��]nT���Ag�V�xQ�f�dRdԜ�xu�‥Wj�ˈ�zZb���\�_V]����ff�%��h�i�}�>D?X�-�[�\�{YSwo�9if���Y)�Ū����邲sGlo��sb� 7��[�2�n%&Ym��(�A'e�������=d�?��}jFe��fҘ�non�n��[74W���#��:�(�g�����Y�bh���K �X�`�F1��f�49� ��U7o.^�� �!��!�b<�ᡀH)FL��.�e�8+2"�S6�nwa�f�*�(���e""�Y�4!^0�D����hx�|�!�2��]¥���s���D�u�򋜆e�zg�ބӺ�˥}��]b�<R}
<iO�B"�܀{H6�� 7e��';ʯT5���y�����%��0����5��-��Kr��.��X��{����ǙVI^���8E�~�)����� 43��Qk��m,��s��24����BC���[���g��gCTpS����I���k]MlHM�T�����$��HO˲���]F��y��(�����Q�@��;"p�u�tO�N�~�1�8���%9+ �P�x�2��WST�n�,'�)��1��M����	p�q�|�^��T��XE�	(G�@*���:�xX]��������^+Z�T�G�.��*�<��)�K�Q@����n,,�
]�O���٦>/��Hٰ�Bh
��PG<�DѸ+����Yh�n������:K��IQᐔ޷��5�~��z\q��Y�v{�n�sgLT�Ұ%+�c����K�sH�c�ŧ<�G��%8֔&�>w��֪��CڶPRh�Ԥ	z�H�^���W��"�#�����8ѻ]g1;&�Ѯ��3Z��c�c��Q����?��@�8�W冭b���P@��OL��A��҆���c�Bhc՟�E2�$6Z��;P�#���ޑ���ӵ�p�� �}i��]`h*��ok`�S�q54^[VS\��j��²ݘ�����+N�Y�]��&\$�s
�c�`���;��}sϙ�{�@��a {�l�gl5f����.4К�/�����üa3}0I���)Em{���,��!#�{�K��w�����{o}�����oq=��q�G�I�[�f�y���`44߅cc�BZ�ʁ�8��4_h�����	L��H���=��?�Ж�
,���O>��M��g�}�l������x,
-���!��c&���c8?Z�ꓠ��hq{���@�L��E��:���g����f�g��u>Ύ{�R��3zʱ �]��:�b[���E������0ɐ��5%�z^7�}�&�Cv6��z>��ؓFϞ��x�i�;ui��6Ud���67��V8�]jɥ�c;w��*!�b��O���?1 �M�uTz8�B�h�
lU ��竃����o�(9v�`�H����O.�Y-ɩKyL�X-T-�wݒ#[�8s�᳞s���s�d�sw^�,kϬ	��'g��A��輦atȮF�.����q�R�G��^�0���F66�Μ�ۍlv����O�vMYL+#=�O���"m�$w��5�2? �U@���˳q�5���.�{Ab��_�]C7bo�&<�A�h��g�����f���� 
%�c�Ь��^�U�Ͷ���g�R�0�f� Ԥv�*}�Gq�\js&��s&���p���e�|��"��	f18�=g��7���*��@8�>D�E��I���\�6�'�ML�Rڼ���O(�t!�b1�D�ͼ�F?���!�%Ju�k���|_Vԓ�
��}ܠUp��͈ݹIK�)~q��\$<#�7�'�w������.E �9x86+aǪ��.75����(i��@���|3N�!O�~�`\%3�B4��Yּ��Ď*���q�̬�v�k�rH�~X(�	Ti�&�/��E����e�!>��Hq��x�}&���e�q���lG�l%w+mT�Br_1m�-K-!���.7
������Q[#j��D|���g+,��cV믷�M:Z�a�Y\c9�&��dt���I�@k���B�ة7z�ȑ;VF����\��M. l��@j'�h�����.fjq��7��x�ѕj�&�����U�LoV� im��p$��XZ�9������Y���Ur�ۯ���-�7/�x��=��Uw$R��!�b�l.��og@xh������"4��"�3 ]�I�@��qO��O����8��B=0g�\��ӽ�ߔ�ꉭ��{����6bN0!G�LCI�L����Mj���	�c�Y}�7x �:�^�rv9�)�i�̷�iX�r[ M��@z,P���T�*c�ɶ�H��Xau��8Ѻ�	"k�qYF���eyw�xAxSw��
h4���>�I�`����v�!��~Zx��4τ����cĔə�(ӊf{��T;|���(9��IU����3w��W5j�Ә����͓�a �uyj\�?�9�d#!�:1A�LFZ��'�ӥ�jdnS����4���Ń��OHٺ~Z����7׏?|��πGN��\D=�m��� �j"|}��	80pt'��q��h��q�j��k�t�lhH��A���x`�H�ӗ���{���z�d��h�GSs�g����u�*�V��#Ƕ]?��t#�*��"̓݄Ҷ�!"̽/���ʛ�ݪ�F1�H�c�b��
HsLٳ8���-E��W�Z�zT@���I5� �Y^₟w�շF��d�����zUU#��	�5��L�n�Nd�v+L��^�Ԟ�IkQ z2�P��'���o�̑(kC8���M�s�DOlӑ���?�'�<�E}gy�p��kԑ<���I��'�,�A˾�pYOct�e����n�1}j�|��FJ��(�N�cQ�q<�������/R���S����aܢ��h��tqZ�]��L��MV�мE�b�g��c��ͼ^m�������ҦU1�}��1~�{�}��xm?���I*c�b=�*˗�������˾���������w�7�����˧�'��Px����o�	LI�=�K��å�������F��s���{������[w�A�ڡ�����$���gm��c	3��S�{9�|�k���Xh���g�;EU_�m���rȢ\ܬ���#��v�?��c�Z�z����M)19IVpO �VW�e�j;�ݛ}�S됆�Z��j     �13a�f�J]��:ļPD%�/wwk���~��4�W�~��蕘ASk#����X�8��E+/
͡ށ)������_���������i�Sc��>�Z���fG�/5,h��7���N�	n�훆k��#v�tq�q:�V�B��-=۝vL+0�� д�N�l��2#esy�yǶ�y�a'b�ؼ��qm��"c\� 㐖pa"8"�F?��!R}o�d��[�N"Z�]��.�:�*��n:)�C b?����Vu)�w��5�5�]�gBc���iF,�9<)3W�i
���$����uR���A�� ��l*a�@ɫV�4ʜ)��;2)C8� ��.���h�)-�͞�Mt볃�+v��y3�)C�=Q��I<�|��P�ٌ�.7ҷY�d�"�M#D�_MG�*�a2� t$���ҽm�#��j�S�{�O�y{a�]]ހIO���w�~�F]e?p��b��n�w�OA��e�r$E]Cn]~a��@2t^D ��lF��8M'��������A;jE f*�!bu3�J�d�5RF:�y5��~�isN�ҡ7ӵ�����߻$ڶ'�uK�/�#����aJ}�{�d����d޶�'��$�Kj��2���a���Ͷ%u٪~=�Ġ����R�{���rUoҍ��I����2L ��~�֛�o/��V?�����~�NJ~�#c"9.�G��ǡ�/������zr��)8�=�%��ߎ<��$��R��2paj߂���7�?��ݏ³�����D;�X�|�?�20b��Gp2j�$��h���p��Ք�gR�nu�@8+M0u� ��g;�=������NZ�i�Ri�ȗ\(F8p�qa5*<��o��H�Z�4��E�d��ܘ�y}���/<[)���� ˶��**����h��/�C��2Y]b
aޤ���w���jUN��?_?�ӿn}��n�ޢ٠o	�s?�t%YLp`Q�m ;$O��āB_Ɓ1��C�c��)^��X!+b��E2F-���؞��ѩQ���m�Sb�Qo���O���)n�����Y�;�/d��}�\�$k����T���y�V�a�[��`���'����0�}�N ��m#h�4������|r���P���M������D����Gk͢X��e�������^2g^�w�^���12N�5C�~�v_h�9�{�j�Mtۥs���2�H�����J
s'���N��9hi���T�ʀ���ou��֛٧m$��96�"�t�Yx%��Ǵ�Ԏ���~�h�b�$Ӗ�V�#��/o�����	�Umh"��������^^��4Wq�0����K����P>���m��jP��dLX+D8�+'yl��S���N�5?�~���D🴙~<��wp��I�[	�h���c�F-���~Y?ݸ���*��wk����~�@�	l�����L��^��3m�a��p�(�9�R��4c��d�_^��误�-�qڶ]��8�8�0�9��VrF&Tr���?:v�%�	���B���~K�e8��Tc��
	�G{Z�^�ޢ�O�����萇����6�)g�~`}<����!�d�Ct���[��� ��J�z������wRGt?�ݸĭ���6|&3�'7�ͧN�IE!�U"ZM��~���)l�=ь��pZ�pZt;oj�?�����eӅ
�H�38�vʯe��'�U��x��gL��^����,�Z�9�=ӈ=���̱ڔ��`ٱɼո���Qi8s��"��tx@}bv�DƬ�n֐����_&}�r�����d#cz�,Y֪�ZP{b4����l�2��}�JKY��l+�j/K����1̍�,M�l�;��*�|����i=���v���c�I�)V:q�3�֬WS]��T��8
M�Þ< y9�ձ�i�����-��*QM㟺(��[�C��Q\ϧد��cNH`�'�T�6����>�{�08��)j\��+Nne���܋@��r��������Z��7�t��Z S_�fI�����9�v���<|3�{f"�ޝ�p^ݖ:|�tsh����Gy��sr�]������ي�!��ߎ���rzʪ��Ԛ�9��Ņ:��ݰ�i%�<s�Kk�4b���e�b>�>��b��eϢ䲕�a&�XcR�*�t.p�-2Ѡ��/R}cK稯I�"ts<\�h�Ha�Y�2/����>\������9�o��8���i��g�ods��a7�b�p>���4�I)�E�C�Kְ�lZ�'�4����v��mE}�L��8C��>^�$.$9���Qw��Bx��rf-l��������F��iK�>}7I�=�?Tؤ�ea,�ե��{���9|�^����]��°��48t�ܹ�=3�{H��W���I��	�>�1 ������\!3������E�����r����Wj���L͐�ܭN�SZ*{
�y�8����<���/��,9m�XH�y�Ņ;�,2��	R�v#uj�5UG����ß˖����$������4j�:��Z����¼���\%o}��~5͇���a��Fl���}_���>��j<��竁�~��$(��iI�N�{J"G9��PXF���(J
6�Յ�4J�7�n��j�D��rAٙ�.��Y&�|�y}]��G�$���Ǳ�%	����|�$A��0�źx�q��	�6��h��y��hr����{q�����3p��3��	���[��l\�-�M��I�D��m�3��[�T ed�'�W�����adk����ל���=a&g>`��q�lޘ���}/��laj��*3�VZ�~\�LT9h���ɰ�eD��ډv��-cu�}�X�V~I�p�!?�y�Ě{=�t����2µP��L�E�+�F�f� U���Z:�+����X�<�=P�s���oҰǸ_�L�3��$�(�,�g��đV�x����.�1YG!b5s����IU\�x�A}�&.T�q��������zɨ ����@�ySMjOb3�Z��Ҍ�u����sT�3gUG���#'��7�	Y�������:e�f7�k��ᖫ��p��Lz>m-���G������ɖ�D����m�نwz�'��s�V���ז7z1�"�^ϖ���j������f�F�d�$>W}Qc������Н�k>_���7,}�\$��a�!�V+}=ӵ�g���b�D�ee��ei�X�F�"0Tiȷ�5�FW��`�Y�V_`�bZ� �Kh>K3����?|��Ǳ�0
��L։�6)������H���r~R��^��a���[��b�9;8�4�z2�n��y ����?~�2�����&qU�&�*
q�^�Q�����r�W�W��v	\� p�B�N�|��Sb��#'����������g��ͧ�s'���Q:�;��&%l���`���B�[o�'�Q�2!g��F�xH�ZA��=�z�0-��c@;]�u�lD�ѭ)F�i�su�$_�|?���G�fI&ښDz�ư7)�q�D�LCa$j�ݙ̫�},�<��GԒQ�m���,D��edí=a/��rE,����d�eb
��Q��� $�����y���D�&�0ScHȨ�Ys�}[5��6E�A���tL�)�߇�MN�2W>n��MX���yP�on��l�r4,!��2S�����b�����$��=�y4uF�ɼ��ew,O�1�p�Cd��"�~�X�3X��%�Rr�KRK�E��"+T5���k'�pyxͨP.��嫤�*���E�*���Z���J�#�����6�?�P8`"�%��G��t.7F���`#�Ǉ��LJ�$R\PHv�Z1�V�j���k�M?�>���T"���b�6��W[��Dk!6��Y?��n ƸJCg��q�=)TW�ϟI���[��?��h:�y�h��Pw 7��U6S��"0 ��J�|��)Y�^���F�S%~hn��'f��P;D��Lc!!T��أ�BJ��|Jy}�`7�jF��R����%�-p��L��� f�49�������b\;��z�pN{.7�nM~Gˆ�_Fg��  �"���m� u  �0Q�����;f�i�u��!n�7�C j�v�|}�LI����� �`�$q���yF��TQ75|����xy�|�W%�͢�]�Ҳ���l�� waEHe�����w#�<r�F����)��;9�B��[�f��#or2D�N�ؑQ�����9�9-�4m�|�9s�ɫk��@_mm}�����<O�qF�e����ԝ/�I��
:�-@��f�59��}�Ն_]߁z������?>�<=?|���RKٛ�v��ygY/����aA^BT�A�fO�����׃�T�G�PV�:�i��wW��ٟ#IuY�h��z9�+�O%H�ݵ������O ��I�j"Y�uE�@J߳xJa�1>u�1�_�oI���� �S��{�9�|u�����^���tRuu�PE��,)�:�b����N�;'��8	P�fMk񮽭���5;�p�t#7kA���uQj[�x2�)�Ѻ�a��||x^����ۻ�|��������]��y0{�rf Q�nK㫏�0�$"�8��QC��V��r#�뻃," Wo��%qi6��z={�����o��!�WE2��տc�����]���{����Պ#M8�V)C�M?U����&���q���I�΍8(�G�L �2�s��ވ�F���ݣw�l�4⌐!�N5��zrG������4�-Ik�/�>��R����|��u�[�zgq 0��l��w	X�B����<a�,��T�j��f�u��}��4�"����?�@it5�]Nm(��5P���1��pg��F	��(����(�H$}ϧe�I�-]qe�G��8�'��jb��eo	4G���}	����{����&��v8_0O/��hQ�6���g-Z��]_y6�oC]��)c��֜d�ս���>� 6Ehe�ߴ��&Q)BDuՠ����dT�[�uߒ��ó�sk.�����-����<AUR�yn�i�gJ�i�"8l�&�(�*��=ku{Cܟ�Ʀ�z�1� l&ꆞ��r���v9]V�
��d�"9��T<8_�g�'~�7��cd\Ȣ�?m �n � 	���9zµ�P7���� P��Q?8Sf��oc�g���;t������������$�r      �      x��}[sG��3�+�4�����~�HP"%䂔=3�,�G�%�����'������/ZKt�5���̮�{~i��0���{DL�ڧr_���r�w�k�Y;�ۊj��/..��3����ì�,.����������d}������w�7��7�~����X+���������_�}�y�q}w��~������|�\��&���Ʉ��,���N��'f�Ꙡ@����"�n��}.�R)j閤S�"�ng�P����������z�ݼxy�@N�͌�|���ާ��^H�4�ع\�������a����g�b��/7wO)l�)x1Rӂ3���廃���d�3� ���&g�F�>�r�:;������O�{��3�b_�}.fT	����	��ɀs����{�o/9G��,��bb�T���������Ŋ����������?�o��DϜH`n�ϓ�±��������ջӫ��'��ӗ��>ܾ���yL���Kx����%�Gf�r#'��Ow����ֲ�+��ˬ�����
?�*�p�y�۽<8��,��.<�@C�6�f���i�,�����\�A�^���}!���s�љ�E8�7ֽ���W�y� d"�@ �h��R�G[����^��B[���D�KE�jz�_��o̿ J�2���/�����d9_.�o��2?���6��Չ¶E!A�͘�����aY��0CE��7���Up��
�����w�/�LJF������f��nR�An���%��W��j�� �U���v��Q�
��/Q{�NA������w7�,x%���& �����셶`�+Sp9?=BZ�V��+��˛�w�O�w&o�ǌ������P�	�"qf����x=?x��_��/�=g�=�h�(0�@FT�'@�dtp���}^rQP��]�����ʈV���[x|�~]?<M��{vcA-�^^�����!>�*�_�oJ5�XQ"5$z�
�*<�dPV���&b�r�a�}����s҄?�5��b,�bJ�6
�vCU�=o�����Ģ����QSJ��lf��{´�d�9�b5�G���;Q�LWT�F>�#�r��྇7H�H�$5S�v^��4�;{���5��mv�n8yD샢��P�[�X����I��J[����	q:1v���u���XT��w5y�����O;7��zsw}����&"eB�������^ {'WoWG������Q�B�4QB�b��\�^J�B+c�+�R*	�6t�h�K|�ٕ�?�ugU%����ͨ��������%�?7:&!A���}��O���J<G:|XuE���Q�4���2�������G@�[��@�o�6fv����ZX�0<�/Z��`���ly�X8��ͣG�ˈ$�#fD$�xm
����O�,r�Έ���Zjj#w���UL��~o�����!Z��/ �/@db:�Ͼ��J&<��̖n�.%�`8���+��W���"�^M�ܖx�;��ΘՊ�E��v�\G����K[�z�m�I�+y����h"�N�p�)�xR���Kq"q��+3�J�]qԹw���c��[�I�r�^5��_Xfe�j���$�'��9��Aw���^�vQ-[��@_]�'O�����- :������L�/���b�ߪ1:�7�on�ys�����/��q�*�7���������hy��>�	Cp#	j��ׯ���_��e.~��Q�Cn�J��m�K�A��+�J�g���$��d9ѪM�ܧ|&����,�9��g���v���<��D�(�J��q���KX�Z���H5�j��)��e�B	���~�?pt�qw���<V^�Q+�����W^>��|!jc��*Sp����*m�.O-JC�Xp�8A�GSn���k(�$ �x��͞7i����PNDR��%FZ\p׺��%ꂖ���N�B@=����7/gm_&�:�\|^�=M_=����qz|�����f��V���^�7�����])��B�B���A\��exYfOg�K5n�������OO����&�+�P*����W7�7/����w�7m
�[��۴NoKxk.u�x!챊ӑ�����b����&�1�}�����W���xF��-I�J|Li	���W宅ί�#���E�<NB�z����x����E��_[[Q��?^�<\I�*�9|��\�|5
�"�[���������~�\b_W���@�3�P�3!�&�}ݜ�,������s���h�Eu�\x&&���)��ł侙p8t%��m���x�\gW,�����7���ȔO���T7h7�ޠ�)81tb4-Q��n�8��h5���h��m�^���htk$�k#�������3�z�@m�Q����/p.���g'ˠ[����o7�e���u\�vK_�"آ-�7sF�R�a>������~���+>n��gr}]� �)�_�e�7�6`�-NN�Ē���_���P�}���%l��6vw\���Y�a��P"6X�g)���T�]�V��u�4F�8��ӏ��N:�����Ms�:ϓ��``�}�f�P�M�yR��?�%~<��5�-K:R$43P��ƥ0�m�����7Op.-����J+��L� GJ&Rm~ٺ��S&|�Ԩ�&��᱐B��|�JfT�/a��Hٝ�+�}��t2�t� I1�a@�K�8<M�Q��p�ԁtWV�z���4�Iq��f����'u�ɽ���-1����>�E�X��K9�n��*Tܢ����3�H��ߊb1騷D`��&6!]�!�`!}�tJ$U��r�y�v��&��!�Υ��`�f�vŹ�6m�"�+������$�\$ւ%�B��Y������P�M2��;�0	�liJ�|��l�g�S��-�I���)'�Ê�b�L���arF�VF�?ӑl�'Z��h�ګhT53Z�,����t� �
��΃�V�?�ҙh�������u$& .�x:[��&��7�n�`�!&%���?8�[u��G��N�7�O0�<>�v
�^/�R�v�I�~�y]Nc���M�0XS�7��ߒB��`�1N�h���(5tr���G��l΄�L��ul�qV+�eΣn�GP,�lf�*L��i^�������p�8X���^�<�#ͳI�I����r��L+���v��C�6NE�?+��RQ�ٮn�:��DvW7d���~ğ���auC�Fs�~�/`4ee����!!\� ���3V��^̧�����+���L]�9��\՚��*�D<�F6OF���g����Wቯb��n��h������p����N����2�2�T��է◦�(R�����D��<e���C5��oL�ͬfB���͇��i�+/�XICT��z��~02��\V��DbWu�g2X]2y�����/b���c�8H�C,~�L��\WM�Qy�CS^s�A)�;���T�:ϿJ�ϔ�c#;�+�[#甙�{$���?SP��%W�c��2O�z�PS�(t�X\�3�ظ�-%�o�N���I���:7Ȝ�(�����lxh[�\'��Bccq�aq$��;aB/��f�Åp��L:�zg�h":t�Ėbj`y2?���7S7����賓s�����p][v׫�~W&=QJ��������D���4\O��n�����[vw��U�q���8�2/H����v]hu+�r��tT��rn��o%x{urP�h'�VQY���/k%z�U3ͧ���x�[��Fւ�$�9#,;Ѻ�f�Dg|�@p�W�j֦�`]�H����v�T���"wC�S*ŵ�������v��ףrJF�����`G�m�V�40��G��`vB�l�������~����0ƕ3&�s�Z6�HRa�8�������h�D;���.j7��f��E�9�@?'�\��\*&�ϿA����V=��+�}�/(`��gM��������!NW��kFtZ�!I~����Á�8bP=3|�x|�7�^��I��MZ;YV�t~v�j+���Q3�֐�0�FEҋ�N�E��|������F��F�H6    c�b���ƴ��f�RÒ�b�9�4�j�n����E����I�+�]���o��ms��U��£�u8�&g`%I���Ԕ�D�w}[~f�J�:@1�i] �4lP�%𸥘	���v֎&�w����������yi>5��TJ���kGFDG� >�¶��q��X�GT�?Q���v�ΐ6�r��d�6oul�s�+M�lU5���/��Ց)x��ܧ%��iSVls�ѥ5�:�wH�4 ����5~�&Lm�լ�7��c���݌';���\�J=�T��K�e3���P�
��a�o�$����8����q@i5��oI���o�8��ơ���-���v��	�t�L;% ��a��I22����PF�+��r�(�m�56��Y��z�A��N�g����K޸@���[��@����݇�h{�)�!����/�.<^~
Y�)��XG�^�cۓ�RwE�8�'�p�Dm�O�w��ޑf��qko��.m�]�E�L��G5�;^�}>�ۚ)G���x7$)p�s���:���ݺ0��h�
!V�*�['�4Z��� ��%8�p�*�-����Q;<�?�*ӊ�f/��j�خAܺ�� F:�!��7T�X���`p��8��n����{�����SL#$R�QRtK]ԧ$����#Q#w4m�
�3��~��zcL�Ӛu�U]�7�$,��S�n^�W�؜��8�/�ψ�yy�������<�y�- u��:":��4���r�.�����x�m�<B���������Ӵ�dPD�F	Y4��	V�x�`��������ۻ뇵?x�g!-���,�Y�_�5�\���F�O$M?���&�H*a�N��+�[m7D���k �ɀE�����;���;@�'�`�i�y]~�y���~�����_���g��kxڜ��T�	x��߲����b��m;�miYQToqg`w���g�һ,$(a� 54��2B�.d���/P[��mw�y�T�b�(��xD�})H��hK6L�;'�ߓl2��)��!8+�b~����2@u5�U���\�����.z:?����E��׆b�3�-m���2e�Jbѡ!�_{�Q�%�G�s��D��/Lw'p��oԻ�Ig{�K�~!�B��Q
�O� �����G�ˣ�ȥW:w�H��󉃪����{�cR��4��H�R��
�1�{�`�Z���Ɂ�p����a��ì;	��?߿���6��:!d�M��OG����-����9����xJ=�+}|���(�,�sn����
}\ӭZtOG��-�+�Wt˘n���b[��}��c�p�ՊXi�:o͚��'W����Lt�2�G�꺘��ʌ��~7c��1�� )��ͷ�K� �#xG`ܙy����>�=�8�)�A��f�@��ٰ� ��⭵�!tE:�#gÞ���V����S�zXP�����'~{#�*R�V.�0C��Ҽ/~��立�H�L��$6����mz�?�#=RI����6EG�g�M��E��O��T���xWf�9��������|�g{�Hx
!�p�
Qk���IQ.ʿoJU8����`%�8*,IeˎÈ�y���b��G��������}���|���%�ˎ��tD>��=$�_���޾�˻7��㳓ո�Ui^5P� �M�ٙE�Q%Q��;I�@��{
o��g���x2U�,{�����.(Ĳ��{1�@s���"���j\~���������,�!��N~��X*o��&^��+yA�3��Cg�r�#	Fݤ0wIq"�J0��K��U��K!��%�r�H[q��p���i��6�@�O��V�:��Kё��u^&N��AQ'�uѨ]�7�b]�v-Qw�ݫ�`}>�͕wgG�DX���K9<����s�A1����I8�a�b:|"TvK<ND&T�ct���Ci��$"�jY "�eVU���9i��+t
��2��L<�����6�1���>��	�/^܌��$BTLZ���e�bHhq�}���qd�/۩Xc�l$jЉ��V��[u��d�,�NSfJS}���G����EX<Az�3����������m=r	�j��f	CnX�"T�D�L�uW8+�Z�T~G����6}
�]�͐psH�e�↤W�v��C���ZY�_#M�F`��fL�=FB�;I �i���s:3�<����l�P�G�>��A-˫����8�N����6/�r��4(�=<eu�CZ��B��#o�6�E���fp�	�6?#��I�+�9J�E^��mk�V��n�^�����ÉȆR���wDDa�ͣS�F�E�@FR3.
ǹ7�����f�Iχ��j�Fķ[�n�
���j]E��힗�g.]nh8T���$}L�j)�z?�YƷ��g`���/�s��=���(���c�Ū�	��TCe�$���8#���abv�=�^�Sq����iyz�+ܑ~j8-j�ޝ��'�� 4�2U�b��eJѾ�>����I��Q����?f�u'�<�7%4a�����	�*%f�e�g@�"�Dc�8  �ׄ!J��wϳ#+�3��-�pb))Z��䅷x����Y�1R�DgW?��3�k�:]*({�w�8����/�$��[�L���:�<���������&v�͛�7�R�h���l��g�
1�߸�ĳ�Es���_Ӥ�VÐ?Ƣ���1?�1f����8�7t<5��7��?֧�������8����V���[��a�dC��� ���׷�%gF��o�nÕ����۫�ty�?=X���-?���R���;8Eٛ��5��)>~zz����f��y���r妕+�<*.�s妝+G�+̖߸�Ԝ�/��]g�u��������p��/-Ny����,��1k*�ns�η���M�w�X�����QG���ȶ9rxJ8_<b(g���x��r�c�)����?��b6~C��k��M���]�2_�_O��ӿ�M���Ng���41��q�v�.>�����͏!N_�]�>=�Z�z�Mx+0�umZgA�AT�����r5^���i
�k�jlܮ�s������O�;тLONN�?Ie��zuY��1�!���\�aF��,�N0@�p� � ���O{��[*��*����LT�0o�ڥ~YVqP�pS����� ��<L����<�K "-e&>��ˌ5eM���w�S,x���� �.H�����%��B'u�%[���^&!I�l�X��';0 "�w�u�0|���(B��hx��.�Ѵ4�o'����%�v%$�90#NH<R�Q�����uA��k��«������B�����9d����zO���϶�Lk�D� kC�p,�8(�d.�	��.��(�=6�4�&vqbo� �p��f�hT�c �.Q�����p��D"K>,���yX��'M̞O�-KG�	=�b����QS�
�X�t�����[���u.��E���~�"�!x� e��V��vu��x|�ޜM����N. ��5"�AX�5��(F���<
�|����d�a�o�s�},hd�>W��6Ee��}�g:W��:��B�Y+���yV<��q\..
�
NZ�>�߳���,xτ1%Ȳ�C���T!��6�:�����w�Ӗ!M�@T��l�1ҁ�b+�'�x�|=?x�t��jA�1 ]^R�%��[c瀥�����v��f���$T�����|D$�C$�l'�f27
�%�1��|������?^����6I��d���a6| ��o;$�A�[:tq�r���i8�4}G��~���	p��I�|���s?ޡ9C<��.8���QѮ��6C�Mf �d2&D;ja���#�sǚr�[z�tp�~D��=q	#���(�qe�b�!$(�l�P��\����¦O��S N���rQ�䱓*�!������M�C??�_��\�L��K��:�����@%�7��	Ԩo�w'Pǜ�Ɵs)H\�ܑ@�˻�٠��������k6-ի�%ś�%u{�@�𳭋n7��    �R�a=����f��/|��|3~����_�_�{����ǻ[�sF����WӋ��	�����꿧@���N1�l>'�8��!���suzx\6<H�h��ja���s6�� �ӿ>�����\a�{�v����gӗ�/sx4�-h.ǃ�I"���fq<�>�(�0�j}�6*Y���N�/����Q���ê ��Q�J�(����
�"L��d�(�X�N\!�W��։�I��b�	۴]�A\!�<�;�Iq�D?�� PC������?��xp[5���ʿmW�����E�2�����_*��tj��������a������ă�����n|)�Z��k�6$���&L~Ƶ�h�s��'�{�6ڒWF��:����q5��(�o2/��v�Y��Ʀ����2>�����ڎ�%�������)���� Sӕ�L�������zV��F�	�s5?��<Z]]����_g�b1�$��M��pE,*�D	�}}(�Pc�^�_�w�FB��i�u����g9�2�4W�rC&��7;����`/��D̻��H�3�Ѡ�������&��-(E����+���Y����8p±Q��:��P8a����JQ�;�������6.� :��H�
�C�����Y�F�`ǀ�MhF�&�f���q��ۗao�ˆ&z���p.ޞ]t\�"��4M��� ��N�}�zy��~T�F<�^ ��P�}8�c' �*Zm+���ӑ��Z8~��YܸU4�+[�^B�s$!�k�ׇ��V���wR0+]�tYo�vm'��g\���lTT<���a8ox�pm�#K��Eⱄ)���"����1�����S�N���
�s��9����Az3"(�
J�)�HP�iE�օ��H�f�n>T�P��
�'�vhx�U�b���
>��Zj��<K$�Y8υ����#~s�Z�¹�<�hC,	�5���zڌ���4E�H�Dj�6a ˢsO�D41}��c���R[���0G��z�VٷW�B��S��,���9�h������NYg�4I���TP9�_���i���9�\�޶Y�{q���PNe�3,n��]�F{�H�S�\�
>N�A:X��u�t��H��:t02٭��h�b�WNINu¯����G߲,����gz�����e̱�u����A`���|��C�aI�`8��A')^�@�C��+����w��he� É�.���F�� �cjc���X��\�ʠ�Z �j�؁2P� G�WQ�W䔞�o?vF4���/ft���˷������x9]���`��"97����zbh~\�"��d���Cu��nS1�h��
��a�G$?e��~i���ِ47�b6�a�8k�~�-5��k�!Ie�4�;�wsSZ[9"�Q�AS����bf笫���~�#�����36�HS��o����{��z��������������?.^����bB�eͪ��Z�p��,�.˛���b��j9�_F��"dx���~vK/
ϑf7U^���9�z&����aFx��������1C,gHr�А~�m����m�@����~�B�]"�P���G8s4^�ź3È�4,��VU��	¤�F*�Hl�N4���YF�s��X@')gK��-e�jZW�.�����OJ�D�2�M��t����j���0n%
�Z��e|FOw�[��[��D����Љ2�Ť��7�S�o_��ߧ&����ZG��������^uT��.�<6H/C�������Bc !i-S���ʴ��� #\�"!��;�϶H؆�@�i�nЁ�󿉊ڏ��/uw�;	]�դ��j��^u�"��V��Y�Ű��~���"b��QMܯ\4����R��;4�p���־��5�є^��;|+�'dX�	�����/�H�@����!��n[$�8w���*�:x.\��L}�K���*�Y��co!~���t�ZX�Ƶ$b��m鳩c(R��M
࢑�X����l|��������z�}�o�K�4��>b����������t��/R��S�)ũLUC>%�de��~�v#֪��)�!;��?���5a'����n����.�	���j?�	�Y��)��d�O�E��`9�fe�>]�x��(��\�<Ҟ1�ǈxB��!c0)c��"-�*EQ�e�lg@�5���E-��D���`d݋"�Õ���&�t�bE�n�������U�I?�h�oӴ]��x�7��l��w]џ!V��yή������Y=�H�D�J:/�N_�E���<�rg8E��2�F��o�<
ǟv�w�p,|���E�_A3����ģ�έ�}f��i��M��	D��毤�hs�n��!33*�4	7��!~vKn��MX�p�7����e�DD�C��l���0�[n�M<X����3�9�M�<X�{��6�z������΃�v��m��q��ӼfQ��Ֆ�:fy�:��|t9�����bzyt��Z�m�M��Ϻ�Q%Ƨ�լ�ثٰ4��NaIxa�X�(!a8Y�_]�/GDRT�2d"�H<�^$!+CI�H���HLb��,���<� �*���%vD�<��n����u��,����������m����jL��=���x��S	���o/��JU�x//���r�eHa��DpEK��F�����-��@$u:�&:�3�#�V(�ґ�[?����xS�N7�ꢥ�+U�$G}i?���Ry�����̬aj��^M�zu�0���zBjR^�?��h5���hG�׮ڳk�LU���7�%�دQ�Б}���1�/p��g�ou�Xc�^������e��:?_�*�}�����<����������Fs��~h|�*R����J�����!6��z��~���a����Wj�&0�:�F*�'��%�V{�����&�pǴ�7�Y@D���>!zs��nҐ�
�㪕Դ��ݮ�<.>�N8VGb���b�ƃ�%�!�^'�S�Gy��hE�MKN���_B�w��ct���y����*W-B�Rq�7�D�e"1��$N)�J��R�K�HM�_H��Jń��k�ܦ
T���8���o���cD�XS5�9��x^w�����؂3T[n��.�XT�� ݍ{��� �"����͇���џ�}<=�����.1���p�0�[�s'�\��Q%�C��ZS�4�<[*�m��f̅ATȘy:�<����7��Y�����
 �]�n�ٳ@�/��Nu�;��䃹
ѽ���[�G�m\v?�Äi�U����x��/��y�+�F������	�+�"��h�k��:�����˕)���t?ȧO�}�%0J�i�Q�+DqZ�S{Sȗ^�_ar�_G��T0�y|��-޴7�8��$Ֆ,{�AֱY�5;y��F5*��Ud&�Bϭ~���Bp�]
G��qx�D]ռ{���p�-�L��K�6	�G�+���X曔=.7!�'v�>��\�!�Bk�6:	�h�O��⎮1pUŻ:�2Ǵ��v�Yp�8(�v5���/�e���v�찳��_ʜ.f��cnx7�ڟ΍Q�ľ+��0��J�;P����wӦTg�ltآA�7�_�P�Y�����N�6ɸ*Z��h�Hml�w3�Z�e��P�P��X`C4��&lB�I�?��j��#��Y������s�����1�}�����L"�yk�@~���h��ڝv���ߘJ������q����I��MV
���Ш�ߕ\4�	�V.�j-+
DBPei*&UL� ���P:M��R��V�����Ҍ5��lX/�`[��4�����	7y��S��u����[ �l��t�_�w��^p֤�?�|�g�Q�t(LK��o�4T�~H�s���bI�π�K�`(.����YÐ�;HI,��c��b�e���S]1�Yf��縧-�E�y�Ĕ����A���Kا	�F�]���ĝ���U�w�(`tJA�Rpd�����fg�I3Cpd���v��o��w�>Q)w�FR�=4<<W�h
��۴j|�\.���E��ib!&�z    <���F�n^�E��c(��7���@߄�s�PI�����]�2:"zru�����1A��H���SG����i�9"�h,)���ഃ��wXy܁q��'�X\[RO~�~{���H�s\���w�?*H!ܞ�J�����,G�r8��bUc�8mm�)�c����Qe�;:��yy���ۢd�������w����}=����}V�T!��2�K�f:��3�.j������ ��ta4.xT��Ǧ`
0�B�f�T�nKEc�Jr�X�}} N*��Ԭ*V�ߠ����V�cCё uGwFfb�D;���8j؛�}�\�&���]���VY��?�M�o�#R��y��HWq�1�*O�}]�d�	Uwj���kяg��4�dg�VF���u]E�w#�1���c�J���F�_�S�ґ�]Ԧ��tc%��R[;��lM���l����@X^��k@�F�e�غ]ӭa�bW����XW(�{�;��E-�cׁc��m�뿣�ç��Ƈ�Kƛ��÷W���j�����jq9*9��?�(,/�B
�E�D��[FY޳׭=ѯ�m�u�3J�F))�҂ݚ��~2�/�~Ap����=~(���}�&� P<h�Y5!�jiKA���RDC�>.��:�{`��
�+�ѭn�>�Ut�*�<b=K1J7+Zj�%�AX]
�V^�*��H�x�aQ���ٱ}�Ԥ'�:xo���nm��C$�_�--^z�@ȱW#�o��MB9��8�]�9/]�w���"R�k-������S3SF
%'��u����6����-.���o�<m5�����Vc�T�Nm����v�p�Ю�Y�$�fY������X����$b?�pj;�A$Ɔ�O�3��i�-���G�ԝķI�V	�����%��'/9�%HP�%�je�Kn��0O"u��'N��]acКI��@xG��
0DT0S��BB�mDQ��-�t`�n���X�!�����������������_24�Z�K���æ���,�?,?��G:7?���o��^p`�lq�,���nU��+=Y����������u�'p�ݮ��n��~�X�DM�Ք�׼���Kڕ��aI	vL�wp��j~y�;�۸[�n��n1 &A�C`�=x��Q�w��sS��ɚ�Eywa5m�io�ܖ�'ص��D
���0�����U[�������%�0�5�W&����l��.�W8c���#��TbDK�h|a����d3���,�'���̒�����7����ع(�I6)(ϗ��ռ����4��,�*%��5�\N3e^v0��.�kwdut6_��܃�^dA����x�l��mG��[�|K:��,�G#2�'���CJ5SP(�7���>�<-;�CCO�c�����mƩ�4�Ku԰&��=���I)(W/�Ë���0�����^|G����F�Du�%͌
	�}�:����tB�e}Ϙ,|�I{��;�{�y�T���ј��0�M�HHs��!x�&�s��(Y�w_�]�"*�ƪ�R�X�-�	x���Rψ�+o{�p���`��_��M����5ľ%͹�[�n��>��Qlp#�� ���z����kzp{w}Ӻi��t!�!Z�%����	~��F��&^��g��=9;�:���8x�}9 ��؅'�L+� �\|�򹴘�XL��C*���vQ�@p����	�lAW���|��<����Ef������d�F�mXj��F�x�����
^�����gl���m�����'����(]cUh�4#���å��jХ���vh+�;f�xw�t������8^a��61V��:IT��sY�R/]ƴ�d�]�vyW��Kr[��d��[ǩM�/Xl:SFk���F�����9���e
}�#�LdHG�<!��,�#cR�������gY�̟|��I���oO/���CҎ���q.����X���<��:���:z!85��ys�a�3f����j��MY�8=W�p��a(u���&�I<�x$H�T#�8oN ��4ȧ���_�\�k���&�A��jxy�f�x�2yxz]ڦ��F�Z\�`@�p����<�A��8NP�B�A������'�?ť�Nt�;]Kd�hlA`�� J��VA��y"�2y#!!J�������;����er����w�W"��������gJ�`%:#B'Z�N���y�?�]�
�D�A���0Q}Q;A����-���3Ih��󤸈�����yq�t `(��XV%�Ĺ`��?��u@�\z*�E�#1�Ն�p���RK�jCj���	qpJ3��s�p��F�N6����zp�y`Z*�z$�AY)xs7�t�"�W��~�ǚ�.�#��
��^\a
<Q#�c4���V��h���s�U�A�\�B7;$ZG�i��+�Lj�#G"�|RV�ƣN��ʎ �ж�PZxHu�	D�ȫ&���s;�,����|�:�[X쁿�#O��q��&bp_<�1�7������.S��v7����<'��;!j��m�9ߩ�z.�_nf3w\\�V0_�T�n��u��wk�w�7w׷O�n"b&e���h�c��Gl_�]Mr�G�m� T�AGU$>��:t�*dɶ��1��BO�#�n<q���nk��������$��xy����i�UR�0��,B���ѽ��o?�A�i/Y�G=h8�}�2�$4dL�z:�����C=b�7aW������NN�1t�v��r�E�D���e�^��q�A���l�4�4g˒��gk�~�����~@(c�!6����lsu��Gl�[<�~�P���?~|*P%n�P��5_�`L3Z�J�~{uR���-U��-�w�Zj�%v1X�Zȡ�~kQ�{��]�>}((��=�u'��)�>)��zr�yi]e=
���pd��H�TG��%�PV�� ��3�-Z7�h������-/����gwP0 y��6�
���̳��;�?�]T�2�����j��FD6vP�z���и�bnn������d=k��!z�_�7o��9>��ׇ���z��@�vS0��՚��>ݍ�:�ɒ]��	ն��7�;�
,�����I�[��1��ẑt��4,�I���0���a/������ċՀB��@�e�3�d�#x�\�[�N-�Ԍ�앍���{F����7Wƚ�2f�X軔�UV����:f�_ծp��G�7NӋ��S�Q#��u���Eb��Ն�E"O�;j1g3'���DB�"��~���M@cIU����1��oو@�^x�����Ϩ��dh�<˸�|I̦uo1��\�D�������щ6�0�oj{x_���X�mڹj���N�ӓ��K���Ӡ��N�Gbm3������q����Кnd�䗀�U���ư�?��VfW��ɥ�)�Ҩ�H�9���$�G�Ұ�����nG�jy¥r�):#N밻�T�t�9c���ObQ�k��s�z�NB���������������-����9��΋bT$y���,���#t�p`�!tr�r�p�.�i���L���y�h���a1*Zʕ\RQ،�*�)
Y�!kV���N�x��ԚɆ����p�����i<�ά��SF� JU�G�H�@������Ѝ����(܎B�j7�ǵ�����f��
K&p��*�D���~Nb��KA#�K���N�Z���qBP5�˗�G�\��M!��F*���b�|a��Q$�<>�$���Nh�8/q'tm�p�KP8����)b	��V�R�z�{b#Of-ь�rk��*k4�5 6u��]J���^Fv�0j��#��3���n�wDa�_�6�B�W�?�1Yj���_���V7KF���R5H�:+$U�YQE[vX��vV�ji��x��X�����T������}tR��,hXQh���	Bio9��Z��m��@Bq.I0��^�����v����RIY�]�����?@�l�:�\����	д�w�1�[�����k���g.�كw � A  ���)5ث�@�|Ɣv�*�xS�E��ڏ7�)��%�PKAH�J�v��������i�E#j��88����]���I�?c�m��Ξڛ�L�B2L�.S*�Q�n��`��q݆�.�nP�nZ&D0��o�OC?^�z���ߕ$b��k�����Z��d�$s��٤U�>#3�+Tm�dN�����h�E��|X���1�p�^�y��9�}�@SpJX�id�O�FqMi��'�g�o��A@{?�*:I���)�|j�O5�Χh�X_�6�\R��B�BGB�8�W�H8 V����]�m�����< @<�����d��I���qD�aR�9\�������<~�u\e=��@G��<t����Yfx�l�_�b/-N딙�N��E
RZ$�ipQ��3�BNć�}����"�s��� ����9@��9����o��R(#d�;�$�lT��0���2*�#�:�z��]�Y���
d�� ;��B0Q���:���#>�*�3���F�՞���c��F�VH]/��^~\?�L�_��=Mn������z֑)J!��4ۮEW�F]�Da-C�cw�̛N����>4�ǵ���K::�*�D�������=��L`D����ڸ�~��W�$QacIҰ+8Q#h�1�Ŗ;�墰GF�� ��Z�8���%+\O-gV*����������u.�:X�#1K]Xݡ!47�l�VA4>�v;DfBK���-*��E!�!�'��*��b/�JO��0.Z�d�q��������ۧ��~'ǳv8$���ɥ0���+�릷<�²�=�p9a@�@�0ͬĹ]֫6�v�'#���GY�Bu����7YV���Cx̥��jwx̭�AC�K��n���,$R�,��z8ɭǆlh>h".��gab����,ɐ�����8K]/����Ԕ$����Rwx)EG����I�I�A�$:�,#0Y���P�
��
]�������b�l�9�Ș8R�����Ӧ�@s�1E�Fܼ(��U�N�����u�zF�'���w�Ǘ���}�}^�KW�����](�Jz��v�&sx��&��(��@{(>��{{dC�Q���/���i��������Z�X,���ЃM�r�+ئ��6 Nc�#�7�`�� ��$�0�����s<F:�j���$�3\��p|����F6�k��r����s���CZ��N7]����3-���G zTrI54I@_^��[��.��T��R����X�5�P�␍�/�JzB��Rn� �(�U�A�A�ƙn�OFm���u�wu���^�[�Y!ڔM{������Uˀt �r�M�$Z�ʰ��h,ajb ���)�����ǟ�'
�v�ڤt�x���3*�kS�@wƣIi8kI-���C��x��w�TgD���Ru�CC��y0�4�*SZ��rM\�!�*Q�*�;d�*L�Tkh�'<�^O�\O6�i5s��d�b*��k [*c��m��$��c��# Z"c�FU�}�୔N���a͑u��go<���]���Vg��S�fe.��\o
Qv���k�����k���o��`Kl��&q�;.g��>��	>9x�j���GW�8cI���[��)�kr��N���*��I��*��,*��[�V��J2*
���ޖV؆J#"��P4XK����nK2,�Xb���/W�������1Uh!�D�g8Q����?יaL=��X�`=�!��`�11����}Q_��:�a~�	{Z#�`�I;(��P���%�&?�8M��o �~-�q:)�z����x}��D
�X�}?���҅��i|?ms��Q`R�ѷ�7aã���}_X�0���4�#��3����vq��3,q���δ6��^s^
�-4�����5ӌ�N���H3��/x�{��08S�Y���^x�3�����̆���N��L��o�&J��t(��$#׳�f��1�y�S:v��Hb�(p` \l҈�6�_���o^�l$pƩ0v�|��Z����?�a��}�f
�R�<g�t�*4Q:�&�j�]����1v�9ߐ'W��c����(��i�+��gv'�S�5��G �[�(��ݺ��9�EP��&�2�$hKI��)	�:���;�-a�m�F�j�ۖ��	a	�0�6"ٳ��c�W� ��g���~�f�`�׍kD㷄spa;T�j��nۀۻ 
 �nߴ4m�F
�CQ��K����zgG薰�Q�sE��f����R�z&b�i�`���&a��}�ڳ��@pψ������M1T��lv3���IQҀdN�R�%y�]c��ρ_�u>�֐Z!�d��Ҳ�"��p��RHR:�gtB睬�̳v�~����P����:�>��B�ɬC��üO�j7��[�Q�1��X��Nl��@�+�[���q%�W�y�rG��h�t�o�u���֏�*�mqC>�1o��-įKdW��;���mv�f*�.�s��]sت�s�;�<;^��p0�p�#%ȥV̏� �8l	<~�z_�"�E�w��U�]���N�\!|�c/�*M�ԣ�Ϳ�+l38��������B.Eںq<�o�ˢV��R.��F����涪j�#���=�7�]���Z/���b�i�x�H�^�V"Q^�l/�誳n��:���H�O�7a�7�m$�!��\
�K
H��B�F��0vWZ��Z#<^��C�����v"���#Ɉa���G��t���m|<d����zY�89�,�#'���ЬF~�[�s�J|��S"
�-
����짟~���7Ia      �      x������ � �      �   �   x�e�Q�0D��S�	����g�L��]�Ʋ%K!r{������f�E�IOaF�T�ғd�>a�ohh7����a$u�h.J�3�̉T����a�,cv�H�mR27}�*y♂k5�%|��:I���^�L*aL�z��ߖ��r���i�JK���xsF����>	-ߎ��q�3o�͑�콲־ Ƀt8      �   ,   x�3�tK,�U�MM�H��,N,����2��J�rS22�b���� ��      �   5   x�3��/-JMNU0�2������lc.8ۄ��6�2��͸��ls�=... �{�      �   �   x�]�K
�0���=��
�7m�ґ�%��B��~Ӂ���|p�����~������F�3�l}�P/����p,�L� �G/j�P� �p`b��)���-&?����嫎4�%Dէ��!��q?� hhQj      �   /   x��J�I��L���􂱸��r�sS�3���Ē��<N7_�=... �x�      �   3   x�3�I�PHK-I�PH+��U�,I͍/(�LN��M,P(IL�I����� E�      �      x��}YoG����_L䞕on��vʠ��b�r%�b7.����/����H�m� {�U�y"N������_�O���I1Te|L����FeaBV��� [���T��CiY��\+���S����|���ś���]�m������\��.�l.����n�/7Xp�?3����ׯ�W������9o�6Q(�h{���Ň�ņVyo6�7�o����]��|b��߼����x��n.�\��:߰?`{�n.�i�w��׆ɍ�� �Z��6~��y��GKq���ͫW������Ŝ��X~ޜzw���`�
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