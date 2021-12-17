PGDMP                     
    y            oaic    13.2    13.3 ;   �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            �           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            �           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            �           1262    16384    oaic    DATABASE     Y   CREATE DATABASE oaic WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'en_IN.UTF-8';
    DROP DATABASE oaic;
                postgres    false            "           1255    24778    UpdateDeliveredQuantity()    FUNCTION     �  CREATE FUNCTION public."UpdateDeliveredQuantity"() RETURNS trigger
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
       public          postgres    false            !           1255    24593    update_invoice_number()    FUNCTION     R  CREATE FUNCTION public.update_invoice_number() RETURNS trigger
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
       public          postgres    false                        1255    24595    update_mrr_id()    FUNCTION     �  CREATE FUNCTION public.update_mrr_id() RETURNS trigger
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
       public          postgres    false                       1255    24596    update_order_po_intiate()    FUNCTION     �   CREATE FUNCTION public.update_order_po_intiate() RETURNS trigger
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
       public          postgres    false            �            1259    16385    AccountantMaster    TABLE     k  CREATE TABLE public."AccountantMaster" (
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
       public         heap    postgres    false                       1259    24688    CustomerBankAccount    TABLE     :  CREATE TABLE public."CustomerBankAccount" (
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
       public         heap    postgres    false                       1259    24686    CustomerBankAccount_id_seq    SEQUENCE     �   CREATE SEQUENCE public."CustomerBankAccount_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 3   DROP SEQUENCE public."CustomerBankAccount_id_seq";
       public          postgres    false    276            �           0    0    CustomerBankAccount_id_seq    SEQUENCE OWNED BY     ]   ALTER SEQUENCE public."CustomerBankAccount_id_seq" OWNED BY public."CustomerBankAccount".id;
          public          postgres    false    275                       1259    24661    CustomerContactPerson    TABLE     �  CREATE TABLE public."CustomerContactPerson" (
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
       public         heap    postgres    false                       1259    24659    CustomerContactPerson_id_seq    SEQUENCE     �   CREATE SEQUENCE public."CustomerContactPerson_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 5   DROP SEQUENCE public."CustomerContactPerson_id_seq";
       public          postgres    false    272            �           0    0    CustomerContactPerson_id_seq    SEQUENCE OWNED BY     a   ALTER SEQUENCE public."CustomerContactPerson_id_seq" OWNED BY public."CustomerContactPerson".id;
          public          postgres    false    271                       1259    24757    CustomerDistrictMapping    TABLE     �   CREATE TABLE public."CustomerDistrictMapping" (
    "CustomerID" character varying(255) NOT NULL,
    "DistrictID" character varying(255) NOT NULL,
    "InsertedDate" timestamp with time zone NOT NULL
);
 -   DROP TABLE public."CustomerDistrictMapping";
       public         heap    postgres    false                       1259    24781    CustomerInvoiceMaster    TABLE     n  CREATE TABLE public."CustomerInvoiceMaster" (
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
       public         heap    postgres    false                       1259    24581    DivisionMaster    TABLE     �   CREATE TABLE public."DivisionMaster" (
    "DivisionID" character varying(255) NOT NULL,
    "DivisionName" character varying(255) NOT NULL
);
 $   DROP TABLE public."DivisionMaster";
       public         heap    postgres    false                       1259    24810    CustomerInvoiceViews    VIEW     
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
       public          postgres    false    283    283    283    283    283    283    283    283    283    283    283    283    283    283    283    283    283    283    283    283    283    283    283    283    283    283    283    283    283    283    283    283    283    283    283    283    283    283    283    283    283    283    283    283    283    283    283    283    264    264                       1259    24698    customer_id_increment    SEQUENCE     ~   CREATE SEQUENCE public.customer_id_increment
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE public.customer_id_increment;
       public          postgres    false                       1259    24650    CustomerMaster    TABLE     /  CREATE TABLE public."CustomerMaster" (
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
       public         heap    postgres    false    277                       1259    24648    CustomerMaster_id_seq    SEQUENCE     �   CREATE SEQUENCE public."CustomerMaster_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public."CustomerMaster_id_seq";
       public          postgres    false    270            �           0    0    CustomerMaster_id_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE public."CustomerMaster_id_seq" OWNED BY public."CustomerMaster".id;
          public          postgres    false    269                       1259    24672    CustomerPrincipalPlace    TABLE     �  CREATE TABLE public."CustomerPrincipalPlace" (
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
       public         heap    postgres    false                       1259    24670    CustomerPrincipalPlace_id_seq    SEQUENCE     �   CREATE SEQUENCE public."CustomerPrincipalPlace_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 6   DROP SEQUENCE public."CustomerPrincipalPlace_id_seq";
       public          postgres    false    274            �           0    0    CustomerPrincipalPlace_id_seq    SEQUENCE OWNED BY     c   ALTER SEQUENCE public."CustomerPrincipalPlace_id_seq" OWNED BY public."CustomerPrincipalPlace".id;
          public          postgres    false    273            �            1259    16434    DMMaster    TABLE       CREATE TABLE public."DMMaster" (
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
       public         heap    postgres    false            �            1259    16419    DistrictMaster    TABLE     �   CREATE TABLE public."DistrictMaster" (
    dist_id character varying(2) NOT NULL,
    dist_name character varying(20),
    "DistCode" character varying
);
 $   DROP TABLE public."DistrictMaster";
       public         heap    postgres    false                       1259    24724    InvoiceMaster    TABLE     G  CREATE TABLE public."InvoiceMaster" (
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
       public         heap    postgres    false            �            1259    16467 
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
       public         heap    postgres    false                       1259    24737    ItemPackageMaster    TABLE     @  CREATE TABLE public."ItemPackageMaster" (
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
       public         heap    postgres    false                       1259    24750    ItemPackageSizeMaster    TABLE     s   CREATE TABLE public."ItemPackageSizeMaster" (
    id integer NOT NULL,
    "PackageSize" character varying(255)
);
 +   DROP TABLE public."ItemPackageSizeMaster";
       public         heap    postgres    false                       1259    24748    ItemPackageSizeMaster_id_seq    SEQUENCE     �   CREATE SEQUENCE public."ItemPackageSizeMaster_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 5   DROP SEQUENCE public."ItemPackageSizeMaster_id_seq";
       public          postgres    false    281            �           0    0    ItemPackageSizeMaster_id_seq    SEQUENCE OWNED BY     a   ALTER SEQUENCE public."ItemPackageSizeMaster_id_seq" OWNED BY public."ItemPackageSizeMaster".id;
          public          postgres    false    280                       1259    24628 	   MRRMaster    TABLE     K  CREATE TABLE public."MRRMaster" (
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
       public         heap    postgres    false            	           1259    24597    POMaster    TABLE     r  CREATE TABLE public."POMaster" (
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
       public         heap    postgres    false                       1259    24794    MRRViews    VIEW     �  CREATE VIEW public."MRRViews" AS
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
       public          postgres    false    265    265    264    264    265    265    265    265    265    265    265    265    265    265    265    265    268    268    268    268    268    265    265    265    265    265    265    265    268    268    268    268    268    268    268    268    265    265    265    265    265    265    265    268    268    268    278    265    265    265    265    265    265    265    265    265    268    265    268    265                       1259    24616    NonSubsidyPODetails    TABLE       CREATE TABLE public."NonSubsidyPODetails" (
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
       public         heap    postgres    false            
           1259    24614    NonSubsidyPODetails_id_seq    SEQUENCE     �   CREATE SEQUENCE public."NonSubsidyPODetails_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 3   DROP SEQUENCE public."NonSubsidyPODetails_id_seq";
       public          postgres    false    267            �           0    0    NonSubsidyPODetails_id_seq    SEQUENCE OWNED BY     ]   ALTER SEQUENCE public."NonSubsidyPODetails_id_seq" OWNED BY public."NonSubsidyPODetails".id;
          public          postgres    false    266            �            1259    16793    StateMaster    TABLE     y   CREATE TABLE public."StateMaster" (
    "StateCode" integer NOT NULL,
    "StateName" character varying(255) NOT NULL
);
 !   DROP TABLE public."StateMaster";
       public         heap    postgres    false                       1259    24815    StockMaster    VIEW     Q  CREATE VIEW public."StockMaster" AS
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
       public          postgres    false    285    285    285    284    284    284    284    285    285    285    285    285    284    284    284    284    284    284                       1259    16953    VendorBankAccount    TABLE     j  CREATE TABLE public."VendorBankAccount" (
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
       public         heap    postgres    false                       1259    16951 #   VendorBankAccount_BankAccountID_seq    SEQUENCE     �   CREATE SEQUENCE public."VendorBankAccount_BankAccountID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 <   DROP SEQUENCE public."VendorBankAccount_BankAccountID_seq";
       public          postgres    false    260                        0    0 #   VendorBankAccount_BankAccountID_seq    SEQUENCE OWNED BY     q   ALTER SEQUENCE public."VendorBankAccount_BankAccountID_seq" OWNED BY public."VendorBankAccount"."BankAccountID";
          public          postgres    false    259                        1259    16916    VendorContactPerson    TABLE     �  CREATE TABLE public."VendorContactPerson" (
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
       public         heap    postgres    false            �            1259    16914 '   VendorContactPerson_ContactPersonID_seq    SEQUENCE     �   CREATE SEQUENCE public."VendorContactPerson_ContactPersonID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 @   DROP SEQUENCE public."VendorContactPerson_ContactPersonID_seq";
       public          postgres    false    256                       0    0 '   VendorContactPerson_ContactPersonID_seq    SEQUENCE OWNED BY     y   ALTER SEQUENCE public."VendorContactPerson_ContactPersonID_seq" OWNED BY public."VendorContactPerson"."ContactPersonID";
          public          postgres    false    255                       1259    16980    VendorDistrictMapping    TABLE     �   CREATE TABLE public."VendorDistrictMapping" (
    "VendorID" character varying(255) NOT NULL,
    "DistrictID" character varying(255) NOT NULL,
    "InsertedDate" timestamp with time zone NOT NULL
);
 +   DROP TABLE public."VendorDistrictMapping";
       public         heap    postgres    false            �            1259    16903    VendorMaster    TABLE       CREATE TABLE public."VendorMaster" (
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
       public         heap    postgres    false                       1259    16932    VendorPrincipalPlace    TABLE     �  CREATE TABLE public."VendorPrincipalPlace" (
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
       public         heap    postgres    false                       1259    16930 )   VendorPrincipalPlace_PrincipalPlaceID_seq    SEQUENCE     �   CREATE SEQUENCE public."VendorPrincipalPlace_PrincipalPlaceID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 B   DROP SEQUENCE public."VendorPrincipalPlace_PrincipalPlaceID_seq";
       public          postgres    false    258                       0    0 )   VendorPrincipalPlace_PrincipalPlaceID_seq    SEQUENCE OWNED BY     }   ALTER SEQUENCE public."VendorPrincipalPlace_PrincipalPlaceID_seq" OWNED BY public."VendorPrincipalPlace"."PrincipalPlaceID";
          public          postgres    false    257                       1259    16967    VendorServices    TABLE     �   CREATE TABLE public."VendorServices" (
    "VendorID" character varying(255) NOT NULL,
    "Service" character varying(255) NOT NULL,
    "InsertedDate" timestamp with time zone NOT NULL,
    "InsertedBy" character varying(255) NOT NULL
);
 $   DROP TABLE public."VendorServices";
       public         heap    postgres    false            �            1259    16388    approval    TABLE     H  CREATE TABLE public.approval (
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
       public         heap    postgres    false            �            1259    16394    approval_desc    TABLE     �   CREATE TABLE public.approval_desc (
    approval_id character varying(30) NOT NULL,
    permit_no character varying(50) NOT NULL,
    serial integer NOT NULL,
    mrr_id character varying
);
 !   DROP TABLE public.approval_desc;
       public         heap    postgres    false            �            1259    16400    approval_desc_serial_seq    SEQUENCE     �   CREATE SEQUENCE public.approval_desc_serial_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 /   DROP SEQUENCE public.approval_desc_serial_seq;
       public          postgres    false    202                       0    0    approval_desc_serial_seq    SEQUENCE OWNED BY     U   ALTER SEQUENCE public.approval_desc_serial_seq OWNED BY public.approval_desc.serial;
          public          postgres    false    203            �            1259    16402    approval_status_desc    TABLE     ~   CREATE TABLE public.approval_status_desc (
    status_id character varying(50) NOT NULL,
    "desc" character varying(100)
);
 (   DROP TABLE public.approval_status_desc;
       public         heap    postgres    false            �            1259    16405 
   components    TABLE     �   CREATE TABLE public.components (
    comp_id character varying(10) NOT NULL,
    schema_id character varying(10),
    comp_name character varying(30)
);
    DROP TABLE public.components;
       public         heap    postgres    false            �            1259    16408    dept_expenditure_payment_desc    TABLE     �  CREATE TABLE public.dept_expenditure_payment_desc (
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
       public         heap    postgres    false            �            1259    16411    govt_share_config    TABLE     �   CREATE TABLE public.govt_share_config (
    sl integer NOT NULL,
    fin_year character varying(10),
    head character varying(30),
    govt_share_ammount integer
);
 %   DROP TABLE public.govt_share_config;
       public         heap    postgres    false            �            1259    16414    dept_money_config_sl_seq    SEQUENCE     �   CREATE SEQUENCE public.dept_money_config_sl_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 /   DROP SEQUENCE public.dept_money_config_sl_seq;
       public          postgres    false    207                       0    0    dept_money_config_sl_seq    SEQUENCE OWNED BY     U   ALTER SEQUENCE public.dept_money_config_sl_seq OWNED BY public.govt_share_config.sl;
          public          postgres    false    208            �            1259    16437    farmer_receipt    TABLE     S  CREATE TABLE public.farmer_receipt (
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
       public         heap    postgres    false            �            1259    16440    farmer_receipts_sl_no_seq    SEQUENCE     �   CREATE SEQUENCE public.farmer_receipts_sl_no_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 0   DROP SEQUENCE public.farmer_receipts_sl_no_seq;
       public          postgres    false    211                       0    0    farmer_receipts_sl_no_seq    SEQUENCE OWNED BY     V   ALTER SEQUENCE public.farmer_receipts_sl_no_seq OWNED BY public.farmer_receipt.sl_no;
          public          postgres    false    212            �            1259    16442    head_master    TABLE     u   CREATE TABLE public.head_master (
    head_id character varying(10) NOT NULL,
    head_name character varying(30)
);
    DROP TABLE public.head_master;
       public         heap    postgres    false                       1259    16998    indent    TABLE     �  CREATE TABLE public.indent (
    indent_no character varying(255) NOT NULL,
    "PONo" character varying(255) NOT NULL,
    fin_year character varying(255),
    "FinYear" character varying(255),
    dist_id character varying(255),
    "DistrictID" character varying(255),
    "DMID" character varying(255),
    "AccID" character varying(255),
    dl_id character varying(255),
    "VendorID" character varying(255),
    "PermitNumber" character varying(255),
    "FarmerID" character varying(255),
    items character varying(255) DEFAULT 1,
    "POAmount" character varying(255),
    indent_ammount character varying(255),
    status character varying(255) DEFAULT 'indentInitiated'::character varying,
    "Status" character varying(255) DEFAULT 'indentInitiated'::character varying,
    indent_date timestamp with time zone,
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
    "CustomerID" character varying,
    "POType" character varying,
    " CustomerID" character varying,
    "VendorInvoiceNo" character varying,
    "MRRID" character varying
);
    DROP TABLE public.indent;
       public         heap    postgres    false            �            1259    16448    indent_desc    TABLE     �   CREATE TABLE public.indent_desc (
    indent_no character varying(30) NOT NULL,
    permit_no character varying(50) NOT NULL
);
    DROP TABLE public.indent_desc;
       public         heap    postgres    false            �            1259    16445 
   indent_old    TABLE     x  CREATE TABLE public.indent_old (
    sl_no integer NOT NULL,
    indent_no character varying(50) NOT NULL,
    dist_id character varying(2),
    indent_date timestamp without time zone,
    dl_id character varying(50),
    fin_year character varying(10),
    status character varying(30),
    items integer,
    indent_ammount integer,
    "accountantID" character varying
);
    DROP TABLE public.indent_old;
       public         heap    postgres    false            �            1259    16451    indents_sl_no_seq    SEQUENCE     �   CREATE SEQUENCE public.indents_sl_no_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE public.indents_sl_no_seq;
       public          postgres    false    214                       0    0    indents_sl_no_seq    SEQUENCE OWNED BY     J   ALTER SEQUENCE public.indents_sl_no_seq OWNED BY public.indent_old.sl_no;
          public          postgres    false    216            �            1259    16453    invoice    TABLE     ]  CREATE TABLE public.invoice (
    sl_no integer NOT NULL,
    invoice_no character varying(30) NOT NULL,
    invoice_date timestamp without time zone,
    rr_way_bill_no character varying(30),
    wagon_truck_no character varying(30),
    challan_no character varying(30),
    challan_date date,
    fin_year character varying(10),
    dist_id character varying(2),
    dl_id character varying(50),
    bill_no character varying(10),
    bill_date date,
    status character varying(30) DEFAULT 'notReceived'::character varying,
    rr_way_bill_date date,
    discount character varying(10),
    indent_no character varying(30),
    payment_status character varying(30) DEFAULT 'pending'::character varying,
    items integer,
    invoice_ammount numeric(100,10),
    invoice_path character varying(270),
    gst_rate integer,
    "POType" character varying
);
    DROP TABLE public.invoice;
       public         heap    postgres    false            �            1259    16459    invoice_desc    TABLE     �   CREATE TABLE public.invoice_desc (
    invoice_no character varying(30) NOT NULL,
    permit_no character varying(50) NOT NULL
);
     DROP TABLE public.invoice_desc;
       public         heap    postgres    false            �            1259    16462    invoice_sl_no_seq    SEQUENCE     �   CREATE SEQUENCE public.invoice_sl_no_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE public.invoice_sl_no_seq;
       public          postgres    false    217                       0    0    invoice_sl_no_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE public.invoice_sl_no_seq OWNED BY public.invoice.sl_no;
          public          postgres    false    219            �            1259    16473 !   jalanidhi_dept_expnd_payment_desc    TABLE     �   CREATE TABLE public.jalanidhi_dept_expnd_payment_desc (
    serial integer NOT NULL,
    transaction_id character varying(50),
    scheme_id character varying(10),
    scheme_name character varying(50),
    comp_id character varying(10)
);
 5   DROP TABLE public.jalanidhi_dept_expnd_payment_desc;
       public         heap    postgres    false            �            1259    16476 ,   jalanidhi_dept_expnd_payment_desc_serial_seq    SEQUENCE     �   CREATE SEQUENCE public.jalanidhi_dept_expnd_payment_desc_serial_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 C   DROP SEQUENCE public.jalanidhi_dept_expnd_payment_desc_serial_seq;
       public          postgres    false    221                       0    0 ,   jalanidhi_dept_expnd_payment_desc_serial_seq    SEQUENCE OWNED BY     }   ALTER SEQUENCE public.jalanidhi_dept_expnd_payment_desc_serial_seq OWNED BY public.jalanidhi_dept_expnd_payment_desc.serial;
          public          postgres    false    222            �            1259    16478    jalanidhi_payment_desc    TABLE     N  CREATE TABLE public.jalanidhi_payment_desc (
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
       public         heap    postgres    false            �            1259    16481 !   jalanidhi_payment_desc_serial_seq    SEQUENCE     �   CREATE SEQUENCE public.jalanidhi_payment_desc_serial_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 8   DROP SEQUENCE public.jalanidhi_payment_desc_serial_seq;
       public          postgres    false    223            	           0    0 !   jalanidhi_payment_desc_serial_seq    SEQUENCE OWNED BY     g   ALTER SEQUENCE public.jalanidhi_payment_desc_serial_seq OWNED BY public.jalanidhi_payment_desc.serial;
          public          postgres    false    224            �            1259    16483    jn_expenditure_desc    TABLE     �   CREATE TABLE public.jn_expenditure_desc (
    transaction_id character varying(70) NOT NULL,
    item_name character varying(50) NOT NULL,
    item_price numeric(10,5) NOT NULL,
    quantity integer NOT NULL,
    serial integer NOT NULL
);
 '   DROP TABLE public.jn_expenditure_desc;
       public         heap    postgres    false            �            1259    16486    jn_expenditure_desc_serial_seq    SEQUENCE     �   CREATE SEQUENCE public.jn_expenditure_desc_serial_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 5   DROP SEQUENCE public.jn_expenditure_desc_serial_seq;
       public          postgres    false    225            
           0    0    jn_expenditure_desc_serial_seq    SEQUENCE OWNED BY     a   ALTER SEQUENCE public.jn_expenditure_desc_serial_seq OWNED BY public.jn_expenditure_desc.serial;
          public          postgres    false    226            �            1259    16488 	   jn_orders    TABLE     ~  CREATE TABLE public.jn_orders (
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
       public         heap    postgres    false            �            1259    16491    jn_stock    TABLE     �  CREATE TABLE public.jn_stock (
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
       public         heap    postgres    false            �            1259    16497    lgd_block_master    TABLE     �   CREATE TABLE public.lgd_block_master (
    dist_code character varying(500),
    block_code character varying(20) NOT NULL,
    block_name character varying(200)
);
 $   DROP TABLE public.lgd_block_master;
       public         heap    postgres    false            �            1259    16503    lgd_dist_master    TABLE     |   CREATE TABLE public.lgd_dist_master (
    dist_code character varying(20) NOT NULL,
    dist_name character varying(200)
);
 #   DROP TABLE public.lgd_dist_master;
       public         heap    postgres    false            �            1259    16506    lgd_gp_master    TABLE     �   CREATE TABLE public.lgd_gp_master (
    dist_code character varying(20),
    block_code character varying(20),
    gp_code character varying(20) NOT NULL,
    gp_name character varying(100)
);
 !   DROP TABLE public.lgd_gp_master;
       public         heap    postgres    false            �            1259    16509    log    TABLE     �  CREATE TABLE public.log (
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
       public         heap    postgres    false            �            1259    16515    log_sl_no_seq    SEQUENCE     �   CREATE SEQUENCE public.log_sl_no_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 $   DROP SEQUENCE public.log_sl_no_seq;
       public          postgres    false    232                       0    0    log_sl_no_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE public.log_sl_no_seq OWNED BY public.log.sl_no;
          public          postgres    false    233            �            1259    16517    mrr    TABLE     g  CREATE TABLE public.mrr (
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
       public         heap    postgres    false            �            1259    16520    mrr_desc    TABLE     z   CREATE TABLE public.mrr_desc (
    mrr_id character varying(30) NOT NULL,
    permit_no character varying(40) NOT NULL
);
    DROP TABLE public.mrr_desc;
       public         heap    postgres    false            �            1259    16523    mrr_sl_no_seq    SEQUENCE     �   CREATE SEQUENCE public.mrr_sl_no_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 $   DROP SEQUENCE public.mrr_sl_no_seq;
       public          postgres    false    234                       0    0    mrr_sl_no_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE public.mrr_sl_no_seq OWNED BY public.mrr.sl_no;
          public          postgres    false    236            �            1259    16525    new_item_price    TABLE     ?  CREATE TABLE public.new_item_price (
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
       public         heap    postgres    false            �            1259    16531    opening_balance    TABLE     e  CREATE TABLE public.opening_balance (
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
       public         heap    postgres    false            �            1259    16537    orders    TABLE     �  CREATE TABLE public.orders (
    permit_no character varying(50) NOT NULL,
    permit_issue_date timestamp without time zone,
    permit_validity timestamp without time zone,
    farmer_id character varying(30),
    farmer_name character varying(30),
    farmer_father_name character varying(30),
    dist_name character varying(30),
    block_name character varying(30),
    gp_name character varying(30),
    village_name character varying(30),
    implement character varying(30),
    make character varying(30),
    model character varying(50),
    status character varying(30),
    permit_validity_1 character varying(30),
    permit_issue_date_1 character varying(30),
    fin_year character varying(30),
    dist_id character varying(2),
    engine_no character varying(30),
    chassic_no character varying(30),
    ammount integer,
    remark character varying(100),
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
       public         heap    postgres    false            �            1259    16543    payment    TABLE     �  CREATE TABLE public.payment (
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
    "Implement" character varying
);
    DROP TABLE public.payment;
       public         heap    postgres    false            �            1259    16546    payment1_sl_no_seq    SEQUENCE     �   CREATE SEQUENCE public.payment1_sl_no_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.payment1_sl_no_seq;
       public          postgres    false    240                       0    0    payment1_sl_no_seq    SEQUENCE OWNED BY     H   ALTER SEQUENCE public.payment1_sl_no_seq OWNED BY public.payment.sl_no;
          public          postgres    false    241            �            1259    16548    payment_desc    TABLE     �   CREATE TABLE public.payment_desc (
    transaction_id character varying(70) NOT NULL,
    reference_no character varying(70) NOT NULL
);
     DROP TABLE public.payment_desc;
       public         heap    postgres    false            �            1259    16551    payment_desc_2_sl_no_seq    SEQUENCE     �   CREATE SEQUENCE public.payment_desc_2_sl_no_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 /   DROP SEQUENCE public.payment_desc_2_sl_no_seq;
       public          postgres    false    206                       0    0    payment_desc_2_sl_no_seq    SEQUENCE OWNED BY     d   ALTER SEQUENCE public.payment_desc_2_sl_no_seq OWNED BY public.dept_expenditure_payment_desc.sl_no;
          public          postgres    false    243            �            1259    16553    payment_invoice_sl_no_seq    SEQUENCE     �   CREATE SEQUENCE public.payment_invoice_sl_no_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 0   DROP SEQUENCE public.payment_invoice_sl_no_seq;
       public          postgres    false    201                       0    0    payment_invoice_sl_no_seq    SEQUENCE OWNED BY     P   ALTER SEQUENCE public.payment_invoice_sl_no_seq OWNED BY public.approval.sl_no;
          public          postgres    false    244            �            1259    16555    payment_purpose_desc    TABLE        CREATE TABLE public.payment_purpose_desc (
    purpose_id character varying(50) NOT NULL,
    "desc" character varying(100)
);
 (   DROP TABLE public.payment_purpose_desc;
       public         heap    postgres    false            �            1259    16558    schem_master    TABLE     x   CREATE TABLE public.schem_master (
    schem_id character varying(10) NOT NULL,
    schem_name character varying(30)
);
     DROP TABLE public.schem_master;
       public         heap    postgres    false            �            1259    16561    source_master    TABLE     {   CREATE TABLE public.source_master (
    source_id character varying(10) NOT NULL,
    source_name character varying(30)
);
 !   DROP TABLE public.source_master;
       public         heap    postgres    false            �            1259    16564    subheads    TABLE     �   CREATE TABLE public.subheads (
    subhead_id character varying(10) NOT NULL,
    head_id character varying(10),
    subhead_name character varying(30)
);
    DROP TABLE public.subheads;
       public         heap    postgres    false            �            1259    16567    system_desc    TABLE     u   CREATE TABLE public.system_desc (
    system_id character varying(50) NOT NULL,
    "desc" character varying(100)
);
    DROP TABLE public.system_desc;
       public         heap    postgres    false            �            1259    16570 
   tax_config    TABLE     r   CREATE TABLE public.tax_config (
    tax_mode character varying(2) NOT NULL,
    "desc" character varying(100)
);
    DROP TABLE public.tax_config;
       public         heap    postgres    false            �            1259    16573    users    TABLE     �   CREATE TABLE public.users (
    user_id character varying(225) NOT NULL,
    password character varying(300),
    role character varying(20)
);
    DROP TABLE public.users;
       public         heap    postgres    false            �            1259    16576    vender_master    TABLE     '  CREATE TABLE public.vender_master (
    "VendorId" character varying(5) NOT NULL,
    "VendorRegNo" character varying(150),
    "DateOfReg" character varying(150),
    "Name" character varying(150),
    "FarmName" character varying(200),
    "IsVerified" character varying(200),
    "IsReject" character varying(200),
    "RejectRemarkStausId" character varying(200),
    "UserName" character varying(200),
    "Password" character varying(300),
    "Type" character varying(200),
    "IPAddress" character varying(200),
    "FinancialYear" character varying(200),
    "UpdatedOn" character varying(200),
    "UpdatedBy" character varying(200),
    "DeletedOn" character varying(200),
    "DeletedBy" character varying(200),
    "IsUpdated" character varying(200),
    "IsDeleted" character varying(200)
);
 !   DROP TABLE public.vender_master;
       public         heap    postgres    false            }           2604    24691    CustomerBankAccount id    DEFAULT     �   ALTER TABLE ONLY public."CustomerBankAccount" ALTER COLUMN id SET DEFAULT nextval('public."CustomerBankAccount_id_seq"'::regclass);
 G   ALTER TABLE public."CustomerBankAccount" ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    276    275    276            {           2604    24664    CustomerContactPerson id    DEFAULT     �   ALTER TABLE ONLY public."CustomerContactPerson" ALTER COLUMN id SET DEFAULT nextval('public."CustomerContactPerson_id_seq"'::regclass);
 I   ALTER TABLE public."CustomerContactPerson" ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    272    271    272            y           2604    24653    CustomerMaster id    DEFAULT     z   ALTER TABLE ONLY public."CustomerMaster" ALTER COLUMN id SET DEFAULT nextval('public."CustomerMaster_id_seq"'::regclass);
 B   ALTER TABLE public."CustomerMaster" ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    269    270    270            |           2604    24675    CustomerPrincipalPlace id    DEFAULT     �   ALTER TABLE ONLY public."CustomerPrincipalPlace" ALTER COLUMN id SET DEFAULT nextval('public."CustomerPrincipalPlace_id_seq"'::regclass);
 J   ALTER TABLE public."CustomerPrincipalPlace" ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    274    273    274            �           2604    24753    ItemPackageSizeMaster id    DEFAULT     �   ALTER TABLE ONLY public."ItemPackageSizeMaster" ALTER COLUMN id SET DEFAULT nextval('public."ItemPackageSizeMaster_id_seq"'::regclass);
 I   ALTER TABLE public."ItemPackageSizeMaster" ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    281    280    281            t           2604    24619    NonSubsidyPODetails id    DEFAULT     �   ALTER TABLE ONLY public."NonSubsidyPODetails" ALTER COLUMN id SET DEFAULT nextval('public."NonSubsidyPODetails_id_seq"'::regclass);
 G   ALTER TABLE public."NonSubsidyPODetails" ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    266    267    267            c           2604    16956    VendorBankAccount BankAccountID    DEFAULT     �   ALTER TABLE ONLY public."VendorBankAccount" ALTER COLUMN "BankAccountID" SET DEFAULT nextval('public."VendorBankAccount_BankAccountID_seq"'::regclass);
 R   ALTER TABLE public."VendorBankAccount" ALTER COLUMN "BankAccountID" DROP DEFAULT;
       public          postgres    false    260    259    260            a           2604    16919 #   VendorContactPerson ContactPersonID    DEFAULT     �   ALTER TABLE ONLY public."VendorContactPerson" ALTER COLUMN "ContactPersonID" SET DEFAULT nextval('public."VendorContactPerson_ContactPersonID_seq"'::regclass);
 V   ALTER TABLE public."VendorContactPerson" ALTER COLUMN "ContactPersonID" DROP DEFAULT;
       public          postgres    false    256    255    256            b           2604    16935 %   VendorPrincipalPlace PrincipalPlaceID    DEFAULT     �   ALTER TABLE ONLY public."VendorPrincipalPlace" ALTER COLUMN "PrincipalPlaceID" SET DEFAULT nextval('public."VendorPrincipalPlace_PrincipalPlaceID_seq"'::regclass);
 X   ALTER TABLE public."VendorPrincipalPlace" ALTER COLUMN "PrincipalPlaceID" DROP DEFAULT;
       public          postgres    false    258    257    258            O           2604    16582    approval sl_no    DEFAULT     w   ALTER TABLE ONLY public.approval ALTER COLUMN sl_no SET DEFAULT nextval('public.payment_invoice_sl_no_seq'::regclass);
 =   ALTER TABLE public.approval ALTER COLUMN sl_no DROP DEFAULT;
       public          postgres    false    244    201            P           2604    16583    approval_desc serial    DEFAULT     |   ALTER TABLE ONLY public.approval_desc ALTER COLUMN serial SET DEFAULT nextval('public.approval_desc_serial_seq'::regclass);
 C   ALTER TABLE public.approval_desc ALTER COLUMN serial DROP DEFAULT;
       public          postgres    false    203    202            Q           2604    16584 #   dept_expenditure_payment_desc sl_no    DEFAULT     �   ALTER TABLE ONLY public.dept_expenditure_payment_desc ALTER COLUMN sl_no SET DEFAULT nextval('public.payment_desc_2_sl_no_seq'::regclass);
 R   ALTER TABLE public.dept_expenditure_payment_desc ALTER COLUMN sl_no DROP DEFAULT;
       public          postgres    false    243    206            S           2604    16585    farmer_receipt sl_no    DEFAULT     }   ALTER TABLE ONLY public.farmer_receipt ALTER COLUMN sl_no SET DEFAULT nextval('public.farmer_receipts_sl_no_seq'::regclass);
 C   ALTER TABLE public.farmer_receipt ALTER COLUMN sl_no DROP DEFAULT;
       public          postgres    false    212    211            R           2604    16586    govt_share_config sl    DEFAULT     |   ALTER TABLE ONLY public.govt_share_config ALTER COLUMN sl SET DEFAULT nextval('public.dept_money_config_sl_seq'::regclass);
 C   ALTER TABLE public.govt_share_config ALTER COLUMN sl DROP DEFAULT;
       public          postgres    false    208    207            T           2604    16587    indent_old sl_no    DEFAULT     q   ALTER TABLE ONLY public.indent_old ALTER COLUMN sl_no SET DEFAULT nextval('public.indents_sl_no_seq'::regclass);
 ?   ALTER TABLE public.indent_old ALTER COLUMN sl_no DROP DEFAULT;
       public          postgres    false    216    214            U           2604    16588    invoice sl_no    DEFAULT     n   ALTER TABLE ONLY public.invoice ALTER COLUMN sl_no SET DEFAULT nextval('public.invoice_sl_no_seq'::regclass);
 <   ALTER TABLE public.invoice ALTER COLUMN sl_no DROP DEFAULT;
       public          postgres    false    219    217            X           2604    16589 (   jalanidhi_dept_expnd_payment_desc serial    DEFAULT     �   ALTER TABLE ONLY public.jalanidhi_dept_expnd_payment_desc ALTER COLUMN serial SET DEFAULT nextval('public.jalanidhi_dept_expnd_payment_desc_serial_seq'::regclass);
 W   ALTER TABLE public.jalanidhi_dept_expnd_payment_desc ALTER COLUMN serial DROP DEFAULT;
       public          postgres    false    222    221            Y           2604    16590    jalanidhi_payment_desc serial    DEFAULT     �   ALTER TABLE ONLY public.jalanidhi_payment_desc ALTER COLUMN serial SET DEFAULT nextval('public.jalanidhi_payment_desc_serial_seq'::regclass);
 L   ALTER TABLE public.jalanidhi_payment_desc ALTER COLUMN serial DROP DEFAULT;
       public          postgres    false    224    223            Z           2604    16591    jn_expenditure_desc serial    DEFAULT     �   ALTER TABLE ONLY public.jn_expenditure_desc ALTER COLUMN serial SET DEFAULT nextval('public.jn_expenditure_desc_serial_seq'::regclass);
 I   ALTER TABLE public.jn_expenditure_desc ALTER COLUMN serial DROP DEFAULT;
       public          postgres    false    226    225            [           2604    16592 	   log sl_no    DEFAULT     f   ALTER TABLE ONLY public.log ALTER COLUMN sl_no SET DEFAULT nextval('public.log_sl_no_seq'::regclass);
 8   ALTER TABLE public.log ALTER COLUMN sl_no DROP DEFAULT;
       public          postgres    false    233    232            \           2604    16593 	   mrr sl_no    DEFAULT     f   ALTER TABLE ONLY public.mrr ALTER COLUMN sl_no SET DEFAULT nextval('public.mrr_sl_no_seq'::regclass);
 8   ALTER TABLE public.mrr ALTER COLUMN sl_no DROP DEFAULT;
       public          postgres    false    236    234            ]           2604    16594    payment sl_no    DEFAULT     o   ALTER TABLE ONLY public.payment ALTER COLUMN sl_no SET DEFAULT nextval('public.payment1_sl_no_seq'::regclass);
 <   ALTER TABLE public.payment ALTER COLUMN sl_no DROP DEFAULT;
       public          postgres    false    241    240            �          0    16385    AccountantMaster 
   TABLE DATA           �   COPY public."AccountantMaster" (acc_name, acc_id, dist_id, dist_name, acc_address, acc_mobile_no, "UpdateOn", "UpdateBy") FROM stdin;
    public          postgres    false    200   ^      �          0    24688    CustomerBankAccount 
   TABLE DATA           �   COPY public."CustomerBankAccount" (id, "CustomerID", "BankAccountID", "bankAccountNo", "accountType", "bankName", "branchName", "ifscCode", "InsertedDate", "InsertedBy", "UpdatedDate", "UpdatedBy") FROM stdin;
    public          postgres    false    276   [      �          0    24661    CustomerContactPerson 
   TABLE DATA           �   COPY public."CustomerContactPerson" (id, "CustomerID", "ContactPersonID", "AuthorisedName", "AuthorisedMobileNo", "AuthorisedEmailID", "Designation", "InsertedDate", "InsertedBy", "UpdatedDate", "UpdatedBy") FROM stdin;
    public          postgres    false    272   �      �          0    24757    CustomerDistrictMapping 
   TABLE DATA           _   COPY public."CustomerDistrictMapping" ("CustomerID", "DistrictID", "InsertedDate") FROM stdin;
    public          postgres    false    282   �.      �          0    24781    CustomerInvoiceMaster 
   TABLE DATA           N  COPY public."CustomerInvoiceMaster" ("CustomerInvoiceNo", "MRRNo", "InvoiceNo", "PONo", "OrderReferenceNo", "POType", "FinYear", "DistrictID", "VendorID", "InvoiceAmount", "NoOfOrderDeliver", "DeliveredQuantity", "InsertedDate", "InsertedBy", "UpdatedDate", "UpdatedBy", "CustomerID", "DivisionID", "Implement", "Make", "Model", "HSN", "UnitOfMeasurement", "PackageSize", "PackageUnitOfMeasurement", "PackageQuantity", "ItemQuantity", "TaxRate", "RatePerUnit", "PurchaseInvoiceValue", "PurchaseCGST", "PurchaseSGST", "PurchaseIGST", "TotalPurchaseInvoiceValue", "TotalPurchaseTaxableValue", "TotalPurchaseCGST", "TotalPurchaseSGST", "SellCGST", "SellSGST", "SellIGST", "SellInvoiceValue", "SellTaxableValue", "TotalSellCGST", "TotalSellSGST", "TotalSellIGST", "TotalSellInvoiceValue", "TotalSellTaxableValue", "PurchaseTaxableValue") FROM stdin;
    public          postgres    false    283   �4      �          0    24650    CustomerMaster 
   TABLE DATA           �   COPY public."CustomerMaster" (id, "CustomerID", "LegalCustomerName", "TradeName", "PAN", "BussinessConstitution", "GSTN", "ContactNumber", "EmailID", "InsertedDate", "InsertedBy") FROM stdin;
    public          postgres    false    270   �6      �          0    24672    CustomerPrincipalPlace 
   TABLE DATA           �   COPY public."CustomerPrincipalPlace" (id, "CustomerID", "PrincipalPlaceID", "Country", "StateCode", "DistrictOrCity", "Pincode", "Address", "InsertedDate", "InsertedBy", "UpdatedDate", "UpdatedBy") FROM stdin;
    public          postgres    false    274   �Y      �          0    16434    DMMaster 
   TABLE DATA           �   COPY public."DMMaster" (dist_id, dist_name, dm_id, dm_name, dm_address, dm_mobile_no, "UpdateOn", "UpdateBy", "EmailID", "BankName", "BranchName", "AccountNumber", "IFSCCode") FROM stdin;
    public          postgres    false    210   �m      �          0    16419    DistrictMaster 
   TABLE DATA           J   COPY public."DistrictMaster" (dist_id, dist_name, "DistCode") FROM stdin;
    public          postgres    false    209   cw      �          0    24581    DivisionMaster 
   TABLE DATA           H   COPY public."DivisionMaster" ("DivisionID", "DivisionName") FROM stdin;
    public          postgres    false    264   �x      �          0    24724    InvoiceMaster 
   TABLE DATA           I  COPY public."InvoiceMaster" ("InvoiceNo", "PONo", "OrderReferenceNo", "InvoiceDate", "WayBillNo", "WayBillDate", "TruckNo", "FinYear", "DistrictID", "VendorID", "Status", "PaymentStatus", "InvoiceAmount", "InvoicePath", "POType", "NoOfOrderInPO", "NoOfOrderDeliver", "InsertedDate", "InsertedBy", "UpdatedDate", "UpdatedBy", "IsReceived", "ReceivedDate", "EngineNumber", "ChassicNumber", "MRRNo", "TotalPurchaseTaxableValue", "TotalPurchaseInvoiceValue", "TotalPurchaseCGST", "TotalPurchaseSGST", "TotalPurchaseIGST", "SupplyQuantity", "SupplyPackageQuantity", "Discount") FROM stdin;
    public          postgres    false    278   �x      �          0    16467 
   ItemMaster 
   TABLE DATA           n  COPY public."ItemMaster" ("Implement", "Make", "Model", p_taxable_value, p_cgst_6, p_sgst_6, p_cgst_1, p_sgst_1, p_invoice_value, s_taxable_value, s_cgst_6, s_sgst_6, s_invoice_value, p_igst_12, s_igst_12, add_date, update_date, "Division", "HSN", "UnitOfMeasurement", "GSTApplicability", "Taxability", "TaxRate", "PurchaseInvoiceValue", "PurchaseTaxableValue", "PurchaseCGST", "PurchaseSGST", "PurchaseIGST", "PurchaseSGSTOnePercent", "PurchaseCGSTOnePercent", "SellCGST", "SellSGST", "SellIGST", "SellInvoiceValue", "SellTaxableValue", "InsertedDate", "InsertedBy", "UpdatedDate", "UpdatedBy", "DivisionID") FROM stdin;
    public          postgres    false    220   ؎      �          0    24737    ItemPackageMaster 
   TABLE DATA           W  COPY public."ItemPackageMaster" ("DivisionID", "Implement", "Make", "Model", "PackageSize", "UnitOfMeasurement", "PurchaseInvoiceValue", "PurchaseTaxableValue", "PurchaseCGST", "PurchaseSGST", "PurchaseIGST", "SellSGST", "SellIGST", "SellInvoiceValue", "SellTaxableValue", "InsertedDate", "InsertedBy", "UpdatedDate", "UpdatedBy") FROM stdin;
    public          postgres    false    279   �      �          0    24750    ItemPackageSizeMaster 
   TABLE DATA           D   COPY public."ItemPackageSizeMaster" (id, "PackageSize") FROM stdin;
    public          postgres    false    281   ��      �          0    24628 	   MRRMaster 
   TABLE DATA           '  COPY public."MRRMaster" ("MRRNo", "InvoiceNo", "PONo", "OrderReferenceNo", "FinYear", "ItemQuantity", "MRRAmount", "VendorID", "DistrictID", "DMID", "AccID", "PaymentStatus", "POType", "InsertedDate", "InsertedBy", "UpdatedDate", "UpdatedBy", "NoOfItemReceived", "ReceivedQuantity") FROM stdin;
    public          postgres    false    268   )�      �          0    24616    NonSubsidyPODetails 
   TABLE DATA             COPY public."NonSubsidyPODetails" (id, "OrderReferenceNo", "PONo", "CustomerID", "DivisionID", "Implement", "Make", "Model", "UnitOfMeasurement", "HSN", "TaxRate", "PurchaseInvoiceValue", "PurchaseTaxableValue", "PurchaseCGST", "PurchaseSGST", "PurchaseIGST", "SellCGST", "SellSGST", "SellIGST", "SellInvoiceValue", "SellTaxableValue", "ItemQuantity", "ItemQuantitySold", "EngineNumber", "ChassicNumber", "IsDelivered", "IsReceived", "IsDeliveredToCustomer", "InsertedDate", "InsertedBy", "UpdatedDate", "UpdatedBy") FROM stdin;
    public          postgres    false    267   o�      �          0    24597    POMaster 
   TABLE DATA           �  COPY public."POMaster" ("FinYear", "PONo", "OrderReferenceNo", "CustomerID", "CustomerOrderRefence", "VendorID", "DistrictID", "DMID", "AccID", "DivisionID", "Implement", "Make", "Model", "UnitOfMeasurement", "HSN", "TaxRate", "PurchaseInvoiceValue", "PurchaseTaxableValue", "PurchaseCGST", "PurchaseSGST", "PurchaseIGST", "TotalPurchaseInvoiceValue", "TotalPurchaseTaxableValue", "TotalPurchaseCGST", "TotalPurchaseSGST", "SellCGST", "SellSGST", "SellIGST", "SellInvoiceValue", "SellTaxableValue", "TotalSellCGST", "TotalSellSGST", "TotalSellIGST", "TotalSellInvoiceValue", "TotalSellTaxableValue", "POAmount", "NoOfItemsInPO", "ItemQuantity", "ItemQuantitySold", "EngineNumber", "ChassicNumber", "IsDelivered", "IsReceived", "IsDeliveredToCustomer", "Status", "InsertedDate", "InsertedBy", "UpdatedDate", "UpdatedBy", "IsApproved", "ApprovalStatus", "ApprovedDate", "ApprovedBy", "IsDeleted", "DeletedDate", "DeletedBy", "IsCancelled", "CancellationStatus", "CancelledDate", "CancelledBy", "POType", "VendorInvoiceNo", "MRRID", "RatePerUnit", "PackageQuantity", "PackageSize", "PackageUnitOfMeasurement", "DeliveredQuantity", "PendingQuantity") FROM stdin;
    public          postgres    false    265   ��      �          0    16793    StateMaster 
   TABLE DATA           A   COPY public."StateMaster" ("StateCode", "StateName") FROM stdin;
    public          postgres    false    253   �
      �          0    16953    VendorBankAccount 
   TABLE DATA           �   COPY public."VendorBankAccount" ("VendorID", "BankAccountID", "AccountNumber", "AccountType", "BankName", "BranchName", "IFSCCode", "BankDocument", "InsertedDate", "InsertedBy", "UpdatedDate", "UpdatedBy") FROM stdin;
    public          postgres    false    260         �          0    16916    VendorContactPerson 
   TABLE DATA           �   COPY public."VendorContactPerson" ("VendorID", "ContactPersonID", "Name", "FathersName", "MobileNumber", "EmailID", "Designation", "InsertedDate", "InsertedBy") FROM stdin;
    public          postgres    false    256   �       �          0    16980    VendorDistrictMapping 
   TABLE DATA           [   COPY public."VendorDistrictMapping" ("VendorID", "DistrictID", "InsertedDate") FROM stdin;
    public          postgres    false    262   M8      �          0    16903    VendorMaster 
   TABLE DATA           �  COPY public."VendorMaster" ("VendorID", "LegalBussinessName", "TradeName", "PAN", "PANDocument", "BussinessConstitution", "GSTN", "GSTNDocument", "IncorporationDate", "ContactNumber", "EmailID", "ApprovalStatus", "ApplyStatus", "InsertedDate", "InsertedBy", "IsDeleted", "ApproveOrRejectDate", "ApproveOrRejectBy", "WhetherSSIUnit", "WhetherMSME", "SSIUnitRegistrationCertificate", "MSMECertificate", "CoreBussinessActivity", "Turnover1", "Turnover2", "Turnover3", "Password") FROM stdin;
    public          postgres    false    254   �B      �          0    16932    VendorPrincipalPlace 
   TABLE DATA           �   COPY public."VendorPrincipalPlace" ("VendorID", "PrincipalPlaceID", "Country", "StateCode", "DistrictOrCity", "Pincode", "Address", "InsertedDate", "InsertedBy") FROM stdin;
    public          postgres    false    258   n{      �          0    16967    VendorServices 
   TABLE DATA           _   COPY public."VendorServices" ("VendorID", "Service", "InsertedDate", "InsertedBy") FROM stdin;
    public          postgres    false    261   Y�      �          0    16388    approval 
   TABLE DATA           $  COPY public.approval (sl_no, invoice_no, fin_year, dist_id, dl_id, status, approval_id, indent_no, approval_date, ammount, transaction_id, deduction_amount, pay_now_amount, payment_status, remark, dl_remark, paid_amount, pp_id, pp_status, dm_approved_on, bank_approved_on, items) FROM stdin;
    public          postgres    false    201   Y�      �          0    16394    approval_desc 
   TABLE DATA           O   COPY public.approval_desc (approval_id, permit_no, serial, mrr_id) FROM stdin;
    public          postgres    false    202   �      �          0    16402    approval_status_desc 
   TABLE DATA           A   COPY public.approval_status_desc (status_id, "desc") FROM stdin;
    public          postgres    false    204   ��      �          0    16405 
   components 
   TABLE DATA           C   COPY public.components (comp_id, schema_id, comp_name) FROM stdin;
    public          postgres    false    205   !�      �          0    16408    dept_expenditure_payment_desc 
   TABLE DATA           �   COPY public.dept_expenditure_payment_desc (sl_no, reference_no, transaction_id, source_id, schem_id, comp_id, head_id, subhead_id, head_name, subhead_name, sd_path) FROM stdin;
    public          postgres    false    206   ��      �          0    16437    farmer_receipt 
   TABLE DATA           �   COPY public.farmer_receipt (sl_no, receipt_no, fin_year, farmer_name, farmer_id, full_ammount, permit_no, implement, payment_mode, payment_no, source_bank, date, dist_id, office, payment_date) FROM stdin;
    public          postgres    false    211   �      �          0    16411    govt_share_config 
   TABLE DATA           S   COPY public.govt_share_config (sl, fin_year, head, govt_share_ammount) FROM stdin;
    public          postgres    false    207   u�      �          0    16442    head_master 
   TABLE DATA           9   COPY public.head_master (head_id, head_name) FROM stdin;
    public          postgres    false    213   ��      �          0    16998    indent 
   TABLE DATA           
  COPY public.indent (indent_no, "PONo", fin_year, "FinYear", dist_id, "DistrictID", "DMID", "AccID", dl_id, "VendorID", "PermitNumber", "FarmerID", items, "POAmount", indent_ammount, status, "Status", indent_date, "InsertedDate", "InsertedBy", "UpdatedDate", "UpdatedBy", "IsApproved", "ApprovalStatus", "ApprovedDate", "ApprovedBy", "IsDeleted", "DeletedDate", "DeletedBy", "IsCancelled", "CancellationStatus", "CancelledDate", "CancelledBy", "CustomerID", "POType", " CustomerID", "VendorInvoiceNo", "MRRID") FROM stdin;
    public          postgres    false    263   ��      �          0    16448    indent_desc 
   TABLE DATA           ;   COPY public.indent_desc (indent_no, permit_no) FROM stdin;
    public          postgres    false    215   �      �          0    16445 
   indent_old 
   TABLE DATA           �   COPY public.indent_old (sl_no, indent_no, dist_id, indent_date, dl_id, fin_year, status, items, indent_ammount, "accountantID") FROM stdin;
    public          postgres    false    214   7�      �          0    16453    invoice 
   TABLE DATA           #  COPY public.invoice (sl_no, invoice_no, invoice_date, rr_way_bill_no, wagon_truck_no, challan_no, challan_date, fin_year, dist_id, dl_id, bill_no, bill_date, status, rr_way_bill_date, discount, indent_no, payment_status, items, invoice_ammount, invoice_path, gst_rate, "POType") FROM stdin;
    public          postgres    false    217   �      �          0    16459    invoice_desc 
   TABLE DATA           =   COPY public.invoice_desc (invoice_no, permit_no) FROM stdin;
    public          postgres    false    218   ��      �          0    16473 !   jalanidhi_dept_expnd_payment_desc 
   TABLE DATA           t   COPY public.jalanidhi_dept_expnd_payment_desc (serial, transaction_id, scheme_id, scheme_name, comp_id) FROM stdin;
    public          postgres    false    221   (�      �          0    16478    jalanidhi_payment_desc 
   TABLE DATA           �   COPY public.jalanidhi_payment_desc (transaction_id, farmer_id, farmer_name, implement, make, model, serial, project_id) FROM stdin;
    public          postgres    false    223   ��      �          0    16483    jn_expenditure_desc 
   TABLE DATA           f   COPY public.jn_expenditure_desc (transaction_id, item_name, item_price, quantity, serial) FROM stdin;
    public          postgres    false    225   ��      �          0    16488 	   jn_orders 
   TABLE DATA           {   COPY public.jn_orders (fin_year, dist_id, cluster_id, farmer_id, dist_name, farmer_name, status, date, system) FROM stdin;
    public          postgres    false    227   y�      �          0    16491    jn_stock 
   TABLE DATA           �   COPY public.jn_stock (fin_year, dist_id, dl_id, system, po_no, cluster_id, farmer_id, farmer_name, implement, make, model, engine_no, chassic_no, status, receive_date, deliver_date, dl_name) FROM stdin;
    public          postgres    false    228   :�      �          0    16497    lgd_block_master 
   TABLE DATA           M   COPY public.lgd_block_master (dist_code, block_code, block_name) FROM stdin;
    public          postgres    false    229   �      �          0    16503    lgd_dist_master 
   TABLE DATA           ?   COPY public.lgd_dist_master (dist_code, dist_name) FROM stdin;
    public          postgres    false    230   <�      �          0    16506    lgd_gp_master 
   TABLE DATA           P   COPY public.lgd_gp_master (dist_code, block_code, gp_code, gp_name) FROM stdin;
    public          postgres    false    231   C�      �          0    16509    log 
   TABLE DATA           �   COPY public.log (sl_no, date_time, user_id, action, status, ref_url, route, ip, browser_name, browser_version, fin_year, remark) FROM stdin;
    public          postgres    false    232   ��      �          0    16517    mrr 
   TABLE DATA           v   COPY public.mrr (sl_no, mrr_id, dist_id, invoice_no, fin_year, dl_id, date, items, indent_no, mrr_amount) FROM stdin;
    public          postgres    false    234   ��      �          0    16520    mrr_desc 
   TABLE DATA           5   COPY public.mrr_desc (mrr_id, permit_no) FROM stdin;
    public          postgres    false    235   ��      �          0    16525    new_item_price 
   TABLE DATA           �   COPY public.new_item_price (implement, make, model, purchase_price, taxable_value, cgst_6, sags_6, invoice_alue, selling_price, sl_taxable_value, sl_cgst_6, sl_sgst_6, sl_invoice_value) FROM stdin;
    public          postgres    false    237   �       �          0    16531    opening_balance 
   TABLE DATA           �   COPY public.opening_balance (fin_year, date, system, dist_id, transaction_id, ammount, remark, purpose, reference_no, "from", "to", head, subhead, payment_type, payment_date, payment_no, test) FROM stdin;
    public          postgres    false    238   I      �          0    16537    orders 
   TABLE DATA           �  COPY public.orders (permit_no, permit_issue_date, permit_validity, farmer_id, farmer_name, farmer_father_name, dist_name, block_name, gp_name, village_name, implement, make, model, status, permit_validity_1, permit_issue_date_1, fin_year, dist_id, engine_no, chassic_no, ammount, remark, expected_delivery_date, delivery_date, c_fin_year, date, system, paid_amount, order_type, "FullCost", "PendingCost") FROM stdin;
    public          postgres    false    239   I      �          0    16543    payment 
   TABLE DATA           �   COPY public.payment (sl_no, date, reference_no, transaction_id, "from", "to", remark, payment_type, payment_no, fin_year, purpose, payment_date, ammount, status, system, source_bank, "DivisionID", "Implement") FROM stdin;
    public          postgres    false    240   �`      �          0    16548    payment_desc 
   TABLE DATA           D   COPY public.payment_desc (transaction_id, reference_no) FROM stdin;
    public          postgres    false    242   ��      �          0    16555    payment_purpose_desc 
   TABLE DATA           B   COPY public.payment_purpose_desc (purpose_id, "desc") FROM stdin;
    public          postgres    false    245   ��      �          0    16558    schem_master 
   TABLE DATA           <   COPY public.schem_master (schem_id, schem_name) FROM stdin;
    public          postgres    false    246   ��      �          0    16561    source_master 
   TABLE DATA           ?   COPY public.source_master (source_id, source_name) FROM stdin;
    public          postgres    false    247         �          0    16564    subheads 
   TABLE DATA           E   COPY public.subheads (subhead_id, head_id, subhead_name) FROM stdin;
    public          postgres    false    248   �      �          0    16567    system_desc 
   TABLE DATA           8   COPY public.system_desc (system_id, "desc") FROM stdin;
    public          postgres    false    249   ��      �          0    16570 
   tax_config 
   TABLE DATA           6   COPY public.tax_config (tax_mode, "desc") FROM stdin;
    public          postgres    false    250   ߘ      �          0    16573    users 
   TABLE DATA           8   COPY public.users (user_id, password, role) FROM stdin;
    public          postgres    false    251   "�      �          0    16576    vender_master 
   TABLE DATA              COPY public.vender_master ("VendorId", "VendorRegNo", "DateOfReg", "Name", "FarmName", "IsVerified", "IsReject", "RejectRemarkStausId", "UserName", "Password", "Type", "IPAddress", "FinancialYear", "UpdatedOn", "UpdatedBy", "DeletedOn", "DeletedBy", "IsUpdated", "IsDeleted") FROM stdin;
    public          postgres    false    252   l�                 0    0    CustomerBankAccount_id_seq    SEQUENCE SET     K   SELECT pg_catalog.setval('public."CustomerBankAccount_id_seq"', 36, true);
          public          postgres    false    275                       0    0    CustomerContactPerson_id_seq    SEQUENCE SET     N   SELECT pg_catalog.setval('public."CustomerContactPerson_id_seq"', 141, true);
          public          postgres    false    271                       0    0    CustomerMaster_id_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('public."CustomerMaster_id_seq"', 178, true);
          public          postgres    false    269                       0    0    CustomerPrincipalPlace_id_seq    SEQUENCE SET     O   SELECT pg_catalog.setval('public."CustomerPrincipalPlace_id_seq"', 203, true);
          public          postgres    false    273                       0    0    ItemPackageSizeMaster_id_seq    SEQUENCE SET     M   SELECT pg_catalog.setval('public."ItemPackageSizeMaster_id_seq"', 19, true);
          public          postgres    false    280                       0    0    NonSubsidyPODetails_id_seq    SEQUENCE SET     K   SELECT pg_catalog.setval('public."NonSubsidyPODetails_id_seq"', 1, false);
          public          postgres    false    266                       0    0 #   VendorBankAccount_BankAccountID_seq    SEQUENCE SET     T   SELECT pg_catalog.setval('public."VendorBankAccount_BankAccountID_seq"', 99, true);
          public          postgres    false    259                       0    0 '   VendorContactPerson_ContactPersonID_seq    SEQUENCE SET     Y   SELECT pg_catalog.setval('public."VendorContactPerson_ContactPersonID_seq"', 122, true);
          public          postgres    false    255                       0    0 )   VendorPrincipalPlace_PrincipalPlaceID_seq    SEQUENCE SET     [   SELECT pg_catalog.setval('public."VendorPrincipalPlace_PrincipalPlaceID_seq"', 108, true);
          public          postgres    false    257                       0    0    approval_desc_serial_seq    SEQUENCE SET     H   SELECT pg_catalog.setval('public.approval_desc_serial_seq', 107, true);
          public          postgres    false    203                       0    0    customer_id_increment    SEQUENCE SET     E   SELECT pg_catalog.setval('public.customer_id_increment', 178, true);
          public          postgres    false    277                       0    0    dept_money_config_sl_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.dept_money_config_sl_seq', 1, true);
          public          postgres    false    208                       0    0    farmer_receipts_sl_no_seq    SEQUENCE SET     I   SELECT pg_catalog.setval('public.farmer_receipts_sl_no_seq', 643, true);
          public          postgres    false    212                       0    0    indents_sl_no_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.indents_sl_no_seq', 245, true);
          public          postgres    false    216                       0    0    invoice_sl_no_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.invoice_sl_no_seq', 353, true);
          public          postgres    false    219                       0    0 ,   jalanidhi_dept_expnd_payment_desc_serial_seq    SEQUENCE SET     [   SELECT pg_catalog.setval('public.jalanidhi_dept_expnd_payment_desc_serial_seq', 12, true);
          public          postgres    false    222                        0    0 !   jalanidhi_payment_desc_serial_seq    SEQUENCE SET     P   SELECT pg_catalog.setval('public.jalanidhi_payment_desc_serial_seq', 24, true);
          public          postgres    false    224            !           0    0    jn_expenditure_desc_serial_seq    SEQUENCE SET     M   SELECT pg_catalog.setval('public.jn_expenditure_desc_serial_seq', 36, true);
          public          postgres    false    226            "           0    0    log_sl_no_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.log_sl_no_seq', 5603, true);
          public          postgres    false    233            #           0    0    mrr_sl_no_seq    SEQUENCE SET     =   SELECT pg_catalog.setval('public.mrr_sl_no_seq', 229, true);
          public          postgres    false    236            $           0    0    payment1_sl_no_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public.payment1_sl_no_seq', 1312, true);
          public          postgres    false    241            %           0    0    payment_desc_2_sl_no_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('public.payment_desc_2_sl_no_seq', 93, true);
          public          postgres    false    243            &           0    0    payment_invoice_sl_no_seq    SEQUENCE SET     I   SELECT pg_catalog.setval('public.payment_invoice_sl_no_seq', 114, true);
          public          postgres    false    244            �           2606    24696 ,   CustomerBankAccount CustomerBankAccount_pkey 
   CONSTRAINT     n   ALTER TABLE ONLY public."CustomerBankAccount"
    ADD CONSTRAINT "CustomerBankAccount_pkey" PRIMARY KEY (id);
 Z   ALTER TABLE ONLY public."CustomerBankAccount" DROP CONSTRAINT "CustomerBankAccount_pkey";
       public            postgres    false    276            �           2606    24669 0   CustomerContactPerson CustomerContactPerson_pkey 
   CONSTRAINT     r   ALTER TABLE ONLY public."CustomerContactPerson"
    ADD CONSTRAINT "CustomerContactPerson_pkey" PRIMARY KEY (id);
 ^   ALTER TABLE ONLY public."CustomerContactPerson" DROP CONSTRAINT "CustomerContactPerson_pkey";
       public            postgres    false    272            �           2606    24764 4   CustomerDistrictMapping CustomerDistrictMapping_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CustomerDistrictMapping"
    ADD CONSTRAINT "CustomerDistrictMapping_pkey" PRIMARY KEY ("CustomerID", "DistrictID");
 b   ALTER TABLE ONLY public."CustomerDistrictMapping" DROP CONSTRAINT "CustomerDistrictMapping_pkey";
       public            postgres    false    282    282            �           2606    24809 0   CustomerInvoiceMaster CustomerInvoiceMaster_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CustomerInvoiceMaster"
    ADD CONSTRAINT "CustomerInvoiceMaster_pkey" PRIMARY KEY ("CustomerInvoiceNo", "OrderReferenceNo");
 ^   ALTER TABLE ONLY public."CustomerInvoiceMaster" DROP CONSTRAINT "CustomerInvoiceMaster_pkey";
       public            postgres    false    283    283            �           2606    24658 "   CustomerMaster CustomerMaster_pkey 
   CONSTRAINT     d   ALTER TABLE ONLY public."CustomerMaster"
    ADD CONSTRAINT "CustomerMaster_pkey" PRIMARY KEY (id);
 P   ALTER TABLE ONLY public."CustomerMaster" DROP CONSTRAINT "CustomerMaster_pkey";
       public            postgres    false    270            �           2606    24680 2   CustomerPrincipalPlace CustomerPrincipalPlace_pkey 
   CONSTRAINT     t   ALTER TABLE ONLY public."CustomerPrincipalPlace"
    ADD CONSTRAINT "CustomerPrincipalPlace_pkey" PRIMARY KEY (id);
 `   ALTER TABLE ONLY public."CustomerPrincipalPlace" DROP CONSTRAINT "CustomerPrincipalPlace_pkey";
       public            postgres    false    274            �           2606    24588 "   DivisionMaster DivisionMaster_pkey 
   CONSTRAINT     n   ALTER TABLE ONLY public."DivisionMaster"
    ADD CONSTRAINT "DivisionMaster_pkey" PRIMARY KEY ("DivisionID");
 P   ALTER TABLE ONLY public."DivisionMaster" DROP CONSTRAINT "DivisionMaster_pkey";
       public            postgres    false    264            �           2606    24734     InvoiceMaster InvoiceMaster_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."InvoiceMaster"
    ADD CONSTRAINT "InvoiceMaster_pkey" PRIMARY KEY ("InvoiceNo", "PONo", "OrderReferenceNo");
 N   ALTER TABLE ONLY public."InvoiceMaster" DROP CONSTRAINT "InvoiceMaster_pkey";
       public            postgres    false    278    278    278            �           2606    24772 (   ItemPackageMaster ItemPackageMaster_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."ItemPackageMaster"
    ADD CONSTRAINT "ItemPackageMaster_pkey" PRIMARY KEY ("DivisionID", "Implement", "Make", "Model", "PackageSize", "UnitOfMeasurement");
 V   ALTER TABLE ONLY public."ItemPackageMaster" DROP CONSTRAINT "ItemPackageMaster_pkey";
       public            postgres    false    279    279    279    279    279    279            �           2606    24755 0   ItemPackageSizeMaster ItemPackageSizeMaster_pkey 
   CONSTRAINT     r   ALTER TABLE ONLY public."ItemPackageSizeMaster"
    ADD CONSTRAINT "ItemPackageSizeMaster_pkey" PRIMARY KEY (id);
 ^   ALTER TABLE ONLY public."ItemPackageSizeMaster" DROP CONSTRAINT "ItemPackageSizeMaster_pkey";
       public            postgres    false    281            �           2606    24636    MRRMaster MRRMaster_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."MRRMaster"
    ADD CONSTRAINT "MRRMaster_pkey" PRIMARY KEY ("MRRNo", "InvoiceNo", "PONo", "OrderReferenceNo");
 F   ALTER TABLE ONLY public."MRRMaster" DROP CONSTRAINT "MRRMaster_pkey";
       public            postgres    false    268    268    268    268            �           2606    24627 ,   NonSubsidyPODetails NonSubsidyPODetails_pkey 
   CONSTRAINT     n   ALTER TABLE ONLY public."NonSubsidyPODetails"
    ADD CONSTRAINT "NonSubsidyPODetails_pkey" PRIMARY KEY (id);
 Z   ALTER TABLE ONLY public."NonSubsidyPODetails" DROP CONSTRAINT "NonSubsidyPODetails_pkey";
       public            postgres    false    267            �           2606    24613    POMaster POMaster_pkey 
   CONSTRAINT     p   ALTER TABLE ONLY public."POMaster"
    ADD CONSTRAINT "POMaster_pkey" PRIMARY KEY ("PONo", "OrderReferenceNo");
 D   ALTER TABLE ONLY public."POMaster" DROP CONSTRAINT "POMaster_pkey";
       public            postgres    false    265    265            �           2606    16797    StateMaster StateMaster_pkey 
   CONSTRAINT     g   ALTER TABLE ONLY public."StateMaster"
    ADD CONSTRAINT "StateMaster_pkey" PRIMARY KEY ("StateCode");
 J   ALTER TABLE ONLY public."StateMaster" DROP CONSTRAINT "StateMaster_pkey";
       public            postgres    false    253            �           2606    16961 (   VendorBankAccount VendorBankAccount_pkey 
   CONSTRAINT     w   ALTER TABLE ONLY public."VendorBankAccount"
    ADD CONSTRAINT "VendorBankAccount_pkey" PRIMARY KEY ("BankAccountID");
 V   ALTER TABLE ONLY public."VendorBankAccount" DROP CONSTRAINT "VendorBankAccount_pkey";
       public            postgres    false    260            �           2606    16924 ,   VendorContactPerson VendorContactPerson_pkey 
   CONSTRAINT     }   ALTER TABLE ONLY public."VendorContactPerson"
    ADD CONSTRAINT "VendorContactPerson_pkey" PRIMARY KEY ("ContactPersonID");
 Z   ALTER TABLE ONLY public."VendorContactPerson" DROP CONSTRAINT "VendorContactPerson_pkey";
       public            postgres    false    256            �           2606    16987 0   VendorDistrictMapping VendorDistrictMapping_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."VendorDistrictMapping"
    ADD CONSTRAINT "VendorDistrictMapping_pkey" PRIMARY KEY ("VendorID", "DistrictID");
 ^   ALTER TABLE ONLY public."VendorDistrictMapping" DROP CONSTRAINT "VendorDistrictMapping_pkey";
       public            postgres    false    262    262            �           2606    16913    VendorMaster VendorMaster_pkey 
   CONSTRAINT     h   ALTER TABLE ONLY public."VendorMaster"
    ADD CONSTRAINT "VendorMaster_pkey" PRIMARY KEY ("VendorID");
 L   ALTER TABLE ONLY public."VendorMaster" DROP CONSTRAINT "VendorMaster_pkey";
       public            postgres    false    254            �           2606    16940 .   VendorPrincipalPlace VendorPrincipalPlace_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."VendorPrincipalPlace"
    ADD CONSTRAINT "VendorPrincipalPlace_pkey" PRIMARY KEY ("PrincipalPlaceID");
 \   ALTER TABLE ONLY public."VendorPrincipalPlace" DROP CONSTRAINT "VendorPrincipalPlace_pkey";
       public            postgres    false    258            �           2606    16974 "   VendorServices VendorServices_pkey 
   CONSTRAINT     w   ALTER TABLE ONLY public."VendorServices"
    ADD CONSTRAINT "VendorServices_pkey" PRIMARY KEY ("VendorID", "Service");
 P   ALTER TABLE ONLY public."VendorServices" DROP CONSTRAINT "VendorServices_pkey";
       public            postgres    false    261    261            �           2606    16596 (   AccountantMaster accountants_master_pkey 
   CONSTRAINT     u   ALTER TABLE ONLY public."AccountantMaster"
    ADD CONSTRAINT accountants_master_pkey PRIMARY KEY (acc_id, dist_id);
 T   ALTER TABLE ONLY public."AccountantMaster" DROP CONSTRAINT accountants_master_pkey;
       public            postgres    false    200    200            �           2606    16598     approval_desc approval_desc_pkey 
   CONSTRAINT     b   ALTER TABLE ONLY public.approval_desc
    ADD CONSTRAINT approval_desc_pkey PRIMARY KEY (serial);
 J   ALTER TABLE ONLY public.approval_desc DROP CONSTRAINT approval_desc_pkey;
       public            postgres    false    202            �           2606    16600 .   approval_status_desc approval_status_desc_pkey 
   CONSTRAINT     s   ALTER TABLE ONLY public.approval_status_desc
    ADD CONSTRAINT approval_status_desc_pkey PRIMARY KEY (status_id);
 X   ALTER TABLE ONLY public.approval_status_desc DROP CONSTRAINT approval_status_desc_pkey;
       public            postgres    false    204            �           2606    16602    components components_pkey 
   CONSTRAINT     ]   ALTER TABLE ONLY public.components
    ADD CONSTRAINT components_pkey PRIMARY KEY (comp_id);
 D   ALTER TABLE ONLY public.components DROP CONSTRAINT components_pkey;
       public            postgres    false    205            �           2606    16604 (   govt_share_config dept_money_config_pkey 
   CONSTRAINT     f   ALTER TABLE ONLY public.govt_share_config
    ADD CONSTRAINT dept_money_config_pkey PRIMARY KEY (sl);
 R   ALTER TABLE ONLY public.govt_share_config DROP CONSTRAINT dept_money_config_pkey;
       public            postgres    false    207            �           2606    16608 !   DistrictMaster dist_master_1_pkey 
   CONSTRAINT     f   ALTER TABLE ONLY public."DistrictMaster"
    ADD CONSTRAINT dist_master_1_pkey PRIMARY KEY (dist_id);
 M   ALTER TABLE ONLY public."DistrictMaster" DROP CONSTRAINT dist_master_1_pkey;
       public            postgres    false    209            �           2606    16616    DMMaster dm_master_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public."DMMaster"
    ADD CONSTRAINT dm_master_pkey PRIMARY KEY (dm_id);
 C   ALTER TABLE ONLY public."DMMaster" DROP CONSTRAINT dm_master_pkey;
       public            postgres    false    210            �           2606    24577 #   farmer_receipt farmer_receipts_pkey 
   CONSTRAINT     i   ALTER TABLE ONLY public.farmer_receipt
    ADD CONSTRAINT farmer_receipts_pkey PRIMARY KEY (receipt_no);
 M   ALTER TABLE ONLY public.farmer_receipt DROP CONSTRAINT farmer_receipts_pkey;
       public            postgres    false    211            �           2606    16620    head_master head_master_pkey 
   CONSTRAINT     _   ALTER TABLE ONLY public.head_master
    ADD CONSTRAINT head_master_pkey PRIMARY KEY (head_id);
 F   ALTER TABLE ONLY public.head_master DROP CONSTRAINT head_master_pkey;
       public            postgres    false    213            �           2606    16622    indent_desc indent_desc_pkey 
   CONSTRAINT     l   ALTER TABLE ONLY public.indent_desc
    ADD CONSTRAINT indent_desc_pkey PRIMARY KEY (indent_no, permit_no);
 F   ALTER TABLE ONLY public.indent_desc DROP CONSTRAINT indent_desc_pkey;
       public            postgres    false    215    215            �           2606    17012    indent indent_pkey 
   CONSTRAINT     W   ALTER TABLE ONLY public.indent
    ADD CONSTRAINT indent_pkey PRIMARY KEY (indent_no);
 <   ALTER TABLE ONLY public.indent DROP CONSTRAINT indent_pkey;
       public            postgres    false    263            �           2606    16624    indent_old indents_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY public.indent_old
    ADD CONSTRAINT indents_pkey PRIMARY KEY (indent_no);
 A   ALTER TABLE ONLY public.indent_old DROP CONSTRAINT indents_pkey;
       public            postgres    false    214            �           2606    16626    invoice_desc invoice_desc_pkey 
   CONSTRAINT     o   ALTER TABLE ONLY public.invoice_desc
    ADD CONSTRAINT invoice_desc_pkey PRIMARY KEY (invoice_no, permit_no);
 H   ALTER TABLE ONLY public.invoice_desc DROP CONSTRAINT invoice_desc_pkey;
       public            postgres    false    218    218            �           2606    16628    invoice invoice_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.invoice
    ADD CONSTRAINT invoice_pkey PRIMARY KEY (invoice_no);
 >   ALTER TABLE ONLY public.invoice DROP CONSTRAINT invoice_pkey;
       public            postgres    false    217            �           2606    16632 !   ItemMaster item_price_map_1_pkey1 
   CONSTRAINT     {   ALTER TABLE ONLY public."ItemMaster"
    ADD CONSTRAINT item_price_map_1_pkey1 PRIMARY KEY ("Implement", "Make", "Model");
 M   ALTER TABLE ONLY public."ItemMaster" DROP CONSTRAINT item_price_map_1_pkey1;
       public            postgres    false    220    220    220            �           2606    16634 H   jalanidhi_dept_expnd_payment_desc jalanidhi_dept_expnd_payment_desc_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.jalanidhi_dept_expnd_payment_desc
    ADD CONSTRAINT jalanidhi_dept_expnd_payment_desc_pkey PRIMARY KEY (serial);
 r   ALTER TABLE ONLY public.jalanidhi_dept_expnd_payment_desc DROP CONSTRAINT jalanidhi_dept_expnd_payment_desc_pkey;
       public            postgres    false    221            �           2606    16636 2   jalanidhi_payment_desc jalanidhi_payment_desc_pkey 
   CONSTRAINT     t   ALTER TABLE ONLY public.jalanidhi_payment_desc
    ADD CONSTRAINT jalanidhi_payment_desc_pkey PRIMARY KEY (serial);
 \   ALTER TABLE ONLY public.jalanidhi_payment_desc DROP CONSTRAINT jalanidhi_payment_desc_pkey;
       public            postgres    false    223            �           2606    16638 ,   jn_expenditure_desc jn_expenditure_desc_pkey 
   CONSTRAINT     n   ALTER TABLE ONLY public.jn_expenditure_desc
    ADD CONSTRAINT jn_expenditure_desc_pkey PRIMARY KEY (serial);
 V   ALTER TABLE ONLY public.jn_expenditure_desc DROP CONSTRAINT jn_expenditure_desc_pkey;
       public            postgres    false    225            �           2606    16640    jn_orders jn_orders_pkey 
   CONSTRAINT     i   ALTER TABLE ONLY public.jn_orders
    ADD CONSTRAINT jn_orders_pkey PRIMARY KEY (cluster_id, farmer_id);
 B   ALTER TABLE ONLY public.jn_orders DROP CONSTRAINT jn_orders_pkey;
       public            postgres    false    227    227            �           2606    16642    jn_stock jn_stock_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.jn_stock
    ADD CONSTRAINT jn_stock_pkey PRIMARY KEY (po_no, cluster_id, farmer_id, implement, make, model);
 @   ALTER TABLE ONLY public.jn_stock DROP CONSTRAINT jn_stock_pkey;
       public            postgres    false    228    228    228    228    228    228            �           2606    16644 &   lgd_block_master lgd_block_master_pkey 
   CONSTRAINT     l   ALTER TABLE ONLY public.lgd_block_master
    ADD CONSTRAINT lgd_block_master_pkey PRIMARY KEY (block_code);
 P   ALTER TABLE ONLY public.lgd_block_master DROP CONSTRAINT lgd_block_master_pkey;
       public            postgres    false    229            �           2606    16646 $   lgd_dist_master lgd_dist_master_pkey 
   CONSTRAINT     i   ALTER TABLE ONLY public.lgd_dist_master
    ADD CONSTRAINT lgd_dist_master_pkey PRIMARY KEY (dist_code);
 N   ALTER TABLE ONLY public.lgd_dist_master DROP CONSTRAINT lgd_dist_master_pkey;
       public            postgres    false    230            �           2606    16648     lgd_gp_master lgd_gp_master_pkey 
   CONSTRAINT     c   ALTER TABLE ONLY public.lgd_gp_master
    ADD CONSTRAINT lgd_gp_master_pkey PRIMARY KEY (gp_code);
 J   ALTER TABLE ONLY public.lgd_gp_master DROP CONSTRAINT lgd_gp_master_pkey;
       public            postgres    false    231            �           2606    16650    log log_pkey 
   CONSTRAINT     M   ALTER TABLE ONLY public.log
    ADD CONSTRAINT log_pkey PRIMARY KEY (sl_no);
 6   ALTER TABLE ONLY public.log DROP CONSTRAINT log_pkey;
       public            postgres    false    232            �           2606    16652    mrr_desc mrr_desc_pkey 
   CONSTRAINT     c   ALTER TABLE ONLY public.mrr_desc
    ADD CONSTRAINT mrr_desc_pkey PRIMARY KEY (mrr_id, permit_no);
 @   ALTER TABLE ONLY public.mrr_desc DROP CONSTRAINT mrr_desc_pkey;
       public            postgres    false    235    235            �           2606    16654    mrr mrr_pkey 
   CONSTRAINT     N   ALTER TABLE ONLY public.mrr
    ADD CONSTRAINT mrr_pkey PRIMARY KEY (mrr_id);
 6   ALTER TABLE ONLY public.mrr DROP CONSTRAINT mrr_pkey;
       public            postgres    false    234            �           2606    16656 "   new_item_price new_item_price_pkey 
   CONSTRAINT     t   ALTER TABLE ONLY public.new_item_price
    ADD CONSTRAINT new_item_price_pkey PRIMARY KEY (implement, make, model);
 L   ALTER TABLE ONLY public.new_item_price DROP CONSTRAINT new_item_price_pkey;
       public            postgres    false    237    237    237            �           2606    16658 $   opening_balance opening_balance_pkey 
   CONSTRAINT     n   ALTER TABLE ONLY public.opening_balance
    ADD CONSTRAINT opening_balance_pkey PRIMARY KEY (transaction_id);
 N   ALTER TABLE ONLY public.opening_balance DROP CONSTRAINT opening_balance_pkey;
       public            postgres    false    238            �           2606    16660    orders orders_pkey 
   CONSTRAINT     W   ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (permit_no);
 <   ALTER TABLE ONLY public.orders DROP CONSTRAINT orders_pkey;
       public            postgres    false    239            �           2606    16662    payment payment1_pkey 
   CONSTRAINT     _   ALTER TABLE ONLY public.payment
    ADD CONSTRAINT payment1_pkey PRIMARY KEY (transaction_id);
 ?   ALTER TABLE ONLY public.payment DROP CONSTRAINT payment1_pkey;
       public            postgres    false    240            �           2606    16664 1   dept_expenditure_payment_desc payment_desc_2_pkey 
   CONSTRAINT     r   ALTER TABLE ONLY public.dept_expenditure_payment_desc
    ADD CONSTRAINT payment_desc_2_pkey PRIMARY KEY (sl_no);
 [   ALTER TABLE ONLY public.dept_expenditure_payment_desc DROP CONSTRAINT payment_desc_2_pkey;
       public            postgres    false    206            �           2606    16666    payment_desc payment_desc_pkey 
   CONSTRAINT     v   ALTER TABLE ONLY public.payment_desc
    ADD CONSTRAINT payment_desc_pkey PRIMARY KEY (reference_no, transaction_id);
 H   ALTER TABLE ONLY public.payment_desc DROP CONSTRAINT payment_desc_pkey;
       public            postgres    false    242    242            �           2606    16668 !   approval payment_instruction_pkey 
   CONSTRAINT     b   ALTER TABLE ONLY public.approval
    ADD CONSTRAINT payment_instruction_pkey PRIMARY KEY (sl_no);
 K   ALTER TABLE ONLY public.approval DROP CONSTRAINT payment_instruction_pkey;
       public            postgres    false    201            �           2606    16670 .   payment_purpose_desc payment_purpose_desc_pkey 
   CONSTRAINT     t   ALTER TABLE ONLY public.payment_purpose_desc
    ADD CONSTRAINT payment_purpose_desc_pkey PRIMARY KEY (purpose_id);
 X   ALTER TABLE ONLY public.payment_purpose_desc DROP CONSTRAINT payment_purpose_desc_pkey;
       public            postgres    false    245            �           2606    16672    schem_master schema_master_pkey 
   CONSTRAINT     c   ALTER TABLE ONLY public.schem_master
    ADD CONSTRAINT schema_master_pkey PRIMARY KEY (schem_id);
 I   ALTER TABLE ONLY public.schem_master DROP CONSTRAINT schema_master_pkey;
       public            postgres    false    246            �           2606    16674     source_master source_master_pkey 
   CONSTRAINT     e   ALTER TABLE ONLY public.source_master
    ADD CONSTRAINT source_master_pkey PRIMARY KEY (source_id);
 J   ALTER TABLE ONLY public.source_master DROP CONSTRAINT source_master_pkey;
       public            postgres    false    247            �           2606    16676    subheads subhead_pkey 
   CONSTRAINT     [   ALTER TABLE ONLY public.subheads
    ADD CONSTRAINT subhead_pkey PRIMARY KEY (subhead_id);
 ?   ALTER TABLE ONLY public.subheads DROP CONSTRAINT subhead_pkey;
       public            postgres    false    248            �           2606    16678    system_desc system_desc_pkey 
   CONSTRAINT     a   ALTER TABLE ONLY public.system_desc
    ADD CONSTRAINT system_desc_pkey PRIMARY KEY (system_id);
 F   ALTER TABLE ONLY public.system_desc DROP CONSTRAINT system_desc_pkey;
       public            postgres    false    249            �           2606    16680    tax_config tax_config_pkey 
   CONSTRAINT     ^   ALTER TABLE ONLY public.tax_config
    ADD CONSTRAINT tax_config_pkey PRIMARY KEY (tax_mode);
 D   ALTER TABLE ONLY public.tax_config DROP CONSTRAINT tax_config_pkey;
       public            postgres    false    250            �           2606    17014    users users_pkey 
   CONSTRAINT     S   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (user_id);
 :   ALTER TABLE ONLY public.users DROP CONSTRAINT users_pkey;
       public            postgres    false    251            �           2606    16684     vender_master vender_master_pkey 
   CONSTRAINT     f   ALTER TABLE ONLY public.vender_master
    ADD CONSTRAINT vender_master_pkey PRIMARY KEY ("VendorId");
 J   ALTER TABLE ONLY public.vender_master DROP CONSTRAINT vender_master_pkey;
       public            postgres    false    252                       2620    24779     POMaster updateDeliveredQuantity    TRIGGER     �   CREATE TRIGGER "updateDeliveredQuantity" BEFORE UPDATE ON public."POMaster" FOR EACH ROW EXECUTE FUNCTION public."UpdateDeliveredQuantity"();
 =   DROP TRIGGER "updateDeliveredQuantity" ON public."POMaster";
       public          postgres    false    290    265                       2620    24735    InvoiceMaster update_invoice_no    TRIGGER     �   CREATE TRIGGER update_invoice_no AFTER INSERT ON public."InvoiceMaster" FOR EACH ROW EXECUTE FUNCTION public.update_invoice_number();
 :   DROP TRIGGER update_invoice_no ON public."InvoiceMaster";
       public          postgres    false    278    289                       2620    24594    invoice update_invoice_no    TRIGGER     ~   CREATE TRIGGER update_invoice_no AFTER INSERT ON public.invoice FOR EACH ROW EXECUTE FUNCTION public.update_invoice_number();
 2   DROP TRIGGER update_invoice_no ON public.invoice;
       public          postgres    false    289    217                       2620    24736    MRRMaster update_mrr_id    TRIGGER     v   CREATE TRIGGER update_mrr_id AFTER INSERT ON public."MRRMaster" FOR EACH ROW EXECUTE FUNCTION public.update_mrr_id();
 2   DROP TRIGGER update_mrr_id ON public."MRRMaster";
       public          postgres    false    268    288                       2620    24637    POMaster update_order    TRIGGER     ~   CREATE TRIGGER update_order AFTER INSERT ON public."POMaster" FOR EACH ROW EXECUTE FUNCTION public.update_order_po_intiate();
 0   DROP TRIGGER update_order ON public."POMaster";
       public          postgres    false    287    265                       2606    24765 ?   CustomerDistrictMapping CustomerDistrictMapping_DistrictID_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."CustomerDistrictMapping"
    ADD CONSTRAINT "CustomerDistrictMapping_DistrictID_fkey" FOREIGN KEY ("DistrictID") REFERENCES public."DistrictMaster"(dist_id) ON UPDATE CASCADE;
 m   ALTER TABLE ONLY public."CustomerDistrictMapping" DROP CONSTRAINT "CustomerDistrictMapping_DistrictID_fkey";
       public          postgres    false    3985    209    282                       2606    24681 <   CustomerPrincipalPlace CustomerPrincipalPlace_StateCode_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."CustomerPrincipalPlace"
    ADD CONSTRAINT "CustomerPrincipalPlace_StateCode_fkey" FOREIGN KEY ("StateCode") REFERENCES public."StateMaster"("StateCode") ON UPDATE CASCADE ON DELETE SET NULL;
 j   ALTER TABLE ONLY public."CustomerPrincipalPlace" DROP CONSTRAINT "CustomerPrincipalPlace_StateCode_fkey";
       public          postgres    false    253    274    4051                       2606    16962 1   VendorBankAccount VendorBankAccount_VendorID_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."VendorBankAccount"
    ADD CONSTRAINT "VendorBankAccount_VendorID_fkey" FOREIGN KEY ("VendorID") REFERENCES public."VendorMaster"("VendorID") ON UPDATE CASCADE;
 _   ALTER TABLE ONLY public."VendorBankAccount" DROP CONSTRAINT "VendorBankAccount_VendorID_fkey";
       public          postgres    false    4053    254    260                       2606    16925 5   VendorContactPerson VendorContactPerson_VendorID_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."VendorContactPerson"
    ADD CONSTRAINT "VendorContactPerson_VendorID_fkey" FOREIGN KEY ("VendorID") REFERENCES public."VendorMaster"("VendorID") ON UPDATE CASCADE;
 c   ALTER TABLE ONLY public."VendorContactPerson" DROP CONSTRAINT "VendorContactPerson_VendorID_fkey";
       public          postgres    false    254    4053    256                       2606    16993 ;   VendorDistrictMapping VendorDistrictMapping_DistrictID_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."VendorDistrictMapping"
    ADD CONSTRAINT "VendorDistrictMapping_DistrictID_fkey" FOREIGN KEY ("DistrictID") REFERENCES public."DistrictMaster"(dist_id) ON UPDATE CASCADE;
 i   ALTER TABLE ONLY public."VendorDistrictMapping" DROP CONSTRAINT "VendorDistrictMapping_DistrictID_fkey";
       public          postgres    false    3985    209    262                       2606    16988 9   VendorDistrictMapping VendorDistrictMapping_VendorID_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."VendorDistrictMapping"
    ADD CONSTRAINT "VendorDistrictMapping_VendorID_fkey" FOREIGN KEY ("VendorID") REFERENCES public."VendorMaster"("VendorID") ON UPDATE CASCADE;
 g   ALTER TABLE ONLY public."VendorDistrictMapping" DROP CONSTRAINT "VendorDistrictMapping_VendorID_fkey";
       public          postgres    false    262    4053    254                       2606    16946 8   VendorPrincipalPlace VendorPrincipalPlace_StateCode_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."VendorPrincipalPlace"
    ADD CONSTRAINT "VendorPrincipalPlace_StateCode_fkey" FOREIGN KEY ("StateCode") REFERENCES public."StateMaster"("StateCode") ON UPDATE CASCADE;
 f   ALTER TABLE ONLY public."VendorPrincipalPlace" DROP CONSTRAINT "VendorPrincipalPlace_StateCode_fkey";
       public          postgres    false    4051    253    258                       2606    16941 7   VendorPrincipalPlace VendorPrincipalPlace_VendorID_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."VendorPrincipalPlace"
    ADD CONSTRAINT "VendorPrincipalPlace_VendorID_fkey" FOREIGN KEY ("VendorID") REFERENCES public."VendorMaster"("VendorID") ON UPDATE CASCADE;
 e   ALTER TABLE ONLY public."VendorPrincipalPlace" DROP CONSTRAINT "VendorPrincipalPlace_VendorID_fkey";
       public          postgres    false    4053    258    254                       2606    16975 +   VendorServices VendorServices_VendorID_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."VendorServices"
    ADD CONSTRAINT "VendorServices_VendorID_fkey" FOREIGN KEY ("VendorID") REFERENCES public."VendorMaster"("VendorID") ON UPDATE CASCADE;
 Y   ALTER TABLE ONLY public."VendorServices" DROP CONSTRAINT "VendorServices_VendorID_fkey";
       public          postgres    false    254    261    4053            �           2606    16685 *   approval_desc approval_desc_permit_no_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.approval_desc
    ADD CONSTRAINT approval_desc_permit_no_fkey FOREIGN KEY (permit_no) REFERENCES public.orders(permit_no) NOT VALID;
 T   ALTER TABLE ONLY public.approval_desc DROP CONSTRAINT approval_desc_permit_no_fkey;
       public          postgres    false    4029    239    202            �           2606    16690    approval approval_status_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.approval
    ADD CONSTRAINT approval_status_fkey FOREIGN KEY (status) REFERENCES public.approval_status_desc(status_id) NOT VALID;
 G   ALTER TABLE ONLY public.approval DROP CONSTRAINT approval_status_fkey;
       public          postgres    false    201    204    3977                       2606    16695    lgd_gp_master block_master    FK CONSTRAINT     �   ALTER TABLE ONLY public.lgd_gp_master
    ADD CONSTRAINT block_master FOREIGN KEY (block_code) REFERENCES public.lgd_block_master(block_code) NOT VALID;
 D   ALTER TABLE ONLY public.lgd_gp_master DROP CONSTRAINT block_master;
       public          postgres    false    231    229    4013                       2606    16705    lgd_gp_master dist_master    FK CONSTRAINT     �   ALTER TABLE ONLY public.lgd_gp_master
    ADD CONSTRAINT dist_master FOREIGN KEY (dist_code) REFERENCES public.lgd_dist_master(dist_code) NOT VALID;
 C   ALTER TABLE ONLY public.lgd_gp_master DROP CONSTRAINT dist_master;
       public          postgres    false    4015    231    230                       2606    16710    lgd_block_master dist_master    FK CONSTRAINT     �   ALTER TABLE ONLY public.lgd_block_master
    ADD CONSTRAINT dist_master FOREIGN KEY (dist_code) REFERENCES public.lgd_dist_master(dist_code) NOT VALID;
 F   ALTER TABLE ONLY public.lgd_block_master DROP CONSTRAINT dist_master;
       public          postgres    false    230    4015    229            �           2606    16725 &   indent_desc indent_desc_indent_no_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.indent_desc
    ADD CONSTRAINT indent_desc_indent_no_fkey FOREIGN KEY (indent_no) REFERENCES public.indent_old(indent_no) NOT VALID;
 P   ALTER TABLE ONLY public.indent_desc DROP CONSTRAINT indent_desc_indent_no_fkey;
       public          postgres    false    3993    215    214                        2606    16730 &   indent_desc indent_desc_permit_no_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.indent_desc
    ADD CONSTRAINT indent_desc_permit_no_fkey FOREIGN KEY (permit_no) REFERENCES public.orders(permit_no) NOT VALID;
 P   ALTER TABLE ONLY public.indent_desc DROP CONSTRAINT indent_desc_permit_no_fkey;
       public          postgres    false    4029    239    215            �           2606    16735    indent_old indent_dist_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.indent_old
    ADD CONSTRAINT indent_dist_id_fkey FOREIGN KEY (dist_id) REFERENCES public."DistrictMaster"(dist_id) NOT VALID;
 H   ALTER TABLE ONLY public.indent_old DROP CONSTRAINT indent_dist_id_fkey;
       public          postgres    false    209    214    3985                       2606    16740 )   invoice_desc invoice_desc_invoice_no_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.invoice_desc
    ADD CONSTRAINT invoice_desc_invoice_no_fkey FOREIGN KEY (invoice_no) REFERENCES public.invoice(invoice_no) NOT VALID;
 S   ALTER TABLE ONLY public.invoice_desc DROP CONSTRAINT invoice_desc_invoice_no_fkey;
       public          postgres    false    3997    217    218                       2606    16745 (   invoice_desc invoice_desc_permit_no_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.invoice_desc
    ADD CONSTRAINT invoice_desc_permit_no_fkey FOREIGN KEY (permit_no) REFERENCES public.orders(permit_no) NOT VALID;
 R   ALTER TABLE ONLY public.invoice_desc DROP CONSTRAINT invoice_desc_permit_no_fkey;
       public          postgres    false    218    239    4029                       2606    16750    invoice invoice_dist_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.invoice
    ADD CONSTRAINT invoice_dist_id_fkey FOREIGN KEY (dist_id) REFERENCES public."DistrictMaster"(dist_id) NOT VALID;
 F   ALTER TABLE ONLY public.invoice DROP CONSTRAINT invoice_dist_id_fkey;
       public          postgres    false    3985    217    209                       2606    16755 +   jn_stock jn_stock_cluster_id_farmer_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.jn_stock
    ADD CONSTRAINT jn_stock_cluster_id_farmer_id_fkey FOREIGN KEY (cluster_id, farmer_id) REFERENCES public.jn_orders(cluster_id, farmer_id) NOT VALID;
 U   ALTER TABLE ONLY public.jn_stock DROP CONSTRAINT jn_stock_cluster_id_farmer_id_fkey;
       public          postgres    false    227    228    228    227    4009            	           2606    16760    mrr_desc mrr_desc_mrr_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.mrr_desc
    ADD CONSTRAINT mrr_desc_mrr_id_fkey FOREIGN KEY (mrr_id) REFERENCES public.mrr(mrr_id) NOT VALID;
 G   ALTER TABLE ONLY public.mrr_desc DROP CONSTRAINT mrr_desc_mrr_id_fkey;
       public          postgres    false    234    235    4021            
           2606    16765     mrr_desc mrr_desc_permit_no_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.mrr_desc
    ADD CONSTRAINT mrr_desc_permit_no_fkey FOREIGN KEY (permit_no) REFERENCES public.orders(permit_no) NOT VALID;
 J   ALTER TABLE ONLY public.mrr_desc DROP CONSTRAINT mrr_desc_permit_no_fkey;
       public          postgres    false    239    235    4029                       2606    16770    mrr mrr_dist_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.mrr
    ADD CONSTRAINT mrr_dist_id_fkey FOREIGN KEY (dist_id) REFERENCES public."DistrictMaster"(dist_id) NOT VALID;
 >   ALTER TABLE ONLY public.mrr DROP CONSTRAINT mrr_dist_id_fkey;
       public          postgres    false    234    3985    209                       2606    16775 ,   opening_balance opening_balance_dist_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.opening_balance
    ADD CONSTRAINT opening_balance_dist_id_fkey FOREIGN KEY (dist_id) REFERENCES public."DistrictMaster"(dist_id);
 V   ALTER TABLE ONLY public.opening_balance DROP CONSTRAINT opening_balance_dist_id_fkey;
       public          postgres    false    3985    238    209                       2606    16780 -   payment_desc payment_desc_transaction_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.payment_desc
    ADD CONSTRAINT payment_desc_transaction_id_fkey FOREIGN KEY (transaction_id) REFERENCES public.payment(transaction_id) NOT VALID;
 W   ALTER TABLE ONLY public.payment_desc DROP CONSTRAINT payment_desc_transaction_id_fkey;
       public          postgres    false    4031    242    240            �   �  x�}W]S�:}����I��Ix�A*r�ܙ���V�uJ{ﯿ+)E��8�.�k���fU�:���$f4�\����.�K)��pSn�}SvW��6�E0�uV��]q��˃ݽ���L�	�I����8!��%���
��d �F1��M��޾�}���-�a����ܫ��fIhD���򊤙��Q8Mxw��>���Wuv)EB�#.���'v��V‽��&�^�9^��Î'W�̤�PM>n��uU6A�;eeS��Ǽ�v��/h�km�vs�����1G/���YQ2�i����<���,��a�c����u��:˚�`a�����K[n0�k��~6��"J��bMe�?OA�
cοNa�N�fym��)9y��n�,+W�0ˋr�۰i�'��EQ_�T7ި�K))���f��g�I�8���!���x�c���f���-�CZ�*�4ȫ��
�)X��>�^�}�]n"��&�P%Tcbg�bɀː����a���Yi��ej��h��K�\�+�u��K0@�#U�u;")�D*3�@����C����b����D���y�{�%1�厠@#��W�}b��(
�`��*�p&�^c#��[��௶.�������e�֠��^�|j)4æ�DG*V�8����`!��ޮ�MA��/ ��w�Q�|1�&���Y�W��\��iW�U(����H�X$1g�U`I�D��힂n����z�&�"����4�۶��(~�g I�h��7��|���E�i�LT"�<�D�L�P���aJ��	�
���01㥙�>L'�į�l�rd��s�����!�$\Fc)��Q{��Xx��Zc5�SԻ�xB �]��>��M�~�wt��+��ӌ�DɄS�DX�3T)Cޯ���͆�|�����f�R%���-h�[4� ��Ū?��K�����R�6X8=�z���,;�۵I�fN#�Ȕ�vW'�:s%g5�)8酅��|'�~��-�w;����%���n	1�'L�>�=_ݦ�<���U�]��:Pa���q/�	��O����d؟q�Y��a:�|<�ݩ�6�S�{
r�٫nߠ3=��7I�?�[:�A>.h���j@�P
�u:K��cC"I�񵓳�Ԏ��|���f�b��]��=	K���̄�Lc��!N3ct���
���lnng^�����<9?
�p>Wo[�G�����'DK)�Ʊ�g�P�H�J|s��	�Ñ;4�oV��A�FӑƢz�e�4�/<	����l���Z��>j7�2��!rNnk��}�L�j�$��C?�X�!��X�c^l��s��M�r��^c�P��'7�?���@�M�֡���z�:V���N���i�tp��K�>Զ	nݥ�Q�*��.��$����<�v����:!� �GJk�اCSAgBM��J_��m�6Y/]͊"-�	ݩ�'6a�w����Pq\8�p��ϊ���*��x�]ݥ���~��@>�w�y9U��wWiU>�[�ޙp%�>'�vj��7�97���p�tJ"FN����� Ϟ�ū�N��������(��K��ﱈ�>��o�7���k�ԝd1��c��0�g�<P&�� ��ɞzF�c�ZŤ�o3w���'g�� �ڮ�6-p���N��]����?�vgRw��%Ŀ.����H0�}A����e8��(�������s|u�i�"���qVu�4���_���;�y#5`�V?�_�?�� �#      �   "  x��WMo�8=+���m��%��jG������ĉ�����!eŉ�b,��!�A�73o�P<)����:�h�H�,��u�@�ϟ/�v���'���n�~i݆�}&Ii�ofӪ$�jV�c2�B���ӻfN���˛䮩ڝ�x��4����r�S	�_T�&vt[՞���
��J.�����7Z��99�4�����@R`RPIy�nW����b������ߤj�kG��j��?ܣ�$���1��K6H	�93���� .���$�cg��|�]{xu�͚�5�C(!
\撧�D�(�_qie]I�6g$B�-��^mw+�;�X���a���.�����T���	��Dx.U2�LĈ�d�~7@�<OE�_o�|�\7#KnmU��̎�5L� M.x
��x��Ä���&���m9%���z�}��x�o�ׇܶ�X��\ GT� *�E.�_J�	F�k.	~�8�|`PL��g���o�D�=�xؠ�\�%
*_��t)���G|�#�����4*����F�e#���rַ�j����	:���(�Y<U&1z�G6ŀin���P�b�w�)�v�p�������#���(�b�f�M�"���1��F�W��{Fw�E�(��{���B�&�y�8�p�� �e�s��;��m��:7����R)e�|r.�q2p*�2;U�ԍ��#ۗ��� ��Es&R�c�b��M���ř��u��h����sK��#W�9�w=�<�����d2���n�q�?��7�f^��7BÐ@�Eۍ� ؝Ɏ9�
��B\��	:oe��������W1�g��n�W*ӗ��/������U�XNM�1����P��$�*F�t�ۺ��z�����ֆ��x񐀃&��3�F�1\�h���6o�?���'�`���k�pxp:`�#`��+B_���.�����6��{p_u��,��yp;l�\��P�����r�/�����4��	<�,g2�8���=�L�8T��k��n&����m��m uN��X��<x��ɽL�!B�S����ڼ�����Oc�+Z̢��o��N>[_7�dTSO�� �̩^p���Q�q�	n/;�3#�b��j�})��s��d<�=�����V0�G�a��,��<Xh�Y��Hdqq�/���������U�h2��mo@܈�V��e�4ZFՠ:F��a4�2s�{IȆ�M�6�}QQ[O'R|��]�q��A���΋���
��4-R8�H�y�^�^6I�3�k*��m E����ݗ�Gx;��Fc}�A�?Su������?���0      �      x��[ko�����+�}1�I6I��Hcu,?������m)V[-9��_���mKIsw'��OYu���J%�OF�&���/���3'r�L��m�z����淧UU/�Ǘ}S&2���ʼ#��V¥����B���ޔ��q�d��.��u9��;ד�b��I�ԹT�ɓ�q���9��o^6M�{i>���_H�i"h�m��	 ���� ��;2˙���$�j��	�����̦��/G0��#Ņ�R�^�1L͘|~�j]�:ׯ��� �x�����ſ��ۧ�6<�p��42�g�������0qs���h��d�v6�nO����<����r���qX|��`�Z/����@�z���^ ��|���b������a⬴��-}��VծZ��Fz'�@ԂE�8#�|����h����n�� p*t{���kuK_��K��Ay����{��ހ�L��6ûO�}_�v)�Lޛ�~w�@\�3i�"��WF��ϢsY�krKD���$���i�˄�O,��K��bI�
~2��)nK��pPr��pA�XU�Z	�N���"�T��4���U�q`��jX�UR;�)��݂�zj�o�R�sp-�n#���3�u�Ay�����\�>%V�;�HVߧ/����z�Mq�g�f�B��ꘗ&�<;�FE��'��g�62��%���\�=��Rmb�o�j��:{�&F�s���r�T�z�T���8�f�.�J�c��6N�G�P1��$?B��̈́�t�A�j��^��~��P:�QF5L:���e1.�q��ۢs[|.+�(ЎV9)ݪ�V'XN�䩳*Ȝ�TĔz��m�'ۻ-@e�q�j��I�����զ��\���C�FG�i�1�����y��y.������V�Ն�n�IL����t�� s�!��W���b��i�:�dRނ�z��o↫������!`űr�"ǼwY^��u1d���]p#8�z3=�8!TG�:f"��wy7��\�&�cN�E��M��L���ș~<�l*��-l��a�X��7�~�a2�|�3�b����e릷�3�Ȝ�MR?����ż9.�H+zc����3�t{���ӥ4HQR��r0�t6�T��S��s`	�((�g���;�j�\�;��]���q���L��u"m4 ��)�����`�PT�a�f�A�e��kS=7`8��v @u�T�(S�g�A|o(a�:NIe�H�US�7�9�r�������H5g���2W�-q\qU99����X�<Uk�۲Z�ITg�q6�B�Te�ط�5�����S1(;�>�I�"AZ'����5/��Īΰ)�*���2�x&�>D$�
6����R�p�D9+;✨��9�9���Uo� ����^#g��z���������0�X �,e\�s?�r�"3�XZ@�lR�NcICX�!`)�:�W)u�����͉��E��$�S�@�U��F�<�˪٭g1-eG-S-w���Q��1�j�$@�L:'������@��P����Z�eK-��~�]�
��%T�DH�.6 =���'�!L�I�b�3֛�R�ܶ��e���dPE[RY�av�%>�1�����)��]�j3)Qi6�A���r|�TGu$����wD�N�9hY��[-���u'�l�4�Rmp0�I�Yt��9�.��o�Ip,H��V���c]�fۇ��d�����r$^1Kf"r2Dy���jr?f�u ,Ee;{�WO�p�鮞����,p����d.���
�`��s�L��rYo�^7�ʙ߾W��8o��<vޒTr��	�������dѼn���q����%`��WE���,O�=&�q*](�&?�?���\},*�5}n|v���K��Ő䨕�C� �b��Q^�$"���xVk5�)BDϚ�6��"�H��(�s�f��1tK�O�8��!Gy��}��3�vR�4�o=MVF�[I���v'�iޓH!ҕy��|޼����j>R�GQ�/2��I2�^��j�N��� ��z��������I���c��G����*����Y�(�Ti�xΘJ2�^5��2:���q� G�X	�1Gd��3�����^�E�>TQ�.����p��Y��> of����5H%��әۿe���	�*�,��Bơ�Dx���E{n�������U��Iu�A����P��.��d�P���'^x��C�'�m������x��R�T!�b��}I�/�
R!��Z{�w��g�O������܌�4uQ]���	�CP��x�zZ�*��A�A���6S�����}+�J��,@����N���Ǒ8Ҥ[�Mm�Z��zs'�8���L�m��*���<������阬� W���{���4������]��:�
�?�����Oo����㍤��&z8��:0�7&7^�P��O����,��xO�.�5��@���\Ta��y����$۵���z@��t؜���Q
��2�J���)z7��	캄�7� �r'�㓇��d�9@��v�:P���O���Nk!��M���d���8;;�Omt�a[%��t=�����Z�{���+��Ւz'����"��@��A��M��J#\f�d�h�	&�� �eSM�6���hP�^��F(����;z�qlފ�n���PUN��;T�Ÿ߹���Q:C�����<�e�b��P���r�S9n�筬��VD�
���y�R�NM,MJ��>Z�P����rx����:7�`0
���T���U�l���
�ʑ�A �[j�XX��?���/��(�3�#����tf�M����|�5�zY�{֜�\��Me���I��v���Ae�@�qBJ��NMN4��~Mt.pP(�=!�����-9:uf V�j����/V'z��:4��N�\�"��`����Թ�O�^��8gk�@B�E����yͥwhp��X�.��_�G���[UN���] �PڷS�7���u'c��C����;m^��3�B_{��Xu��Be?��'m�K�>i$��ק���Q�dif�ݔ�M��?D�)��C
��ʽk� ��bF���Ö<�O��>�T��G�!q���B�i\�kS��|�'X���
�(\�P�n?|O6LO�k�hjjcLg_�6���Z�f 8*�XN ��@�fbE'��^�X��;1�x���x#�r
�����v ���n�0z�d�H�g��nN���CG(Yr��SŢ��
�~�nP�nS�eL���!�ϰQ+-l��;*����K����ng�WQ�j@jHv�lwU�Y�n����2q��uڧ2Z���R�!��?�u�r.ތ���C���Q�h?.�R��S�b,�K���h2(.���ܠ�dc��T�'�2^�֋��S&�2��
%�%D'���$�F[�H@U��w���XtHס}��.F�r;U��~|uw"g�$6ƣ��}�i�l��m��}��a����(/����`t�c���zo���� ����i�2�$>��ߖlL���b�
����MI��q+j�M5��Ms�M?�o���U:�0�mCt����h��v?'���i�=���s�$c\~�V};v������E`�Є�"`���n�1�	9W�v�M�,p��	x4|A�?��G��9+���{�qXR���w Ů^��fMB1]����Oߩ�	��Sw�@Pa�sr��Hm�=Š�/�E7,.j/�+�Ѧ�WSmNL�������t`(�6����P3���l�l��*�-2A�� ��;(����>����[�p=�����S��L�,�-d�g�S�N�����
��~Z����s@����`hr"���)�1:"j稇��Ǚ	�����B�}¥�M>�d�7��<�=���t����םh(�@�o�6����-��{�N���ΨB���yڂ؏�l�I���n^K펷�R�p�*�V?Mn?�͑�Tx�O���u�R�z*:u�Rڡ�ֻ<��Y@��C?����9"?>�"��/֤"�!(ۙ�i]�j�v�����f�s^�&�s�˦?��Wa�g��$S�o
f>zSX湍�G���u���֜����9� �  '.*�d�TI���c/�?��)Ig���x~�?�ّ��w`�y�)�nX˄-�Z�W�o@�ד.��r������jU�%Aۋ�����i9>w�@YƼ�t�_��Q�B�,8�10Y�Ȓ�;��,w����ٷ%��q�~���E��������>��ZHC�Q؟�3d���V�Ǵ2}��
4YV(|=��#-M*�h� ��je���.Ɵi���[-s��Q5+L$��w����(_� ���T�>�@M��m�V�_���Z�;׆��p.H�5{����(أ�\e.*H��M�UnR]�\� �0Z�^���}ny��掕ј��������^��k<)�w����V�u�E�������C�w�s����/@M�<���5~BG�-��n��܎�Ju�����b�zZU�{xO�\���,�Z�!o>fQJKZ�z0Zkw��)_Ѣ�2����&�M �/Z���6�C�i�/�(�ݼ�}�3`i�ʥ&��2�WenC��,�s��x7��fZm�j��$jNRD���J�˜�i��bx�ҭ�Go8.�7��~ww�c��u%�J��3E����)����^y<x�8���Ƿ�$}Se�{3�,�t��h��e1@�U��۫>ߺ�9m�>@~G�y���C�H���k��N!H�2|h�ܨ�Khe������
"��O�����]ty&8v(֯�!���P�uoa��[��xO���������"��Mt�����_~�_QZq      �   8  x�m�In1D��)�,�����9B�]��e�7�"���KU���y��+�g]�4?h\$�j]U������������祣�7��c_��0��N?;K'���-m8j$Բ���75O���j�ꎿJ.����kB��[qz'�^�Z�D0`mB0G%J4�/�kO�m\\K��L�aN
�eZLS��G���."H��Ɣbm���E9QM�I۽�,	Fsi���0�4'(_��s�T.Ze4�'.h3,ꖸ���>�n�ȫ����7|����K�%T9�%�J�.�b<��z�i-�]��L�~Q��CV�	�:����t��n�2A�U!/���H1����Q�-��ٜ 1�6��"3�H��nL'�LT��'F0ʜ'�0m���+��{j=�V7F�0zbl��p4�'ذ*?�;�ʉ1៾NjK���j95TOuޝ���@5K*}���AW����C��%|l���!Ԝf�&�؉ܝQ�N��U�����	f�y=:�$ߘ����R�:zK�a�T��4��Q�.�zbl��PW�H0��@�c3��]t�Ww%�6^}m5��[�&:1Z�J��m��!�1�L_��a0ܴ�%N�q� �Y�UqA9v��C6v����k� �?[��G俖���NFa?c��K�%|&.�o��O��LL@ifԿ�10��ڇͮV��G�oJ�a�l�?<�j4֬�«Φ	6-��O������g�	�v�z��:1+ε���U�[*�p[|b� �B�:K�$؞��pg[��0(����YzbhCH���Jt��1\��t$�ؓ��ءn�����Y���
>�~���}{���~Ʈtr0����6ts	8� B��[_`k��;��ڀU�T+���^��+~/Z1>pYX��w{��H�e٪~�:��:,��:�Se�E�j��w&>��c��`�Kq���t�m�HNN0�QѠ�������{���\�����8�$�����Æ���Wl����� ���~��Nh��~��U�����m��;젽;`W��	�B8���M��g��= ������pݞpkw��F�>9tFj���۶�m��z+�,�������nn~�6�W�E�oN�v�2+y����Ϭ��-���'��7������|�Ej�4���%Tl��//{�BG��P����ܴ�]V���l��7)p��ڣ��NX^�p��0�5�F	g=�9p�pk�s���l.Cw����[Vt�_���#���T��c�O�=�.	�89L����|3�x�n��zqT?+}7Al*�WҚp��aңߜڸǖI�F��ޒ`G�����!��\�z���X��޹���C�GN-=0�to���6�6�m�͓�����L�E�ܵ���u��_l�f|����)<�f��X���~���D�e�lI�g���mbf[��&&t|�����햀<̥���׬�`����h���sWH�QO�w�!H=9D���=j�������>Z�$ܞb������86K�5r܏�/� ;X�1�	ӓS[Jg���]�^��d��9?��7&;"a�vZ�?/ujϙ?ؿ������      �   �  x�ՕQo�0��ͯ�C6!���v�զjm��ڧ�@q+K4�X�N��3PF�"�bE���/��wg�:uO�.a����l4*C��o�OvR��m����<N]�]��AvU�Ǖ���R���B��*iI
��e3`���S�������hmEsƪ�"	�h�V=pkUϡ�{CA�^`�V���,�X�BJ�ϰd�E���ߏb�q��ʹ0��1
K��G�O�A�r;���PW�I��_�()�)��fʒ���'��*���2c}�'�~�\d��~b�{�1�r1����B݄d4����<L��sy{)5_}���_�%yX����8�?#�7��2���?�q|�$�}N#��[���^tO��$#��u��m��ޘ���_>�6ϓ�q��a��Ѽ�0G�t���l��}r{'[�a�&����#���j�\�F�[�6�O��{%Z��/" ��      �      x��}ms⸶�g�_�O���=�W�%[Χ��	o�jW�r��IH
������Z������:u�z��r�i�k-5�δ�S��r���_ʍ[��w��ޤ5p�$�K;��IF�<q��^V���}'ۼ�mV���f�\�9�64::Q䇔�����}���o/���{|}qa�_$�c.%WB^qߣ��"�|��0��K�N:���I��B�� +�N'��4���)����p?d��6��[����b�=��^xD�cD�F9���8n��U���;�l�2���)��Fg��FaF�ܩ!!����OH~�GT0�������$O;W��4L�y⎯�as�?������=�t�ݦ|vo^��y��ؕ����q���|�?y�����գ�Zט�p)��(�hȎ0뽕�P�T�F�j�9�ʅ7o�@��sI��i����O�����.�^M�3G2D0:�`�M��^���,*�Dx����@J!��f|��j:q�[u�F#5��I>I -w��&�E�Bc���q`�� x���ۼ��(9+D�҃/u�iX��u��e���@8`�r5I�x	�x�r����y�ߋ����[���=��g�5_�8�N�64:�j���!u�m�ݾ>�`߷�ٌ��,n��P�[�b��������I���$=�8�4:cZ��"��8/o���,�?�<����X{�^H���A��!��ʿ ۝��T�:�$≓���zQ3^C���"�A������s�y^mʗ�k��x�$���,p��*zi%!NzI�p����a�~Q n1ͲA��
�$�I��[�x4�
eĨ���.Kx�	p>,��MI#yn[a���C�$t�C�W����u���#�U��,#4$�_CD|2���i9�Oo�z������x�%%ZO���Z@*�k�K#�n�>'��^C���^��Q�g���F��0
�q��=-0���Sw ��f�MJ﷿Q|����:����#�[���љ�VI%�}���W�_��V��|u �ȁ�� 5�؅��>�o^!�N�#�,^��Q��G�����M��4:�5^�%��|���z����+���G�|}�u�=��ԡf@���荚�6�ub��й�Atq���Y�$��X�&+�ZF�����}�\��K`�hC��yx~U��!j��FF5�/ꭺw8�vp2OK}�e7�PnEYQ`g"#�|/ @��֚��}
�<B��2Ւc��BK��y���Y���(�{�����x5��R'b�CF�ٕ�%���c�W\�:�01m�ّ%��4ľ�9F5*�]��K7nK�	�tk���~����1�.5]�P,���z������ȸ�W��z�%�L{	0Ӹ����j35�*�;�o�!Ƹ0�`ѵe�j��~�`L|��[�<<�]>�x���V=�nr���,G�v{j8B[��O=��ϊ���9��u�,_��k��/6䄲���`�R�D_��G��1�sηA/�Bz�8^`����� s���퍁'�0�_��O�/�K0S�O�ḷ�y"`�ګ���X�8�Ma䪍������l�����6��w�1x]}�]��1��t���.��&%��,�1�,���~���`�(�y�n�j��\���ب1m�`��]mw�zw�FhۅO����W-����/���ڔ�X,֫׍[<�� ��߬@ݹw�o?ʵ�_��(�=s�d�"�tRY@����[x��`�O��qa����S������o��ʭ/��y����{/�޷�l����`���O�]`0�` ����9-�1#��V���-|��Ī;���х����[�/ϋ���f�N6�\��0�>�e{�)'"�^��ޮ� [? _�g8�cZ���}!_�x��	cA��_&�!>˧�$i�9I֗����q-B+�a���b�==<���Щ�Bق�59����52�4��X�����%h촋8�o3P��9�5�΄&e�G�ٸ�pF� o��Y���X�ŽZS��uM�Z����
5M�M�8�&�O��6�{�տ�,Dʌz������:1����OA� �������z�T���A-_7�����/"�1|v�E�Vt0^�-W)��xp�79x�=A`ؚ���<�grAqS(9�\�	��0�2�t/Q]������" �"�����rwg�>a�����0��O'�������H���I@L=_^ ��m�e�����J�|wշͫa��a�x\��A���߁�=QѠ�"��k@�@N��������!4���1Oh�h�NM��F�+0s�qawv���%Vmht6�Y	D�:!������L\�M5�
-�0BF�b���5���tL���ɐ�g�ĉ�a�*C
�69r^�����Q���`~���?v<��g?�:ӡ��A����A����bz3E��?�;>S�		|!�������m��e����GZ���!1���2��~�᏾�1��
��o�}��>�9%��Aπ�t���6�^2,0�u�d�K�/;I��Kް��Y�}��\p'u��d��RJ��t��*��V��<h-�V�0V)��[|�H�?�!���&��Y�s��,%ӹ.�["���{��o�z!��.~𣯀�SR�"d� 6f1?<�0����0G*�L��x2���.��s��s,^�Z��}1.0y�־�(�,��vAk�.��N5�q�G��U�A/��Ħ:k����}&��9�,zۭ��:9����΁���?�,�$l�њ�'�I�h<����N@��Ѡ�Ck��'���˵Z�D�N���Ӿ�߰N��wܻ�b�?�?5��x����p^6&i;�I��o�?�IØO���S0�� u��B\s�'wIf C�k�F�ِ ���"X��Fg�f4�����K�^���R%���Xw�R�X���u@����=~Gŷ�b�K����4)`�R2<�)wOXYQ~۔�Ͼ80ģS0�� ������X�[�V@O��לĝ;�ϐ��tnMC��R �#�ˏ������փM?��A4�I��m_�wx�c7���{�LuC2��;q��L�#h��hht�U�z�G�6���×
��x�(�&*��L�G>-�x�Z=2P/�ѱz	�=
Z9�=�:Qs��������Laß9(��3� 6x���uZ�������4O?C]?v�����j�� s��I+��#��0E:�R�����0oW/�ϫ�f�:�2���5���O����Q=t�X���<�T��G0~c��?����pe_7�@��V�hC�'����K Η�,;f~�(���[�G��TH��ӓ�z��=L���s_�� �^���rr썄�`�x��Ǫ���p��0�����1`m�Bv�F���ӿ*=���6e0^����%�ye�bm�`���km�SO�\�6jeCm�Bq N��K���%�����ųڄ����UY��x����+�A�ZWS%^*�����@?�+P}����^l�W(/���4S�K���%��'�X��N��0�p�zc�b.U[�ӿӶkiY�m��4�~�B{�N��@]^���V�y����[���[�헤���I~�b.x���|	�m��-�1�C]gv�u��f0B�=h���1�X&�{�F	h�<�y��3�RRK���>���ܮ��-D�c@�`.���1���F]8����) S�I��`�S|͆>g�嬲�a23dDpIÈ;X���{���L[�h�k�<�r	�6[0�j����#u���>��j[�$��mE�5��N	���Vv����g��Ci4����6
�\q��MFJ׷i�*�>�GŝNV�G�YC��^)#�+�)_�ǋui�\#���*ќr��Cm�`Tq/�;�֙<�;@�Od�,�MCda �P�� n�W~��"�g��Fj�����\}�u�*ΦY�)a��YMÝu#ʐp�.I�]�    ��liH�!�8��P�*wnUZW���Y'�5[V���Y=N|[B�~�)W�"��������x<��d:��؋����sjI954:a�eH���\�Vx�C<B��	��Lt#D�N^��M��:!�x64:�� ���?[!,<�<<޾H����i%��8}5�g�㬟����&�5��z�ȉIg��
V�ii;�5��d�l�D� ��M�L��.�QeXޘ�Y����ਡ�nL�,ܙ/o哌@��Q_��'���o�"m`�����a����J�[�6�zD��<vCC��`;��#g����[S�Y�="�C�H���]���X/Y�*���0�,����Y`VK��b�Zm���O<8�R�Bꑖe����tf>��Ҋ�錋��/�tԝ��t���#�{@ӌb�S_���,7+<Z+��4�Կ�	F�?V����0V�F�GSyw���M9~X��T�M��s|��o�l�s��Ĭy�ޠ�ʗZ�C ��qt��;�u�x��׈���b��Q6a Ė��it�q o��<�9�V;d���n	�V_��[e��ih����1�ȶ�yT���j-̯it&	�qpF�|(�����^>Z� sh�1Z�rU�qn��B�0cǯ��8��T54:��
YB��#�M�݂E,

8J@t���T��,�H���4�k���1ƨ��ľ��#��pALCL��jT�n��q���g����q"l�{���b%K 	1|x۝9�1��e�E���\T���)�tbWH����U��e�j����§m7+f�0�����V}l`2p㢓�8%����tt[��օ{��Ig��RIN��mh��P�2b�yzGi-�Q	ZϚ*~ũ�}�i����4�U;~�F7��, �nꆶ_0�;&g�T�#� :Kb� <�,��� �h��*Z��#�Yd�ǚ�?(��q��s� �B/��Q���i0O	�zbp��^ă�,Bb;Qoh��K�����bi@EB�P�W����t\7b����Y�<�=M��P!'!���M��y�s�;w�b�<�-�m��ւi��;0ps����Aq��b���kw��j�XA{*he%���W���y�z\���mU���V� 8�h�@Sv�����I�*ɏ�/�,�(�,nJCkl���&��a���iu>��o�	 �0 �>��5��4�b�?�װ| !n1�I��t�E���A��Ѳ%�ihtvo�a�LV1��:ŷ�%4X�3!i�5�&p�F
�[z�t!�����g�pfm�i{�3���'X�'t�JkpaPa�����(5�&��I��l���t��	b����#��sL48_��V�0���a��-j_��a�2z�iO�F��.�"p�-���t_#lk�5֊.W�VeY;�0�Mem'����
��R�_Ӊ�-���u����]M�M�()"}�<@���n����e�5���m�4��b�$M�j�nzS��kt0�nF|[N���T 6�Ӑp��_�����kl�(��X��V��0b��	6=�Ax�φ�'�����b���AVa.H��I���iz�ȼV���a*�9.�aB��L����3vb����AM����C�S|��)wK͉V�@�GJO���h���k2���g{S�Y�� 6���ձ����O�i�.!^U��y�\�~���~`�@�i��mCG/�^
��`ܢl��j5�"p乳ְ۬~�r���T�%�%��]>���@�{X�E>����,o)_��<91�{���z�t�p�a�[���P�Q#���E�U�0�;(]���2�0�T�	i7q:7�Y�s�l���Fg�Peϱ��	a��dt���-�fZ�q]��F��.����9(�=�9�	�.@4-�sCCk��A�"#g�+7o����z�*9�P��xAx{��5��$�΃���ì{ux��Ͱ�AK������~0�mX.h��o���d��B�ڬ�i�ũ���u�;H���w�Z��N6�ٲD��Q�?z[����y�~:�t9i顦�WOǵv�d;�7�>pQ�M��{����>��ۚƘvAKO���'/+�g�םQ�^\ci`j:���j�t��0.y���C�A��]�h낮0s�H'�o��N��q��kL�>wv�3�)p�O�r1-�8���0Ǩ�Ӌ ��KV.�-oX�،��/��P[��ˍ�޽=V����eU�;Z1�����f��X�����'x[����͔DD,B-U�Kx���|�]�U�w�dU�"����1H0�Y`��oF�v�����.)��ִ}q=�0��O���ي.��O��6Ӥ�Suᖪ�ȓ7��\�(��Ĥ�	:��&���p���r���4|T�!���-n:��nM�n�=O�����qw��\/�TӰ�Z�a$yE:J}�Kn�����sQu�D�n���1=�8u���u��^�]ꂯ1H �N����jsk&$Bl6gDR�/��7$XӄT��K�ǌ��D]OU_����m8�<
[���Y�	B��f���{L ����|�Ycr�{Z�n��s�bZ�[��t��4�L�TՄ�*����?���4���^֧<Ϩ��Yf�h���K���e9��z&ePJ���i	�׍Cse�)���̞:lEw�m����֖`�il��A�9��f��Ax�J�lA��`�V��D���E[�����%G�����v������z��sP�'6������>���ڂ�n ��G����uƴ`p<��+���LGG��f74���Q�f��J�dp`_ʃ{��"�`�s�o�uRn�
��f��n�oYs��w}�bښ��a�n�������g���$K���<�o�56��F�뒙�R����Y��Z��i����pS�y��|/����+����kG���'�x�vκg�d��* �-�̥�.ֆ�� ��xI���v�[��r�Q��
#)��K��o����2�poL��N�Ό5[���	 �n	8:�����ܬv[��f�2[،Ɂ��ć��X�}��a�ӹ�T�.��i�f ~$ף@?���8��b5�hiG<ܘ n���$�{w�S���gV�t��l�nlLu����]C�+�����/~�W`�/v�-�����m�����3?!�$���$�2��t�j2T6,��6����_�V'���f۳���Ic p��c>~balغ��b3&B������ߪ��Lw2��0`T�N-j��vbì���M���ݩmQD\B_��^�N �� p��Au=�n�����wvz�lH#B-F���NT�O�h ��|~6�2��k ���g��'�P�������L�[*���5�JK*� }*���`�vғZC�x]{�-�k��q�����є��]'���\pJ���t2,�|���ز����ڪ�2���>���/+��pP���'��+�kj=����nUӥ�ӽa8̻w�,#Q����oN) ��1]B����R�[�-kж����Q��=�տw��B���a'��]��4K���$�����ix^�������L�;5]��.?�e�̢;�.�-�]C�Ѥ⽪>8r�n�W�3�n����:9�5��8jr�e�UP�?���ǷY��mφ�@:���~���a�����R���6�8��t{�ރ��3����/Ỷ�l%5M���X��2_��Zl�)!'�\�T��8�[;n�q�x���ě�|�V�q�)�[
k��s��z��]��ӏ@Fx��6Hc^`*�10��&S�c�F�=G;Y?���J�=�d,�<��ƈ�ܓ�@Ӵ��]��E��E���<C"-QGC��{���#�Y�x��x��x��޺���ѓ<.>�v��f}<���
���9 ���N��6��X�KK��A�E'�Ѵ��T�G���U'f1wO+m����ApΥU����Z�+�۬g�	L�t���U�6E�5�E��4Ui���2�g���ݲ�� �  g��U��~�ˌ��)Wqz�e�O�����B�'@��i]�[jھk��Ng���+����$�r]5�8�k.T>�4��E��,�6&q)xI�I��;c�<����^����2t:��om?n�����N����I ��b\�w���'*5z���?���nl��]�������k]�&!����ǧڏ��a�G��?�i�Ʃ}�y�`���n<�)`�4ee���R#������vo
5]�8���Z �*���i�#?dB�0<^p7	/��}ӻѦ0�����^z�F<��9���"��;8��������뜤8M�5N�����v�E������;��|�'벂�}�dZ�q2��WaT��� n�b�[b5�w�i7�s�|�^�;C���щ��1a7U�e������zx��@jg��>0��8a2�܃[EUz<9���"��Y˄j���&Fa�"g��!���/5<����	�i��)f)&j���ט#�y�N�s��J�<�7��Um�j��?O:}u�M��4O��{xkE#ˑ����1�=� 0W��v�Ĵ4�T���u�c`��}���)�TeC.#y���BO�]�~}a�9��6G{0b�kѫ��Yhͥ�\;��$��Xac���]X?��f���%^��:{K������U�o�����:�C.      �      x��\Ys�H�~f�
<�ƒ������& �  ����m�mO˒CmM����,�������Pئ,�WG�gY��}תd�k5)^?&RL�×�9<}�$qE�ߐ��(��8z��<JC�e����&v�-*�k��LH��l��ރ��/_���w/��o�/߂�߃�>=��G����i��_�߾^��Z���x.Lh��D����������$1"j���C�AS��4X�v���	B�@Ds�̅3!8:=}}z�o�|<�&��!�4h��쾱;[��q��hGN:�OֶZ�Ep��?o`;�}��ʮms�%�š��2���CX�ͻ�]��m ��kد}�u�y�N_a�R=Ft}����5�^=�A�txvO��^�������}��Xм�k��!2�Hs�[C$'��z�����۷�7�����@e�?�������
�i�b��-�m���da�%vF��;؋����(� ;���4"�}�OO����<ơ��0�8�IA��@�H� �$f7B�b�k�y}>�|���� s���Ov��`�ui�uqm�zn�jŁØdD��v�UKKV������r�^�A�H�&  S0���uL:�A��= �T�����6*�u�B�ljg�]�ܖ�aYT�(�S%��2�,V���A.�_ d��p'%ވ��]�=pfn�vW�p#E�cSW���1�vA|Z�Hj�����I�Ve4�@�5{��"�=�`W������2N�M�/l��HgB�/
�u��=���h[��9\��6�4��߀״eП�g����7)�N|�:x���=����kًo�fui�
�LHD!w�M��╜�\�?��Vp2�24*�D���/ZG��(�<�[�
l����`3	�b���$K4i!���ΈN��/�=�[���Y(4e�q:�`���V�F�H4g��B��.֣c`U��&*H���fP�a�7E��YȈ1"<0e7�E6W*�bV2Yt"�	]#w,���̛��%#��:	
����8��%#f�b=,5H@Ǭd��d��D6iV��1���<������چL�*��LN�I�����xRǏ��&��@�:͝�v��+>�=SjD��E[��mmT�M��&D ⹒J�p���%S�PjR���=(�rq��8��(I8C��3�wc&?���UQF�Xb�Q���n��	r�!��_qwb�/�0̚z��CFz�!.�IN<�a:&~����Y`��.ѐ ������
8�o�aw�v�����xx;|=@�z�
6���Hِ�d�UhT�'�
1H>��*�S@CW&"��I$н��T�I�[t:	�{<��Yt��t�j�w��;���G��f�z�y�3��l"f��a��P]!��L(R��q��[����
��ML�}�KL�!����</�N��qBc�$�7 �=�-$��2��7���Vp��C g�����7�Fc�;�$���;v��Wp�[�7�� �6p��)����W�3�Md�D-R��A���(��T�1��jm]h�^f�0!&2�~�s�d2o�nj�F}�i"4�8a��hE��%��2��AQ��Q��01у��/����j~�D�O~�r�b�^��K����*������L^�M�/U�T�@����{���)�%i�����9�|�vx�&�p]�I:Xu�\�i���j�Փ��\��Q��˺n�rm4��`k��j|��y�ό���+�S���)�_�]�S6	4x�
`�z��ʍ�W��������'��#جZ[�ŒMw���8	�-֝X�XeFPȣU�Nw�6��vb����(bp�\�X�!�GI��%\E4����$��)��n3��4���HPecG�?m�2pڊ�)����EO�G7y]$E���ۊt^��<�U^슲��l2,F�O�\=RK ��s�����A����bB6�;t����+	�������z(�"��pз���ʄ�L������9fF2L=�.9�t��0"<�h9��ڣ���>�T�;o p�,1�r�e��xAS�[���[$�K�G<��]=��MW=@4R�y��B�kA͋u���2��B�M �!�kf�|z�R���Xm�%%�%c��$X�̫�0e��0���L#ٗ+��v����*�Q���G|/3��b��h.���2�f��ݥ�I���P�;�,Vg��� $��1�������I6���<Mƀ�*t�Вf	�6����1تM�TU�1�~=9�ʁ��F�u���-��0_��i6�=|~�����`s���?1@aW/
[�"��P�T�1�dW�S�>�3�Ә�䫲(W�6������j��9`���lF�!5�M��
f �N��'�"K����>w��b��nW�3���I�����\��S���M��ʻ}i���#~��T��?���9f�}Yݿ��0�Y��S�Sm��:�A(t����BSe��F&:�)D�],OW��L!­�5��������O��@���XL�q!#ĥ'?k n�"�)����6�'� 7QT�њ��]�w�|�3�p�p	^�`�B�e��EXtt��b��"q�s���2�9,����y�$B���Ɗ!~^�ňe�Ŀq�f�a�fԷ�����(�/����\�.��#��4�K͙��1$�b�j&3�j$ �߉�o!�M=z�Jz�㜍B��(b�K�H�p�#"�(��"��A`7e�e���p9$��gp4	@�}��'�?���h���uuy�$ U6ѐ��ѥRl�N�)�k[W^�s��R��]1>�%�]�,^�^@Q�b<rL.���H��������*8��0�s��
1�1�+���Q�%�l��:�+��䁇sNB>�T�~��`�����k�`�n"��j@Z�/��w���c�T��_9I3�����rT%F�*�Oދ�`�7��w�#F�'�ۚ&I��z�"'ߵ;��7��	)Ò�v�"FH���-K��G�q5vQÕ��	��ʩN�-9�#4��D�m\d4�m���EK!w�ƹv4#Fi�aU=�X�$�4S�9jG/b�^̤��럫�(�	m���VbV�]�Z��4�G+=��"��,O�^�β�#C]�}ߚY�E�];�Ձ?� ��n�7!G)埋v	�-!
��C�PG��z�gL7�`�H��E���P=���o��a�^cA���~+)�}�����
%�8aĖ��q�2h�\�Dp����.s[����?.=Wd��U2��4Г��^a�z<��q_�Ht:=e�)f�5�e�[�X��M]`v̝@���%�0���4��KQ ��_@���1'�r_pb���'�P���a�;X7!͡�z�˽�Ø�~n�i���T���c�����Ҷ��-���"�N�R����3�eԔ��*)y�co�Zw�˴�R@��%���g,^�
��8���+,�-!��O�k�X^�v�4!pr��1aʵ����Vv{Ɏ��&��Ю�Z��N Q\��[KS��̝����pdy��vKL᠃!6�_��g������bUe��& �8Z\8��4\"����ट����4�s$�;���_��aڐ�,?�����r���t���Y�b��Il������d9���4�.
��-w�
��.��6�c�K�̛�k/V7@yW�H�Ҡ�P�C��MX����E��,�X��dj���)�Y���q��د��]��YE��a���
7W!ËU�c�l����p��6���f�w��İsGc'�~��������m8{���KU��oS��.�(��!/,���*����t{X��<`S7���l�.k**�|��5Ġe����$�`'�4_���P�-p5�i�6���)��bK�C͎�
7ց9�wW� VuN��d	M����`	�a�ք���X����U˿� ��N��П��Ǉܑ�
��e;���(�a�� a  )�6����C�EQa���.����'
@��Ov����:�O*<s���`
�Yd	�6�.�/ٸ ��q�z��ԍ�`����F�rֈ+9��4�,`L:`}� �~V69�<��#3��P����I^X����1�D4�D_�2T��׳0�E��z��0|D&'z!�q�>�y�Γz�'S�a��)�ؠ;0��벃��5%����:j�W�r���M�`��)����_�\,��.lW�]��1�0��I?c�|@zR�+�� 
J48$��Ƙ����yg$�ݿ���)�-��!J0z�|܃?1x�w�5�eo�`k�+�[��P8��m�z%��Oܼ�;�;0M�w��Q�����s�`�%�g��= 7��.6v��ŵ��S�[5T�ͼ��h��u��V�w)�E\F#�}��a	��Ѽ{(n��]�����
,��Z�d�Ʌ{�'n��v�4�ay2ag+�{(n���������!#��0�h�#���w��$��*�� _�ۭ
+�q����G~b�r�R�1�r�����ϑ)�8N�6N�O�_�93�,��`v�S|̳	]��7&4��vo���E�I���h4�1�e�$H"s��XR6�A��v"��>Ny!��@�������<�㿹�*�V�^�{�'�o�����z�]5��-}���q�n�`!7t&�w�>v,Gch�Tq/�D<�[�P��� ���MY����O�/��+��b6�q��D2:�p�ź�֫ݻ۾.[��JJ<����d�ZK����}���2��\�ƞ�e��?*{���ŀ���{T��F2R��3�;}8���E�����9�b5_�p�
E2�2z�����
��٧��=1�ǀ�Y@��B���0���1����I#5Yxq�)�� ��^F���	fl�mW��	~\5����9J{����8�;?�o�!��|EJ��b��;Z[׻b�Y!��+�`�h'@���$�t/�`4�6�;�K\�s\�Q[��n�W�t�_�-�?>��^��u�B��^$�sQ����*o�O�%8}�Өlȓ�v[���\k����#z}j��_�~��� i�I      �   U	  x��X�r�J}��B`��*u�t�!cd��d*/m�,\&���Y�
�S$��Ҳ��{i����̈́ϣIԋ�����r���7����v�z�|��%�"7W^�7�fa�� �D:ZpEUR:�0zM�5S	;Rt�C8Qo<���[V��k��n�y�7���͙��.�&[y��0[��s��+��F�RI΄�ҙu�1�*�ˈ3��GQ|;�m��>E;����ȻYn~����Y�L���)0"*R�B0h��������[��"�F���N��f`��(�J��(g�%���n���"9]R��l^L�D���=��YZ�����@�	�y`�C�/�¢�|Q��ᜇ�ˀ�ס
%�K�Ӎ��ôoĺ?�M�u��81�w�����?���
��v�'�`IT�C�4���)|�9x��^���?��ٿ�Ѵ��	�R*CI$�P!B�2
r}�O��(�+�����|���^-�<-KC�x��I��Ԅ��)���@�-Zկ�T7��R��h���B�jg�0�&�G�e���}썓E�l���f�N^���&7��]Q(��Dw��Cu�˪����QGƹJ	��:<�.c G�L��N�6O&[�m���2�b�'��h��y�Jj�M*��_���Y�P?��d�g��r`��8S���L�ZUN\h�塕��\N�E�&��s�}I���zZ�YUCV���$r�$�Ok����6�֋0���&8��U~����K�3̧eO9Yiy���>�����'�%۟8$��j[8V�q��~�r�}~aG�E�ߢ8��ٞ�Zq���)��.���!�W|�͑�8���_L͛Y�Ƙ5f�,)��,�P����Ҿnqk[�,�* .��4�*l>;z ��p I�i4*(t�������.A�/�fe��AO_YƇ/"g!�<9������;/-�_K��y`����x�r���q/�֍�ӧNBm{ӍAmt�e�-��f��_Z="��g�$/[&*����T��*�ֶ��k�6{/�YoЇ8������,�j�ҥԹE�����*�V�uj_�����剱 �yc��[�
����Q�H�P���.}�8/ž����|�8F��g����A4.Iyƙk2��\8�u��~�b�����I����˓��`�QPז<$=������ �2�5N���Y��>̚&�s�v��n,�/������7I�ˑ���r�Y_D�!L�s����-�13k�0fI�6��v�Ǝ՛.3dM\�sB���� }�[T�ٵ�Ķ@���&ͪ�Z�n��ҕ7��������͛m��,$�H�khf-�Q!��Ծ�C'-�^�GQA��VQsP�X�tֈ�¥ܹ��*�>Y��7yQ3w��i)ׯ z��Z�t��P�&��b�EqW��XC�K�[�Q�0N�a�+�q�(�|1e������[����z}w�(�	�v�8�&j�!��O��.��ǹ��ꋗ� BH�)�5Ff�[:#x ��^Q��<�c�Y�җ���Y��Z������w~9Х�j;T�F�x�,L�T��>�Ϫ������kC�c;lZF ����]PaZ���2g������ɴڰ=��n�Mj�y^5�д(�b���Ў[!?�F��]X��#��^����%8���jv�]8����ctS؆3�V?�o�H��X=Fo�Ќg�%�K�t�z�S& �A�\���'���*��Fi��xk# =��C|7(��kxҊ���I�O�$��> -�d���"/�z�瀈��U��"HM,rB1��B�k���yї��
)����,��s$e�����e*:{ٯ������2+Pk
�`쾋 ����l��J@���d�Ͳֲ6	����]���������@��vy������kV����Z�
�;��C�W�Y+�-8n�8�<hy�r�J�����F��xn�3�B����I�B�mZg��y)�>Y�x+$������T][݁O۽US{���Ph��I����G@��l����(z�� F� �q�⛏�1<}qeW��'O�-⻱7��:�&�!ZL|���1 eS�D�����>�V8��ýJސ�;��7�Y�X��E�b7?��!�D���G��~����o��M��� ����~Ťˤ3AUv��
~n��|��~�<��M�z��nX�;c�ʪ�J|y��?��:0[%!�`y���kmH4�F��D~��դ�.��$0v�{X�����IP�}n뽿qI�9s�ןٛ-�њD��5����������Ƽ�� �Ѓ�>��2��_Z�C�ۦ�˲��;hƨ[���K<�F�K%[V���7���1r)9��<�\q���������      �     x�5QKn� \�Syߥ"'���R��:i�1�3�`,XB/j��Ⱦr�ד0r\#�8����K#���u1�H扩O�1�y����uE[,Uy��>ΒY���A��;��@�i%�8��	q�U�F�馽��!E����)x�wd1��S�<��sed���F69Y�~!�^��uS�F޴� g�r��Ȫ�¯^�0�:���k(7(���e�ҵ�����ݱ�^F�S�%,�!�D�HZH�ƫ��kE�o�M��N�A���?����~ ��a�      �   A   x�s	3�t�K-J�,N,����r	3�tL/�W�ML���T��!B�y�%@�	�[jj
W� �
�      �      x��[W�Ȳǟ�O�����w�d�%�5���/̐�\f����OUK�%�Em���C�F����ץ����������Ň�˿��\|��a���ß����V��`�S�f����M�|�wr��0�dF]|���{x�>$���d��>���������n___�����p��f�GU׻������˫O�o��s����;\Y!��J	g�۫?�՗�>����
�Q{:b�ɧ\�8�)UK�)�/��3��L��jQ��y��w�������4���}���=�痟����#dF�j�-���\SS��M���[߫=Bl�Yܧ�u�1�Q:�3]�,��H���|{Uq%�亘�6LJ1EK�)�R�4��j����`%������9V�Զ�~���|��XB����aD1/Å�j���qQK��y剽j>�]�\&����v�hk�-�&�un��ԵK���~�_���p��#+V�߅�(��pn:��Ib�𔹙t3�k��ת�,�����
��[o��Քk��5�tm?�&�����#ƆAg��'��x��
�����O��(P��-�tr��_𿊚Қ;^M2f�.Yj�35�i�vs{s[����5#��ZYTX�vԀ(æ��I���#[�0C��󯵵1���M,����W��#����`�Z�//� l����2H�]�7ٯo>/�ظ�͊�Y���46�x:��b����ߠ��6���>fh�r���ɖ�&��l�����Rq|���\�r�� ����i�HO�W�W���z�~�����Q���qS�(�{r�i5!e[�w�,��h�)��<jh�C�fv���B`0D֨����~��1g���'T���5�~�6/��D k	Br�!���1����e�ZǍŉk��	Lz�3R�I�Z[��tpv�3��f����G��q�1)�����h�������TR�2�kT 3P����|���C�&�-ǔt��G)}'���$�#şr1��/���h�@F�.ȅ����$~bAe�a��;2#8��Rf�+�'���R�iw�P+��|�l<�aƛ�[��@(���e]�ieTJ?t�4Y��i���;��?����j��f�j���=�9M"��*(
�p��܀�,cM�)jR���tR�:�<�n]iY8S��å��6� }-#�p��;Ƿ����	��Q�#�X����WM�8�E1%_�Q`r�\?�l& �j#�E�6,����;�Kg���4��z���o���(^�==_-[9�w ҦŜ��D�k��q�c���b&8iO�ў��>�)�jA�5��^����
��bNRr|��'\��*cMh��j�8)m�z"�����8�ռ���M$��Wj��z����p���f�1���#c�&�SC �9�ڙ����o���-�J*��Z]��w�����d�{�b�fWU{���	P�f#��͌�yٽ,��i�LAT�Za�̣>˟	ȧܐ�Y������l��t���:�;�/������16�j�� ҵc�@��렰;�J���q3���3_8��,!,0�MZEc톰�UA�5wz
��d����H �G���/�'��s0e��B�r�C��ۏY�1�?8nf�V�ˍ�8��!b�;�L���i+�7V�R�g�s���9�=�">_NH��ִب��A�_��`J�?.-.�FFi62F>��g�j��A������3�w�~�i��O����=\>U��W,�݉��;�Q�����%?�v�Z�&*�gLi5>C���3k�jE1�'�U!7�]�5�_�rQ3�<�`��r�I��z����<��D	
O�>��9ryLD�)^��|YM�$[�~h����R*&M��/�Q��Zʴ/�6��9npV&�
�T0�:%�{r@)fNŉH��,4�2jN��j�����ݗ7'�X�p���J�^^��lG�9��t�F����A�1�T��ep�φ0'S�?E�k��Z�X��ِc6�g$��I��*�V��\m@C���с3#_�"z(�e;�}���8ް���X:k��&�Yj����1�^6��TӢ�Tp�N~�r����Eu���Ւ3��bW��\O�Z���Qba����Vg�ݣ$�����)Q;	Œة�$F/S����{��.׉��w�A��
��T�!fBո��~>?��:"|q8�a.�mt�?��1hEz$A�8�k��K���Or�w6��0�0��]
a�(�맅T!/?^4F�F�ڦ��>|��}����ݻw��eë��/�<���(�ب-ȡh��V\�о,N���CZ{d��*�4Y&Y�w޸�����t�㫩��Մ��˂��	z��)qYMl!Ф�dlA;jQ�\�Z��v�Az������ǘ��!83i�A�XD��0|�xQ6���7���8�(���9_yer�tm��R�JZ7�#J��@��������#��#gF�k��4����2�x���c0I�p��r#�Pt��S���aK�V�Tv����͌����y]�E�p��%�&� �0�<
KJ�22�g=�>�
v���&	�WFx���;�rFDwn���gR�)N�=E���1�>�S��)lU\�gG����9��5������[�e�O9	=
<B�S(�۹]{xͭ��$����ñt[jgz�>�7��X�&Oګ9ϱ�$�y�Ս��H>9/9�tN>9O+�Q���@&5ѷ��ϰ�ϛ���~�-�]0�S�B�x�p_A+_�P���3�F�"Tꇆd?��Q���4j>����/��ɇa&�T{�l��M�w�C�-� �'���:�<��s�� ��$�}�a��Mڵ �>
S���k1��
C�#g�~�M�I:�@#���FV6�e��d��u�X�GFr�`����B�ƶ�?���-�sTo��5�Kb1�{cXed73�>��������L���b����
�puBAt������ /���f��#bt�@�7'b�/bU�T�Ȃ]���Phe2hc�8�/��!V�r73�ނc�6�AG�m�
�N�6A��,m��5
�n��P���Å�b�B���C�Z-V���?������-K�:�h��o��"�4<k�4ʍ����f��&v��~�>N�Ɩ��d�X#Fj���n����$�X^zL�2�̺T��?�gR��6.�{_4QG�6>q/8�h7P�1׏�4�Gj�kI�����k+�ܝ"����<���4�����9�dѧ����?'����73n+E�e�7��OS�O���tw����w}��t}�.��i�0ьSIXqE���HJnp�̸�}��֢;����P>_X^,�$�>����Q�DV<$�\� yp�̸{�|�p�&5���G(����-����P\^,;��p��;z2�9L�Q��U1FB�b+��09��^c�
��N7$�/Y����<hg�5$:��`{M�S{Pl���q�;`��� �Lv�X��K��Ԓ0�d)2�z	h�I�chݜl^��DE�bh��;z����W�ǡ],��XR�Pc�F��q�rT��8)&�qX�2��KT!���b��fI����@��i_r�uyr�{s�)L�͟ϏO���P܏������5ls��Մ���oH3�̏���^�*֬ ~Ȣx�d:�}2\F\?�eT�H�WP"��Q���b
�Fֆ[ޥl���\(�{z� �h��siO/������?�9�ϊg]s��0���|^a�@�ǥ�{�`�M�w�x�3	y�1l�������%@�+�cƗ`�6�s��s�{��������5��5�iP*]{�`�z�i`�B����\��7\s�  ��,�(�D+]�kp�J޿r�k����W�:���q'�o�!k+h�C��(f�;�M��Y�H�n��t���%mW3)��S��ʆ�Q`[�Ћs�l �����t�(t��icT�֐��)a�I�q��3ƾt�v'J�I�ґ�p]�q�1P΍M��c��D�G�i�<ʞK�9��qm*^h�� �  �6��_,UP��l��w �����Fƀ�L�zq;��]M��SԹߍ��#CݥC#����^Ɯo
C��ͫ�OG���}���G�C��|������x꒥y;v�:����X�hh�3�uż�X��o���3a�1�}�����;xcb���ųmw�M���ae�F
�2Z�x��|�*��!�r�W��r��~�9g\�E���`�ĸ$c+��&�A�!����(_чm��ʦF�Bİ�(t�%� �Q/�R
J}	�p�`O�[(@L�lہE�Zk�����h��	�=7���q����P��s�%��IHu��V
׮v�a���T��3�i��)�wU��,ᴔC-ѣ��!*�9;VY�y\G����p�'�
�m��C��bKc	|(�,g��z4m�z�oX�b�v�%���_�>CF�m�yS�a��Bf'c��Ўs�Q:w�2�)F��5���uC� �4���o&\i-*�#�NJ� ���F�/b
)�>%�+'kK������1g
8����}N��M&T����L��z��{�\����G���̋�*��j��I	���=�S��g��V��[H���\_�J!و=֪�C��[�D�FT��L�T��!�|�ҹy���vmJ��(~��Xנ��qD��$Q� y��0d��v<�@���}��(�aA�ߎ���!�'˗&��X�0#ڽ�)˅v�Ezz�p�o�B��p9H�(�b�.�D�k�Э�Yz���U#r�����(�k��GCDv6,�c����}>I��iR�4�s8��=�I�%HL��/Bj	_Df�� ���X���m�	���(�k��m��F~����?۷�S�'�%+��Ko�s�<W�z�
,[� s�)]gr麎��x�W�!�Ɣ���� �ն�|ۼ42gAw����jq>��,]��ja���s+MjW^�\����eB�I�܀�jq��1b�ŀ��yh�-�3��xs�v�y��J�r�7�sK��$q�sj����$�:���id��s�����\m�\E��q��#�'����%"{�%��!�*Rad����<���|)�0_
9%A�-���<� ����r1})��`�QO��H���j���}�0���~fZ#=M����|�ϻ9��&�����9��c�]���ȱ���?H@ӔL㻤,���Vȍ~��h����	�Dqi�:o\���*�>2Q��BY˦e*���[�7e�[�S��'�p�m5���n���o�`PΉ��R�fw�2$�9��1ʤT'�ŵ�Y�7El=���ֆ����WAzo�AxP�A�r�כ�y��o� g�2��� �6u�dz��|T8p������i ��Ě��|�[>_��T��Ǡ޵U�=Yͻ�X�0�t��v���O���a����8��l�g���R�P�_|��q猲(|��|}aVB�=�0 �N�ܜ���p�`�j�t`q�q�=g?��Ҷ�]e�o6��U?y�����3�      �      x��}�v�H��5�)����E8w$x�͖ʖ�e���K,�]��R�|5�0o8O2� ��Hq�ߧ�V&32#����������;��ONN:��O>��:I�#�;*�T�I��`����bjX�dʕ���_���x0�6����d����#������~0Lg��ɜ<<��7��Ѡs1��U:�n;P1����%�3Wd�9
�:~8�KM�i�h��䑠��?��y;�·�����s6��c�6��År4�<��nȇ��p>�%��޾=����a���[�2�M�)yuq�����?�c�e�0ޣ��L�Q��5���$�\,�"����Pub)ډQ�����?dĄ{�z�GL���"T��g�sp|~�<�,�q6�n�Û��`��t�!��9\<L'~Ǆ�_ȿ�����.���~�l�CL��qѓI$x����`�K}���KP0S��EhO�a�L���b<'�����J>�o#�9J���>�N'7w��~A%��~HTғ�-c���)�;���x ^�o������o��� q������?<N�w����Q3�AyO�H$%�bg ���5����|2휜��\uN�7w 1�Q�S���ұY�UGH�ddL���Ȱ,�B�=͙�`O�yzs7���11e	����k�vG4T(��'F��y	BUs���%�0cH�K���$L8R��I��ER�i̍���&o��#*�j�Mң`NJ���ܑ	Oti�̉�M�8�`��>U�3�w�I�vG4T(���"%��K����u������������_�}� oyGjJc��|;Me$U���(�Y���F����*�h�Pd�J�����P�8�BN?~�ppq�Tį������uGQ.�B��Ii�g�,��-K5�������*�h�Pd�D
4dW �9�:��s��9�8��K��x�H���w���z�:8��q�NX+e,�X���	-�݀��]��l5���Khi����~�Q �kX�j��d,���ӄJ��CY�U�P��V3X;�D\އHމ z�gR�Ll'�,�e8y�TR#Ď����*�h�Pd�<�.���{��:��v�7�������.#\v�� ���
��q�:�,�`~�,5�%;���8��B����=*z�DB���Z�} RQC��;��V0��Ac�(Y�"gi��G5��mp�ۮ�(�Pd�)n�D&Y���<��X��3r������6�!����'`e�#Ï%1����E��5tGb<o��#*�j���aSM������W�w����a1�� }��{ab%:�`Y��$�`;Zu�mWqDC�"[�@�͛B���rB�ʬd�ٿ>9�@p�	�+�Da ÕI��2�f�4�T�MA,�����m�W!#(�6�m���-V�U(2�N؉��z�c��&8.'�S�)7D
X�@���4ObX\�$�`��>UJ�~0f��G�� p�2��穉H�b4T(2�N�u��z�cD@ة�k�2�q�+����H'Y�g���26BJ���qAQ"d%|����-V�AC�"3넽
�s�����W�M���x0�p�!AȐW��_����l�A����ee�U�p�R,�`���4���*:�feN�+g�{��)e@Z��#�Pdf����S�y,������(I.ޑ/��~Hw{D-`)�{Đ�2<��R����,�-�<�/���2�ɘ�K�+���B��u®�d�s� �+h#��/���O����B&�������O���	X�8�_q�%�h&���K
-V�AC�"3�]gʨ�<����4,��D}�ɮg�?�N�&�W���0�_�hc���D�S�,�e(B
�S��-�&I��qK�<ҐՆ*k��� ���Y'd����
���4����o��җ\����$L�)8L,�Q��%(���`>ސ�ɸ�́�%��s�Ų&BB}Y�!Q���W��иP�r�0E�`��sk�����b0�'��؜�vϚ!h�["L����U!���#��/�i�:��<$~h�b�=�Θ��/}�����󒁭Z�]�������IǷ$Ԟ��]�=��s�����2�zLG�oF�fkh��⸂�5If�G�سQ�0�8�RW:�o)q�/E�����W�t�\�B��BV3&hO�G5r�1��ap8�{ͻQ:z�����!,�&�o���b��0�AD�ƌn֓���=t�Ub���6��®K#	��M��z:y�C�����d�+��k{������0YBWy׸���N��I�~�ʬ'=I�q�l�p���"�t��&^$�)T��.ژ(ay�"��T�"=ّ$o��#*�jv�A{d��I����G�:"��� ��u�_��r˖RCc������*�6������:;߰�U�g����������C��_I1r9�0iw@��7�_64K���Y�cƬ�g*�0#�I��z!e1�����Wh������u�2�9wE��!P�҈ë����\�㳰�·\q���HQ�varYƮ���R�%n_����]��I�E��ՈbI=�
-V�AC�"3��h�s��Ƙ@�2*6Z�C�Q�2X�g!�M5��'1&qG7	H�.d`9l�g y�|�P���:a��	�s�FCPI�����V�.JP�S>�eV(��H��SO	[f�%����e4c�ү���Z����
Ef�	�-l������a�R2�����ʛ�'�;�f���̀,U�<f��1�a���<�e�|/�JJ�w?Z;E�����>c��=�+��*�Y'�a���U��&���{N&ߛ�R���!7����B� %9��2C��N��#Db�}H� ��O����RB���S`�.jyce�Ci��Uz�_�[�X]~�rrE����\!\��|`�L��]��|H���Zub�;;�� ��ɧx�	��������X�)��V�Rמ���ʈS_Z�`������Z���0Ma��s=�d�0��2@���3H(�h�����?���λ�ݘ �(��p`��� c�?A��� N��?'v��qMl�v6Rt�@v����bZ����(�j�<�.�����a�L��p2&��DBF�)����������o��o�|<�3N��ZXf\"E���L�!�p�u�_LH�U=t�v6Rt�] �Lơ�iN��y;��3xf�,[�Ґ���3oN� (:�z�'�t���dᩜ ��W�8�'�5a�l��r��d|�p�'O��8l���G�,�����Z('��)Mސ���C����Ms�UF�	+(?n�[�+|��ܬ����l��MFv��7T�I$ǋ���]���\�9�|C���p2������O"����,����gsr8B!ܽYܓ[�s��F
&�iD�҇�f8���i$*�TH`0s��0�Ҏ���֎�'���+kg#E'Pd��8��iNj���?r�|�y?���1��6Y��]�_ r�B_O'��VI>�.��r�%i�ı
L&&$v��9�|;)�ᕑ]&㻚�8�#�W!߇�;rz|yB���_�	�(�g��p<�s+�����ϯə+p��2�b����t4�/���Y�{2��������՘'��{2�zRd��j~���,�p��N��A��|�¡��޷q�^mp�qOfG�rg7���'����{2��b���N��T Y$�
=��C�&7��.!�{����\��w���x�
�Jh5�oP���j&��MD�jx]A��F��0�@v��+��'�f��y��5�5%������{����DB�n�cG�K`qV��"kg#����e2���'�o�I9s4�N�a8�8 i=��ѠN��9:��&��Gɻ����Jߡ�_Q({T�`&㵓w�`I�Q/�JB�Q4~;P\��$��e�Mb�g�8$�B+���?���'c�G�T���?۝r��v�Y���ϴ���u5���t,���vk����u>� 2lL&�yc\D��^k�����=�?��:|�:���F�\,�s��ٳ�\��4�F���
�7    +�X�OL�d��E��8nX�7^3�2w^�3Xf��|�8�;j�\f�[�'�T�Ԡ��*f��k��:,�,��m�Y�p�ڍ��O���=8�r�'��6T��ab�pǺ>�e�r˧ ��͖��*�h�Pd�	>V�HI� 7F�B㯍�Ҟ�n�W�2����,�T�J>�Z�����*�h�Pd�2V���ާO�b##��f�6�I���Ȩ,U��ɮ��dmWqDC�"[M!�qk���7f���0��E>�`�.Y��Ȓ橲Fp�^YVo+�r�U��P��o-a${�1�Q�2	�Т�[e7|Q?B�3��v{��2k��SM��ǶzW�vGY�"[�z����b��Si<���5O>]}$R�WƠ��u��R�(�y�`z��O�k�ҡ�ٻ[��k7�-��b6�P�f����}��BB��x��*9 �;�ܞ��=gHT��2�Y
���mߚp�ڮ∆
E�u?����ϥk��2A����lu�>�eV��S̀��̖��x�v�m�\N��Y*9���T`qs��xS�ʵ{1hq��K�NS�ǧ�0����+���'�B�Ğ�g,��8K�����|dmWqDC�"[��A;N#a��R���O��^�}{B~�=�i��Ia-��)�E����Y����n��7� �e����k|';Ь┆
Ev����IM�ٚT�vnOZ�(i�
��4RQy�о5��I4}�M��ڮ∆
E�j��)ŸG�P�����.G|�(&���m����َ�V�5ֶ+�J�z��-��i��2�U��P��q-!��,α�$�2@\����3��'�y�����O�2�;̸#<S5����X�����V��%�	gqMuO��F���d��88=��I��z����>6��j䘱v�>AU�O�[�"x
��'BӺ�ꡝ��+��.�qŞV���� m'�ɽ�=r�Gנ���& T�����e�?��F�~���}��\f]�t��΍� ��,���	�ͧ���d���r�������h�֐���.���+jכ:��ȡ
�x+�'1���,kg#E�r��dlq�8y�#M�;��XX�:*��#�R<�7!���{&�;��{��8TZ-�K����L���]o)�]&�9/rRљ>Fyo�u�2,�M�}
}�K��W���ǇA�\g�ɘ����
��5��a�6Kw`e{^���h�;��ۮ��SXB��d1�yE.ke5'�$�$\��x(�hy�e��5�t<�So3��};��[��
��d���
����`�?Y�oKy^�\��~����/ ʠ�C͟�:��OB�3��	^���.qdP�Y+ �X�Z*ir畓?����|�֝Ё����=���h���[}�Q:�_N�a:�6W�{aQ�犽�u���i�oT�HӃ>(e��9L�>��:�l1�s
��w�#��/�������I�kc�����vê*�E�/�)-An徟���^<a�@��#S�m�?��׊ja�1&�[LE�y��c�{�=S�H5��i��y(���>R��� *���m�F�`N݋��@���ۻ�x�9�A����t�7z�~vO��{�?&����	��� - h��X�����[�% S�ػ}��cPX���廇F=�#�$�A���#"�(9�ަ7���txk���y_��҉GJ��]���vl�%H�` 5��,*��������>����ݦ�������]:���@n7��U^��~ue�pĸ*wī�u��C�]�%,mr�݃�jt�숯�r���t�ʟ���o����x��{FG�����i�t:��y�)�L�Z��;�ūR�@I�;R&�h)��}��+���B��u¶ZN=�H�ĥ����:9u,�AP![��X��N�5+�2X���!U�k�I'�{x2L������{3��b4T(2�N���Q�y,�g��rW�5�Z�s6�F��3X�F�!UJ��ڲ�b.�R��˭>��D%uA�Z�⃆
Ef�	;�2�9�e �$<�S�9�d<�CX���g��z"�F+w�c��#4����<��IͱTh��*�Y'�^>���Xú�	9�[�s��M�X+�,�e�"�O���K>-�Z���*��
E���cŜ���ߚ~A�!'x�]�Bԡ�M|���e�}�di'u�~~�+�Z��
��l�4T(r\�E\07Z5{��5��ǋ�g������������c�9郀�Y���r�||+���w���w�`�;mw�����4�]�QXKl5�1�01Y�n,�<���x����~0{�^*�\l��j�,g,���,�%�o�����3:jF��Y*9��Qy`qCG�{��"��F�K8o����P�	5,Y�Ж4K��r���]�QV��V��h=�Hq��ʿtcO<;;�ݜbB:�������,C�g�Ƹ��XY�U�P��V-�2��
M2u�٦���OeǓ?'3v�tIe���Jz���r�d{��%_�SD`�#��=n���_�����!M"{����Id�I��D|�T ��I�Q��8Rb��$��֠�A``����t2�Z�y��.��Վ�s0�C�t�9�L����P鰙F�S{r���KQ6�P!X� �*0�Q��\��Lo� ����v濐W�(%�����p{i�?@���x0r���]�ʹq�tmI�ܜVL�k�]��#�n:���d���d< �.�]�����W�X����@���/�C�PAA�>��D�j�-�'F�����Gk;�8��qX8ӽ.hp'4n���ںU�:��,�`Y�U��/*�#���*�h�Pd����bxߒ&k{⥋������%7�y����3X���4Ⴙͪ�;�^�f�h�2'��txPh��*�Y'l���s��<>����rOc���uz���i���3.t��諰o)�X��!�ﬂ/H��e%�C�,���B��^)4Y%�*e�s}~v��tx�?=�]w�r֌����d�ޔ��$�*��4��t�d)����S����Zxq_���SC��O��^)4Y%�A�s�VAܙ���t
s��]n]ܿ��t�gg��'�����K8�B�=E�0cw^��q��.Ww}��H��&�N��.�qŞV���50�f��/�1���a�P�8�|G�D��⹧s��F��Om�"	�Y�*��7�v6���KD\����r�+�����S���NJ�B�=�c�=����.���d�1��
���`�D���bO)�Q֓���F�N�ZV���:�!A�Y�%L'���	#�����w��^��F�ԗ�/�r�����r��Bk�&�� l���r��L�]?�����rR$�(`ܓŵ�۬�uj� 'Y$�EC�]7K�M��!�����l\�Bx�K�ȽH����qJ0>3���
߹�1�V����u�P\��i	��R��1x�P�,�/��nq�R��q�g!u�WYk1B���M�:6��٩-t�@���7X1޽�<����\C#^��������i�5Shg����ܦ��7[����-w[�[�����	���)ŋg�̬l�A�E``��������4�9j|�����e6B��@����dv�0%%{�b��m��"��Q&�_j`ڃQ�B	�o��l�f�x2��������@�V��Xrr�;�����^0�j�f5"��{���3��[!5J���l�`+k����B��Z[�Md�f����{�ޞt��.�U�*�W�B`�K��,���|�9�;�z�1���V~I���\���b��
E�밈���f_a	��k�U(k�T> Aǜ��"�Y#@�g���P���B���V�ۮ∆
E�ju�,�2ǀ�ɺ3����Ip�8�.�?N`i�pߝ�=i���q�x,@H��������,U�&���8�`e�ڧTN��Y*9��iU`q����V��D6����<��E���U:쵔��a#o�K�X�i,�wX��v�-��!e&�X�*���+偆�"#�D]��r��F)i͖c�� c%2��ߗ    K!���86��@�`��u�SM��������a� �dK���*�h�Pd�٤bmᒵ�X�Y¹v�p�~M8�]v������t`0K�btR2Xf��Bj41k4�����, ڎ�l�4T(r\ssϢ��M�XK��Ej)B��	$��8���Ok���/d�,*O�XKp�n����o8�gũ�j"k��*�Y'��>�z�c�bS5�P�c�|�p}u���y��QL�Yjg@<[�a�y*��,��`VVq�e�W�������R.h(^be������9\�jW��N�R�pu�V�'�P{���ٵK8E���)|z��q��'\��Le�l��r��d\��8i�b�����.G�W���0����r��9 ��/�K0��t:9��OX�'Ix��+J��xbCл'��z��Z�@�u��"	W�������{��'w��8V��/`l�o,)bX;y±� ������j�oX{׹�u���c�\�d�l��t9�e2a_G�����̃mtH{��D�;l��+�vB���j>�^'8T�627�T��T���]��8���x�m����U�Tg�1�Q�]6w��\\��4��i�xc�L��)��G�f��}ŘB�ž���P��q�v*���2�6��̭k�K���{��]{<S���u�%��P��f-@b��gh6����w�E��o)����%Gw�=�e��:Tx�(z4�xpv��4<;g���qsUIl#����0 v���m��w��G(F�pwXawuķ�a��]��ը+/x ���*��>�{���`ce�cxo!h�/^+���K;w����mz�����x�cl��uf�-E ^���pv7$W�,}��=P�;�Ȱ=��V�a�o��ª7
��@�8귀VQ�5{PZK��O�2�p>On��*����{Ĉ4~oa/��Q��*ķ 
��ں��(�Q?!^z�e����X�de���p�c��8J�vɊz���h�z��x14C��^���U�����u��J�������8�p�{8ҟܢ5�l1����$/ntb�W��u��n���;��0_%X�ڷ"�	�1��G�#ԚQ?�x�s4YLA�.�&I�w�Z�ȼ�O'FQ�bi��&"�W����k�n!~�ۇ�g^��Jmh�p�����#����|�p[s�c�z4�����bw_���������1�x2�P�\I-�&��9W�!c��I��xcnW�(�8��B��'�X���
W�B��ƫ�� $NG�>;�7�?�w��e):�Hjx i�Th��#*�j�Tl�զ��h��rÅ��M�2�R��S��\�$���1vR�(��I�Ts�W��l���*�h�Pd�d���,bz͌�[�9�8"ɗ�N������#��a��,M�4C�0�GCFJ�����V1KC�"�uX�)9���8�*FzX!�ω�ίK��/(*XU�g�/	f�aB�8<qVj�[#�g4����,�X��̬��r�9�E����/�V�d�E3�?����s>1d:�N���G�� 3B8��"�u�,e���O9UB�4	�>��-�r�3���|Z����
Ef�	�P�y\Ep���ݕzC>����7�Oޥ�#�ؽ��ѝ7�sց��=���č��C�f�b����^��d�ɸ�iN�`�D���߻�i���d��'�"g�� �3��k� �KEA�����������xe��d�l��}��2W�iNVAY?�x7�}kЃ{��3��~�2��(��@����Nsv��h,������Ք�����h���J4�Wwß��x��mw;��Y?}W�h�#rO{s�tx˿`��Fyp8���������wwW/F�<���+�W�g�K۪�@�ϲ��h,/�U�mS�{L���Ӵ@)�ەJD0��f���c`*��U0੪�m��\�j��B�xż �����0��M�8��'�U%S�[�m�G��TPhTc�ެ5x``Z��[+X��*%AWv�%d ޾K,Y.�(7[��k\,��{F�KZl���gE��
����2��G׈Qn[�O�QTA^L�NG6��m��~Qa�L~�7��+@�r�kx���� 7�5��ķ0����p�����҆/�F��"<�-�mY0$��X�ã�3aT�hk"J ),D����GO��x�W�ݱ�>6�S<(I��ź�h���ͤ`��/o����*�>��
�A2��W�8�*,A�9fE_�pļ�R��ζ�3����޹���ķ��� ]�=�²�k:��qJ����K�@Ԑ����X��n"��u�6����@�5�6Ldb\Osi��PpnG�h�Ex�޺�6�M��x�<ƊϰU��ʱ�z��rj���Mݷ�ބ�z "�v�� �>�yj��_ <�æ�6���je�2S���#��.�'����}{pz�A<89�(���ʮ`���<�e֗rH�]odmWqDC�"[O�l�"_*Q׏:O�=�糫��k����L�ƈs��x�����Y*�M��P4P�q���Or�U��P��qqAX�l�@Ѧ/^�tyurrM:BɤK�:�3ᮋƁ��
�,Û�YjF��M��ڮ∆
E��={sV�(�r5H�7.�Yl|���ye=N�v���%�Ja�)D1	�Rjw�
��޹�2�Tm��Y{�P_Z�b�"]&��V$��z�{n�?�hv�Ӈ2��/k�1h�p�h��(��a�L�JQ�RPG�%��xY;)z��]&�?��8)�+`D����S@��~�1
����C�b����VH�����;���XJ���(���"]%�Lf��ze���`��Ox�[�np�8������h-b|O���i�Sq���u�د�%y͑�����C�@v��C��
��"��k���[:��6Z<�J?��٬�O�M� &J Jm�G����Ti���#w��~Ĕ�[T퇰8�lr�k�z�V<,��"o%�0^��{8(�G�)C�+��Ǜ�tz7���W��_�s^)��B�;�~�+>I����y��;��l4ڂ�2ҫ7�_�Dڛ1Ѹ���͞J��Ïf�XS��"��b�!���g^7 Q�}W+�͎�~�K��ȃ�[�<,[{�����B.})���	J��c1C���"�Ǔ����津�.�}o���q@S��b����{h�y	i?��Vl>�ij:x`��I���3�!�`܏�G ���%�bx����#F�hc��ک%Z������d�ķa��B�p�VX�U�l/d�����ڒ��'�oO�m�s���l��T��1�P����Z�*��/�,�iJIЭ�e`]�_ �tB��. �-!���Q�	���85��V��)��N��b{#���e�����3������$���y|B�sx9����1��Mna=����v�Z�lG�;�=�d��)0�lo�� A&���O;���qd���8�}�|On>�پe���z�z������V���RM��M�î��L�?��y<�O�
�R��
8d��jC��O-����@��paR$V�2�h��V~J=?5.,/���x���b\�,CC�H�,݄T�f��y�ACP*"�HX�;=�}���w.?~9�"�WGލ��O���)�C�N?�3Xf�Ts��3h��h�ޛN��Y*9�â���,�j��7�CT����G1�t=�"��{�8d�W|��
���]�M��B��]��l=�Ǌ����t���~����HX"��m��7�`z���$�E��;�>Я�k�Idd����B��Z]RY�3�ōAb\`EQ��J7����!��c�"4p�aɪ
,C1!�0���emWqDC�"[�f�]p�uU�O�?��k�=~�[:��/�a���ΔNܥ����H�<M�ՠm��x�CaX��3'[�lV��q͎����wl\-��Y���e,�b7f�`��-�O���qZ����Aި�_���W��߼&N�;   GGt�����O]D��s�=l��2�/����U��7��Å�����&���6��i�5[�&0�<��wl�f|�
���Mt��p���vr��y�X�������-�>d؊SU�
����V�����!��*DV}�?�_�{q�n�ި}�h�/��'��l4�i�y_]`Gİp/�cŽ��[�_���]y l��_޵�!�_�p�ZzF�������U[��/t2}3�9�J�h|�� �u6�c4(O�
��q߷���N˗v;��	ī�Y��EZ(�𵥍XEK/s����ܠ�����)Шj2G�/���X�ED�Y8��p��Cx>&���Sif~����K�H5��n��@;q�x?��b�0�,	��z5��nO���8�Ho&���dd�XR��5�������[�@�U'Xz�����ٖ���������%D6Z�K<�dQ�������/�c0OG���F�(?i/J�'!�ذz�����%�DfØzX�������i��K�}��M<=�Ca�e�~yI�������Q��(1��x���qs����2%eP�g���v�h>J�/x�r"U���48|]���B�j��	J������Vk4�z��m�:ԐQ�� YO�uO�

h �"��Sd�vv4Ymo�ݹ�_�'i���z�z.׶�B3ङk��x6 ����6���	^oi�p����$2/}��C�?{���E<~��-
�o�#|��o�a1-�F��L'��� mC~%�ô�8�2M��}34X��##K�"���_;#,܍��W��rk��.0��K!�����-�F�s2Z8�j;@	��,�߸c���؋H�n֏��F��'�=J���]�_�[�sz��x�J�����]���B���²h�;F//�O�Hļq{Y�V��:x!�2��k����3ߧ����Du�{�E�9m�%$o�8�!�#����dY��,ϿE�s�����"8^�j�U� ��b��s�t�%�c�?=����#`��(s1�c�k��q����//���nW���Y ���?������<u��������� L�s;��d���wnП�e���@|���L�eʋ���F���Վ����*����N�a�a��L����v��@���yֻs4U�eu;~�@������s-Z��&{�Qkkm�����}�#Zv�}���.f7��v�@ ۔��1��s:�6@��.��c���`��#��/o0�B�'��������̷G�X��l6x ��ӟ���M�WwW�U����E ���?��Q�E	����m?���nx߶�[���r/�^�����}4�tY �� ���_L���.}s��f0}��j�-��*���c���`�PX�p��#d �VӆZ����i�����2S���'��]�s_��ix/@����������qz�5X$�~�| ���?��1�yd�̞w���x�?���Ô�h0��>���Ku/�'����`#����1�x���0�m?��N��le ���O�&{�Vkt[ꈷ�쟇s<�h��XA<��Ѷ�@������H{�!L��1o�\�=霿%�
��3�@$T٨4�0)0fM���H��JHU����	o�g�{æ>��*fi�P��h X����F�F��|�ݘ��K�P^��� ��#���t�R"�|t!�h��e�,�e�j�)K���M����d����B�㚸���F�D�"E��@�n�)�Oi�V�{ 7&I�i`���H�,U"�J6R؅�i�/#[�,��2����Ÿ���|H�MR�t���	-c�~Qpf"#��E2�Rokju'c����vG4T(��˰�oi��m�[��>$�:��(#��6�������B� �,�JZ���B(k��#*�j���r��w;�A
�@�Μ6�8�Z��O�6��y�`��J�Z��V&t��߯����V1KC�"�u'���f����$��_�?���gRU$      �      x��}�rG��5�)��v���<g�N[����Zn;�cn 6�M��D]�;�Γ��̪J��P �H� ��2���|x��:�����rqV}?�]\.>��'�f��]T/+�l?�9�u��Z����W7�'�>���r��zvus"���5����K|�JM������Od-ų:<�j*�������6SU�<��ǟN���˫}A�6H����i��A��Z�&~(��n8�xN~^��.��s �̖��/W˛<Ϊ����O�������|]}�O7׋���rqwϧ�^T_�Y�����8} ��/��6�	�O��h�okbtܕ�sb�|gOz*j�����ݓ�l	^�3��(�z��ىKon��ܓn�t��$� %xΧ�����R�_�����j���j�����^U?�ݮ����[y9[��\W/f7�Dx��>�x|��˼���<�_қ��05v"�|ʝȴ��5#y�Ǹ��	��{6"�r#&m�N ���MZ��F0��g��<Ƚ�Dcb�<���Ƚ\�NN���n\u�p�dx�].%K>e�~���r"-~U>-�Yd�*2X��B�!BWp��D9�A}��c��d��R��j9q�0J OW���Q�����T��R����ù�Q`Ϋ�+���$����i�����`{{�Z�/�f�׿>�ͨ䦧Z�
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
��Fi�u12.�L��`���ޝ-��#�8�w�!�����ai�F�7El�Q�ofW�Yb|��/ǣz]4��.��v,�4�O����^���F=ڟ�כ>��FE�8zt8��zP�.nQEM4��n�[���5:0T�'[��?'��_��D�      �   O   x����0��0L�8q�����(�KAL�
T\���6*x�A�gC�G�c -hZ3�*���r���w8��>$?�`      �   6  x�͘Mo�H��ͯ�}�����n���� >�4VDC4#v����o��v�mB��b�T�>޷���D=Tl���Oz�ݛ��ä�E���B ����Mv��X�W�aw�/���|�����q�|Z�P�?�����i��˗ t�^ g�g��v�p�A�WW�o�ɏ�����pF�Ĉ&`�M��B�nW����y� ��z��~��]e�p�Cr+o����:�L�y?�#n�:3:HЄ�-_//�$��`:�g=��O5R����m�ئHƀi]������I���W#���?�Q���q}vh����.:�.=�Cu�aI�������Q������AЎ}�]�i��y>Λ�d �i�����hy�����0���Y>3�sk����Jѿ7k)qݚ۴���
�l��0x�Pڃn��ǰ�g��
�u���:�F5�LC�	7/T�`��g��_�#~T�����_�m;ɝW�� ���fvr�$u>��v�ܗ쎥Z+N�����y?��X2_ʻ;��3p�M빃��­���T4,�<ԖO����3#
1M�����}CF�ۈ�+�Jԧ1����ݘm���K�NE�*}_aTEU�BHx�6#��N\Z�E��ĄU�"Y4��$�.�P&���$��#B�Dr'���L3�W���:�J�ЁP����	��u�Z/��"/#� �h���������n���.�]i�o�>��*(�S�Z�
�ړ�+m.�����ڜ*Z��B��t���y1�T��g�@�]�O^���ĕ;?~���T�Z�%�#|�;x��z��TUa
i����?nl��5^�Sk^�z���sj�Z>���]�ZO��UU]�"J,�i=�ŨM"���lY��2R8���XV�nF�z{����Zﺋ�+�Z�}�"�l>q��P�\�8��Q�yW)#����3�J�T�aG`����-7��`J%3u�»�vAB!3FT@��Q�?�'�]�_���I�'�b��|4��������I���ݥ1���?f�wnj�����x�Ș��X��r�֛SG�5�ߓN��u|      �      x������ � �      �      x��][s�ȶ~V~��v�Ԕ��_x`;�@\`�̜r�)b���1�S{~�Y�Bj!a��Gn���{��� �	���ߓ��{����xpp9 ������|�d�|�e�`�;��ӌ�/�zA�j�^�?� 湙M�A�_��I�O��Y��`:�>���t�}N%�� ��k�����Ds	P����X� �@�G�/��/�Y��ϓ�/����v8����`6��j`t�T�I��f���7�--�}�ϊ��#�T�,��Y�>��gu^�`(�J,�������??�n���A��#��@i��>�A�O�Ȓ����$<Ng���?�i���y2����$�>Φ#X�������};�����'_��o����>�H@�|~�$!���~��k]h�\��畠��DE��h��!R�GD��6�W4�j)S��v'c]L̇1����1,%���e���������3�н�/�vla~_Hu���G�7����9��7��/� ��U�Q9��u��-=���௻�Sg��#��`����^���*]���y�>i6���m�|�ͻ����;0�P�
ĸ��8�
��8%T��ōe���`�d�9���#r֌	!�iv�f|�����dB 4�5D�H6���En͖D2i �D��0�j0i!��f���pmּj(���K;�V�i~�߰K���)��?q/>��j�3���G�����E�r����И`KHaF#P1@^��M�Q�?ZGO�Y�
����^��T�,I� ��pΨ�O0�6B��'�/H4�n���M\2��,l���!n���C����Z��r�9D�S%��8e*>�\����E����2O$�zeO�������dV����U�-���t4
�&��s�ா��,	U���$s���_N'w�=N���T��bJ���@Ƥ�V6��)���^�$�V���Y����7E�PÂ�9r@�AA��b�%ԐM
f���
��xE0�N��.�y�p���o�A�4����,�$h
�,[S�֒Vf� ��;��o�.9^�Ϸ��>L�S��
o���#B*il��&Y����4�w�1���=��y����jY4���F�@��x��*�Q�4�b�'٥�e" o�Y��5u2�F�5E���@/��i�Y��Kp1ߎ�_����H�Z�BY�d,��$[���~ b�u7�6��?�'�I�d�e�B�]�DM0dI8箛�I�O��i\�|�mIҏ���,��I�T��8�:�n �9���_�Q�"��=���Cg����ۏ`��y:4�Qb��Y�1n��&I
M�@��Rn��Lx�rDUh���k��	\�\,���ׁ��\��C?��z����aV)���$͍/k/��V��h	]\7�5�[�e����Azx�J� ��by�[��l�z�9d�\�΅M�[]䘵���*�lV�3���U��a����Av�9s���z�HМ܎��X���.�)�p���K�R .i}h�Wth����n|~r�'���^7�<1?����'''�V�!9bVsqL���V��DDV������N�j0��bӽ��hv��|��_�e��ۉ���!B�ۀn;>�=�tc$0P�,�?���𧸋������e����]�q_��4>D�h���Q��t�3�Ό�&`}�jq��Xr����]��}7��8��m5���L`��P*��<�jq(�;9`?���^N:�j��DteU�7��M`P/��[jM�xhN���?���3�p�f^=|MG����o���׭�~s6�ۺf6I���ͳK]ڀyl:O���1�aq�#M�1 e�"ƶ������93�,%epyw;*���#�o{��>DR�;v�~����/��d/g�wE��$i''�y�X�_�KH��Ϫ�U�/W���S���	M#��s�e����k�!�Y�U���y�42��s�h��{L%��B��M���GD�D��ֳA�mN�W���8hN���K8��ه�^IIo �ހ[1�_�o�&4E2j�-�5io���f�<399\�2��Q���A���b����C����R�wrwO�����k�T0����U�d��L���#$�D�.X}>M(,:�zD+�)�9�*���O�]�Tcvxj��z�o�����~�O��h0�y�wh%���4S)����&y������lޔb�HH��YvDip���{�%e}�m^��+b."V1��<�N�4�\��	G��8��O���$vc�7���b
�P��Y ��*I#-7��ֺ,杧pw��q+Fd-���8>���靁L�[G?	ہc�a5/����5��<�����_��"�~��q����RCr���yW�Ys� ��`���J�##�80i ���sR���B���#Y��sH'>ck�<
����ʙA�D}��%w!K(���Z+bp��Z�J����4���q�Vk���X�F�U>dG�ʮJ���.7|�r`����5�c��0+��%�
E�&�l3�5+/�����1����1'��F�L>����X���<�aqݐ�UA
�f��uK����-b��,֊����֓�����v�6�]�ng]���rD���ω(��B{�\tI�5��`���Z�A�/z���	��w��<��U1	�s���ZN�W�>��6o�c��B���L2����Ie�*��Ā��hJIf��e��LQ�h�"S����H)��X� �¨*Wn�~y�:��n��?��Ϫ�p��>��<�#NҜo��5�?�p�R��M����#�e]a@���N�UV��q��KQ���BF�wƀ��bt�#����	'6a]0h�\8��5<Z-򯌉��p�ώ��Tj�#�n��zCХ��7]H�-E��,@Xuj؎'u�L�F{=�_����l�+3l.��@�?������U��,�l��u��5	�s.��_����<k�6�UOn2�
1�"�6<u�L�$��v�ߥ,�Q��BLJ*��]���,�(����-�(��w���F��p�C�:��l'0�����)��.0���~�9�&7�	G��dB�#Gu��dL�e+�	e�.�#�VXS��*�q��uc��� �+��2�l�j)PY��K�ax�����8s��������'[6�����������|fu�7{�H�S�O�E�����5R��i����G\bx-�X\*��r'b��Z2�	�����Ɓ��m�n<l�Y���HC���˸�l ��KD��d6��7̄B�e,	�s&̎:(%RE�/n����u��vֺ�5���������,�dzh�kyG�hs����ޑo��m��'I�i{�4�g�~���/M>(r���<�Ӻ$(�A�bZ�d�VK����Û����]�P��N 	<l�>X��%�!����4�_��Z;fV ��Z]٘i��p�e^E�����$Y+��ޞ��lGxMW��zk���l�4h�G�<o��v)�GN�������g�7i)|4a4���Tv	R/x�Q�9w�߾�dxG޸v�U\���*.Z�����1�(?W;�����|Q��\�W�DV�!�� ����=�V�Kn��0޷tq� �Q�ǽ�؀���t����K'�
p�SI D��$p#����}��!8Ǌ���GD+��V�����\���˷�]r0�#�ۉ<��α.��Y�ts�ED���_�?�a�z��#�:�3O a������x>�l{�)R���?�E歋�����W�|�����?�K�k�H	���,~'�GU��R��9��Dr ���n0-67�#.9��k0�K�P��gM�8�0���p`5}{���*��M�p7��wLmC���hfϑS�"E}']
�� ���&�p�n�½׺��A���-Ηr`�G���%����#,�G4h&�̈́0T� 
x����Nu�zcToaC�st�+��#�Z0l� !  � ��.�d�\��^�: n�Ӷ�w����aZ��I-H�|Tyϣ�Σ��㯞|^���3���_�!33�U>n�+=��z�d&pc�QI^��`��3\<��%�d	} nS�s��'	�g/^��Q%b�d*M�`�;_��v��Y�)��lSYPF��~��D��,�Ó�S��<#��F�!
��6'�ܧb�FT5HD{o4���x��߉���)�ͻæ����/��yS��w���}�׮J�|����(���~���$w�"m���4¬8�5����fE�J��4h�_�c��VZݖ~�&TA)�6��'}��װ.�������7ƭ�U�ԙ��9ϰ+���.q���2����j��]��|�k�y�ju�Ԫr�Q��ؗ1.�Ǟ����>Z�h4[s�o�n���cs9����u�T��f�3nT�@������u�ң��L�-#o�a�(xD#��9�����4(�����|��WY_���ټK�̈́Q�I~�n�&����rf�H�¹"�
p^�q/S��	rl����Vދ�(�R��1O9�P��QX<wD���!;���;o�#6$#�#6�{� ɶ������Ԝ���@O���~����á����R]ǈ����g�I�xY�#�u��4Y�%��:J��2���b~+�.^��-V�,%����
<0<%������ள:^�s$R� ��ѿG���<��b	{�HP:��K�Xmc`J���I���Z7ؚ���ޒ�, e��DY���H$����ɴ����9�&�$=̺��U5W^̹��T���妸D/97��|~��� ��5�V01Vv��K��A��������p��&Dm=�c�zX�k�U�w���%��N�P�@����@M! MR*ǻTB���o����GF$�7^ġI�q�l�c[Y�\뢛n�W8^���{f���x��y{��r�(;y��|�	�|-(�F�_������h�zgڢ�L�d �|��#�R�'�����Ԡ�EЀ�A�jQ[��&�;�D�l�&�}��Hr���[,_I�R�=Pϭ_�K�'�:�͸11��|2��z��KA����c2	xAk2~��� �|	�&��g���4�-�Gg{#D�'G��HH�ł��E��V�e,l�6H^|��'bڜ�Jd9�鼤a���Q�b�fɿ|��4a�)G�k�Nx�g*d��i$�O�@Z(�&i�r�a~�� %�r�C1�x楾���NJn.`�R��p!bz=a1�7��7Wt�v�̞��6=񶤯��NW'����]�7{���3����㼴���!X��b���S	�B��;�ap�uX�*́^�Y�/ՠ��Y��[���-��w��a�q4���=��wdI�2Ϧ��7����~yO������Wb��9��9��4�3�,Y���nx��fA�C��a4�H�Eϳ�e|th/a�(49�6&:�<�٠�'�a?�ٜ�R�����N�lq�2J�Gk���u�w�R��Z�v5�� :ƇB#Y�y���2�"I�
=���3A#��4�dJf�2C��y��[,8�ﮣw���?�?
      �   >  x�]PIn1;K�����ȉ���K/R���&9��"%S́P,2�$�T��6�N�%���yk���^a]�4����G��2�2�����d�ذ�z�Z�G�,���VB���ۥ��@36>�u�6;Zn`��e���|$��D�|��ъ��K&��*���%n�X_(�tD��]E��D	ѳQR��a��Yʰ��	B��=Q���K���J:n;x
�~nu��vlz�Wt�A����>�zW듍��b�3U�h]ܲR�B�!�1ԑC���`s��Dn�RP�|�ѻ8{�zy�O6z�֧���Ŀ_��̓y�      �      x��\[[�X�}V�
�OG���ɘ�`8�'�͋�at�I>s.���ڲ��])��!$h�T�nk�]ʇ�OJ(�N��d�%tt�bq�|}(O���_���_?�>���j]o�e����z��7�z�^
!�����/�>7w_�[����E�Ͽ��q���N:lt�L����E��"����~��B�*F�'a���v�{'��n��Ç������"�h�W���涾=M��W?���b�<�g��P�,�[X���;k�bh�,�]���,���
�W���V���>?�G���ҼܗKQ~�{�~�{lʢޞ�/ʛK8���'��Y�]��/����	�����Q
�L�F�p���;�(l������PJ���2��E��\<T�������>�Ul`:��w��Ų�-E�럧C���&�����7oI40��V���FTZ{�Q�B'����ϱϯw�C9�9�4"����B�J�~�)&�T���^(��.O/���z��k�|�-�23
9���R6+dCeae;V3U��hT�1�G��s��`k�ls�;+����2�BI*o�S�_""��WFq�!�XHa��"��/�\�w���bM_��7���5/��U�<fi�KT!�A����N�R���)QK�Kpw�E�N�.}�s竟Oڸ]��U����Y����8����Ř�z\����62��	�VT�3�[HUDQ�B[$���5���ǯ=o6���F�ޯ��m�2��$�L𨏱?z!Љc%׻,S�@c���
1�����IU���U��,�,Us���&D�w]��`�ri�S��@�a����Ga�g��??���E{��@�1�����F��ܔR-�ZHS���*�F9��B�����ׯO�5+��<h>�>���w����oq��z��d{B�+��x6�d��tQF1�k�p[(U�D#����O�,���/ͧO���y���\>�������<����az\��◑"o�z��i+|��I{�k(�����lf��~��w��A�#���!+g��s!fbh8U	��au�I(Ա�]��>L�]�
��M�h���h�Qs����+_4WW���DrNNg�����wuwϻ�q3�&o��:r�ǅ��=�M���F�h�!���y��l�����r{���*:W�=�b ��n2W�E�De��]1L+2�@��Ji-M�	_W�����-4�9�,�I<��%��.0\Ψ��`9�����ܺq��"́{2Z�tȉ����Lg�+n7.�[�}z&�K���oy�G���C�s�a�s u >�f tQ�� ���r?���>�ԃ�����ڕ�z�ov�Hi1'Jiiuԙ�����<�ɹ�Ъ����N�HL3}��c&�����L�jal�#Û3���/��A;g5<��齔9�Yo��rS_���=�n�ԭ���N�Є'jo0�Mww�/4�G� _���S�o��=J�f�G6Z_m˛��׻Ӟ_s�� < ��/�I���C�3�AB���o��'El�w����g��禼l��q(r!�4\�2P���f�1i�)��jÌ;��P		F�r���h�.��@�Y'�1�	���O� �%̭�Nk�96���,�h��0y�ypv�L�a�Y��
z��#F[�I�ا�f����| ����J�8BP6Gv߬���v������>��C��\Ѱ��gN�� `r�`��2#�@�VJ��}~�O�'J���yr�ݵ�@�I���v����W�
]�1� v ���DW���o��CL"��B��(r a��c����@�r�].�iVq &N��L��$��#o����7� dt*��5'"���L $�
���V���0��r�X1Ea�F�����gG��=Gޠ�~�����YY� :�i{�-�<�c�0�����#��E#�Jg��Ch)g(��J%m��)Ҿ2P��q�yc]��{8�A�P�@��D^.�^��$|_�':�%��(�3�6�����0K��π��T��4#�HL���X�4G�1];:f
M�>�Lz�́�D�(�EG/NTʘAt�ؗ~Ut�/\XWDop��w���Zy`})Xo�oƊ^�8v-a�����#a *����?D`��ք�� jsO�V��(1���4xlޯ��:��)3�&Pk �Q�2����(U�of��ex�p��bH�I�P�0�]�C�@�`�����6�����r�u��Ǉ�$N�M�$��t�	M�i�<�xT�Ӧ@u�`c�S ���Vy��̵�o4�Ey�4 ]z��D
�Yh��q�bz4CQ/��^�8�4��H����9 ���&ǝ\]\����=�ru����9��}�P�|"�Bf2}��"�KX��a�`�˴� R���F��4�O�K�{�K�]}s�.�/��JIo�MQس������+KJ�
���M��Hp�z,��6*�N�:�
�v���*���K�Ƿ�c�da�;�i}�BG�s��\5O_^�d���|�`�'J���L␛���dA����^ �捑�BKW ��f��$��D���Y��9�` �c�Qt#pK4r�(~��u�'��H���+=��$A�F�1��cM�Qr��1L�i �B)��|��Z�=5L>�/z��'�-�}�i���������RI���*���0���K�>�	Z�a�Î��ϯ�/_�_��T��0�����f�⩄Z��Jq'P�(C�/tm�`{>Y@v��b&<��m�������-�_���ꦾ\�������>�D��(����:WXL��y2����l�'7I:n�1mxtډ(GJ�J'�R$��64�`TX��Q��fF�y���|{�RLb.M�Z�~��w"�w�k �Dw� ���D�F��oe������*�y�<?�3���M���݌jS�Ɓ��	��B���鱗�i�2�&y�xS��[G��]�1��Md{���c�:�P~X�ө\O�I�!
k����+!������&��@5�FlT��C�G��xx@l�Ju��bp���w��]oOQ{.���]$��`zZ�$1�-zZz9p�<H ��.�w��fm/��t*���J��؜_�s�H�l¶^!���R�+=򊚾��f��* �0���)F�ٟ\&��^������)hWV�'˚��;v
�񴔐9�Hؔi�qL�#�e�	^ �$ʶ�ڒ8N��庼�/6�ӛ�Yӏ�j;�m��$��t�L���e=�`*�VH���j����FqDO)���1Ez���a}M��j�����ǴG&\�}�JV�JrGO.�<B��t��h���mCt�n3�Y�������|`����x�}IF�1�3?.aY�D�1����x}qu[n��UY��'��a����iz�������A6��eIc'���UI2��`	��~�\K��^Z|e�� �ò$P��F��hi �f�ߦ�8c�i��(΄�/�x7-: �0�0�Ç� -x��I�}d���
�ۮ�<�� ���U��gx�T6�xL8=�[E��{F<� 0Di�ٴ.���0���4/4��{bf����}�?��S�FK��i �� �t�%�h��D��^�Z�s~�����^^6��I��\�N �0��N��f�!���!�Z&8���xq	���D`�� t>4e��^k�l�s�lu~���[��$^�C�L:��������$��$K	"�;�΀��H�I���{���k{��h�,�`�<��(�W~��XO��E�10B�*P�TG������t'��{��u�g�h�Ǿ���a2�5i#�ɂ�Q�)�|�bp�	�a�
�4qP��/���^>�������Y��0V3�� �t&!Z�C輊G����>�^$�\vw������r��U3������i`�zp菠�_����"����7�u}�/��ʣ��Wȉ4��ʲ����/�X����I���}�_�Kx�=J�N�i�A*�����`<	�h�6G43�� 1��֖}ῳ�W��̪��2}5�pC �  ��23�b(S�t��p�Q�1P=��騍5��J���V�F��7�(Y�lC+��UQ0�*���������`�� � ��[����S/[��7k@���m5G����s�����
��^o�zR2u�� �C�(@�����Q��Qb����������qB�'�.�T�J:p��Df0G]`^[���ڛ����۫��yy�[����~��p��Y�~<��Π�V��g�ISi��0�623.��	N(��;��m~o^zgJ��:}j���Z������x�)��ޮ�^FS*
ì1ESzv����8��Mӡ�s�G\g$��e)¨V1L����)��LoP�����������q����d|��d,�o�F
����Y�(] ��)�y�(z�T���8��P��>�7Q��QR�$��n
��y������VN��q�䤜p�-IbX3���N��h�$T���5Z?AL����Y
�� .9h#�����y��3�{o�K��['�Q� Z9�Uë�H�Ev�61S\���	���O�������f�[2��ʳ�@��LW���	Cb`��&D��ObF�z��k���}�xN!�3B.'G�M���|q�Wfܑ�C��	T�HNBE��Q��t�0W�]=�?���냮�f�ַ�/,uL��b�D�2�\DA�v�3�ٌ[��׶����A�%����(�:n13����Ŵ��BR&�����w<�rt�}8B�)�2�t|�35�w�rǍ����)"i�Bt�	�j�L��:����kz:�ʹ�-gx>&5�7��vx�FHv��/+H�i�����ZB�����:o�ؤm�u7�,���7��ß�D��:��p��Ld��
�m�U��tp7;��m�]����Eg5�&�!2�EC�\6�t����x����3۔Eo��]���MO��j���1q���Rd"cw(�VЯ��uv�x�y���<�ߗ����2?��b��
J�̟��'��8�N�3��@F� 	�L���]W�㇕���#O�&�Q0lb��Ikɝ쒝��V .�3� ��I�q�������]*��D#6���XO��i�*��g�hk5�=���b�����x��l	h�K�]4*%��RI�s���߆ g�:!�Pr�ts���?��/�s�      �      x��[ks�H��\�+�~ok롒��Ԣa�=�1Q6�Q�W�蹾���,���;��CLX�Y�'Of���&�����`�}K�&��f��=�	��K{��� &�Ӳ��Thc�&��O�̜�B|~Y�l<��a�Zo��j��_���5�eXQ`x�_\�g�z��'�۷3���ۺ����i�bn�<sK�,����p����d�n��ݮ#5!�R��0�����_@�l��?�]m�f{v��O�i�_.��<�m�g��?�s����/w����������W�o�����샤��o�?}3+�Q<�?�pd�I�۸g|���77[���6����U]�����D�����I6Lz��q7��Q���ڗv���&҆[��ة����nKy���a]�un�s�A�A:*����v/�%�d8�t4J�!�0�1�v��N�p�C����G�I{|_�?����5l���q����<x}��ݴ��y���
&4k�ZI���%���m���C'���������w�����f>���N���?6 ���9��8��������ذ�tF�p�k��`�;X%e�q����%kUl"ɵfk��,�������ztʚu��Z�K�T	S��t��^J��'�"T�դ���ڄ�d�mඳl��&9�k����!x�:�9Ţ�O���� x����h�E�
m���5�M�?�Z��C6[~H��֕t�΁�2������^2�X�m�bm�if������	�i��	܂\k���|��Jh�W��̦�}�躟("2�Tb���9����N������x�I/i��d���>��X!��.s/��b�<��o7\E�5h�֊
4Q	M�߄��OSD�=�K�r���+%�ye���7��)�U uT�(.!�LJ��?��G�a<�����K;m�D�q�JIY��oV�l7w��p��ܰ��sD�[�
T�$��@=�d��X�!�x����QOkyti�6w�l�~m�梐�1�u�ʍT)%+��;,���� b?w�^��:66%l��ƽ�u���~�9a��u�x�^&����S%rV��������&ä�����!��1�jXh��4s����M@0��X�JW *�P���أ�ka���~�"wy<��Q��sg
�H�v�q?(s���~~m�"/eb�9غU��5�^Q�ܺ��/ܦ�ȶ�9���|�&��Yj�C�~��\B�PR]����t��ĥ�ҁ�U�Wb&1�`�MS'����%�F�I
Sk6�#c4Dw�w&�����o��u)���
S��T����Mx��ڷ�}��|�I�����r/Iy�(�7.�#6(�~|S�xt*�n<���Y)���6:��=WP�K�2��C$6qK���c:G^��Aτ�{���Aa2̓�T�̔@Y�d���݅d T.��[�AD�ҽ�E�-u�*�l]hH��<�J�rv �HE�<|+�L]��^RkVk|�0�5{y����q���kj6"I@�4���%�9�`L��[�� �3B~兣�҄l1�M7��n���l�[.n�%&BU	�Y��D�ȣ�����\5�����1���"-|Y���|?[�0�u��HL�0�WJ�ܢ<k{Ǆ[���A���Td��n����X$�-X�jb����ByP���a��@���ٻ
R�=���7�X����_������x�m���*�&n�U<�8A��Y�?ǻ�C
�t�c��ڰ<�MV;`��iqM�z���T���ċa���@���AS;E��T�w
Ѳ|Φ�����&A��⁔U�U���081�O�6�Tz�E�\*�����S�zL<��[���6"��Tb@�$x�p6}�վ��ls�y�!��8�2F͋��7�����������dWܽ�u�38�0��>�W��$iS��Z(i� ������PF'����[��Nj������J�PFua9.x��d�5��1]������)S�M����H �Dt:d��w�$z$�S�PC��D�P��<�%����{5��D���TP�ۡK���;�|t�Ї���䮙���M��P����r�z~&���]1�~�+qզ������4թL�U#�a�/�.��	��R�P⚣�_�f0J$�c��Y�	�� ��tf~E\ƵB2��:|p�w���\2�\�ItT$c]���=�;⌼g1H�&�W��q̶˗�bc�)���0��6���.��L+���^���ԏ���J�D��y�Ɏ��@f�����N�z�����'g���~�B�S4�7�+����)&+��eP<*T=;��+}���:uS��
h�	Q���@�J���u�BY��+@=����o@����r�5�J�G�B`�l״$��n���]aP��H�Q�U��utQ�谯��\��5j�i⅌G~��J��>Ϯ���IE�7Q�"y	�z�]J�*w)륅`A^�@i�M�o�B�`RM^Uߍ�SY~\��u��4�to��L낊�`R�dd�\�
���H]�,�5�)�-���kE𢡄��AP!C��2����k�Z�_�y��;Ζ._"*�`�%}��ܞS�G��[�H�ꂪ(+%�H3�%�L�o�w��� �a���ϐ Q�Rם��Pl!��|��\�P���:o�TY��������e������Cv��퟈���7�C�K&��9�F,����]
�_�C�U�]JZQ��F	����Ƀ��2J���-�,�/���\�`(+�<{��Y&WW��j�D������ ''C0�2�RK"�T��A����j��x�3P�B�"�E���^�9�%�n�$)�X��
��ۏI�`c|�N�JXۈ-'���j?�����j?�|pd���Ub'.�r,Xd��m�r<> Лɉ�kc,J1T?��&�|�JᮯX����}i�N)e��ƫ�W*n�� �/�j�6��7%t	��f�+ǅO��"��%�%�u s7>8�&�����A�6�r'�C/�V��f�}�����f2��B�aIj|X��KX�r�{�V�im����+��ᒸ:�~Q9�	�d����N�7�!��}|���n��H�$��l���?�d���(��3���y

74Ζh`��rN�����Od��fz�Zŗ-�5�pv��-~�����4�������	i/����ε>@
V�)u�W�핝���@
�r��� ��}��+uw|�|Y�+k�v�p��Ug'H�f��"��-�RDM���t�����^��א鬌��x��e6�a���%��o�>L0�vY��ҵ�*��K��
b$p��[?�[u��F��M�*@\R q�A�5���]�ۧ~�c�Y���=<�c�
�P�-�S����6��6D��U��.@m����<�:�j�z�o�?�����@���n�fn"�M�<(IE%53�}��b��{fO4�Y�e�9[=�ÅU���x��M �v{�b���#�P�j �Ł����	d��h��G�:��=,���Q���l9԰n�)�o�
w�+�R\�g#3H�;H":M5��!W�TL2��x~�g��"�P$���������$�+�b���P�����k���T�2�/0F-���	H.W���7{j���<�.��*1)�ZRp�j`J2	����+*�N2��₦ � ����f��|vJ���j���!�	�T�)E�Q�$�Ƥ��
���NG�b�~Z�z��܅�d��|���񇚭��5u�<<$��~��(i�	d��Ȕ�ThX�ˌF���V�tܠ)���z~)�:b���\�}�n=W4@�'�)�8��T�YS�[�b����V��iʝ�ڧ�by5o�k.�?�6����^���$snmL;2U��͔a�t��>[�vA�	6��։��u��+�b��q:�p�����Jbe�Fm��_��j�Fȥ'�vr��66���x��?���(8.zG�֨�x�|�4��x�Q#�'��z/���D*k%�%*L���ėh,�����2�5��xi�Ȉ(��7O�N�^ t  ��n�����(��xK�Zߺj�����F��|F�u�}�������.[Gq3�3�aP8	���,��,�H/��#TC2
�e�i���؜F��b���ш0
PuV@0�Ce�H����k�IB|	��OpWw��� ����D�U�N�U���J��D��<rR����H�$��+V3��{�GI��=D� �"�X��H1��|��:�-��[u3��:�1���/�l4���Y��!5=|�<8�u#��
� ����o���c�F��P#�n��lW5��Y�*:��&�A�^����lI���u���)��E�GW����O�
J������?g���-'��?�׷-��YjuV����<�C�}r?n6�^k��p��=w"c��m_���~2ɖ���P� E1(񁧕bV�**�Fz:�N�~hicP���Q77˂�bw�<d���5J�*H�����d:]bu�l�v�c�s;}����!�0).���q�V:!��H�A���{~���)93ӱnW���q<���A�4��w�$���𒊤)x8�(��C[J����+:�A��3��/D�ŏ�Hgl�?��F����������s�*qf�w�B^/y�5G`G��0?�y\��YK�h���o�.?A��6�ZU��� �>��=�Rr0R��іK��2��cC�w<�슃�O�ɕ��|'Mٺ�CYk��g=���8�V�n?;�&B���oFb���v�ǤY�i��fm�f���=�F1$���k�t��"(��h�aEG��wPL��;�$J/اQ?���:�"�D_������! �9Y��]{웈y�'9o�����5�������c1C�nxT5p�2���K���
�{c�lC�le(�7����7��F��ڐ@�-�����CXg逐��t	 e\� 7�ÐhHr��0H<_�����#��%)�l��p�WxI�MR�Q��d�*��,w��� F�|� >e�X���� �����R]�]-�<{���rH�t���+!�2��{��u���3� ܣ�C]>���Y��i��̇çI�m#���'��' �����F���a�=.�L��G���6�������F��]`���U�2�����q��,��I�?�o��P���d���O/3��+��"]�)�%��E�Yä`w��"E��U��Aѱ+!"i:C�C��Z��\���4���%f�A�� I}�LNS,�0�;<�H��B���nw��({�$�:2�m���j����Ažf��L�q�Ne����YO+�IpͱQ�In�]�s�D�������<D�L��PȆ�Ñ��i^K�h�U��<��iOC|\����4Z���K�O���T�!�s�xxPĢ����l;����g�s����ot�:�:�Vb@�X��A�):�g�rC�V���/b�?P{�"C�	xU`�ރ��^=��ǛF�t�^������w[�2Dy��4�N�\u�R��mQ�V�ʐ@<���F���������t��hh��8L�O��Z�kITO��&�d��= ���~编o葆ơ��#���$`u(�ͿD)=�Wh�3$y�zh���j΁��l��r{�9�#2�8h��3 ����?�})ߜf��h���Bڌ���q�-�.���F�?tU�:���� QQg�&�����y6�g W�)�c�[<}�y$!I�XH�_���*�X�$ux���ʙ�h��Fѧ�8-P�i��c?ܛ��|�1�.�����򥋧�	Q/�l���oh\p׮ݥ����}�<@ZJ��0�p�z�{kp7�{� у�ҠEWZ ��}��?�gI�y������E��(S���jd����u��IT�����'�������z      �   (
  x���Kr�(���*2�
����������������;�U_9>�d2��?�e�f�;���?[����_�.O�f������?,-�ϗ%�c�q��Q��3�GO��^ ��s�ޖ�7�/J��f�Kh��c����r
�/�\\H�l�pw���5�	�δ��
�޾�N�:�w�+�Pcc����n�{`*��(�R���ek(���<�����gS�t�i��Eթ3����fJ���x�ޝ�p�,Y���E��	-��_6)7Sqr��Z�����O�����]�;�t��]6��~�{�	��������(�w��;�,�q�z��ڳ�^�Ӕ�w�b$<�xlW�D�.W�\��!���+��J�O��OS�x�u���p3�W<_�^�kQ��SQ��k6��q�"�W��hRI����/���9�MJB����5l���<�L�94M$=L�N����8 �s���{��;�{�OGhe���ba�����"S�7����ܯ7��Τ(�����Z�P/��%<N5/���Əb����j^���2#�L�S����6S�D+�L����횑��(ed����V�]�yI��H+^G�^�ku�X��(��`2&��f�S�2�EIc��}���B�2����������wNJ����h�6�~h�Oӭ��۟i>�8H����.�aLi����di�����y>�o��Ү߆!��=�;�
.�@~O�����g/�3���y�`"l9F�b��a�7�Vo�2�ǖc,�L�Ye�*cV�ʘUƬ2f�1����:	m>P˻4�j��h���Dg�]z��ѐK��M�K��d� ��'�%C.Ys)̌��Tpͦ�k:\���P׌*��T�5�2�4���>����VX�'�g�m�5�Ijk����5I[��f��{w�1<ax�����ǚ�Ǭw¬�3���$ ,	K¬2f�1��Ye�*kV�f���\����U׬*�fUƝfUn	�֟P��ZB�����c�	����'�O֟ �?�H"��j�/���v.�u\���3�G�^��u\��3�/�����fU���+�fU���Qp,��%aI@Xf�1��Ye�*cV�ʘU֬
/��Y�p�o�i/^�I$-l����_�}7��K��������n�uw����\*�~�RsƷ-57�fU���+�fU���Qp,�[g�ג@��$Pp��֙��1�[g�Ǭn����u�op��֙��1�[g���ues[ߵqUƝ6�J��Z��F��"��w�i~��i�m���������a8cx�������'�fU�*�����U�rF��@*��
�%��kI���Ugͪ�cV�ʘUƬ2f�1��Ye�*cV`5Ӵc��~9��'���0���?m�`�+�W�5�k\1ָb�q�X㊱ƕW9�M��Ӌ�.���SL�2&�]�>���Ҿ���X�ڗZo�I{�s�K=�������U������6c=�5�
�ŝ4�
�匂+���=��'��
�d�B+Fe��
��ThE�B+6Z��АK�\J�H�X��M	��.����-�J)i���t���;g��0<cx����&�'�&U���f���!,��%aI@Xf�1��Ye�*cV�ʘUƬ2f�1��Yu�հ���h2��1��L�N���0gzUt�WCgzt���:ӫ�#��3���\nE�LC�J�o�LC.�r{�!�[�=Ӑ˭Ԟi��Vh�4�r+�gr��m�O�jUƉ�+|�uƷ���:Fg|���ctƷ���:Fg|���S�3�Y�7��q�꾁�cV�lg��o`;��}�Ǭ���3�Yݻ�g��wwϸfUj3X��{�5�2�wwx�~ە�a����3� }������������p����K�����N���G腦~j���ɰt�J�^f����?��^k���
�rd��n�L��_�;�B2�I��&�����R3��v��JS.����(Jᆇ��`���x)c
̸�2p����	�3�/>pͪ�cq'�*a9CX 	K��$ �*cV�ʘUƬ2f�1��Ye�*cV�� �d��5��fl�ÁP��/橯�b��X&m%���=��B6ы�[y׆m�&:a !;��^|�\j�wi ^>T�u���+OC��	����Ǥ/J.���>��M��K�8���4t?�ϓ0��й}�����K��_:�);aen[��섕��f�g|���m�Ʒ���f�g|���m�����Ǭ�+�3�Y�W�g�����8fu_��q��2?��}e~�1�����kV��pͪ�kV\����U�W�:�V��z���M?xH��&�t$����ܭW��J�6�N�s�Տ8�����-4TL��d�}4?��&H�6��;����+k��v�{�y�;�g�� �@>�|Px����'�_����_���G��x�����k���_�2�A��e�/�~�ˠ_�2��A~Ӕ���)l[�f雦Ə�&^\.�)��<�)���Y=�j���_��A��lY��{�ua�~g������ �s      �      x��}�v�H��3�+�t^n;�AOʹ5�H�}��k���L�j[��$W�:_w�E� ��[�l��"���c�Oӿ	&�/B�{quprP���\�܎?��?-�.Ϯw�����ߟCz�ۤ�>y�?���/�g��Y�F?R]L���S~y�����|~����gμl���_��E��������d���h��f�c
?ߞ��~�������_���Q|~,�?^�˩������h>0s�p~��!�����E?]�L����_��<��P���r���j|]\?��?����%��R(�tV�H��+�i͙�B�P�,*)$S"2�0F1����R�٥:�2�N����O+b*f��Ӄ���0>���Ƿ7�ٖ��ɯg3c�:�.3��t�y�'�����v@f�^������/�������m���%�*|�zx{	����-�yEp����6���:��P�c�#�5��C.�GR��b�k���z�2sU̦�Yy�����<_��*O��fLIv2��0\�{�p{>���
ZCq��+la���Z�S����������u_}�
�V��v�W�{e����̎�Rq�*��Y�Pp��b�	|��#��)%CmӸ�*�]�YL:FQ�Tm\b\gˢ��X礩U�FX;2+>�?��N�'�(���B'�o>��OVtb�irb4��C:!�b����^��<d���-���ǃj�e83�Z@'��׆ДtF*oE�ҿ��C��{I��yR�P���#��)2;R¬�s~%�-?�����8��=�1������,�c����3ߍV�A6��?��a�ɴ��ݖ0rG77��d6-����F����s��i���K�M��%��͠2�>����AI7̝�1f�-���^�chr}�Fl$$�Hv�A���C�Fr���d��r�=e�+��J
��L���������,�I9�(NN?-5�࿖�;;��p�� ���e�&�����J6�(\��J2��SI˽��)���P�k�{���<zxVKK�T��̪���`p�!>��D��s���y�����[�������HY~���\��UhF�(�����|~?�.��V�Y�{�qu�>�1�؆�?_¿N��/?��l�̨���m�c��lXSv(�H���b!7�U^��J�)l���0���u���2����*d�9��y���<��յ��)�s�sċ*!]��b��Ⲽ�B.}����]�B����7$\/\���O�l���������N�������*�{IM��d� ��&�p�Jz�Sh|�[��Q�l�UV�dB�X���aN��dZ��V�.�,0��2Ԍ���Y�����yypz}{:�Lǳ����ey~v�V��*C.{�מ/����a���pD�Tsp&���|���e)�}�H�2�z�g6�~���v���_s�q���!	+�c8�,gx.r�**����J�]2ǀ��)�P��RҦ�6%'D�\���ӻ)@g{��T ,�#�(n���-���m�{{_�ߟ�n��W�E&�qo��:�����ŏ��-�~�3���{����> i4����o�*zP?����x�N�B/-�~�� O2�Brϒ��u�b�J\�h����M�-�x�ƌ�r:��T��A>�]:5,����� ��b|}:��w�<��͠�n ]:�8���z����L�YP̷��œ���X�d�����>�����$)���p�7e'�UOJ�CI��)�`\K�Ea໸4�p@`����@(6X�����@|xr��"���Re�Z�����h�d	f4� lGx��*/�fy^N�Q^^������D8>���N'�r�g�r���/!���e��+�M�"��ײ����Ϸoa?�"��(a3U���f𪉂�w	N�pR��O�d�u�ѱ�R ���5���2�p��b�d+Dz.l��L���9�;9�O����q3�8k�B��5����s���l �I�u �������� #�DN��2��= ~N�B[[<P�s�*vrB`�Q>Rݠ%.j'�~����Pإ����G�e�-��������XU����,c�`l}���������K��ha�Se�.������uy{�a�G���� P>�<�W�~�Ӟ��/!�
0�����&D��</�������8_���ې��#�g}q�z�	����0
��s`k#]a���n9mĢ�IX`l��D9jXT�},��86�T�N�����
����K�������>/O?�ͬw�À�y�_������ZC	\�����mX]� ��; ����T=�G����'��Z�<�wfx����qg��E�Ԁl��Iϑ�<=;�W.� =q������%�5�b�Ys�0��^4�π{l�'�����������z�p�=��P��a�s��q$?Ԗ"�0G�i�`zn�@��gPN1gt�J	TZ* ���"x�[2e�J�bp��#�	� `�;�+cUǴI�P'����El�`V^��G崼��נ�&o.'3&�ݞ5 ����-[ �r	q�y��2~J)���@=ʁ���\x���^����a���� �B�����ڔrd�nX�Ai!-�����vE05����E�a��U�<&�����2���-k��fE�"�\b��(�k�;����9V�����(�@�@�*'yoey�����pK* L!6�j^�#r�@�^_(Ƽ�� ���a�{@��L �\���ZPICς���,q�12S�?��Ys܉�V�`�6�̇����LG�����OK���cyurqz}�����MJ'��"  wZ��l�%��ِȚe$�+�kO��'K�������5?�\��}�%�%ec�G��:| ssD�=�;�p1.oo]!5����H�#0 șզ�`�љ�s�r<��A乶��xw,Ya��Ztყ��e��W�r�,ˋ���R_H� �:�T��k�F��5�{�Nz�8�M6�f!`-_¿�����0���^@^�`pd~%ٽ>��[��n�p��]��<|`'{'��([ �BQ@�<�^�a.�����>>�԰��Ck�נ|2yU+	D�_�:|OH��oǳ��h*D7��^���6t<�u2�6V�W�lq��K���aϗQ��su�1j/�"t�����<��^_��9;�	��N&H��DC>Q�����ۀ�*���xzZ�f�֟�����h��L��^-j������p����m�!'4|�(_G��
�,�	B+�C��׳5��5�kv�_��=�GRj"�S�n�*��o!��e�����D��~��^�^���{9ȇ�hc˨H~���}�n,��c�������$��y�#\���s׷;��5�a~�f $5�'Қ?F��*��Ԉ�G���CH�R�Q2���#��BF[U	�%\�I�)]L�BN���pY�'�&��v{���^r����?h��k��.�ǲѼ��1�_�ŏ��%?Ň�����`Pަ��e`�{=6Hq�t|g����4d�<�=@S!�(��j%���<&,�bl�@-Я*[��3&['�
>��F���[����������	�ϕ�	%.k&������r|5�==��rH���J�mI�C?��n����������[N�Ϗp3�7Ro���|H��zjio�yOi;����������?|�Oܖ��i6J��^���Ps�+��w���/���X���6���ld�G��&Ȝcv`�"x_����2[�9�(�(>�@)��_�ܖ�w0;==���y��I�8�P0�Ir���m5)�|(k�X��f�D����ʢ������ �o��-��`�z�u=�%��i>2zw��FY�`xIJ0�*�63����GMJγ
?��5���ұ�A�^�(;�2���mD�%y�����u#����`|}r7�����ͤ��[����Ro�r	~?$�f��(�{��Q���
c�EkẈ*���W�XS��F��8H��%������ɽ��؂஠�(F��$u�j��    �B2Dӡw��Ӕ�Kʃ
:�a�}�`XI�����YV�J�`A�'���b��y��Ӣ�=�L :��b�YT��m|�����Yƫe�k�䛎��i��JR��y�}�=4������T�"\����*�D'�H���[3�m�������-Ï�����ǥeu�p��"�2�&1 n���*�ډ��D1���ͫQ��x�n�!�]/(�>��$��P�U 
@��Ɓ���ڇf�;�N��vB�����CS�B���r{��H�#�uK�W���u�k�)E�\1������T�Pgj����fuu
�)���Y|�R�LT|}E�w��7�e�i�qZ^�Ru|}z
�y�,��>�8��z#o���/k�ߡ���]�P+�Jz�y�|��c�����������)���6��Xv/�Y���PYJ��QrD1J��P[�ț�ER��ěJ�qXSR�Mmr�_��F�t����y�a�e�Y�n�L����em����.�������������<8���S�;��\G�''0|v�3�P��i���6�H�V�+���o�x��K��5<����s|{���W(͐H�F4�8�h�\^J3I1rn{)�,����>�o�nJ�H��e�|� *F4X�䕉����'"Ӯ)f��T%<��}NU�:���QS�>^d���W����dF�|�8�u��6'�.��Z&+������&����$�%����}M*�%�X�Y� ������������p�������*dmX���I2�պ��S�'��������\W��Nh�j˻�
\���tک��<R��gW��A�ȵ���R�ٞ?�0�X�K��T4�MO�x�_���/�a^�+ۯ�P�V*�+(���-��Y����b�T�R���$ �1�x<��0x7�ȕ�6Y]����5+[yx��\'ܞ�����$�s{�T1��El� ��33X�.�������?X�0_C�%�!���:�<Er \�\��$޿}}���}�������$��@��s?Rj^��M^��TU�(&�M���r*]%�i9�)��e��u� \�����,f��p���&K��u׷���;^�|8�A�\9�����
[�χҁ�5l�itȦǂ�h
��R�-����)�W?��M���R�MD�s>�3��ܭm�e�X�AWF'�S���"�d*�p�R�`��ΰ�`����xF�n1�_��EP�c����r�'e9=��QC�a�b�vKuX{�`M�|��յt){����-@�ÿe
��{�V	�x"�+i���ڀ�MW��]�gV��*�*T*����*C�,x%BN�� �Ѹ�d�#,{��堝#h��rEyu4���l�������ׇ����+�{������O����0F�#ϭ���p0�"<Vߖ���[�&n��jw�n^R�.y�z�W��D�FܓBs4�M�M]���8�+�[M٦����g1���u��{U��g�����׻��
He�{����T���u��"~7��.�ߑ��5�0+���=�'����&�_���H/�Wj�������Eo���b3��6�٠�"�-�I�T��9W.E��[���#8�C�21��*�m�i���i.k��ʨ���/�N�ʓ����}yU^o</��ɽw�'�S���VW�\���c0��e��j��!���c���1<��B֍z��A����0������K�]�Z*�l��X#WF�@���`�`��O.A��Qi�6�A�1B`<��^Fp|ے��/������������������"��w���r�aF�,#͒�3Ѡ��FJ�(j}������R�;8�h��
���c�YAބ��Hʝ23�IÌ��@ˌq�v�P� ��ZX���DRU0L&E�+�R$�j�C��C���`&���/H1w�J�o`�{=�{ys�����l�
[�$�����S��;�R��Y�b<J*ءח�e�z��^�~�%�&e�䡖�Q�Q?�PVMQѝ5fs�!�]R�6QjA1��:���>ʚ)�hV�Y
�
+51��red���M�m�M���t|{z|�w��h⭱����K���|~?��!��������K�㢴�o~yyx�����߀���WZ�2v��'�i�������4�.�߳p6�$l��:G�x�x2�i���W<C��;�T)�A IO�.w����e	�ئ��(t���۴�������^|�a40ۖ$Z.��!-CI�N1gO�-�Ҟ,$H��s������������`3	@���K���U4	�~����E+��-��m�&0-�*�(� �VU���&MO����wt�Lx��cM.�<*o�B�VZ�Ǜ�#�&l����i������̻YC+�M��~t� Q^�K��ۼ�)�R�[J�T;��.t�֔O4=�v�vǿ�:����\VREEe"Ԋ[i8��i�WRn/�L�v4�eū@= �)���?S�n�GW�ͣ�O7�_�xIytr<�̐��T~)��0˵��Ѡ�b=m\kl�R^�"6:U�H%9����C�^�P��|���:B'{"-z=��<i���K$\j=h����y�q(jӔ^)�N*�0�^Pp����J�kKUx�������N/��!�q<�D��G�-�W����*s�5�4+ �����Oa�,����{��ڛ.�@P�4������aTI*wW�eUq��,�2Іȸ��*�JG�p,�s�A*8H� +;��	� �t�������\3&gz��3�ϻ��p3T�K�a���m>�]b�ϣ�8��J������T�Re�E��W��1��	9���I��o`�N-�MK���"N�8RG ���Ĭ�s�� 	,B��DU��V�D�*0@�L
ډ9���n��,�5-��u9�8�M:8����Q�y�y2᠈�P���Mz�b��u���:�FY��d4.���*���5���4K4����G��ۭA1WCEj�GtRiA����D����B��(\E)7�4,�;<�2G�4)D� 55���#�l�ꉏIs�:U���=�w���w����6�۫�L)g/��̀xZ���Lk���v�e�\����\���i�C��K�-M�|��>�iV�_B-Jπ3��`�{T��?�v^�;��o�FS�O�Bà�|�*h�3)�,��̀�[A]�$�M��RT(A� ��
$҃�;Y# �)��x��hr9pMj ��O��F����W'����w,k�h%�'_��Kx��������?hfCдR�����'��@�0E��@�r7j�����Y(�	'^�m`�Ȅ1*�d����r3S��
�Lˎ�P�E�"c ��btq>��ta�aY~:;�"��`���Umg�Ji��[��xǒ�Q2�- .jz.������kx���?�j�#���~ٞ��Y��	Mr����ǯh�h&#/�a�:g�h��G4�S���$���ZE��8�<^&��ѹTd����&�M2�Ӂi�Ovjڃݺ�OgG�"C�ýUxӽٟ��|��y�p�;k�����N I�:բ̕�:m/1����:�F�f���+_FK\���lB[8fڔ�2�;���{'���q]���%)��\֕�� ��[�x!'e$P�D���~~/z_}�}�༶�K +�U��fU��?T(֮aŲ�H��T;�Rus����F��ϣ\mSWt�����8��6�������O��Np �+ 9�8��B^J�l`��z��̔��K��T)K����0��R����j�k�Z`�"U�8�]=���w�k���ˣ����o��0�Tu�=�iY�?�1Z��ڲt���$�����K�!~����^�8/�fM���s~�A4�p#��űݹ=!<�Y5�oFK��^F���ZB�*eB�W*�(kU�\+��Ѽ����kX�k�u�R�P_���J�CC�^5����6��lr�b�ZS��w@���k�N�K��ek�)�7lm�VLz7�d?R>=�}z9���OZb�o~��+:*x3��5��p))�[~��l|���6�_^�h���Ӻ��?�_$��{q5�Z�o�@��@6��r [�e    �Ma����>�̨,F9j2��S2��b]fq�:�1U�Ѳ AUW��A�|s~�	��n�}���8�xh�VR#	����eW����v�A�_��q�E=����1U��W�ҧL	��J�vƠ&w����-۸��k&��g�~��Z��� ��↕ރ�	C|Gij�S�5̶򔂏)F�b��l �um*� ��J���V�qLy�"�Nr���&Kquw}]^����rL�Qg��S2
ԎKX��db����O�@憠 lߗ
���X��*�)l}3�P��)C�{�%}���$�eO��v�D3V�a���D��3�����E�Ux�Y�>��Ҵ	E�O�ȃ�m���r��. ��4��I0�(�c4�ӔX��u�5K T����:��`�2�Yv�����d��8�Q}�]2)/ʓb�轲���b�+����̑��v6�Fo�r���΋e�\�RLSݺ���y�+ŷ�=�_C�Ե��\��E3rA�~l��]2��M����]�D����k�+j�*�`ѩ�_����eW[͒��- �jdN}��|Nu�x��a+���������^r��4��F�Am�r�"�LhkF�����`����h�v�:;c�n=	|J�u�^�Χ߿���.�=4�#�t_���kf]*N1G���\1���9��Ќ^('��s��Sֶ&�Ĩ�6=+ vSA�y��ր�NP7�2�z.90~Uw]� �|vwy�/��Oʶ���tz;�Qn�99�ݎ��'M���d�ߞ0�̕�z{}P��P�d����7�e�M3FOX�������}������H��S��u|;u�ֺ<uӄ�v'�@�5�@(���2��d�9wET���aф���J�
|Z�L2̓p5U0X�q��ق������*�K���z6�f�y��UyrQQ����ŘF	7s�;���ɱ��8c�wL{���KM�n�1z	�Y�p���
�(�Sz�_i��/����ưP{��)ճjC�BP?��tcd7�-8��)i$<(�ۦeLH�b�A��;�C�K���\e�J�
)y�C��)��p���.u�|r3�0��>w������m��B��1	C����]b(R�X�uu�e��|ZJU<��8
1�6	��쥈M���kj�u�ҫ���Z*?���W�Ce��LYɸS2�*ǜ\�z��\T�xi��&�!6����)��t�b���מ5>M�o�jL�p�_�c���8�5��{��"b�����|�'���x�C��R�}��7tM*J�I�S׌Z���4A��Z' ���V�1�Vp��c����VIrK���I��9���v1c����:Ug��㋳���nҳ�&��^o���m��M�G=�S^y�v��Fٙ���5?R��n8C����|�i��2�:vM�������?'�'vr��K�b e��@�p��Ry���N�B�hs/	����I�tj������>Em�5 TUE]I����kWL�9�T>�t��*��M G�֖J�c �G�#����^r[ZÚ՚N��XB} ��M�:=�����Ř�fƻ�P��u$�����YB�^CT����".�i�2"�T<G5-���`/�
�K0���lx��1�>�����NE�5xo���^��p����������<[ESh��ɕ��n��G~�zA�(j����h��[�6�)ܐ��rri��������P���^����c��
�$�3�f��Z�O 9D���B�4�*��@�Ԗ�
��VYS�5�P�����l%�OԠYA��&��"�������:]P�]3�xrq3�\��������π{�'�f;t����bvNJV�boȱ]j0�8_���H	G��=��&*��C��?��<?��=�߰���0��~��U�=�j�WL8k�0)�#fZ/�ϮD;浅N�bY�IY�e���QT�ݞT/+hi���<�J�l�"x5�kYi+��+	�֝~�TQ~ ���V��)��w��7���� no-��N�g�ئ��%���v�Vw ��O�"ȎIQ|���f�������R�����mO�Skr�$u�1�����?���g���n?<�\@�n,KX���W¬�
8n�*r�,��`i�2����Bd�5�0sQ���׶ts��A��x�E��b�N���p��x��6?r4��/������&m-v��1 r���6;�.1��X���������w��1��&����r|�V�S���C��y�����N-��wv�N�FZ����i�+�T��X����R
g����on&�4��{Fj|vF{��Ϙ׀����S6����#��-̞#�hב�z 4k�v�0��l���O�
��x}|��9a�;n�8�����E��o�F��Y;�y�H�g�ez�A�xeQ�E�T-�]����C¬@]cp���)��1��i��
"�UY�Q�(��VRl��;32�h%;���.�%�{�8S^b{(����b���۽~���ZZΰ��S��PSb����b����<�=@�a�-���=�ؐ)\���_�m���h1O�"���8�նy�	��f�TaS�PIO{&���4��-Ɯ)Fc4"ǵ�>Fvb#u}�N��������
9�щ��p����r)/ ��~�>!�q^�\�-�x��`�h��w�U\�}7PN�*�"��)�<O'���������#@×���r�TT	��[4�daǫ�t��iX�D|\�L�<F,�iMR9�\�Z^�rU���:YUL��4��qxR�:�7��1i}������cyrs��m(˛�cc��]��>� ���=�����5�W�g}���v *^;�T�[H��!�=j�����ք�z�;]�z��Jj��gg�2_�[�!T��Gh�����4y��j.r��R�!���ԕH��h*��U��6-g�v����^�lX��P��:�̨p{��Ӟ�fK���げ�v����5�iڔ�2o�M'�?��I���6#���9�}�4�]�����f�wWw�ϟ9�����|�6l�HY��]����C��2ey�PMs��5�)�M��8w�	x����ٱ��r:��'��ϯ������j@FM���,ԥ$�U^,�Fdٔq�Q�Gh$E⓻y��ƺ����2�!��K��*��N��2�$��t�۬L��jڷ��;T��_�*V^��0���xǷ��ef{�����0�Zo)�x_b05�X�Y��ᒶ�nF��0z�B~�O4�K��CR�v~�S>�W���O�i����&Ҷ@��Ec��&(����T��f�Z�|�����SC�f��I�`S�d�����	�˻�@ӫ���<;bF���F�6�R�?`ܞ��o#�a޷������*��?AH�О����,̝�����G�iu(�;��{��% ��L��|q{wYΖ���gey}v+���JG(�y��Wn��;�֬![	�~b���dB[���^�_T?v���KASD��"r~Cf�	>A1v��(�7�`!=��+��a>��(��)�p�iz�NP~fi�V�!%I;���0Q�Ux&eg\��E����'��)|{QR���Ewx���xrB��u:,T*&���ߗ�#�XF��9R��X���z��*_�\�}}�=��ޏwa*Ӑ|�D��ܰ���ț=jh��ۋ������dpw4�,*|��l�kk�h8��"��5��3X�J���լr�Y�/t��Jϊs�ksp4�(i���uY\�^^�|�L�uQ^|�|P���L�
���R����@n�1n���L�v�Um��������o�y�{��U?K~K }�&�WC4�.6;�b�vO�YN��m��#`x�O��Xwm�����1��ԩy� d�\��:�o᫶��.1X��XF
���}��74�9i�ן�o�F������9=�w�9�v��r���IO��������hG<��q�1�q>M�Ql�&@�R�'�Pb��O����=�ǭD�D��oULhSЏ0����4�{��W&��:�Aj��# ���n��`�l��۪��-�'�ɨ��m1�a �  Y���� P�ᔖ"㺯��
�ͼ�[td���n��O;�b��KQHjנb���ͦrM�<2�,�½�jm*.��y�h����L �<��͊�W�8�LzQN�[Vt7m꭛��eO���
fQn/`��i��m�:�%���y�����r���}�!�����|i��҄�=w^[7�� �3}4Ϯ�<`SN�Ocv��J�n� X$��<P�Ќ�xߜ"��u3��{���1V��=�)r�i7Bjmt�T��F�k:M�r@��ߧW4m������r7��u����G�x���LI�t>Y�&r�tt��`�s��疭�Y���'���������=z!(q(]S����̆X�}��:Y�/��V��W��w^��5�\I;&T�K9�]�U�x}��ժ��V�z_���+L}�j�ה����L��LW�m�/3��;�ڵ+?���qs��Ni5 `Q=4)����{�VJPi*��v�O��ZT7��H����� ��|PO�Vv�4�/���fJ� ��4.DzM�i6��� m7E��"�?K����:�a0��p�L��S�<����稣�םėw��ի��a���Pyz|6����)/M#s(��)_�?���bΗ��h�U_uͣ��U�q!T�����������ԗ͸pݗ��a��iP���3���4*� ��6$"~��)KL6���� R�R��[L���	�8�k%s��*���E�Y�lH4������� �+�k�d;|ss��������FkP�C��l��D�
8<�z�%>���*�+*��4W���UY�h�q#�v:eÛY����E[)��VAՒu&֖��q`'03����3�^��N��f�r��u�kp��ZD�����Kw��כ�6�Lt����Mq<���Sv��80�fBt��}_b8�:_�݊c � ���(e�&��D���#��7{��y)�*���$>=Rj��R�MF��4���[����%F���KA�L�Z4����� q�Ρ���i��$.��Y棦7w�8t��$��F��m	�n'Sڱb ���%v[G�r�a>:_ƺ}J��q�0�o�X˽w�\���D��=Udt���SM܏�����s��}�2z�h���4����H�:ep,&� ����*xB�ۨ��N���qt��Ml�vG��]qK���:n�mڏI�Ey�irBCBD@��Rm�Q����,�yw�`�(%�R�X�����!��Q�v����ZHOҫa���b�	���� �P1�����UQ3m�ʽN>Y��f��T�������f�UL]L��׀��7�`B��X�L�M�;#{f瓉���D�0�r[2�}�a�;_Ʋ�i�۲"��(�����.ݙѳ��G��Li>k_N��U7ࠚPm�۲����^cr��U(�i����x��R�-m��j�S���J���'
gf�1W'��=/���f�o��9�v�rѪwr��|~=$�f�wN���-��W��،h��'֣徢R�.1�L����.�";�w��Kjz��aY�yq>��7��N?S	���f������+g�� ��U�d��|>Դݬc��Jd]m	�5A^|y���1���������k����ކ͢�����}R���˦�#�-��J.F�P��\�D�>�(�5
cю�QC�eEV�犦?�L�iJ�i7S��1gvэr>�D:����ؾ�).`�[�.���5�U+����Σ��j��^�//
��#H�ȴ凌=��+�����{�����?U��+n�)��&͖�=���~U�R�w�����f��9�z��pH}��]ν��M3�O4E/�p�rԷ�B�B���o��I}�.�u�8V�=E�t{����ݳ���+�0>#�N0�WFOA�]Sj�W��_i#�+�Dp��U�"x:>W�u�a��S���*pC�D�E���]��Y���n+��>��C9�=^���J7,�������A��Xc��l�7�=��a��ߛ]���ns!5;*�&��'�BW���[���c�h�6œ��Pۊ�Z���r[T3�V���2X=�U�2��JC��'@�YX뺊�6�u��*��xz�Ҵ���d�5��i��=������r��w��W����'�L��)Exz����n�\
�7��2׫�~Ch�i�٧�O���L�xFݒ�ˎ]k�SU��L�6֞vn�Y���� h�"�y����/����=��      �      x��[[s�6�~F~���:E /z�,�E[U�̬����2iʖ�'��|R$!C>��U)g$^�ht��E�WJї�gB�|��+�ltx{xbI,C1s����r�����������=���i_.�L�ZR���
�����|a�D��-̝�6�)K��-gņ/��υ�D��N�bl�fe��0�o��B��a��2�� k:"�b4"����֡�ltǗf�>�71+>Y��w9٬�_n����.��U�7O7�h.���H�0Qy���:Ꟛ���B���i_���۟/�__n��Zk� �NK-ƫ�p��:G�z�?�|{�v�P$8�aǻۿʇ�uT>��������՝���a�|�m������X��Cq��sf,�hs�8���/�\�._������_���o�����0:c����vdV��=ih���y�0�)߬�զX�{��ۧ�X�š�$�@%1�Z>����!�1���Ш
_�����h�������e_V���_/��#%��P� ��{�ҙ�ی�����|df�n��g6��5�9��cc͜�wu��RX8He��YO�Lwֻ�n6�,X�BX^}���>�q����ruww�z(�PfA,<>�ӮR1�\t����9|47���XP�u�@;�$��߄���Np�(�Il
�17fq�E�E��t=Y1 ���/��zjz�CݝGC�ud�ʹf2Ɠ�0Xt;���4�qK๦�!�|
�}no�ct�sk3���N0�0�����x��Fb��Zed�Gb;'$�Gb o���U��V�t#�ؘ�),��8ǹ�L��D�lxQW�������0�h�],.fxw^� �h��?�̈́��k��@�peS�r��N�_��]?�b�� ��#@v.@ǕNo?	�273��y��vS̋Q��l7�`<����PI�3���տ5g�q�k�Y�G�}�l'��3C�k}�M���7�Ӣ�	�';�W��u��;�G9,��=N>�ɭe��h�E�/��yʉoJ1�v\rZ��Sc)��dU2�ÁLes��z���K{�־)�eY ���(T�p��e�=[�V��Ş�����pU�pc��	9U�e��#gi�TJvv��d7�r�/�Oܼ?_wϏ�pe���̯?~>?��I��H�?=�}���������+��P-����*���T;��Ly�_u�_F�؛ng��:_\(+u��%u��0��{0H9���;>��X(,?�O'9�����u^,j������)W�~I�����#F�Ton����e��[O�ąc>F��o0��_�bq׳�}K��@X+�������f���X�뼳+dL��a��sb�ʘ�.���f6�S��p�v]�c?�!Nmӿ.�u(섿���艌�^�L�l(t �����(dJ_\��zkfֶz|35����l�(d�a���xaW�d�a���#�F� :��.��D8�O�$ ��d� ���[J9~ļ�~��O8�������0ӆ]"H=�^��ڍ�׻2�tA�e�1��A�H1�A\K(��ƔZ���fn�Db�� 2�m'��~}W�tY�IBO����"���B��d̋O��N��2���YA$����[��|({'��0�˔�	ߴ��K� q��-��{�`s�*�����ӂ44!�3���fф��(���$��E<�}$fZ�\OW9,�"{����խ��di�Q��{ ��K;v_��+5 8����>�w�/JY]8��]��i��B���ӡq�̢3A�&��ώ��2]F
���
4����g�D��qS��E���Sp�s�ҊQ�n�R��Y�9����P��(P>�nR,X�TȊ6��@";�A����=q���$�ec]�绂i�ģԧ#� �s�һ�����'ʗX9<Ej&��#���nr�˪�>WY2:ƟX�\���qm�f�O3��ߘ����vN^w�2_��F�_fU�a�v|]V���]>��aB�4L=�X:;�1����#�ōU	!��7Bɕ�#��l򞛧�<�ҁԗh�k!.���ڊ�,�0MUk�8�p����HaL��}͋��L��*d����C�_-L��Ldi���z�U��Y2�\.e�i9�  �gJ^}S�rW�3F�x� ���Q%�.+�&t����<�������]��*7�-���Bo��x��]�;eK�s@?����̻�8���o柮@���͙��;�EC��`���;ʎC���A!d�G���Z��~V��@*�z�'v�-L'#8�u����k�x����RJ5=pz,?v�6�L��
p{3_�T�����P�|d�t<��WL"_Q	��h)eO]6Q�<]&�Y+R�(��t��YixF��d�̀��� h���*X?��0�m�W8Ҏ��"�2Hԭ5B
Qvqcr�V��ɑL�i:�v[��J&㉈X�]>e$��hM��הR��q1�s�@���ʬ'D���%@�)��}
k:���S�=�<�?�&CHg���F���������W�������o�����?������;^%��ɡ�|��U-�5�;��(�ֈ"�	@�%�@�M�f������*.��m��Ӭ�0fZ��ED���V�"Z��AǊ��CJfy}ݿn�'��IK3D?ص ��cw����O{�ڶ���Au��WB�H�8=��7�I~����kD��$�<���nb�^�	�;��5b��[��L�p�rd�T���M��l������Y�8E�~��F��?��d�����ioa�<J���?)���Ԥ���_<#�	EX��$�`�v,_FL��,,fn�Ӽʅ�c�����p����r�L�N'���@(�z��{��{�˻�f���v�tEL��U�V�C��j�V�ޅ^VJl�Y���Rw�VeX\�aAv���m����3k��i���I5�ڢN��x%R�KFB�6	_:;��D,������Ci�]h� �˘b��
�>�!ѯ���U7��'6�)O�I�3I�� 2�m�Uʴ.0\�ل����)��P���I.���#,�6j�ģ��9�D�8�C6X(E�G�� :Q�4N��}�a��|�!��B��WoL�L$�S��l/�!���&�i�PA�j
u�d��!�4X��M�v�]5%�JI�+��g��Æ`(q췕����`����������� ��<>����cy��?�%����yn>AQOo_����˗F��g	�B[�D��e���W�0a��P ��Rq��
fuŻ�S��u,� N�Wr��	uĒ���"�H���h��Kb��]S*�P�;'x'1K���T�/����V�H C@���a\ͭ+��Sׁ�j����~C k-����b߭��3ѕ���C��	�In˛���)�r'):���?�T�-\O��Q������g�KRϟ�B�4���$e���c&^����#P��sg`6�#��}%x*�\5��[��HrjG:�|3���q�$aw�ـ׳(Ҕ�B�K��w�X5H��o�cɯ�����ʿ�o�3� b���OǗ�_=��LI�mј�����μ|%����>>���v�;�<ϻ��22��5��QZ{ڜ��'�`I��O���徴�Nw���z|ٕ�|�z�'�m�^�s@I{{�j�}쑊�!qR�+����K;nz�rR0s�^� ��|�f ���މ�Vi�}EW,J:=ZI���j�vk��խa�������]�q48�=a0�:�X��z[<>����|s ����x�����K:RK�qB%5��&���hE�l�����G7})�`���x|�������$�۹"���:a�$�֘J$�ޣ"��zU ��Ya��$l�{�ܜ&��ON�B����!e�B'��?A�-�w�!tα�_M�դ틪p��D�M	' �?�L�=P�s��Qc��K��	1�8���ЁH��R�<�'m8q&!<���9���ۓ��ˆ��ݚ�z�_/��,�P���Okv��|��k�15ԗ3s5AХ�g[� �  ՜��NyiDsQ��H���f,퐰��ۮh���%�����mT� Y���UAc�Ӝ_3J���]о,p����h����NW�XP5¥!�k�p��	9�Cl�Q!BR����Ǜt�D�U�^TwB9t���,�����7��Nx)��������KtR��d����6)����a�Ss8֫�7�N�cZ-M=�n�D�L���#��﷗��&�̄9�<؁R��6���r���q�r�V>@�9Ϗ��� <X�4o늗PTӈj��A�`G�X~$�XLY~���r���O��-n�W��0^Yҡ�*g��ȑ&,V�<!4��R����cK��S��Z,l�G��6�3�dHSE��͕9!�,��;�=����|D�<4n�w�V[�W0)Xo�����,aY��4{���q��]<�0�rc���q�,e��h�[�M~��������|z�?�|:�������Vv/Þפ��;O�*�#��O��Y���YƲ��)6ʫZVg�&@g�<�LƄ��%ͫ�������|3�Q?��X����T׳�F������M{���S�̝�F ͒�
Wl����~x��6��l�02�O(���˺ 9�,n�L��I�Ҕ���A��m4ˁL���(#�y�|	����b�������7�	�{
u"�i��*Y�]�,���GV�`sÉb�K�@"�!KD�++F'�,�p��4�%h�Ly�7������`z{@������CQ�W�����S�X�%�H+ʗ'���)k��r��1#Ф�dF�6�v�zԝs�A�i�q������������˿y��W'�*H����Jz6����)�X>�1��[����dC�V�5Y���>_|Z��-�盻b��:�AIH6N=*s�3J���z���q6�T2j}��*��`��DG��~�q�qJ�(5PQ�i�J� 鮦����/�����׷�{$u�J᤻��&�可�mw��1��猎hɢ�"[o�I	�#�;W��\�!�L����&Rhv�7@t�P\�q��_��4�h-@&YN������/�����T��L�aʄ��:�d1��)f~v#�| ��9��:�r�o8�;"S�r#FDA�+�au��q�ս0�H3;�49���1��bj� ��iOw{�q�!_L��:##Ҿ2;r��1R�������� 
�ˠ M�Lp�z޷9������~�'�4�Os�/��/����P      �   �  x����n7�ϣ��{ �,�}sl�!���%A؃Ȗ0�$O�"�Z���n��b�����>�A��9ы`7�>��//��?�w������&�o%ϥ�*=���&�����||jV�k��������������R���ﴗ�~��)��͇����ui��AJX��e3Kr[e'c'k�o�E	��ĦD��GY Tw����e��dtsj����y��e����,d`�t������?�}��\�rn�D�f�r��U��|�r�RX�
��Ԗ������_���l�uc������25�wurrk&#����6��������O��巫�o���͗��ݗ�׻��d� ��t�Xm��dْ,�9�&{Y҃x#[�ɏ1��nnv��χ�����$�ÚCI>b��*��������q�
�Ԃ,H�+Bo-c$|2#�-L��T�U�A'+�B���4PJ��RҤ�P^�	��Kd������B�^zQDl^�NQ@�HW�w��+�_]����������J|�� L >W ����&-�� �o&h�����s
��@�r�E*�d ���Ox��;�лL�\pz!a,�����zF��v}��v������ิ+�pB�jw$D�g�� �u2@���0g��$8QS���	|�	��4���DGW&�� nh��x�PT gG��.��0�"`]�4�2��N�=����$�ё5,��c�W�T�汌a�.�s,#$����p��Swmr2�����NԸ���-y�q�>R�� ��W��e����2�l9�*T�ξ(�{�@�3�d�&����k�:���vs1I(�������\J+�I �����8��Ϊ���3� B�Sci��A9kMEh^�ofp)��!�"ԧ�r�	č-�P�А$� "���B�,��`R_iW�@�l!B�PHޑ�?
'��� �C��X���jd����9��v�8q NB�
�� E�W��uV���<M����U��WID9ڹ�&!Ȝ�((�<�(O�ء���+\��]�����f��lE���8��(Gy�0���q ����q��qr�$kyTb (���aϥO�� �WC���0	�5?>PȘ@R�
S�_;�a��f�凘�4���ӎ��thĤ���M�n��s��x�Q,���C������"�\��w�ۻ�����mr��2F�)3zy8
Dz�y���,i~��$��I�=�5$pz��U"h��U�j�?�Q����k�[�B"𥘂�\�E�����Le�*C��p�O�Z�71.��@c!~�;{�γ��Ҁ�<�
���Mգ�sR�nri�X����w�4J�3J����2h���U<k�ra=�.�-�'���iXWn��:G�M����z�N�{�p,Y�z��+����~�uV0��`�F�cߺ��kwS�?GC�Z���"~>��m���m�����ϊ��4y7f�2g))ͳdJǭ��zdɱ���Y $�,�d5���E�8���V�ޅús:��k��3?�:��È��t���b��\�����m��m؈��Ӭ�,��
���3m)�ғ�Qy_�z�����E���}����@�f�i�)�Y�1��V�#)9�|5�DHOH�	����j���O�(֔��$(�S�b%�9�ns7b\�J�X��N�j��ʣ=�>��(�X�F%���0��+��l΀y��z�sd�4S��u̃بd����[:���lTd'����I�a�1���e�0Q�[~��(���pz�:�����y��W[�nc��ɍ��桅�7��	U�<��������z	�y�K�4�ۘ��m�W�,-���~2N���Xb���������J֓ң�Ia��I�S&%7
e 6*�3�?�B~�a��P�B̓nW���7@5���p���i<8�?թvϦ/o�L��q߄i�h%��C�d�i�����l)�펦1}Wl%�T��v������ê�ˇ�������P�      �   w  x��Y�n7��~�}������j�~�%�n� 
�R�[���? o�!w��h���k����9s��ɼ�r��͔?R2�]L��}]ޮ��y5r�a<Qɑđ�9�BR�Jx	�e@h5��V#��<-�#dϓ�F�K���o>�����O�����77w�w��z��	����u��e�{��>\~��w#�
��^�q䜿
�mߌ@�����Y��uJm7�1�r��"�g쇧/_�/�l<��?�f�ة����|����?�^(�,����˛�v=ZX?�n?��|�c��)
^�R���X 	4h�I5ޑ7CJ
d�2(������'�o��*��^>lv��Ύ��� z�J�]C�^��쬾E���������wB̤m���V5����i^{���5�֢��?@ c8����Nԩ��gcQ���l��Em�#��"�d:� d�T�ՠ��m>�ͭ���˧����䊷2����G�='���\I޵�FXc!shbЯ�
$�������V��8�3�}��]��Q�p�tI`%�>p�Ba�\Ű��k�#�ό�|C� ��H�#��A�r�xT&D�J���Y���@�;m'c���o���r��^�M��5�V���F.�[6-�4�6����ǵ!{V6�@L��T�v=������� ��-f��?s41�>f�Y�j�ƵJ�-8/���c�^ԩG��&l���-<*�A�hV�����ȿ�Е��[�O�i3wܔꆆ�3VJvI��9	�	q�z��ب��Jz<��L�8lӽ!�KR�֐�ǓKn�)�]X(-PrY�3+e�CCl���D%���=�6I�.�ho4u�8�D\=`�<��n��:������$�y8�}�'e��L6���rD0�9�!'U��ǎ�7��t'y������@6đ�����jU?84/_�]�W���>=�����!r�W$� Ʈ����֐+,�*4w����������A0�cDgj�e�ۃ9{�>��-���ٯ������/g������j6�8I���o��%n;uA3�mQ'_�<��* *�yo�y�;�J��t6�1�L����d���䜴>�X�*܁R�+U��zMp+�8��6�M+��7ܫ�������c��:��aOz�8uJ]�|c�����Zڐ������#G����S�,�A�a��{��s�ټ�������k!Dz��3|[��j%��a�I�����_�r`/�BqG��YP��p�pH=7w7wQ1C3��م�1�ZXp@��\Շ1����Ƈ���I���v`��۳�+�����(�����FX����6y�r��L�H�LH!L;�Tև;+�I��.-9�B��{���_���e�M�o	 (:��Y�?��TDF��U�čl��Żg%��\C�|5�x�ی�v�}5@Vka�v�rK������XlL.���s�e�v(t'�x��e�}73A;�>;מP1A]�rb���;@�p'��,�"�p���=�W'����"�H�������	 �ygȱ.��'��?�at�Qt�H�ݧ�7��H���:h�Vr[4I�~+#\�\]]��h9��Pۦ�|\�\�}�	˧���l���i���&�&�/m˅@^��z�
v����n����$����ǟ~�\^G�K�.esnȇ.�KD�cl��?58:�Nn-�Mvpe�M�%���QJJ78�.g�A�������҅#9b�jy��Zh�T<���mǜ���<��n�ߖ����e����v�ވH_b�.}&���&�~i�����Y4�P���j
�4Ν"8�%d�A���5��Kn0j������:��H�X˂�8�ۜ54Ή��'��l�sz(�Vs\V��X������~�ϧ&�6c�뺌�XU�t̝;F7�ɂ�By�Qe���Ph�`�s���M���j =w	��"ឱ"o��9Jb��OAa׋�׳�I
+��L{E�U�1;K;x��!��d�׊]�\N>F�4�?v�Į�ח��p��Y>o^?����b#�=�+�q$�Y�z{�E�ub]c�����/\�����x�G o�P����~I��~�/��,`;��}p�����]�+
k}������������      �   �  x���Mo�0���q#����ˊ�`X{��Ê�ȚF���i]��c�GC�c�"E֕8έ��z�nu�������%G������0WpJ���ѲL+���۟�HҾ���LR�J)L��~��d�#-�^���۫���dWARC���PWC�J.�`��|�����>��I���L� z+f�1��,��$�T��|Z�����.��@���c�4_T��t������i\�no�|=x����zu�H�CO�@]����"����<iqp&��9xS�)�t�[2�ս�R�̲~�fb���9y[\b0����H1<�wu�C��+~b���(�i�6�80S��hF{����`�F���s�{����)�땁;4��/øO�2ٚ�)9�̲�~��u֦��6e*�����?�exfM��~�4gzk
��B�~��3���;0�:�5M]��d���_4M�uN��      �   U   x�+H�K��K�O,�O�����*\|�
rI�y�ȲN@>WAbf
gpirrjqqZiNN�BAbenj^�BI��KjbNjW� I�#=      �   j   x�U�1�P�9>L���ܥsU�?��b|r,+4���]�G�ü�ՙ�c�E#�l\� )%薭��|i�h�GS��U���fk>�&�ϋ�~ ��:E�      �   6  x����N1��g��/���/C�(�-!U�&4�D	y��z����R�\���?c�o�
��q����9�Z
���E������㦾~YԌ1qr��9!����i�K@Lv���,	H<�iT�|y��2m$�I��/1X�� ��"�|Ju:�h�%�Ғ4+��MUEx  �gSv��ͥ,�t��MRv5g�X�Ad�T��T��0=���q�>���xfA�6qz����zGllIxX-���ݗ��=o�|�Z�wE^�x_�J��&��F�/�"��)b=���T�H	��,!��;�HX�Y�J���tV��?�v��A㨼�R���	U��Ҟ��H� 3J(.����x�ݘ��[Р�bD���~�d�J��H&�L�<<%�(m�����j�]�VO�׎�c���3����rYX}�7�#���C*s'R[��, t�kߚ�3Ω�$��|��t��}3��C��a�`
6����܊�Y�����&	"y��a�.�}\<8��t3F"V�����"�gySX���̎-�1y<�FÏ�ۮ�q�cۥFk��\��f:þ�q����q�r]�X�m\�&�8z�\*���C�w���z�Z֎K:��-��F��lhz;5���cO�O��|���=��<� �d7�T��T2�����Ψs�(�Ry#P����;u�XÁ���QP���Q�=�}z� �����DQ��7wƚ(��������������J֧{�3*���ƪ�P�>�����u�S��X8莓���9�M�5�%:W$^t>����| WG��ۯUU�}w��      �      x��}YsI��3�+��m�d��D$q�@�hl�ʠ��ȢDi(r{�߯{D��84m��=S%C_F���wpmF��j�3rEG�ߍ����|���U^���ȋ�x���v%4Qz�g��&����w/���s�����4�?���������a4�����>���~F����1e�T\s�)ʈ�#jF�������;�m�����u���|}��ǫ�<��we�_q%��H	��M�^��F�7�|O�y	O������ܻ>f)3*=��=S�!d���'�v?�M���d?��@����zwx}���_9OyMU�'���S 8���i��^8���<_;�J38M���r�x�|���i�k�3B�҃��bĬA��׻�v>���3x���F�����7�D�Mt\Bi2�3j�Ly��7W�zS��6�o6���;�Jj��P<�-���Ɉ�*q����h��wŮ� �MW
�m
�1	� � �c�peW6p�|;_��o��LV����g5���vQ�f�,	�Z��U���j��b�*4� ��ڢN
��K�h0j������f$�Rb�p��nuj�Z��W�rY,�9��#0*\���I>|��/���:�T�LKc蠽21R� ��|���*׀���@���RsMy��J�=�h15���������{�S8ʚ�$eB5��˟��C��f
$H'A�1YґHxա�g��>��؟Қ���\K�I�h-躍���4�o�2��x�J�ƒ��yLw�:�)�$r^LE��"0;�b=��
�7�9�;�R ��kn2C��}�	P��ؘ�lKG����c^��)XPT	�8���5��ϗ�1PF�	�4�D�ݶ1ٖ��y9[�{�"<�|�S�
\EN�?сS�s� �i`��Jb2�-m��P���L�ȸC9����"ڠ4墳%ecb��rF��iJR&�L6�!����~�z7[���x'�+I�������^�Đ��1ِ��Fy�t��
�?��2��8��� ^�0��Yz���4f!k�;PŹ����#���@�c�sqM)�Ɍʤ2A�dc6�-m�~�_������^:-U�x��ǧC/>���m�u��,,p�R��} T�N�������z�$5�,���޵G�ͬ��%��t4F�r�6[g��𰄴
�L��[g���~��gk�g "�$6}�e��d�9����X讀7��2Ɍ�����@�욃+i��N�� <F��~�n���Y���,؄d���w�J���N8I��P�u�<e���ʎr�QJmX«�ǰ&UَA9��&,�#y�e�kI�vs_x�X��ȉ��t̫Nf����fZ3��t��1�@}T^:>6�q� :ev�	�3���d���U��Y�0[f�_�z{>���<<>{x��C�Ph�<��ԅ8iK�i{�X��^u�&��r�"_��@`��H�1hP��������
���Bf�a�/�q� ���0z��X��b��zZ���f�ϼ��,8'�KZࠐ���7��Q�'tL@5����*a��C�%BJ����O��۷�������������/���#.8��K;��#Gas����z6���6�o�[!�-ַ��ч>"N�h���|�e���hZu8
��5�GE��S�c�7��b�t���{����t�����r���l:+�� ��W�#dL� =�0�s�M~��}g���c��L�}�	o@A�@3i@e�rOP_!:�a��h%�w�� u���hp���xZ�{O)����ԘQ#野h��5��h�3�5HM�2`\�`@���ԯ���@�c ʹ�?�[�
���L7 '���[����{l�:QJ)f� Ť։�Z����f���Xn �^����cGC�+�|4���KT�꠹4I���	 �Le�r"��*GB4&!�����s��l������O�1R��T2�H�����%�HA��5S��4�� ��,�"�r�n���8�/w�:���$+�`>�t�s��П��j��C�� c�d!8Y�kYh;[����S�J�
;�H�I�u�����7y�@[�5�I�ţ�)����}������[E��/���gl(����;C��I1 �n:��x�
�>EW;y�[���X�G[���v��Yv���S��X?o�N8��< E�CjA�RE��0c�b�L��g�N=��{��Z�t��(�� L0cNb-'}��X�u��y	�*!��R=*�~|y���o<y|��%%�)b�|��a�j�4)����XKL�|RT�\��"}�oF�����9��'�H:p�0)(M��Viy�H�e����o�:����_��������f�}��\��r5�.��^�qB��Q�
��5�TB�%G���/��E|�1S������#:�5����z�5U����['`Cx�z:'�����r�3��K�XYLU����2_�)`y�X8��c6��n}{s���i^��r�a(�����x�Wi:���
'g���|kp���$MX.���·����%�,�[*'_a���������	<����Ï����'���?�w:Rw��B�Z(��L!��Xޯ�Upc�-����=eJ ���y�D��)��L������qèN7
uLn\�*8-�]��	�ƊT��L#�� ��`������2��x�pM��k�h���$k�Z�����ԁ���a���f
Z��&|3o�mr���� n���屢l��#���t��Ʊ�l��o6����w�f��N��KE)�x�1�q}d�ٜ	9mv�B:�Ƃ쫴�E�1���@�� ���Ǫ�(,�{�=��#�W�����30R���\��9@�1���N���:ϩ����
�b��p�W����9L��m�s���`�l2�ud�����\1cO1'�`�~�H�$h'�I�Z}{¦�39f�����(�X��h鋘|;��1m�9'&R���h��M� �h	s�`�j#��S�Rڍ�d2цt(�mT��1,Qs��go�	f��c>�4<%E7NJ�;/_߀5>��R���:˘PDK(�}�q3������c�`�V�e��������1a�,��f_L'����a��=OF�G�
5P0{\e܀�O�Z������;;s�犪��cÚD#'�du�H��H�j�݁J�qft�"Wh&�fh���O�����Gu��=�i�4���!�??���9��ѥqɚ�j&�I��6�gۓ{ɰS�*�>HTM��2&��g1���*"0M���|�D�$i��xy|=|�2����w���7P�x�XO�����M#n(	F�CXcE�ͤEcP�u3���|7o�`��ި�j��1s����w5���R�bt�AW�|o��|�)��]��qe�FGzD��)�~QĂ�?����x���kQ�\�������D�N�0��	�|��ɽW-4O6���g�O���*�� 'cp��.��=���lUӋ���T�؜��_���L��7��(��uڶUQ��?�\�W�U�4�h��i�t��ߎ��3גeD�0��9B��/�s���o��H�J�41=��9��bL0�w�ӛ��>c��-Y,��\�e0�3�?�2z2q��[�_�2 |,�	i���m�NR 1k�E���IB�$1�W��<����������1Z���+8��F��������L�5�����
B���XI|�hp�56k0�u2�8��/0��cy�/����GT�#e�]���7��^���+E'����޺��a��<��\��§���d��I&�d�̗��r�����T#�H�S1�_�h��Sm�c�Ĉ�>f�2������n��uT�h�� ŴpDvt���|�]�Z����7�R:[��r7m���Ű��#��J�!@���ۿ��( щ�b�y=��j=�DB�]Cp���Ȼ�մv�ULF�%�y.����b�>����O�P&��_�=��2�>|���{��	�$�	�p�v���;&'ՒS�*��8�̋%������+k����'82y����~
�:W    b8��~U�=A�`�e�mY��j׏�&��:g|�h}9~�@��w�����f�v�o���PBa���h`r����=��0ވ���/�ϯ��|�@5�\��[��{�]CP�I�7{,�'j��E˪���<}���\TLm*��=(b��9�(�rZ�\�6<Xu�@�^�Q�e�)�Y��8	����c��$$�`ήn\X��]{}xz=Ny=��3��5�[�0ELR$*�1����rY�7#��Q~�Y�.��)� D-��x8�����*@ 73�X�$<���nT�x�]�3[qf��@�����q��/K���ͻl�g�	�#���"�1� ��o�E�~�X̖�H�<]v&f�L�7���!d ?M���<�[�5ت1��Ϋ����j����dvy[��.z��V�I��c&�-���|����VFـ��R��D'ECa�X`�~��W�ƨ cL}Z&�v�wɊƓC�La��b��'=9��)�������v�Y�f�ͬ� �J(0؞7l7b��-땳I�sn�t���W��6\��so�l��=��eƶ���?S4�6p�,��)O��7y8�	A�����������xA��4�yLq1Z|��x�ia�TaV�����i�����2��!����pz-U����V��ny����nl�������L f��h��sob�Y
	&���V�� ���_.:?&�=��^�������ǜI��A,bϑ`�i/
�r�)���hkLu&��V3���]Zu�/}|'�&��;��F��Ee���	�Q"�� �/�XDT.�dB�%Cd�ab4,x�0kgs]ܖ��pGN��I���#�'��KJ�_�d�O ΰaVP�4�=5�1������@�e�d{P���HBO?�ͺ�T�@Spg�S����4�2R�i��c)�B�YL̋��E��r������+��24�w�~�� �OO�R�������[`[$F ���d�*
�0x$ ���o�|�<011��!&�MB�I)F��S:�~:oqb��\l�.���c��&��[A��Ҵ|�s���o��|�
;�k	K��B� ܓ�U�vY�%�1F4�q??�^W�}�)3�	����ľ[�E3VV�|���%g�(���L�2����!z��9�fZ�<�J�c"5-�.r�G��ӕ���+��A(
@�sj�U��|(�!����E3p� j�S�r!�6�E�t�1mΉ�]\�����v��0S������1�ږC��K�9�V�[��T��>��g=�#je���U���
�_��o�v$��6�0��n6&VK�^�8�a�\"�=��]��tn�Tw &| l:Ϩ��2-h7Rmc^�-��b7����J/u�L����˔�`��lK1 �T�� �6�R�ri>-v��B���M����Hޙ˖1��?&�1�ږB��*�����έN:��v�XJc���ƚ!�a��Ӷ���,pAY=���1gM�',j�F6��\%"�\v! �:0�6&R�)6ڭ��~1�O��n��uV"|����jA�CGӛI7��>'R�c3�mtW��8�C��Zh�O{���liT�0��>v�bo��i�ձ�j[���~�Ci��2akN?Am�-��Rϰ�\��|��4���)ֶ;��oJ�����;�$t�����=H�=���L�Y2����$��V� d�o�@WMA��\�>L�T�#p�Ix1�q�S�ķ;bIh�%SWl���U~�?akd�J҅#��S��(�k���t�1�c˗�I�g���>���a%^D�$8	���� q�I'��"	����y;/���������R�����-�
=�4v��G!J��iw�"����b������@�	�����`�;����}���_^Ư�_�~��ߎ����EOL��SlQ�����X�d��eJ�«\�y>=\�~�>����Ͻ�s�<�r��\�'�ɲ�9���>F�1l}�����o��_>w��-I3T�J�J�iT�4-g�~g�t݌n�ߍ �׸�R�M�����̸J��L"��@r����.*���#������ͽ�_T�*�<<��D��XL����i2Z���*̍���/Ban_��\>�`
C�#����.� W��[��3�p~u
)H���vTR`��XjW����>Bh�)�D�Tp�:fc�a�ۢ,07��>L�������nId]��n�]a/%�	8����D����4&IĤK8ױ�l��:Q��3Qu��
rP��P�Z����&�Lܻ(��E��qy�J��������Z9��gv����^&VW��
k%����v	+Ic*�4~�%�b�No/��&�S��u�o�OQ�hr�4�Q�HcF�,����U/4��_���s|�K�L���%`ie@+R�[4�(O����٦�lmȐ�g\H�%G�G��2��S���N�b֦-k㎯]Q�D�x��G{�ϯPvD�z��q�����b7��,M��7�4�l�r6Pv�5�]Y�2�?V2�2+(�M�Ev��ޙ
���`��h�ƴeclC
�Q�!�'26U��8O��'y[D`�Xͦ�����e5'O>�EL�4h|��7g��*�<<�%8F�����y�m��P"
��f41�Җ|W�n�_{�� lcT�PG�~:�d���\A�`��fM��B�]1>	֣��֊&^��I�4fc�X�;פ:^bɵ&d�s��p'�����#�3Hq�ba��V���	�=7[ݮ���Ŝ��6���
��$z$[Р֮؄=�	[��ُ��V��[6�]0[q �h3Cpm_�����V]r�h��6�x�z �S�&�T��Ȱ�Y0������r6�����]~w�71 qUs���T�ֳ��c/~�*�w|hd����5yY�B�ΰn���z�>ػ(���1b�d-aV{��%;ksw��JB��j��>�������%8�46�q�b(Nv���w����Z�e>�o��,ص��Y.J8)d�f���緟���N���)a��B�<e2`q��*#�7��|Կ@8�x�l�e�c��HI/��2�`}G+���8U�閅�J������͐����
��:�����rQ��d����4ko� S�>��;��ޕe1���Xݠ�;�ie���/�.�ϗ��mO3�ԧ�N"�q�y����L���9.R���x�FckK%׋���̲��]����7���U�D@u�ȟH��:fM��>~;��qU���f��#e2_x���؝��vZ1)v��{���1𴘙?h�U�C۟4��������,��w�!f$��`yo�����/:k,�e��j�>ng�c�-����6���_�b�[���W8w�۽�ڮ�p�f��qӷ��D� {�ǌ��(���(�V��D=\D��=��OZ;+��%n\�"us$�tկP�N!q棶p�B�)��&Υ=8'F:�+��y�	.�z�;?�����bd�	)�Tf=�؊�{���"I)����@G7���&4y�G�0�X}.�~b��-?t��@XF;5 1��`8eY����w�t�F�U�Zw:���uLpe�����U�	��n6� �d���z����L8�;��}���6R%
ugt�.�%L1���q�z�
 5K/5��C���p��$K��lxL���ɻ�cx��|_��6tL9'ڹO��m��GN���6^�ᦲ��6���S�y̚�e�x��7'	ܶ�h�<=��Ȓ�P��Ȓ��p,�Lz�5 ��C	_ø^�V�1`6E�����|����y��� ���tAm1��`ҥ�K_��uz�	��:��{���U�K5�q/EL�"
G�}�>w]��C q�U5�vA���Į{�[�n���F�� 7��KEo�A��Ώ�MB�(�фã�����9[4��Q�n3�F_��*n�j	K0��}y���ժ�?�Xu�#�ً�|\�&��0���<��ر�+�M���ulJ�Z}�    ����b ����o}���?�_^cG��p�'�+�:�fZ��,D8�M�>ڙ�rEK�<���h��p��b���e��ɗw��}��.T��	�Zp�^77!\L﶑�n��������x������eU(|�4H�Bm~����Mc���t=�2�s#�=7�}կS%�+p�p�! ���������ٳ.À�,`��#��x����\[��(׆���8��L�®Čb� .c1�H��8R�3�wxk�j���wUM�U�&MI�9��]X��ibp'F�i]U'^�#��8�/������a|��U��ike����uE~��c0p�qCN��_Lp��Lm���)��+��X��5�˸G�p~ڤ��t�e����B����AF��SWu��k��s������K]�/=cD�Y��\�1�J#��4��a����rt{xv��p�Y`-���p�b}��w��(���w36��.�Wu���j=�טd�n\����//�y�DAX-S�iG	� �������>�6�,������Wl6 %W�:�syN����)lֵ�)"q�L.��AĖ>XR��/f�B���B�	6��'��Cr-wѹ-��.n	z8U�l��ef8<�*^YF��M��� ���+�{��B�ψ���`9ͶJ�����"[�VE�]�;����ì(7�1�خ��q���j����s��%1�Q#�5��r]����L�q(xIX[Ck�+ud�&���Z�a�n̕*Nd�}�%�x��v����3p��+�<-1�3�x��>l�CL �k��y5��t�2U��m���B�O o\��|9�L�+8�>6�|-x=�AڇX&�(kp�w .l��F�n�M��+X�@��P�y�@\0ƍ���|s���g���f�_��l�PJ������nd��f��4:������|�����]_\�=��?��.�T�6�w��`�^u�֟�؜��&�J�Ó�����8@����1��J�*��)���9/Xo���׸�w��VpZ�
�M������q)�����H��;�b� \Ʈ3����'�('13�[o��s����*Q����~ª���:�e�ǐܭ��֨��fp0Z��nd���.�E����s����G�婪v��i�-���]�A�ާ�D�G`xY��XK���I�G�RWE�ל���q�������~W�d����"�*e� �K�o'����`	f뫔����x�c3��ׯU�+���ѻ�cE�V�c.��5�m@"��X��B�4j� Rnn'����#&��iEG)�X5̀�p;S�u�@� Gr�����c}��v���H�c���8#�(pê�6��u�TA���,�d��ZEQ��8R���6ò�]5��k�y�bA�8�a���Z��7e��4��r���vu�L|�.z���)���x�-G�rr��w�Z�0�,�L�#�����kt��eEH�=`ܸTY_VP�c"6�LJ,ON|;-��]qn!ZI�iyGrs�����G5>RO,����C�R0e	IA�1�r&.+Tm����3.\[�UR�㟣P�ٚ������T��i��r�2	����/���s��s5���-�G�0o���F�O�R#�
��5�$ZL�X�zX
7��5:R�� j��	��!�	/�Apq�a,iY�a!�?�C��j�(�#Cz�]G�u&�d���*�]&T�rr�t�������t�ⵝ�� u�t@3h�[g��6�&���8�������n�_[��ؒa�V�̸OK�ud�Pǹ��I�ޭS�b�:=�D�0�$=
��E������D7$v�֘(��9�b����X�b����v����K��Rw�	�
n�/gi�F�#G;r���>=�|��ʈ���Ӿ@f�"N�C�Lp�:ٖ�B��f�A#ܐ)��82X��v��c�2�D�0���O¤m6n	���͖n���$�f1d���`QΪ�nq}q^KK�"��N��a��e�6�#��"f�o��G��rd�.g�����w��b�e�ธֆWOpD܇u�!s�,v�c*�-�)�TUK[��,ι9|��W�?>UY.�)k*A�E^����SZ�q-�H&S�����`y������m�,��h|�Ȃ�����[)�KOd�1�M�Z�rƋrd�(N���Ý��Q�i%��%�a�!BQ�3�y"���oÑ�6�+&����6Z5Ŷ�F�KP�J�F�1��x�v��C�{?��4�ʛI��0C�B;�� e=�;2����:{��F�p�o����@���/��g�W���wU��Ԅ�+��3�YL�����x����^�r��q�O��A�7�S�SϞ��8�4��x��c�kʎ��\���\ u��`Q�7S�	�/[�#�Cg��7�M���\Ĩ9�Ju�{��e��n���7��`�͉��������!���).���t�!��É�q��$���݂U6�r���:��G����3����,x8x1g�j�%޸%A�����4	;�.2�gJ��	���.&.Fz��P����_��Yʕ\b�|H)�=�$ڇ�$�;/�Q��ጋ�s�θ��jpe$��jQM!���h
�i�[tlzq]ӹ�- �V)�iq[�L�z��}h.,������1l=���^��7ר`s��l��Z�K�1����,QS�j̠�~���T_�� \(~$#C.t�0#�T�Ҫ�5���ͤ�2Qp��U��F�k��1 M����T���`%GL�[y��`�eF�Q����55�J;r�B�\���\��O�*����S���_���Ui�]檩�ݝ~�����2�A�!��]�1�N�u���r�c�-"B/��EK8n��p����!�x'�ɐh�ML�X jb�-A���]0yc\�$qYə(O�fy��\`]p�@���4Y��7���p�L+k�� �i������Y��^2�y�z����u4*XG�ȗ�9�ϋ�[� �� ё�F�|���l"�OI�����]
I�[_T��e���1���18p�m��9���G.�%�Ei��!&T�E�t�bWԋU�	q[b  �p�C��0(y����)��� �v#^
���0��rq��<_�Q8K\q	�'��~7�5P��o�g/Du-��C�P0��������(׫߁�i��'�ؠ��q/k8���Eý�K���&T2��J�I���H�ޏ����Iީx틢�eQ��Ӭ�53����K�q����� ������
`�_�R�rY�j5,U���=���#�Zɬ�c�Z��%.*X��NW��k��8���Y=��G�h�]]`�Wh���>t[3ݧީx1�
���ߴM1�l:����C��5؛��_[+m�%�
"�`���ђ>�]��&fT�xi�
��L\���X�F�I�i�*d9������������V?B!����`?�t_�5w\����
�����ߞ/pȅ�+�j.��"�W�[��7�u�~=<�����`�YLN,Xҽ�-���l�Wokn��=�^��Wcz�"�H�e�e�*x�K��xي
��`������p<W��s�w;-���_H�L�Z����DI\K�k�P�����tr�/~�� v��6��X���M,�χ�?��!��o�n=��|`#�yL]�z�㋜85^8yr��ϑ0���'PP��Ԟ!|1���qm7.3kۈ ���O�?s�d�4f����T�pE��Rwl=���ѝ��j�v��c6<V�؇�M?�����\���7��p#�d^`���_��$.$J�e�&*�-W0%h�o�gxw��Q���}}�M��2����9g��~�X-��
4�_?��牖Ş����e-D�#�8 �{� b�|E�W��3�װiCx}9f�n{pZFp��ˉv�i�v"D*ݐ�k`���b|�9�Sb�p��pc*�M5aT��>�3�F֠�X�Lف�kt1�Up�d��z�&�p�sg����|�&Ƈ)s� u  ��)qw
!1C��ϸ�S�>�S��}��SW�讥s�[w|.'��{�@]�~S�
�D%�W���f�OgX�w�{�/�N�d1��ǔ��X"9�_`�[�eE[V����Ęc����'�;~�&�Vi����G�lW���rl3��6�Ԥ��**د���8�z� ��$c+y������w�b�/Ov�4H1+����D
7ޯ���*��׷�ǟ�<|�!��.-p�N��򫹦�O��i���>5��`v�;�T�N�f�킥*[�:E'�/GON��V��p��'�9��@�v����*з�Π���bg�q����ނM*�%nS�^#q�]���D��H���)&��)�أ�Ijpu@c�V�,���㏗���};<�C�P=�Ҹ��u�����{�j�
��\)lW9�G�y��/3�R��AA͌��(q�6t��Tx��8��Ͽ�[V�JY��`�&S$��-�V��K����&hl�v�DS����(�#��F^�/�t�z���'*Xr������'�^�l�+9�zr�����5�Fh-��
SLs"��j/"�x}r��>�*Y��i#�}��0$���wo�A0n���1j������_ٻw���ٹ      �   &   x�3�420��52��J�I��L���425 �=... |�%      �   6   x�3��HMLQ0�2�0L�L!S.CN�Ĥ��"�Ģ�T.#N����=... }�      �     x���_O�6ş�O�{5���y@]
,��ҧ��t�.1 
���28�6K)g=
?��{���jq�e�a����y�����W�\�����{˓���l�����z�-���zS���s�����N���T��fZ��<X]o~�][��}�Y?ԏ���w���vvx�y�ic��'j�g�z�\���������Pq��×��������J�����Q����n����V�p�Q+�7����(wA{�J&��P��w�n6�
��͔#Pc�)j�\����ly�l�[`��w|w�y��üy��#��0J��vu��\o?���[b�C�R�!�qR��'�����c ��(�����c����3`����%����a�T�5i��:1`6S�@*f+x�Q�J�
��@N�C c%��Ɛ-��}Z�G����ŧ���m W����~�<�o�
T�Vy'nIoW�H�]���@3C����t�3�a?�6W8���3 ac����M� 4����N��4���JZƁ~I���_���˔Zв,��z�=��]XoǮhe�ޖ������IC¥G���2�ك6+��+%�KY�Ǭ	f�q��b��ɹ�)=Mnr�{���I��۔��k�Ba�p�y������-�:9lbԅ}:�kGPT�H]?�eߐh&4��t�@�{I��2�)l!���:$��*��C�o�ӯa��d��CQ7��S�H��u���|*� �<T�V�E[2t�@)��l@�1������Gh�4~�	ԚK�D�y��Y8f1��"uj�@g�����O߮��R�by�92 M��g2���ܮԁ��o����@�.�!���A����G�V<���y#ym*��̄�89f�Ġ��5��3p��anf�#R�M�i=s�\����`�<n�[XDw��{'i����%�1e�x3���je��J9��%(S5|�7����Z�`�bĮl)��7���j�u��P��c�2y#R�/g�)쑃���*?�����i���l�ǂt�I�݃�n��+%�cp��7��M+rj��������N���:��Cu򞅌���x)|� �<�Œ���,��aO��5����K����L9϶�k6�"�����ظ脃(2^�������4R�?I;���Y
`��Z򢰅c�e�:R��I��}�Y:Q0��
E�Iuzؤ_���b�g��"�M9�V�H�K�������l�!������\�A+��6�����E�Y����vvv���"      �      x������ � �      �   �  x����j�F���O�PS�,!O������Sխ�H#�р��|S���"�֙��B@0�HRShT��R/��>���@�	.o���|{�����������^�%^���B���f��4�ƒ�D������/+bF%�A� g\A&�rSJ�
����Z43l	�l�	�amh)�Z)?�z�&���P�CUh* ,�1�3f.�:��|Em\�TU4�D�v�D� ��5���J�I�0�3�5�pB��ɠZ�{��������m���.����IN����_x������C�m�M9�Y�r�9����G�3�3q���NTs��$���Mk�Lѳ3u�C�y�ѣF�|�1�'u�@�c�jRy2�.
�C&��hE���Ӻ�}� J�<[���.,&O��5tO�"z��A�4��/���qc�D؀s"7�L���@�:<�n"u*E�����w"�x�z�m��.O!;�����X�;�!f�Sɢ�B�D�H��Ҫ�e&���I�n�'�^A�ly��%�S%
*>�m�D�f�N�rq�\��f�e��th����䝗X�g�7��.&�����y�Z}ŝ�"��>��k@q��M�aGnl>p�zb|����c�2}5������+�E����J��瞭����<��]�qY�*���U�����P��3 j^4�]�wL?��F�Re�jO�t\kxc�H>���mQ}�w�ekD�+xq:�\ ���4N
6�	�0�5(H?v�GG)�"��K�%���Q\�F徾�}���n��iIR��k�{���+��&"E�ă����0��7h��ogﮟ)^8��D�7eQ�9�}��C�6H��g� }�!��e�c`>O��cJu�E�3~�����N�y{��b9�7e�%�(��wD�E�%a1���mŌ2�u�̱�E���
ؙ(W��Cdb���m�ŧ��'k�-����>��.      �   z  x����n�6ǯ������M�.E�E� ݵ�(z$�E�E�m����C�fF�&6%'3[�����|�IaJ�/�W�~�C�| AF�!Qw��W��ɢu?���B����� ���A�}������Eأu�x���_�_�4π�C���������Ag-�!�_�0���χ��߾���㧿�?��ЃD"��S���h�L���>�@�&)H�|�~�MrC�`��c 1�� �^��C
)����մ:`� Ctoo�Oգ;�>��r�� j�ilF������u�Q[ C�?X�Rr;������}<�2v d~g�}���@�������ᡇ��} �r�-���`�Q�IX�R\F��q�m~�����!���(:�Ư���yV$��O�V�@��7�����g7�p ��p���>��2�U!A	�`!!p(H�{yw����>�IRv�'�g8��$�t����:��$�*�/m(S�D��?���>�(��s��g8�Z��*��]����pM(�͉
��W�*�@�.�g�\K[�:AI�.1�PrH�f�>�(��5��B�s�F��x�$�vBEG'�e+<E�w->�G�����I�cOv�'�U%��|F�SC��>JcO��[s�[�����x��S"=��v/"k�S備�H��XDca-�I�K�x���0��K�c �<�� �$*�IX�_]�h��,�A�����}ސdjPd-��.zp�B����B�G �0̩��<䛪U��d�^�
���UP��2�g��#�A�����IYv�2�R"9�5V��4w�DN F�����k
���%�f�Q�寍�(;Sa�9A���`�#��۱`��P�܂�A*�� vE�[���ҹr�6w�&q6-P��
�Ba��H!����ò�3�R����9|c)a��js��g��e�Q�mPPc~L K]��/ ����E�2������5�_ O0�K0���nN���,+��Ǜ	����k��.��!������}XNI��}>���J�8/ڙG��R�ޠˡ�w��鐭�M�O��p>Z�h��Cb.Y!���r1: ��Y�%[ʦq�ﾞ�TH�Ң��|��	|vQ�P�Ke�7� �v<e�e-���Y[�Y�� ��r�v!�BI�l��I��W�g��O���֮���y�|.�'v�����+�1��GI�d��8Y�|:�%��r��I˅������)�a^y��#��}�:rd*�"_6r�سU���s"e� �����}�'��忔�������k%��Qy��3)nH[��ݧ����޻+���;.(�,:�3�X�Ob��]�O��qDOS��Z�cm���38��\?	Fn2>����[�ǚCp���ͤ��@{��'�V�y��V��Vs��*�\9��h]�x�p�g�����LS�,�h�����8�~�Eͅ��v�G+!q�b	ϱBx�8N�x�+���;��������x����I6߽������Ӗ�=ᬉ%&d�r�������f�f�AD�˻+,�ax˕j�6�p.����Y��V2w�PJP,��'iH\�DwϘ�C=�_�̟
��s�̡�ZgZA\����-�"zC�P��t�������F���W�i��-�����G_�~�C]jJ��\�ԧ�5e<SF_��RF�P�J+˩�cgJ�66}��s�Q�J�^�%�=�I]x��"���+9^ 퐷n��V�r�dכ�Ip�����Fށ\@��ǂ͖g��l�L�T�����C��ؚ-�DS%ZQ��yd��$o�b,gnA�+zA��U�M�6�	��Y~Ҹă�?b��x�pOE*gn�[� �wRꌃ�x�b"Q�KDE���<R�qt�iV������i�
���.�ЭT�]J}��x��k1s��Z�.�S}% Mq��R�'FEFQ���ӑi����-x�j��#\m��}�.eGEF���P���JL��̍�k�v�?8H��Q(�v���
�rW���m�����q]9����^O� ���!��������|�x^=��˓�O������b)�k����V�fn��Z��u����t(�.�kP֚N�\���<X����5��,"�h)X~^�x�����      �   �  x����n�@���wqأw�B�)j1j��7�J���w�ޱ=��$�ӿ���y~<�<�����%��'�1;�ͧ#��K��ٟ*�̃?n�"�E���M����s�%�dg ��pQ� �h��Z� ����(��T6-��d����Ij���pb��$���=Zd%�|+_�8���ڄ���k�$z��.)���Y6� ����5�OV�"h *lg7�$�Ʃ1�tw�ZTh�"j��:w�Y��h��  `^�ܨ0j�QFm3��Q�z�Uc�5Et��(�h�8Q��yu�5^��Oۢ��A,�}���DV�06#SP��p�8]`sT;[��E�1?�X�+��̵�X��O"\'���)R%VS�Q�T5K<�r��"Ԑ��@���T�SZz�k=�i+7D�7L��S��V������x8�>7��Jp!�N�����[�k��E��a�s��HGt&�k�����ʲ��������q,XzR���R��Ueˍ.�g��6u��4z�{"��(sX�6�mk��I�Rע���#�C�k����V�$G,�fM*-���n��U钹ih�R(7��>�J#]G�s�R4�d��+�r#Yӣ,b��wq�ZĦ�      �   i   x�U�1�0���á1�g,���H���p��� qC,��X8�#�z��dKRI�$AR��H�$ �I��L2�H��y����r?c���ʄD'Sz�ѻ����9�      �   �   x����
�0��s����I۵=��@elz��*��W)XX'4���{�Je=,�1�<M$���q{ޡk�4���ξ2N *�z$�>gX�sæ����J�eTѐ�aE�a��é,�FC���2\4�����h������{I��v�=�}p��١������.5t0,�g�b�W!Fh��]��mC-�f)W���.��>��H      �   �   x�u�1
1E��^`���fLzO�Ղ�����GDa���̃�߯Z�/Z�˭�R�����:I�ZJY����-��$�Oj�����=9��{?�?Sֶ�@���A�#�1)F
���uuja,�ڄ���6j�&X@�	��s���M-�M,�	�P�7���-��)��|,0߀����b>�;U�gl����.Ղ|t��cK��^�A�J-�|�Yx��9���-�      �   �   x����
�`�����������$�J�мD��,���I'I!:��c�a$1	"FD�(�� ���!*�A6˃�	��q��u��&�Iތ�O���%�i��M��չ6x��l����kcː���E�	,�����MU�W��l��K��ncO�~�u:�u�����7�M@��a/P�}i      �   �   x���ˊ�@Eו����[I&]�	4C��E�4�!��?�0�ѵ�[��Uah*L���~���p:���vj� ̬��?�T g��ml$�r�_���\��~|����SF
�@YRC��Ӕ\Ś[:�r�v�&��'��Y� ~
F��ۥ;ޯ�ˏ�_�rS��˪45�Y)���!K����P�      �   &	  x�]�Yn�:���Ud}ak��HG�Ek2(�������*���g�bMTYU�,n��kx���T�f�1.v�ݔPk�v��e�������e{a{1�]ݘ嫙�>n~X���D�u�7�f�� ���I*�9�+dPC�ٮ�IC��VYH��܇�e}���a�5��<B�g��4��ڣ}y;�ۜ��̛���ȣ
���P;*q�C�6&T�Wp+�Hmv�Is�c��v3G��4Ƞ��&-O���}�+�*/"g�^�\A��&�0�q{x�(͓��֨xz��ڬn����l!޲�7��<˭���F��7�A�A�^�]�j�AWx�aﺩ�i}4��� �r	T8�=�2�a�aM2��=�7��y8i�s�>��m:Ó-�i��M�XT������u��Gg	+�]J@ԅ_z��`_��� ����� �8�Gv3�h��FX�]�1e8��ˋ��[���2+G�/$#��	��=�'��!5�$�*��6��R��󺗂��	�ҟi�z>�V5P�QԙŎ���� �XF�(�Tz��ET, �?#��{�����5��	r�����ͪ �G��W9´Ct�h,�i�y@��ܭ ��� e��#�v�N���!7�$���.*�0̂|�.YqE{MX�{�;X��O&��C����B ��mW5En���&�ê�o܈���ecrI2����z�k5(,�'�a	��>e	�2<�꒶&d$� ���&��̧���2���co�v�n 7��%pe� ���w�����J$�$��<�Hp��j�F�Z#(�܀����w����0
%"�e�;\>L8���=���IP*_ی[��(��9�\"���H\�zp��9����0�mP3wT���jBo�kʍT�)�	�w,��ܚ��_�N�r�B��U3D/>d�ZT�1��{*���Eǌ��Dg¤#N'��ʼ�kC���_��g�����yfB����
%�i�'Y�K"���| S�ɩ�o���=�����_��)��ls,qJnfFaޠ���^-���P��"��E�|��B�����GQ���ڏ�(�a���3'ݭ��������m��_�P}��ym&�^���[���45�v�9�[v�����R2LL)�T�eI���-�6���%��Gۚ���}\LQ�ۑ�$�::�#B�}�a��@���d�G��)r%�����Ŗi9���
5�S��n���bEP���iUY+u�Wy�� �#���	���0��v3��O��S�Z��1����x�5QMI{�k������m�D����nD��%-��3FoI�>p����9��J�s�T�i2U`�AZsI**#5ZQ��0�Ìv����Fv,�܄ĈR�O!UZ@��^0�v	��V��|K-����l����X�6����c����担��~�1�\e�w��>F�Bh��HK�HS�"͙����9����܈G#EBQe�1�+���r��� �.�McNn%�&���;_��E�8�t�2l�>����-�vRr�OUC5�a���<*�#>�l#�B͓<4]b5�1Jߩ =�&�n�M�hx�KD�os��t�X�s`O���T��B�&ñnGR�Yc���=�۷<�BxYu���ۙ�r����xB�V���؞�gV��#�=�\_X�#��a�K2�ɛ�K�6��L޹F��fe�k���U�4�1�4���o�%h�N
���>�Y�H�S*M�|�q
��D��;7��2���B�t�l$���a�G
f��k���Ť��j|��F���!�'L��f�|�C�q�8`�� D����ȕ�=ҷSP���e�1ҹZ}�)���)w	i�� �G@�G�	��9�ɖ�	P��*F^�6��h��U+��P Y�a� �Hc��#>C!���(���<�c�D�b��=�"y7�=�Дm�jӣ@q�'�4R��{��_�?Z�D�;�V��Z ��;�<��n���{A�|���XdFԜ�PS�)�]�	��;�y^�v ߡziBUR��r�����Ө��5�J��,vl[�yD��{��<
�����*����J��TN��=�t�~`+���D��A��+A�����Q���g��@���yX�%�8����{����Ǵ��9>�PJ�v��gX�.F���N�����!�jE��2��	J�?�|	UYzsycV�`S�S�4}�]Pg���^o�Pg9DCF(��k���w�+�s<)�)C��~x�Y���v:J"k{�����������      �   �   x�-�K��0D��0#~	�,:�@�Ѩ���9�����r��h�ӻhZ##��y��a:�/2u�8#z�^F���X5���u�Ū��M��6�8?i��+L#3V�BK���3�s���H\i,K�Ww�zē9���P��$u[�`K	�2݁H��nL��TK�{�����Ӗ.�V���9��'E��+ъ����Nc;��}�M\�s�Ah����x;r�����ϼ��Z�]�G7r&uߏ��)����[�      �      x�t�۲�:�5z�~�y�}�*&g��
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
&%���w1c�='�an���~# 3�Nv-�� �T�]`��>jÃZK��e��mV�N��BT�`����s�x���{���X��������&2x��*2�)�6�-�a��g����A!=� �l~�|�,f�i�A�)}�T�Ђ�����"�;�5����\^   �^�@���Q"�Q�3��	R��A�Jk&�R��cT�ń8��i��!��wF���6�q�\��"}n��s�5���/.�|=�Y#$��LW��2��N]��wwI��r�|n�S�sk�z�n1�Y��^�D����a��\����3�Ξ��ik�����_N�0s���[�K��y�Ї��r�}�y\1<��(G���&-�`�sȐ1�3�g������%1$ϘsJ���v�B!���_}���9hJ�Ϗ����Q��l      �      x�ܽ�vǑ.<���s*g�%/�Qb���-�K����,�&	-���o�Gd��QY@���&x����% _dT旑q�����څ�]�r��;�)g������7_�����_�r�����ۯ������x������w�_%�\G�a|�g��Ӈ���77W��>^�r���M����� _8z��9��C�������S�O�]��s�!�h���q����w�7W��|xw������F��r !~�������Oo�����J�����C��O_�W����q����߳�o���J~��C��8u�`��EI/��\ȉ�kK5����hm��dߥ̐|#H�,&�@�|� �́�~���b�f˄�]Ǒ����_�Lx�#�.�W/���������r�U��ƻ_P�r�(���-p~��W���\C�`��銽��۷!p��rKʆ�C[�d���o������)��v��,0�p���)5�\�k`���!7��I��b��[Q�����F��.#�kly���:��U�x�[r?@1x1c
M���;L��aJX�;FS[��8��$��D��t��;`n�e���aᬶ�
� s�gN���ۮxLZQ������]S�H˻+׿YC�ܔ;�-��Ϣj��3�!p0��Ո(���7�������d��K:�H�V��'����\S`rX�Z1��\M�����~o���0�/(�"�a��s|-��J;$��m+�&̨FO 1���9`���©�!���5,0+U��m��瀣������߾�}�۫_�����_�v��w����뛛�����7��������>'��w��7Wn��G�'f�/f1F�����W��1w윏�����ݧ���|\u�٪.vVj��-0xnz�����]����u�\z�����	����ݽ	VHs�cOq#��ik`�)rz6����5B ׏�l��{�^�T����l�P)+��7��k`�F��s��h'Y!Q�r��>@洓0f=X��z�p�,�8�
7�+���2I���9,�7�����K��G��{��?7c7y+~������ʏ����͛��<�΅7��c�c�0���^�� ��/����	D�+'�	j����`����9����X�b@�M��<�[��26圐j`Y1{$?:��y���^��՟��<������h���r��B�ϳT7)������%�GF�GF��G����L�[�PLS�K�#6s��%�OH~58��c�D4"���]��z��tC50p�|�<����~���퓚y]~d�>
���T����ވ�\���Q����VDPϜ��5B�!�'�G���_C��wK����.��4P�%�!���49
z.�f�\��������޼�l����F+�\�������3vY���6�4�f��Ruc�b�-�,oj�u��ZrR�dY?xb�ns��[2`1'2��P�2� ˹r^L�4�p�}���7���E����;y����ʟ�C���N)�3ż:cpz�Y2C�Zu�Rƶ���&� �.j����^Y�x��Ǐ����:�Iȡ��� ��/k�T��rS�S����cƭ��9`�������t#U��}�FZ9)�?}�( �O��?��ݷ������Om�	H�Q2��)K�w�M��,��x@r.��&�6�]����n&���ي����oL���Y��Y.pr�=w�E+:��-���@N5���Ɓ�g��lEg��!�1;rFg�YdJ�����g�i�ٻ I-� �}S����E��f.��ԤW7���o��������/w��_���;��w�Zh������r��Jo/,&{��s�CꝽ4[SL������<�f/L�[���t[��A�5�����P�ӑ�Uj	�(���^ԇ���Ɇ�y4xg/���e�L��YNg��p�s@n�:6j����,g�Q��{{��/�9�9����~�{��۫��|���۷r���޺���l�r5��꛷���#��-����%��� ���J]��G��Jy����[y{�h�$w�_ž\���Oi��F�4w3��ZY��[dYb���ww>yo/�W]��ɷ�v�"T�K�(4X�e���l1t���~��P�X8t^��m����"u+���7[?n�k�ya�8>�Q�d`j���jd1�A�y�=n�oU��Ȗ���{��{+�
ћ\�m������$|�]�o�X�3b��i`K`����ō��-p�����v�a����_}w���<�|�����Ȼ?��w�ȿ�ꏯ��������ϋl�a)��G�M�b	V�C)���Kc�Us��Ǐ�V
�l*r�<��r��
BK���,4�(��2[���h7sϻ����&�IB�l'EK��:I�ܾy���|������W�4�Q�r��G�[`�[�#��� �o���������0�?�����/o��n��?]`�\Oé��~9�ϊ�XsMe�Wq�|�����,%���E.=K�-�s�R3y׺�~Z�������E�:ɴAS����g�	��,�s	�s5�F�ډ�r�f��˞�:���iwk�5��1??�OSd9��)��|�=�����/_}s�V3�u�~���ݾ����_���7�?�E~��܉�A��d_j+r�y�v|Ts�xww��7c=r��a�qɜ�De}ٸ�Bۤ?���Y/�s�_��E��9{��C~x�Mwm��.�5�D,
"��z�5�:� �1��z{4��Io�b��{�oU`���et����Ӛ��ۺ�̩n\G������m%����;����"��]�\���8.y둵jQ8'�6�wo>hb���ۻO�n�G���������y�Q�՚R���~�c�l������&�/~��z���m�bG�8����9��6�����,�k�[�|p�k�dK���9���G��s1��Cjuϙ����A�ɓu���?W�ի�Ī�(~x�n޽y��ww7o~����^�}����'�_}\��a�w���"=*��n� �HQ�l7F8��#a`�r��n����,hqK��M͚��h�:���t���&�s�I�T>I�Kƥ�`u��Y�D�� u�bv�Y�Ln���ܭ�*JFZ��|(g�V*����.�iCK�9�hYM��"�@\U�����u�A�5�R����}�j�N��q��&h`iӊr�$�5Y�G˜��PS�"9l�qˈZ:S�����F�v�X�3ɿ �Ħ(�A��r&���`��^]7�#�y̩ԟ�șc ��ҥ�(�k�1�#����wW	w_���r?���,��XZ���q��eyQ@�=%���2;x��� �Z7�I	5nG��d��Of�[��LN����J�d��Bɣʐc3�I�R�s@.���7o�MQ��埯g��WEK�e�7�w�U� �,�
��<h����k�]��G���˳ڰ>w�"R3�8Y�P-��N��pn'��T	���˩*O�R��N�ӟ�u[������eS.}[]���H�MK�@y�L���2E��c�SEb�O.O}�I�\}Z��9�8�r��5�K�C�V'[��1�@}�ᘯ��`\}��t?��I�_xp-޺#<���H	�`�'C�|�};�ğ�LM�+5S7�����u�����og�K⎠�kh�>�N/�a�J�Xh\5�b;"3tQN�����ZI�a�[/"jp�c��ld̵������DF������-�y���3��2jDX˞����gl�Ò����� ���h��>?�c�FX�Q�(�.RI=mS� �(�V[1���w�O &��;�Mc��b�,�v���6�d���L%JE���Q�6l��k�����f��T+:�L��8��?�wF$_��Uڕހ�ի#���P�Cn��;���Z���nVC*B?;��/��<���h�c�
w�/�p��U������^��v��]vF�52s��4{�s����h�m7��A7;J�`��|�"}�V^ �d9(���P\�Ĳ,    ��$j�&N�WyXvU8��Rl��0bؾtH����K��8Pc�=�F�_P�? ۅhv�l���D�PC�s�vF7����_�e�^iq�d���z��ӊ���v׃a�\i�z��)&�m�r-P���C��*�y0��*K�.���.Fntʇ�_'H�K����f���:lWz���0��:!jk����g����K�Q��DA���c�9Oy˴�G��&��i��Z�l�ї�^V�*��YPԜ����U yZr�}�����@`A��q9s�����?7ǜ[Z�Ȁj��; ��([P��:��w�G^Mp��n�р�f���*>�,(i�\�f�@����߲J�l��,hм<�ABͶ{
�gn���f�e��Q��o��5(h��v�ɀj?h/��1[���!��܍@-!�����|�e2�O���� [>Ҕq�t��o��l	K�[�n��V,#ay��`����H����k�H�2�R�衝),!	��*\L��Q��� ���YR"KH}z�fu5���wvb��n�ZB��ҦԮ�$KH4�3���Y���vL����Z%�A��������P_2%F95�@��R��3G+L4���v���BǄ��yU���>�"�` ��ܲ��1QiE�'��ZPA��Z��	Zv���,p��
�����'�lhv��&W{�a?j#>�h�|-���Zl����ׁ����+�֧�Vuq��dC�1���-���th������J�u��|�77W��>����^��[ؤΙ������7X�2wY�}}S�1��Rˈ3y:�4�M��ݲK�7[\V'X���!lv6�!}��!���\up�{c:�9��tf3L ���ԶK1d��X�:�`5
�e��i���v/��--��w)��G6���"A��Sh�kJ��7=;�����M�I{�7ĵ�C���<l�^t����?	%�|��i�k9Jp��+�Rk��RU�Q=E薸������@웮����0�츦����r�(�����uz���Rn	kX,%1Q�+]� Ԏ��Hm�N�.[d_Z�e��ٻ	�$�r��M�Nj���C�D�-�{�`p�:�^�C�k=Z�2@�yy�a�>^�Ҭ�d�L�Z��8��?��q:��.��e�	��͹�bc	��sl{���W۩�e�cÊ;�f�����-O�0���e*�T�-�<̡�Cɐ�7���v�����#�>�Cn�R���y,��\���.o�LY�X�R��ڎ	F`�\�����X�� ��W����F�5r��c��ל2_B��_n����kdF�g��v��,r����X��[��>��?��Do��"}b5�XjH�hB�3D˅�ʹ#�p�:
DK�}�X䡭��� ��LA��k�:
�1�>�tpG<��xQ#b�-u��^�W�dE+�R�pזB1�Ƞ�u1�gv�Md����
X3,y��^���Yx3q�/Dw`W����{���+@���W����2Q�$�ff�ų���F�1cl�2��(ɖ̨�_��Dյ����4n]�E����r_�]�T��D���ɚ0�ЅجL�^�*I���R˄��}�.�y�2ad{yhg%ץ2�ݷ��_�9u�="����lYޗ�����2c�Υ4RH��e�<	#[����2ql�8K�%c�s��{�c��-�2 �|�["�4�����;c2�% �C@�B��V�5���5O�a�0�ZF�8��a�0��\�
j�Gg���&TC�� jذ՝x4u�Xgh�~��P�iׄ쵁Iӳr���7��PH�W~�����p���򀸾7�pd��*���Ώw*�q�}>߼|���s57jƉ!�e���9���\�B/x�q��|mO1�ZF�G�j
�N�#���!G�f��bP�!��e�M�Ԋe�Z&��[Rz�<�Y�
Q(ȷ�ψ�j��+&�� ���
ђ�jQ}�nR^���v���"ج�<FK����u\I+LKa:mċrCJ-�^��%��!��s�<�d����8�O�ײ��H��ev^��fN;��pbjɊ�.��� Q;�BbZ�P����B-�Ɔ\۶�q��wbb�|��jd��R���ϥlE+�[ƅ�-�Z4pf1 l>�N[${Y&����[>��O �D!���XC���_�E��JD(M�\�ơ�a�L����Gp4�%�2��7������J��k�����.�Ұ"��7=0�p�s���U�z�?�Ǻ�z��Dò�#�60S_VnXLú�,����0Ħ��4,�9g��#�!p�;n�N���c=Ȥ����������,��	���q�������~)��)��luAk$���A�79�ՊH�J����
&giU�$Q��(7 gIU��N�,@�^��Ƭ�C����-+:�e��K"/�k��%�,l	�k'ߖOL����+3v.4-w#��ݢZڰ���R�O���Mq���2��y2����z���|pm����������c�ǉ�h��X�����,�>B:G�6�c�[�`��8��ڎ%�쩢'��v`kaȂ�MꯧD�y�О˜
�-u�Cx��T����lR&�&�Tl��e!��,#���2�"3����6�`p!��=Ĉ�I��j�נ��ki�A��A�jB<���2�\��a���zs�۟~������,t�Ã���#�q$�!�~}󯧳�.п�ޗ_�mY����;�^z+{R����셇Zx��0���5?�\(}�=v!�|�۰TC#v�|8t8B��
B��d�NS�P:2��N$��bR�V��E��E�>�5�u/U#L�X���Q]�{G���<�<d��<���9t�7~�����}jP��;�3��l��8�x��<��%�#�"䠙����学��R{E=��O�(;�V�죈��YLoGM�K�Z�&oK�8;���b�؎�*ZN�Ur���� ����@���v�P\q{*���u�WC' Wĭ��I����� \�y*I�j��ppE��������%G�s�L��j�ї�&9�*e祎�J��V`;��	�SY��5��8Zٹ�a����z��'#{� �36�Q!����G�t����v�5�$�g�궷�v�����K��p�@;`eL:�]�i�4�X�~|�M�QQ ��5q�1B�I�"���#Pj�!���fA.���=2��3�EK��7��m�S�J��A�s�
B
�?ٗ��a�=����^ t�e|`XK�W��_�Z(��eRð�����N ��M׋���5��4�4�&*�T�]䬣=Z��7h��Υ���4,*b���������hq˄Pھ�%n����W�0(4��7h	Sv�y�NO�aa�	0wb>M8��]k�:k�qda��������6P�m!�&�̄�Zz�c�Z.�j\_&�&P�'�J䔐�Z��8}�y�-ǧP��:FS{qQ���gP���e������ܒ�$���;���)�"g�M�;��S��L�-'q1SՃ�ZrR����3I�eU4�15%�;��!�&\��Ԟ�|j��-2(2BHU�ĽjHV�<zZ�R�7��\�(A��cvʇ���=RnkE�l����b��Ɖ�\�܅��-v���Sw���
s�傅.�81d�14h��c�CN���"c�r j�o��!vN6��V�+Ԙ:�,�@MUvqW~�!��;�X
(���t2g�{�݈�J#M��M��3ȐK7-��SS�,{o�Ŭ���E��������`�9jQ_������<�.�Y��]ۭ�� �]0@�V
�AFV���Q�-rPODhca�,pi͢=�rc�l�է�9K��7��Ȩ���W�Cw�(�O@j�DSÌ{���g)ȣ��$&��}�Gh9�a�Y���ԬMb]�(�e`E���T/�u��q����w�7W��|xw����
j`��S��D�f�'Z�2��s�Mk;�4�;�9WM7q6�>huZ�.AK3���2N,EO-�z1z���]�çm�7�(
 �bê|F4��_ോ:�1Z�B���ym/�l%w�F��ܠ!�    �ʓ���t��h�-n��Y��C'��T��Jd+�}&`6Ƞ]�;@ʮ�%gp�Jv7��0���kXM���.g�!j榎1�\:S3k�1��3��u�G�M���4O�ChZ��,na��kz#P�����H-����쌥�ڗA���I;s��~���GW��j��Y�7	C��2e�����1��U<"I��rk9EZ�7�k\"m�4}�,.�A��b���hpտOg��C����fM���|�}���̼��ٵd+�d�=��c�����CQ�O���dq���s�����t�;������I����*x�K�~.:�-���b��CH�)��a:-h/�h��u5̫�q�4�Bl���ä��I����7��aJ}�[&]�|ަ�a�|�[*_zGMכnl���[�<L�?���H,I�&��az|�4h��Ӗ��az|�4+r��1`S;r��tJ]�c5�凍hp���u�0sS=��-���Z��N��5�6�qv�|U8��Q�|�6W�=�>7c-;p���qN�s�=ղS���#=cٳ�ݫ%d��tC�����j	��-�o`J~R^�1�j���ҹ<�4�����ɲ�z@��i�{���dIKv+RhZh��R|_�)�yz�إZ�p��]�A� bR~iӑ9UT��0��&�7:�C��nܲ5��]Io�D)�	Ӝ+���~�A���ù"LV�#A��y�N�\�.�s����ߠ-�Pu^������u��\Q+�i,�e�ϱ�犔Y=�؅آ��kK�	�97���1-z�}Qj2Џs���1Ş]j��s6�PrX���T�V���J���>$���[h*�Sf��w�]��;y���5���.Cz1�@���c�Ӊ8��M�h�54�i)��~�����J)>vh��h������Զ�*�TCǄ�ӳ�d�
O�Ǳ����ǌ����Z�r�{$xo�K��Bu�WZn1��"�c˛v�h�˼kGp̖xd��v}�����y����q�����v���� ���d�AjD�ж.x6Ț�����46?|��I�� s�m-4�V�!�����.�"j\\|6�XBPbSck}��E���t�o���ǰ�$�}M�﬇�7�{:�+�K
0k�<M���0��c�c �)S}�,p�C�broJe�f\ʦ=0mj�5j`,�x��G�<��Go�N<��h�,�h�2#mj@;�0����'㖼�Y�A������v�m��'`�2&mc�)tj`�D���8jN�e�B��qSN�<0Y�E'.��)u}����TJ{#ȼ���<p�s���]恣F����6]�'��-O9d���m�}�*����ic��Œ�К����-t8�-4��L��M�C��.-�!T����F�zt�{���jh�:(�a�U����O���J�yhK`�%{��|�?mm)Ln��W�͡�$�����c�d;�\C��Q�%�&�{1�8���5�4F�����r�!'h�G΍w��B���1%�z�XC�@���E@���B'�_���n�B���f%� �>2���B�����1(���r�sژ@:�,tI�v�Ø�.]J<^���%I(��ڂ��IK"�ܘ�Ø�l���yo������0�랒{C��.�A䍔�O�׍h��i��XYt:�R�����<��8Z��UƝ<_k�M���{>8��5[d2�@zt0冘��ԙ-ɧ��ry5:�Z~I�Sj����&�`yx�B��Qd�L��D��%�����:ye�-)C44��EKG��Ц�y`�H��y��{l�V��������[�'�M}suX��P-;�oJ�*��O��wq���P�Cڸ���,7a,ӑ#k'�)��Ȗ���2t��݌�%�>�gKN��;�Y۰l��_��)m��4MUs��"[�"�k�ey:f��2���4�&?ے�����R�7�WͯԒ�f�f�Y�76ᜇ�LEeD�wpf��e-�e���P����1]����ԇ�����j�t���'-ÿ�.�<b,�#�J�uv�]�*YT���,�{j���#5)R���B�Aߕ��Sɳ�z��a:�гs����?���y�˿_}w�9��t�@}2����.Z�HkO�ee��.]��-,稾�v_lDy:`�dA�ܦ�9s��9L
��q�����x*A��ƚ���	�է5��+�J��b�iS�]��72�,4��������#􁦩��!N��-F��Zy��K`u�C��F�d�8��-��Y�XO����\�9M k3m;�m�㣲�Y�Oٵ�����G�ĩR`�UH1�b��?��5��+ �_��qZ��+��Zd��L񍏝G�ZH-�{�i#�F��'��4���[oϢZ�Ԟ.�����]<�j9R�Jq��Gg�1�w���E@�>�}��z��뛛Ï�<�i<a��C~�UT�mq]3֭7�fdYIPu .j/�~��}���]������,��l=������������� ���8��'��M]����1�>D&�h���~���V�9M�X���E��$��-\[��˛�����O�_�����˷��-�X�Ҧ��]�Rjǒ`�
�+d�On��p2,�A�rY����:��}�3��>�.�T��%VZ�^|�x�/Mw�D���Xݜ�YTP� ����G���i���ufj�(iQ��|c%�Vᔚ�v������F] D.�r�:^�6�l�z�8�=C��N�F^Z.�^����R~n1+�".[q�Ģ28G��1���dpj�LS�i<Ѻ��'����y}3>��J�;;1�c;vJ���o�"{hg��ebm�*��R�iF$K�Tw&#kS���,k@���m�fUN�a�d�����`-�2��'�.PCXˌK
�؅�%�e8.�*Y��;7+�2׭0Ҙ���rWt�"o-řUI���L�>��o�߿�}{j��@�Y��ˏ��Ms$����n�n����Z�d�*/j��\�ϝ�G���ׂ]R�j�8k|����都�.c0��
����P�Zr^<����bVXCt�CNG����{^�m?����P�	��\�ܽ���] �4L���`Vwl��k1��^zu���~o��^��Q`����������?|�����R��?��~GTK�l�Zc�:�+r�x [��Tƕd�����5
��*��ڗ��|�������ݧW�������� ����7�&�n�3c6��%�5�,��Q_���#X��ǭ�Dn<j�����n���G1�/(�B	����ʳ���ٍs��n�=6���Z!�?]��k�����?�0�ٯ�P���@��V6(ى����Z�M��2�0R˫7��嶔Tɿ?����������ݱ@i/߾=�^�e�S���ۉ<��2�Y�����"��踩��77W?_��o���o�ߪ��D�ߛ��'Q~t)Q�މ=s�}��]Aq'��e��.�X�����3ݢ�oX?���h5Z��E��dč����\�KzJ���U o����h�������G����B���p�N_���m�`����n9���>ʲ?��QD���A� >0<�&BC�L�X&��$� ����j7���a���\5�8�39	�������GoLg���lA�2�OQ[z�`��g2���.��=����-�dx%�	is�I�)<?i�H������/��={�%�1�2�;��D��'���/-�;�lA���3i?��}��.�#�#yN�o�Z
��a$:�m�I�
8�N�����S��A���}[�3�uh�DLK�\���j��Q^�)�Ay�T+Z�z*Om e����/z?fo�Au�ybMG�'*~�G<�V$*#��%7爜���)"�PP�t{
��f�M��,(i�:�Q�,7uJ�����F�~X����~��`�ʜ��u�;���Y9kf����_\��99d(-:uT	�z���<�R(�2!v�_�]�\��E.�~�W�r��_x͒H4����om*<�Ʒ6)� X���y�����    ��������j;_Sh�K��f��z!��qB&GV��FB�'˺һ��Y�s�M��㥃&�|?3I.�UDm�/OMi8�X#�����~O�$}#��.��|dKÔ�ի��[dy�E����x���m]+T�����eT.m�5������ȖQYk����>�T�ٗ�(�+:,��TK��ƕc�w�x�^��%��:��e+����P�W\&�����&�T�)k��8��f�-2�ҠH�R38�\���5M��Ȭ�D�#C�����R�R�v�Z�5���1����K52c��J���b�B��.��b�E���2��Dܻ9�yހ�a�ʮO��>�/Ǽˡ�;�J��g�K���Y��i:Mf[є\3YD	-E����k1��{���)Oe����c�T�s��Ҽ/c|H����yu9eM������Mzhz��NK�]*���tCB{蜾ԅ��ȃ2�R��~(}�9rm�7���~/���ks�ݔHOe�%�lLZ�ܥ�H�̮����ꄖ��L\��l�j�J��=����9%M���P}F�$K�"#�P�d�;�\�<}1��hŚd�ZP����~6�$K��K�F��>�h�ĲdN�A,����ɜ,�+�fL��`lI�dɜ�P}�a�6�<�SE�H�!�2�� ZE�YK�Ag��/���Ҵ�O�ON�k۷��w�����,��(�-��=TS�-�rߪ*����i	UPY�ֳ�����~�{+O���|���۷7W��tW]��2�k6&��:���ds���|�5	Eم��!�,�2��.��ZX�l	Y���S^W�r�����c�H��~<F�aq��zVmeb��:	���nl�&��RU�KkI���BŜ�n�w�ؕ-�HΊvf�*�R�Ї�M�g�R�ط|�X�+�H���*��r_����M$�����)T^Jl9k��U-$�MŮQ��<h�Lc�E��ه�f h���3�!��M!�%x��a�.Y�4��3��RHv���
.W�6�?��-�l@X�eR��3fMt5�|wy8�*Ҵ�ԦA(M�X{r�#�@�,r(����	�iPFv@N%�C�Y���\(*�m�?2���q�u�԰�� ��Sbi��9ZdҐB&yO5^s�Ȭ�Ҥ-�����
�#2�J�6�<,+Ȭ��N�7ΑK�����y"Z�3��0.~%��6"�#8,^i�B�m=,n�}>耾ҕ�WB�r�"�����(�f�Yk&wO�Oâ�#��n���}��8��J:��E��H�����UGD�]ȁ׵ 9��"'��8DO�f�3�5�Se��$��(�g�D���2��.�mʩӰ��Y�y�T�w#��zT�$y�����l!�LF,y�yׁG��3��b���5
���3�N�DḆ���-�zW�r00}�pO���/�,��8�⹦d�ݾxϵ�8�ī��d��(���e�[��d_���}��8e���[��W����An����������/�6D)~9�U�U�V��c��::��#5��Е9��bȮmd-*�ȥ	!`HUN�>�i����q�`�H�6o�<�>;�Rh	.��Y=��l�B�G&F�o��ͧb��=����i����X�f��I�0�f)���1��^ ꔅ�xz�$��:�F%1<ȕ���O9~���������l�	����N�2c.'J����|�(��T���2^`2�!��(�cre��6F��q����k���M5�&İ��jz���)Xz��x^�O�j�\ ��j���{,5�N{�ɖ�A�"&v�6VPhЉn��Ⱥ���gk]	��z>֘!KR~�&S����ub�>dLi0(h��'S�ʹ>�Ǫ����m��8ԇ�J=lAICf�(���h��uP5c	�5��/䜂o��R
���5��z��/�s6(:���#RKm��1�����\�g��
5(����H���h@5��w��EK[�:��\�g�b�f��V�5(j�Δ��̅�<�Ҥv��������1�P��!��E�7VS�<j��X^|bӅ՟s5[T.� 8:Z: �|Tr�϶�����;��-�NY��	k����;~ؼ5�y���7�H��Pz#x�Z��,h�s����T�Q)t��*8XT��H�)�؁,'��a-�G�{�4��fԾ1�e,m
�E��[�C)�Lw�4�/-���V�?��+��}%ky~�F�h.k�K';ىٻt�=w�L���liJC��w[,�GX�-?B�'�^xl	��nj�	�K'�/@���ɚRӎ��c��2����yTK�:��kX�S��m	P'p���B8���=2�W�j�\��"-�vb�J�;f�?��cm�T[�8t�?�����M.P\�=}�A�Ǌ�!�2�x�L��O?���ۿ4X(h�J)��)�E�-��q����w�%t�����_� 9m7���&�\�P��45�|M�ـmT-�/�=�t�H�T�~C-wl�gy�tn^�ɵhʹx�R��l�]��5 - -�hщ\ɩ#��e"-�qZ���PD�3T.ǐ�G`��g�)t�Iq@�3�9��Ǩ#�[ Z�a(�Mj�� �<��')��f�y�v^cnez�<s���x(F�����p�ӎ�G���fv,W�mz,�x��ꊲB�6+�X������� ���;}�E2���iw*��X#�\�� �1��2��%*;�!�#f��e�.�xL>lf�&�����D�1�e%��8�q&�z�B����ܡ�Ӱ�my�B��&_����}�%fKL�2�]b�Kk�_�%'p�U l�㊬��EZfR�؁0�_���eZ^���E�=�U-��j���x�~E%��+���)`$����Rͭ�2���ēv�^ގ���ZR/"wrlub���sK�,T\���3����9�A��v @̍ �D䋟�Lr���΁��i�ŀCŮ�h!K�
�a�gvj�!���2ÕJ���)v���`RT,=>�NX6����ڳ<\V��N#�Ή��	<1�!녳"co�Z������>̴*go~�ɂ��(rm�-v�T��m��>q܀�΋���
�_���7?�Faa�z%4lC4#��}�Df�2�����Ǖw��'B�Yr;�Ok.�%���\ɰ�X�B��Z��P�~cqiPq�RGT��XIS���:P��8�����WN�X����K�5/90���[���C�E�ªyU?�g�u�V�j�n?��$����\a��%tFh�3Xc"��1�y%-Y.Y�Pkpp�Ci~�\c�H���t��Z��[W�o'�+���5�&= ��4�E��%KM#d*�$�h�SK���.|�C����jt��O'57���[�R) !k��n���%�>.�=�Е�r�'�b����B%���k&�R���!����wZe��V��%���d��(jɪ��A��mޒG����W�UQ�~N�A~GL�U�oK|�3�+Wj�dw9�~؄���Y�5Ο�P˕���L~,v	��K�	�TZ��txFw��kd��!Pvy�G|^�t����i��z���!����'���.+�X��a�̫�:�=\j���4����l�:�jQp\S\1��d���
�^���`�GV�}���P\���)�x,����_�H���1y";��>ɇ�!o�����2���0����Ƞ�B�4��bz�Z;�&쏆�`-�.zϗS�2p��Q���^)��<�w����4�0�H.��heȚiL.�KɐF2���(:�tfq�"�����h!!��D�A�����:JQ�.%��B�O�<?�p�� YM�D`B�5�Q��=����d!�}�wZ���f_/T��n
��S�"��ԓ�Q|>B���8S�vП��_&�� ����B�r.pv�����$�s- `\��Z�K�\&��`����`�V��y�}�H��F�\����bO��{W�hY�ݡ�a��n�h�V�!1�*`�J�i���v�+��|]��3'RUEK�"�撇��gG���&�2�N �eo.
���$�6�p it����˙:2 kT��/�<��z=<0    &�����`@����c�E��}�p̀x\�J�ڊ1�q��&m�/b�S�w�ףI�X����z^��?���}6���'$IR�O�I��;m$�`�%�E Mn�0�b���,8ğ�����ُ�p7A�%>բ0k��c��m����D)��B$L� �=�Y���"���Յ�Ӄ]�ϜT	�L>��`/��-d+FTw9��M��3SC��3����?4�h��lYS�`�T���VȖ0I4u.x��Sq�
,Yj�j�'��v?��1��Gx?�t�3�Qَ��C���K<[6շ0i��x�����R��t>u,���W�T*����i�Ώ�G�a�T�4�d�Ù]�wф�Ӿk���.q�<�e�R*g�sZ2dh�&�a�W��;7�;�<АU̦gpC��\%����y�_ʔ#�����C)@=N.zm[rN����N`g�0�TX�2�@�����Lle u*dK6�,'����剴�Ts�ɻXヺ��ql>�>Ϭ)?�w�C�/`<;�w�O��$A��&�.��]�U��^(-�����]N��6Q����qzT�2Q{�w�qA��.���)���0F��z!�ň7�v���Z2$� �6X��$���*����%9b)a�*f�̂8jL*9�4�"���Z��3r(:����y����9se�3"w��Z3�qAʷ:���i���`���G&�/.|8��șj9�8��LT�s˙���|�#-V�-KD� 8#h搘O)�)��e�d�V�2OM#��Y^���,b� �z�ş��D�3H`�T�M{�0�Kրv�YÅ���vZ�5��N�.b\V����q-r'�q�R��:l�J�v4x�E6{CA��\����a�9�+�4?�{�W�Һ:&mڹ������LB�����@q�+p�C{ŉ�ŕ�e^�O��}Y�u��a6�O���b���\���Y-�����~�{+'��7�������;�OWw��{�����l���,��v�r���us���3$ӥ�N��Q��I`��d����cC����t�mj�)��?%�0�7�F8/��"��ǐ������x���X�)�d�X�ŋ�� �c�o&����{LSQ���q�\�R�c�/�W�d;a�����p=�Z#Pc2���_�z�ޏ�=��F�S۩�����A�@{�r��	������Od�`.ùA�Y~�r����6|��h�� {;�zH	,�d_�z����E���/���r������M^/i���q�5�F��=/���eʥ��i[���D��$�|2��|V���ER�@�\zf�VwY����I�q�K����e�;�θȳ�����r�jҞe��F��2m���q�>��Р�W���n��s5��G�3���~��#G+Mi��r��%�
���zJ�J"2}��6��a�1-�:���ă���4��!�6xf��AU�A�R4���y��q���Q��g�ى����� ��~C~^qɊ��l)8J�9n��
L��$O����k�J�KQ;�S��TOO��oi��e������ױ/����T���6W���6��L�!,L��lrE{�i_Sꀓv�_�c�R%�^c>�IRb��˫�^R"�~���;۾4[M7�6�����������w�����=�_�|yIFBd���w�V	��)-L������K�f�W����o�����>VRV�b�������խ��B3Q&-ː��]-����E G����*�һVAB�C�¥�,�C������B�%w(�+���K+�r;@�)M-Ϣ_�K�TjdC�.]ޱ������0U��Ɖ�iLˠ��.��[���O��AnKr�y��v�ĘTQ��9�-"�97�~�)M�g��{7j"ע��P{�\(_���&dgC��ʁ�@��4��ע�>���~�V�,ÄQ'f ����M��"h�hB���Z���` \^J�MlD�2�����ꍂ+H��s�O�zܿ����f�BTΣl	��4�EHt�B�<buߏMq:_Z��}�&�vX�-��l�(Yz�0����8b���)�9#�.��)�f�,g�h��Y��R�1>!��@����T�VJ��ƚݰ�n�s
�,�a�0;K:$l<�ถC���N�|��9��±�N:�<���r��5����B?�����yss����ǚ�\�������=+e�C�L��^%X�a��O#��wZ)�c������vp9�l�:�:Ν����,`"��.�����nwoԤ�E_]1YS�P凮�}��p�E �>�}��Q��z��X�J��T��v�١�Z"�FC=x}������N�I=�b����+���=YQ���d�%�7��k�����>Û�0X&�e-�Z�m|�@����*Y�����{Ξ�r�i�'�2��C�q�+����/��˅T��8LeC@^2Gk��c���O�y�!�(t��8�%�k�u`�<	aM����A[�R
/��	 �ş�t���l���L�/ Mș�$91�ڷ��__j��.�V�܏^��_�U	'dȝK�E�۽cf�:T���à������;F�{!�-��RD�� �<l!�J	�kx�HC�SOÕ�uI��V�ꇗ�}����i�U)�t�)qܜ8h��2JN�J��9߲<G���!+G��eJh��Z؊#OzҮ�����2��2OK�m��S|�k���I�k��<I���O��r�HC�$#���CX�k���Ήb;���l��pb^��"а��(�!�S@X�u��@Y�f�<��F ����vK֪ͼD��n>����?<dQ.Ff��H�;Bw��z\d��IX�M�ٝ)ڼ�}�����e�<t,���*�R���~�P K��F�伞#��'��@��:h�cC�kSDt�|e���s�=�Q� �Q�,��*�$i]������瞤�*N��	��s�)�ɼ<_�Jف��r+�h�&��
���R&�nmA�@h��e.�2��EfU@5���E��wa^��O�2�4��H'��I�Or%�5��	QR���ƿk3�ϐf�]�H�\�.�t�P��,�
Z^�����=����\Z�?ת�E95�\�#eF�ϕ'ͦ��(k�
Xi�������G:s�������6t�J�똫$�S��iI��/¡���$�K��p>ev�]>,)��P^�j<h��O��>�s���lu+8���!��#��y9�|�7�F�����v/`Q�N��y���|�n)�^��g��r�H�k�T{9$t$r,�)nVH�r���G�̯��/UD��;>RBX���Z�Y9J��si��^�� wA�qslVXy�z9s������ZЫP��n�b�gab�.�d�,�� I^��C/I��ФK�0�1+a��KW���>)�Cultc?]��X.e��#�%�[�,��<V�s.kˊQb�8woP�S2ƎY��3O�e�!�C�Χ)h�20�/S�R�Ӏ�}�d)���E��>���,�r,�9�.����^D�R����a�B,kS2/Fc�g��-c��>tA���Y��VJe ��X��mK����q�q��b�t�=ŞHJ��<גC�0i����]����;í�<n=��[y@�!��\���&�qg��2Xɱ4ߠ��u����XB�s��o�r�/JV�R�"vc�d��.���fs"N$ϴ�K��M�a�xx6�J��(/Έ���6*���/���k:��]ګ��_����:��t�2x�~ H3U���ȝ��.�BgU�?�)a���nĤ�bF��uIï-���ŉH��x�Q ��J�E���C'���ϟ��9Xy�$l%�zTr���X����G�L0"@�]��r�\L�ȡ��t�0a�$��^��hJ[���??�=+r�?}3�������W��UuS��Vҷ��:.�
�e�N�8�������ר������P{�ȳY�yq��q�[��kQ��x���,i�_�F2�q!����#D5q�O	09G�V��af�f 6�}�
梱�]LԲ_�p'�}��Z�Vp^;�r�IV��j�    �na�=�ϑt��>�Bc�8c��Y*�sp�:\��4��������D����C
���%o����/��a���b1�v����PD�Zt���y�˿#N��:p����k2�Q���=u�ֽX�~�\���m����2���vk���~D{9�+1)��|�oh�]$�\<yTՇ���o�?��{��8�o*gr�-�9�p�	z���Ci��j6İ>+s���OetȊ�e�?(Z��\ᇪ�gCu`��e2=�BC�2,_k�:<�½�$�����?_�9���9�-�����kw�%qA�����ۿ�ˋTP�=6�a��*�D��\�%b��@�������B�$j=O���K�8��s���5/t�����F'WK��^V�틒�B$�qL��d�>�������+��4�T��}��/-�Y��p��/}��� �+?p�؆�		�\�5'ب������Ƨ��<lۻ6�������"����\�(����f}U��l��7:W�Y�W$��1J�p�S�Cg5/u|�� ö��g�hkc���];+�|ҳ����Q��V�FV}�	��|rK\�Z���c��ͳ�Sg��S>�|��y�!]� Z�V	ԣ�>���}I����͝�R�9o[��}���`�\+�K���`9]��sG�T�%sm�#���F�lԂ%f_J���:��*��,�� \�?ڬ���AK�5.����(�e��R��fUTL���Z�����XTo�_T��YOR�K�֩ Z��OGL�Lh��!�vU��"	-��#�����`��?���[�ˑ���I���,E�b�8k@7S�%H�݌�2.Q��F,��p)'�X�%E,����vA����81<<]����>iÂ��@�fPwx�J�A�Ԑ�<��ePGxC����xؠ�°f�b?y�b*�Z�����py�.�H!F����Z�EG-b���Z�ҿA	a(��/8�N_�����o!�4,oq�f���O��k�}Y��T3��)��.M6Ґ�E����������j�d�(�?�-hp���b��ԹU2�+e����C�L�K*S&��%"��w�/&Uӕ���E��m�ܷD�E�<w�}z����{G��p�k4�%�8���Ԯ���{��cw�P��V79��u'IY,v8{���$���������ҠH�����Pl[o~��	��>�Ҕ������gB�e��<;��"�f��%z'YX�_��|Q&O$�� kOd_h9,�c=�@]��@��^��aW��-��K1�\c�<׸�v٪�`D�bu؆*���gK:ݦA)�+WZj˟֐�������,�E���iΥz6�����2��j�$�^@�'�ٴ��8��t�2�ȹ%�!V�A��A�2�<k��am����m�N������͘�ՠ����*�A�ݚW�֏E#Q���P37���;���G����ی���O}3ɪO}8���H�Wr�Ho:��ҿ�J����%m*�5�>���aԂ��2�yYd�|)�� Y����.��lD�Ҁ�����7ˍ�Q&m�S��@u����J9��%m ߇H��׊v�Q'��UB�"iN�j�y��z������4�z�4�|�J�T�w�%k�����~�����>��,��&�Z�?���І�0Z�����+s���3�$D�v}�J��ʝ��^�zd�mw|�e�w��j8�|������E�A����ϑu�݇��Y�3���\��В8�v�nI��/hɜKp��N��U`�[[�.�E���:�����M.�꽵X	����>�~y3�:���쌸p$�JT�Z��9�N��թ��9�_�����a�2�֏t��Z���+�,�&'�Uk7W5�2tHՅtK�����9�nm�ާ9����6�
?�ޫ��������`��,�������%�y>�
�;.��e�x>����ދSc �]TݓQ�;��Z�T]�I���BT�e�I�$xA���k2k�zzpi7�\�0Y] �nA�5xt?h�Ғ���|ٔ�@�$:5d�,�5�jp6�+߹~����
�`���^�2�hJ��ϛe�,�zqԅ5#�6��,�
��mF6��X�!�?W=+�m�4�_h�a�1X�\�Qr-�6Ϫ���c�g,a�hάJ������0+�����Z�*&̵E1�s��`S�� u������{2��t�79�[+�WJ�T�;�%�G[
�R�W~H�e`a�������
Q�Z%X��Z��X��x\��۬��PB�'�'��,�K���EJ�~e��+�N����L���+V,\zF8��ݱ>�!����c��;;�idk�"�n�i����|�8 ���DKW�!۶O�Ҳ��	p���/9Tte�yɨ̵+�#l*��u+/k^�;l�����b[=9+��GT{�i'��g����UP�"�]B�H;k'��ey���j��[B�3����.�md�5$T^��Z�d�Q�JaZQۺv�c���$�����k�w�����e_ l�Zot<����F'r����o��^���r-�VH�n{|�,UdWK���ܪ��uZ�c�TC]#����#�5+L�F@��<��{:����ʈ�C�<��
���rHW�:(���A�5������a���F뾵S�t�h��ja�%�����B�ɼ�kY��]��\"�#�)i���9X�h�-��3v\�v=I�x��l�.�(�]v�^��8��k�9��^�;-]0�a���BY�F�ڼ|g���v�JF!x��፳@��;�rcB��;,��+;�bP���ˣ �y�]��,8�7�Zҧb�b-=ى�t�4Y)X�,���/�A�&����\[�xW���E�������/M����e�4"`���}��#�~.K��痸ϲ��%jy��WU��0�1������ӥd���5�,�zM��b w�1ZT3\�����qB�X-�?������n΂9���X}y�����ڻC�2��)UkO���(�������|�������՟����r�?_�ܹ���-|ҷ��~�?{�3���R�]d��-|�ɫAѶ��<_��������S
yX�ɥ �tA����E�Z����Y�/��*ϓإXg��VF�%�*u_;�)c@��J{
fEBX;qZ3x�k2�N��;U[o�@�����v��/��x|9q�'�(�1�a.�v����2,���� �������~^%P�©Kp�*��0�N�j�Øy�H�{�QB�R�:S�5��P�#�^�8��x1��&��U[��8Y#&�Wf�,�hxL�P_�jڦ�3<%0�<��4��he`52B^ٻl^���Oe
\R��PL{G˪^�)`X#�5�/�'�3��<�mv�ú�^��13���_�ǖ��~n��[ՀV��CiI�c�������z�~1I�z
�ת�-��%1�0,B�[I�F���nC�Z��������1ZIJǺ@�Q��"1�t�k��t ���c�E`*ClV$����l�����i�|��37�Kf���Q�b��K7_���?����Hp�ǲ�گ��*�u�d�9�v!��;�bAܳ���؊��S�n}��%F���e��7�G"�2)K�~�s��y)R-���ㅽ=�2<���C飔���QƠ�� M�ļ�b�N��')�u��cP@x��L��~qyoy��ق�\#
ZQ�fo��-*4���D2��c嵛vM\�1��/�okǞl� c
�:��?=�7[r�|��%9�Z�{���9T��4�L��k����f�F.����S��O?���ۿ,�X�]V�#:+K,�V�����#�I5��D��>�Or�V=�{Ln��$:��0�����Ě�k!�UB��?��9'|Igiŕ��KVg���L�s$#�����Da�p��!h�.���v����}��sq��RѢ��qZ�77�!YI�Fͩ���2�A]��%���j�:҈Au\�v����o���ڟ#kB�VE��2�R�"��5Ηb�-X쬮�(���ߓT�owO6�ؤ    v�S��.�x��j`�C�A�F�����`�&`#�1���E�V
�ݲ�\V;|�����R�]�
<��g����픒���8H9�8KKD*"��xc�K��Y���q��;���t�,���c~�c��K\j1H��3�ѫOMGO��|�cq��kPQ�K�ŕ�{a;�o�A�����ZroWB0R�P!��%�A��I�.�xa9R-S��r.C���� e��| @�$������0(�;�!�����#��D���s�{�0�D�CWY�-��![�v�5�,�3C9�V��Ef5ɪD�]��B�'N�9�t=�d&�]�/�Gr��de�B�z�Z�HG�*ʻ5�ݍ��k�"i�Φj� ԭ:�멦�t£*x���O7<7���e���Y݂mJ�W��&"e�i����u(H�Vy�WENӌ�����a���\On�(f�(9E3�pe_�JEe�||�;�+�e�AP�P'��f�Wb��
�ۅ�����j��������w�nٖ=:�\BZ��%��>��OQ��,�� ���E�%
6s��̍�1ѡ�l;��!5<{�%[��<��k7��`no������'�-a!�=��̇]J�	Xj �d+�"�l��r�c��N�B��ް�|6��lS��A�-
��X79����(�Y��Cn������\�2����5�ʸj��[\M�#i"Y��6���
�|T�*��R��׿����o���������~\�K�L8s��@B���p����Yvy�c.�����u(Ys� �0F��rp�.$T��N?*�"�M��i��|�͗Z�/�$d�08���+v~m�BC��1�j����$J
�4��1F*1h���X��r̯�Q�� b�	��k�L6�Q��@���ژ�Q���᜙ƙ>E �����po�p��z�McMM9��������F��� <�zU����%��i�)�6�!��g�ZB�{Ԃ�f�j*���I�AĦ

mIA���	돂�ى:5UJ8U��[w���nIDAaxz��+�WnI���*�kz� (@S��A�ZD�tC�1`k{�l�E�4����缟j�t�H�f�M⍠�b�|>�,��]%ޖ����G�C	As�I���|<9R5m���b�9ɣ��R%�������o������F0$��6���|��F*gYz�r����*>
5�I,{;>�g�\��g�����#�(�DsÇ��o�u��S(��ȧj��p��c��!pO!�T'p쐓W�^�hm�4 g�];`�t��ݻ��[v��FO���ՠ�	
&(ܽJmnss��H�м�j���s�UHpl���_����5�r\~�����&��ps����o>]�����a(��g)s��ج��"=�YΠ�0�)��/[��g\�G�J�w�LP�k��N����'���!>����??����x�_�����_?��.��k9kk.��+��;@C�Fi�*�s��ټd�I��������Ϸy��}#�����������{�$qpj�$1	�=z<�Gz�QW��֊<����� �~�W=@Ps��������qQ��̧�1<*��Ē��҅።|M���WV��e��3Cs+Q]]eٜ$	5Pκ�(�D��2�%
ǭ5��(^�8G*�Ɓ4G	cCq1��Z�����7T9�i�P�#o�n�C��7���4Q�\�H>}�kJp�:�
Vø9�Q�do槻ÿ�?>_���^����oE�0.�z��o�UM��&>+����so�߷�9�����(�6�4�pоi��/{t���iC���t�ˏ�>>]5�C��d�Mix^�e��3"V\?u@�5Ѡ0.��Rb�jW�����¸8�cR4�nMN�� Lׄȇi�`��]�w��ۛ���9����?���K�~�m�s?%c�����=w��2�z:�r_�J��]�V�[m[G�"�!qᄽ�:r,�a�T�.�I2(,W�=��^H2^b9.�k�
L���>�M%#jW6Jf���Z�'�l��3�}{��z{Ϣ��;��sW���JBL�z�АAۭ<5���0Ѧ`u��Wy4#�"G�9|��hV�q+Vj�"�z1����SE>d�yEW��<�����������𾏓�5�+VH�I@:L)����������e5[IP��y7�}S�zIᇪ~{�Fc�j"$��P��c� F����4�]�=)�$)�UG�J:�LJ��K��DOA� %>tˤ�1��������h���}�������?�>E.���j`%T����VX�@�/<�w?��:	C�,9	_�I?������*��Z�|���g���3T�)�j�\���6��=��Z&���47�M����.rR�D'��so�
������B���?R	a�^ۜ��%Rp�|:��L��}���$I����=��0�z(>IM4��nU5�5C�d��	��<�:��n���⪞"�K�^���!mͳE�����VS}�
�*��q��#I⼰�$A��	;���Z�DAB�c�2�*[7k�$ G�]ZW��b\�(E=h��������n�uX�aRT��8�;������2.f`h����Ɂu�׋'TXI@3���fM{���  	�)��r���r/C��N����۰�I2fMjN��
��-{I(_B�2���F�5�$��8S3`��<��=�v�@�gHD�=��>���_�i�WG7�?)�K�TC����3U3�q	�jv�V�i-'i�q��ã��F�Z���%s$���q��	JtCym��Ji8��z��xw�z{�����0.�{�P��=��/�O����Z��R���r����0_�z�T�`��6�R��}ǩ�F��o�
ZPP
'M�wK�� �C0�������7�J��I��Kɂ��H)�!����A�T�`̨���;����!`	�/���K��Cn����,"�{��\�Q���󝺂M�r�3Iz��Z�F��f�E#�FM:��ug�x�����[���V��1G�.E��,�(= �[q�)늒j�"`mߐ�%���<\��x�rz�$�R�#7������Q�t4�"�io���:p;�8�?���OZ��#Xc��*KӽmVV���������U�?��c'���F!�-���.�}��:�P��� `KX'a)�1o�Y�&"R���Nx\|�l	�%,_����)V����]FR���A���M�B��V�W�Z�aLj��!���I
{�����EE�������W�S�E���3�	���e��������i�դ�	K!���IE�3t*�1(u��TJ�B�Qw]�Rq}d�"2#�NEx�ZӴM	��J�D���HRW,�+�2-�F#m��M���y��n����:�|��R�JUF�>�M��<|�A�F�$	K����ux���B���e`����V���-YQ�Х� a�ӯ���v�
�:�x��v]�b	K�%��_�~eX�Q��[i�ܐSڣ���|�!({\�G�e�����N��Q˂4_��S��X��r��ԣ�i���|&����oi�����We����47����2�dt<:B����ʠ�E�@4f耂1F��sPz#eL������K2:-a(Ր��E�dty����V0:� &E���hđ�n����d���������E����G�y7=0J+���6���E�����<�_�QZ���"�xIF�Z:-�:��h$#WVy��(����b0�Id����*�b/���%�k0��n�,��'Ct��+��!����$5T�e_H�����@��/��tAl`Z�N��������K�5JRO����� ������Ӫw3��
V��;f3g���\KO�߇Iک�>�b�jZO����>�2� 0���FZ��?q�.�iE=�q����C�谢��o���K8�#g����櫦�؞]�����H��5�    �'Bj��Ct:��I�qT;Yۋ����,����>��%h����8���P�
h�'rBiA��9�����6I�d��A8���<⛚��;u�:˭�y�$�.;���ദ��x��I��J�E	GEW
�}��m�t��7�>�Z�#��{��u�4N�P��S}�Eᬄs�����~Q8p�9;o�{�s.p���4��9��b�I[Ay6����I[�E@Q�.T����D>u�Y��p��+Y�x93���@J���^��@K9�,���!��<�|^{f�W�%����Hu˱�<m��<ɍ2��s�����H�HO8����*��;���yCI�]�(��/H%!��}�i1?��I�^>p�V�a����)	]�g�^�H���a��`-��/H%������'?)��#Kkb� �w���5�;}�l7����5���Q��JkB���O�� J�§�(�r�FZ���S�!����,ߏ�A1�+��5iPh@��M�.�u%#m	�	*t$>iL,� <�I�]�!�G'#M�O�Q�����4�#T�Q��%9@�?�SP2�&X�x�z͘�m@�H�oI)(x�Χه�R�g.�Ml(+չ�����v��Z��.c�L+;W-Z+�П���Ň�z��hA�����vFj_�|����R�\8P�M`(Y��!R���d�B(�6� ��J�>4@���@�w��vg*u>�T�.�9T����
d@��^niHSAI�Vu�n�@��>�Ђ���	�]�	�!;�+��U�qxz�5O^�����>�3��s)�I�q���M���.K��j��k]��%,�=�:gU,�%���U��rʍ��
����v3pɝ�k<�M3Ӹn�!//�� ��4	bn�Af?@��Mj�5@R�x!��yy�V����i�"l�u���9�j���q=�@謭�y�����K�HI4�\�̴A�&n�%k�ȭ���Mi��@�3˛ܷ�EiL�Q�[��)��;ȍ.P�wB+W��<#��M+r��Y>O�)�ԒqNz��coJ�����&�z*�%�3��=)��,HZ�-d>L'�Q�"%�G���I�6��m�}�c�Z�Z�;��h~�JX#`��W��b�
Z�	G�T�t�\	%,`>د�鬡Eu��7�M<m����]�{iO�|nGӐ+&�WEZ���N�9�ۅ!-���?脛��q��˛/��}v_0,li:�O�QQ��W�/mI�wF%9ظS� �jK�+��'�#��y%�����-�z�/lR�)
Y=�n>�~���W�����Çç�b�拊��X�}�Úm(,V"��d߫l�hek�Q��?5��{*�_����Ƌ���Kc6pB�Fcl�6J6ó7ec�^?{���\j0�U�G]��9e"D��F�� E���+�����E,�W|(������;���x-kK|�>ss�gN��0w�'�g�5>����*P�ʝ�ca�%�S���D���l��sc�S,'2Ҝ聥��I��	�h[�f�ϓ
ki։��k6I�o����=�"���t׊TM�1�����O#�H}ly�iJ��0�N���h����撤j�ԧ+2�ْT����T�+s�k��T��s��4�l �L�qiP<f��^�ZK5
\#�ԅ��02�T�F>�R 05X��V>�/1����� Ac��	u�l�2�F]G�

*}��l�2|�xC��3���0BICY���[��(1x���o��QC����x�F�4S%A��{�<vh򉌖�=�Z�0�K=�����a�4R��#�SKw�j3է�r|��3��x8|8���c�2���:��X�<���ĳ4c'x(�b�͛�Ï���\zs}��y���v��W�ѼD�;��<Z(�TXS����E	���dZ�s�6�|<�G�����iI�t��T7TF֔�kX����D1S!��ͦ��A,�	��7�SP��,'iUL�����PP`�H��t��re���h���B���mp9��X�P	��	H�)�$0l$5qM��fa��E���̾B S>ޥ�K�+�[�d
�G���S�6���OC�����
���������T~"�?l"�P>>{Z!\fsDAc8�:ĶuZhKu
\��ۮ�i��@�0�ļ��M�xag.p?�i�����O�m�W�r�a�5��ŉ�I�JP��/}�uR�f4�J�xy��
�d�!*(Nqw���?�n>_��q%�E�U3���s?��������\S-���O�V����򧥞$D����}.�(�#=0�[�ǐ����ۯ�5�ô&5�Xn��yC�e�Xؖa,�'�l�[����F�⚸ıՉQ^��Q�葁K�1ԵX[�1�+�W"�Zo(�
%�S�gܹ��K̶:����*�0a@��ԨPΟ�,.���+-˨�DT��<�}�T>���k���lTkyd��C�VM�2�� �[�aH����<�^��8_,������&�w�g�O�i.#e)��T\�$Rz��M�\�3^GXR�l�U�8�E1���4/��n��T)�P>=�&T�w�UK��Geh�R$IRp;�dlE�%��!����ZCށMԌ�i�����"�O��V�r~�[>� !���ʯ��b��x6]�Q3�&ъQ�ݑ��p����hG��q\����tu{W��|^�J������7?�qdx���Z���3J��ed�3	N�v��ƾ8G5qGN�f�Q8���T��/���E�����N�.��R�g�lۦ�D�ˑ��Є�B�Q*y�+L���'�E����bMj���b�ʙ�P�*vϙ?����8��X�V�����4i�@Ar�V��ָvɔ�οU:r����@C
�̝���,���v%*5��KNb��ߚ��va���ԃᩴ��͜��t�GC�����$�pt�mzU���FΨ�-;^e
�a�ݴtd�����Q���6����k�;*>��R�"R��=�R������c�;���r�@g']���t�WW���X>>�3��jo]�����p4�V$7B�s3it,)��C��Z�IpZ�WJ�$�`�����L˲;cLI�v��ޖG��ެ���,w�J�����%:�j���}wi ���SZ�������3'�r&Ή*~�j�Uڑ����#�{=&�0�b��&��G4)Y4V�z<��K��+�E�qԁ�i���Sc�#^v�0�c;�M�J�l|>i\86m,J4�mM������m��B�x�uD��}��Q� �5�Ƣ�J�\��6W10ն�>��k�&�*���H�J�X0Q�Ǣd�'���)@`�n�4�9Nm���$50P�%����/:�7����Zg����5`4������!��o>]���o,��-��?o������g�p��/Tk2Fͨҏ�C$��|S�6*�(���K���� �fT��O��ϳ�����h���Ѩ��Z��5:�����s�9gA�i'!�����=��4��(��������,��@�����CI��\�>�8���GZP�Z^='6FR�k�j��P��a�F�4ي>�n>���������VX�e0���V���]�E��~��C>Y�??���}1N5���)�(Å����b�U7���l�sky�l����1����X鋜&1J�s�HC;�I` ��.�S��\����\Frq�}�sY.+�(R���&�R[.g�g��bIEl9b#���K7z��i �玹�L���x,O�+��U�/u�P����>����9���6��j��"55�aֶi�n�z8�>f�>갼n��F9�����W�]�g��O�jz���������F9MU5�y~��h����d�k͚�`��$���.T:FU�@�`8���t��-��A9�
Z8ZX�Q�=���X�e7���b�n���1��
*h�������w���Ћyju�sl�֟�.Y��(̳�������h�Ǭ�c��f��Y�3�<q����MnZ�Uu۲� (y�;��e�{���Et%�3
��N<�PQ�ҷ�f�uP;T_�*��M�j�S��    .p.�{�}
���ǵ�K�*q������N$]"P]6X��gs�_��m��K}<4�M�~�����W���*='	�F N@��K����,� �����i~���V��� _���7�=E$�%��U����#J�0L���h�PR���Zn�':���ܒ�O�������2��!��Z�V\�Ym$	Ǎ̱yJ�(g�3B���|\�CH�o��_���������woW�~���׏ן>�=������������rwu}������R%K�ŷw�����W��2��k������;r��t���y#��#o�q|��І�qiS,��;t�zxڠVc�@5;�4��z��$�)1��J畍����j�,�0����$_�����J������|�i�;����#�ֻ�Hk�Il��g��i���M�zk�<��<T��	�c�i��3 �:t�G�Ͱ�:����.�հ$>i�|�ͫ��<6<��o_)�B�SI>z��!w��m��}>�+g_��ܝ�P��Y|�e/�T��0Dl͆+䭫�J�O}���1/C-�1����$�F�ވ//�e$'����T��8}E?����o>������H�_}t8�y��C�j�����Sn��y�N��� �\�HqY�ȁ�Ê�*�����@�

���<~�?}����8��9S�2��K_Qj|ǩ�<����}�qY����!ԯ��ۚ�i�ՉLA=�\V��o�ڕ�q�� �1Ф�Ȏ�ݱL??�s�;.^|��y��*��"Ɓ&pIݴa�W1>`Pbx����	�jh`�W󦜲Z!E�sL�^P�����@���ϑ�Z)-'���a~6�s$un������}d��<y��b���� [j8�Ai�uR���ɝ+��VlR�[F�.\Tg�T��z���Z��OtV�QT$Z���U�s��0�'�ԣ$T	#J��g��w�t�.&�%	j���ښ�mbA-phZ�n�gt�콢�5,�Lm�٘JP;�x�h��q@���Բ��k��dA��qA����k�O��Ip�7�iCҚ��(95'H��ϰ>����͸P�J(1h���A"�K%
d� �*�*�$�ty���En�ru0�x-�h�S]>��S��^�~������CŁf۷��  7��5�c�!/�>�@�|�t'%��r�Rw���pjt�Ɨ[!��å�E.���ҳ�ײ��4_%�����ظ��Z�@�`�� F�ʑ��:kx
�ج�?Y��#彀�KP?Uц���s�h��@A�TJ5S�K%�ci��L�]�bK�w��mw���V��m�F���������$����'��'ؖ(!���^��d�̐���Y�g�D�H9���u�C,1T�Ko�S
�깷kq������/�1��_9�1s�{3�9�|��"�X(b���qýL������`/zt��>�,��Rz��%}��M)��n���T��#�j�܌���ۄ!�FF�^Kh-JS@w�����CkQ�R�����g�a��t�.��ȏJ�m�L$���H��`ņR�Ml�LR���{���ВT���cl|@KR��4%;Rl!���ړ��7��T�;�Pq�%Mo���R�&�^��&�`)i�Ɨݦ}o��T��+�{!�v��b�R�!���r�-U�T�k{SZ�b��bb�=��.��ASF��AAK}L��A���AAK%L�	�
�r�4��\�R�Jv��Ը4�Y+Գ��]e!�-�k7*�:o�JR�f�Y�����ۅ%}�a�Ju�O)�C�R�8�Jc&B�7�T����Y'W�Hi�5p���$R��HW��V�l70FjT�m��;Π*;9����-����o�����u��χhq��g|���0�����Z��H]�8�^
<���S�l�2'���R�k��VGN0�I3�A9�Btqϯku�C�6^$�֔8J?�OVQŴ
��B&�V�:
'@�A���?�����&c����s~��<�Pxs������/������������È���@������c�@0\�@����t����x�(�\������pw5��W:�}���^	FpzC,�0?(ض��`}ɑ����g����q٩�s�I�$�������_�;��_����/��l����'&~i�(��UH�9f�o,����͗�����u���2��z���s��ϟ�F@�R/�����rin������>�g��X�t�:iKPBcy��s��T��Aյ��T7~���yOC�� ����)JW�U{(����F����S�� ���Wѝ����SW� �LP�.*�1R-���4�x�K#AWc�!qk{GmW�N	���!�-}#'�u���c�lT���聓�d���:e�6�ع~r}������:��������*{?�~�����u�3�i� 8(s��O�EP����]Re��!ta@C���j�2�縉��F�
(���T�գ��s���ė����sH���x��k�"��N�uw�{Eph�˱!���q?H*q���,�y�e�"J��]�[7]b2��|H�١ؠ@�t��o(�N�p�cgm��3l7id�۹D�Kbc,�vq(FԶ:���|��i�v�������\U��7�D���iW�m$I�$	e�4K���HC�pBz�jQW��[��lؼN�3���X�\�bZJ�O	7�PZ�3�( !��Bj9M��E�#�cﳎ�������ߞx�[4j�q������$�%z���Z���Z����D�����ÍV�}�&,�K(o)�
���~�7Ua��p}G��������O����
ׇ7��Ǔ�kx#���sg^š��7���Sba�}�o�N�^��7p��6����kN���W(�����izն<�}�8y��|!�J=��Ja�J8y�BI����ϭ����%�j�����V&=0{���#*���j��$�Ѳ\cn��5M=�(����|òe�ڈҒd��f�h�^W�I�Ż�(m�D�g*$��V��
�0L	�_�l�=k?��",�F �a]��wg��#9d4*���O�_�ʼ�w?���S ޤ�v��V�ttI�rO�Q�ta����sL�=�18J���:[ hr
NR�;?���!8I}�ǎ@5Y=k!IuOCm�u0[��i��,�T1-�Ur�°o+�kb�	%]��d��2����|ɖD�6�՜��9reT���.{�-�nAG	����4I�pb@��u��i-ah!��m`��I�+��nc���T����kp���9��W~(�ky�r�I�S�١�F�/��N�,=��[m��%�3J�"�N%(MC����Z����ajm���m�9�2 �'��y�k�F��H�@4~��>�;�H〘U����ՙ�UH씆��"AC�i��C�_�}�F$�$����F$���hQ���,%��'H���y�釛���p��O�!��+��l���W@�
��&���|�
��V�m[A��=4_�Q�D��5��N�Τ���"x�Q�l|�Y]�B�6hqNG;TS��SA������̓�r���J{ \��x��8u�謴*���*,������&�q8��h��ב��9��YO��}��r��,�"�����{�x�(����>Ҋ�D1�Z�HS����ڢ�����������ADځ4��Tkc>?.���8�{I�ʉz,Ҷ#_g���_�b����J(�e-��� M4]�avX�{�Xi_)�:�H_��XWj]��`��U{G�>��P(�]<
R	au>�V�,m\�NKK���ڈÙ�{�J�Y�>@�}�IՁ�sd��~��9�>��WN�z-��}���-��}�|�4�Fy��#-"7�V���tNZD���*���ƕKA�y����z5�*2��4<e!���}�Ҩ�[���g��y���,��k`���������(}	�L2*EY�ܗJ/������p}sKo"s���E�Yo��k0���Q�[:�S��w�x.�0�s����[�[��]�t.�w�E���;�����;p�_���2|I��3��<    �&y��]��H�Ɗ{�ްS���vf���]��`a+#O�����VFR'�w�KcI���aZbE�M�Ə��Z�k�Poʱ	ҢQ�S�d�F���A�5�����u�\Ɠf`�����c�V��cܶ,�)�88Zi]]gE��Ҝ��3��1��HZ	�z[�|�����}��ŝ���l��O��i�.H�?�-�����mI"59r
�a���R]F2�R�h���x��԰��M{=pg=�:,�v�^D�J���=҂�����IZޤ��%-7d���i��MtS��,Z;��3}�FI;̧~���'�ya���Pm��x� �JP�k��7؅H�4M�e�Kŕ�	�N���:��^�/�:�YIZ/���{ף=��:Ͼ7f��a{k|��}]\�F4������������N�}����F�rpԾ`D/��9P]�TP���ق~�p��͖�'�W����X?�=ѧ�l&겸n��5��DR��Bpo>~<|:\�|�;�����oo�	ua��T��2�����
�GU��I�mf��I�'L���dX���*-҈/��K�J#���I��42��2�v�@- ����C-�3�l����H{���i8'���e���ė���SʥH�Q!��t[��i�xd)���0b�;'�.������%4���&��_fjm�2�?�������e"��d�_�LW�ˠO��N��Д`nRĭ�Z޲��	�+f�����d��X3��D �ٵ�Ŵ�	�Dj�c�"����yW`�t��'���ŉm��N2�E2�Fu4�9�i{B�T/C�q�G�A9�B���fN{��� o�w�&R�[t�������Y�J=n�P^�?��u���i����WdNlZTRc[G=Y(�֡,�V��>S�9�	�J�o=���g��U� ��W_���TAZ���p���y�Z�HɃ�㾂²$���Lя� i}(��*��D��g�@Z$p�A����Eϝ��L�+�Fn��tWu^ة}r<9 (��u�$l$/*��ȗ��5e�e�Z�%��.��~�����Z���%�W�&+��Â��5/�|\�IX��4g^��E	):��(�vj��Y�aHq�6HX3�ڞ�78l����Μ+�I�R�J�p�=�
���7�&�ivo��W��'����<Ï;D0
 y�fP���Z@3������˃S[� %�ֺ{���w���;	p�̨���3IQ#��_ߗ϶QQ���a�H-��&��!;c�0�l]�t�c7�e͖����$V����0ԝ%�D��<?������o�}��+���K�Ő��?ߕ�����U������pC��?߾}�������y������ow���|�����79��]y�(�Ȋ7r<�#�1#떣	ai�����c�rt%
��3��vJ.[����[��%ҭ��+���a�襎G��q������e��}Aa>C�5���r�#?��T�����'$3W�>�46o](��YC3/����+wl���Gf~���	F2�![�l�}R*c[rd)������w}��@���q��d�,��]�Qflp%	F�]hN��Ĳ�|��-uJ��.U�-�M�|�����_�����y� ,%T<��5�.R��t�[��X��@k��/����@����|�Ɉ�ٜ�����{�d��I���^��ցB:`��^�V,Tu��;����;�[���C�%+�ϳ�a��]:�c����t�F߶P󉆞�X�!m��R�S	s���ܱ{7�HEoyθI8�G�`��ר㈄�K)�O�	5)��������ww�w�����Oz�$�s~J�����ܫ�#y�`[��78�D��&�45I�X�͎;,IԺ]�a�s���K(6�X)�������̉yWyH<¡�a�=�~1��$�$5v���%S�]�ny�pV�83|�(���xE���|���-��|����` �nh^�Z�|���t�����R�ׁc1eeŹkq'���
-�(�6������k��������Sݖh�Sݼ���n���=m厐f�:��g.A�^�R�g��ta.浴
��j4����z�Иټ�l��7R�g�|H3${I�H�>\`�0��-����T�^�}�7�,8�i@���0���ϸ�{�B���~�]�ǛB}��zp��goy��_rp�F|��Zo
��$jk����.>R�V��lo��� :|}�Zo�(2��L�^��#����u�o;U����(t<wY�����<��A��zzU�*�^{�%C>6�ַ��(/H����_n�~���/$����&q��
�*2 ��#J��Q�"1y+I�$t��p.Gz�e
S���7J*��]{L�Q�dj$FР��M�r"�B��Ŗ��j��[	l�D��@�@eZ۪��Bp��L�j�2P���b���B��q�-�m��=�C�0�r?�o�+�C���k�oʻ���\�R�04K^�:�tLi��YIkI��Ĝi����X�c;^�\t�T(xfZ���nDZL;����C��ΰ^�r#��E`gE3�`�[M�E����'z� �Q�d��&J�x��c�;�-�SI~\��/����%���Xuq4�_T�ť�����P�^�A=}c4�u�=�r�]�u�m%6w��鹩Y�`�����="��v��|�v���$�b��^b��¨�����<�|X
�o�(���4��;Il�*b�^�^�H<֣�饍��K[������C��l�p��K��`���p㊴�5�/g^xi�(T�
���n�׼̲�u/��ty�rA4�:�^P/ݞzi9]"�h]�d�m^D
%������w�����2����ؗ������˻o~�H���Q̟*,܈�!7���hEޓP��� ������n�>��O�!��+K5�������
AB껕O]/�P�4o踷7���l��V+ӠS����a'�4k��f�ۉ �rתX��7�k��(���� `��)o��Li]h�U����k@S���K��}�Z�y(N�F�pj��aao"����A�a,,G�{|x�^E,l��ٮ,FX�cas���ڷ��9I���^�o�(c�';�{6�#Q���8	ĩ���� Àm9:�� )���fevH�mX���iچ���.�$h�1$!��sn}�#;�dZfr�vTi��o��ߚ��-�-M40�E�Ӄum�6!@��F�`�!8�@��t^�+�hM^_B�l��:�u����O��p4hej�
��F2qwn��}��mS����:���rz�]���c,�T><��q�z�V	"�+y�V�4֥dW	$�JyA?t���v3ӪN�m���%]��n�F��K>�{(Y�*=�%6fq��;&�P�Fq�)Hm�k�Mè�v��B墩I�]�1^��|:и�y����a�s��ɳ�O�ߗ%J�{�|}���%�$й(�M	�k�ʨ��HYś�G]겣Y��cJ~�*�c, +�tM�,\@�(Yh�tJ`�j鈦��l�"�)ş�Bs�o$u+z�3�p�[3ZEU}�Y�n�h�V1\b�JՊ���c9vg+�k&!=�s�M�f�j���^�p��k�� pm�u#�;p8�4f)�n��/�^
���$�%;�T0o5c�V�b6��X먌jP��k��uuK@F�ʨ����R>W��@I�P"�:����[)�Q��#u �q�E2�>=��e���al	��djJ��@IC����~{;�4�� J���@T�Oh����
��Q�].��%�%�r)�Re��H�����欻y�,�k�
njSWqkY)���E�@��-KS�Ӓ��G�x`������b��B���7չ���=��R�0��o@�\����[����6�@I�CBum��V(�Ā�m�%�fh�c��fB�%�=s��$E"�f�l��WC��T��S��+�
Y<V��Ҭ>m�	
t]@���^v9��b�=�=�t�XP���J�X@� 5�0Ck��,�dAT�2H��h���B'�X|���j/������W�+����     ��z��z~/�	�Л�q�Z{y$�BJ.����,���R�y�<V2��	����ƾ��u�6�jC� �dW���9c,��oKN�BK�f�<~v�x���S�� 9�=t������w˖����j�D�GArLts
m�M3Ѯ&o_n�E�"ۭ� ���co��k$J�[��q�×�oͺ:3�&�T���=F_�+-_!R9����xJ�w���|K.�pI�:� ���(��j^�ͼ�	��y�`��������
��R� �%X.<��xu�#M/r�
V�ڮ^Gp����b:G�g��6�c�����ī5��+<��Di;!Rg���s� �4{���*������	�p��:�z���Y�E��{�]��4�H}�T8��������fn���͒�m���w��\�fpٌ{��5�ס!N*�姱�^'�ס��I�^�u.���$_���|=����+ �86���)_Q��s�LV�P'��� ��J	f ����UJN<}�8s�����Hu���t$i����[n���"M����1ʯM�'i¨��D�:-r��0�<>��ηI�mh
����!�Z��!o��<{Em��P�V�M|-V.j+^�F��M�J�#3g���rt�Ex����2�&?7j'a<���C5W����uHI<�����/!�i\��d4�p?��ө	���N�� �(X�'��c�/<�����������>�֛���n?��!o�+�H��7	��Vt�8�0/�K���]�\�1ZƔ�:7	�BV�x.݂P�:�1՛�Tgv�v�ܒ��4]VԄ�afg4(1(�Ҫ�9ۅ�%u�V!�l�P+���F}�mB͜ڙKr^]ha>�HUWQ �l�+���٨�i�VO����=����
�� ���[<�'~��?|�?M�`��4h���ĭkт��q��,�N-E��Ï܏zzu���N����hqB½����d�ˊ�;���V�8�K�n��;2k�e�/�2G�Kiۨ��i�0�hg�ԟ�l�9U����0a�,7����d����U�&�7����%�}Gl[�`ʧJ�;�0���%%w����	H�H�B?DA^�
'ޅ�tR/� 5�~�\�~,_hX�|�G��ͧ��^a��ۨ���I�Kj�c�kYK�xUK@}�l��mMHCi�u�填�?��'��y��7�q���f啠C�r��b�3�44���r\�_�9����:*���t����{}��������&��}��;iV\"��^���.p��8��g�����IC��N�`u��H��@*�Q��}�݅$U>r��ÅW�T�G�]F]�������ۅ�|��dO%C�iT�D�S5��pc�.>�D�SZ7�V�G��f��Gc"���WV��!hD=��\|
�n�%��	�3�3\�v�^T$�U�oq\���	�y��4�ܡ}\/���������J����|���>�ǽ�{�?��	�D�a�{����^b�����OM\�ێ|Bq��k��)�ֽ���@E�I�7�>�ys����/�w�~{w}u��»8݅�Eeh �~Ѹ�U�G?1�T#�mN��+AД����P�gx,�:ue�j������x�J�B��l��<P��&w�:��N/ɪ���Е�&�oVy�[��>���7������X��>u�D�EX�"I�;#[�uq�6.���Gu�21�Z+i������Ce�A�����'��֕��TL�nz�Œ��T�.a}	���}]�A�r�E(�G�A[h~j\93�Zi��~C#�S��ˢ!�1JBi��^ڻ��N2U&�&�ܱ�靤����Y�׼���E�-w�kz'i�)�������w���J*|���N^�H#G���S��d)���tY_�;E�Nȭŋ��青|'OIW�/���+���@�5������:y-wӐ2s����ۻ�4x����|��SI]?���f�j�	���GÖA��ξ!꒠d�\���w�}�mh�=M��H���o���_�0NQ��}�y�	����|���������qπKU�-"z�F�+n&�tI4�T�q��������Y�ݟ�i����ǲ�5!֙����u��{ʢ3P�����H�D)��dY�2��ϒ�5�Ա�z�MP��aNT��a���&��mz���x����~]n�F�LT(�GM�eTO�,�^+ŗ(���֍�M(I(�_�E;
#JGu���k��^%�΁0-n�����dtɐ�T���yK�HG!ힻ@|�u��K��p���
,�5Bx��b\�urפ?0P�'<W�{�Q����x��<Kέqs6�q��@@e�y_��{�����}�s�i�ƕ���Xc�4.?Ǻc�w3N�~�H3�|�R�|\�� d�¼o���sJg\��U��*��&[!�=m��kO��8��R��D�6�L�IV�Qjx�i=�h$+u)���"3�5Y]�d'��ZXx귓���=�R���+@>�b�J�=J�j��<|}#���O6	����Z�j��;����q��`�u =i��7^隃��OV�Dr�\e���2ґ��1N�ck�&{:�t�Ǻj�cZz����l�L����8�$I�[�G����\!�( ��B=�Jg����$Dm��	a\.)����������
a&��r��#��<uYD����T��`�{ܵt>�+!l>�Fn�C�|Zm��/!Ъ䟻�:��J4�F��+6�X"d��ߗ!��稂��Z@- \���~ǉO����4��7�]�W|y���[�섫���3�)Y�_ �[�8U�)[~nZ�b�E�P2p�DKW2�| lȀ��r�9�t������FQy�(R/��-�Q�%���")'����V�o��Z�8����K�3ś�#�X�Z�oKZmօ�hJ�j�v����v8	���¤R59t�>�nݕѱ��1�F^0 ������/����E��ME��`l�HW��;�46lX��%��� �%ĸ���%�� p�1n���G�T��Pv�ɑ�.��o�f45$ I�SQv]x]3�"�D������M�7�%G�.7�憏�	 ��WŻ��߬�Wu��sƎs2�$�I#� $�&5�#S�I�$<y�M����P�[Т��b�^�0O#S����]�p�o�Q�ԣ��2�������1�m��dĩ�L,�R٤���$��Kl+���%�OJ����_��cnnM�^pP�p��[$� Y���$JCibLk�T�PϬc�p;�4ќ�M��G���rC#@(�/ps�&*,�����P]��]���Z���W �I�l�]�+Ԅ��C7a�j(���=�St�²��4��ǚ�|������}����i�ْ�b��kD%
r�D'�%��
��8҄�~a8ǻ��k�<@�ʈ��,8[�p�'�i�6KT���40	i:o��� �M6y��vÛ3g(G	��M����&��.P��g,	�:n}
��l��p?����P�Y^T&	�������*;3Ē�vh;k�Rɐ���*k�e1*z�H�HP&2���ы���*+a"��N�w����M��j���H�Y�#�ID	����Y��x�v��L4��i�LW<?�?ݱ8�e�@�]�稠葁��Z~�4a�|Uy̾n�T�J�Ó;�]�*�
��x��u*�n'+(h�~v�E ��
=Ѵ2g7��yeٝ�M�~,�U�n�|����؆ٲ"��whxΰQ2 �������H�k-+�~�h�x�	���E?��x��_}�R'+��_�R ����l�3�@*E�E�}���i��Rt\���>�������_��|��Xf
_]}��\�o��+���=���DJ�T�@��D\��������qt�uA�0����^�.I: �g3��I�pC.9�}ũ�g��y�Ȍ�*:Q�!]N?��N�4��<�}���I��j*;g$�ÅU]������Qn��󋿡t&:�����ݕ>h��P�gp^o-�r��    ��2��6y�%�]"s���n
Q��u�&���X� ELfO5�A�.�7k 6��F�JG�@'�8v�wՍj�n�k������$���\��~��do�ڰ�8\I�?L89a�������zC��"�CS熅�"�%���JQP�@���?�R,��I���t��c7�Z>"z-9�F�;�7��ʚ�0��:+�"���DvS���&��������Xzh1�zd��t0��sM��G�B�և���^t�����#p��%�q�����2��(���^�8��;6�h�.������{��F����ϷyaŖNL�%M.��

Q��%��TՆ��_z	��-Q�\�v~���}��\f�aKl�lZ)H�>�BՏ����/�:�׈*<�Z:@�����3�;@�Zy��["�g[�q��#9�$�Eq��yp���m�9=�������m���O0q���y}W>��`V�m{}�\{���l���;���.���cRv,FAG��([�wA7U��-�U��x҂��Q�/k��^$#貇�}|�0\�J:K{6v�e8Gާr���wK����#)n��>Ǒ"a	F����]C0/��U��eib h<���=m�dS����=-�$=)���K����iҮ ?���s�5S|6�
�L�l�f�w�DS��Mbh��`�+��hW�e4J7�o�P`�4�(���%�=U���t�n֧T.Ǒ.��ّ�����q�?N���ÁÌ+����K>D��и�n`�̓`w�>�����t��6���E"3����pL2�I�R�����[� ����rnx���zFf\l7 r]?�k�1`oR�����V
��s���N�(ՙ�����AƋ5����jׅ!7��j�@mq����ψ�����~=_i�iX��O2V��';�� 	�M�m��9�z��i�``yx����5�,+�j���X_>�GM7]6R�Bz�9��
��"��Pf�ő$X��B��� ]>��t��F@�Ł����C���X�4��4�����ׁ��F�M��T�F:t�qX|;����It����|	F���#`�W���d�WuA8V&�z�g\</#D��)��n��/Ez��$�ŝG!���_,��wq�J!+N�5Mܷ}g$	5�Saf`��(�!p�O��!�
qej%�eb0�������w��p}���������������fQx�(m�Տd1���Kc�fz�f�����j�A���J����7��d�ʹ��Qk�eoF0dn����t*�K��;8c���0�����/m{�v�PdN��g��qR8�B����MA���f\]Ǐ�@�fO�a/�m@�%Jo�g���`\�|+f�s��j���˾��`�T�(��]0�S(⦓J����|>O�3����D^����ג`����ɟ�ޔ��/��F�J���o�C�p�x����|���w��!3�oo�^(`O�7+{>�8|�`�`�e'�vÛ�$D�ȍ6��.�(#]����'��]����.Q+hP	���B�p��ҿD+���,]�΄%":��� :�������Y��������Di>�w�U��ĩqI4r!KQNv��Ɔ(	<�b<k��g������&=݃�0�Q�4�sO�|F��秡@����faXc)Gs��-cvJnw�V����$P3�Fǁ���1�@��/a8��Z��Q�K�ro���tuJ�	|��s6�;-�<3��i&ӞBHRo:��I�r�&�<�@jf@�Ԙ�x�s��#H=��N�oϘPZ5IFMqP�3�r��%��U=Է-/	�y��M�e
��Z8���2��Qg:ŝS*��}*Wөp�,�ւ�&�E%+������|��|��W�[���o�����3_e|����y��5��w���{{}ww{ǀf0)�娵"Z�8��B[�o5H�4���n�M�\�G�rY-խ����S�O/j�f�)�Q4/���1VKLm�Pi�M,�j����U��!@��aȈ۳/�
:�ݩ4+)��ז���p4t!;#�=��S���n^g���y��sq�q/K�(M��-��G�$�>�7]����Q��w�K:�y
��Ag���ٱ��
�(���>�lt T} �W���yeM7W)���x�nz&C��7��j �z�߳Q�
:i5�ӏ��}t�jP��L���-vj5,Gs�i�eἄ�\��`���86Ӱ�JY�����%��Y�q?��#��Q5Li���?F ͩ��3��,���cҸ,p�󤴱�¸h��h1�>�!�b��Q�	�g/�t(鸥0���K��.��h��e邤�|}l�8��|�U�]�
�$�9~���1�ӂ�����q�tFұ!w��]ᬤ�!
���Ag�; �.�F�I:��.�C	�(T껰Ηp�*\�^�i�Tܬ[�X���s�l'�}~�3Y�UC1� uzF@j]���U% �:;;�Y��U}�,���	[��0�|�����e3}�Q�ggy���%g����yj���p�Q�g�����=GR���
��]x(Uw��Iy��3�T������u�b�t�"�1�o�����x�|w������?>n>����$^�}���.���������m7��KX�%M��p�24F�P)i�E���VґۤR!'�.�=Z|���5�t������.DyE����G�h�a��y/��̚F���>��Ռm��m�T�Tz�OMc1�u�R7�ý���3�O�!H�LS�u�L������8R���q�V�QVH��,H:��\A��$�5����(�h�6��7������O����c����Z��Pl�)+���W�82&o�CH�9�$x	F�Tz��lk�A�� �����.J:n(c�e�$�\e�e��Cn��IW��	��ͲK��]��K�9h�8�Gtt�}�k��s�.�X��
�l&򺋾��6z�ȹ�a��+$]��~���%"� b�再I R�CPz}�d]�T���-�_��Iڀ��~Hݴ��Ig�C�$��1�Om�.K'%�BV���y�6 ���>�&�?f�(��3_�n���bZ���G�5EAGs��L煔$]����� -�Z�e�N��c~h#�x���"��t4���"p��Գ���h'��G�0�%\`_��c*h/�*���"�4��J����T� ��"� t�t�k���b�-��~r�Cf�����7�� ���x��g�w����7��?��U�JH�s���$��c��M�B�N@w�t�M�:08�|j%>3�a�4/a��O�껿J��Awl*`���`�nw|-C�6u`��v<�[_�KX���o<}�頽�L�����6ꆉ`�֥��ٝ�s��r�k�֥9�B�/X�s����]��N�P#���"��t@m#!�	�¸H6qUP�=��:G-L����!ȧ�c(�{��;��������4cq�1��0��Ⱦl����$@w�Ɲ�be�;�q�Y�^yD0��}��^�f]�-b I�EV^7��qE�����([��/$��23@m?i��!�,��7�F(I��M�%��6N�Ԫ�'�Ԛ�$#(4�=��wRQf/.�XQ��M
N*�a*�i��T��%�A����*L��H�}n�9Hݎ���bqL''iTXS��Q(H�����M�t\p�����b��_��x��;���0��H�u������W߾�㾢��ڄj�a8	�/�M9���2L v����?/���w���Fb.ߴA`�'[PIUs5� A,��Gl�&PjM:{����ǯ����wd!U�E.M5^`�'�/-T��� �ԥ�-c�JӺ�=�*è"�i�\�i0*| ��J
���m�����#��1�σu��Q����y��FYè��`�{K^�ж�8�
1�@ ⛯�D���\�e.�FՊ�(�Ϩ��6���:(Y{}
�]�������k�7�"H����]�(�?�ؚ��fa$C���
a�jjO�]r    �%k���4k8���-���
FJ"pV%N�����î�� ���-����^���x�xK��V\�^<�P��v H;0��'�}A(i (m7���������|�4 �- ��"�4H��q�"Ϲ:io���1���BT��X�@'-rs��E�	��2 �5����e�D�BpS1���t�)P�q�¨���P�/i��㹢�,�$$O�}�%�n�3�B�I@ZC"�}l�%Plʙ!��_���o���e��c�J�5m� �h��>f��X��~}�?�����Q<\���O�_?^��� ����/wW�w����f��F���#�7�����7�6y8��@�h:+�.ZC�F�*�͐\�\�Oл���{Y/0����맗㷑F
)n�<}��#��JE�^i]��b��@aP�>i��du1%�4M@�x�m/�sZ��a�D�^����h5U����6�N`Zu1�iin��"�������D��A
z�;|����ba>)���0����4D	���%]>�S۟肠#?B+�ŘV�����I��t!�$�&@GBg������C�#�-;�E�3V�9��}H$��}m���	�fͨ��t(�*#(�=��񂎒��"�Lp�a�2��gg����D���L�t��]�>O�]��)�����I��N't�9�ى���IԴC�>DΒ��:'�RTu�آ�t�]̽t�:�7���lg����.��M\�����9%��zL�:�0��<зD�[�}x�%]��tn	AG��lZ=*�*�́ϧ�f��m���`��N^�J�o�T2Ԗ1�@����S]O�j<�5����[��%
���2�v9�x�xAA�f���o�D�dA*a���"u"�3^��.�$P(�՚9�	j*�	�ILIbi�Aò&7����kX�Ҙ�0�׍�b�,	Ȏk� ݨ^�H�w���8nTC{�.��"΍�k�t�<D�"�֍Jn���SS�>�W�j�#��r�.�g�Q�RWU袳�C-�"��C!�Qi� g���}\��t�;Bw";�t�x>�[\<�ҡ+�kQ"ơ��ї��~�Bi=7���M3:�҄��J͇� Q������K�1��p��m��ACA����?/���]��w^�k)�����4�QF��b���jd:��3��4���y��݌��²���8�yi'(9^�/Ш�yil$���
�FPEmV�3]q���il�X��#.����U]�� U=p�	�����C�4uт���Yz��>4HU��1t�!����|Ph]��̩��pӃt�vw�E���]�E��OL�]��w��v1��EiP���W�5��Vu1��EiR5]��(���y{}��(m���qRn����5��CGi)�� A��]����(�2]̟rij)(���|�6�u\2���ȧ��G�d�)l;A�%(1(�����fY8	a8YO7r���G��}��:.y4H���ڮ� 8(��(�9��G͕��rc�����$JDE�#>]}|����W?�|��oﮯn~�amVن�.���2/L�Zj[��l���c�o���>-"�S��f�9�c˖|�
���x9��?=�	),�O?������Ç��3���
�����:��Tf�c��eE�N��Xđ��+
VH���K��X�`�H:]�5V�v��ubD��*euZUﬡR��1��p
mG ��T����ҝ��o��e{>5k��J��{Z	���Gnad}K!�������W���x>M�H*���}���P�֮����_�oxTC#5eB���l��Ծ_Eg
�N����tU���h�|��E�p.Z�S�B�nڷ���X��T8�@(eG���||�TS˰�<�Y> 䵈-��㸦�!���Y� ����NJ�F&r\!9<?�bӓ���ǻ
��L�R)�����j9ǵ���[�s���.���[�.1R[�Ѱ�A�M ��5D���"H�����bŨ�L5&7���i��R�|�牪�孻�ic=e|��e����`�Cή��ْ�`ブ��J�à�s%+��|�Ċ�������Ηϧ���nޫ������?���xs�i}w�M?H6�<@��g����m���vެR�S�mV8��bC���5�e���Ec�7
b��#EpuZ;wr� �J'�+;�P7��RRW�PkT�M��D	S���GK�#��^�:�Q���P>��L6� �( �od%-!N����|��y1��������Õ�Ug��}󗟮�oB$�y��)��̂q����r���Z�qU���L�/���y��s�}4.�cVjo����^�W�=<�b>m^�5��c��QQC����qe�5&v-u˸ �>rR�\ף�C�r;8���h�H����TSռ��$		��m�=�t�A��4v��S�Q�|��������Zڧ0չ�gY��]W>������
?ݔ?���B�@�7� a��2��tsQpP.�.n�w�h�4�`T��懛Oן�?�m}���>*�]���o�w7ohj�:�%uIBE�.5�'q�HIQp�C�Z^`Ɖ֤���14��P>l��-�����-����׍9�J��}l�����R�=Dv��ޮ9�I�ֿ��Z �ć���<�gƲC�����h����t��g}~��̪&�Ů�.t��س����tx2��|R���z��ϗ_�c�]�A�롪v×����aEl�?�;�)����ߟ�Ν���ⲍ
��ʙ�+��ުA�����G��-�t�[Saђ�v�m�q]��`a}�+ݵy���`sEtk�� �*��>�~ʽ���o� @�p��l���{��U���N�����*�YFK0<���+���8e$ùh,X�P���+rW5�Ϳ�����7rJ�+/UPe��NI¬��|����ʜ�l
<~Ɣ�j4I�����s�d[4_�X-	n���)@��[��L��Xe��'D(��xʃ,�<!D��	�%�i�	;!D��	"�8�� l��y�j��'������cyCK�S7���'\B�Dk+�բ��tY,��x�i�X�P�,��@���2����	!f^����#�� �̫���;R2�7��r$�d�T�X=1����c�|�	�,sP�b%V�:��q�뺁�K�raI�{���<u���V�L��3.��t�!���k��9�%V�8g~���p3=��#_���{ ��1��fP�aC�(h	Q�	4���H��B���%@�Rg���h{ �
Ԇ�"J�@m�[:-N"�T�3qB�^B�y��Eǃ_��X!�TaV��/��@MN(S�d$�������[��S=���۹V�<AL�Rm��y�ۉ9��y�K�ʗ-�v�~EO��e*�8�R�)�H�gb��u�eq!q�VSJIGCx������J�&�.������ߞ,`�������qS*ÖAhw�f8�I��Kf����ѫ�n$�?� �)�� ��F���{���e�	@�!��oM<�~��\7+p��d�	�Ƭ۲�(���;���ճ��&�0�M�2���w��9�r(Ԋ��R���K�(�fKb�Y/�%]ߨB�|Έ�3_��9-�N���Qu�=��8ץ]��'�/3�T}ٶuVB�C,�J(Hu��<��g蹞��g�����?��/~��Jg����K/�?���:�*C����9�
�8��U�6Hh$�_��$%f,�lr�s�h�}�H���r�w91R�I>�`8�;�H!���P�f�A|;��\�19eQ��|Nh筄�y~Y<��2�G�O�s�<�rn��xS����((�ͫ�ߗ]J/��\��H.�������{�%̫�ZԫO����zE�{��2�u�{Z�o�_�|4C9tKs>uf�W2J�Ne�#��.\ڠ4�S�a�B���5�����u�*p��>�����ɝ	���-}\Z�ǻ�v���p�7(���m��=����sm�t,������qK/D#�\���>)    p�����;�PHyj�J��	����$fql�>�j�u��4�.��B�հz�D&758\�-�6@��[��)���"���)R��A�+��<���/@h	��"�Xa�HZ+�n��쵢O9���c� C�P����l�(6�������&�:ũt���$.��n=��	�G�[�U+��n�����M��(��D�|��uN9e���_�T���3�WZ��(H�����?է�ǻ���[w�S�WFb��8)|�ؼ�t9s����) -�#�?NX'+A���ՑDN�W�?��g�iE���]�`J���YS}�(�%e����x��$����ǖ>4J�q$�%��k%AD�C�ɋ�����+��Kv��5�P�2��:���� �)6P/�)c�nX�<�87�ë���<�����4ű��Ln����d�|�916�1UU��}�����S̼Y>obt��n1�1�,3T�k|'"��g�XE��{3�ߟnJ��	�1ڽ�������:����Qڽ���������'�t@x�H�����
�J=& ��%ޙ,H7F{:�IZ�4�}d�5@	"��
I�o������)j.����i	�X�K��_��Z57F��?�#���7]��������0�ۄ:���j�#�yB ��%�����kE�t��	 � A���qM��Ax��j��b�`%9�
Ñ$���R����!�yNrEou���UܦG�em���*aP�cx���� �T�U�X��*(� %J(\Y��V������ø4u��?y���.p��tCX-0��̼p)��xj����OT��׷Ww�=CN�Okr�:W��W���9�p�$����G�����?����*��!����u�M�t$	eS�޿z���_wW7v�����wU0&HT��V��M�����Ҝ����?W���sm$�0_s��m�2����a�'
V�tψx�A@\�d4�<�v�6b��W*�l#�hV���f�L�2�j��-�(�"Rp,Y-��rO (
l�e
�u�-rm�X��ȣdSp,o~��Ѓ[Rr(��ӱ�5k�1$���,�#ς2���p�$]2#�$s"��
{�z+�${֣i����9ɥX�����N�inB&�����IZ����,��N�*�ɲR�ץT~Ϡ���?n�}������on�nv�J��]�����R)�8��#"%�}�������!y%!E�1�9�����u�|�7M�	�I=�Y@ �\~���c%�ݛ�]�s<J���� ėWieӸ����Ӫ�2��*{ԑLr04@�'�Z�&Q°��sCMS%L���[q'..
Z¢�-�	F��@Sۨ���W_^���(�=��ӒkY�cruS���I��b��҅����&���������������7�Q����&��z�����_���U4��D�y��½8��a�&���'.�KVj� @4�)P0�b��Ҁ��I��$�[d'�7-�%���ggP�� :�Yw4jS׫�ѡM>���cMP���J�Oѻ�J�(�|�ͻ�{ɡf!S�8_M?ZW�8R9�q�� N AK�T7i�' #3'�Ѵ��`����l��	�r�#JH�	��A���M��s�vGP���VjU>��y��%S��p�aL���\�|���m���(ac8웼�jz8(�#Ig�_�J��_�pR��238� �EEC[3������?_���X��[1�ϑ�t�D�9����P(*�_����Z}ki�#��w��J�C��:A�fY�����t����"茏]�U�K�o߽}}Y�$;>0�t�g��A1�C]�b�yВ��籩ǚ-?hɰֳ�C�r�q���H`0E2�`�A�Q`�����m���`T���-���wA�e2F�H�]�S&��ߟ\��G�Zn�.�rޞ��d�+�.��/�����j�{�)&`p9���ɻd<��&�=_�v۩�w�� �T��/�7D� ɆX��-���ﹽrG:��.�o�*�K�09��%� ���X(@+����]�%(��s�IB�/�:<�)��G;�8�H�W銢͜D!x	��u͢�����F	���8Y0p�1� aX7Κ�:��Ź�w.��t��H?d��R)\-�<3�t�q�*���=���� �[��X)��*Y	�S��I���v�yO�\�|�|�0'���� z���X8�C���jB_�oes�$��c�4
�_2H쁑����x�&A%� O�3aAFv�IP��@��:��o�Fb��E�Ӌ�� ������G,r�A�W�x��<fL?�ß48��%���B� � ���N����~ORm�h��C��hI*C�e��-
\H�h�2_zq�M�5-��4⦸"��[��8�,�d��:�H[�H(��jL_��(����6�(ҧ�?戒�����Cy�\x�	�9	Cx��$:yu����s�h�ԏ<+a�b;������%��RMY����߿}�┨�gGDaL���b���7}�)�Vؓ3Y7�o7���n�*��JƯ�F�z$'���{���7�	=B��h���`�;���N���R���<�m^�n6���+������าpΐ΅!I���R?q��[��1Q��zz��K��J1�Y%��L$�HŐ!�¦��jYH j��zv���$�&&q;N6�RV�Uiv��H�p���� HN���\`��3�ٜA�*:*�7"5�&�I��`@/�%}^�r�'	�m����	�>v�^M��$��;����0G�K�T�U����S���ز��Bè�R��%��.f̡�����9:硙�!���=f\q1��(x���cTr,\�h6����jW����$x��uu�����Nm<G�@�[`'rx{���&�_w��=����}���������3��?������g]��0�:_�u���ra����~��,M�к�˾,����{��P�) Vꈽ��{��I�q�&i�2��T�����y~]�Qi��������/��8蝩@����@b�i#�8�f��$*�c0�t��aC��*{��K����oH�p��act���v) ���]&H0��/l �U���sd�+�1����n�H��g��[���=�JaD������)F >EDm�o0u(���7���@]��83�����5��@�B}y���$�Q�@�y����c�lV��4�5!X�Ҋ:H�zϜ-�H2�;� G��
�g�;��l`(:�����7H��uUE[�;��h�v����u+J�f-�p�9�� ��9�8�g�vh]4��\6��֘��k^�ڝ���2Xw_�,k���L��NO<��-�M���4��ޛS$Wڽ��QA֮�qv���m�����0$���k�p�}!T�o���`� c90�K0	HO�f�N~x#,�%���b%>RF�=R��� ��+CpVq����r�3m3���������
��℄�5Œ]$+�XI�ԷAc#�����t���ѽJ,��_vwwi5��6}R�Ѫ���v}�Lg���~]�Ρ���ũ�
Kw�5���J�YrF����$�������受��a%껮|Sق��A0G*m[�E��P��]�h`���x5x��>�9&}��%Iц��k�=�z��ϗ_Zߌ��#���<�3�Gj�i�9����b��\fn�>�{���w߼+Di�1<�:��Y��fU�d4謹KE��t&[-s��pnN?'���ʬo�,���X�6�UW6s�d����l�$"���&K��囿_~_fm3G�1<6��3�UW7s<|'6��/�g��}��D��$���:)���P$��3:�HƞǞw�K�Zo�>��˿�J�8�&�A�i��3�5����N}Ѿ�1�����%�	N��frg�3�v�Qh~�M�G۬+o2I�n�.�U�����4pUŢ\&>A!I��t�>s��0M��?�~��x?^�-~��O�z���H���L�f��3��.��tu������ss;�_    ���Ӯ1��6�&�;zަFr��?���yyV=�>czO����.�d$h�ؒBj�g�/d�iQ�	'I�'�BH�s�?G:Cc�*+&q�<^�F[ԃ(�K�?�b�����ʄ0H'@��ȽUE*���}ÉdmD���a~*���_���	��{j$PU�\W��(I�T�
�j���e
�� �+�3r�TI���s�!y�p?�^d�����tƒ�'��K@���ѐ���_bSf.���|�ᎱFm�f��#zu��^����!���-Z/f���+��R��|���㽜�ƭ���E";���}��3WD�����|�<�l|�x
���l��3oE3�+��h48:���yj�C�)�Æ���!f�/��#���/�U*s����8Pg  N 2�x�g�m�If�3R=�:���~K�G������&,�[�^������U*s~�.�l��-�M=��5Gܙ��wx��@�����5�	�tH�\f+�4�t�M��bU����zd3:�1H5Z:�5�#�	�FK�CX�g�B�XK� �p��2#;� x���A����W��)G�`H�'�RYP[d[Hz�W�ʥ[�|pg�+O
>�A|I�ocH��Y���������f���_����������.�0�����Ϙ�P���m�lu��ɤ:����y �C�ӫ��l�~&�m˵�Fw0��Ɲ��h2Ʒ�Kn�/f7��T�,�Ղd�IG��@z�p|3�h2���k��y�@��X	�7�E���Z��<Ri�	|�KP27�m��Ee��j΃�+��/N�7W�b��9,���M�Y�,d�/��4ݵ[%Jk*6��l�1����ir�gBY���H��)w�����0�����#��^�]\qh�3�)�m�����3��܌]m���t�AQ㿪hMϭ��>v�[��ҿN&z��W����*>�>5>��_�<�x�c��@o�|җ��,n�~Y/{��Ao����!ef|VǬ9���
Ίγ�z��2us�F�/Y׽�.o61�G����v��V}[�ߦ���~w���������2Y��z��Yǽ�N7�e��4UH=�d6�����)!��tDֿo�م�pѳ6|���6��z֦�@ZS9�2sA��ߔ!3����~���G���{߲�[Ɯ� N=�`6�9sJHE�+�����:NK��WB�ܵ�-��#GO�q��3Q��O�	W?�H�ҮvÇ=H�M��7�8s]��Y%�vʥ�|�^>)�lӐ�o�q��ɶ�9�M��ۣ���^)P&C`�����U��$h�����f�1�0Y�dY�U����T(`;���Dkӭf;��L� ���cAF�e�~�N��(x��) љ��6���7$��VXW)d�4�E���۱��H*��෭@��"AD� ���� J_A]��.���L� y�E�R����r��g�`%J&{������dBKI+�hT��(�jd2-.�g�?��*�ߢ��z��D��[Խ���t��n��dZ	"�3���L--����gxp2eY���&�	,$���T�Ȟ�d�dsK3o�4^9���LN!A�a���V&���.c y:e��N�����B�|N&s�4�_��o=3����<�h�G�V�@�R@G�<^lZ��.�Z@�c�����B�-�M=�P�@g�	�S�=��ċ�C�P��Զ�DjȡÄ����@����2�f��B�AE4���΍b
4�&5jw~9-T�¡:g���]��`��2��qoPu�[)濅��ܴ��R���㻻��@����#^}�}���n�w�9Z�s���T���,�Wg35�1�k�������ȍ��=����>�(̻_n>^�=؋;�{$��� �����Pi�y��&7�QӚ�ggŴ�x�Q��n��#�Ɯ�H��SK-�θ��$.�}Y�:~�6����߲i�W6��5�QM����>PuGp��~����������;��:�����������,�|�ӋM2�� L�*YR�*K:h�e-��d�"��)+>����;��pp�����jcg�L�&sU<��4�1��&����~�RTZ,J61�8�J��t>�)�(����t=��%�L���G���Cl3�'GS�����f#�*ā�����.��%DJ�֙���,��!�OK��۷/2[��>&2��K	ҳ��Y�h�\���	��?I $���Lp�]@����r����!c��������9���PḧՐy��џYP�;aQ~s~�2?Ľ#�qT�R���JZ��Jim3��0��^��� ̜KeӰ΂*]�f�(��\<�������+��]���V���I����K����*���<�9;�_�4�;��W|��6�1�|<U���݀c�#v^�OxD,|UE�U���_P�N�t�G?�]��?�(]D�Ŝ�CJ7�~�U|b��Ak�~�h�4�˒������(=�����V��i*@9Aeh�i��3<_���¦��|nj(�����>���<�9l��e͐�&�Ϡ]���2Qߖc$�y/ֹ2MS���s�]�*z�X�)3���Xo\���en��wN12F��k���^��Wq��#KY}�}��+��.�'\7ϱd�e.)m��S>s)��ZQ���k_�9�V!���N�gN���
�?;K�̵0x��9��|��� P�א�}�<ՈC��~�g����+�6�hmT�����3oX;�r�'>�B��:�q{eN��s�f���ʹ��O�!s!�6��3���h�`�b������w��������.v���ݯ�3I���Gt�u����ǟ��_>κst��su��a"�����3�	X�����'!�J&� �a={0Zw~�� �a�-�I�`��|�� �b=W�aW�nղ� ="hJ��p��� =+��X)쎍Y��c���� }&�m�K���(�)ԺI�2󓆒>���1�j��L�4L�|��뤍��01�)�h���s)1s)��Itg�Q��7��h߮��jw���cs]�G��������Ω���憷��- ـ�-}kh3���X8���:f.̒�C�&�ƌ�z�3�2������>n}�Q�Cs_`����֞6*�l���\J��67�d�	8t����O�X���j��f(̨*��_z]��D�^E�����L� �C��U���d��$Y�b�qV����Ǜ�[ʔdG��S�/j;k���4O���7�\P�N9����Y��'$�*��,W|g2B������]�)/@�
t5<wd�ӕ	2X�S�������y��P��������kMT��'}����{�v�JwG�=����m2�	k�N�:�Ϥ&�G�J�Δ�-��3�:͓�iև�5����d�4��R�4M�&S��፺RX>g2a	�ƈ6�;�j�6�r����W�4�p�eM,���6OK��D�U�U���L3���Kў?�d��5����W�ܫ�wW�vw���&�˯�p��_�2߾�3��m��lJ&)2݋#:�#��)�H��_�Ȧ�X܃e�����w_*��e��.!ӾH �V�۔2���h�j<��I���9������;b��N���.��E�&��y�2�t��%�Ռ��<B$0�`�/�T#n"8�6	7S�@~Ԣ^a3p%�#�8�Q�f~ ��̦<?�J�T_R3�
O��4u�B�����͜͡�����6�fn�R��z�p3�e�%�	6�o��X4�h�p3�f)QdT_��z�LÂ`�
��!3�B�=z�k��a$�FU��x�gAX }�6�2S�HpAW�nt�{�P��F�Q�Jw�ј$��@�I���%�� �T��M�=��
�`�ĐITܐ�ln汐�����͐�]$��mC&sAp]��2��@ئ��/.V�mn�Ԑt��u����95���x�M��SC�CÍ�ͼ������
�2	t$�b�6=t��Ap��	ݛ���<GZ�mn�L~���b#��s�|@d{|��o,�ɴ4�S��|�}x����s4��3S� �.�aW��>SϠ��)�����E�0.��    6�V^��^�F�V�*��@.����A3�!m�h8�)b`�mC��t�ˌPǈ4*��S�Dٓ�i-�P���FLw�PhI��D����"%���B"Ґ��X�d�v�'���Ias풓���)!�i �I'�9/x��E�=D�F��?�{�����`��'��N��,~B�?���g���Gi#��ք��*T3�0J��)���h�?[����>*ူ�D8�%��MG.n9�])�")�?�Ϟ�/�N�h*%ݷş�O�n�v����O�n� 啢+<w���t��Q�5��k�_^��w	�%��r={��>dIP������YJz:�,"�'���(S��AI��0�kk�Z��q�I%�c�-h��6�B��BO�n�E?�2�j-�M>��ʜ\-k7�&	*sh��Z�m�$�ʜV�z���}�&�r�x��7g��w�ҩ��
�f]h�	.Vz�����#�i��&-@K��Z���&�i���R"FR���޽�����%��3���K���|�Cg*�QC�h}r��9�)�Ŀ�ʧy��������:c��_���(����ڜ��6�RAK�S����|zNi����̗���m�R/8�x'h2��\�m��t��&�\����J��/vW��Q�11��Y	}o�`2��5�Mb� �s�4������������q���M����5�@x�����u�����d���Re�
�5s��H���й[���0ƃ5`2�)�l\��fEd2F���s7F29ɛ�N�v�$�[�~�Нa�_ 96:��c@[ӡ�=Á�1a�5�t���Q��P�OHPl|zʛ>4k����-�����c�W�s��N�N�e<N�Ar����w����cؕO���5r��n�BN�����P`�'M���9�@T�*�V�6�"9"Zk��f�XT
L����8��\zV .�ڌ�I�,�����Û��^،�I����F^�:k3ng�N,�[:�x��� ���Zé�:���+`�hp��3O�GÙ��[�C27)'�o�m��Q�1v�5�JRG����k��D���pP�{������7�է]�u��ws��R&(�y�V��؆���Pz +�Ob}JFG�G�N�ќ0�������d���ӑ�24����ݿw�K��Ү���VT���y�:/�ѳ{��S<i�&�S�n'}����~s��/��1��
$B5�\+��nK|f�q����L���8#�u�E��"Ÿ�V�6�7`(���鯿��M��궱k�l$��:���[�X��Wr4v+�-�p�3ܭ7Ao���='(���I:�����ܝ&���:�1R�\�p�sӥ[M�L+L��&�Ǜ?���|�����J�!����$2�<U�>9�(��cn��DNo5@5���-�	�q��	��Gj��r|:�ۭ��[�M�f^=���gX�H��#�/�(�i�A��:A@C���Y]�su��k*OE�{kF\��hm��M���������j�D��¿��h�ʞ����H�q�ĺ)��`�*�Ι���H���c��|S.?{uL�q��0��4I�An��� G���'�vul�I��ʉ����c1�f�v#�<��1ޡ��ڠ�~�?�;eE���g�){��F1t�,N��z07������ �b/���'�0L��p
�iwY3���{�o]�x�xv[�k����[� �ޤh
5�Uf?����H�`X��{�!J�`hvN����HA���
���E�W�Jʥ�/���7T�������pq��_�>\?��3���pu���4����o�\A,0ѯ��jjf�GISM �Vs���R����4���4����f�׭��C��R!`��L����6��|=�zx����u�Ucld�o/� y״�N��y�g 	 ���DKއ[�5�4f��!0���ۀ�+i�D��;�K�m��>ᰪB���|���[��mS���ވl���	mSs+�M���WzO��x�������3��ts�LJ�.�����-6�})�ϭ�$�(j���ҭ t9B�*>��6 �K�@rcHE�[�(Y���B-ɶ��Ӂh�Rv;{QK�������(� �X|�ہ(�C��B�����{ ��U�n��u�[���B��ҷP�@�׸��"��5\ݹ��(�K����Ym��(��A�J��E�\,O0 ��
D#�K���ݎ�t.�~ۉ�9.F:z�N�1��BK�b=�5l�t.u#�ߐ3�y|▶�t.T��@m�t.�)�Uq;.�H��
��F:���^���ҹ��!+���ҹ�l_Y��ҹ '�����sA�N�Z:�ܤ�6Qz��o;��œƾ��$��@�9D~)��%���I��o��QB4�@�cE�$D��"ݮ7Q�ɊJ�X#!2�8�Z�  j*Bכ�h%DC�`�s�-����7t��w�׍ސ�w�,r�\�C/RB�4�V��F�P���J�4]����A�jF*n�t	���� ����(�	JQ��\������4(ش
�6 Q���]2Q���o���{@.�6z�Ů�t?R�Z����"�$V��iq*��"1�Yh�%DC�L����	�Y�ǂ��	�gDE���fD��7�>���`C���<�(A��g�������8h��1�+&]��[u:~6VgM�W1�����.�Yj5K��U%폽\�,����:G��
��&t�G���c��P��Q�9
�Vr +;_�~ƺX����o��?�}�v�|���@	��5Ħ�ɪ�pek���#MP�^l��֝�T�ɪ�9��C,���Q���H�� ��k�x��[rUe�N�hF�J�I�I��V�r%��3����0G7��Vc�tRʌ=�AS�L�0ekϷZ��P`�!��s�.�H4�J�{j����y0�V�VO�tj�[�K���AP�����}���+��o�n��-]X/�3Z�臡��0����n�S+cE���f]q�c��B�l�6JW���ܽ��[2b4ƃ�!l��B.�7X�p[}��q������vF8N�D�#���V��� s��h�ư���Re����~���'�1$�GfFG�n�=xj���j]3�n��qP��������&{:jD1����ݦ�O�t�B�yˉ���PdCzx�Ê����e��钘��+���#0ԟZQ[�qB��K.�u`S��
���� CYV���n���(F��$�`-7dh�J>�e��|��x�C�����Z����f������ ������:H�Z�g�(���X
u�J�0�(�Q:0��-[	z������Ȭ�[��	��6R�?��B�Uߞ^w3���CS6���so���D6Ԗ�󆄖�����bRu��o��$-���)�_�[_����{��y^�����P�,4�Hn���,'��q�`ȳ�Y^�,f���V%ޮ�
\��8����?է�ǻ��Y���x�~�븩Z��>����(�.U �ƭ��Yc��ht�s�v�Ѝ�N�����#�y�/*��C�z�]���  �Q�3g��?�N ��!=?�1o*�C94>G����.����A�`!J�����o��G���4ґ�PL�����n��s{3s�\D ���<�9ţ�g� ���^T_����o��)AI �Gצ�P��&���×�~P��I�֦��^�q{u_fW�$j �O������<IN�漫2��������æYו�$�J#ϋ<�I�dI��N	J68Z?��c�#c@�����<�՘C�Zӹڌ�#kbƬ�t��m%M[CWs��ڪ��LduU�	Ͻ�DM�Q��pȯ�j&I���Tm^8����QSt�e���5�i٨U˧S�b����E�V�.!2\��y׋�V����v�y�@o}�:Ul��>������pk,��:�ٓ��=���l�*H���=!�j�m�D��`li ��qs�yJ{�H-?aLq N�+*�PZ_u��C�8�7\z�9����b�QT�]1�(���-ޮ�N�PPղz    �5,]�%Ҿ�E�P�\grD�^�7�.�,Ӵ��K���Cx�؅�f�!:+����~�VQ�������CYu���u��-�م�$�#x�r�]����tv���˷?���])�D��8�i׃fM�x��)
�:
H!�wE��A�=�8m�cUS�wB��^+����s�X�(�V�/5�	��5D���J*�P%��j�.���H�hj5y�bsx�D���K$��#� �E(�I�>J �C���!Y�A�LH��8ܯߤ���˷e<L�M=(��4���H �JUk��O?����M"@c�Өܥ&X	Yq����7_?3ɺHP Cgؤ�����[ �Ꜥ
���z`�*o�
��j6��=��2K���͚��e�9vy<Ҹ�tS�A|c,��-7��Q)��X�h8Td���jk>j�Q�=`��ك��(� ��n`�Q���O�� c,�/�$�˫���>?$�1Qʍ�%��_|�x�XZ~��%-���)H�A�8�A@��[��t--����U�GV8Y�;�r�4V7��Ni	��j����씑`�ާh&�,$���ނ�sJz�$��	2]NIoB�.�H��-4�:�u7�s��#��,���4�u�,�T�`"����ټ_v*��b%vT���<�n���i%�Ћ��<�+{�9}N�<U'�%��_.䴑0��+��+r/'H(TIU��ߋ*r���p���uZN?S�k�rb#]��R�(���aX~w��T���/��K���t��#���.��.	�I�u\!�^b��#�`2W�f3V���@hx��V|p��(�L�M���C�8cU���"]3C� �+@1d�t-�a-K����׌��H��9F�I�E4f���s�j�l��~�E	f��	�hi0��Y����+��I>����TVV�]�����t��DC�y�Q���g����oX� �A��z���	X� W���7��}�����ĸ
l��
��@�T>�<�k�y ��ļ�"YLa� f0�j��2]�ū(� 4'�
X@�ox8	���9�6��-�st��:7���ĕ�S����^��M)]D���~ba����d�b����P�J7��P���t#�ű���I��IO+��%�V�S�]�qX�*��F�������c�x���U�JG�n)VU���6�S��BC��x���]���Y���W�%_�������d$���Ub-h�h��c0��8[�r�5P	$$�dy"�
jS#N��H�D���C�Fy���h$N������!B\j`���(�V��A�*�M��c���B��(���>��q��4���|3��-1�$ujF�,�F�������f����{�+Ǡ����]ԟ����AK/�Iw�
.l��w�Y!�1Й�H.פ�{vY��W�Ϫ�I�[����WP�X�8]�q]���B�>k�_��S�{���3���N#lt�."il4%Oa�S���<���<{�E��r]�ٲ��J����q}�5�:�j?EL����\�v2\�_��6��|��z
�6�!P���ZL}��$�h��9�vW3��Ѧ��U�6�%ju2�E�M�v5���j���a)j�A���#V^�|��<�:�A`������~�p.�݉�Kn`�`�-�{������,{�f�`�KZ	�2n��c���:��"�M��u�U�H���֊��0(�|�Z�%4�����D�$i�FA�$�Ioȝ����2�q za��5��Гf^��#����]?O�u�Ɖ�K@���r��إ�H�@��Л���3��v�7^(�2C����������*����h]�{�q �j;�uq�AbI�$��Bs�md�Qłk%����$8��:�����r]�q�	��T��X<w/jT�R1��~�
|����q9��"`t&��u荣"�i�J�r�J�#�P"-}f6{�%�^��)��[�rV�.�T=�s,я]�g��JR=�`]�`�Ak��^I_�-uS�k�,��8�������P�d�Z}��ϷW~�t�w���1M���RK� 4	�z�;�h�a�% �-M��{+�Kz-� x�����$�C�w�1�dlR@�^VW���m�%0�Eiap�%�R����a�]���k-�kyW�pH����Ow���^w���ʎ%��mR�rt�����c���io��5|���G�����uEq�Y��ϡ�S8�0ol}�a_�~J<��x[\��'���$�3P#��K�8ʕT#�&�0^��D���� �@j�J���"H�DZ�*,#k.9HcX�Z�������iơ
���&� =ͫ4U�2�x}�1����ǻ��M[?�Ͽ_�oj���w�v��w�����S��h���t,T��U����q5t�� �������S�^ր����9��t�SY�d����Lo�;C���ˢZa�*	��4T�����[-�Q�W���D�&��59zJm��j�yҝ��Sdv�`%Ӎi�Za�JBz���}�N�.����J�KfEl�D�j4��B�y�qZ��X�)�(�"���a�YߤQ�8����܎Z�K95�3wzH7�9HZ<��}Zsw,���m�n_N+����,:L��`�$�ݤJ������!�O��ȃ~�˿���v�Z�	k�%8nM�/��&H0���\3[�74�q4�@����o7�׿��߫�"�!Q���娌o?Wk�0+�,a�)R$rx�����{u�X%@�	�����|u��x,���$ג�hڶ�4Q{��?�Cۥu���YY��)�;u��b��D�+)���P,xZ�$W�ʗZ�.�r?��:����݇�������UO2�� 8�nJ���NƷ�o^O�:��m� ����U�3�m��wQ`�Bwř������̘�5�1���y�$ �"e���:%^K<��V9$��_��S�y!���M�i���F���S�ɿE#� a#�o59���Х��Z	�rG��8�*|�6c
mx螩/�_��ǿ�{����W��$�~����A �H��= Q�@���&ov�~��`Ekm��=_�!,A�X���N������o.�N�;Pk��o�D<E=��0k��L���sü�2kc�(h�@�~v=�T3X	�ԭ�y��Z�Pb`�T�{1��N���'kכ27�N���]\���[3�B��>,�1O�MH%1a���)Q�������w��~������GZ����է����_�3��?.5O�������%�["]p�?�=�|�{������<�W��VA���(�X{���%L1����������)W=��7cCE��T��?��zJ��upSK\v7�z:�z�C )\���n�/�$s���o�KF2w]�Fop7I6Gd�]�Al�d��]E��֠��@��W*b�W����_Kr��f�29�*e���@~��|�|}u��tw{�i�����~��?w��&�w�bsT)x1��Z�L(�}�f�s|�R|A�����;/� �c�S�	9ٿ|������7v�տ?�r��+���͆s��
K��L_�0�$��Á2(�c񴎕��E*"'���OW�o����}�������n�����E��H��4<E%�'8ݡ���&������{XEp����Aϩ�iZ,T�G��T{�%e�>u�l��3�W	�x�4JH�B�9Y�a}I���@`�Q���DCxaa����6��q�y��!�ד�P=������~�k�4%���L:��|��3a�D���K=����c$��j�S���U��ꜞ�e�dS��}Vٳ�91��@m������r�* ��!�a�4]��M��6PȘ��x��g�ŀ�M$ 	?�<�4I�V�	�AAgυ��j3trA	@V���P�l=�Vr<�y�ɲ{=���mힽP���p2@�BS���æC�gB)j<^������n�{BE}�s��|D�sn�R$����x��8j�ғ����uG(�	1]����/����Y8���Lx�y�vc��    �ar��T�]��������Sd�������`/�}�v_�1D3��M���a擋��59�t��~jL�A�L@�Q@B!�t3�:�?���ݸ��
�"�t����
���s�s(3�fA�� ���G�=�Шc3e����I�	{��EFo�6/`�����R<ky $&�T�c�u���9���$4}�%��]��|�$闆>�+d�[GmS��=�I-�$`vS������-P.�@6Cu��k���EI���2]��$<���,�t����|�3x*̛��l�JF�҈�@�{za�.��xJ��Sӈ�9%J@�f�0��ni\� a���$�=��t:GE�v8Ǻ��tF�]�i�=|�t��x��Jנ��>T��n&n���]+۩9[�Ht�Ar�t�^�����(�q��
�W=/7kn R<��j)x�{��/W�w�*����r(@o�f������8�����=^E�H^�/����i,�x��	@Z�$>���S���ژN�PՇh�#�%!��~IRp8i��L"�XE�Og I���ˡ>��$#[M�
jA���H.�� �k�dI�	 P��^��K>�B��"�'򩡒;����߿�?���o�_ת���W�8%[[₪�,�7���	�s�S������t��D��l���FS��jt)9pŭJ�7���Xx�aV��r'q�����W�q�4��>�"�J'�K��(Y�k{и��T�}�$�RQ��W�K�t+��r�tYS��+J����F^
t��p/�D�c���(��1QK�[y뙋�G1���Oܐ����6�kb�D*�JN]��3Z���}��C�9�*a����9�`��Bt��Tا��v�<z��P�����!��O�Rw�% ��6��S��`�kP����}TZ�`1<��>�\���@�<��Z#�x8�������Y��"' i�þ�r��,�b>jv�a�AP����� ����~����|�W㨼�µ22(+>�F
먰TM�y�ߐ���0E�U�3Ԟ�'�0�����
m�H���8��/:�Z�@�������Ƿ�җk�ZK ����I�r1H-(f��r��r4�o~JiH��.q�C�Uh�k_����˯�U4�OA��Q"	�@�C<I���f��*FO΄�Ɗi��v���H�'�|LQ��n�c�蹶,nk�`���z���r�G�n�M���rG
ȏVK��r,��=�F�5,z>^r�$V�Xy�Փ��Y�#�����~0�㍗O���=��1gД��k.�z��I,��R���7�y�����qV���ρ�t!k �8V^� ��"����6�U��d���`eN��A8��nv]�<���f���O���Z�[E�/����6�7-4����_ρ� 	�j�Ҏ�kQYu�%Q'�F�o,΄E�DM��H�n}I�	����Zl�.A���������
�Xj�J�-�s��rNcvw�ؘ��ɬ�0X�H9�^>��aۥ�����g#Z-�G�s�����d(g�=H��J>l���V�R�E	ֱ�~�$X'��k2i4l��n�o�<�q{`�wK��z�����ǃ=\��tm��zt/r�G��@�I��J�T_\�ō�J7���D��[�~��:��ߙ-��(�L���^�'+����t`�
N�V:���Ǫ�<.X�dj�͸M�J'cy��!l�t4����x���`��JT��*����^	,_�6i�̃*|�����<X�i�ʚO��{E�Zu[�u8齐gU��U:.�6C��P�PәRj��I���'�HR�Ȫ�a!�p���4@�tV�S��&S�^:+���0~�II��Y�̐� �I��Y!���Ő�گ�Y%�)^Qf���gΊ'M��UG%�v=V�|�����l�)�V��h
���>����3��7���i���(@$G�\�Q��ȿ��w�~m�t��LM�F�:j1 �ǝK�����Z|?rx_pK#A�,���
n�T��K����@� ��ʹ�.�@�`�QӰF�3yò!�vNs@��(�u�F�a��!@�-�aX�9��M�K�V�9K�ܩ�9+��/*�Y�:L�7��?�s��� ���WG�9��FE-�Dv�.W�^eE��o����*�"�H�Ø��#Y�+�W_^��R���G�{��� ;������}V�:�v�n� �GW������?�ۛ�Qz��O���%��6h7�FV,���n�4._1�xL:2N����X���~�P���K <��۹U�3�r4Ż�{y%C��2sÜ���	sP��kk���s�,�vs-��D��(��̧'��Q�^��n��\�P��pk��Tr�2�9����hf��J(@�s����(}?��T����DVۿ.�@q���$�������Oq(7�:U$ I����4;G�b)�h%��x�.�f��k��`��ԛ���%������-V=&��d�:Y���K^GOR��exI�ԙ����F�Kw@z�4$�<��t&Ԩ��\�7.]˙h�L,�\T�P�JKOd���L��H�eY�)kb�(z��,�jȧ�����nbʪH6�^:�z�H�yNp���t}���2o���A	��Y%}�`��%�
��5K��,%##O9���S�����a��ҹ=�b��&<!�cB���=�E��z�}6qlLJ��
L��KQ��@u�o�NP��B����=�	��8	�9;o8��jc ��ru��X��H�GV���҉�.�����hn��5ML��=~�t�xף
=��M�hH�>ݪ'*J$l.�F�()�:=6/��5�ם�c|�
�h�].YQbu\�l�u��]6��?�n�n��uۡ{zWWT��0E^w�����a����Q�� �G��ӝ�_�ϻ�_~{���S{b�t��Y�&�CH^�Y[`�������&���_˱ێ+��K��&���ݛ�_�L�W��J��0�e��z	I��6c1�b	9JE>!?�y<��k��	]kt���+)*(��VN���fڢ_�ٿ�L�43�)�5�.!1I$�'���w)��m�g�u���h� �3*D&Fͱ��X��jT�fT��6	v` �	��u�	� �V��B���|=�@z6����q��xQ���jw[^4U����/����9L����əZ_�	ΨZݨ�S��G���ta2� �w�.��
$b�v���(�(�N\_l�.�F�O���2���H�4�i� ��{��"�`�({
v�9��יִ=+c�uZ�㕀A�U��aQ���}�����`SMa빑�p��ĽZ��.ū���������O�_w�7�HS�:<9(a��-u�h�YcA���
�)�L���%��}�����������F���L����� G��������	�J,�����8)��j��Y��~}�[c���`G�g��
H��`����i��d:�w8�Y
!�~���O��_��mQ�	I��t)xaW��̠$M��RDP�8���Q����՗�������S�z!_6eO��/Jӵ��J�o�9�2�	}��$>����
���-C=N�<�,� �vj
��S���qyjV܃�@�T9�@�D���B�O��5��Nc�]�\�S�b��S����S�S�����W�2!O��O����y���~�IPBG���W3Fw%0Z�1,��U�s��rkF�,S��b_�Rp�e�b%��X��׷����>Nc�D�8'�Q�����Y7���~���o.'�z�u�c�J�Fx$3o�=z��BF�����$V��mX��c�Oc^��/:��R�Pj�I��s4��Y=}��a$	�L����g$
]��d�ĺ��9�U�ȺU�E�{h�����Ǒ����dLEc����Rʪ�4K�TE4�.��=$��c���@��9$�B-E������A�%�WMo{�Q9	�dU��Խ�A
�+cI�tUu'dǪ��|� �l��9=�C�MpH&�'e��M$�&�t���M��]~_�"�S-��T>x�dUsH    JM ��4�.�^l�HJ�,D���g$��CRj�y�k^��w��5B,���lJCB��G�' k�H&����v��&�?^�-�_��ӄ��C��A��Y$�"�m�RS�����U*Kwi~��k�%Vj ��g��"��	ڰ�l�"�M�z��n��ՄQ�u9P�����[b5�u��U��94�ߞ (�(��H��E����py#߾�+�2�`���J[��}��̈́�AQk��|��`�ޫ,n�e V���j?�xB�	����D/}�x_��՜Dy�t��1^|?�K���p�B�'OihN��=B�1���Φk�n�$o[U��P[-@pb��j7%䞀	8j0eJ ����gp��=[+p��T��O����|op�d�$�Z�t�# P[/�FZ^�bK���nX����$���i��N�{{�GQ��)�T�4+�l
����V�Q_4���@}3�X8�A�HqPUes���Y>�(��(�������U�7��Tp�����%�[�^){�]���*̪�.��.����>����?�n�_�)�Iw*����/6���3�˯�HX��� ~
+�WC��8B��J++J��B��k�������B�Ǻ��i	��D�&�9�la��u��A�`��=���s@��ʒA.̚,�A7�t�m�+��	Ձ�i8��	0��ZЦ�6o��_��q}���xiw����??]�>�H�?������=���_�űg�?��su�p�%D'�ꔱ=��"�=�0�#T�|^�E�*}������[��1I�̻n��wh{�����*.�
�ص���pQ������i8��"��u�Ngȁ^:J�u�ݸ�L~�t�H�&���cS�u��^���bS�� ��t��y���ǋv���*�襦�|��������#}�c��}���Q�0��a�Ȩ�F�(A�V����e'����U�txt��CMɔw0D��Q��lO�BXpǨ/��J �R�!J$k^��  ��MJ>�'� O�Ut'K����QO-�74���y�95\A.�O��d�zx�t�A�6)1�Z���[��	�G��(�9���ob�UP�7�S ��U0��{���æ9r"5-�S����A�N�3�Qg��A`�to��/6ķǎ�z�ˁ �K�����'y4{b��{p�ʦ-C��ʅ�1H �'����9��L�cM�k��@`/L�r�!���o׷����0�������������^�e)'��f���g3��YtkK-�=w��1��j��y=ȿ�ݾ���q�xs�����s�?�=��#�o�����E��T����Ө�*��w=�5J=	☊���0J�f��٥쳮8FI���8W���o|FIƯ��tMpEb�$�'�7��M�k��$ݧ�8Mi��t�͡%�.`ߋ��{�4ZR7h���tUsHN �G�I�+��sT���|JP�"E��+#Y�z.��r���2�Mm� �f&�(iI��4�*0�dUcH"E�`T�O km�dT�D�><�"SN�$�MI?]�m�?߮&|_o�dT�����u1�ɨ	I��Y�F�8��`8l�<��!�ԁ=���Rr�+�x�=es$�"㌁l*PLM=�������������ư�]�M��b�$���m���%��O?NJ'��UC�)å[#
$G���,P�����A^�W&1�*-�X֜����Hf�rٸhBU?�A.I�4 <V��|F�:= �ʪT-�(�ʪ$	ֲe�/�c	K��I���6/&e�H�%�XK)�"��B�m�h0� �s-O{طH�8E/dV��\�x���su�]E��B'�t�+�pH��_5�.>�>�{w������ݢHA��R����i+I�"�X�@�=����%_C�r���W�=�҈�D�*��l��4"���pn?>�ܖn�0���'wvD��A�iw�� H�<Řv���JT�{&�c	9htpgο���1L�s�wcy�Hq��C�XR蠠/����3���-�5C��q_<K���(��Z���xhd��ؽvc�ӸF;��'��48��g�Ѩ5���Kjd}���j�$�svƉkw�>a	��� ����|��w�-u�UH�=h�Ϝ�f��Kâ�J#��^!�Δ���i�»Vd�i�@�����ͥ�}l)헾?��T��`����%P���t*�bIz����$D�/,N$���՜O-j�#!�dw�)`� @� �c����;-v|n��̸\�cA���w�6�v<�����{�f���	�Z��9�"Ś���r����9Lt�f���YB�IN�4p���=w�{C+j����:W=�xɫ	I��6��1����Y�n�����[?^Z����%����X�������v�ﲯ'�@��H��m��6ѓ=���y�(p OArѽz�՗�J)P&��s�uP|&�9��H�Z�����X`�w�pYG}�͋Jp:X$�HQ�����{@'������1��~�-m!�xl�	J"��ؽ^PQ1kC�#����JS`��FB�t�|��=�__�����c6�rm{��h�R0��z�
�I��%S��������x9�>k���r �Y��uZ0�~"R��k�.�>Cȑ�+)�Կ���Qb�A 1������FT	��(�.���u?M�~&W�.f�h�Չ) ?�F�o[��C�~�֢�h%�v�D}�C��MP����o\� o�?e�W��w��E@����N��z0�ʻ�b�sW�K HI"k&OZ�^ABqT}�ͼqAss4&�1��.(%Qx�DD���JR����#
�]P��I>�R�'����f;_P��d]@�����P���%4,�ɼ((���9]����[�|i��X߮���+6�����%���{�%)�F
lq
%)�*�
*��<����o_LL�?[��Hq�l��i��W$u	ZR<��r�i�8��@w��ГAy�������N����1QBv GJh�Ԙ����&� �S��E>q'f%0K��ҟJ`�����Z�oYś�1�ɧ�AB�4��	�}��BS%?��)���^�T�3�0� ���[諺xP�>ڗ�v�
6� ��C�	p����^�X�������ک���X>�m|���y����N�O�v��+rn�$�����~�X�Xi{�j]�8�����wM��цmo0'��jl���;5�%c���6ۂ��_�qOAf�h7�? R;�1�k���CH���	×���釷_��^�C�e�$p�٦�[���u1(�ƭ���1�(��&��)Z5�gr���I�	I�G��,jIĖ�gkըR֐Lq:TT9W|wH*FGϗ�D�"�8���i�t9� �P�FZV�D�E�JFMh�}�"�[�v	ձ̟��d��aM�̓��W�~���B	�F8I�����reOQ[�D��7�1���P\%���ŕZ/A8�2MI��?��+KD6�P�U�i���w�ˤ<m�@<���q~9�$�@wӼy"	��|b]�ܦ(ٔJ���yr�bcH2՜y��rܪ�|�y�
��J��֐t������+���dɣ4��V{�V��$S�6UЫH�dI�T�Ut�YC��a�[�P�6��P*���4�r'��u� =��UM!�P+D�S�$�Ri������4�d�0�x(̠N2�a�>D,ǠN2(U���M�Xlɠ4��?M�-dɠ��S�cb'I�F��ʛ��j/��ifE�V{ɤ�;~na���ߟ�E��2�/�^�i�>�6t:@V^ɧ��M����|F��H>���X�:"-iɧ��(���C�i� ���B�?����q�؇-"9���M�]4��E�*r�>I>����d�m�s:b��7ք~�!"	�W	HH�k�[e��	�Y�G6��5��o���	�Z�ǒ�&gYx�I�����\ I�����f���o��x���Y$�"RFƺ>4��E�-r+�����r�dL������U��,���F̳�>�x6P�h�,��V�T�(�˵�*��=��Y�& �  &Ǒ���x��-�DDS4��V� �	ل��́	R�J,�"�.�@���
�H��B���\�$��r��S�=Z{�Q"���TO6�U*a�3F�-0�U�z�V10w��[d$�)�w0k��"kH�*!Ye��K�$J:�)�����!Y�������y�s"y�ާ�Yi"��L��P����A$����t��n������\�-e�Hm�,Ù�ВK�
~-�F����t�)�[�G���%�jϏ��AJ	wY��)ׁP��Ʊ�)22\����%2"T�LUS-�"#�@������YB2(�2@��l�x[���D�x�%���t�r{S�g��Ce}�����b$�&(4��y}X�b${
W������`�� m�:K��ª��H�$�.�Cl�dP��^|���<���I�����F�E�)8����}�3ϋ�R �ۧ������H:�}X٥p?�5�V�g7�AiYe�}�W�� ��57
HbRe�*�*jI����J$��C�k�@O�k_���M��� �2ӣr}XV%X�K�t���fQ�H������P�,�fI�#�[��=[�*�f�T%���Q$�&$��P�}y���e��k%�Z~� �^4���J��@�(�Ū�-#���@C:G<䭄?��l�	4�[_���ZI����`��A��k3���'ij>)�yamF��I+[R��ڌV��	�A�o���^��ڌn#+����.�H�E��J���XX��J#-b�bW�yU��Մ!]1x�]�M��N����K�JZEK
�.���|K%N��!���DC/\�����Q�M�z;%�c��WZhI���V��6��*HX���XQ��22�cH�	��-5&q��V �$�u�M�t�Z-+��i�	buO&Z�w�
7�&��s���ʕ\1���g-�br)V4�zp��RvCD$D�gF��@�t��w1q�v zI��l�R������u�d�v��K�����jS:�m#F��{>T}��C�'/��k���r8$�LT���do4�z�N���+0�J����K&G-f�+��  N		�5���\�0XU����c����P��e��N�@LZ���� )��v���q:U-W|�B�1z]Cne����>HNM`MQsHچZ��y�/IΠ��e_Q����!�!�aeowA�3�2 V5�$f ����a.��h��_��A����i�()�*�z��!Qr��t����	��Mitx�H����$�O���'9�Um")�V�P�4�FI����r�%���Nc�j�(9ղ'(<���Rk�<�}�W:�(�"uMQ:��2(�h��M:�Fƶ�, =�>v|4�>��$9�|�u	�ri�*_���/��X�zE^�˾Ɗ�ڔ�Gщ���Bl-hV5��A���S�P�E#^��t��JgXV���`�]gJ�'��,LWwǧW@Y�Z2�a--��ђT=�W���ђV�U��[e��I2Ze	:�X�$�F���W�([��:�V.wMsK�
VԒbAq��c�
VԒd�ճU��
F2��;M������޶q zN~E��
���1��(�`��q/B���Mk�v���w��q$;�\��Cm�򙤞8�y�2�2gZ����[V�
$:�!����զ���~�T�DgYDPa����k\�1v��RR����ϲlu�)���jAp��zѪ0z��S�Y|�$��M	gY��e妙~�ߦ�X �d"�pZţ�t|�Z�����X��!ϱ��1�;�8���܋�qC��&o�=�Y�:+��R�<���ޗ���~ܬ0@��W?�3X=�X��!ɹ�z*ʂ�g ���ڪ����p�bY��)����|i�?�p������ru {<�}�0t�և-Ĉ�Gɔ@,����Q���G%*�nM�,�.��ʖ�n�Xۗu>zt��Z�Ķu�&�G��i�qA�h��C����8O�Ԕl���G$��/p�|Om*�#��'�	.Oڦ��/Bq��}3m�T�G(d��6����˹��zu�tVO!��������,\�����p�e)�T�G�}v����cgk��W�V�7�'������	�����h��c�d8DCIDr~g!�B�c���߃����w�����+dο]���0��?��z�y�$�x�v����!Lϸ g��y�Sl?ð�Bz���;߼�dK� �^�M5�L�4O�oxݭ�;����8T��_���=��߻z����p�������8{��UacB��7Z�$������pF�taBfU pb$�)bENF�}��×�q��揻�-��~T�U}�O��X�8�2�$�d�������zf�ͩYe�*^�3nB��Pg&4�bܛN}Vfӟ�:^���s��~NԽh`/,�'5gOi�Ѻ��(q���S�	�2��E�yS�`�ɩ�9Sp�D�
�'�)2����U�Fvk�O�9�D���4�U��Ǔ���eé�ڰ�ǜy��x��W]�(%smu���\�(4�8��wWjꯏ��t�R�8!+K��g�6 ��8�p2��"Nġ=��G���Ù�.���6[4e8s�$�T��$C'��CEǺ֌oz�	��0���z�������U��+���ަ�Z�P��\�I�3�
�ȑ�{PF+tH�l���d����\7��Vu�!N&�~x �|-ݔ*��bT�[�f=:�u*�#!W�^G�Q�3ȁ���tJei>��-��
ke��-��4�.v�f��i���e�k6�Ywʖ�ʧj@ ��TJў���J�����>!�w;+�8�R��	Z?���]ox@� Ըl�B�W�vS=(�gd$���A�ܾ��$�I���������8{F
e��aWئ�JRO��S�*�K�+j� ����2��W^��Ӻ�`��ͷ�T���2��<�ڷ ��t��8_����sD���J�v|	��J����4��;6�s	?kZtW������uW�ւ!1��h�H�Cy�T��[{��).//����      �   �  x����n7���O�=�r/��@�"@�"��C����3�J&7�q$�Z�w�3s��p{�~zf\,�������}�|���K�#���u�ǹT�A����>Om$JY�B{ ���DW���G�&��N���OsY-�ZT�EθF#�����۷��#�㵕}5-D!ʋ_x<�<y�?��ߣ�"��V�U��&!6e$֟"Z[E
s��[	����������梹���uG1�7#�G`6|��_���@Օ���x��_~�8{�*�F9g�<���F8^@�}�;>����an���_
?��)?}�ة70cپ����t��H��
~�t��>!e����J��`�Y�3������d�vΥ���Cs:OL�1�M��}bȍJU���)�g&�cf��I�ub���0�2.�K4����\\���\]Y���h�PԢ��P�aq1R�&�����5�m���n��#V~�d&V�"i�BLUh�*�Mp�`J۷�`�E,]�<;���vG�Ɋ��b֌��j��
��.��oa��a{+ڑƺ�0o��d1�%�H�3�b�^\��o�#֖��f���ױ�q���Ahr���o��v`Y�uQ�k�2�3�A�(�,�H���Q����f`��(p��j�Y��-��i��\��>s�&���U��!m��	[g�=��i¼�V�XX�JR�D����9T+os�Qkdmc¶+��X�W�ö	�g,?���9�:��
H[�xm�����9V�y6���F3�M��?�eYԼ�ٯ3��S���c;,۷M��K3@y�jB��h(ݤZ ��R�W�)h%��j��+�$��/"7Y�Z��}�H�q����/��.l9Հ���*�a�w��6�k�?��y�D޷>�@AbU��`��|��������aH3�k׸�	ٸ-���`C�3V�Ou�������嚈�W4��i�l&�8�̌d�D�؞"1�ȏ"
������8=�y�/"m�A�= �:�=�A���`�Y#v-���v
��w)`�s+G �YB&���DZʮ��"�+9HX2�m'1��	�C����������Ecr�)!�u�,�O�V�c�y�1���~���J8�q����O2j����h8,X�%�����']�R�m�ǩ�ָ?��Na޸�4���v �ޫ������+UL�ĩG�~�8k��������Ñ�v5������.��o�r�>��kW��6���o_�����r�k#      �   �  x���Mo�@�����,,�ZcS���{ٶF��6ӿ_4;����d>ޙ@(!�Q ������RJfO�Z��"19��Kx̎�XV|�S���|7I�m�H���c��T�NC�[`��b��W8��`�oڇ��4���-�Yc���@�pz�4��P����g���C"cW��v��tg,�r�F9��0.'DN������|���eU�N����kM��r[�<��2�77�����t�Ҟ�DG�5)70ޮ�H8��S��[3@����<�#X���6���i��P�f9u;wS���9����#��v}!������[�a��X����h6�";}�X(�M�qb����C�����a��Ƕ�Xdu���Pll�3����P,���B"��P:1M0ఔ��b�?�����Z]~�S,�dI���Xm�;^D�קH}1���>vQ�����W��)���<���j]      �      x��\�r9�}��
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
>����&��yϖ��HJ�H��F0A7��.�h�f�pH3uv�H�ͦ��I�F�)0�l*�*x)�^P��6�J�k���Cv���?n蠥��@ߕ�Z[���	t�Җ���S);��m2D�hST>bS���x^��8tiIi�l��Q�+/勹���(հO���W�y�Nl�,:�X�\��ST��o�G��b��!�>�*��JF���f6�&*h��Q�Z���:��J맿M���y9J'      �   �  x���[o�:ǟ�O�/ pyd��n�4T��<U�\0!7H M��ӟ�%ĹР�2
������O�E,�`D��rl��֫�KZ���U%¾�@��}ö&�eY�e�p4�����,{�֬��ӷw��e�P<���C�
�#���M\_���V�[��b�� ���6���#:r� �0�d�P�R6۱�$�&.�L���EjtbO��*�w��c˗w%�:ٰ8�$m��[Q;�e#y�^����\���i1�3 ��<�.�iS]瞍u/����I"��=E(��nx6ƽtR���T���+�.�`i�?�F~`��s��(���G��k�L"*��B�¢��=6���������{�`�sS��=�S���r1����XW���m���~��mv��,��O%�~f�⽙�G3�>Ӣ���9(��yG ��sx��v
bg��E>�N��ۢ��,K7��넺�%g�?�9g�耆m���.��.=َ݆+ȧ	ߪ���a׏���P'\W�z�]�[��kլ�L"��3OO����x����"�m��Ü�ʣ�"J��
�� �B�N,�%�.��	U��}���*��o���`�Ƨ^*��(� GZ�0=j�L�*3/�Ģ1;Ye�G�ɯJ�_LEˋ�q���-��"
/�R�����9}��`���Z�S���N��NPL腎��4�ټ��0�>P�B+_Ʌ���O
�|$�u�` �CǾ$�{D*l�CA�&��y���GQ�KV�t�P�h6(����]6໖Z*�����k|;n��zR֦ݛ ֵ���I�[ ��K��Qqy,��(���۲;	@m(z�u��&҇�U.�P/Ŭ���}� ���}��y5�xX�N�dq�ck̶o� i��:��$L\��}��ix�-�&l�	!Y3�@ϫ+��%.g�!�A�x\u�k����n�����.��A�!�t�Oۊr��'M���N�~/Wp��=�v�@�s�������>��|xx�p^Ey      �      x��}Ys�H��3�W��D���4j��7P�	$�vk�DL���R[�[������U�(��{:�G ��>f�_��Ow�6�;�q��i��:$|G�s�/K��.�|�J�b�U��}�D�u�I�uU���q�y
��#�,��u����9�qk�Z�y�I�OY�w~y����������2[�Ӈ������K{zu{���顶�_�]\�}��?�	�9lC��8���W�������0$P?O����k�O��۾s�M�	uN�?�Y�9��Y?������U}w�X?]��Y���S�6��7����oW���x��.���&��jv�)Js&�b��A��4Z��gY�{7I��m� �U�/��4����ؤ����w���/vy����Ế{��z��ry��ˋ�ϻ~�D2.��*c�u1O�O�x�: G<=�Q��txz	\���ͪL��,�QI�`�<*�rռ������"�u� "~�#|y
�{��Qx�@�����@��V��2��(?�r<�	�h�[ ��|_��S��&�穵������-�����tvugǗ��?[��];�Z��mǧ?�D���?4����.��yG�e��bi��������;q�	�G�N�s}xߎL~{je��|?D�̛3>M��5M��y'�'�!��$��Q�g�s�J	��QO�0QH_�Ћ���9'��'v�;����8�^�R�YF�je��y���*�Q��G{xn���Q��5JuJS�|@@K�G����'$ ����K�B+:K7J8A'������i>��}�3�M�?A�s�6�]�����u�9�	<����M~X4�:���Q��\�mvL�^8�M�afQN�8��7���S���}� �il�>~҆�]j��X���Ֆw</��w��+M�H����gS8��*N��I�g���/�v)��T�}$d`��՞��	@�pIІJ��7�s6���~Q!��n�Ѣ9�ڕ�ve9�m�(�dU���� ���$��!~��l�0�\�W��U���H��$��@�ƅ%�'�=_+����5`��#0���*+t"#{	�5��8.ۛ��͢,**vP��7�r��ۃ*1�i}���]>�3�g~�K�zsi��<?}����..�������~�o���������|�A@�r��]�����2�L�N%��h�q���{\G9����L�H��F �&p�����.�����z0�F	��$�l�Z� ���)W�AD�y��;�W9�J -��$ ګ9�c|��$��L<p��aq����{�'xG�n0N��c���/�hQƅ�d�ʻK�@�8�� ^�ԡSt�6��t�玝�iy���"�Ѹ9��4�^� ������￉_/�H(�ȃ.d��I7���7�p���ZhIR��!HLV2F�X'_��y�ю%�����k+����o�J::�.e�+I(�/t�H�',���6����o�N�A$]�y�U~�0�,ʬ2���>v+����h��.�2��g/�,�u���G�����A���	OO�P끓^J��
���*��m8ƍ��	Kc��y�M�VQ�zp��Ã�M\�����M�����@wU2G�䁄?T�tu��iE���\�/���'�;���>��s�����cRx"
��^C�G^���]�ߵCkׇ ����.gy$��q:?�����'
��h�m�bG5؊n��mp�ip��	#��>Hd;Υ�AE�S?pE=AZp�_�$���Q�[eu8�"���=�0�H�8i8�}��{~����zǎёw�6���2sf����\�^2�4I-�!1���$��<�,�7D"�̖?�`���wp��ސ&U)�!�8��C���8�:���{4tBS"(4�n湠��ܜWK��gp��/O�E��M�+8�h����l�y�>��̦vͣ�Vi?���?�I��'ڨ5���V�G��;册�oR���$ u���.kpb�쪾�|��~h�w%+ z�	�R��!Byqyf硕F��M
1��|�D��DD@��!D8����d20��S�Z�l���k5Uܞ�J#���m��[wex�A���S�|�ǁ�z�O�t���Y��Ɛ�7.;q�6�;�r,�L�γ=4��[p�@,Rc-<^�b�ݻ��oJ�������(<�ap��f�B���a�gu�2��p0f�v�þIRU�l�T��v���~q���*��:�����`RxL"#���h�$����n�Q�$�DK@����,"0BS�S���ЈE��5ff7���s�D�v��ÿ������/���϶��	W=�[��
c`���hs0�gilg���z�i�b"h3K�k�??�^�7���/x�B7��'�5�0S<�$d�xI���u��Z�ï�w�]�^_�Y�]}q��m*qj�>�_2+�x:�)���G��,<�tB9��t�p]eG���x"��T�U�R�60+͍&��6��,�͇5���mJP��������B�h��x�*l��m~h��v�0�Y4su�0X���ov�|��������纲��k���^nm��&UV-��`/[�8.H�#�� �y�Ch���P���I�َm����;��SA;BH@��`]��S���1V�3_� �abMxg��^}����,���rc�����^��]�zb�y�]����6���`����:p�+_}�����o�9���}�6�b����t�2Z�yؽ�J���|i�z��m6�֝c�l��n:#;��s���E붦ػ=ʨ�J�EΪA`�c��1q�kH�ā��͉Y�x��xoD�8o����W��������]��E�r�}��u�٭�p�N�7��${�|@@v��G�KB�}C�Bm��Pޗ�Rl,R�Am/RL"�v;�6�����?�<?>��^>��� ~7!����‒�����[i
���2u��rr���\�h1��:��N`Mgy%;��UjE�Y᰸=(�4�r�7���+��$��8�$�	�2˘16@������o¨����L$���܊bUm�)"���;���� J?�c`Wfg0=c������t�l}�u�t1Z ,�&�0�ݣ "?��	w'�#�Q�����s��Z����y&��kZ�7��/�t�x;xz����j���*gYbG�b��F����i��TS#����q�ZP����q��~@V.�����vZm 5�*�o��������������uV��W��[�ݛ����*WU�
��6�̟:	����c<^���*��4�|�E�8����$.D\Z��s݀y袧��:;�<?�g>� �9�7n�(]e�n̢M"��8m�֔�ݛ���gՠ���,��t�����h�Av'!�D�u�28=�(#��� @�6C�0�YJ��0C=Q�ʹ�E8��t�r�ǎE����ES�X����	��Q�`�A����Ş���^�G$ڀC�D�JxvG�`�$����(� ������>��q��8kD��e�Xs�$#��� +q|n�>�y���sų<NU_��?��Ȓ�C�g��I4�Y�o��dB�?��h2Aj8�N�G/���h����Pn}��%|�y��5�@K5�@b��a�k���z�aÛj'��y\���~��^��S�����+++lB;�
�Tx�76>c0�8G8��0{�vw�y$N�`)~�i�d�uH����5������ã��գ�x��l�����;��1��to?��e/7��:�Q�>� ���Mu�`� �|G��#8x�u�:e2]A\�g`�6�K���N�bm��B# Ft?',Ym9W�^�7(;P��꘾��!�P߂�8�������<C�N7@˫��F�b������s�h/� �*`��������y�5&/����8�����Q��=0E��m_D�C�MȄ�A�6��d}�$:e��+0��T��"J� �����hEt�5hj�*�8��_    ?����|����tm��'c�����EG�6]"��\���(%R3��$�@fSI�`9Ν-4�i�h��[b`��X���qǟ��W6���I��[���1�p��N�*����kE�p��Ŵ�-&�DWKH�@=(c�lcZmÀ�iq�ٵ����Z�&=\�bx�7m�A/^�
�ތ�m}�ckw�`}�� �'�A��M�{�X�O�8.��^UQ�s���`3���N>����0��B�I�'��������o���|;�}��)՞PST��/�M�7��C�`w��jⲾ�����Z?��|�Ŀ��n���5cd��'ͳ*N_�C�˽�h��D��h%��0��^3>2_��-���$����.^�,RXw!�a��}iݩ����@s"!I�����]�#+��.�{]���3&���7��_����1�|S�� �I�^w�������W��T6�� �<}�����ט�n���\���C��>YD3��S �Ua#89n�� ݗ�&�`m'�U��}�cS_�ָ�(�N�w,�Gk:-�}UΝC1����|��ȡ`M���� `Zc@ )Xk:����F����u�i�[����&W:?�D�L�)Ym�׌uE��kZM���R�i��P��R�����6��;���prB�$��L��f�N ��v�~~x�w����c�1+$;�l������r� �R����1E&�#ڛ�VD���痴��[m�!D��������;� �£���)�n,U�I��k��:���m��#߈0���q��+̘�8�UbG�3l�|q���-����
���g�t~���RV)c'F5��JԻ���3�'�L<'���0�.%�*�wh�����U��$�����{S3�zym��IԜybndiϼŰ> E��\ރ9��st�/4(J�KB<�;�(#9���'����t��@��)�zS�����AtE�CB�Ķ�u��D/��8��>5�+E��,�Z����^g�:�O48:�U>����xV�~��C xg�������}bP����6�ٳ�Vh���ʁSfQWZza�F�T{�T�E��!nO*�?��4-C��=�w��p�T�ڲ��	����ʾ�1�Nf9f�������v���_�TSe�A\��laU�%��\�1Q@��E��s��.�~�}�;�Lv�g� �fEPF��%�xC�E�n�+D6��S���1��)ňJ�
3�j���5w&���R������`�3+pgv�ѐ��=���A$�$5��T�ڼ���|Hn;�ǖM\ƚ�d :_M��}�q�_~����Y�5(����}�wj�kV�X(~3��>�H��	��� �Gv�z��,�׃M��r�ˈ��~Y��"i�g չ�$yZΚ��9��.�GwOn�!ߠ��H?x�{��F2y|i��T'p�JFe������G����������k���x����/r�U,0���N�z$O�Rr�CI<g��q4{���;@�0��f�I�S����>KJ_�xG����DZ�h���^�l�Fwӫukr��'.�8�Q��WӾ�;��}��#]gϿ>�;���˿��������\|1LN/��kp�D���:��&��R�{�s[�W�B5�WW6'��5�����麣�m~A� u�	� ͅ�/��"��3	0�3��$�����_f�A��;�-1XV�c���j�m�G1=łȓ�1X����d�Co�A��q�Sl�E�i*�=UBOE�x�W�a	���0>���r|�t�f��mغ���0�ۆ�f�<O��S'C4���	���t<X��L@O1=]���pԊ�B�=�1(� /a	:��&5k����6�eM-��H{��;�-��L���B�m#i,��Cj��A� {��l����&z�m�먭��+ġ�G�.0/�
ۓ%�]%���h��֙�}�D����1M��w���gV�;��_m�����}����K��NW����`Z�CG��3�po©��'��7�w��%��Cȡ#�Ye�6sS���ܕ�f���-�P4E��ڣ�u�F��)�<J�3�����O��i�/W�TP�� �������V\�}��d]��[4�X�N�l�Y˦H�i�	&�`_1�b�Zg�*������Z��Ԥ6��ic���bh�An�N�Ǒ+Vo?��J�*.U�w��3 �st��Jp�<E�7����ڏ�Dx�	ù)NB $4��Q�z�(@�:k�P��N�E���h�M�u�����k��e)�YWsl�����I�4d��XV�n�@�A @&�8��lK�Ű�~��,�c����}���
�*Q����g�j�#�s+��7��:���
�Z��|j�P88[���$��;	�~��E����#�>oD;�����;h�=��g�)��U�nB�Olln+Ŏ�Z�(�����Fr�f5��=C������94�=����9�-�O�$g�
����[(�\
�O�^O�<�(
������M|�W��v�y���OX��A��.~T�"��HŸ����iT��!��`�z,$LѣU�Թ����h��m ���"I�6��qG��8��r�vP��j��!���8$9EK	W�����G[51�Qr��z�)�u����{��HUZ�rȗS��g��	�)2p��-���F	lY��ذ�>ݬ��!뉲���P�:Q��t��0$�DF���ߞ�k���aoOJ3ԟul�|�f�O��I�H7�1+�U��H���-:.��&�o:&N2�Q���t�����T;��껧Z!�W`i��K��g`�:!�Hf��_���k+ G���b	C�>Ff��\�TΓJT���oE/��k�� "��x��C����b����J���[�	�[��W���M���a�#.��qÈ��C�8�R�dP���;�����
���յ}zuU?Nֺ~x�z~ �n�:H!�����jqy��1>@�0��bl�a/�y��=��+�f�J��Y����}4��H��J;�:)��eZ�R,f�f��fŪ�u�A[7L#x��D�$ ����F��h�)�`1g��	�� �C鬻;`?�M*�π�m�8�}(�8�L�^��V`���`;���#�쁠��7����{�ك����f�.�p��S)f�h#˱�Iq;��n��t�L!X����1-�|G����ȃ�� 8peq��=�6�~�Gr��T��c���2%�/��ǫ��Ta�'��+{��i^MJr{m�����24�wߐ��/]G����w�;
3{�ru08�oA�<?��5]�2���AV)��l�U��룕�o�A��T��U${`l�o���U�&��	�_E��۸�s�瑺�׏ mTⓨ�{)���S_[��í��!)�p���ެ�����y��i�l����)(E��j�uu����(řJ�5�0��x��>R��RŦ��.$�i�h1�w;�����ێ�n%��L�c�l+���0�n������Ki?�y�MTT\+��XXA�����'��[�A/;eU��"3����M0R���5r-�"�����2FP)vB/$[N�Ge��I��9���x���=iv]T����Զ�̰��S���yq�a��'E�����*a�G���.!����4ve��������>�6[ވ��DW���Ȫπ�Y ����Y��zoL�38K��.q	&*�X%)6G��<���}��e5G-ҹL&��A�߹|E������K-�^c�p��u�-R�c�pd�������˂8X�ʦ5������?��6��r��3�lG��.�`/��3"��qg���W�����̻��G���^@���e�&�"���>��wt?F����T�PY��q�mϔ����X���i��\��y-~9]g+��=��"��(Ec`r}�	eHR�����@uJJ�>�rǡ��2͢��hѤ��=m	t��G�7E�b���1V�O��g��a��$��    ��,R�����<R�>�[��464�����g���I��ʏ����m3�ʗ���$�L���C8>���m,1�����bmpF�m ��Y��n�?�C#��t�/��d�ᴌ�����cfC�1���tK��n�\wm��|�2K���� �<�w�����O�M����/�V����y��m�b���`�in�3tNc��Ie� C�V�co4����~�	X�:��6�1�6?�V�L7v)��*���7��e����E�.{]!����JCǰbw��ե}�"'p9�&]j��hia��L^�^,�%6 ��Cn�ԍLcxX��B�ޙ!�V��ĩu8�r�&u:�����w?꜎6��ΩD,@��E>v��g�����h�f��=q�9��>` &��;�׳���w"�t��ڧUttP�;v��i+������؁���S�0���]PK���L����!`��Ҋ�xK��3xZ����$�y!1<�LCB�q��N7�*a���q'�_�L�E;�D�Ӊ�)*b;_��?w�fh'�YB�G�����n�Q8�f=��W�+[^����]���.�1��m��B� ��/�J�G��Fq�g���:�<�e37�4/	?E=O����p�x����n#���F��|���#R7@�G���`��-��ZHc���r�)�1!V���h��VQ�����G?�&�?�S��f���uF�fpJ\nU���Ag�R�xQL�vEbT��9K9���+^E�]*����lv������(lf֯Z2��.���G��B�U����]��u��A�l���ۋ�g�<]���ϧ�Ξ�����͉c��(.o!`����'�-s��!:�}y������!c���\�؇!�ad&O�ֺ�@
�����ŵ �V������r��0
r�ģn��,�1�Ms4b�%D���z#IA3����/��X�Ϸ���O�G[
C�V1��ᡀH*FL-'6���<-RA"'m����8�-6U$�H�����$f҄8��a~��b����ӕ��:&� �w	��nZ�=��#9��s�W��Y�%�jN��/���w>	�h����qx2���Cas��p�F�}�S~�䨁� ���ۏ��wΩ�����\
��#�h!�-�$J�\^����>b��=VVEyq��A�����(=_ϘbF��z�e����%�/��ᘤ� ����H>�7�MQ�e(���ѓ@�'׆�X_49��<���&i�Gz:�U�_T�2�,�D�EPgTk��BpT��#W\K����㈳?!����@�U����zwq0U!*��e�����c;Y�sT�+&�]�-��z%ٱRoXE	(E�@*p��:�xX^j�����=��^+��K���<���U�y��K�Q@�[���,��
U_f���ٶ�,2	�Bٰ�Bh�¡�g��qW�;�1�68� �Qr��M�[����!)�oA>k����x������M���m;��i�4LɊ7Lss�|��:D������41�Z������~��Xc�/�-�"4Dj�=F$do�4	w쫔C�%����8ѻ['!yI΃���
Z��cIC��A���u?�� q��-[�2-�P@�6Ot��A-�҆���CՂocU��Y4s86ZL��P�3���m7m�k�)���Ij��d�;�Д{�����`�j��xmYe���V��e;q�#��V��8za�t�/7��"��)^:{mO�	m��{�\ܓ:��=>rf�;s`�1�.��'Nq�����x!���bi���$R��3��}�Ї���o.l���C�o.��o��,��Dc�v��u�����>J��06c�[w?�9�]86&XHV9pg� -W����}Y���Z@{��br�����^���t�)��0�I���y�mV{����	|�&2~�����1�m��I�}jbq{���@�L}}�"���ux�3;h�'`}�óW�:M����H�|ߚ}�X�]��u�a[���U�i��w�0�Tt�ErJT��n��pM���LBm�|�%ı'M<;�����䥶�[WA��e��ܲ�J9��w�$W�6h۹[�W	aS;m\�P?���i�n��RG���O>D����F�}�8X�}��O���7@�D(�.���љhV�rѥ�<&S�ʖ�ݻaɑ�L�>W���9~�)n�Ź;' ��gƄHד3��A�w��0*d�#Kg��~ߺs��Gm�^"a���F6&�N���G6��_����#}S����ѧ���
��A��@���	�U@�����y�5���.�{A�>׼���n��Ѝ��A���N&5�� �ǎz���dl��@3΢R\xYVy�إG/8�����h�`��h��W}�̥�g�;�3�����Lg/����$e��L��`��=r0��:8���U^x���S$Z��³������D��D2.���*�����*��5�D�n3��7���E�/�v�T�v�Z�/�L"��b�N��I��}�ˁ&��g��G���fԺ�����c���ha�羅	�w{�u�c׸|K0 �b�b\O1�k�8�Y��lvz��y�����hj�p�0�L+��e�%/�ǳ��V�vQ�5�5F�$*����͐P}{����������K!�-p�dv��W�dT��ûk�����#Q��|��вe�w�yFgt9���I1��$�mū�\{���_al ���Ծ�B|�"U����4�v��f)R�y~���jT�\��Q�>
:�*�o�Z�����ڜ'�T��I�4S8��n/���Gb�"��� �������^�]� ���Eq�}�GE��iV��4G���,�[�Lp����R*#�u���(D��Q�p�&y��pr@d�a�U���h(:$��	έ�2�w�hKA[�y��f	�"�b/?��D*,u}U?�E������l��2�|V������xd�)JB�C�`{6Q�Ӈ�#Fq��i���PZ,y���w__$D�Y���)�x�ĝ��b.$�]�ͭZ�������/���dEFΐ�F�s��
:ЄVp�'�pE�)�nY	ͣ]����c����H�' ���(��a��h����٣�|Ы��N��ĽX�[�I�?լCb&
BF;�N���e���`P}��ļ9tL@����L�<r\f0MCj�Z�2Yn	\ϊ!�ƾ1ݖ="Oi�X�u��W��~��۟#�Y"?7FF�]�
�z�w�w�ވ�{"�L�q�0�����!���|��d���3�y �7M���6�5����M[�a_���w����OgY[���:�,�����zM�44-�1d��`)|��&��5# a�y]H�LUI��u�K�[q�4��:��z��U@�C�����;bK&R����Ԙʗ�V�X���L���ĸ������D�ߘaƇիR��i9���v<�b��G�k �4���1����D��'v|t��Y�O�T���6�Ȏ������9r�%4�HS�>N�cUw���]8uq�H�a�sS����$�"}q �cy�ĉ��0��BB��ڽ�0Ə�h�6C)�D$C�c�X�D�+�}��Љ�wr�m�v^}����M}��6�H��r�����M2hs}��$�L{�q�2�K�m6�� -^���,m\s\2�����L��{5���'Δ�=� �G�Ҧy͢'�����P��ۮ���{y�d%��"�������\?�_<yz�>M���w&���b��]��u(w�T���\�y!lW  �N ������ڞb�R[b�+b+ק����^�<�XB�s���0N��c-���s�3�5[���Y����=�����mu!�����]<�i�J3��L�\Ó ��
l� �M�����/���2Xl ����z;5$/�h�!�����盛�>���-��Ť�x`�s>rW�ؙ�+wgְ���>�;0ZZ?���U�\��8�1
���;9�� ��d��f��X\�LBʙ�|o6�]�y�D����N�{�q�/�Ut    ���V<����]� �b!��_��!?�`��:�ו:����4��;��II]d�{x��S�F�N� ��R��Iuo���d��Ҏb�]��.�:�*��.K������O�Bǖe9K�a׎`(»v�K"f�-4�Y*��sxR�8��S���#�?�t<a��A�0/�"�O@��	^jeN�D���>���ִT���l�	y�͞�%���B��E���ȑ(��>�s\W_iڮ���[��� �f�z�h_e�v��4�' ��Gy|Ži�!��jӫ��=�Gļ�0�V&gB���;Շi?]w��8b�1De�Y����S�f۷Qє�;�o �?H�����͈Q�7W/U��0�>�;)��h'��pY}�Dm�e�l��pz�F|`I�S�{a��kkz����x��'۠��jΔ��3a��_4�9D���İ�X�˲89�Z6���S�yahɝ���D��`�7s�\�p�q;����l��뛌O��)�p=ɡ�֖�	����][n�������vG���tϖO���,��QKK�ϐ�o�Ďh�s=��v����Ԟo�<��%�7Ѣ>�e�Ou2�'M�0��#�|E����RߟФ}���M���AMe-~���S�f:�3�C#f��P%��ͨ�He��7��X��F}i^
J�R�Ӑo�<E���w!�x�:A�1�@�'��{#������m2�%"��)�,8���&]D��VXVY*�+�b����y��/WQ����������p��G�{��Wx�HSI>���e��`f��p%��l�`��J��4滇W߭�V(}��" ;漚��c�w#�s��k�56+�?L���0�S&� �Å�(\r��|U���y��VE��l���u���H☪v�P�7�'pI���x\e�I��u�q\��<e�9�lײ�8��e9�褒���vz�t�p'�u������F++��\���k�2x,���t��g�>>]z����/C���J+��j��v>v)�Es4����Fk�>��i�`�!9�8x�������F�� ��r�$�q��L�C
8J;���B��z�2�+ 1CS�Ҿ��z$������~g���v�E����Ĩ�ID�	5�#7c�	��D����'��!7\#�R���I�R�>��E9����%~���8ѴaPR�ޞX;/�׊U��%"���#�5�jL�e9�>����e^/X������*Ni@ Pqw��y�m�.�����d=>���Cu�1;�Cs�\��tb&15UM������������4�Ͳ�	>r�Q������^^)����a6L)~cPN�I�\:q��X�����1f,f�,v(��FoO24c�$�6����mTT�$X8js�x'9�$�0*f�9D�#7�tgδј�&r8Fc����+�����}���[u��GΎ�&0.��N8�l�9��5Z^7P�bE.*e�W1J�&��J0�H}}%n�itǴ�|�����	'���Q����2͠�#`�,�ѱQ5�'��+�"�;j.�駵�^V�Pa���h�-z��Yl����o�8�x�:����CpD�<d1v�faaA�m�{M��K�%�k=�ߕ;��;�y�r�ÔL��7:|]�tfOn !�+�֒J�h V�h�9���8��<�ǰՏD3��q�z�0n<��4�)���Z�m�4�"���i��&� ��x��zL�,^�*��,Wt�S�:&s��id�)>u���<D��H9�]��r!�H$������٭#�vO�^C�֐�2颗CY�]�G�`8Г&h�J�m��[��G��n���ԝM����4�A���6�ߎ�4�)��O߳z��tζ�i�:��A�-g��͞6�:���U�sLfX��!�Ht���|tS�HǑ)
O��i��l��.�A�����'���D���U5$��r_�zp��z��h�\^����O~)y����(y�(�㏊a���)j\S8*N�d�q"�	@���~���|U�֒�m�w��0�Mja�b�gg�� ��0��	����P����m�s���×�CkUv?�����
���]����6;�3�0�c/C&���*�*6�i^���Bz\�aX�be)�}=Kca�ąeic>�9��b��blς#䲓�!:��`�&k��9��ȵ��f��Ս)�#��%���qpզ6|A
;}��`�8#������^�7��T������H�nA`/�DG6�&���C-�
��� �O��t�T�Y� ��璶�Uێ��I7�48r�`�Ӌ;Q�6�ڛ���<���O�!�F}�^��1�#�/g��&��� ZO�w!Z_v�˛IZ���Pa�j��!�W�B���ZȨ����ڪ�w�
�6,������niU�3���˪պ�������I�	@�F��ߎ�]K�LZ�N�Y�L�Id+>\y�\�35S��ps����;R���>7쵤��'|�Õ����'��^���d�����+n�R'��cyT�)a�A��L�is�;N��Z#}�q�&���Ǫ�\Ob��n���dC��b���V��f���G�c��7���VV��'��W&H v�Q��F��GJ"E9t}��7ݭ(r�3����_h�`o�~?��AE:�r%�3;M���<E����%	t��cW��qrp\����@�oM"$��}\|��m�M�2r���f�~��MN�Z�B�o|+.��#;cfc�wlA�Pϙ�K�c��ξ�)� ��T�P�>*Pdd�'�q$'��j�l`�675��ל��S�:LO�}�F��u3�i�vpB�햬vؤ�0S�b��x����H�;��N�oM�E*�^K� ?�a44��3���wH����2�^O����1C�pmWa#Wi������]�(*X�a#��Џ�pc���=P�{1Ѧa_b�|]2q��oM'4�Ô�8a��)^�0w�!ML�O�P���b�,��sB8��r8J�7�{D\x�����x�d�	��R��)~�
��f��d��4�.���\���֦��Λ�&t^9?� �59�4�q(�K�K�Hq�-d���.5;��<�,2ڧ�E�\�ӓ��|�/���3�:��ϥ��toD�+o&�B���^�q{r�"���Q�.z��	>�R0�����_��nu\��Ʀ��#���,J��O��S���\�S��0��)Yĥݖ�-�]�l>	�GP�!5�ΐ]e:ԃ�l���Y��@|ܮ���8&v����'l����3�k��΀_��j���'�K��db7���1���-��#�kw�O? `Z�5?��}������	e9o���b���Ѿ.�z�<�����t�nS��I�O�y,HV��������}z����eF;)�l�҉3�7�?�/�]�>7�o��oFM�J���h ����]�
���9֛Ї����
oh�d�O\/�n��t�0a@_��n���k��G]�H��DS��h��&.�	�n(L�Z�AwF�j!l�:��I��#j�(�6����b
"���2�֝�0��������Z����DV,���Ap�f�NB�����]�CEwLq�!w��f��vDlՔW��)e
�F4�c�f*R�c({�ش5*s���2pޘa����������2��=E�⃹,SIu�<,fq|��N�P鉧*�&��.�۽��1�[�.���3N@\=��nK7��Xr�s�S�s�*��H`V-�]�	,\��P��ky�&*v�ĳ�tUlJk���w�ٜ����4��@�&bG��"iL83dR� p�JX�˭�x�;�����=�"�H�Ȃ4ͪ|�D�}����0�L�"���M��'G�&8�s��|�!�)aމ�'a��H������CE��j�8.Ǐ`1˒�bP�,����M�
r�t�Z`� t�YW�<�S�*�`s���J\_��kN,�š(v���x��B�<��Gc��e&�,��n:[4�eE%�@;�o��(4�(3�L���� ��49�����l1���ϊ3�� V  9{H��v��(�A#��0c �5F�y���D�-x�Vh�)��d��]���rDmA���%AH�T^��Q������5�؞����>"o��U�땠1��ZeY���
�a宩�f<�n{<�ʑ���󶐬]v��ԁü�30C�}+U�9u�e�ΪS��I�@@��h��7"ѓQ�����齩X��Ĵ1qA��&���oat=u���ȴ:p|�<*橠��W��N3{��F%z+�<v m�����Qd�ˡ6�K\h
as�\\���pv�u|�]���s�
�����!{��=�
!j���jل7-�u<��%��B,��//�
��S	�zsi�y~�� ��AҡZ@��#�^0��u���j�O^nM����C��]=���z�#r;��o�q�v�Y��<Β�h��D�(�ȑ��H8n^$�|��ޠ��A�<�LB�e�=	�w�?h�
 ��8�re�ǆkj��[��%�nI5m%H� C�ҳt����e��G��Y.K�s���Y�t���?gP�iԤ�����`p�B�H�wmr�L�q�h��H�`��7��������2���U�o���s��60a��c���C�XD�g��F�1�ƪ�x�f̹5�[���� b�|E��Go�pQjR� z>���o��?\�Q�_�o�G��WV|�mm�E,6���?���F�f]�;�"�YGs_]���c��L�� ����}���-�/ȥ�9!��/!	�(�vV��G=l�{c�.���Uދ��Ա����ލ�Ǐ��� ��N�VF�@ay�M�j)Ñ���kmf��s�X2V-sx��ވ�r���_"Q+�r�=�9�a��]�t�
�����uv�t)W�׏��7���=�?^5����t��w�+���o!�'Bi���>�h�S�o�C�V�)�XY}�l�8�p��m��j!�����bL��N���?��Bt�5t¸a��ޚ��tg�&g�*8�%�.�.����{��bl��i�Wo���)plB�[90WaBFɖf]P�O\��H$[^mq�O1�����z�oLN��g3��j��!&y|0������򿓿��o���>�      �      x��}[SI����_q��vۖ$���ہ#	PMuۘ����$�A����u��Ed�ɌHZ�53�*eʿ�����0`;L�0�����c�9�xz����o��_ �n������������g}���buY�,�o�~�us������N�3�Ǜ7w�����Ǉ/�У�_; �寂5����6�_~�r��vs�m�t�pO����kLGp.�������|�s����W���G��Z�z�=7�;�n�w�a�T�.ח��������Q����?7�n�7��rs�Ԋ�(���a(Upi�\�zjP�q�Fq|�~W�W��7gg(p9�BK���B�(��h��X��<��0�8.X.�����Z1�e}��m����zS�P�8,qh�rx ����Ne�} �BX��	 <b�U����X�d]z�ۂ9����1�"7�<^_�I��C�qH�w�/!�1~@�=%�p�7�, �D�WC���N��@`����
��5�d�s��.����0��@T��D�9!]�8�,�³+"�#�'�G@H������M,��&d���v��E����.>�(��ZY뮛��'kq̜Mֳ�vO�B�6A�k���}"B� �KˌMֳ�vO�B)�:2�{,6���
�kT�o���w�`�g�7)
S��2~�]c�iM��cU���x�'la���D@�W����i��@� ]#l���`"�b��?�@DK�c�1�-��"H��#i
#�D ኌw'��ژH扗��ς�y���%���ׇ���_1��ɍ'�d�W�������RH�7�o����g�ςt�̄S]1d�԰p�1��%T�%�
-�Yꮄ��D�����/��-�2B��-k�"b��Z����b���f�������K܈�N*�dn�s���{��h�C�Hړ���_�l>n��=�-��[h�Z��a����	c�v�����@����>�Y#���/�y�w�wq��^ cgҍ��8�V��q��dj�|��!ݞ҅v�����*�/6��_F8�������z�{�������Ou5������s��c�#�D!��q��>9��`{]�������A@�~�?_o�oQP�"Q]$vO��B��Ő�;��$G��E��3&����=��
�(��?�7v�0�S�M������&��%jYF���GM���=����G�����9dB�����c*��ǆp(K �8~|��9:�nӉM�<3�,��y�����7�)$�ma"�ӗ����YGNrJ��Zcyp�i�ˊ~r�a1���Kp��ܗ��4<�]�_����������Se��Zv�);Fà���	U i?����!{P�D�T��p�OAU��=\t���T�����H/滽�;�e���ˉzT(Iz4�s`���4W�r�&����
(�N�8�b�wFdZ8U������2}�[\wq�!�x�k&�@�L*mqN�@�'3�.cNT��BQ��#f��"�����C;�[9A<��PR��5YW��5�M���`>7����[(W��1���˅^0�H�ʆ�ob_���26��j/{�� W���Ga@��<|�+�X5Fv*���@[�
���5У&⤧���&��[F��L�g� ,�� �����ҞJ1�+�Q�[�ѤBkR��)�x[�B3)]��0qD@��S)!�lG����ay�'�VW�0�D%��=�|� R�W��1�5��v�55��f��|�j�,�C0:&��٨0#5#���r�}�y|�J �.v��0(fɰ�y�t�#&�c���iF��׍�G���1ͯ/P�{��d���DXx2�V
��p_+�uRA	���p{qQ,Y�j��2*�,U�.�^(�_L�bD�y*KD眣I'���V�7��/zԿ���J�ϟ����L�b�Ko	��'C�=�\��Q�`�w��`$/����T�Fg������`S��â�X�J!Mb1��m��%i%Q�0V���^�tp�<ֻ��Г�]�{������x�e/e��'����,�]��]2��R�95����u���֕�j����ؽ����Z�HhCa�³�_���(�F�����o~����ޡx�u%��K��(�*��y�����9ƃNki�?�O ��z���Jػ�Y\_�J)\��Е�<oԖLK�����kWL��|���ܼ�O�ƺLQ[�ْ��=�bIi��ϽֈR��"��cmkz�n?�?�Ħ���B�,X2�����.��q�m���|l�M�i��\"*>#Ɩ��K����ޒ�����#���ذև$��܂*��B��
g��J¼�.A�ͲrrR����I䯓�Ҵ�8%#Tt���4᱒Z�7���!����x���H�6�Ca#�&��eR;�U'�"���>Gd,�/���2"TYע;�1��mE�_���Q>W,�(��l����~����5>:��-ޒ��B�5�(�S0�3��mC9�>���PNt?��C�-r�F�T�j:ˇRť�[�%�3m��.�PX�.`dv1VG��Q�P�r���Me����#:B���=���̠���<I�P:ׅS����9��0����P*);.>R��Unq$t�H�g��zXQN:Mq�D,���Dg��jP����3F�ʼ\�*�0I׽�iX]/꺮��!bk�wz,Y K(H�1F�6Z02���4���?t~uW�A)�������8�h3ƿwGhɉ;���>��E/�az��Z�3�M��v�RK��r���Bûh��Z�-�������h�d>�rKe�3������c�a.�B�̒mu�B�)��r�Zt�-��,2�|`��\�
JRy4����~�H�z*���Zγߐk����ǩ��PgJ �㱀j���f9�ZG�9j��(~�h�����34--���t	M(!��P��JK��'��:e�bf��S遃�W��9u�PjӴnE_$�f�bӨ�D���]d�2oNH��u����27��	?<?�
#���q`��"��������	[��w�����tJ�s!0��̀��R�Es�̰e�|��Y*��:5Z��t�C��A;���ʩ��XH\ 儾�|���*Yf�@WPKU0�>�@P׸;^J�d��?J�Pi��ǈT	u,��'!��%\5;�i#�1"��Խ�h��7QF6��nu�Dj�rF�ʨ.E�X�@4����ǹFe�IO��	̫��z��T����M���S,;���6� X~�ܘ>2\'k���l.Fs�0�p����HV�3��>0I|"ݦ��&���E۸�a&3B��lP���^�uQQ]�Bn�Н�GPf~�
�8�Y]P�u%Uԟ�$����#m|3��s�<z&��Ф��#�gq�v���ӣ�I�G��ϡ�m�Z�%EE�j�Q����]��03��,t�`���40��q�F�#,b��Y�b0��g�lԊ�?T�p��Э��%�pe �_YHZ������.�5�ߋ�[��M/3jZT�oV(���W k�\�=�/�gH�z�A��}t���T�����=�O'Y��D���3��8�'j��檍?�&��a_AiI��G��S��7�ֶ׏�U���KL ��܉��u�A@U�	��9�P��z�"7�Tjʞ6��&{�!])a��-e����ũ��`��!T��	}
����a�����NMe�ҴF�CƬ����Pԛ��!�_KX\]��?�j��OWu-�n�U�"� �r=���p�xR���
�@�#�_�u�@^�.Y��q��:`H��4|#5)=��RG��mG6����+��u*�Ġ T!����JIz@��@�ΒP�N���8݅d����0��HzR��h%s��@�Yn]�-D	�{6Ny2��"���R�sI���@	����Ї���5꾬:&)�����kw��|��?�N�_�;��T$�5YF�E���,7QQK)o�A� $$�:B��>Θ�-��VNs��`��:��    �M��vu�+M�*�-W����MQxuv�\�]m��h+b��/�[�4S�L9��0	ŐS�_�{�\݆�x������j�N�¹�#Bw�Pf�JT����u���g��,�*ӕ���KNr��:���Fx�{l���L傰]�j���齮�Eۚ]����O=Z�i�	�}V�	�K�G�}uN-�q����X�O� �SS:g>��_y2��yФ���=B��e,���X�2t������*y'���ݜ� ("�`B�B����f�ox���{�������zt���oHyV�+���޺aJ�x~����� g@j1��	D1�2���~��~��:��?�2D��W��Q���(T2�b�D�%�3R��欐� R4�T�iX��} +�4&��ͮh��E��r}�!7tEt�@�)X")"�vbItl�y3��]�2�I�cJ����uyR�p>���K,����<4�j������g�FW��G��6�v�$�7~��lp�*E�Q;W^�?' do��"o��s
c�<Y�#k9����I�v<�H�(=e���y���)��k��=u�>iQGOIN'��&b�'�"F����E�^�o��X�@v�x2U��������Fj��ʫ�ZC��O5$�wT��d��G�-��j[3�Q�M�S_o��W�V�ͬ��R��](��""�u�P��;����pQ�| I�:&���,���3�rk9jv�P�9��R���(��"�{ 
�ֵ��Z�����u]Q��)�E����	�DU�C����%��&#v�HT�U��	GE����EA�wE�{����Cס�v@���v��0 �+����L�� �I��{�#(�����%�L�{�2�)C/�`���'7M�
�,��9>�]H��B�Ud�(�CS,�JH�88Ԛ��m�O+�� �E�qTMჵ�����^�C������	Il�j����co#ܺ�?wc�.7_v���'��<���7O��W5�w�����廋��C��ʳ�$Y�9m((��"��Ò핋�Ͽ?w�շ!l����ݮEg���R�P��5-���]<��:7V�f�	<6\1�S^��<b������z�q}��A�(���Σ��˝U����^kH���s���&Y���L�-�i�5y61<0#zqnK&���W�q&yhR�R4���S/��mA�w��j'��#J]��ޫ���#B��%t�	CD�Ǿ���K����u��*	ڷM��]��ɸ�/�����@0j2��Fv���	����J�e�!%��PW:÷���I���kUB����Sxk�I�- p���9�S�k5�/k����"��"L�����q=n��*������7Y��`M�sy!��@쮅�AG�FO���#j����aHJo[:Ns@�>(%
ٙu��ͧ�D�Gv=��@g(þ'(����^��(������m*��-��+�
�G��X�{����:E-�P�ۥ���/���g\9�i;%ZI�g��m~�%]�{qs�1�S�㈕]X�#��FI#� 5�Z�@�� �Pn�-7�F0J�g�����=U����lB�h��
����P�{�������^)��q�k���������aU��m%�4/L��t+��MÉ��2W���s��t�d�k`��Ձ�����f+��TDq�	<r�h�n�0�JD~����� ��Qn KX�-$0�P]�[��:f<w6>��pݻ�h������$�~��F�o�j��^������o��--�V�Y���A3�s�]��;~��D�#���k����z�I���bXn�<-�����T�
�/��-2׬��������u��m��6��a�
�?	��J�D�HQ!wH=�$̵��g�@�-�<�2)��X�(����_1��
Ÿ"#ܞy5���[�Ԛ�&c�n=8ƌy������MM�l#/�խ"F�J���_?�k��������1Z����E/c��C��Y�]��:F�b=�)�.�hU9��>`}�t�(�0I�$���u(Sn����hkz��tZɰ�ݧ�v��ϴ�.b�R�J��P1sb��X���^�Wۍ���*M��ls4��h5<�;����r[:ţ��bTQ�@�e�b�2�:J�Fe=|��s.��{�/���jW�u��F�]��ӧ_?�FK���'�2��2�����4�&�yY��ҀJ��9k��Ny"��;�E�P�g�_Օ�n�(�x�-�v(�FU���m�d#5/��DM�0zT���w��w�<�$!5�P)�00��i����a�4�F�X��ɫ����������b�m��8�-����[�ƫ�a�a'j"�hl��pH@zt�޿�
��i�D��UU���a�8�<1�7N����G�ր0*��MM���AԊ�>^Ӊ�kY���mCZݟ#��[���Y>˛0>�y����R������J+�ԉ��Xh_���͉LFK����K@z��t��`j����i��-�fX�`�,�ƨ�e�	�����Q���IdO1O�]��m�W�m��a\��JT;-�H�v���o�R�$�,�j���jgjMUG���'�P=�tjM�pf�.Jtf"m!Ͱi
i��aI�(t�@�JŸID:�=�v�H�vo�	�M��W�̀{�%6\��̯�X7�����Hb�����Q�JJ�a�`!ٶ�ZI�&5�R�b�iu�J���1a�K���k]�y+����yC����XM��T�L�z����`p5Ú�R�4�~4��*F�n��O�
ݟ	��D�|A�vP�[��2&�A����aPS+U�A���V���n,����3�NMڊ)�*ޓ֙\��P҅ �uM���ٿ\��?�1�rG���f�p�K�,��a�L��c��N��>�K����Cx4�Etu{}7�v%�ƣ��v�C�񼿺X���-���'uR�������������EW�mF���'�m���ƌ��&cti��i{���2�3�x]�j���p��Ҝ|[��g�K� �E�rNN�[:{9W/�\���SB��Mo���R����?//���������G�t|�L�s%�����2Ֆ�;�X����]��P"6\�!���X�(�����؍�Q���</�NׂiL$ˌ�gm����HX9�� �nzf����<�dG^�j��*�fh�s��/;�^�����Q�[�dUɲ��˪�d+-���N��+X�;�!���*�}�Rf��d6���lZ��}���h碏+:�����nH���8q�ןҜ8���W�U�_��K�V�����l��v~:�I�Wl�<8�&�#h���9�(�v
������&�Ԍ�IM3̓���`�0�2W�q��7P�h�`�zeUb��|A,�3bљ	pl��8Z���c��X�wd�-�������m�&�L�RVj �EE�?�����,i�ys�`$�vt�d��c�h�F(u�͢�K[�t��a8���%хöĥ����	z�����p�!]�d�K�o���Qޒ���	���ơ�+4T��DUA9��hZ�nx��W�Kt.^;�An������l��R2�?���.N�Bkxj!�-���"��m�Qx͘���u�	f��%V�H�Jk39�F>�zK���)+{�Ld�Ҟ��^�� m��6�8�.�((�ކ�D�>%���p���B¡{�.ZV"�7�tG@h���4
B�6���R�su%ڟoO˯��'j��Z��ڿz}������[���ѷd�̖KJV���/!A�U����x}��:u�h~��}W��7"i|x�{�k��(�V�j�/��3af����n�e۷���[��(cP'��5�֗g�����ղΝm/@��� $�uy#P�i1�����8�
phR��(]?F�P^WH넉�l@����K��{,���0f��1�7L���ѽ|Z��kL�� 1�J���]k4��@�� $=��IA9�I}��)�q���=�'H,�    KT6��8���n���/�2��"/���.��"��
�=�]N�#�@�$�}�q[���s7�A��ϐ8������p�|K��;�����&-�x�:D~��F�yw�n�xv��������xQ[c�R���щ�ee7�'���'-�m���K�g�jz�RW��<�s.��o�����cB\�w��u����	S��>��lytt��<(���^��*2Wm8K��5���ۄGO5�,�
igˊ%�Ḹz�ĭ�3�3�f4ȋ ���E*��5�� ��Tי{R"�Ye���]Y��b�'�%�9�{��������:[����f�ʺx�
��e;8<]�"!2�-�I��V�_-���+�����pu|u���3W�(e�sy�
��@�\�&��)S�
V��2P�듟�Y+h��q�� ]��Bµ���G��D��1��5���.Vo�ֈ������'�V�' �1+��@���`�Jejw�H��]��O?}���������eH���7;��<����!���m
�����5k�r��Rb�����pm�.l��[�7��4MJ�i����5��%l�>sD����6y�M��.5�U������I�nޘ	8|�H���qX����bR��C.	0#
�ؚI��Bds�����}�%��;Ւ.�O:�n� �b�l��9�1�^�Ċ�������}Oh@�H'�����,�JaH�D�3Oh�䄎@8>4N��u̙�hetb���db1Z�|^Y����A��|�A�#�J��֊��/��5�kϛ�9H[?��a�3>pBo6*ݕ�bJ�2�~��l�F%Ag!��9���_R�F�D!���Sn%�+/�Z��&լUfU��#�Q0���t��*���Z(�t;v[����������7��͗�g�W��IMҷ_Y+3!��U>0!��;��!��U~�;Bt��C��
� ��Y��r�LtA�A`6N6w�S�-}����.n!ɪ�������.}{vx�\�zu�j��p�h�&'8g4��F����π��J��&�do ڦaɞ�?7E�!�,R=�Ě��B	��DBo�,"?Me��j6$���g��Z*�r�@Td�����iD�_=1c��d��7�l2:z�b�.����z/���M[�	�����i���Ӓ�_���Y�eÆ����.6je�yIy��e@'@�7@��DM+���jB�`�������cB�s���P��Uɲ���қ9�د�۸]����tN�S
��Uz���EMT_@�g�W���d̠C�>�����JQ*)1H�s�2�-�AB8F5��]��])]�OVR	���.�4SH���l��͇!�Dt��N"zT-��5xI�j��_>-*�-7b��k��f�Z�����_���D'��]�1�
#VCg�&:/W!�ƈY�_��헄��Wk-�Q�֜hڋ;*���ׯ.��/��-'> �$1n����3���&O/V�X#_�)O�԰`Ϭ�`�ѩ�0v�%����F�Vt�#�Q&]�[]<�f8P��b5NAbg����.��r�1�j�ĩC���tm���Ao�lu
���]��.J*g{<�<�A�I��/�?%Ж�8M���V��!�\�/Vg痯N_]�����v�CMM���Xm��t��D��#R�
�l�-j��J��;Z� (_0|!��r�l�h��i�t¡=�Z۝�����邩�0ryxLH�y�.J���u����Š�l\Hjv��*�qr>G׺��m7�U�ﶻ�%N�M@�C���ߝl���9�=�w�֛�nx�&�u-�Q�o�srb�"�QG~�v�ڑ�s�\0������	��Ոp�����(i�^�@�آr�H��Ô��q0��}����B����LxPp�k7��qzȍUR�z19Ư立��Ut��ٛ}��V9���R��:��.�1s�U	�����>%Ry-�ѯϻe.gJ���ᛷ�������������4H"yr:�zO=�b���PX�Wz���y`��ĥn&�E�o��N�����j���tuz�*ͪ����"/�V\����ӭЊ�q
!z�C��D5�)'�&X��O06u*]t*T��F�gY/[3�(�RI�#7�)T|����4óGo��퟽ߥK�m��#��m(t&��q� �G�z��Ǚ�n�"�"�c���)��/�ޝ_R��t�HF[�6�y:�0�wx��S�]j��I$�b���&�>�)��:�)֦z��$�O#�!XHk����� �)t�M��?'�O��(K���,Yz;~$=ۙ0�98S��ҎC�6T}��,�a���g��u_`�BHtj���o�� �i6Wx�W�< q&@6)��������8I��x�f�q�w҆Fi���%9�Qw�(}Kr=e�qģ��}Ϗ〵Nt�媊q��묪(wcJa�&���fT���A�{zy|Rc��iJ�1���v�����h�/�Y�I�)ғ-eoO$K������u$(�Ǭ��c�z�1l�p�1Yb��,l��������$�*q�	<������!1��8��#��y� Sb��ge�]�]6�m -% ,��F$��A�U�~�J���t]��
F�B��&�4��sζ4��Yf�Ґ<�Y&��R��2�ڥ��Kh�F
�����?�O/��k������Ǜ�Ű!)�&9�$�3�	�e��c�E�R����M�a�Y{��ؑI��C����NڹB1o�l��UD|&�̖�vg���G4|�	�oos(����V��EK�NʶW���f� b'!Jk�P�*cw?ҳ/����ߣl^PO��SH��mTϥ�]����*�hf
}����Pǔ�z�_~���EW`�c���d��ۂB/p����쉀�9�=G�T����G:!y�{�uO5�K#i��s;_�@`�]�ܜ�BT���k��!f��D$��0Mk��@/���C�7�:�pE������}�`� R�z>��F�T�{�=H �{����*��f��Ћ������}��c���E�Z�D�]��]�֫��p���Ћ���`��L��mn{=�V,�S�m~�X\שQ�U,��i�&1q>O�����������+��������r���Y�DU,���X���T�
�4�¥W�����V������.`p��K2#_Hi��۰������ћ�+u,A�w�*p��9�;6nm���|�_:��WI�9E-�uS8�	��$�'�ԶD��k[cz��!�gIZ.Yb;��&k���L���V��My��N��^8���?��Fi�S���V�,����aq�6ze=�9ZƼ&+�P���m4CՔS�QkX�K���?��g�T�4׮����	%�os�P�f��܆��Kԛj���9_�,�N��)l�d�E��xEv޲:yqu������rl�7����C|N�L��:��;qF�;���N�E��[��X��XL��<9��b�jE<����S��������.S]�g��5c�$��q20��k\�o�'����ʟ�t`���Ul�.a�|i�95+���d���e�fx��`Edi�ߕ^��	������@.�歙/zI�U��z�M��)ې�n�G��P�������9�Bަ��i޺�9$��
=$���7���u�|Ts���|��������c��#����$:��������W�K�<<_�ϗ���z!�N�:�����U�����At#ӄ%�� ���A���]]��N`L���o�����p6�q$_�1�H�0#�]�-�?߿��M�,�t�":i�����ɖ>�����B�)���.��݃��<��<�7�-�+Ub)jG��U��^���`PW��>%D,�[�7��] %o���XAw����xE9[� Q{�PbY��}�!T�:�6�>�QL�E�+��M��i��b�p1$���֢*a8A�ש�n< 
cE�L��N���8�O����oh��>�r)+�I-�:o����Zg�s�i�j�Wru��1a�cj{/�Nv9S�j�W���ט�[���|�]m�299�H�n=�ƑاUb�	9 �  �H*�6q���l�PAy�y�}F��/��T����添���� �����Ȯ'���}�B�4��"I�����/��g_�$/t��ѭ���ݰ�T!�|D�����g_(��
�#nkx����Im��Zh�qa<�肰���l�HD�� �@hM�����]y�:�w�7�A�I:t�ۿ#�-Usf|�E# 5|�6T�N�at���P�fF�u$�9Ma�y���Jh�х�G���_c-��5v���4�\�&\CAS�"�CO����O��Qk���;��ٗ*����֑��.�W�7��]fMϾPZi�*C�-& ���ݞ4t�������;FϾPZ0��ڎ�J��F:�Hض�r�w6E}�a��m�y�H^�y�qR8���K���o]��F��k���Й�j��#&�����2��:&�֚��I���{�35�&�CP�/&�KP�	WƆ����خ�yS����t�3��2]��������W�{�kGF���pܢG϶5\�����~���/.T���ճm�����!� ��˫pG��:W�ۻ6��(pE
c@ǜ.�u�0��/T���� ��P�6����	�3�CKi��-5qvŦ'�-4-��w� +!�We�����Ұ$�7�D���S��O�Xmt����C���-����̌Mnu$� �Q�FZN܂I���K��E\�E���ݗ�w!`D������A�H��d�.��\�]�y駨eAwFY�8xI7���:>up�S����}���������$��'�Qj�3{��	!a1 ��dkT�W� �!��P�V}����������>�}�	��D�W''+��\�B�u��Ob���|�!w���И��@�]��
I j��!��r&��D��O߮���/���i��#
�OOw	��ZS<�}F]_]����������ؼxu���W�r�����ވ9��'�o�����*`4̾������5�����..g&����)K9�T�a5��o�N������rQ혱Z��emqd[��Ō���b"���	�S��xSyCI��\��u[1c�dΦu�[ϫ:c�����n�R�=�&��ɟ7]M�#��ϟ��b���ޣ�-�'F����9=K����nĶz�"�*��4��*��OR�ggiQ��t��7	Q���i3r�<��2+n��:y8�
���pj��L��-����B-��T^c����*o:A0��΂q�szC�Y ��5_{"�veƳ�킙I���E�<C,�-�,�g����RD��E��s���w&��_�����&��D��A#�xW�h�bʮ'��$�/���	�8�4�jPQ3���J��IY%��!��}<�[�����
(DMC�*���:g\*�`��ə��7�]_�� g��������
C��oE��q_�ʫ��2��U��/��]U      �      x������ � �      �   �   x�e�Q�0D��S�	����g�L��]�Ʋ%K!r{������f�E�IOaF�T�ғd�>a�ohh7����a$u�h.J�3�̉T����a�,cv�H�mR27}�*y♂k5�%|��:I���^�L*aL�z��ߖ��r���i�JK���xsF����>	-ߎ��q�3o�͑�콲־ Ƀt8      �   ,   x�3�tK,�U�MM�H��,N,����2��J�rS22�b���� ��      �   5   x�3��/-JMNU0�2������lc.8ۄ��6�2��͸��ls�=... �{�      �   �   x�]�K
�0���=��
�7m�ґ�%��B��~Ӂ���|p�����~������F�3�l}�P/����p,�L� �G/j�P� �p`b��)���-&?����嫎4�%Dէ��!��q?� hhQj      �   /   x��J�I��L���􂱸��r�sS�3���Ē��<N7_�=... �x�      �   3   x�3�I�PHK-I�PH+��U�,I͍/(�LN��M,P(IL�I����� E�      �      x��][o�F�|N�K��7�-˰|��:� X�U�X�$'��O���d�mH6;.��_�W_�pt�����kRU��*i��QY���sF�<Ȗb12�*�PZ�)9׊r��Tj���?�~�es����������6<��7��3����b�w����^]~��yE���>]��Vn��򖶱�g���o�7��{�y��}��-����#�����{w���|���t�B|��=ۜ�Җ�|�ǆɍ�� �Z��6����y��GKq���ͫW����g��Ŝ�j,?oN?�=����0}?n���� ��c���͇�{Q�U�N�6y�������B>_��7D6�|��/���n��ß.�v_hpg�D|��k+O��l�|~{�挸��_����5�i�%�H��u�f� �wO�Ǹ{<�+�мD�9���,������� y��4_���!_ ���w�W��,4ߡs��KX��}M��/����4���&5ɗ��V��i+���y����;l�0�������ǿ@�x��<���h�_"��y����/�wn���3L0�sL0��`�	&�x�4*	$��JI偤AR� �T�T.(*���E傢rAQ���\PT.(*���M��#*4���M傦rAS���\0T.*��;)P�`�\0T.*���K傥r�R�`�\�ܱ��K傥r�R�`�\pT.8*���G��!Q��\pT.8*<���O傧r�S��\��U*<��ʅ�ʅ�ʅ�ʅ�ʅ�ʅ�ʅ�ʅ��.P�0P��\T.*��ʅ@�B�r!P��Q9k�m���	n�&�y��n���	n�&�����n��
v�e9�&�����C��hrM���Y��ђ�FKn-�y��Ғ�HKn$-����Ғ�JKn,-����Ӓ�LKn4-�ٴ�Ӓ�NKn<-����Ԓ�PKnD-���Ԓ�RKnL-�9��Ւ�TKnT-�Y��Ւ�VKn\-�y��֒�XKnd-����֒�ZKnl-����ג�\Knt-�ٵ�ג�^Kn|-����ؒ�`Kn�-���ؒ�bKn�-�9��ْ�dKn�-�Y��ْ�fKn�-�y��ڒ�hKn�-����ڒ�jKn�-����ے�lKn�-�ٶ�fۊ�m+n���ٶ�fۊ�m+n���ٶ�fۊ�m+n���ٶ�fۊ�m+n���ٶ�fۊ�m+n����Y�_�f�i�e�]k���䷭ɯ[�߷&�p�Ͷ7�V�l[q�m�Ͷ7�V�l[q�m�Ͷ7�V�l[q�m�Ͷ7�V�l[q�m�Ͷ7�V�l[q�m�Ͷ7�V�l[q�m�Ͷ7�V�l[q�m�Ͷ7�V�l[q�m�Ͷ7�V�l[q�m�Ͷ7�V�l[q�m�Ͷ7�V�l[q�m�Ͷ7�V�l[q�m�Ͷ7�V�l[q�m�Ͷ7�V�l[q�m�Ͷ7�V�l[q�m�Ͷ7�V�l[q�m�Ͷ7�V�l[q�m�Ͷ7�V�l[s�m�Ͷ57���l[s�m�Ͷ57���l[s�m�Ͷ57���l[s�m�Ͷ57���l[s�m�Ͷ57���l[s�m�Ͷ57=���Xs�c�M�57=����&a7���_��Uc�v�������5��b!�;|�������H�n W�q� �zx��j�X�Ta�~�"�B3,�F3,�J3,�N3,�R3,�V3,�Z3,�^3,�b:�E��xƝ�T�~*WkFL��k<;UbFL����Tq1��2bReeĤjʱ橂r%3�𳏹��䟬C��:��wNKH���,H#*Y�FT�(��dYQ��4�Ru���\vΰԊ�a�%;�Rkv���K���Z�3�JuK���u��ϸN}��Ӹ��w%�qӞ�Jl��?ܕ��M��k�5.�.�O_��:�ϸk�/Wf\�≯\}�q��0�r�a���ÌKՇW�_�l^���Je��J�#(�GP*��TA�8�R���N�S[ㄺ
��6tB�����}�1�O?b���TA1�z2bR�dĤ�ɈI���%ǚ�J�t&q������A&�{��	�����\!�P��?�R`B�V��J-�	u����J��	�*�3��:î�.��ΰ���+�3�:[Kf����p�]�e�cB4Er,�G�rk�H���ʨ="�L{D*���T
����#R�s��H�g�% ��ᶢ$�9�t��s��z޿�t��lC>ؙP��9�RtB���J-�	�Z�*�X'�u�*�3��?î�.��ϰ����f�u�m3�:�6���~�>�R�vB��J��	�Z�*�b'Tj�N���+�)�,�6�vvq�����Ma�%R��)�#(�Lq��A��+|��J>K\�3EGP�9�
�&���|T��N����}N��N�\^}��9�|J0�rw��ݭ#*w�����W��\<�r����U\)�`�aW?n>���3��Z�K�.U�TQX�Rea�K�.U�TqX�*K`��x��}s�!��!t厠#(w A�<#(�|g��ӝ��է���xGP�[C#(��������}Yh�)4�r_A�����?���#�*�"��{D]�U��t���������;$�mN/6�ڎ��Ç�{�0�r�FP����=xAW))���=u8?��ሺ
���GT���);��C�O3;�
N>���C�I>�������:�ן�a���̈́#(�@GP�����/�A�_�9��߷|��������^�]B�_?\B�_B\B�_E\B�_H\B���]B�X|�w~���W �.?��9g��rD�~j����������#*���GT�'�����Q�T8�\|�|s�>�_�r�}��*��˕����3.W�g\��ϸk�/�+��~�������/��fFP���GP��GP�g�GP�'�GP���GP��GP�3#(�}�c�C�U8��\��6��7�j	���?�=�?�=�ߘ���/M����&f`�30��A�/P,�W�ފr���/S,�W��=����4br=��k��\Gv�����εcL�;`r��X�\/6���$�k�#�\"��<���&����p�i��BL��W�'\��.���	������V=��_�p��1ᒿ'b���"f�����x-Α�w�as�9?%g:3,w}'X��N�+�-W�&X��M�\5�`�b6�r�l�W�f\"��~�r����gw6o�/�|��qy������߬Y��Z���&\�[w.�	��_]Z�-�]�	��.߄K~�o�%��7s��.����Ed��[S�|���S�����^q�U�M��*�&�U*`�[���	����PUK�!6��Ԇ���PkQj�hC.�σ6ܟm�]][.+,���
�e���rYa���\VX.+,���
�e���qY�x�ؼz�������1�|��{����Mr��\s�'�cv�(隮�f�d�2ڪ�m��`Q:IC2Ɔ*u~(��q�<��Lh�z�sKMGS\nBT�����VL��]�TYR��z�h՚x~���r�Z��Pl�!US��5؜Z��rͶ��Uq�W���]���<�k���[%����m�ޜ�۟.%��7^W=x�a�J�"���%������ƻ�b5+~����Oݕ;�ߦ���x�������K8e����J�Ŧג���$EJ�m���_T���٩X�my�Dy����דR��!ভ�7>�bRtB�mj�8��2M<��!�䇄+� b��?�?�뻻xUwy[N�|�Z\C7/[�:-�����z�7Wz�[��P[���<(����k|�����eZ\!6T��X�������Uԇ p�/`�CFi��m@���X�z��6�Q�=�]�w����~��ͯ���_$���Z�`\6f�R�#�';4Ur5V�0Ra�L���jI�����7��i��Z<GVf���/.�,u�-.y"%��U*;�RJ��g�Tֱ	���������1��,Ћ�A�eC�TJ�
%�ER9���"����-�ds�(#�.�#�m�7��n��w�����l[�7#,�H�jo��N-+�b��=�9f-��Ǔ�p>%��Tb��v����+vaQL�Au��J�w�m 5  R�?/�0a!-�"�[2"��K4܅�*`bt�C���۸��Ү9�,%�j�����UtEh�D(C�J_Ar��VY<Ȭ!ov���u�X��oꃐK�IU���?�(A����".�����yʦeV���0�yn�v(��ql���X �Q%��
��-�Zs~9����0Z� {V�#����5>\ǧǻۻ���P>����ZQ���A]�:Z��I�+��a�]�모hL��?�ձ�s����m����}\0��F�ĐMCa�0���2Jt"9�6 B[l�1��d�(���k<\�n��|���s��t`w��N�	���@����:c�n1a�B�h-	�:E3TS�,�[��m�x�z��3uR�����C׌�eZn���ZJr�� g�( 68���w'�:^��繯uq	��Ɗ�7�[mM���
l�	׊����rDKbpx�8�a�\�n���ٻ�����Mܕ%G !��X-�[c����� �?PhW�]J	�5*��AvJ@sY\���t5)��"w��dt�A�hdo8�f�@� M��R�Q�N�&�x(���a[������[\�bǡz- ��m��,�ŽCzE��x"(�`.���^�䳶�<�vq)䲆h�C�i���PjȾ�W���̓��D�GWi��$���I����n�]PuLM�Kˮ�9゠�HE��-7c��ҡ$��`[`����u������K���Wkwh3�,�CCI�ۋ�����-RP�
�¯xX'��`��x�c�qw���r���<��3�j���:Z�`���hm�����%�,��k��}r��� �������6��6�lA7SMxe�3���)a<�
�UP�������W����o��v�NWJ��b�܁eXj�/��uΰ�Ӳ��
���]A��I�N@��=l�w��_{��m��cJ��+hT�%^<�(��	� ���GU�+ւ�@�S���o��0"��К`u��ڋ���k���%�x"S}��TC�$�-�"b0Ж�����asݰ�A�($��v�%'�|�M�sj � �Q�%����[Bu���Yc�R�Ш��F9�l+ԦeW�0��6�Ƈ\A[��C��6 x�^���Y�>R\m��ISS����V������:�ݪ�kHԪ�&�)�C�O4Q�k�[�Q\mQ'm���P�<	֟�*B���iʳ��{!$��W]��wj6MݝS��"ۂ� ̓_�p���>U	���8��F�G����W�c�5�ƀj��X��z�jM9��a D	:��P��Y��a�mq%����҅�sP �Q!d@Q g�����h۝�)9��Y��*?���~��7j�ϥ�RXP^�nk��;�6	&&�4H�W�P��J�WTu订��_��:�4������?-�O�+	�'���!Ѱ��Q��y:I�z��t0�M���g�P���z�`��{s���P|����C��MR�n�Ak�:Ⱥd�x�ռ������6{[�u�����:��0��!u6!���V��4�'�&��Z�Nb6��a!����`(sJ K��B��i@	*Șp���-1͡����i&ܖ��n�rI�-&>n����\�p�R�:.��Z˴��.����d������K�%�$T���v���e�~�P �`��齫w��Kxӂ!(�GO	c�C�E����|�N)��c���ـ����y�|���<��!��b�i+I�c^\��J�n3&D�L�=\b?퐘7��ea�*Zn�2�����$c�K���Hu���[�*�������!Va���3�%��� +:��1��ea�M���Ƈ9y�o��.r��Z<$��`r��J�l��)��=����ᷝǄ��y�ު�&�ݕ�|������a�1"g�Ø&� �X���b���)���a�bN��K�)g�m��]�b�=� �����ఉ�YT"&���D
� ;�����-Z��Z���i��K`�~0�H��`�d���EM����f��.�jɲ�Â�.����d{o�J�ߵz�x����\/�I6��a;�@?@��Ȕ����Oip��R�����{O�
�C+�瞄�����~�(�$�y˚ �rɘה�}j�X$�"O	�5h�:)p�Eq�Y����`��.��0����18���j�[8��гE�;��xD4aN��i���6�Ĝ�
�{�[�#���x�#�L��(��Uw3���&��Յ&f���^a����
O���u��w/Q�K����E1�6�(����Ƶ���H�&X��xxG�e��pL>���c�~4>7q�v1��<n@�5�o�q�aѸj�������B��,6L	�_�� Q�f@� ��p�ٕ��Z�Σ������N�Q�W	��M��~C�ەm1
\nSj��
���9d��
���K@?���A� ��P�g���y�����
��>#����E����+TZ�SN��T� �(ULiZø�V�.-zTn�mnC_1l�:�7���`��,�)�0���6XC�ǳa�ZC�F��,���nSʸ	fN;�����4��PN�9��鬒�W7�:aG1��m�t���3��jQ�f%���N��t�ԏD��>t��j������ D�y
M�K�0�,&)p��Ч%(�N�<N-{<B��~{:Qj�n�p�[��YWy|���iw��<C_���b,0d? �vsl7���4��~�W�*�AyjC�)�����Af����+���u�};0�0(MZ�t�T\��-*�0����1:7�_�h94���@G�yV���ǻ��=�X��������������X���n��c�(W�'h��e�B���Gz�l�0V	֪/���*)�g{���#f�*���a�r<��D��m��V�BaJǨU�����}��5��ݩ�ھ{�,��r�ƦE��t���c<�C�������qyd&a0v��a ��n���7��
�::`�x+L�B�t�%N�:]��ۗ�:ꂛ�01Z�fZP&udP2X�;��kU�iU�����Z0&��1�?h���'�c�����퇓W�>��m]�9!�MC����b�Ͱo��E;�}U��'W����x@\��ܦ�k̡���0���Ѐ��h�Q�+�Ѿ���{�~��Q.A+q����4C�-�����Ȫ-|w��]*'��f��ڇ՜`�1 ��zϨ=���s��(�����~��1/x.,ݸ#t�
a*��.�p���cu���?а ��*��zưS�Q?m�}p1�[ny���D����iK%4�Z,�i?"�5B�$��T��#I�aF���U�}��Ϡ�ln��Z@ "|�Ô���1pOʢP	0B�Ò6���'���'���k,w7��~v��L�*F��Qpf7�&5�j�Q�ƶ³4� ��*kc��b��J{��"��]A���Mh�`r�v�Tk<� Q�ZGUk?������*�u1�"c���")x���� ������d?-�[�0�[�A)I���c}���(�CS�ld�Y]x���4�<�����{�
g���R��Jxr4�ʥY���臙V�����c"�o��
S�n�=;�y�Ö� �Ab E �!l,�{n&v�?}�MC��NK��?���Gӻ>wZ�B��;�������=y� ����هP�����@����Bc�;�
�<�� Y�.
[S�����Z���I	�n��>�`
����F�`r�P��fe-	}����@BxB�0�:�t;L[Ӊ��������&�3�      �      x��|�rI��3�+���}�S%H	� y�T]���X�E�JT�������̤D�-++�Bf�p�r���>��������`������'BO������a�������,<��X����q���%݅��8����j���|5�Ь/���Y�򱹸���^O��#�l�,�hlQ�2/����PK�q��dXI6����Eo��ZW���{;ZO��|��w���8&�	q��D��0����<����6<=�����ۧ������R��>�g%=}yx�vo>]��/6���|9��ւ1ݙ:_�x�^#�N��EХ&gj�9Ƌ�:[��O6Z墮Uʠ��)!�T&a�����QS��Ty0U�a&n�1<ގ�?¿ß���ݿ���x~_����szz~(�������ϻ�00u}1��Y���_W�z�ڞn���z{ss5��~9_4�+�YY]2���K�&k����&8�X#,㉱ wK�`�2Q[F��6���LO����Q���f��-;a�]����ͯ��r�l��ѯ���yܜϖ�6�\��\�3:UL��)��[�D�J��u�)";F��͓��Y���xF�T��M�`����N�G.���_v���l�����)_��:!�*B*�T+&i�x�5�D�H,.������A%E���	�b"�D�����M�w��D�.�f��؎/��f5FA]4��������f�����W��|3;�Dw�\5�_�[�@z�TvA��L���{#��ffEME�ʂw�9#�B�i.�ͪ�D�YVO���Gͳ���<iO$�c9��.?4��>�xq}�,7����y<]]o.P!F��:ZN�8��]rQ�p���'��ǳ�%9�[�Nko)T��j�*�(�V��0
e'E�/��`�;X��	�F�������3�=����]-NO��z}}:��փ���I��.��
6�g��B��m!V�K)RlҬV3���;�T�VU����I��`��v��_	�cG���|�;��!�G�p��!�������}�>�U��E��s����D��K��a�_4�t{v1o���+�3�U�P� fFפS�5��לK�j|B��*�%-��VQ}���L�С£f��r�!5�<�mW-^mƳf~:�
��-�/���������S�� �ח��|}�j~�Znf��ְ���֢ڬ�g5΂��g粌I�o�ʎ�|���b9�$p��4
�A�7�w�u,����`ʹ��g�ב�Us�,"��W�f9[�N�7���nV���j<n�g��������������߇{�{Ń'��K)IT0�&Lu�ho�Ij%K�ɚKα��O
�Rt 2
Z�w�.P� e�aB�fo$$+Rk#b�0�S�V�l�ʚ�u�A��!x

Q��Z�����X	��xER��(�םS�³�-����������=3��(#p���E�BQ
��k�)Ĭ�[]��Jɑ�:���� �3��ZM�;Ҳ#"�c"D��}���f_{Ə�3HX�T���|SmNW�f�\�IIFC�fPV"�֡ZZQYKU��E�b�)�K΢r���s)��{��(��wx��!�#"B�H9�f|�>�\�>��܇O�TA���_w���uP.�KP�j�
ȿ���v��[�� <S�L�L�K�(�9�\�PVl�`��UoB2��*!�=eF=�M�;��1n��+�=ͮ� .���Us1?螞#�׽+V��+�"����Lc��Dm+�9��Gb
�l�h�Y��+��"�8�6AƂ����t̅۾�z�ڞ�*��h2�nk�w^�[�]���v�޴�� Ȩ��S"r*"�d6�L�R9�L�&�K7�G�X-L�D(-��WV�G���c/��/Z�Hp��H0m� 7�f�l旭e������1�=��/��gⱏ�J[@^�m��*kVk�#���ÿ���<WB��)ܳrU�u�X1P:�Ù��=n����ԋM3��q��0�\���;p�CϢ �3VE��$�
Dsc�.'.l��O(����
�&�*h�d}eN���qi�Q�Q�
�o��쬺j./v	������-��=Ze��raa�c"�E* :���U�y))i3<��Q �d���C��1�#6�#6B��R��t�>�7�Es� `W���zq	37�Ӌek�z��m~:[���_o�7W�󛞱�!Z��q��_�,g	��W��
����F"�#HyVI�!x�mh:��T'��p�6����-�����|�j	D�l�:o�/-����C�vx��m�w�����s@�-ȍ���5*	�B���dv�M �F���^2o4)���f�A<�%���w��:�#:�#8��F���@���0^��/_F7�>݆�ϟ��e�_�w=��/��of���mE�*�DsM��B�\��lK4�g�� }5ӅW�58"��y����Q�D2�^r��l�LWT��A@���_�s�2u���D��t1NDkq����4�d1��x���H1���y��"0wj⏣������U ��ҁcl�p+L�2�@\�>B\��UP���B'H�p$�5���W��P��NT�P�$<n\�uD�M�O �r4{ >���^f�?�ۀ}�~|q�dks
%���: ����9؜�>]TrLA3z�7��r���8ծpf� I'gɩ��yA�5%:�#:��,1�h��{��l|Qn�C� ��3���{ �f1[_,f�SL�#���@��)W<�	���Z!T!j���S�*{�d�ZW���	"��\V�� �� 	w����N���aգA;����_7À�_�]���m���.CP	�*����b|�^�.�����e��F������/*�xsWt�Gt�G��jwL�=(A����q#g����"
/�ӾM�.ܛ>�A��Q\����d���Y22��4GJ"p�<�K,��e�����,�]M�u�[�5�5R��S7�<|P���W����u��Q���anR�i��gؗL0Jp��I�3���'�S��&��c�,\D�y��9�[X�Av|H�~��|輁���.���Sʶ�-��yy��9o֛�z��_�l3(�I��y`@�S�8��+�s
���Aܑ�Z1�va�O."��TT��<3eG�d���I6�����n��Es	+�s���f=��o�粶��Rs�Ί��}�$T�W8�41�ʣo�>8j� ��ly��bb4������d�Gת��m����Z�7�Ж����������$��c~� e���9g�ʒ��
Ӏ�GU��.�r�e�1#3O��=*�~D�8^ydGr�ꛩ5"�ͦ��T����_� ,�Z ���/K���.���;-�M^3j��+n�J�+4�j�uU����I��Ԏ���a'��;7��a|
k2�F���p��<\��<ܗ���!"�t�E7��fg�_��	B�NP�6�� �XB�@�q�JUZZs&���[`�ѸbtH�������: �����5�w=�T����Mҷno���[�,����2J�/�G��4�%0ҹ���ӍA���,BB�_R}��Z7�#@��j�����|���~�Y�u��k�N�w�wW{BS�uV2�,H\��Iͫ�9r�a7��%�h��٤,��û)����n��b�ꨖ-5X�.���e�!����^��.{ �r-5�`�qJFT������ k�1�*Xh`E�<��vM`��;�@ǁ�E��h� ��duw_ze���o������g�)��s�D��C��+�:�^I��Px�J{W#HC���}_S[���Wձ ձ �N��hR%gH�������{mĤB/��1��Vkk�<'��䡥��AuU$x��Um ˀ��C�%��Hy`x-�P��mR�o��q���e�ς�]��r��|?h������zKm���d�R�O���%NmI`y0:��W�0��FKYLD���/;Z�:Z$5ű����K�]B>^�[7�wwk�o1�^m�mM��l!���e�� �J����%C�dϰ$��*z����Pf�cHJ    �W�@A���`eِD^��~} s].��E�Է�������*�)���c�� pS[͢O"F�^ËQ�
�d2���8J�7��+�4�v9����,��/�H=��v���2O� ah����t�{7r�FD�(��br3�ëv�X��>��(/�0ź���m�<e��2K��mt�n P��:���^.�wtUǝTǝd�s{���]�B�^#�Dmq�ڼ~����޵oD��\X+"1�"ti0U�"j��,,B�Ii����R���:Ǔ6��'¹�I��I��z���[������.���jM�������k��'���"X_�R:����k�<M�ZF]|WS��h���������=g͜�����nE��M�-�4#H��ݿ~�^]K/u�Wd���l�h>�E�WEe���3[b�oa��BZ�9-^��4͒i� Ŏ뷣�j��6��q�܎.��.1~�h}�lN}��|���\�.QR.P�a����+BHM����~�Vގ�R��$�}6@	��d$1�pEa�^����/D�P\1�&�D�v4I�ZE��GͿ�M@ڪ����ݭ���
��Y��9X�6�u�f���S��ly�̲!�L6��B��ķ��d|�"Ի�@>yǒ��(�f��º�|l�������rz���D-3�����d����sm�.4eg���e�j��LB�xZ̎9��^>�"�cAWwtH�萣�1v�o����������1c����OC�}h����Q5�I`D,%ZZ)S�E+���B�Vyz ��E��3Q�6(Y����#�A�1��Q"-�M>Am����k�jMލ�]N.'o�W��ir�\�V�f{���U�	���)P���U%W</�`�E�ʄ@	Fuڍ��W����٨;�;��	��1|�{��CO���H�ȼ����i@m_u�@���/7�Բ�
C�
%���p���`>B��Sf��S5�i��҂�;�t�wt�w��Q�hAU�8��ټ�VC�^�/�6��.���͂n�'�k���@K_Y(�J�`4:+��N�j�s0�2����̌^>�V�����**0n�Fg�������t�n��BP'4t��ߗ��i�j�D�5�lQ�*c*��%KNV��"�`5�1|F��%��é�~ܸ��hӹ̞hE����]�ݥ�n���ǹ7��00?�N�[�>��H�I�\���P�08gbD�Vq�$DW����6'X{Dq	�U�r�?��#5�v�S'���}5�-��4n�k���w��5�r��׌�%g�^4��Xr"2�@]����Z�`m׎���/a?n]�a��[	�G��Y�w���棛��g�!��L���}p�\��d䬲*������ʊS�-���?���en`r�"v�U�Qc]�#4;�}���̩d��A|eJ��a4]�_��u�.f��N7$5�ۂ�i��#>�aRj�1�CH	�7K,CZh��|�����G�GM4w1���<N�f�͸UJ����E�auy�_w���
�YJ�k�
"/M��L:�ͳ���*M�B 6��%���/�����L�^�,�'���,iK�A�.�׮��]�ϛ��>��ݧ)9����,��fV	`��	�dZX.�w�D�
�όͱj��@2ZO?^TLGS�8���hR�||�ܐ��:�󼽠��.��Z^HƋ�QW��1M���I"�*L�9Ŋtӵ&c6�v�a�}�yW1�K<E��G����[E��k������o>�`�%ŭ�Y����U�do�ƃL�Ql��N��B]��$g::�B��ʗ%�[��#0�F����#5��t���e3��!�W3zu���}f�Ȅ�OL�v�A�@�2hY�Ƅ�๨�&0e�#+J�)R�#T�ľ��8�|�k��غ�Ș���vD�h4�VqS//�����?ot��h'��9�*�� ��0Π�#R�х�5�H�Α�B
n�a�M*9�ǭ���2},d������,s��m.vC��+�������P=��2I��l���@(=�����\5O�	e�Q1Р/��ʠ�5�8�V*�O�ֱc�Ě�v����lZ��><� ��]}� �*�D O[�*,P*C���QB�RF_4��.PF�ތW,J�~¸�Ę��$�}W��	~v=n�]��#47�m�W�����u{.�JaN�ꐅ�:Y.�R�� �#}�e.���8(�R�\�T�}�n�&ށ��1���DR�i7��b!�����|h֋��c�}���e���Cq�Ft@��E��d�S��v�f`!�Oe;�bY�k(GP�]Q$�˸�����i׫��p�wu�5��X��D�Ҭ��!^�q�0�� ?J�l��M:��0��q=cQ2�q;c�+�'G��x܌o �WW�r��.��_���l=nC򛘜�W͇��!��v�4� Ȫ��RTM��p)�ˢ���!a!x�I���#&"�4�߄F��`�3�8؎�؎�p{�h���ysլ7���Y��G���U����Ap��&
X�2����;ZXBq��ZB��P4��)~����UEo�5�H��z�;;Zc;Z�5|����/Ow��nC҂֏�}}_�Q��_>Є:����ܷ(m�?N�mG\lG\4�6'w�F=�Ooǫ/�Om*Αj���ݟ�v��[pi��_��[�[r�^�V�aA8�)�)��D3V��e��8����FUҀ����q��,�ﺻ��f�n��v�Y��b�����-�;՛5K�c%?!#�(N���`@A�w���,�A�Z�+w_���H�ʠ���>ιm�^��[I�R�oE۪>����n��������`�����d,X&xZMܡ�$MK��O���a��Q� (����?6��w�T=�x�J�+|zI����6�����֪����RK�.�{f���I��Bc4;!�h'K
.��,�F�J[x�� �}Ƞ��;�#3���YZD��[��~yη���M@i��N��ri���u!eQ���el1/	dT�lY���,s^4�ehG+�!K�H����;>c;>�ڹy?��H�Aۯ����&:�0���х�M�>�1XaH�]�*���vPL&��@{UAo�,���J�T�Ω��'$�樭��9nHs��q���i�z+�������6�M�)-�ެ~�{o����^3.+p�K��^BЂ��Ǫ����$�7$�X9D0�Z�S��������9��7��o��t�wِ
���z�8ލ:�B�-���Y��.���`�]���<�۳����ZE/�F(ɣ�	���׎ A��� � S��Ҋ@O|
/(*?�/5h���t�q��1N�����W����p�؞s�x|I&߇�����_�+����Hh 0Ug��r�&j��r�Z���H�,R, �M��8,:q�|�܎�^#ǜ�d�~�����o4�0@�����;���Ӿ�4[�B�^Y0U$���ZF��`B�Z (�9�`8�e^XP�\��h%�a�q�q+}�'b}���X�؞m��#�P�-���4�e��F��v�1Y�W�����9�^H��u���� �iK!G.V#��j�M

��
����8n��9=�9R!j�ۛfѴ���ѯ׫�v9�������=���kBw�������:G��*Y���c��v:8�h�4^� �H��,����E�#?��9� �V�M7��n.��y3Z��o�N{W>����r���$�p�T���[ɐY@�h�97�k���X�!�X�u��/:�b�;(��(���4D|{ґ4[=�����]�5+@����j&�r��;o'�ufp��cBPBRTi26s��&#� eC(^+�����6�?�oUZ"��������X��4k� {{�p�-��4F%��0���s� �c�@��d�O`�\����א�JB���҂��GE�h��I��po��Z������ip��u8��nϲ ��`<��^]5g������o�'x�T�i� >   �P���Sx��GǤ	�\'������9'������DHp�����F��:Z�;<>��i�׿�����^�s����������n@a\�A'X��bt�C)�ɀ(�
�Gg48�������\q�ei=0At�ln�ȏ-ꨍ�}��6��������O����t@Ut(��?¥�eM}zZd���pU<;0�C�'ǩ5��Dx��*����s�����
��w��c7�c7�D0d���z��Y�]̖���z5�}v�(� ._/�ME�|m�V�c��:@����'���?���]x��RQxhi�ȭ��[:�C��b�Rǋ��،�،�tΓM�}����z0�߇pOC�W������Jaю����C��h��P�cEH���T�Pe!��cC�4��N(4��+��,�X�v+�q2�;2�;2#5�lwt�~Ǫ�^]���Oo"��s�]��t��5�T�I��v�*�J)��cP���B���i���>���@�&�l�v�Q�:�{�4��qj����������xAÉoEF����T}͘Tn�4��������U:�Zh����h��.EF/j���;�}�]��wt�wt��Atf�rz�?���~�͏�//g�F�_AdB��l�H��"0jh	QK�i�]�"�T���l"'��9�v1��i��}Gk|Kk����DT+I��|��V�o����w����Me �W29�y�5j�V�&��9����I&����	�L�[��p:�q��a�4��3�LCj���0��M��c4i�{�mV�f�����9��{rB�L֗�bJ�z�S�;	��i���$q�v�Ҏ9��vzl�<�V:�53�AÏ[�;�,�������C�c|�����n�1n�o�z���2iW�@̾@�B,9Uc�I{�Ba!z�5LM�"%i�#��76	����`�TեN.��^�����O]lJ���vC�I��*_h�_y����,m/T�+� 9��
Nc'<	Ν���X
A(�x �CJZN���T�+��Ov�8G�C��P�tb�����鷯|32K�p?�AE���i"�=0�E� 2r�V�)~����1:Z�6�������}�I@���,�%�=����>J�:��7_�]�_�|���
'�7��P!@?�k�\!Zkb
R 2Ҭ>/<���FQa,U[h�-�ތ��Կ>n�<�%��l�h���6�b������\���W�7�z_=Ϫ<�^n���/������S�f��,������)I�\c�����4moy�$(�,�YU�!���S���`p�0u0Lu���Z���(Վ���YI�]_U����A��5�f�#mm/+�ey�0�h�� ��8SYzٗ��
V��a�>X��iM���v����x���r�ž>��8jwO��?>d����qB7��WL2K'�*�� 6�,5���h�B����j��r35Ǜ�;��`yW5���vՖQ��ܦ!���p�k��-�4W����R���RڃK�5��!%��![��\@i_��5@���=ͽ�}��m1j:X��*�������_����o�x�g     