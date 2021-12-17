PGDMP                     
    y            oaic    13.2    13.3 C              0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false                       0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            	           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            
           1262    16384    oaic    DATABASE     Y   CREATE DATABASE oaic WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'en_IN.UTF-8';
    DROP DATABASE oaic;
                postgres    false            $           1255    24778    UpdateDeliveredQuantity()    FUNCTION     �  CREATE FUNCTION public."UpdateDeliveredQuantity"() RETURNS trigger
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
       public          postgres    false            #           1255    24593    update_invoice_number()    FUNCTION     R  CREATE FUNCTION public.update_invoice_number() RETURNS trigger
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
       public          postgres    false            "           1255    24595    update_mrr_id()    FUNCTION     �  CREATE FUNCTION public.update_mrr_id() RETURNS trigger
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
       public          postgres    false            !           1255    24596    update_order_po_intiate()    FUNCTION     �   CREATE FUNCTION public.update_order_po_intiate() RETURNS trigger
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
       public          postgres    false                       1259    24688    CustomerBankAccount    TABLE     :  CREATE TABLE public."CustomerBankAccount" (
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
       public         heap    postgres    false                       1259    24686    CustomerBankAccount_id_seq    SEQUENCE     �   CREATE SEQUENCE public."CustomerBankAccount_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 3   DROP SEQUENCE public."CustomerBankAccount_id_seq";
       public          postgres    false    278                       0    0    CustomerBankAccount_id_seq    SEQUENCE OWNED BY     ]   ALTER SEQUENCE public."CustomerBankAccount_id_seq" OWNED BY public."CustomerBankAccount".id;
          public          postgres    false    277                       1259    24661    CustomerContactPerson    TABLE     �  CREATE TABLE public."CustomerContactPerson" (
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
       public         heap    postgres    false                       1259    24659    CustomerContactPerson_id_seq    SEQUENCE     �   CREATE SEQUENCE public."CustomerContactPerson_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 5   DROP SEQUENCE public."CustomerContactPerson_id_seq";
       public          postgres    false    274                       0    0    CustomerContactPerson_id_seq    SEQUENCE OWNED BY     a   ALTER SEQUENCE public."CustomerContactPerson_id_seq" OWNED BY public."CustomerContactPerson".id;
          public          postgres    false    273                       1259    24757    CustomerDistrictMapping    TABLE     �   CREATE TABLE public."CustomerDistrictMapping" (
    "CustomerID" character varying(255) NOT NULL,
    "DistrictID" character varying(255) NOT NULL,
    "InsertedDate" timestamp with time zone NOT NULL
);
 -   DROP TABLE public."CustomerDistrictMapping";
       public         heap    postgres    false                       1259    24781    CustomerInvoiceMaster    TABLE     n  CREATE TABLE public."CustomerInvoiceMaster" (
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
       public         heap    postgres    false            
           1259    24581    DivisionMaster    TABLE     �   CREATE TABLE public."DivisionMaster" (
    "DivisionID" character varying(255) NOT NULL,
    "DivisionName" character varying(255) NOT NULL
);
 $   DROP TABLE public."DivisionMaster";
       public         heap    postgres    false                       1259    24810    CustomerInvoiceViews    VIEW     
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
       public          postgres    false    285    285    285    285    285    285    285    285    285    285    285    266    266    285    285    285    285    285    285    285    285    285    285    285    285    285    285    285    285    285    285    285    285    285    285    285    285    285    285    285    285    285    285    285    285    285    285    285    285    285                       1259    24698    customer_id_increment    SEQUENCE     ~   CREATE SEQUENCE public.customer_id_increment
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE public.customer_id_increment;
       public          postgres    false                       1259    24650    CustomerMaster    TABLE     /  CREATE TABLE public."CustomerMaster" (
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
       public         heap    postgres    false    279                       1259    24648    CustomerMaster_id_seq    SEQUENCE     �   CREATE SEQUENCE public."CustomerMaster_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public."CustomerMaster_id_seq";
       public          postgres    false    272                       0    0    CustomerMaster_id_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE public."CustomerMaster_id_seq" OWNED BY public."CustomerMaster".id;
          public          postgres    false    271                       1259    24672    CustomerPrincipalPlace    TABLE     �  CREATE TABLE public."CustomerPrincipalPlace" (
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
       public         heap    postgres    false                       1259    24670    CustomerPrincipalPlace_id_seq    SEQUENCE     �   CREATE SEQUENCE public."CustomerPrincipalPlace_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 6   DROP SEQUENCE public."CustomerPrincipalPlace_id_seq";
       public          postgres    false    276                       0    0    CustomerPrincipalPlace_id_seq    SEQUENCE OWNED BY     c   ALTER SEQUENCE public."CustomerPrincipalPlace_id_seq" OWNED BY public."CustomerPrincipalPlace".id;
          public          postgres    false    275                       1259    24724    InvoiceMaster    TABLE     G  CREATE TABLE public."InvoiceMaster" (
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
       public         heap    postgres    false                       1259    24737    ItemPackageMaster    TABLE     @  CREATE TABLE public."ItemPackageMaster" (
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
       public         heap    postgres    false                       1259    24750    ItemPackageSizeMaster    TABLE     s   CREATE TABLE public."ItemPackageSizeMaster" (
    id integer NOT NULL,
    "PackageSize" character varying(255)
);
 +   DROP TABLE public."ItemPackageSizeMaster";
       public         heap    postgres    false                       1259    24748    ItemPackageSizeMaster_id_seq    SEQUENCE     �   CREATE SEQUENCE public."ItemPackageSizeMaster_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 5   DROP SEQUENCE public."ItemPackageSizeMaster_id_seq";
       public          postgres    false    283                       0    0    ItemPackageSizeMaster_id_seq    SEQUENCE OWNED BY     a   ALTER SEQUENCE public."ItemPackageSizeMaster_id_seq" OWNED BY public."ItemPackageSizeMaster".id;
          public          postgres    false    282                       1259    24628 	   MRRMaster    TABLE     K  CREATE TABLE public."MRRMaster" (
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
       public         heap    postgres    false                       1259    24597    POMaster    TABLE     r  CREATE TABLE public."POMaster" (
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
       public         heap    postgres    false                       1259    24794    MRRViews    VIEW     �  CREATE VIEW public."MRRViews" AS
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
       public          postgres    false    267    280    270    270    270    270    270    270    270    270    270    270    270    270    270    270    270    270    270    270    267    267    267    267    267    267    267    267    267    267    267    267    267    267    267    267    267    267    267    267    267    267    267    267    267    267    267    267    267    267    267    267    267    267    267    266    266    267    267    267                       1259    24616    NonSubsidyPODetails    TABLE       CREATE TABLE public."NonSubsidyPODetails" (
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
       public         heap    postgres    false                       1259    24614    NonSubsidyPODetails_id_seq    SEQUENCE     �   CREATE SEQUENCE public."NonSubsidyPODetails_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 3   DROP SEQUENCE public."NonSubsidyPODetails_id_seq";
       public          postgres    false    269                       0    0    NonSubsidyPODetails_id_seq    SEQUENCE OWNED BY     ]   ALTER SEQUENCE public."NonSubsidyPODetails_id_seq" OWNED BY public."NonSubsidyPODetails".id;
          public          postgres    false    268            �            1259    16793    StateMaster    TABLE     y   CREATE TABLE public."StateMaster" (
    "StateCode" integer NOT NULL,
    "StateName" character varying(255) NOT NULL
);
 !   DROP TABLE public."StateMaster";
       public         heap    postgres    false                        1259    24815    StockMaster    VIEW     Q  CREATE VIEW public."StockMaster" AS
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
       public          postgres    false    286    287    287    287    287    287    287    287    287    286    286    286    286    286    286    286    286    286                       1259    16953    VendorBankAccount    TABLE     j  CREATE TABLE public."VendorBankAccount" (
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
       public         heap    postgres    false                       1259    16951 #   VendorBankAccount_BankAccountID_seq    SEQUENCE     �   CREATE SEQUENCE public."VendorBankAccount_BankAccountID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 <   DROP SEQUENCE public."VendorBankAccount_BankAccountID_seq";
       public          postgres    false    262                       0    0 #   VendorBankAccount_BankAccountID_seq    SEQUENCE OWNED BY     q   ALTER SEQUENCE public."VendorBankAccount_BankAccountID_seq" OWNED BY public."VendorBankAccount"."BankAccountID";
          public          postgres    false    261                       1259    16916    VendorContactPerson    TABLE     �  CREATE TABLE public."VendorContactPerson" (
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
       public         heap    postgres    false                       1259    16914 '   VendorContactPerson_ContactPersonID_seq    SEQUENCE     �   CREATE SEQUENCE public."VendorContactPerson_ContactPersonID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 @   DROP SEQUENCE public."VendorContactPerson_ContactPersonID_seq";
       public          postgres    false    258                       0    0 '   VendorContactPerson_ContactPersonID_seq    SEQUENCE OWNED BY     y   ALTER SEQUENCE public."VendorContactPerson_ContactPersonID_seq" OWNED BY public."VendorContactPerson"."ContactPersonID";
          public          postgres    false    257                       1259    16980    VendorDistrictMapping    TABLE     �   CREATE TABLE public."VendorDistrictMapping" (
    "VendorID" character varying(255) NOT NULL,
    "DistrictID" character varying(255) NOT NULL,
    "InsertedDate" timestamp with time zone NOT NULL
);
 +   DROP TABLE public."VendorDistrictMapping";
       public         heap    postgres    false                        1259    16903    VendorMaster    TABLE       CREATE TABLE public."VendorMaster" (
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
       public         heap    postgres    false                       1259    16932    VendorPrincipalPlace    TABLE     �  CREATE TABLE public."VendorPrincipalPlace" (
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
       public         heap    postgres    false                       1259    16930 )   VendorPrincipalPlace_PrincipalPlaceID_seq    SEQUENCE     �   CREATE SEQUENCE public."VendorPrincipalPlace_PrincipalPlaceID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 B   DROP SEQUENCE public."VendorPrincipalPlace_PrincipalPlaceID_seq";
       public          postgres    false    260                       0    0 )   VendorPrincipalPlace_PrincipalPlaceID_seq    SEQUENCE OWNED BY     }   ALTER SEQUENCE public."VendorPrincipalPlace_PrincipalPlaceID_seq" OWNED BY public."VendorPrincipalPlace"."PrincipalPlaceID";
          public          postgres    false    259                       1259    16967    VendorServices    TABLE     �   CREATE TABLE public."VendorServices" (
    "VendorID" character varying(255) NOT NULL,
    "Service" character varying(255) NOT NULL,
    "InsertedDate" timestamp with time zone NOT NULL,
    "InsertedBy" character varying(255) NOT NULL
);
 $   DROP TABLE public."VendorServices";
       public         heap    postgres    false            �            1259    16385 
   acc_master    TABLE     c  CREATE TABLE public.acc_master (
    acc_name character varying(225),
    acc_id character varying(30) NOT NULL,
    dist_id character varying(2) NOT NULL,
    dist_name character varying(30),
    acc_address character varying(1000),
    acc_mobile_no character varying(15),
    "UpdateOn" timestamp without time zone,
    "UpdateBy" character varying
);
    DROP TABLE public.acc_master;
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
       public          postgres    false    202                       0    0    approval_desc_serial_seq    SEQUENCE OWNED BY     U   ALTER SEQUENCE public.approval_desc_serial_seq OWNED BY public.approval_desc.serial;
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
       public          postgres    false    207                       0    0    dept_money_config_sl_seq    SEQUENCE OWNED BY     U   ALTER SEQUENCE public.dept_money_config_sl_seq OWNED BY public.govt_share_config.sl;
          public          postgres    false    208            �            1259    16416    dist_dealer_mapping    TABLE     �   CREATE TABLE public.dist_dealer_mapping (
    fin_year character varying(10) NOT NULL,
    dl_id character varying(30) NOT NULL,
    dist_id character varying(2) NOT NULL
);
 '   DROP TABLE public.dist_dealer_mapping;
       public         heap    postgres    false            �            1259    16419    dist_master    TABLE     �   CREATE TABLE public.dist_master (
    dist_id character varying(2) NOT NULL,
    dist_name character varying(20),
    "DistCode" character varying
);
    DROP TABLE public.dist_master;
       public         heap    postgres    false            �            1259    16428 	   dl_master    TABLE     �  CREATE TABLE public.dl_master (
    dl_id character varying(20) NOT NULL,
    dl_name character varying(70),
    bank_name character varying(100),
    dl_ac_no character varying(30),
    dl_ifsc_code character varying(30),
    dl_mobile_no character varying(20),
    dl_email character varying(100),
    dl_address character varying(200),
    add_date date,
    modify_date date,
    "LegalBussinessName" character varying,
    "TradeName" character varying,
    "PAN" character varying,
    "PANDocument" character varying,
    "BussinessConstitution" character varying,
    "GSTN" character varying,
    "GSTNDocument" character varying,
    "IncorporationDate" date,
    "ContactNumber" character varying,
    "EmailID" character varying,
    "Password" character varying,
    "ApprovalStatus" character varying,
    "InsertedDate" timestamp without time zone,
    "InsertedBy" character varying,
    "IsDeleted" boolean,
    "ApproveOrRejectDate" timestamp with time zone,
    "ApproveOrRejectBy" character varying,
    "WhetherSSIUnit" character varying,
    "WhetherMSME" character varying,
    "SSIUnitRegistrationCertificate" character varying,
    "MSMECertificate" character varying,
    "CoreBussinessActivity" character varying
);
    DROP TABLE public.dl_master;
       public         heap    postgres    false            �            1259    16434 	   dm_master    TABLE       CREATE TABLE public.dm_master (
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
    DROP TABLE public.dm_master;
       public         heap    postgres    false            �            1259    16437    farmer_receipt    TABLE     S  CREATE TABLE public.farmer_receipt (
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
       public          postgres    false    213                       0    0    farmer_receipts_sl_no_seq    SEQUENCE OWNED BY     V   ALTER SEQUENCE public.farmer_receipts_sl_no_seq OWNED BY public.farmer_receipt.sl_no;
          public          postgres    false    214            �            1259    16442    head_master    TABLE     u   CREATE TABLE public.head_master (
    head_id character varying(10) NOT NULL,
    head_name character varying(30)
);
    DROP TABLE public.head_master;
       public         heap    postgres    false            	           1259    16998    indent    TABLE     �  CREATE TABLE public.indent (
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
       public          postgres    false    216                       0    0    indents_sl_no_seq    SEQUENCE OWNED BY     J   ALTER SEQUENCE public.indents_sl_no_seq OWNED BY public.indent_old.sl_no;
          public          postgres    false    218            �            1259    16453    invoice    TABLE     ]  CREATE TABLE public.invoice (
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
       public          postgres    false    219                       0    0    invoice_sl_no_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE public.invoice_sl_no_seq OWNED BY public.invoice.sl_no;
          public          postgres    false    221            �            1259    16467    item_price_map_1    TABLE     �  CREATE TABLE public.item_price_map_1 (
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
 $   DROP TABLE public.item_price_map_1;
       public         heap    postgres    false            �            1259    16473 !   jalanidhi_dept_expnd_payment_desc    TABLE     �   CREATE TABLE public.jalanidhi_dept_expnd_payment_desc (
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
       public          postgres    false    223                       0    0 ,   jalanidhi_dept_expnd_payment_desc_serial_seq    SEQUENCE OWNED BY     }   ALTER SEQUENCE public.jalanidhi_dept_expnd_payment_desc_serial_seq OWNED BY public.jalanidhi_dept_expnd_payment_desc.serial;
          public          postgres    false    224            �            1259    16478    jalanidhi_payment_desc    TABLE     N  CREATE TABLE public.jalanidhi_payment_desc (
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
       public          postgres    false    225                       0    0 !   jalanidhi_payment_desc_serial_seq    SEQUENCE OWNED BY     g   ALTER SEQUENCE public.jalanidhi_payment_desc_serial_seq OWNED BY public.jalanidhi_payment_desc.serial;
          public          postgres    false    226            �            1259    16483    jn_expenditure_desc    TABLE     �   CREATE TABLE public.jn_expenditure_desc (
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
       public          postgres    false    227                       0    0    jn_expenditure_desc_serial_seq    SEQUENCE OWNED BY     a   ALTER SEQUENCE public.jn_expenditure_desc_serial_seq OWNED BY public.jn_expenditure_desc.serial;
          public          postgres    false    228            �            1259    16488 	   jn_orders    TABLE     ~  CREATE TABLE public.jn_orders (
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
       public          postgres    false    234                       0    0    log_sl_no_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE public.log_sl_no_seq OWNED BY public.log.sl_no;
          public          postgres    false    235            �            1259    16517    mrr    TABLE     g  CREATE TABLE public.mrr (
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
       public          postgres    false    236                       0    0    mrr_sl_no_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE public.mrr_sl_no_seq OWNED BY public.mrr.sl_no;
          public          postgres    false    238            �            1259    16525    new_item_price    TABLE     ?  CREATE TABLE public.new_item_price (
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
       public          postgres    false    242                       0    0    payment1_sl_no_seq    SEQUENCE OWNED BY     H   ALTER SEQUENCE public.payment1_sl_no_seq OWNED BY public.payment.sl_no;
          public          postgres    false    243            �            1259    16548    payment_desc    TABLE     �   CREATE TABLE public.payment_desc (
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
       public          postgres    false    206                       0    0    payment_desc_2_sl_no_seq    SEQUENCE OWNED BY     d   ALTER SEQUENCE public.payment_desc_2_sl_no_seq OWNED BY public.dept_expenditure_payment_desc.sl_no;
          public          postgres    false    245            �            1259    16553    payment_invoice_sl_no_seq    SEQUENCE     �   CREATE SEQUENCE public.payment_invoice_sl_no_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 0   DROP SEQUENCE public.payment_invoice_sl_no_seq;
       public          postgres    false    201                        0    0    payment_invoice_sl_no_seq    SEQUENCE OWNED BY     P   ALTER SEQUENCE public.payment_invoice_sl_no_seq OWNED BY public.approval.sl_no;
          public          postgres    false    246            �            1259    16555    payment_purpose_desc    TABLE        CREATE TABLE public.payment_purpose_desc (
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
       public         heap    postgres    false            �           2604    24691    CustomerBankAccount id    DEFAULT     �   ALTER TABLE ONLY public."CustomerBankAccount" ALTER COLUMN id SET DEFAULT nextval('public."CustomerBankAccount_id_seq"'::regclass);
 G   ALTER TABLE public."CustomerBankAccount" ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    278    277    278            �           2604    24664    CustomerContactPerson id    DEFAULT     �   ALTER TABLE ONLY public."CustomerContactPerson" ALTER COLUMN id SET DEFAULT nextval('public."CustomerContactPerson_id_seq"'::regclass);
 I   ALTER TABLE public."CustomerContactPerson" ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    273    274    274            �           2604    24653    CustomerMaster id    DEFAULT     z   ALTER TABLE ONLY public."CustomerMaster" ALTER COLUMN id SET DEFAULT nextval('public."CustomerMaster_id_seq"'::regclass);
 B   ALTER TABLE public."CustomerMaster" ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    272    271    272            �           2604    24675    CustomerPrincipalPlace id    DEFAULT     �   ALTER TABLE ONLY public."CustomerPrincipalPlace" ALTER COLUMN id SET DEFAULT nextval('public."CustomerPrincipalPlace_id_seq"'::regclass);
 J   ALTER TABLE public."CustomerPrincipalPlace" ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    276    275    276            �           2604    24753    ItemPackageSizeMaster id    DEFAULT     �   ALTER TABLE ONLY public."ItemPackageSizeMaster" ALTER COLUMN id SET DEFAULT nextval('public."ItemPackageSizeMaster_id_seq"'::regclass);
 I   ALTER TABLE public."ItemPackageSizeMaster" ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    282    283    283            }           2604    24619    NonSubsidyPODetails id    DEFAULT     �   ALTER TABLE ONLY public."NonSubsidyPODetails" ALTER COLUMN id SET DEFAULT nextval('public."NonSubsidyPODetails_id_seq"'::regclass);
 G   ALTER TABLE public."NonSubsidyPODetails" ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    268    269    269            l           2604    16956    VendorBankAccount BankAccountID    DEFAULT     �   ALTER TABLE ONLY public."VendorBankAccount" ALTER COLUMN "BankAccountID" SET DEFAULT nextval('public."VendorBankAccount_BankAccountID_seq"'::regclass);
 R   ALTER TABLE public."VendorBankAccount" ALTER COLUMN "BankAccountID" DROP DEFAULT;
       public          postgres    false    262    261    262            j           2604    16919 #   VendorContactPerson ContactPersonID    DEFAULT     �   ALTER TABLE ONLY public."VendorContactPerson" ALTER COLUMN "ContactPersonID" SET DEFAULT nextval('public."VendorContactPerson_ContactPersonID_seq"'::regclass);
 V   ALTER TABLE public."VendorContactPerson" ALTER COLUMN "ContactPersonID" DROP DEFAULT;
       public          postgres    false    257    258    258            k           2604    16935 %   VendorPrincipalPlace PrincipalPlaceID    DEFAULT     �   ALTER TABLE ONLY public."VendorPrincipalPlace" ALTER COLUMN "PrincipalPlaceID" SET DEFAULT nextval('public."VendorPrincipalPlace_PrincipalPlaceID_seq"'::regclass);
 X   ALTER TABLE public."VendorPrincipalPlace" ALTER COLUMN "PrincipalPlaceID" DROP DEFAULT;
       public          postgres    false    259    260    260            X           2604    16582    approval sl_no    DEFAULT     w   ALTER TABLE ONLY public.approval ALTER COLUMN sl_no SET DEFAULT nextval('public.payment_invoice_sl_no_seq'::regclass);
 =   ALTER TABLE public.approval ALTER COLUMN sl_no DROP DEFAULT;
       public          postgres    false    246    201            Y           2604    16583    approval_desc serial    DEFAULT     |   ALTER TABLE ONLY public.approval_desc ALTER COLUMN serial SET DEFAULT nextval('public.approval_desc_serial_seq'::regclass);
 C   ALTER TABLE public.approval_desc ALTER COLUMN serial DROP DEFAULT;
       public          postgres    false    203    202            Z           2604    16584 #   dept_expenditure_payment_desc sl_no    DEFAULT     �   ALTER TABLE ONLY public.dept_expenditure_payment_desc ALTER COLUMN sl_no SET DEFAULT nextval('public.payment_desc_2_sl_no_seq'::regclass);
 R   ALTER TABLE public.dept_expenditure_payment_desc ALTER COLUMN sl_no DROP DEFAULT;
       public          postgres    false    245    206            \           2604    16585    farmer_receipt sl_no    DEFAULT     }   ALTER TABLE ONLY public.farmer_receipt ALTER COLUMN sl_no SET DEFAULT nextval('public.farmer_receipts_sl_no_seq'::regclass);
 C   ALTER TABLE public.farmer_receipt ALTER COLUMN sl_no DROP DEFAULT;
       public          postgres    false    214    213            [           2604    16586    govt_share_config sl    DEFAULT     |   ALTER TABLE ONLY public.govt_share_config ALTER COLUMN sl SET DEFAULT nextval('public.dept_money_config_sl_seq'::regclass);
 C   ALTER TABLE public.govt_share_config ALTER COLUMN sl DROP DEFAULT;
       public          postgres    false    208    207            ]           2604    16587    indent_old sl_no    DEFAULT     q   ALTER TABLE ONLY public.indent_old ALTER COLUMN sl_no SET DEFAULT nextval('public.indents_sl_no_seq'::regclass);
 ?   ALTER TABLE public.indent_old ALTER COLUMN sl_no DROP DEFAULT;
       public          postgres    false    218    216            ^           2604    16588    invoice sl_no    DEFAULT     n   ALTER TABLE ONLY public.invoice ALTER COLUMN sl_no SET DEFAULT nextval('public.invoice_sl_no_seq'::regclass);
 <   ALTER TABLE public.invoice ALTER COLUMN sl_no DROP DEFAULT;
       public          postgres    false    221    219            a           2604    16589 (   jalanidhi_dept_expnd_payment_desc serial    DEFAULT     �   ALTER TABLE ONLY public.jalanidhi_dept_expnd_payment_desc ALTER COLUMN serial SET DEFAULT nextval('public.jalanidhi_dept_expnd_payment_desc_serial_seq'::regclass);
 W   ALTER TABLE public.jalanidhi_dept_expnd_payment_desc ALTER COLUMN serial DROP DEFAULT;
       public          postgres    false    224    223            b           2604    16590    jalanidhi_payment_desc serial    DEFAULT     �   ALTER TABLE ONLY public.jalanidhi_payment_desc ALTER COLUMN serial SET DEFAULT nextval('public.jalanidhi_payment_desc_serial_seq'::regclass);
 L   ALTER TABLE public.jalanidhi_payment_desc ALTER COLUMN serial DROP DEFAULT;
       public          postgres    false    226    225            c           2604    16591    jn_expenditure_desc serial    DEFAULT     �   ALTER TABLE ONLY public.jn_expenditure_desc ALTER COLUMN serial SET DEFAULT nextval('public.jn_expenditure_desc_serial_seq'::regclass);
 I   ALTER TABLE public.jn_expenditure_desc ALTER COLUMN serial DROP DEFAULT;
       public          postgres    false    228    227            d           2604    16592 	   log sl_no    DEFAULT     f   ALTER TABLE ONLY public.log ALTER COLUMN sl_no SET DEFAULT nextval('public.log_sl_no_seq'::regclass);
 8   ALTER TABLE public.log ALTER COLUMN sl_no DROP DEFAULT;
       public          postgres    false    235    234            e           2604    16593 	   mrr sl_no    DEFAULT     f   ALTER TABLE ONLY public.mrr ALTER COLUMN sl_no SET DEFAULT nextval('public.mrr_sl_no_seq'::regclass);
 8   ALTER TABLE public.mrr ALTER COLUMN sl_no DROP DEFAULT;
       public          postgres    false    238    236            f           2604    16594    payment sl_no    DEFAULT     o   ALTER TABLE ONLY public.payment ALTER COLUMN sl_no SET DEFAULT nextval('public.payment1_sl_no_seq'::regclass);
 <   ALTER TABLE public.payment ALTER COLUMN sl_no DROP DEFAULT;
       public          postgres    false    243    242            �          0    24688    CustomerBankAccount 
   TABLE DATA           �   COPY public."CustomerBankAccount" (id, "CustomerID", "BankAccountID", "bankAccountNo", "accountType", "bankName", "branchName", "ifscCode", "InsertedDate", "InsertedBy", "UpdatedDate", "UpdatedBy") FROM stdin;
    public          postgres    false    278   6      �          0    24661    CustomerContactPerson 
   TABLE DATA           �   COPY public."CustomerContactPerson" (id, "CustomerID", "ContactPersonID", "AuthorisedName", "AuthorisedMobileNo", "AuthorisedEmailID", "Designation", "InsertedDate", "InsertedBy", "UpdatedDate", "UpdatedBy") FROM stdin;
    public          postgres    false    274   i$                0    24757    CustomerDistrictMapping 
   TABLE DATA           _   COPY public."CustomerDistrictMapping" ("CustomerID", "DistrictID", "InsertedDate") FROM stdin;
    public          postgres    false    284   ^7                0    24781    CustomerInvoiceMaster 
   TABLE DATA           N  COPY public."CustomerInvoiceMaster" ("CustomerInvoiceNo", "MRRNo", "InvoiceNo", "PONo", "OrderReferenceNo", "POType", "FinYear", "DistrictID", "VendorID", "InvoiceAmount", "NoOfOrderDeliver", "DeliveredQuantity", "InsertedDate", "InsertedBy", "UpdatedDate", "UpdatedBy", "CustomerID", "DivisionID", "Implement", "Make", "Model", "HSN", "UnitOfMeasurement", "PackageSize", "PackageUnitOfMeasurement", "PackageQuantity", "ItemQuantity", "TaxRate", "RatePerUnit", "PurchaseInvoiceValue", "PurchaseCGST", "PurchaseSGST", "PurchaseIGST", "TotalPurchaseInvoiceValue", "TotalPurchaseTaxableValue", "TotalPurchaseCGST", "TotalPurchaseSGST", "SellCGST", "SellSGST", "SellIGST", "SellInvoiceValue", "SellTaxableValue", "TotalSellCGST", "TotalSellSGST", "TotalSellIGST", "TotalSellInvoiceValue", "TotalSellTaxableValue", "PurchaseTaxableValue") FROM stdin;
    public          postgres    false    285   �=      �          0    24650    CustomerMaster 
   TABLE DATA           �   COPY public."CustomerMaster" (id, "CustomerID", "LegalCustomerName", "TradeName", "PAN", "BussinessConstitution", "GSTN", "ContactNumber", "EmailID", "InsertedDate", "InsertedBy") FROM stdin;
    public          postgres    false    272   �>      �          0    24672    CustomerPrincipalPlace 
   TABLE DATA           �   COPY public."CustomerPrincipalPlace" (id, "CustomerID", "PrincipalPlaceID", "Country", "StateCode", "DistrictOrCity", "Pincode", "Address", "InsertedDate", "InsertedBy", "UpdatedDate", "UpdatedBy") FROM stdin;
    public          postgres    false    276   -a      �          0    24581    DivisionMaster 
   TABLE DATA           H   COPY public."DivisionMaster" ("DivisionID", "DivisionName") FROM stdin;
    public          postgres    false    266   }u      �          0    24724    InvoiceMaster 
   TABLE DATA           I  COPY public."InvoiceMaster" ("InvoiceNo", "PONo", "OrderReferenceNo", "InvoiceDate", "WayBillNo", "WayBillDate", "TruckNo", "FinYear", "DistrictID", "VendorID", "Status", "PaymentStatus", "InvoiceAmount", "InvoicePath", "POType", "NoOfOrderInPO", "NoOfOrderDeliver", "InsertedDate", "InsertedBy", "UpdatedDate", "UpdatedBy", "IsReceived", "ReceivedDate", "EngineNumber", "ChassicNumber", "MRRNo", "TotalPurchaseTaxableValue", "TotalPurchaseInvoiceValue", "TotalPurchaseCGST", "TotalPurchaseSGST", "TotalPurchaseIGST", "SupplyQuantity", "SupplyPackageQuantity", "Discount") FROM stdin;
    public          postgres    false    280   �u                 0    24737    ItemPackageMaster 
   TABLE DATA           W  COPY public."ItemPackageMaster" ("DivisionID", "Implement", "Make", "Model", "PackageSize", "UnitOfMeasurement", "PurchaseInvoiceValue", "PurchaseTaxableValue", "PurchaseCGST", "PurchaseSGST", "PurchaseIGST", "SellSGST", "SellIGST", "SellInvoiceValue", "SellTaxableValue", "InsertedDate", "InsertedBy", "UpdatedDate", "UpdatedBy") FROM stdin;
    public          postgres    false    281   ׊                0    24750    ItemPackageSizeMaster 
   TABLE DATA           D   COPY public."ItemPackageSizeMaster" (id, "PackageSize") FROM stdin;
    public          postgres    false    283   ��      �          0    24628 	   MRRMaster 
   TABLE DATA           '  COPY public."MRRMaster" ("MRRNo", "InvoiceNo", "PONo", "OrderReferenceNo", "FinYear", "ItemQuantity", "MRRAmount", "VendorID", "DistrictID", "DMID", "AccID", "PaymentStatus", "POType", "InsertedDate", "InsertedBy", "UpdatedDate", "UpdatedBy", "NoOfItemReceived", "ReceivedQuantity") FROM stdin;
    public          postgres    false    270   �      �          0    24616    NonSubsidyPODetails 
   TABLE DATA             COPY public."NonSubsidyPODetails" (id, "OrderReferenceNo", "PONo", "CustomerID", "DivisionID", "Implement", "Make", "Model", "UnitOfMeasurement", "HSN", "TaxRate", "PurchaseInvoiceValue", "PurchaseTaxableValue", "PurchaseCGST", "PurchaseSGST", "PurchaseIGST", "SellCGST", "SellSGST", "SellIGST", "SellInvoiceValue", "SellTaxableValue", "ItemQuantity", "ItemQuantitySold", "EngineNumber", "ChassicNumber", "IsDelivered", "IsReceived", "IsDeliveredToCustomer", "InsertedDate", "InsertedBy", "UpdatedDate", "UpdatedBy") FROM stdin;
    public          postgres    false    269   ·      �          0    24597    POMaster 
   TABLE DATA           �  COPY public."POMaster" ("FinYear", "PONo", "OrderReferenceNo", "CustomerID", "CustomerOrderRefence", "VendorID", "DistrictID", "DMID", "AccID", "DivisionID", "Implement", "Make", "Model", "UnitOfMeasurement", "HSN", "TaxRate", "PurchaseInvoiceValue", "PurchaseTaxableValue", "PurchaseCGST", "PurchaseSGST", "PurchaseIGST", "TotalPurchaseInvoiceValue", "TotalPurchaseTaxableValue", "TotalPurchaseCGST", "TotalPurchaseSGST", "SellCGST", "SellSGST", "SellIGST", "SellInvoiceValue", "SellTaxableValue", "TotalSellCGST", "TotalSellSGST", "TotalSellIGST", "TotalSellInvoiceValue", "TotalSellTaxableValue", "POAmount", "NoOfItemsInPO", "ItemQuantity", "ItemQuantitySold", "EngineNumber", "ChassicNumber", "IsDelivered", "IsReceived", "IsDeliveredToCustomer", "Status", "InsertedDate", "InsertedBy", "UpdatedDate", "UpdatedBy", "IsApproved", "ApprovalStatus", "ApprovedDate", "ApprovedBy", "IsDeleted", "DeletedDate", "DeletedBy", "IsCancelled", "CancellationStatus", "CancelledDate", "CancelledBy", "POType", "VendorInvoiceNo", "MRRID", "RatePerUnit", "PackageQuantity", "PackageSize", "PackageUnitOfMeasurement", "DeliveredQuantity", "PendingQuantity") FROM stdin;
    public          postgres    false    267   ߷      �          0    16793    StateMaster 
   TABLE DATA           A   COPY public."StateMaster" ("StateCode", "StateName") FROM stdin;
    public          postgres    false    255   ��      �          0    16953    VendorBankAccount 
   TABLE DATA           �   COPY public."VendorBankAccount" ("VendorID", "BankAccountID", "AccountNumber", "AccountType", "BankName", "BranchName", "IFSCCode", "BankDocument", "InsertedDate", "InsertedBy", "UpdatedDate", "UpdatedBy") FROM stdin;
    public          postgres    false    262   �      �          0    16916    VendorContactPerson 
   TABLE DATA           �   COPY public."VendorContactPerson" ("VendorID", "ContactPersonID", "Name", "FathersName", "MobileNumber", "EmailID", "Designation", "InsertedDate", "InsertedBy") FROM stdin;
    public          postgres    false    258   �      �          0    16980    VendorDistrictMapping 
   TABLE DATA           [   COPY public."VendorDistrictMapping" ("VendorID", "DistrictID", "InsertedDate") FROM stdin;
    public          postgres    false    264   Y�      �          0    16903    VendorMaster 
   TABLE DATA           �  COPY public."VendorMaster" ("VendorID", "LegalBussinessName", "TradeName", "PAN", "PANDocument", "BussinessConstitution", "GSTN", "GSTNDocument", "IncorporationDate", "ContactNumber", "EmailID", "ApprovalStatus", "ApplyStatus", "InsertedDate", "InsertedBy", "IsDeleted", "ApproveOrRejectDate", "ApproveOrRejectBy", "WhetherSSIUnit", "WhetherMSME", "SSIUnitRegistrationCertificate", "MSMECertificate", "CoreBussinessActivity", "Turnover1", "Turnover2", "Turnover3", "Password") FROM stdin;
    public          postgres    false    256   ��      �          0    16932    VendorPrincipalPlace 
   TABLE DATA           �   COPY public."VendorPrincipalPlace" ("VendorID", "PrincipalPlaceID", "Country", "StateCode", "DistrictOrCity", "Pincode", "Address", "InsertedDate", "InsertedBy") FROM stdin;
    public          postgres    false    260   �2      �          0    16967    VendorServices 
   TABLE DATA           _   COPY public."VendorServices" ("VendorID", "Service", "InsertedDate", "InsertedBy") FROM stdin;
    public          postgres    false    263   
F      �          0    16385 
   acc_master 
   TABLE DATA           ~   COPY public.acc_master (acc_name, acc_id, dist_id, dist_name, acc_address, acc_mobile_no, "UpdateOn", "UpdateBy") FROM stdin;
    public          postgres    false    200   sM      �          0    16388    approval 
   TABLE DATA           $  COPY public.approval (sl_no, invoice_no, fin_year, dist_id, dl_id, status, approval_id, indent_no, approval_date, ammount, transaction_id, deduction_amount, pay_now_amount, payment_status, remark, dl_remark, paid_amount, pp_id, pp_status, dm_approved_on, bank_approved_on, items) FROM stdin;
    public          postgres    false    201   zT      �          0    16394    approval_desc 
   TABLE DATA           O   COPY public.approval_desc (approval_id, permit_no, serial, mrr_id) FROM stdin;
    public          postgres    false    202   ]      �          0    16402    approval_status_desc 
   TABLE DATA           A   COPY public.approval_status_desc (status_id, "desc") FROM stdin;
    public          postgres    false    204   �^      �          0    16405 
   components 
   TABLE DATA           C   COPY public.components (comp_id, schema_id, comp_name) FROM stdin;
    public          postgres    false    205   B_      �          0    16408    dept_expenditure_payment_desc 
   TABLE DATA           �   COPY public.dept_expenditure_payment_desc (sl_no, reference_no, transaction_id, source_id, schem_id, comp_id, head_id, subhead_id, head_name, subhead_name, sd_path) FROM stdin;
    public          postgres    false    206   �_      �          0    16416    dist_dealer_mapping 
   TABLE DATA           G   COPY public.dist_dealer_mapping (fin_year, dl_id, dist_id) FROM stdin;
    public          postgres    false    209   c      �          0    16419    dist_master 
   TABLE DATA           E   COPY public.dist_master (dist_id, dist_name, "DistCode") FROM stdin;
    public          postgres    false    210   pc      �          0    16428 	   dl_master 
   TABLE DATA             COPY public.dl_master (dl_id, dl_name, bank_name, dl_ac_no, dl_ifsc_code, dl_mobile_no, dl_email, dl_address, add_date, modify_date, "LegalBussinessName", "TradeName", "PAN", "PANDocument", "BussinessConstitution", "GSTN", "GSTNDocument", "IncorporationDate", "ContactNumber", "EmailID", "Password", "ApprovalStatus", "InsertedDate", "InsertedBy", "IsDeleted", "ApproveOrRejectDate", "ApproveOrRejectBy", "WhetherSSIUnit", "WhetherMSME", "SSIUnitRegistrationCertificate", "MSMECertificate", "CoreBussinessActivity") FROM stdin;
    public          postgres    false    211   �d      �          0    16434 	   dm_master 
   TABLE DATA           �   COPY public.dm_master (dist_id, dist_name, dm_id, dm_name, dm_address, dm_mobile_no, "UpdateOn", "UpdateBy", "EmailID", "BankName", "BranchName", "AccountNumber", "IFSCCode") FROM stdin;
    public          postgres    false    212   ɇ      �          0    16437    farmer_receipt 
   TABLE DATA           �   COPY public.farmer_receipt (sl_no, receipt_no, fin_year, farmer_name, farmer_id, full_ammount, permit_no, implement, payment_mode, payment_no, source_bank, date, dist_id, office, payment_date) FROM stdin;
    public          postgres    false    213   ,�      �          0    16411    govt_share_config 
   TABLE DATA           S   COPY public.govt_share_config (sl, fin_year, head, govt_share_ammount) FROM stdin;
    public          postgres    false    207   g�      �          0    16442    head_master 
   TABLE DATA           9   COPY public.head_master (head_id, head_name) FROM stdin;
    public          postgres    false    215   ��      �          0    16998    indent 
   TABLE DATA           
  COPY public.indent (indent_no, "PONo", fin_year, "FinYear", dist_id, "DistrictID", "DMID", "AccID", dl_id, "VendorID", "PermitNumber", "FarmerID", items, "POAmount", indent_ammount, status, "Status", indent_date, "InsertedDate", "InsertedBy", "UpdatedDate", "UpdatedBy", "IsApproved", "ApprovalStatus", "ApprovedDate", "ApprovedBy", "IsDeleted", "DeletedDate", "DeletedBy", "IsCancelled", "CancellationStatus", "CancelledDate", "CancelledBy", "CustomerID", "POType", " CustomerID", "VendorInvoiceNo", "MRRID") FROM stdin;
    public          postgres    false    265   ��      �          0    16448    indent_desc 
   TABLE DATA           ;   COPY public.indent_desc (indent_no, permit_no) FROM stdin;
    public          postgres    false    217   �      �          0    16445 
   indent_old 
   TABLE DATA           �   COPY public.indent_old (sl_no, indent_no, dist_id, indent_date, dl_id, fin_year, status, items, indent_ammount, "accountantID") FROM stdin;
    public          postgres    false    216   )�      �          0    16453    invoice 
   TABLE DATA           #  COPY public.invoice (sl_no, invoice_no, invoice_date, rr_way_bill_no, wagon_truck_no, challan_no, challan_date, fin_year, dist_id, dl_id, bill_no, bill_date, status, rr_way_bill_date, discount, indent_no, payment_status, items, invoice_ammount, invoice_path, gst_rate, "POType") FROM stdin;
    public          postgres    false    219    �      �          0    16459    invoice_desc 
   TABLE DATA           =   COPY public.invoice_desc (invoice_no, permit_no) FROM stdin;
    public          postgres    false    220   ��      �          0    16467    item_price_map_1 
   TABLE DATA           r  COPY public.item_price_map_1 ("Implement", "Make", "Model", p_taxable_value, p_cgst_6, p_sgst_6, p_cgst_1, p_sgst_1, p_invoice_value, s_taxable_value, s_cgst_6, s_sgst_6, s_invoice_value, p_igst_12, s_igst_12, add_date, update_date, "Division", "HSN", "UnitOfMeasurement", "GSTApplicability", "Taxability", "TaxRate", "PurchaseInvoiceValue", "PurchaseTaxableValue", "PurchaseCGST", "PurchaseSGST", "PurchaseIGST", "PurchaseSGSTOnePercent", "PurchaseCGSTOnePercent", "SellCGST", "SellSGST", "SellIGST", "SellInvoiceValue", "SellTaxableValue", "InsertedDate", "InsertedBy", "UpdatedDate", "UpdatedBy", "DivisionID") FROM stdin;
    public          postgres    false    222   �      �          0    16473 !   jalanidhi_dept_expnd_payment_desc 
   TABLE DATA           t   COPY public.jalanidhi_dept_expnd_payment_desc (serial, transaction_id, scheme_id, scheme_name, comp_id) FROM stdin;
    public          postgres    false    223         �          0    16478    jalanidhi_payment_desc 
   TABLE DATA           �   COPY public.jalanidhi_payment_desc (transaction_id, farmer_id, farmer_name, implement, make, model, serial, project_id) FROM stdin;
    public          postgres    false    225   �      �          0    16483    jn_expenditure_desc 
   TABLE DATA           f   COPY public.jn_expenditure_desc (transaction_id, item_name, item_price, quantity, serial) FROM stdin;
    public          postgres    false    227   t      �          0    16488 	   jn_orders 
   TABLE DATA           {   COPY public.jn_orders (fin_year, dist_id, cluster_id, farmer_id, dist_name, farmer_name, status, date, system) FROM stdin;
    public          postgres    false    229   l      �          0    16491    jn_stock 
   TABLE DATA           �   COPY public.jn_stock (fin_year, dist_id, dl_id, system, po_no, cluster_id, farmer_id, farmer_name, implement, make, model, engine_no, chassic_no, status, receive_date, deliver_date, dl_name) FROM stdin;
    public          postgres    false    230   -      �          0    16497    lgd_block_master 
   TABLE DATA           M   COPY public.lgd_block_master (dist_code, block_code, block_name) FROM stdin;
    public          postgres    false    231   �      �          0    16503    lgd_dist_master 
   TABLE DATA           ?   COPY public.lgd_dist_master (dist_code, dist_name) FROM stdin;
    public          postgres    false    232   /      �          0    16506    lgd_gp_master 
   TABLE DATA           P   COPY public.lgd_gp_master (dist_code, block_code, gp_code, gp_name) FROM stdin;
    public          postgres    false    233   6      �          0    16509    log 
   TABLE DATA           �   COPY public.log (sl_no, date_time, user_id, action, status, ref_url, route, ip, browser_name, browser_version, fin_year, remark) FROM stdin;
    public          postgres    false    234   ��      �          0    16517    mrr 
   TABLE DATA           v   COPY public.mrr (sl_no, mrr_id, dist_id, invoice_no, fin_year, dl_id, date, items, indent_no, mrr_amount) FROM stdin;
    public          postgres    false    236    �      �          0    16520    mrr_desc 
   TABLE DATA           5   COPY public.mrr_desc (mrr_id, permit_no) FROM stdin;
    public          postgres    false    237         �          0    16525    new_item_price 
   TABLE DATA           �   COPY public.new_item_price (implement, make, model, purchase_price, taxable_value, cgst_6, sags_6, invoice_alue, selling_price, sl_taxable_value, sl_cgst_6, sl_sgst_6, sl_invoice_value) FROM stdin;
    public          postgres    false    239   �      �          0    16531    opening_balance 
   TABLE DATA           �   COPY public.opening_balance (fin_year, date, system, dist_id, transaction_id, ammount, remark, purpose, reference_no, "from", "to", head, subhead, payment_type, payment_date, payment_no, test) FROM stdin;
    public          postgres    false    240   �      �          0    16537    orders 
   TABLE DATA           �  COPY public.orders (permit_no, permit_issue_date, permit_validity, farmer_id, farmer_name, farmer_father_name, dist_name, block_name, gp_name, village_name, implement, make, model, status, permit_validity_1, permit_issue_date_1, fin_year, dist_id, engine_no, chassic_no, ammount, remark, expected_delivery_date, delivery_date, c_fin_year, date, system, paid_amount, order_type, "FullCost", "PendingCost") FROM stdin;
    public          postgres    false    241   �!      �          0    16543    payment 
   TABLE DATA           �   COPY public.payment (sl_no, date, reference_no, transaction_id, "from", "to", remark, payment_type, payment_no, fin_year, purpose, payment_date, ammount, status, system, source_bank, "DivisionID", "Implement") FROM stdin;
    public          postgres    false    242   c      �          0    16548    payment_desc 
   TABLE DATA           D   COPY public.payment_desc (transaction_id, reference_no) FROM stdin;
    public          postgres    false    244   ��      �          0    16555    payment_purpose_desc 
   TABLE DATA           B   COPY public.payment_purpose_desc (purpose_id, "desc") FROM stdin;
    public          postgres    false    247   ��      �          0    16558    schem_master 
   TABLE DATA           <   COPY public.schem_master (schem_id, schem_name) FROM stdin;
    public          postgres    false    248   ��      �          0    16561    source_master 
   TABLE DATA           ?   COPY public.source_master (source_id, source_name) FROM stdin;
    public          postgres    false    249   Ɨ      �          0    16564    subheads 
   TABLE DATA           E   COPY public.subheads (subhead_id, head_id, subhead_name) FROM stdin;
    public          postgres    false    250   �      �          0    16567    system_desc 
   TABLE DATA           8   COPY public.system_desc (system_id, "desc") FROM stdin;
    public          postgres    false    251   ��      �          0    16570 
   tax_config 
   TABLE DATA           6   COPY public.tax_config (tax_mode, "desc") FROM stdin;
    public          postgres    false    252   �      �          0    16573    users 
   TABLE DATA           8   COPY public.users (user_id, password, role) FROM stdin;
    public          postgres    false    253   &�      �          0    16576    vender_master 
   TABLE DATA              COPY public.vender_master ("VendorId", "VendorRegNo", "DateOfReg", "Name", "FarmName", "IsVerified", "IsReject", "RejectRemarkStausId", "UserName", "Password", "Type", "IPAddress", "FinancialYear", "UpdatedOn", "UpdatedBy", "DeletedOn", "DeletedBy", "IsUpdated", "IsDeleted") FROM stdin;
    public          postgres    false    254   V�      !           0    0    CustomerBankAccount_id_seq    SEQUENCE SET     K   SELECT pg_catalog.setval('public."CustomerBankAccount_id_seq"', 36, true);
          public          postgres    false    277            "           0    0    CustomerContactPerson_id_seq    SEQUENCE SET     N   SELECT pg_catalog.setval('public."CustomerContactPerson_id_seq"', 141, true);
          public          postgres    false    273            #           0    0    CustomerMaster_id_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('public."CustomerMaster_id_seq"', 177, true);
          public          postgres    false    271            $           0    0    CustomerPrincipalPlace_id_seq    SEQUENCE SET     O   SELECT pg_catalog.setval('public."CustomerPrincipalPlace_id_seq"', 202, true);
          public          postgres    false    275            %           0    0    ItemPackageSizeMaster_id_seq    SEQUENCE SET     M   SELECT pg_catalog.setval('public."ItemPackageSizeMaster_id_seq"', 19, true);
          public          postgres    false    282            &           0    0    NonSubsidyPODetails_id_seq    SEQUENCE SET     K   SELECT pg_catalog.setval('public."NonSubsidyPODetails_id_seq"', 1, false);
          public          postgres    false    268            '           0    0 #   VendorBankAccount_BankAccountID_seq    SEQUENCE SET     T   SELECT pg_catalog.setval('public."VendorBankAccount_BankAccountID_seq"', 90, true);
          public          postgres    false    261            (           0    0 '   VendorContactPerson_ContactPersonID_seq    SEQUENCE SET     Y   SELECT pg_catalog.setval('public."VendorContactPerson_ContactPersonID_seq"', 111, true);
          public          postgres    false    257            )           0    0 )   VendorPrincipalPlace_PrincipalPlaceID_seq    SEQUENCE SET     Z   SELECT pg_catalog.setval('public."VendorPrincipalPlace_PrincipalPlaceID_seq"', 99, true);
          public          postgres    false    259            *           0    0    approval_desc_serial_seq    SEQUENCE SET     H   SELECT pg_catalog.setval('public.approval_desc_serial_seq', 107, true);
          public          postgres    false    203            +           0    0    customer_id_increment    SEQUENCE SET     E   SELECT pg_catalog.setval('public.customer_id_increment', 177, true);
          public          postgres    false    279            ,           0    0    dept_money_config_sl_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.dept_money_config_sl_seq', 1, true);
          public          postgres    false    208            -           0    0    farmer_receipts_sl_no_seq    SEQUENCE SET     I   SELECT pg_catalog.setval('public.farmer_receipts_sl_no_seq', 632, true);
          public          postgres    false    214            .           0    0    indents_sl_no_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.indents_sl_no_seq', 245, true);
          public          postgres    false    218            /           0    0    invoice_sl_no_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.invoice_sl_no_seq', 353, true);
          public          postgres    false    221            0           0    0 ,   jalanidhi_dept_expnd_payment_desc_serial_seq    SEQUENCE SET     [   SELECT pg_catalog.setval('public.jalanidhi_dept_expnd_payment_desc_serial_seq', 12, true);
          public          postgres    false    224            1           0    0 !   jalanidhi_payment_desc_serial_seq    SEQUENCE SET     P   SELECT pg_catalog.setval('public.jalanidhi_payment_desc_serial_seq', 24, true);
          public          postgres    false    226            2           0    0    jn_expenditure_desc_serial_seq    SEQUENCE SET     M   SELECT pg_catalog.setval('public.jn_expenditure_desc_serial_seq', 36, true);
          public          postgres    false    228            3           0    0    log_sl_no_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.log_sl_no_seq', 5137, true);
          public          postgres    false    235            4           0    0    mrr_sl_no_seq    SEQUENCE SET     =   SELECT pg_catalog.setval('public.mrr_sl_no_seq', 229, true);
          public          postgres    false    238            5           0    0    payment1_sl_no_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public.payment1_sl_no_seq', 1296, true);
          public          postgres    false    243            6           0    0    payment_desc_2_sl_no_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('public.payment_desc_2_sl_no_seq', 93, true);
          public          postgres    false    245            7           0    0    payment_invoice_sl_no_seq    SEQUENCE SET     I   SELECT pg_catalog.setval('public.payment_invoice_sl_no_seq', 114, true);
          public          postgres    false    246            �           2606    24696 ,   CustomerBankAccount CustomerBankAccount_pkey 
   CONSTRAINT     n   ALTER TABLE ONLY public."CustomerBankAccount"
    ADD CONSTRAINT "CustomerBankAccount_pkey" PRIMARY KEY (id);
 Z   ALTER TABLE ONLY public."CustomerBankAccount" DROP CONSTRAINT "CustomerBankAccount_pkey";
       public            postgres    false    278            �           2606    24669 0   CustomerContactPerson CustomerContactPerson_pkey 
   CONSTRAINT     r   ALTER TABLE ONLY public."CustomerContactPerson"
    ADD CONSTRAINT "CustomerContactPerson_pkey" PRIMARY KEY (id);
 ^   ALTER TABLE ONLY public."CustomerContactPerson" DROP CONSTRAINT "CustomerContactPerson_pkey";
       public            postgres    false    274                       2606    24764 4   CustomerDistrictMapping CustomerDistrictMapping_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CustomerDistrictMapping"
    ADD CONSTRAINT "CustomerDistrictMapping_pkey" PRIMARY KEY ("CustomerID", "DistrictID");
 b   ALTER TABLE ONLY public."CustomerDistrictMapping" DROP CONSTRAINT "CustomerDistrictMapping_pkey";
       public            postgres    false    284    284                       2606    24809 0   CustomerInvoiceMaster CustomerInvoiceMaster_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CustomerInvoiceMaster"
    ADD CONSTRAINT "CustomerInvoiceMaster_pkey" PRIMARY KEY ("CustomerInvoiceNo", "OrderReferenceNo");
 ^   ALTER TABLE ONLY public."CustomerInvoiceMaster" DROP CONSTRAINT "CustomerInvoiceMaster_pkey";
       public            postgres    false    285    285            �           2606    24658 "   CustomerMaster CustomerMaster_pkey 
   CONSTRAINT     d   ALTER TABLE ONLY public."CustomerMaster"
    ADD CONSTRAINT "CustomerMaster_pkey" PRIMARY KEY (id);
 P   ALTER TABLE ONLY public."CustomerMaster" DROP CONSTRAINT "CustomerMaster_pkey";
       public            postgres    false    272            �           2606    24680 2   CustomerPrincipalPlace CustomerPrincipalPlace_pkey 
   CONSTRAINT     t   ALTER TABLE ONLY public."CustomerPrincipalPlace"
    ADD CONSTRAINT "CustomerPrincipalPlace_pkey" PRIMARY KEY (id);
 `   ALTER TABLE ONLY public."CustomerPrincipalPlace" DROP CONSTRAINT "CustomerPrincipalPlace_pkey";
       public            postgres    false    276            �           2606    24588 "   DivisionMaster DivisionMaster_pkey 
   CONSTRAINT     n   ALTER TABLE ONLY public."DivisionMaster"
    ADD CONSTRAINT "DivisionMaster_pkey" PRIMARY KEY ("DivisionID");
 P   ALTER TABLE ONLY public."DivisionMaster" DROP CONSTRAINT "DivisionMaster_pkey";
       public            postgres    false    266                        2606    24734     InvoiceMaster InvoiceMaster_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."InvoiceMaster"
    ADD CONSTRAINT "InvoiceMaster_pkey" PRIMARY KEY ("InvoiceNo", "PONo", "OrderReferenceNo");
 N   ALTER TABLE ONLY public."InvoiceMaster" DROP CONSTRAINT "InvoiceMaster_pkey";
       public            postgres    false    280    280    280                       2606    24772 (   ItemPackageMaster ItemPackageMaster_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."ItemPackageMaster"
    ADD CONSTRAINT "ItemPackageMaster_pkey" PRIMARY KEY ("DivisionID", "Implement", "Make", "Model", "PackageSize", "UnitOfMeasurement");
 V   ALTER TABLE ONLY public."ItemPackageMaster" DROP CONSTRAINT "ItemPackageMaster_pkey";
       public            postgres    false    281    281    281    281    281    281                       2606    24755 0   ItemPackageSizeMaster ItemPackageSizeMaster_pkey 
   CONSTRAINT     r   ALTER TABLE ONLY public."ItemPackageSizeMaster"
    ADD CONSTRAINT "ItemPackageSizeMaster_pkey" PRIMARY KEY (id);
 ^   ALTER TABLE ONLY public."ItemPackageSizeMaster" DROP CONSTRAINT "ItemPackageSizeMaster_pkey";
       public            postgres    false    283            �           2606    24636    MRRMaster MRRMaster_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."MRRMaster"
    ADD CONSTRAINT "MRRMaster_pkey" PRIMARY KEY ("MRRNo", "InvoiceNo", "PONo", "OrderReferenceNo");
 F   ALTER TABLE ONLY public."MRRMaster" DROP CONSTRAINT "MRRMaster_pkey";
       public            postgres    false    270    270    270    270            �           2606    24627 ,   NonSubsidyPODetails NonSubsidyPODetails_pkey 
   CONSTRAINT     n   ALTER TABLE ONLY public."NonSubsidyPODetails"
    ADD CONSTRAINT "NonSubsidyPODetails_pkey" PRIMARY KEY (id);
 Z   ALTER TABLE ONLY public."NonSubsidyPODetails" DROP CONSTRAINT "NonSubsidyPODetails_pkey";
       public            postgres    false    269            �           2606    24613    POMaster POMaster_pkey 
   CONSTRAINT     p   ALTER TABLE ONLY public."POMaster"
    ADD CONSTRAINT "POMaster_pkey" PRIMARY KEY ("PONo", "OrderReferenceNo");
 D   ALTER TABLE ONLY public."POMaster" DROP CONSTRAINT "POMaster_pkey";
       public            postgres    false    267    267            �           2606    16797    StateMaster StateMaster_pkey 
   CONSTRAINT     g   ALTER TABLE ONLY public."StateMaster"
    ADD CONSTRAINT "StateMaster_pkey" PRIMARY KEY ("StateCode");
 J   ALTER TABLE ONLY public."StateMaster" DROP CONSTRAINT "StateMaster_pkey";
       public            postgres    false    255            �           2606    16961 (   VendorBankAccount VendorBankAccount_pkey 
   CONSTRAINT     w   ALTER TABLE ONLY public."VendorBankAccount"
    ADD CONSTRAINT "VendorBankAccount_pkey" PRIMARY KEY ("BankAccountID");
 V   ALTER TABLE ONLY public."VendorBankAccount" DROP CONSTRAINT "VendorBankAccount_pkey";
       public            postgres    false    262            �           2606    16924 ,   VendorContactPerson VendorContactPerson_pkey 
   CONSTRAINT     }   ALTER TABLE ONLY public."VendorContactPerson"
    ADD CONSTRAINT "VendorContactPerson_pkey" PRIMARY KEY ("ContactPersonID");
 Z   ALTER TABLE ONLY public."VendorContactPerson" DROP CONSTRAINT "VendorContactPerson_pkey";
       public            postgres    false    258            �           2606    16987 0   VendorDistrictMapping VendorDistrictMapping_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."VendorDistrictMapping"
    ADD CONSTRAINT "VendorDistrictMapping_pkey" PRIMARY KEY ("VendorID", "DistrictID");
 ^   ALTER TABLE ONLY public."VendorDistrictMapping" DROP CONSTRAINT "VendorDistrictMapping_pkey";
       public            postgres    false    264    264            �           2606    16913    VendorMaster VendorMaster_pkey 
   CONSTRAINT     h   ALTER TABLE ONLY public."VendorMaster"
    ADD CONSTRAINT "VendorMaster_pkey" PRIMARY KEY ("VendorID");
 L   ALTER TABLE ONLY public."VendorMaster" DROP CONSTRAINT "VendorMaster_pkey";
       public            postgres    false    256            �           2606    16940 .   VendorPrincipalPlace VendorPrincipalPlace_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."VendorPrincipalPlace"
    ADD CONSTRAINT "VendorPrincipalPlace_pkey" PRIMARY KEY ("PrincipalPlaceID");
 \   ALTER TABLE ONLY public."VendorPrincipalPlace" DROP CONSTRAINT "VendorPrincipalPlace_pkey";
       public            postgres    false    260            �           2606    16974 "   VendorServices VendorServices_pkey 
   CONSTRAINT     w   ALTER TABLE ONLY public."VendorServices"
    ADD CONSTRAINT "VendorServices_pkey" PRIMARY KEY ("VendorID", "Service");
 P   ALTER TABLE ONLY public."VendorServices" DROP CONSTRAINT "VendorServices_pkey";
       public            postgres    false    263    263            �           2606    16596 "   acc_master accountants_master_pkey 
   CONSTRAINT     m   ALTER TABLE ONLY public.acc_master
    ADD CONSTRAINT accountants_master_pkey PRIMARY KEY (acc_id, dist_id);
 L   ALTER TABLE ONLY public.acc_master DROP CONSTRAINT accountants_master_pkey;
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
       public            postgres    false    207            �           2606    16606 &   dist_dealer_mapping dist_dl_map_1_pkey 
   CONSTRAINT     z   ALTER TABLE ONLY public.dist_dealer_mapping
    ADD CONSTRAINT dist_dl_map_1_pkey PRIMARY KEY (fin_year, dl_id, dist_id);
 P   ALTER TABLE ONLY public.dist_dealer_mapping DROP CONSTRAINT dist_dl_map_1_pkey;
       public            postgres    false    209    209    209            �           2606    16608    dist_master dist_master_1_pkey 
   CONSTRAINT     a   ALTER TABLE ONLY public.dist_master
    ADD CONSTRAINT dist_master_1_pkey PRIMARY KEY (dist_id);
 H   ALTER TABLE ONLY public.dist_master DROP CONSTRAINT dist_master_1_pkey;
       public            postgres    false    210            �           2606    16614    dl_master dl_master_1_pkey 
   CONSTRAINT     [   ALTER TABLE ONLY public.dl_master
    ADD CONSTRAINT dl_master_1_pkey PRIMARY KEY (dl_id);
 D   ALTER TABLE ONLY public.dl_master DROP CONSTRAINT dl_master_1_pkey;
       public            postgres    false    211            �           2606    16616    dm_master dm_master_pkey 
   CONSTRAINT     Y   ALTER TABLE ONLY public.dm_master
    ADD CONSTRAINT dm_master_pkey PRIMARY KEY (dm_id);
 B   ALTER TABLE ONLY public.dm_master DROP CONSTRAINT dm_master_pkey;
       public            postgres    false    212            �           2606    24577 #   farmer_receipt farmer_receipts_pkey 
   CONSTRAINT     i   ALTER TABLE ONLY public.farmer_receipt
    ADD CONSTRAINT farmer_receipts_pkey PRIMARY KEY (receipt_no);
 M   ALTER TABLE ONLY public.farmer_receipt DROP CONSTRAINT farmer_receipts_pkey;
       public            postgres    false    213            �           2606    16620    head_master head_master_pkey 
   CONSTRAINT     _   ALTER TABLE ONLY public.head_master
    ADD CONSTRAINT head_master_pkey PRIMARY KEY (head_id);
 F   ALTER TABLE ONLY public.head_master DROP CONSTRAINT head_master_pkey;
       public            postgres    false    215            �           2606    16622    indent_desc indent_desc_pkey 
   CONSTRAINT     l   ALTER TABLE ONLY public.indent_desc
    ADD CONSTRAINT indent_desc_pkey PRIMARY KEY (indent_no, permit_no);
 F   ALTER TABLE ONLY public.indent_desc DROP CONSTRAINT indent_desc_pkey;
       public            postgres    false    217    217            �           2606    17012    indent indent_pkey 
   CONSTRAINT     W   ALTER TABLE ONLY public.indent
    ADD CONSTRAINT indent_pkey PRIMARY KEY (indent_no);
 <   ALTER TABLE ONLY public.indent DROP CONSTRAINT indent_pkey;
       public            postgres    false    265            �           2606    16624    indent_old indents_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY public.indent_old
    ADD CONSTRAINT indents_pkey PRIMARY KEY (indent_no);
 A   ALTER TABLE ONLY public.indent_old DROP CONSTRAINT indents_pkey;
       public            postgres    false    216            �           2606    16626    invoice_desc invoice_desc_pkey 
   CONSTRAINT     o   ALTER TABLE ONLY public.invoice_desc
    ADD CONSTRAINT invoice_desc_pkey PRIMARY KEY (invoice_no, permit_no);
 H   ALTER TABLE ONLY public.invoice_desc DROP CONSTRAINT invoice_desc_pkey;
       public            postgres    false    220    220            �           2606    16628    invoice invoice_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.invoice
    ADD CONSTRAINT invoice_pkey PRIMARY KEY (invoice_no);
 >   ALTER TABLE ONLY public.invoice DROP CONSTRAINT invoice_pkey;
       public            postgres    false    219            �           2606    16632 '   item_price_map_1 item_price_map_1_pkey1 
   CONSTRAINT        ALTER TABLE ONLY public.item_price_map_1
    ADD CONSTRAINT item_price_map_1_pkey1 PRIMARY KEY ("Implement", "Make", "Model");
 Q   ALTER TABLE ONLY public.item_price_map_1 DROP CONSTRAINT item_price_map_1_pkey1;
       public            postgres    false    222    222    222            �           2606    16634 H   jalanidhi_dept_expnd_payment_desc jalanidhi_dept_expnd_payment_desc_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.jalanidhi_dept_expnd_payment_desc
    ADD CONSTRAINT jalanidhi_dept_expnd_payment_desc_pkey PRIMARY KEY (serial);
 r   ALTER TABLE ONLY public.jalanidhi_dept_expnd_payment_desc DROP CONSTRAINT jalanidhi_dept_expnd_payment_desc_pkey;
       public            postgres    false    223            �           2606    16636 2   jalanidhi_payment_desc jalanidhi_payment_desc_pkey 
   CONSTRAINT     t   ALTER TABLE ONLY public.jalanidhi_payment_desc
    ADD CONSTRAINT jalanidhi_payment_desc_pkey PRIMARY KEY (serial);
 \   ALTER TABLE ONLY public.jalanidhi_payment_desc DROP CONSTRAINT jalanidhi_payment_desc_pkey;
       public            postgres    false    225            �           2606    16638 ,   jn_expenditure_desc jn_expenditure_desc_pkey 
   CONSTRAINT     n   ALTER TABLE ONLY public.jn_expenditure_desc
    ADD CONSTRAINT jn_expenditure_desc_pkey PRIMARY KEY (serial);
 V   ALTER TABLE ONLY public.jn_expenditure_desc DROP CONSTRAINT jn_expenditure_desc_pkey;
       public            postgres    false    227            �           2606    16640    jn_orders jn_orders_pkey 
   CONSTRAINT     i   ALTER TABLE ONLY public.jn_orders
    ADD CONSTRAINT jn_orders_pkey PRIMARY KEY (cluster_id, farmer_id);
 B   ALTER TABLE ONLY public.jn_orders DROP CONSTRAINT jn_orders_pkey;
       public            postgres    false    229    229            �           2606    16642    jn_stock jn_stock_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.jn_stock
    ADD CONSTRAINT jn_stock_pkey PRIMARY KEY (po_no, cluster_id, farmer_id, implement, make, model);
 @   ALTER TABLE ONLY public.jn_stock DROP CONSTRAINT jn_stock_pkey;
       public            postgres    false    230    230    230    230    230    230            �           2606    16644 &   lgd_block_master lgd_block_master_pkey 
   CONSTRAINT     l   ALTER TABLE ONLY public.lgd_block_master
    ADD CONSTRAINT lgd_block_master_pkey PRIMARY KEY (block_code);
 P   ALTER TABLE ONLY public.lgd_block_master DROP CONSTRAINT lgd_block_master_pkey;
       public            postgres    false    231            �           2606    16646 $   lgd_dist_master lgd_dist_master_pkey 
   CONSTRAINT     i   ALTER TABLE ONLY public.lgd_dist_master
    ADD CONSTRAINT lgd_dist_master_pkey PRIMARY KEY (dist_code);
 N   ALTER TABLE ONLY public.lgd_dist_master DROP CONSTRAINT lgd_dist_master_pkey;
       public            postgres    false    232            �           2606    16648     lgd_gp_master lgd_gp_master_pkey 
   CONSTRAINT     c   ALTER TABLE ONLY public.lgd_gp_master
    ADD CONSTRAINT lgd_gp_master_pkey PRIMARY KEY (gp_code);
 J   ALTER TABLE ONLY public.lgd_gp_master DROP CONSTRAINT lgd_gp_master_pkey;
       public            postgres    false    233            �           2606    16650    log log_pkey 
   CONSTRAINT     M   ALTER TABLE ONLY public.log
    ADD CONSTRAINT log_pkey PRIMARY KEY (sl_no);
 6   ALTER TABLE ONLY public.log DROP CONSTRAINT log_pkey;
       public            postgres    false    234            �           2606    16652    mrr_desc mrr_desc_pkey 
   CONSTRAINT     c   ALTER TABLE ONLY public.mrr_desc
    ADD CONSTRAINT mrr_desc_pkey PRIMARY KEY (mrr_id, permit_no);
 @   ALTER TABLE ONLY public.mrr_desc DROP CONSTRAINT mrr_desc_pkey;
       public            postgres    false    237    237            �           2606    16654    mrr mrr_pkey 
   CONSTRAINT     N   ALTER TABLE ONLY public.mrr
    ADD CONSTRAINT mrr_pkey PRIMARY KEY (mrr_id);
 6   ALTER TABLE ONLY public.mrr DROP CONSTRAINT mrr_pkey;
       public            postgres    false    236            �           2606    16656 "   new_item_price new_item_price_pkey 
   CONSTRAINT     t   ALTER TABLE ONLY public.new_item_price
    ADD CONSTRAINT new_item_price_pkey PRIMARY KEY (implement, make, model);
 L   ALTER TABLE ONLY public.new_item_price DROP CONSTRAINT new_item_price_pkey;
       public            postgres    false    239    239    239            �           2606    16658 $   opening_balance opening_balance_pkey 
   CONSTRAINT     n   ALTER TABLE ONLY public.opening_balance
    ADD CONSTRAINT opening_balance_pkey PRIMARY KEY (transaction_id);
 N   ALTER TABLE ONLY public.opening_balance DROP CONSTRAINT opening_balance_pkey;
       public            postgres    false    240            �           2606    16660    orders orders_pkey 
   CONSTRAINT     W   ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (permit_no);
 <   ALTER TABLE ONLY public.orders DROP CONSTRAINT orders_pkey;
       public            postgres    false    241            �           2606    16662    payment payment1_pkey 
   CONSTRAINT     _   ALTER TABLE ONLY public.payment
    ADD CONSTRAINT payment1_pkey PRIMARY KEY (transaction_id);
 ?   ALTER TABLE ONLY public.payment DROP CONSTRAINT payment1_pkey;
       public            postgres    false    242            �           2606    16664 1   dept_expenditure_payment_desc payment_desc_2_pkey 
   CONSTRAINT     r   ALTER TABLE ONLY public.dept_expenditure_payment_desc
    ADD CONSTRAINT payment_desc_2_pkey PRIMARY KEY (sl_no);
 [   ALTER TABLE ONLY public.dept_expenditure_payment_desc DROP CONSTRAINT payment_desc_2_pkey;
       public            postgres    false    206            �           2606    16666    payment_desc payment_desc_pkey 
   CONSTRAINT     v   ALTER TABLE ONLY public.payment_desc
    ADD CONSTRAINT payment_desc_pkey PRIMARY KEY (reference_no, transaction_id);
 H   ALTER TABLE ONLY public.payment_desc DROP CONSTRAINT payment_desc_pkey;
       public            postgres    false    244    244            �           2606    16668 !   approval payment_instruction_pkey 
   CONSTRAINT     b   ALTER TABLE ONLY public.approval
    ADD CONSTRAINT payment_instruction_pkey PRIMARY KEY (sl_no);
 K   ALTER TABLE ONLY public.approval DROP CONSTRAINT payment_instruction_pkey;
       public            postgres    false    201            �           2606    16670 .   payment_purpose_desc payment_purpose_desc_pkey 
   CONSTRAINT     t   ALTER TABLE ONLY public.payment_purpose_desc
    ADD CONSTRAINT payment_purpose_desc_pkey PRIMARY KEY (purpose_id);
 X   ALTER TABLE ONLY public.payment_purpose_desc DROP CONSTRAINT payment_purpose_desc_pkey;
       public            postgres    false    247            �           2606    16672    schem_master schema_master_pkey 
   CONSTRAINT     c   ALTER TABLE ONLY public.schem_master
    ADD CONSTRAINT schema_master_pkey PRIMARY KEY (schem_id);
 I   ALTER TABLE ONLY public.schem_master DROP CONSTRAINT schema_master_pkey;
       public            postgres    false    248            �           2606    16674     source_master source_master_pkey 
   CONSTRAINT     e   ALTER TABLE ONLY public.source_master
    ADD CONSTRAINT source_master_pkey PRIMARY KEY (source_id);
 J   ALTER TABLE ONLY public.source_master DROP CONSTRAINT source_master_pkey;
       public            postgres    false    249            �           2606    16676    subheads subhead_pkey 
   CONSTRAINT     [   ALTER TABLE ONLY public.subheads
    ADD CONSTRAINT subhead_pkey PRIMARY KEY (subhead_id);
 ?   ALTER TABLE ONLY public.subheads DROP CONSTRAINT subhead_pkey;
       public            postgres    false    250            �           2606    16678    system_desc system_desc_pkey 
   CONSTRAINT     a   ALTER TABLE ONLY public.system_desc
    ADD CONSTRAINT system_desc_pkey PRIMARY KEY (system_id);
 F   ALTER TABLE ONLY public.system_desc DROP CONSTRAINT system_desc_pkey;
       public            postgres    false    251            �           2606    16680    tax_config tax_config_pkey 
   CONSTRAINT     ^   ALTER TABLE ONLY public.tax_config
    ADD CONSTRAINT tax_config_pkey PRIMARY KEY (tax_mode);
 D   ALTER TABLE ONLY public.tax_config DROP CONSTRAINT tax_config_pkey;
       public            postgres    false    252            �           2606    17014    users users_pkey 
   CONSTRAINT     S   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (user_id);
 :   ALTER TABLE ONLY public.users DROP CONSTRAINT users_pkey;
       public            postgres    false    253            �           2606    16684     vender_master vender_master_pkey 
   CONSTRAINT     f   ALTER TABLE ONLY public.vender_master
    ADD CONSTRAINT vender_master_pkey PRIMARY KEY ("VendorId");
 J   ALTER TABLE ONLY public.vender_master DROP CONSTRAINT vender_master_pkey;
       public            postgres    false    254            '           2620    24779     POMaster updateDeliveredQuantity    TRIGGER     �   CREATE TRIGGER "updateDeliveredQuantity" BEFORE UPDATE ON public."POMaster" FOR EACH ROW EXECUTE FUNCTION public."UpdateDeliveredQuantity"();
 =   DROP TRIGGER "updateDeliveredQuantity" ON public."POMaster";
       public          postgres    false    267    292            )           2620    24735    InvoiceMaster update_invoice_no    TRIGGER     �   CREATE TRIGGER update_invoice_no AFTER INSERT ON public."InvoiceMaster" FOR EACH ROW EXECUTE FUNCTION public.update_invoice_number();
 :   DROP TRIGGER update_invoice_no ON public."InvoiceMaster";
       public          postgres    false    291    280            %           2620    24594    invoice update_invoice_no    TRIGGER     ~   CREATE TRIGGER update_invoice_no AFTER INSERT ON public.invoice FOR EACH ROW EXECUTE FUNCTION public.update_invoice_number();
 2   DROP TRIGGER update_invoice_no ON public.invoice;
       public          postgres    false    219    291            (           2620    24736    MRRMaster update_mrr_id    TRIGGER     v   CREATE TRIGGER update_mrr_id AFTER INSERT ON public."MRRMaster" FOR EACH ROW EXECUTE FUNCTION public.update_mrr_id();
 2   DROP TRIGGER update_mrr_id ON public."MRRMaster";
       public          postgres    false    290    270            &           2620    24637    POMaster update_order    TRIGGER     ~   CREATE TRIGGER update_order AFTER INSERT ON public."POMaster" FOR EACH ROW EXECUTE FUNCTION public.update_order_po_intiate();
 0   DROP TRIGGER update_order ON public."POMaster";
       public          postgres    false    267    289            $           2606    24765 ?   CustomerDistrictMapping CustomerDistrictMapping_DistrictID_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."CustomerDistrictMapping"
    ADD CONSTRAINT "CustomerDistrictMapping_DistrictID_fkey" FOREIGN KEY ("DistrictID") REFERENCES public.dist_master(dist_id) ON UPDATE CASCADE;
 m   ALTER TABLE ONLY public."CustomerDistrictMapping" DROP CONSTRAINT "CustomerDistrictMapping_DistrictID_fkey";
       public          postgres    false    3996    284    210            #           2606    24681 <   CustomerPrincipalPlace CustomerPrincipalPlace_StateCode_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."CustomerPrincipalPlace"
    ADD CONSTRAINT "CustomerPrincipalPlace_StateCode_fkey" FOREIGN KEY ("StateCode") REFERENCES public."StateMaster"("StateCode") ON UPDATE CASCADE ON DELETE SET NULL;
 j   ALTER TABLE ONLY public."CustomerPrincipalPlace" DROP CONSTRAINT "CustomerPrincipalPlace_StateCode_fkey";
       public          postgres    false    255    4064    276                       2606    16962 1   VendorBankAccount VendorBankAccount_VendorID_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."VendorBankAccount"
    ADD CONSTRAINT "VendorBankAccount_VendorID_fkey" FOREIGN KEY ("VendorID") REFERENCES public."VendorMaster"("VendorID") ON UPDATE CASCADE;
 _   ALTER TABLE ONLY public."VendorBankAccount" DROP CONSTRAINT "VendorBankAccount_VendorID_fkey";
       public          postgres    false    262    256    4066                       2606    16925 5   VendorContactPerson VendorContactPerson_VendorID_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."VendorContactPerson"
    ADD CONSTRAINT "VendorContactPerson_VendorID_fkey" FOREIGN KEY ("VendorID") REFERENCES public."VendorMaster"("VendorID") ON UPDATE CASCADE;
 c   ALTER TABLE ONLY public."VendorContactPerson" DROP CONSTRAINT "VendorContactPerson_VendorID_fkey";
       public          postgres    false    4066    256    258            "           2606    16993 ;   VendorDistrictMapping VendorDistrictMapping_DistrictID_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."VendorDistrictMapping"
    ADD CONSTRAINT "VendorDistrictMapping_DistrictID_fkey" FOREIGN KEY ("DistrictID") REFERENCES public.dist_master(dist_id) ON UPDATE CASCADE;
 i   ALTER TABLE ONLY public."VendorDistrictMapping" DROP CONSTRAINT "VendorDistrictMapping_DistrictID_fkey";
       public          postgres    false    210    264    3996            !           2606    16988 9   VendorDistrictMapping VendorDistrictMapping_VendorID_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."VendorDistrictMapping"
    ADD CONSTRAINT "VendorDistrictMapping_VendorID_fkey" FOREIGN KEY ("VendorID") REFERENCES public."VendorMaster"("VendorID") ON UPDATE CASCADE;
 g   ALTER TABLE ONLY public."VendorDistrictMapping" DROP CONSTRAINT "VendorDistrictMapping_VendorID_fkey";
       public          postgres    false    4066    264    256                       2606    16946 8   VendorPrincipalPlace VendorPrincipalPlace_StateCode_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."VendorPrincipalPlace"
    ADD CONSTRAINT "VendorPrincipalPlace_StateCode_fkey" FOREIGN KEY ("StateCode") REFERENCES public."StateMaster"("StateCode") ON UPDATE CASCADE;
 f   ALTER TABLE ONLY public."VendorPrincipalPlace" DROP CONSTRAINT "VendorPrincipalPlace_StateCode_fkey";
       public          postgres    false    260    255    4064                       2606    16941 7   VendorPrincipalPlace VendorPrincipalPlace_VendorID_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."VendorPrincipalPlace"
    ADD CONSTRAINT "VendorPrincipalPlace_VendorID_fkey" FOREIGN KEY ("VendorID") REFERENCES public."VendorMaster"("VendorID") ON UPDATE CASCADE;
 e   ALTER TABLE ONLY public."VendorPrincipalPlace" DROP CONSTRAINT "VendorPrincipalPlace_VendorID_fkey";
       public          postgres    false    4066    260    256                        2606    16975 +   VendorServices VendorServices_VendorID_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."VendorServices"
    ADD CONSTRAINT "VendorServices_VendorID_fkey" FOREIGN KEY ("VendorID") REFERENCES public."VendorMaster"("VendorID") ON UPDATE CASCADE;
 Y   ALTER TABLE ONLY public."VendorServices" DROP CONSTRAINT "VendorServices_VendorID_fkey";
       public          postgres    false    263    256    4066            
           2606    16685 *   approval_desc approval_desc_permit_no_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.approval_desc
    ADD CONSTRAINT approval_desc_permit_no_fkey FOREIGN KEY (permit_no) REFERENCES public.orders(permit_no) NOT VALID;
 T   ALTER TABLE ONLY public.approval_desc DROP CONSTRAINT approval_desc_permit_no_fkey;
       public          postgres    false    4042    241    202            	           2606    16690    approval approval_status_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.approval
    ADD CONSTRAINT approval_status_fkey FOREIGN KEY (status) REFERENCES public.approval_status_desc(status_id) NOT VALID;
 G   ALTER TABLE ONLY public.approval DROP CONSTRAINT approval_status_fkey;
       public          postgres    false    3986    201    204                       2606    16695    lgd_gp_master block_master    FK CONSTRAINT     �   ALTER TABLE ONLY public.lgd_gp_master
    ADD CONSTRAINT block_master FOREIGN KEY (block_code) REFERENCES public.lgd_block_master(block_code) NOT VALID;
 D   ALTER TABLE ONLY public.lgd_gp_master DROP CONSTRAINT block_master;
       public          postgres    false    233    4026    231                       2606    16700    dist_dealer_mapping dist_id    FK CONSTRAINT     �   ALTER TABLE ONLY public.dist_dealer_mapping
    ADD CONSTRAINT dist_id FOREIGN KEY (dist_id) REFERENCES public.dist_master(dist_id) NOT VALID;
 E   ALTER TABLE ONLY public.dist_dealer_mapping DROP CONSTRAINT dist_id;
       public          postgres    false    209    3996    210                       2606    16705    lgd_gp_master dist_master    FK CONSTRAINT     �   ALTER TABLE ONLY public.lgd_gp_master
    ADD CONSTRAINT dist_master FOREIGN KEY (dist_code) REFERENCES public.lgd_dist_master(dist_code) NOT VALID;
 C   ALTER TABLE ONLY public.lgd_gp_master DROP CONSTRAINT dist_master;
       public          postgres    false    233    4028    232                       2606    16710    lgd_block_master dist_master    FK CONSTRAINT     �   ALTER TABLE ONLY public.lgd_block_master
    ADD CONSTRAINT dist_master FOREIGN KEY (dist_code) REFERENCES public.lgd_dist_master(dist_code) NOT VALID;
 F   ALTER TABLE ONLY public.lgd_block_master DROP CONSTRAINT dist_master;
       public          postgres    false    231    4028    232                       2606    16715    dist_dealer_mapping dl_id    FK CONSTRAINT     �   ALTER TABLE ONLY public.dist_dealer_mapping
    ADD CONSTRAINT dl_id FOREIGN KEY (dl_id) REFERENCES public.dl_master(dl_id) NOT VALID;
 C   ALTER TABLE ONLY public.dist_dealer_mapping DROP CONSTRAINT dl_id;
       public          postgres    false    209    3998    211                       2606    16725 &   indent_desc indent_desc_indent_no_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.indent_desc
    ADD CONSTRAINT indent_desc_indent_no_fkey FOREIGN KEY (indent_no) REFERENCES public.indent_old(indent_no) NOT VALID;
 P   ALTER TABLE ONLY public.indent_desc DROP CONSTRAINT indent_desc_indent_no_fkey;
       public          postgres    false    4006    216    217                       2606    16730 &   indent_desc indent_desc_permit_no_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.indent_desc
    ADD CONSTRAINT indent_desc_permit_no_fkey FOREIGN KEY (permit_no) REFERENCES public.orders(permit_no) NOT VALID;
 P   ALTER TABLE ONLY public.indent_desc DROP CONSTRAINT indent_desc_permit_no_fkey;
       public          postgres    false    217    4042    241                       2606    16735    indent_old indent_dist_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.indent_old
    ADD CONSTRAINT indent_dist_id_fkey FOREIGN KEY (dist_id) REFERENCES public.dist_master(dist_id) NOT VALID;
 H   ALTER TABLE ONLY public.indent_old DROP CONSTRAINT indent_dist_id_fkey;
       public          postgres    false    210    3996    216                       2606    16740 )   invoice_desc invoice_desc_invoice_no_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.invoice_desc
    ADD CONSTRAINT invoice_desc_invoice_no_fkey FOREIGN KEY (invoice_no) REFERENCES public.invoice(invoice_no) NOT VALID;
 S   ALTER TABLE ONLY public.invoice_desc DROP CONSTRAINT invoice_desc_invoice_no_fkey;
       public          postgres    false    219    4010    220                       2606    16745 (   invoice_desc invoice_desc_permit_no_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.invoice_desc
    ADD CONSTRAINT invoice_desc_permit_no_fkey FOREIGN KEY (permit_no) REFERENCES public.orders(permit_no) NOT VALID;
 R   ALTER TABLE ONLY public.invoice_desc DROP CONSTRAINT invoice_desc_permit_no_fkey;
       public          postgres    false    241    4042    220                       2606    16750    invoice invoice_dist_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.invoice
    ADD CONSTRAINT invoice_dist_id_fkey FOREIGN KEY (dist_id) REFERENCES public.dist_master(dist_id) NOT VALID;
 F   ALTER TABLE ONLY public.invoice DROP CONSTRAINT invoice_dist_id_fkey;
       public          postgres    false    219    3996    210                       2606    16755 +   jn_stock jn_stock_cluster_id_farmer_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.jn_stock
    ADD CONSTRAINT jn_stock_cluster_id_farmer_id_fkey FOREIGN KEY (cluster_id, farmer_id) REFERENCES public.jn_orders(cluster_id, farmer_id) NOT VALID;
 U   ALTER TABLE ONLY public.jn_stock DROP CONSTRAINT jn_stock_cluster_id_farmer_id_fkey;
       public          postgres    false    229    230    230    229    4022                       2606    16760    mrr_desc mrr_desc_mrr_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.mrr_desc
    ADD CONSTRAINT mrr_desc_mrr_id_fkey FOREIGN KEY (mrr_id) REFERENCES public.mrr(mrr_id) NOT VALID;
 G   ALTER TABLE ONLY public.mrr_desc DROP CONSTRAINT mrr_desc_mrr_id_fkey;
       public          postgres    false    236    237    4034                       2606    16765     mrr_desc mrr_desc_permit_no_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.mrr_desc
    ADD CONSTRAINT mrr_desc_permit_no_fkey FOREIGN KEY (permit_no) REFERENCES public.orders(permit_no) NOT VALID;
 J   ALTER TABLE ONLY public.mrr_desc DROP CONSTRAINT mrr_desc_permit_no_fkey;
       public          postgres    false    241    237    4042                       2606    16770    mrr mrr_dist_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.mrr
    ADD CONSTRAINT mrr_dist_id_fkey FOREIGN KEY (dist_id) REFERENCES public.dist_master(dist_id) NOT VALID;
 >   ALTER TABLE ONLY public.mrr DROP CONSTRAINT mrr_dist_id_fkey;
       public          postgres    false    236    210    3996                       2606    16775 ,   opening_balance opening_balance_dist_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.opening_balance
    ADD CONSTRAINT opening_balance_dist_id_fkey FOREIGN KEY (dist_id) REFERENCES public.dist_master(dist_id);
 V   ALTER TABLE ONLY public.opening_balance DROP CONSTRAINT opening_balance_dist_id_fkey;
       public          postgres    false    240    3996    210                       2606    16780 -   payment_desc payment_desc_transaction_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.payment_desc
    ADD CONSTRAINT payment_desc_transaction_id_fkey FOREIGN KEY (transaction_id) REFERENCES public.payment(transaction_id) NOT VALID;
 W   ALTER TABLE ONLY public.payment_desc DROP CONSTRAINT payment_desc_transaction_id_fkey;
       public          postgres    false    244    242    4044            �   #  x��WMo�8=+���m��%��jG������č�����!eű�b,��!��y�3oސ,)�gɷ:��Q��	�U�p���#�?~��}Ҵ뗖�}&/��]�Ij��_/W/��)��JC&�2�H������x*�_T�&vtW��[}�?���C57�(<:GT*S�T����d~!I�������Nj�Gn�1IJ�p;�V%U�r���'��w���7sR�m]�&�M]�.� 5 9��@ˍ�_�V]ܝ=���99�4�����@R`RPIy�nW����b���a�&��[wOn�,|�(�r�AJ�ΙI���Dp�eD(&1S�]���1zr���m6k���PB��%O��V%P �ƥ1(�������~�����I,���}�[��xJ�Ya1�wF��R� S�D�HH���կ������V�˭�/���Ȓ;[�d>��cM@S=H��B��U�aBF@e��^�㮜���z=�>�l��o�ݶׇ�\�q���*��3��%��ݤk.	~.8؜1(&��3�0�*k0�6�74.���J|��L������k}����F�y|�~�c�xS���Xm\���?A�םE�!��Ll��i1����J_B�/۾O)���ï���f1D�hFi+6�h�q����hTx�۸gt�^�bO���,Tjb����Н�Zq	R\=w?w��=��^熁X*��ᇹeTȹT�������TiR7�ގl_j��{��L�L��ł��`9[�3C5�=Hѝ��+��-���߹��9� ����΃��mL&3)9�&��x��Ӈf�̫��Fh�r�h���3�1T5\��s0A�����R}��>R�*��,�\�� ���Je��2��ǋ�v��}`C0�S�f�����e�;��NR�bJ׺�;ʯW_Y�om�x��	8h����0�aߨ;��K-���M�G�����@,��@s������\�ʶ��v鶯�~�!w-ރ���\di�4ȃ�AwT�Z��P�����r�/�����4��	<�,g2�8���=�L�8T��c��n&O���m��eg����byt���q���&�2�A�B�đ�{�yy��q�{?��/h1���|k�p���3^Fe1��1\��GN���S_�����;3��5�j�}*��s��d<�=�����V0�G�a��,��<Xh�Y��Hdqu�/�Ø���@U�*d4��ն7 nD��~�P-�jP�NʄK�%3��KB6|m�w�i���z:��Jw�A��қ��   �0      �      x��[ko�Ȓ�������~���#M�X~@��	p�m)��JN6���j�R������@����:u�a)��'#i��їWҚ�eF$��|[������yU����uEߔg��5�
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
�z��g^�=3�5"�xZ�N!�Oc��~�N�Q��S����)��=n�D-����i����@��S3 ��G��m�nٹ��{��:�;e�g��V�d�3'oշoA�h=��]l���-5��A�U��f�#��h�}P���4�l�݊?&�A�����s +�H����Y�PL�����wj���L*�N*,�Nz�m��E�膝I�Fq7�T�j���Ax�v�R��%۾�Q�]�j\�S3��m_Z��E&�P@C�|���`~����D`,�o�o�pV���r��	�E����|��iw�@\��9�r��x�iU�k.@��P*E8F�S���6�~\h���VUȿϸ�ɧ�l���{��A�.����V��d2�!�7�%������O�=g���h�c����<-`�͊�N���n^�N������L��1�V?N���#5)�<�T���:��.�Tt�8���0(�w}ԇ�uF����U�szF��/V�Yt9Q��0ݺ��� �]�Z缠%����\*�_3�= �  c$%���xS`0��7�ei�qH�ߖ˰�l���� m�>qQq'Lh�'��p��ߐN�����l����R��5��U`-$i q�[締�I�CH:��~���k��wȒ�����|W����W�,��}�8�g��6�5G�:����˝��a�&�V�]�k���B�p�YBq�m]�Y�RX-��̘ٟ�3D������c��>�Q	jK��nwWCّ�&r	�E�c5�3:Ѯ��O���ʭ�9pè�%&�����O�/�V@2Na�'��8\��/����u�kj�¹ ���eKH������s��� 	�?��It�su\�`�h�{�ΏW��e���;VDc:��G�k�{A����޽sP$�p��V�����,l�_�O��rN#;�����dR]�ᇃ�i�w�7p��v�Ҫ�6�7͌v����"<�{�"�h�]�)�0���90��JЦףVJ�3�N��vL��N�O<=0�сT���/�ۤ�G��#���w�W1/��=/�����0^Ɔ4y]��6�jq7��fZm�j��,�!)��O��l�eNd���G1�E����7��r�v~���1��:�i���bfPJ��z��ן�����<��mI�T���N8�7LZ�p]Pr���C�o�ZC˰��ߐ`�=u�+�37�Z�SR�ک7*�Z�@����d���H9�s�2����W��/��/�q         "  x�m�Kn$9D��)j߰ ��>��#4z7�?�ew%�"����~������+�W]_4_4.�K�����^R?����n��E��y�(:捩��7%|�*��������a=�DK�	���4�M͓j|�Z��㯄�Kp.��P��V�^�	�Wű;,X��Q��K��S�D�R�8,�b��B�a���g�gb�����1�X[euwQNT�j�vo9K���\5�%a7ĉʗtx�����V��Ɖ���%.�6�O��$�j�j/�_A�|c��zI���"g���A�>�ES�g!�XO1����<�	�/��r�J1�R����n��M[&ȸ*�e�5)fW6J�e?:�$�ۦ�Xd&� i#Tҍ�D�����F��������7wO�'��ƈFO���&�V�GugS91&���Im	�wV-��ꉡN"���V���fI��t<1�
A�q��`hy������; ��Ӭ�;��3�Ӊq���9��4�GG���zX�U�Ao	6���?�&�2��e^�O�M\b�B	���yl&X�����ƫ�ͣ&ش`kބA'F�A)r�>1�7���K�8L ������6�5˽*.(����t��N����qM�gK\�����0��(�g��� b	þ����T�����	(͌��<��X{��jU}���$fɆ��c�F3`��)���l�`�b\�49�-`( {��p��`kg�w~���\���_5���B��'�
�.Ԫ�tI���w��N�z�˘�'�6���دD7�P�E�MG��=�����]졮O�u�ۭ��c��z�۷W�	�g�J'��@		�aC7���� T���6���XuJհ�N�u����������=F�-�V�s���0��a�F����*#,�T�;0����˞�_z�no��o�Drr���]�%\����'�������a&a���6�p�b~��`�>���vwB��>?���,�j}ܗ?h�g���a����M���]�l�X^>���`FN�\�0�5h����[���4���ɡ3R+5�ܶl���[	f	�����m�ts�g��	��,�~sr�+�Y�s���ͺ�����:zr�|��=���Y�N�oYB5�F���,q�o	Uk��M��enzN�ζ~��NΪ=�������
G��m�[��m�p�ќ�	�v8LN��2tg\K�eE�����-0r}OK��?���C�����Z��/�7����{�7G���OĦ"~!�	gk���!=�ͩ�{l�Tj�8��-	vNNYna�
����﷎�:����읋��?d�q���CI���z|`�lC���<9����+��Zt�][�lYG�ņ�a���I��a��΋�{�`�jAO_�ɖdzs|�߆1 �`�5��abB��|�n	?�n	��\J�~(|s������ݡ�v0��.0w�$��x���tГC���أ�N8{��
�eH��� �J���6�7�fI��F����͡`�=�6azrjK��Л���lo��+�����l��         �   x���=k�0�Y���w���mN�@��n�R�$�K���A�ҡbJ��x9�������&�P-Sj��}7�5߿v�|/�W����}ʯ���sզU�N����^��KA�hŲt8+5�f6�]��6��s�d!j�%�^���f��#ߢ��B�FA4d��8�(����l�ß��f��;n�*�LD%�0��΄�����c�S"�h|����Eq��      �      x��}ms⸶�g�_�O���=�W�%[Χ��	o�jW�r��IH
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
9MY�;z$���ĵ7�G�t2�ݛBMW7N�i������&`zZ�����2�W�M�ŋ"l_Eo�)Lx����G�궗��Ͼ�wN#~�H��1���;v��:')N�q��g"ss�s��?�'�����2��ɺ� h/�j��E�U��i.�۰��XM��b�M��*_���Peq@ht��hL�M`����{��2��j�=P���k�L�4N�2�VQ�ONƱ�Ȇ�`�2������Qط�Y>�@�wz�K�t�<�}`ڥqʀY���E�5��c�S���C#���6�⍧`Uۧ�a��'�N_ݪAS0:�Se�e���Z��rdc�xm�AO9�D?��1�������A�%.      �      x��\[s��r~��
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
��CF;�Ge'Q�{Z)����ޱ\�r��j���j���~�d��      �   A   x�s	3�t�K-J�,N,����r	3�tL/�W�ML���T��!B�y�%@�	�[jj
W� �
�      �      x��[W�Hֆ��_��Y��]g���!fu���n�� !����{�dYRT&!Y@��h׮wJ�������n�[|ع�������-Ƙ���i���-`0`[�@=gj&،��o���;GGJ
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
s�S�́�R(j���*Yp�	.ӗ�+	V���ڎ$٬��?d:S���g�5�Ӕz�-_�7a���әlR;PϘ�1�cn5�ݵOۏ`�\ ��4M�4�O�R�xh���78�v	�X���H�FL������pJʡ2�#�.��lZ������}SV�;Ūq�'�V�z��6)h8��~����S�             x��}�rG��5�)��v���<g�N[����Zn;�cn 6�M��D]�;�Γ��̪J��P �H� ��2���|x��:�����rqV}?�]\.>��'�f��]T/+�l?�9�u��Z����W7�'�>���r��zvus"���5����K|�JM������Od-ų:<�j*�������6SU�<��ǟN���˫}A�6H����i��A��Z�&~(��n8�xN~^��.��s �̖��/W˛<Ϊ����O�������|]}�O7׋���rqwϧ�^T_�Y�����8} ��/��6�	�O��h�okbtܕ�sb�|gOz*j�����ݓ�l	^�3��(�z��ىKon��ܓn�t��$� %xΧ�����R�_�����j���j�����^U?�ݮ����[y9[��\W/f7�Dx��>�x|��˼���<�_қ��05v"�|ʝȴ��5#y�Ǹ��	��{6"�r#&m�N ���MZ��F0��g��<Ƚ�Dcb�<���Ƚ\�NN���n\u�p�dx�].%K>e�~���r"-~U>-�Yd�*2X��B�!BWp��D9�A}��c��d��R��j9q�0J OW���Q�����T��R����ù�Q`Ϋ�+���$����i�����`{{�Z�/�f�׿>�ͨ䦧Z�
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
��Fi�u12.�L��`���ޝ-��#�8�w�!�����ai�F�7El�Q�ofW�Yb|��/ǣz]4��.��v,�4�O����^���F=ڟ�כ>��FE�8zt8��zP�.nQEM4��n�[���5:0T�'[��?'��_��D�         O   x����0��0L�8q�����(�KAL�
T\���6*x�A�gC�G�c -hZ3�*���r���w8��>$?�`      �   �  x�͘Mo�H��ͯ�®���n��5�� C�4FDC4�����o9	�m�m�	;B����V�����pB�b��⮈������}�OP�^P���ԗb�O�y�O'�lz���
�u����������]������/_�0;FN�O#�����}�T�y����$�!��3�.F4�оi��٬~N�?W ����|��[t�Éɭ\6%��UV,.�,Dop�1��� Bƶz���\R��e<]��O]��q�}�!9��m���LڢXc
&r�ZB_W�w
�?����j��S@� M�ٞ�����r�|�n
�DA������0:5�k���v�+�N�90{��Yw��<��P�ܼ/-�n/p:n|/p���pn�"C|�����p����ܦ7��:�R�����u���X������Br��lAݭ~l��QM*�Ps��1()�e��'p�U~}9��}+��
���f7ٴ��\�&J����= .�%�g�{ũ���j��܎%򕸻��9��4Ф�;�,ܺ��Lm�%��A�!�}jdBL"��F��!�U�m��k�J��e��2ݘ#m���+�N5�*y_cT����Ѧ�SґKڣ�!�d �&a}[�(?,�%�K�)#dBal"B#���e�LR�$Wڷ)�d2��a�P6�^+�n&���v�+Dx�y)�
�2�=7���,/�۶J��κdw����|�XYTA9hl��ņA�]Isi�%ܖ�Tsh+�[��qhY�u��%r���bs:��u�,��,q��o�<�cm"q���
�	{�/�j����T����W�|ޙZ��k���޼,~hT-��r�~:/�,��������e(��r��R%3����Qf�3I+#��꜌�bE�z��>>0�y���v�]��n�?�.ÔM�Gε�(R��.��,�f#�����%��Bj���0�����F�� 9<�      �      x������ � �      �      x��][s�H~V~���fj�J�/z`;�@\`gg�\�Eb�cC�3����t��Z���ablvY���w�}�i�> $�w�_||Oҷ�N�������NZ�����N�;������>�%�Fr~q��f3���0ϗ��$h��0���I�>k���O����/�?���σ�C�$ `p-4���hN"�����d��h����M:k���������8�������8�	�j`t�T�I�e�Y�%��܂�g�:����R�g�x���'�?���1CUb����ǚ��������Ⱦ�;RL���4�zT�@�|%�4h���`�8��5�����ǓQ�|������d+�\��O�?o�������ۤ� !���@D��D
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
�{�m�~��4�VtN:O[�tی��Z��&|���*���B_���m��6���_v��Ac���X��G\���cR�گ�%B`:����8`6Ƕz3�m����Gn��U�]�)��v��i���*����"}$P�V�$�� �����4�2h\-�Ys��;��X6a3?�_��z��-V��}ܞy��%ɒA�o���GLn�`��y�m.�v�4yJCm&�1h�Gc��a���q��b0		�����[��:<��ҳP���u�6��;��҄�t���6�aY��t^R�yZ���Y�_6W�	ɔ#��W'��n��~��ͣAZ(�"t;��E���-HI�`��A���sn�ĥ�*�G��QS,�+[��CJDs�Fv#����C�=�ʚ�ZV�9O��Vf�E�d-u���a��)�GG�uO��O��:z�������8      �   >  x�]PIn1;K�����ȉ���K/R���&9��"%S́P,2�$�T��6�N�%���yk���^a]�4����G��2�2�����d�ذ�z�Z�G�,���VB���ۥ��@36>�u�6;Zn`��e���|$��D�|��ъ��K&��*���%n�X_(�tD��]E��D	ѳQR��a��Yʰ��	B��=Q���K���J:n;x
�~nu��vlz�Wt�A����>�zW듍��b�3U�h]ܲR�B�!�1ԑC���`s��Dn�RP�|�ѻ8{�zy�O6z�֧���Ŀ_��̓y�      �      x��\[WW�~>��>�ʹ_�VBd������@��셡����ۧ$QUg{T���t ��}�.�?l�R�wZ���Z��e�2&q�~�X�=?�?�T�o�}y}z��b٬�y�^��e��6+�\,�R�y�N���������m�>��i���?�^�)��K�飭���M�_-�;%+f�Ό�S
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
|���]V������v��������cm�i�)[|�"��f*�PF�&� OHB��T?�>���S��;S:��ӧ�H�ؐ��e-��fГ~{m����ZQZ�S�"�{�ݡր���i9�򑗧	�e鲌�q4+Y��&9U���b��!���^�?�[�;:���(A���H&r���Dep��>g��4��G�3J�9�?2�}��/{�O��!���Ĩ�R6H�7���a0;>��	�n�yu�N8�`ϖ)�	A�_�]����V�m� �������� /�{#��·��(��d\�a���d�ѐ!Z{�M���H���D�]�r���m�[2~{o?k:�u�� 4l$W��(t����^\+��$oCf`y�MJ̧bք�y��k���}�xN��B/X�F����-��1��Q�Ì����� B"��1��|�0��]||x�����'��.t�o�#�DL,��f�D�2�w �Q�ř�ٌW�[�y�v�������Z�a�YQh�u<b�)�ދ��I�]=�R���O�rw�      �      x��[kS�H����+�}����|�S�����3DlD��.�¯�{�_��dca�kw���.%P:�ǹ�ޛ��Sr)�H���iv�~O������&���>��w�d��ގ�������M�ɟ�2�$���"����j��6��&߭6,���}�!lS��0���?�nƜ��[�/���9|{�͖��q�=�V�.[>Ͳe�,�],���
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
����i���kn%"�&7Qݴ��"2�rm��;^W��~4+m2h��'��Pd�v$�������ˇ�D�U�"ECߚ� U\���7���lHڸ\�*ZqF�U����Q�|F���$J!+)�#So-��E������U��      �   3	  x���M��(FǙ�x󎤐��2jP���:q������7ɈN�#������3�a���/��ƿ|���C��rEr����t���ο<-x��'Ws��h�Y��3�g/��O� ��{�����?T.���.����ǎ���:�\HQŹ��2�GR<���!V���by�RP������'�d��`����+�K�r��9���Ct�.�;�]=L�����g%�}�������|��4����r��jC/+��,8�Z�{T⊷�7m�;Gr�-*���GI�EGY�z�S=I�寺��qw��{\;�:jW�
�z{E���÷ܽ��(�'���Z��:�(�AS�U��z�t1I���ez2d�q>ix]�,WO�e�n�(�t�(��HI��W�\=��K�W��HS�x:eGML��W�W�^L�)�T��0=H|�1�x\��@�&�ƞ����W�9])J�Ų�=|��ȹ��h"�a���o�)��3�#g8*�7�)��x:��nJ��۪�'�L��J���sp����%����=�ϗ�OHv������j��pp%+GJSE-��4
pa�SE�H�Ț�Qєʤ�JE��A���)��t�uD��DfmzOmzV�D��{
.k���:�,�=�Z��gZ�U+׹��8��1��b@[��p��G>���{�S�wb��XitIIj��9�l�ca��L��礔�������v���0�x���y��x�I��)�I�������i��?,�"唴����?~�E�/���ݟ���GWR�~7o���+�7�w���U��$l�J���}!a{Z���[s��6�lRׂcV�ʘUƬ2f�1��Ye�j ��6�>k��U���D3Dg�.]!:AtC襏�DC.	�7A.	��"H�y��d� ��d˥�2ܒi��M�t����-�n5pK��[Nu<XR��}BY�^i�g����5��T�ǞDv�Ҋ3�����3���0�A�����1��ŝ0���a�$,	K�0��Ye�*cV�ʖUm��������e��-�nY��`Y�[d�'�}�՟0p�?a�X���a�	����'�O0ҟ��Z�+���&,y�W�������y�W��	��/��#nY5p+�nY5p+g$aI@X��Ye�*cV�ʘUƬ2f�-��+1�-���F�����M�=�k��_{��ھ{����������/��4:��A�ܲj�V�ܲj�V�8ȭ3��[I`�V8fu��?��խ3��cV����Y�:�8fu��?��խ3��y��ּ����W5|z��㘗�f�]z�_*��j��	�2�Ux�g�^0�bx������nYպ
���7�e����1p+�n%��[I`�V�eU�ٲj��UƬ2f�1��Ye�*cV�ʘ� X�4�ؠq���$��)�����q�X㊱�c�+�W�5�k\1ָ
@㪖{�MNz����j�{�8#��L���|?�şS�Iz�A;�\����+<`8��@��~��^0�bx����X�p˪�cq'˪�[9c�F �t����H�62���:͆P�6|��Ӡ�m�4h�%[.�s��^�_�M��)��I�oR����q:F:����3�g/^1<ax���!�7�%����f���!,��%aI@Xf�1��Ye�*cV�ʘUƬ2f�1��Y�մ`���8u��|�W�gzM�3�*:ӫ�3�
:�kn�����
\ne�LC.��{��n%�LC淂{�!�[�=Ӑ˭؞i��Vj�4�r+�gr���3�܊��ʧX�*'�f�W>�:�[��o�3�u����1:�[��o�3�u����)�Ǭ���8fu?�v�1���3�Y���q��~��cV���Ǭ���3�Yݻ�gܲ�����=�U߻�<߯�ؕ�i����3��}�^��������p���?������߯��G荦~j���?�c�7f��2�?з��Z���W
W W�w�mj����>��4��}�ߦ5���_�t\�չ�������2]}�<�'�ZM�����/��z
h����}�<	��+�g��lƵ�������3���0�A�m��[V�;aV	��IX��%aV�ʘUƬ2f�1��Ye�*cV�ʘ� X%�W�U~%�g}�!{�Oc�eb�3�v4�<O8�S}:�.G���=���7�7{jP�|g|[G��myƷu��֑g|[G��myƷu���|g�����8fu��q���;��}�w�1����cV�=�Ǭ�{�3nYU����U���e��-�:����������k�d%      �      x��}[W�H���W�_�jO�/<��\��Ń�fk��+��*�*�P=���?_Ȗ�lYv�i�.la%�B�}q��7L�_�����`|P��^_^�N>��?-�.N/w������_Bz�봼�ğO���n�3�q�,c��.����9��=<�(�8�ߟ,q6��Y�3/�5��f~�������0}(Y�5�j�Y����������r��3=���Sx�>�/OE�����o9������f���9d�=�v�����/��������*6rR.^W�/'W��}��o_Cʯ���Hgu!��N
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
H��e$��)*�*���$>=Rj����K��4��]���%F���KA�L�[4�����s�Ρ���i���s������i��\      �      x��[]s⸶}V�
=���F�m�&� �tON��}��Н�.B����wI6�J��:u��2	�����k����T�/ĀI��ö"���ԌKsKR�p��b�W=z55��/M���vﲬ���P�C��X�SC�ȧŸ���:S0��9^��ǟ��&)�)1�a�Ϋ�z��Q���i�������'�w��`������/����\ Ð'Q�zx�@Ig��ׇ'���o����n�X��u�B��>?ow_��X��]��=��`�&�c��fdʅYnʓ�VeNo̵Y,�zJץ�Z�w��}��]��i�d�����h?�| t���9������h�\��n��+�߭^�T�]U���f��:2ʓa,�JF�槅t��V��]���̬^M���/6fif9���iY�1m��ZO���Q&�|�|�������K��bO��͎�Mk��~�;o2�P�H�;��-#��Ϋ�zm�l�H�9YΊ������f���M<�56����Z9
%\L�yK��t)x����f��wcXPL(ӡL"�Ű��zS�:Lq;�#���`�X`��scטdY�o�OV�M٣��=Z��������+��<�8�,�<�V���&�̀C�XY�f16+;3���_ѪO��=j�䶘��7��t9Y�3��̗��̮
��Ʒx[E��ψ��+%�"�� ��8�@��p�B�S��@+yF72���$�a��9�ufz�2 ���0P[b��d��N�-#x��E�ۚ��b27��� ����R&c5P8�@.�w��cY,ִ��}��+�9��;��30�����b=�/4���eCד4�7��o`�Y�2� 	?B4��V�`��fV�Ȳ�?����6+�Z�M���~�~w��=ڝ��ґV* @��a���' ����?�95�u1/F9"��YO���S���9ܗ��ֿ������&���43��x}g�1��ւ�b�_D�A�EH��ɗ�r��J1��Q>�\&�Q�������sei��ˢ4l��$��nٲʹ(�SK5�!Y�F$	Î��r3��̋��vG�Sy(����Y ��y~�;A�����V"h��x��6(똔��L\BK-_dZ������Cv޺�3An���nW��y=��l�_^���L��?~>?���$�o�B?>�����������Đ�����B�!���"D�<�	�Af�]f�CV���٦\�k��\�w�\j(��e�� �J�^eJ��(�L	o����\vB�����JpQ�Z�Ţ�����}ˇ!�pӈ�*�;�##��77 ���z��4L��t	{D	#1��y�^�bq�s�������|�C�oVk��N���I�3fdbm�X�d��HQj"�˙\����Bxi��|�vmݿ.�M��d����3��i3��z��<��ŌHu�b�zcfηzt=5��ri�������P��A�E�X?��a���C��b19�y���d:)�d���H@�ɪU��WP�a��B|"pG���'u�7=v$����SՄq=�����C�����ƒ��
H	�6O�;'��h�y�"�.~R�4�G�qL���L'c+.N�;-V���Gg�շud/^���C�;��+&���D \b����j��#>ǹEŸ 䱍in-4��gz�C�ISʙ��d�Z&��,NI�>��iQPs=Y\��Zǚ?�Ռ�N# )ZOC���~%����z�.jP0�H���{�g$�/*ɠ�k><m��,~D(�<	��Gq�&�e���O��S-�p�$v���GY��8	�~I��Y�D������`=魢���$=�q$C�����ث7�W�gL� EЇ@`V�����:O[�N�uM���S�k�������<J�8�PI����N���G����!n'��^�AX�N�����A�X_��)��n�����b2)�F���Ut
��~�JF2d�rI�B���lE�XҿSŧ�g�����Ϟf�p��4���ߛ��(yv*au��H|tZ�*�N{���%�1w�����2�ui>[����N������O;������Jt��*<o%*!Jj�X����ԝ�:��+G������:%���mPe��H��;��)0���u6�,�d��&'D�-E`A4�6/6�4��P�[��M!����l���]��<�g�D#}�"�L����>j�w��B@��=�^���u���$" ^"/����n-A>���W���v��k\f�f�<b�*֋2".���w[9~ʑ!���w�B���٠z3�x��`S��P��-J��P���Ǆw��/]ZL�4���i�zMo9���ow���~w��?�������H�����^���)d�;>U������~|��mǹch7��<W̵X�����FTr9�3�B���������4��Q�gM��I8Q�{:����)D�˛ �Ui�-��v�!S%r�e�D���Q��y	���/g�?�K�����D	Q�k����qk�*[w�b}@��D�Bc�N<�Kb�t:���S��>b6s.� ����e�O���t�Bo^w���[\;ü���ۣ��`�Ξ
�ZOp'[����%E~14��S�;l��drnMQ���H�\Z���d�|��ũ�<?K��,��ӝW�U(�ZWq�z//&�(}�q��̷B�0Z�k?h�N]j����y\�$$�ݷ��R�X�����Aw�֗\8��Io�r(�I~JΝqÝ!�F�*���B���$%I��A�f��<��[�����5�������ζ�ǎs!��ݷ�ǉ���g\�0g6��ī�TLT�0Z?N㴇�����i�*�_{�o*�Ԧ+!�4	D��<_ )d2<fn�Ӽ.��*�v�}k��ֺ��dL��v^g�K){��uj�����n[2a�#0�C�'��[��Z��l��A�]8w�lk�eKB��g݌$�R�&��`�@���i�;l���nv�2���v��6c�:5r��5$�g���̞��O��7�I�q�ۧ��C�J<�Ȣ�"A������f�zbO����Y�ꖅ' �$- �DHƩ�')'I  �j%94L)��sqU�f{�A���=��uF�Ri������-�̑z;�J��9ę�#)mcӝ��C�M��'��go3�
�I�{Z����G�� I��;�D�E?���a�m��j
s�����z�\����tS�{�5a���(侩���(I�Tލ��,C���뾼��.��;���:�x�\B:Q���g�������=���:����@�8|9�UR__i�� >��Y~��P�nl�r�v�V�Y�7GB��w���8�79]O��`	w�#�$���II�%X�e�����lQ�/y�	IEx|{�P,]�h%1�@��'��F��$7���7���@�w$�փ�!�/��f�|]*{�G��'��l���{M�zgsp'y��(�P��$�;����ã��j�f�7厃%�=	�X�2dQ/ǦIC<����r�����[w��r?*��WH�'3���m����=V�ݏI}z�0�	IJ��'����ce+��VGp�����
�Q�]=�����U(�~TϠ�:T/O�Cկߥ������n�}�Gd�f9����"��qG��G7���yލ�V�Xg��ZS�y�T��4��$�$�����q���U�������񰭞�%��,k���J���x���F�fV���iB�Q���7�&�20�>�e	Z����������I��E��KB���X�*��3E�nc����<���~�-�������������}���O�W�)_=¥�����8��͔j6Nm*���L�사��;}�}�쁣���M�Xo<�`�����j����:�[CJ[���1[�Q�I�7\cjH��ʊ��� 'ҏ��ݜ0���$�)�Z&�h����--7�)$s-]<P�!/�r�:��b|�Z��9f^ѫ�b]N�W�F��X�Qp������^���63{b�%�Q�UnI��ɁX��R��5�A]:�X�щ%g&,%��a�z;-�8���,V��z�,#YGJ��� B  ��a�N��(j�AӁ�'�˙�� �ڊg�tu��X�֥��@'���2M�����Mi�� \��]��7{�.+F́#庾006eqm�f���bf�fd���E<�YM�P��$��̻.P,l7�2&Y{hD��lr�h�i� Y&uvj�I�<@���^�Qdu/��V��ϒʨ�}�|���*�_�]Hf�`�B�N�i�I�Mo���q�ғe�5O�`����S���Ζe�RW{�L�uxd^��z�i���&�����.�"Lo�0��ε+����k� @�<?B��.�f����y�.��f5��jh�;�$����TLU}���+j�����׃����z]0A,�PA��(���pd���m��M:M�L�`�5����S�������"�{S!N���R>3�^B�1�]�E�F��ڋ"#g~]n7f.ZOf��|�^uo)Y �|�+TUI ��'@�"Z�G8���>�w��#{Q�ޑ3�Ql�D*��Y'Dˋv8;�v���X����]�O���^�"yYGR�nڏޔ��=+��ڙ���W�ߵk��P�"�C>���ΈV�M޴���oy�e��=Tt�r _���C)^�J�^0��͘'������X	E����&�r~�%�u/�s�������y���m^,�E@��fa�΢�r�OF��;[X��䶯�"�&|��H�5(���T�R��_	:�lpI���k7��,�	`��,����L�Ĝ�n��N� �ᵛrn�+��ʻ��ZDk{��V��"O���s��]��VW��l��P������l>TA���Y�\<�k��oB�7�T؀�B�u0Շ��Ç���x�      �   Y  x���Mo7���_��D}�-MP ��A��^w�,���zӢ����qlI�fFv_���J��������Ή^�y�i�yuy��iw8�������J�K�Uz"3I/LT?H;i��xlV�k����������K3[�&J+���h/_����c����˫�Mi��AJX��e�%������5��좄v~bS
"�v�Q 5�q�i�2NF	2����q�<��a����2�m�E�� ���������Ua)[S �4��X�Tf���a������۾�|{����r�HƤ1�$S���/��lױ��a�m���r�RX�
��ؖdg�n�?�e%�ck��5��u����~��O]S����*SxN:I�5��BJWX�ʺ�ᵶz)�r�3�FA.<�6��gٲ%Y�s�l��(�jE�"`Ϗ1��now��O��ݧ��I��R�� �U��1��~FH�s1LR�����sk#aό0Bo?��	g��P��������n73����p��3@����*e]4�pcEXЎ1��mR��4)#��-A���g�_� B�����Фъt���=�A!��r=���� `* H�ҧat�y��pN�<PH2A�Ԯ��"��n�;�ۤR�H�����c�9���tg����	s�W��~�3�淛ßw�W7_������n�. �Ӆ�i�v'B������.�� u:�E\������P'�)��	��FU���U���>�'[��*^�=�9���>ǅ��4��XW�1ݭ�,e&�Hȱ%	ktdK"�0�6��1v��Rf�2Brm��㻜k�]IW�� �w��S�!%R`|�Y^�t��@6��B
*�̾( z�@�3�d�&����k�:��h��IB�heE�:c��1��^.�@�"s�q%
ȝU�g�jP&�r�UL�}Ă
�S=�\ҝ@e�Zk���THy�yT �5�c�������	��>1�g0O um�[����B'��c[���'L�ҭ�f�-t�9�T���Dk(���	)��DX�'rd�?�ω�e�Gv�Tu UC:
�#	E�W��i���#�*m�+�̵iF���zR�<sE��6�(�Mr@YǃHuW��kC��㉵���يЦ�8c�V���4�<pr"����y��<9�jhy* P����$�K�����P�iL���X&cI��LZ|y����k`ˏ��iz�;W>+b�/��Iy-U�R����9J�qE��#� �s�P�Zp�����������R�g�����ѻ�wW ���� �P1`I�OE6&E�D{,T5jH���ɫD�荵P�hZB.�6M1����d�EEsy6�ኮ%�\��%�0�� |�%��݌e%�C��7"�H� �}��2?	�P��-����7��x6�X�P��¡�xSM��T������-6��3�4J-��Ń�UlЫ^ëx�6�:����Ｗ$��QƮa�,��2t����p�mgJ�w
7ݒ�u�y��l쬰_���,X������p���]����ЦiGyA����o�hj�n7��ˋ_�q���tAb���e�R:<P��d�LX�,��:�R`��˳ H�Y�{��o����t%�y����0l�`�N{��b��O�ڦsQÀ��x�Yss���W���E<���/�*�B�`�6�iK�n0=��k1�+X�2`��?�Aм���G|��4P����)���_H�L���l��N*�Ùt�jp��F5�ŷ���?�J�$(�K�b'�9<n�4b\�J�X���<S�FJ��D�����(�D�F%��>b�Q=� �WplT��u��O�Q�k�Ru��8;;���E8      �   �  x�}W�n��}�|�? ������[�AXi�y�v0vd썸_O�1a�M��R&�ԩ�s�k]l��ݙ�Ή��b5T+?,7+�y���:f�σPȈ�_1�ݬ�cV9β��T���j>TO��$�|x,�ͱ�2�;����ur�u�d�:�n��>������D()I�RJ�yH<�;F�<�P1�A�]
�j<�o����Z;Ӥ�-�E|o�G�W���UvL��z�+d,���'(Eq��i?���E�t����?��p��)��zZl�Q;jW�NWrtFe�^V����y�Y�lo�}��z�o�в�w"�2q_P2�>66����Ɠ�x�b�DhD>��UY�N��%E]�%�״,s�� Sy�nH�q�{|�����0x�S7��8�j5a�Jr��� ����@HJ�+5s���U�*H�ң��z(�.�?4�AM�R=?F�%V��n
���*I�[g�A�ާɡ)�����߁
0�G)����R�[��.���!�7�X�\=����Y���a�f�ֶd�T;m�"3�HIՒ����&b�����	a��T�МX��lv�'���M�n�:+ΰ�DW����+�;������/��>�[��0"@(C�����_����c���>��qf�v�g���OG��M+)&��j�Yz����}�u9�<U�H��\�+�i���S1��fa0��T3>ْ x�+!4m�a��cj�A[7�P ���ג���TEV7�$�cSi�
��*vR�
Fa�I.y�O�=S��/�6�b=kH0��U�L�2?��%>w9ׯ��W��l��g��9��.k���AV�j�}��=~���
2�g�6���z��'�KlA�ܱ�܅{i��},��4�S`�#������A!����c�0i����`��}Sa�?K,D�h���Y�K���aY�����AB��F�]+T�^�`zPݶ���ԌPN�0��X��N �)P��To+�7�3hP�!�_8G���?g�>߫���u��f��
IX�gI�����l{�';,1:v�'R�>e����eE���/����@�!i�IG��g5B��t��w��,� 6C�Q�y5E#-%��Y�BD_&�n_�A=��$׳� [Vs�9G��7yvm@�JL�I��#���7��
.ї39\� ���J-7τE�-��ؙ'����_�';� \𽩑�w��jg+P�J������t�0��\�z�]Wcu��Ub5� (� $e�j3ݲ��З��0�I��\w���I4������}��#kSX����R���V�hf�8ph�"��4�{p9�����YY�+�	r���g�y�.�9���O�&�l�8ü|�_ieϜka`�EP� 	��1:`��� ��\=ͬ�}(�z2����U~�#�{+���������^Z�'\t:8�^��g^���Z8�"�sd�]���V��	g.s������W��f[���hf���<l�9�����}�LwN��o��΅C��cc&Ɯ��ot���?W�y�e�<����1�v���z�*����qe�q�A:���(��}1	r#�_L�=�z۴�&���Y�s�ŧ�f;t0D���n4�%8�p?��z|ߕ��3�b�Z���1C�Iv��̼e�ߧ�q��B�|��׎����f���1��1s9��R��ۢ��6f�Cb.m�����%H1o|���܈�g�&I��_2�Z����˽���?�)�!      �   w  x��Y�n7��~�}������j�~�%�n� 
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
6����܊�Y�����&	"y��a�.�}\<8��t3F"V�����"�gySX���̎-�1y<�FÏ�ۮ�q�cۥFk��\��f:þ�q����q�r]�X�m\�&�8z�\*���C�w���z�Z֎K:��-��F��lhz;5���cO�O��|���=��<� �d7�T��T2�����Ψs�(�Ry#P����;u�XÁ���QP���Q�=�}z� �����DQ��7wƚ(��������������J֧{�3*���ƪ�P�>�����u�S��X8莓���9�M�5�%:W$^t>����| WG��ۯUU�}w��      �   ^   x�e���0�x�p���S2���с���^��D'�yu�ِ�/�9�w!��T�@�`��,��Q��QA�s鞩��<~��T�{3��}@-      �     x�5QKn� \�Syߥ"'���R��:i�1�3�`,XB/j��Ⱦr�ד0r\#�8����K#���u1�H扩O�1�y����uE[,Uy��>ΒY���A��;��@�i%�8��	q�U�F�馽��!E����)x�wd1��S�<��sed���F69Y�~!�^��uS�F޴� g�r��Ȫ�¯^�0�:���k(7(���e�ҵ�����ݱ�^F�S�%,�!�D�HZH�ƫ��kE�o�M��N�A���?����~ ��a�      �      x��}[s#Ǒ�s�W��C�u���.� ��� G�P�/��]kF1�N���ɬ�+ Rz�V�3V�3d2���e�|�=K�n�n�t[싲J�iB)aL�?j�h��HIb-׊KL⦳�������<}�9�N�2�)�����|�=M�eV�r�����M�]̳�ۤe���tQ��vw(*�&2P��*���̓jU.�;싴Z�w�l�T�,���w'�
��)���5�HI5�>��5Lˈ'	xE,�(��f�����l[L����w�n\~�������M�p�5RHc�%�VI���6ݗn��V@�˗�29 c��("�P)��~�S7��2�:Y��|q��eY���ދD��	A�y�J�F^�,�����V�]>_�.��|��8�43c����@�x���P�\��J�&f�8��,!VKA�<fIR��Y��iD�H��s�8��s�h�*�Ӫ��Y�W����*��ʘd�����Hm#�Z}�@�~�"_f�bQf�2h�Z���d܎��)Kn�}:?�K�l�(�g�;�Q��G��i)G����^.��^@���dZL�Ek��*�E�"R'�(����5����>��C�LJ7!���ë��6G]�k=$AON����T�d��*�jeIuR���Ngz�cl��
��'����t���W��tQ������l>_e)0�ݻu����������m0��g���4��;�-�5�T��%�sK-x�ᮑ���hrȳ�b�
.P�|��H4C4>ۚ@�#�� �s�;��o40��5Tјo��&����(7�@%��E6��6���D�M$+��ևy�̪ �(��U`-�>^�yD!�b\�з���I�Ix`����4�F$�-`Y���T�|��1>=�����`=Ḑ��5���>֡ڗh80��
�%�����rx�p���3y�q��:L��ːx�JJ�eQ+�_�`�@�#�BHޟ�~8¹1,�+�>�#(�p�L�����sp�~�.���&� W�R�WQ	:�v�4"}��cCA��L(�I���V	��Lm܏�3��$�z���P�e^�=:y���{�]�žq��@o�Nn��S�����HP֏۲D
`"��JP'�u6G���S�ۖ�0/w�u�f"�n|z8�:��c&�N�2�Q%VY�1���Q�D�+Pq����h& �m�aMM�̴�d�r�}֊�����"��a4K��tHca؏��1xei�C��-7��b~w瀞�\o�L+´��ɦ�nR����a��6l�g�lDE����]�����{�8M˚4�!}��6�G$C��Kp��3�������ҕ�����p-5i}�#
����ΙN�|:�C�kZ��Ӽ��᝖��EV�.�P�٠�fE��/W���;q�MD��B���5�FC#NM��ϯ��۫�n��-n��a�w�u<�nw���܁P�G��9��X�YK�15�$�:��'�DX+n�8̔ܜ5h�}[(	<l�d�I������kXI�LmLE.�r*f��6]�
T�秔�3d�̇̈�~���ڕ�����/z����T"�ǭ ]�Pډ�A<We���P��{Z&���O�y���Tc\(�ŭ)S�d��پW�hl8xn�:lІ��n�O�1%-�b����,@K��Ϟ����S��R��VADL´��Y�_h�/�Y1�I1����JF���Q�c���԰е�JV�f�)Yx����|@Gt�%ܠ[E��j�E�P50H`�)�J�X#9"���"'� ��{?��e��V�z\�2������j)>���H%uHLZ�3�<�pվ��ig8_Ǥ3tYU����n�0+nꪽ�S3�A���ӈ���b�H���x`�Ȏ���1��I%8Q��q�
%��]B<�ob��t��l]d��̸I�.G���Fn����޺��F��.�m4u��0/]������hr��oAX,J*c���4��ʵ1H�"߃�"E�LH�3*I[�ӈ���|��,����0t��]ך��ÀB�wtED�����y����dWai0t� :}Ɂ �$G�p�K�� �P+)7�W��wD�x�"X�e�Lp�f�,we� f
\qW����D&k�����<��:�b���y�̔��	��Br���#1K%�P��T9_���2�7�Z�:��ۺ`�6!j/+�,Z2���5�q<�H��>�;��C8DQ��	1�m�j��3��L�D5Bk�U�o�Zt�+�X�cz�nQ�uK+�m�A.���U�\�L@.�4"�!:ɳ%�H���^�R��=>�.X�iD��
���m���0SM6�B~rfj$Ƥ���w�kX��� �~��r"ѱ��B�6u`��C�'�S_9��g�";�s��:#�yF&��"�����T��Y���h� �E�+.��r���çXf;�#%iʘ@���V,�yDBᑅ�u�=���$�ƈ�ԡIr_E���Zm�Aڊ6��b�X�z
{�ӗ��nH�j�ezի��5�vM]��a-�����8l3�x�D�A ���þ=�)�r/	@�l��dL��{ґ���m������6�,�;з��5����n�h?n�B�H�Sh�%�I#V�s�0tX�ٸƈ(�`A�Vtb%xS�j�֭��"���DK�Z<�H�B��=�΀C@�w�؂RY v���`��Kc�o\��g������r�O�$4i!��ø���6kz`�2ڻlspu^�v�r���2*VQ�("�����8�!�0�:i��D�B0�ec	M�A#��6?�l�$�9�޺�!�P��%̿K���&�L�c�P�ہg�u:tD��Qv,"Y]���NNl��)���1���<I�͔�
s�k���L6>PPQ�E9[���m�զ>}R�/ɣR+>�ۆ�ys�[�P��������/��������Tf+j֓U��M�}ƃ:��j��U�Ҩ�cZP���`0��m iuS��b1����i���tu�ѢQ�݂r�v�W�l{ǓR�YPK@c�x�i��r��N����
��ANWRs�M6ژ�QJ�^0_0�rZ�Jww�IS��R��Lma�2f�'6��.r��	6��U���+����ՔYw{���K�J������T�:�?NǦQ;��L�x���א��f�נ[�u_�U��ձ�$&D�b�9�ow}4�z^�D�M��[���i99�&�ѱI�7�gi��2l_~3�wv,e Z�~�� ;{�� �EX��W�[��9���Om�
7S���[,� p��ఛ���"��b$A��o=��Q�"�ѥ��u)Ǥ��	��Dz�nPT`��y ]eLم�Xy%�1�s�%�[���l�Ӥi�m{�����*��3��u��(���e�Mlh���ءJ��:��Ә��d�9,R0��"-��Y.�
[�G\��N)u+C���B��򛭲�P�\H�ݤ�E�߮\�Hnp
��$����8<��(9�yK}����-��4ྃ3�U-��@N}�}�2J�f�N� ��m��iw���5O�X6V���iXnC%����a!G�� ��u~e\� � ��$�1�2��r~2�5�><��Ѯ�M9�{����'�l�0i&�␘�l*�i+?���Y�C��!"k�(i;%"b*0>�Qt�C.�Ɣ�x��wd����3&
�2p��dL�1�g���$ 0ai4m��L�6�SZ�3z����X���Zh�P���E��j�en�}��*+;L���*YO�-�z�N&�O1m3��Ӊϻ|�),��fh�0�p�J�S�Vu����
1�mu��8�p�HLs ������J�����,�\ý��:�t�gI0r���>כ.��i�)��9b2,r���ޚ6����Ҷ�°0����uT��{�O�K���	_�����4>g�on鶧�f)�%�j�j�V�}QL���u�i��A!pf�l��*.兞��Z0��+��a�� Y���M^E�)��d�^�;���BV��a��uY�����?����F���~l����J���AȒ0��vWM7�
    �cR�!���Ɏ�9R��I����E�A5���]�K�e�J`1j�h7��G���#�-N%��n~.x�����l}~��W�v��j���v&Y:�O)1$%��8��j�����u�VD�O��DH�G�2��U�t"�l{㡸������ͯqz8樍R�O��uIl�.D��⼝�C�U+�cd����xʘ8g�I���7X��/XQ+ux�+�ރ�1&iL9N�&���[LRK�nTp�_L��E����1nr~6���!6���}V3�bҬ�o�afx��Ĝ�O���� ��E+ô���QLR����W�ip�"��\��K���x�׷�do��Lh\:u�A�-�8���pݤ��G���SO��m�> J���X��$f�j=��1��������i�����X��\Xҋ%�;��9��%-S�G���R���igwN���q���6)�wz��Uڰ������lL�t�.ajduI���%���RY�d�Ҧ���&{�KXQ�AE���u�1I�n/�Zpԩf���!��1ɳޯ�ݚ���1��$�Տ癧��0�(n�;���K*M0�����Oh� ��J;�TX���|�_��7�����{ ��{ -O��U���N�/��4�t�i�~���1����[�?'~�4A�FgvC"?09&�ҏ2�ɓ��Hs�����ݐm�x1�T���.���2����{����纞w�����2�D���s�)�B�ϫd�T�
�A�W����SҴAPE�����D�'l~���	]3�D[P��Dd���n��ɧV��zɷVuj՟�#�=�?,�Gf|o%E����Th4�T%շ�T �����6�_���A�� av���B���e��ڏ��
����q�����d��\^����������GS��K��;��Kk��F��K��F�v��-��)/ڀ+S�������F���uBwx�}��zR`�,�R�~8hb,���g��<һXe�Oz�B;�>� :]�PD5�)qݚ��06�	�޺7E%*��� P`�U�ɬQI�J*ݺ$fY�aX��f�A��&]#HܕiY�9�i$��z�~5�1- ž���k�}v����ڪh$�w{bSڠĶ���C�a
<2?Ր�\�7�W�:�2-�-R��h"��]��nM���ƨJ�ɺÆ�����2�Tp"��..��Ĥ�a�arc�f$@�h;9��qL�L���[F9(ÿS����e̠�b�#��С�a�=G'&�l�04�Ƕ����`vp9��rXm���T�F��^,�`���t�V>���~}|�^	alP��9'�"��Tm�=ܠjss5���;��!��r1y��"cmq�G��HL�a�� 1� '۸���=?��C٬X �~��	�1��;��g*k:]�T��{l:M�ڷ)(t���c ������5��7�"��N^ ���TLp��l�	v?����FM�LӴ8�}����wb�c�����x��	���:��<8���@�����L��Ϭ�_�b~+{��]ڤ|����b�(O�/�ԥ_��q��Hj�K�����1ϚPz�i�~���>&���Ԫ�w}%D5�����qO���b�O�c.�n��q&��&϶;s+v5}r}_)�$.=��w5
�#|q@)�R4��N�"���#�&:;��A]���c+$e�o �M���as���(��}���k�4�X�	B*�� �^�ȵ{8����k�L�NTo��./��u1#-�`B�I�|�X�M���5�Qn$��p�N���ȋ�:�/
��2
�E�{XXլz�Әt�J��f]���gا��V׹��_��s\��h��H��$�憮$�z��kJ��k�@��AQ�U���^{B�;�%�:p�©����iLRy/XL�H�g��$f����0�f�����#��z@��=�11��ȇhǝE;W�Hu� �"�/�Qߕ���:�4ɲ8��~R��a2�0��KjUW7k���qL�m;|~0��&���\��؁E��15{�
��uW���.tL�t��W6��^A�E����U�	���iw�J㒣�jo7�Ƥ�_��� @�^X&��4�:�ۏ���z����g��pcXobrԹ�w���벫�:NR}�6S:�����h�����vt;�����$%�Y�;���F�[������1g�1d�[E���j��fn�t!�.�����f_���g��erg0����i�0<�i�*Z�Խ���̯w�@��v���}vy�s��D\jM�����z���f�Zq�,H8��V�32϶	� ��Y�?����b���-���T��a�M��"���$ޤk�	>V=#TA��;�	ۤj4�}����X�[>�얪��X~�TRE��L�7fö���{��,��-A��	�]�x\�h�;���ڭ]~}
��[ё���>*2������[��v;,c6N,��<����e|^l��t?����8�k�2���z8WԂ�*�X��� 飌G^B�L�Epڛ2��]�h�Sn��WAGe!���Ar�^>n#�0��Ii�@	{�1M����b�+?-I�ٍ�E�A���k���s���jޱk~��7e�t�aS�Y�9\�"�/�{�DǼ}��I-s�C�������q�R�V�/7��t�DKlྐྵE����6���O��~LFq�������u�Y��5�h��۹r}�8)e��nr{�m{8����Vځ����Olq�I����]ɪ;J���-�����7ڴ1	���H-��!��[^��cL~m�y�6��o>��P����{�o0~{0>ǝJ���-��jv�r�;C�q��.���se���HIpA�i�J��'��ވ�t��⾏.ULR�N�/\�gD�aL�Q�1T!^g��v{�q��9���&8�arq@�O�D�<�a*�K���b�V��6.:�$�H,�Q��07���zqvP���</[;�ֽ��Mz�.�u�������Ru�ؒ��W��9�y�F��[�̇A�̇�qY��	��:2�ۍ/�=@g�3��K��W1�S;]���>Äc��)��@�.�ov܁%��I59�tU3�pɅ�C��S�����%5�,*<�w�]�a����.*ǄC�Rb��%�Ԫ�/��k��h�n��ULF�G���5�Qn���)�">Ma����O1w�\\�_��F���Օ8T���s6�+��~���c �p��m�|"����JL:��g�iP�{@�E�Ώ���Kh�^B+�����zt��,ť-���L���^�`�����J�>�*q�o]�Q�97�ȩ�V��z��c���o=f�T�����D�����M3�Ƥl��ST�N	.p������9��:�I�01��0�����a��4�
�9����.�8��\�c��x۲\�6
�&�� �'�I:��D���:?�]=�X��B$ �Y���p���4xE*�mB��F����d���f���k��Sq�^D��ԗYڀ��h�HX��H���J��Y���<~O+&�fsL���M �b�bY�&�ƽk�c��dS�i%�ܘ�G�.��.m�����̯�ȸz�?��|�K�[�g����un�p��>.�$N�*�C=Ө���g��m+���b\�0{�Kx�oe��cqM�(��A������8�����N�A�Z��)Ua��0��i��C��ku�R<����@�p������"�tᨆ��l3 ��X�mz01��s�i�״+p	�m2l�:lๅ����1P.�ɾ��l���:{�c�x���s�X�2�f��%�k�o���jX��� �:�@���\���uX�ɖ�����yV��L阀U�D���ZLg@ޢ\�-�@	J �ƨ���i<)Qf���%9�}��~8�9�Y'"��(�7Ú��#C�Q9|O��`��M\������|���=<�/?���W2������o?�������ǿ�������r�{�y������n^_�����t������ۯ�x�%��f��   K���X?����_߾���/���(�B+c%��_����=���뗿������%�Ȅ~x�G��V����OL)A���/�ς>>��<�<��G�^���Ǥ<������&���$�i��$5�^N���$�DP������o��LW1}W���7��m>���{�@��w߾[�o_=��?�揲�|�)&�B��1z���ï_����������3�[����~"��b�7�������1q�XB��v�����������_�����׿�@Tk�|OéIR@|d&�<�$�w����W�%�)_�V+�5����� �t%�?<)-U/�H�V�x��Ȥ|!J[��2�ܘGWr���j�l�E��S��b�9
���j������^����_e���B�K����t^�.�����WJi�)ϛ?�)r�-�����O?�������椹�{Ws�B��OO/�/�A<��B��IB���_���;>�#��{����������x�	�'�&�˭������W����ĥ������Ĺ쇩�̮?��xC���vF�O��}�u�5�l��?�����\#,���ѫ�׿=�����p��_�/���v|~}yi��h0)�
FJ�"ͳ|~��GqT��h������h�t|��G}��G�����x�(���'j'���oO.^�&^�?�=����!�����ۿ�����l�����2&D^�5�������������l�Nu�/(k���3�����[������o/Oo�}��4�ӟ���_��P      �   S	  x��X�r�:}����vY7[�i���ɘpzz�_���I����ϒ|� ���TNE���^{mQ�S����돿�X˟ժ���Xϋ����wS���U�"H����̗$�I$<ř$�H!<Q�D_���'x��0����a��^�z�?Vx�ژ�j>�^���l��Ҕ�`�3���^��"�L{�)�\	or9L#�G8�i���H�7�lh���Io�~����j�����f�0�sQ��#�`*�j�A$�q֣I(#�ax�6��@=L��L�W��F����˸�F>%��m�]tz[����~��@#{�v���|\���Ue6Ū��b��,��m�cnʗDYuE�C=%R
E����6�Q,�>@���>��Ά�T�������ď�׿�����bk����J���r��|�l�9�*I$���K�Y�xL~�N"{<�׬�|�6`��DLc�a�Rp�(ot����qb��
&wi0�gœò\���E0����1?�L��^��D�w�!-���\J.���r��'�7��Oo:s@N����
Y��:�V	�����6��V�;�W���T��t����D*u����dH�v�f�Y� �%��;4��ЭK}���"8�v9z0K��x�eQ涄�N�����))O��ACH�8��X�[���!K]pLFVu9�U�}"��`��z~�R�"��ͻ	R��}��S��_.'������j�8T��p�p�mu��O��7��:%q�$S��������L��6Gk������>��,��L�WUq�v#m�T�XgB�P���ֳ@���`�ϩή?$ąF��KZ-'\�#�A���9$��t�Y�69T`>7��N��x�ˬ�&�e�H!�j���y�|��6"[4�R)��b�E�d��u֊��O�d*Ө�e>/ʙ=�̶ճA'B`�d[��l��NJ%��@����}�C����I�����n��% &�D���3.|B��U=���V�\l��~�Un,�jn^߶�t��h^�	x��$�k�	��0s��B�:8�n�YP�i:y̆�. 5���z�0Emq�6Όi�9t���ß�/����0x��<oŲ��5F�P׊�9���	�� �<K�0|���Dhq��+Q?RR��#�;�N?����M�dL�����6�x����?�A��,=g"�;�9"	m���@��<C�������U�xb����~�m��\[�j�|l�����m6�X��M�~_�����ԅ$h+O��ĊZ9<($�*�7ع�f����ۨ�	�4A:[�Lq� ���[KK`<Z��7���[�߈\8/~��5��XB	��_�Ƴ�nN��&j��ڦ�>���~�w�8X�/�f�}��b����n�~��Y�I���dT*42q�3��EIH���c��睧�S+Y����$��P�44|n�Ќ0�]�� ��f�)��3`�ݖ.��R��/Sb2ؔ��@�V����Z��Q��5!{Q�jW>�v��Q���:�`?�v����\�5$�
�camrN�!�3̰�ߩ�i�a���C����!���iѹ�̕��sE>�v?a3"��=����ga�"%@	)�:�+��j�����m8���G�k{R77V��ī-4��z	�R����9�)�t١x�w������3�؄�lV:��6"bv(l��Բ�h�6]*����nv��u	����7Q�9	F�����p��&.�!ܺ�=b\�����5�������mU�m���rw!(��y�Dz��d���C-&������B4��M��0��FI���mi�e=f���&7�V�����9���@�MU�M��;���<���	� �Ɗt.�Vċ{o�	���P���e����hp=�Z�c�f���P`�垝'ӛi��>Y�xuZ����m��Ss�t��t���j� �TQ&�z0��c!�u�n��τ{��	a���vP)�>���:��w7jnd�䩾�{3���YW���SD��
�Ba�<$m
%�{�z����N3��|w�����Tx��%Z�3���{��a�]b�-lOC;���5n+�'�RMK��!����6o�SZ���"J�������TClP��W:z��>}O1�
	E:���	���K�^�0KxO��[C�ǘh��>y�k7]��&�v|�;U;CKX��g:#�P%�8���߸Z�D��(��ػ+�~�dx�\�OQ��u��x��{�]v7#�U�� k�m-&rX��T���\��yK� �Z��3�I�+I$1�R8���Ի3����̐�Ŷj]�<�81�f�6�|��v��p8C ɐ*9�`�q�B!Ş���������#!!�
��c��������r      �      x��}YsI��3�+��m�d��D$q�@�hl�ʠ��ȢDi)r��߯{D��84m��=S%C_F���wpmF��j�3rEG�ߍ����|���U^���̋�x���v%4Qz�g��&����w/���s�����4�?���������a4�����>���~F����1e�T\s�)ʈ�#jF�������;�m�����u���|}��ǫ�<��we�_q%��H	��M�^��F�7�|O�y	O������ܻ>f)3*=��=S�!d���'�v?�M���d?��@����zwx}���_9OyMU�'���S 8���i��^8���<_;�J38M���r�x�|����i�k�3B�҃��bĬA��׻�v>���3x���F�����7�D�Mt\Bi2�3j�Ly��7W�zS��6�o6���;�Jj��P<�#���Ɉ�*q����h��wŮ� �MW
�m
�1	� � �c�peW6p�|;_��o��LV����g5���vQ�f�,	�Z��U���j��b�*4� ��ڢN
��K�h0j������f$�Rb�p��nuj�Z��W�rY,�9��#0*\���I>|�?o_F�)�u�����A{eb��A:-&�ɩU,�a-����_����L	�P{8D�bj2-5�۝��c�Χp�59!Hʄj^��?���9�H�N��7mc2��#��Ccπ9x}���?�5g)���<���$Z�u���i��e���-�,�d�%����u�S2I����lKE`v&�z���o�r�v�� �����d�ja�.���1ٖ���=��Ǽ��S��� q&�k��_/�c��\�i"���mc"�-��r�(��Ex��
ԧ�*�����=�>��'@:���	ȕ�dd[2�>����ϙ\)�q�r��k�E�Ai�S{1J���^�&Ӕ�Lp�lLC6�����
��n���=�N(W�6xo�x5j�&��!#oc:�!-������E!T$-8e:Wqp_� �va����J'_;h�B֜w��sE��'
GGف�����Rp��Ie�@��ld[6ھ�<<������߽tZ
<��%� 7�O�^|�k����YX�$�L�� �� '�?6z?[�(Ij�Y��4��k��c�YC-Ky�h���m���U�a	i����%5,�=��r	� DZIl��ˌ�ɴr(�����]o�94fe��t�Iс$�5WҢםT]Ax�( ��*P� B�ó�ԃY�	�0-�\	�A�p����1�y� oA�帣�ڰ�WI�aM���r0sMX�)G�x�2Fג�����r{���W�8�w7�ʹf6� FcT�$���
t|l��At��fg'(�4#	�X)��a�̒����|o�ux|��$�.��"y�өqҖ�����	�'��M��E����v��9u��cР4���	<*��Յ�1`������_��A*n�?a�
�����6����Ǔ�6�yMYpN����A!7Ko$�zO蘀,jt%��U�h��	J"��4�ߟƋ�o�����������>^�G\p4B��vh�G�����.� l#m`�·Bl[�o緣%|
D���t���<��(��$�Ѵ�8p��kB!� ��u���od��~�\4B{��)�9�5��c���?g�����tVֹ<�!FȘ�AzaR璛�(!��n��0�	����ހ�P�fҀ�8垠�Bt�1,�J$���#8A�<�����w������Rth�1�F2�+�2�r�k��)вg6k� �\e�����T�_)O�T�@
�iڷ�H�n@Nf�=8�@���0,��$Du
��R�^A�����
����4we��@���e1�ǎ�4�W��h�㭗"���Asi�`)@
1�ʀ�D��U��hLB4 ��������������?��c����d֑(���K쑂
�k�2ki�-({'X�E���~/�;p�_��u�1�IV��|:���8�?ӓ�
/��1#@�*�Bp�,f!ֲ�v�����Χ^��v�{�=�n�|qm��o�.R���k*��GSk)i������緊��_��>�P
]m�w��+�b ��t
V4���}��v�4!�`1��������4�� K/�X��~�:�,p 9$x@��ԂF�� �a��ę@�Ͼ�ză�(�� �4Q<U�`Ɯ�ZN���+���|5�.F+TB��5�zT~9���r���x����KJBS�D�s���V	hR:!f11��������
)�QE�ߌ�﯇�{H�O��*t��aRP�D���X�H��o��}�������߇���~�N-����j�]ޗ�����.�k�?���K��3�_��7��dc�b-Sm��Gt�k������k<�* �_�|��N�����tN��f����g,�����XKU�e��S��Z�p`��l�?�����R�oӼZ��&�Pܩ���1_��t�U�'\N��S3���0t�I��\<&,N1�o' ��!K$Y�TN��S������x0����ח�O0ZA"�t�������P��B�'���_����,�[�ݗ{,ʔ@��3�P�Sxəx�9�]��6�Q�<n�ܸUpZܻt�΍��ϙF��A���
lqIeu�e�1���X��<�([�I�*�.�e7]�g�G�� ]��8�J%M�4<f6�2����������cE�*#G���骡�ce����l��M���:��Z	���R��Pc���,�γ9r��>�tn��Wi�� cN�-��r-\}��UIQX��:{z�G|����%�	�g`�H3ùTIs�`cF�-����u�S�ç�S9&^5����}Y�	s�����Sg	���dR����3t���b��b$N�a�8����.�I�N&
�̵���M�gr��5�Q�����.�1�v��c�hsNL2�5F!\�����3@8"&�����F�1�0���1�d.��PۨΣcX��2��$���|"�ixJ�n���w^��k|`'��kku�1���P����f�;M��Ƕ!�T���(���'��,�c��YZ%���NDK'��x{��⏔j�`��ʸ#���&
�x��X�=vv��Uf� �5�F>N��$�l%��=��՘��$���E�>�L�4�懗������� �{6�Ӻi"h=�C ~���s��K�5��L(���!l϶'��a�LU6�}��4�0��eL&���bv��TD`��g�$��I������z�6�e����k�o��񾱞nG�釛F�P���Ɗn�I�Ơh�f��(p�n޶�HE-�Q�Q��c�ؑ���=2�j�7�-z����X��.�����nSxu�tm��D���:aS��������֢$й&V��lщ��a���{9����{�Zh�l�����8��UD�#: N��dn]��{��٪�ͱ��ʱ9�+�D%|,�lso8Q���m!��jm~�2�ܫ�i,�X�������%Dg�%ˈas�l9"_l���-߾��r�hibzX78sL�-Ę`,�*=�7CQ}0�d![�X���*��`Ng�/~t'
4d�d�C�*ą-��d@�XL������@b�t�x:��jIb�� �w�y�sM�÷+��#�c���Wp��r�l�������	�kXo����|߳�������kl�`�dLq��_`,��~_6�1ZS1���G�|� �`o�߽2��W�2NFwo�u��È�y
��&$3("�Oa-&�"|-�L��~�/���~;��ݩF��bԿ��⋧�8�8��}�(�e�����p����tђ5�A�i��������|������n��t����nڀG׋a�/0FvC��C�<f%����Q,@�Q�*D�z -�z
������ ��w��i�p���TKF�\�-����O}�G����",L���~{�Qe$}�2$��� �LI�����~wLN�%�|U�q>�K�����y�W�Xi1�Opd���k���nu�    �p8u	��4z���T�`۲��ծM��u�����r���0�ʽ��7����,���	&���J���R_+�{��a�A5_<�_U�
�jx�h7���;<��������o�X�NԼ'��U�|�y�P�˹���T@m{P��+(s�Q`���
mx��L���ȣ�˰S2�`�q �TO�d�IH��]ݸ��	b�
����z��z��g��k ��a���HT�c��-�M�岸oFZ=����]��S�A�8Z���pt-�I�U2� n"f���Ix�ҋݨ:�=�:��g��>�$)��n�������?^��m��w!ت�$8G���D�c"�Ah��̋����-+� "y��L�<��o�3��C� ~6��yP�<�k�Ucz3�W����;��s�"�=����6%]��[�,���L�[&�˷��y����WC�l�Q�N��º����8��2�QƘ��
L��|��'��!��L��(2D�OzrwS3 ���u��f�Z�ʛY�  �P`<.�=o�nĬ�[�+g�|�ܤ�h�ϯ��m�������0l%z�}ˌm�5��h6�0m�Y�S�n)o�p���ׇ���������0�(3i���b�����F�
���¬�����������e$>�C4���3��Z��+l'���5�=�����E�ؼ��x)k� �2��������\�LLr�$��AR��>\t~LL{�����Y�ye�9���)�XĞ#���^B��S�C3d�֘�L׭f.����"_��NZMd�w�HO�.�l)��D`	�AN_����\6ȄK�����hX��a��溸-�y᎜J%����G�O�5���f���$�?� 8�aì�4i6�{j�	b:4-��oq�˦���:R�鑄:�~��u9�ށ��������I�3h�e�<����R����Mˋ���I};���W�eh�����A�OO���Z	����m˷��H� @[ɘU�a�H @�����>y`bb4-1BL8��ޓR�&��t0 �
t���I�؈]^����M&����i��\���ƫ=�Rv���&��A�'%�����K�c�h��~8~%�����S"&fLĉ�-�}���f�2�>���OK�dQL[�'�ze��;�C��s�ʹ,y����DjZ"]�>B�D�+�?�W��-�P�6�� �9��1N�P�	BFS�	�f�JA�8�x�B0�mp���Tc ڜ&����o����\a�,O[u�bc�-�"ᗘs­>*�����}��z2G��(����\��*����`�HPmm2a��lL����.�q�=�ֹD�{�)����� ����@L� �t�Q�e2Z�n��Ƽj[^�W�n��헕^���><?���)��+)6ؖb@�-Is�|�A�m̥���|Z�>��
Y����~��3�-c8!L�c
�-�6[U�u'y��[�t��1���n17��5C���m�sfY���z�уcΚOX�8�>$"l�7��>JDܹ�B@3t�`�mL��%Rl�[��b��z��P-�D���u�Ղ����7�$n��}N���>fP�2�X/�q懴�������c�Ҩ�a>�9|���X���c�Զ�����6�bOe�֜~���[�;���a�t���!6i(�7S�m)v:/JߔRK�Ogw0�I��e���{�"@{�5(x�4��d����Iѭ$AȺ�΁���$��}���2x/F���b��"�-���owĒ�^K���<v�����;�����=FB�$�QP�zk��cd1Ɩ/ᓘ�,ћ-|��)l�J �(��586Hp i��A�:�N8_ECoI�v^�15����m�+	 �NY��[�-zzi���B��
���E�����3{y53��~U޳�:�vz�����������_�~��ѿ!6��ދ�����*�8�A����m˔��W�
�|z8�T�=|�kw�{��y��x��O��es�!;�}��c��0Ə����_�|�<�[�f�b���4��Ө�iZΜ��J��ڿ�@�	�q�+���'��)�!p�q��16�Drρ4��+	pu�9\>T?GГ	:��]�{���U�byx:Q�`��,0!�d�p��U�}^��ܾt͹
|����G0�#)]��:�� �gt���R�=#�����űԮvYsg}��S�d��6vu���X�*ƷEY`n}�Z�>?���ݒ
�ȺFa�l��^J�p�鉉 Iy'iL�4�I�p�c7��u���g�������ڵ@1tgM*&���wQ��`���V#��U5b1/�ǵr:����_K	�L��W�J*4����V��TNi��K��p�$�^��M�x���蟢@��\i��N�ƌNY 5_�^h�	ƿt7���6�N�$��J��ʀV���h�Q�1��7m�w�M��ڐ!��$���K��'��e�ߧ*eq�*ŬM[��_��Ɖ2 񾛏�@�_*��&�H��n�����n�Y�T{oZi�ٴ�l��k$�� e��d$dVPR���
���3(�0�ј�i�������C�5Ndl�(�q�NO��p)0��MmAc9�j N�|���i����o�.x�5T44<yx��K>(p 8����l����q�<D:)�h(b�-����|���U9@�ƨ8|���t�5��)�����`��fM��B�]1>	֣��֊&^��I�4fc�X�;פ:^bɵ&d�s��p'�����#�3Hq�ba��V���	�=7[ݮ���Ŝ��6���
��$z$[Р֮؄=�	[��ُ��V��[6�]0[q �h3Cpm_�����V]r�h��6�x�z �S�&�T��Ȱ�Y0������r6�����]~w�71 qUs���T�ֳ��c/~�*�w|hd����5yY�B�ΰn���z�>ػ(���1b�d-aV{��%;ksw��JB��j��>�������%8�46�q�b(Nv���w����Z�e>�o��,ص��Y.J8)d�f���緟���N���)a��B�<e2`q��*#�7��|Կ@8�x�l�e�c��HI/��2�`}G+���8U�閅�J������͐����
��:�����rQ��d����4ko� S�>��;��ޕe1���Xݠ�;�ie���/�.�ϗ��mO3�ԧ�N"�q�y����L���9.R���x�FckK%׋���̲��]����7���U�D@u�ȟH��:fM��>~;��qU���f��#e2_x���؝��vZ1)v��{���xZ��4תס�O����[���{r�;�3�ZY��7���|��5��2�p5A7���1��Aw�u�hwG�/k1�-o��+�;���emW�8�p3Kָ��Zp�{��s�c��q��j�j�qz�.�����'�����7.��:�9�]���W��t��8�Q[�P!ϔ�a���#�wՕ�]y̌<��E��ߝ��� 	q��k	��?12q��p*�xlE�=tT�v����t�el���Q�<�UJ����?1�Ζ�Hq ,�������x0��,���v�;~�z��*U�;`V�:&�2@����*���R7H R�^`\���L�[&��z޾A�u@���3���������8s�q	�����q�!�}[8@h�%G�
6<�I���]�1��`�/�u:���ܧ��¶Mѣ 'PUU/�݇pSY�`��@�)�<fM޲f<�䛓n[I�l���kdIA����sd���8n&=���D̡���a\/f�����S���C�� ��Fki��A�n ��L��6��ME0�RuY��/�ۺ� =���
�l�=��M�*ʥ"&W��yо|��.H�!����� ҅��tb׽��-N��bs��t��D̥"�7� �n�Gۉ�&!^�h��QAXp�f��-|�M��z�/bn�V��%�龼���jU͟Y�:W���Em>�c����G�hthDR��ĕ�&�I�:6��yV���    ~LHw1H��۷>|���/��#F�`�Ӏ�xN�X�-�V"��&O�LL����	���y4xO�K�Pc�Th^�2����;���>�F���D-�V���.��w��`��������q<������*�	B
$�~���������R�`��X﹑������ש�p��{8\���W������|����a@_0����C��F�p��h��J�_�kC��
�l\P�paWbF�}�1��wT��U�V)��;�5l5^����&�*Q��$	ߏ���.,���41��W����/Ƒ�b�����~���0���\�*�ܴ��@T�����
?�ǉ1�ɸ!�w|�/&�`C��}J�Xƕ`l,���Ȇeܣ	n8?mRЀ���2y�Xe�I!�A�� �����:����v�irx����엞1��,	IT��o���V��ǰ`F�y9�=<�uk���
����Q8D���ɋ;��f�vѻ��Qū:�C]���k�2L7��M^×��<w� ���掴�	�R�]]	\
� �j�DA]�xY�����Op�+6��+�S����'����6�Z���{�?��� bK,�Y���F��v^������Uޡ?9����ܖ�\�=���xS�6��23A�,#N�&mp�@E[Õ��=Ss��g��id��f[�{�B�J��h�"�.ȝ`�r�aV�?��՘Sl��ۂ8��q5���Gx݂�[�{
��﨑����U����Yv��8�$���5��:2nPLK��0~7�J'��>��H��F;l���8��g���L���t��!&�z�5�A����b�_���?�q��6��{!�'�7�d���j&��Xo���� �C,�@��5��; 6�t#�M7������w���Z(�C .�ƃF�@e����ֳ��f�̯n�_6�(�����m�m72�v3y|��pp�z>����ޮ�?�ОY�u�R*� �;nd���:v�O�lNR\�F%��I_T���P	�y�~����%qD��PƜ��q��k\ϻ�h+8-X���f���hxܸX�v�b�Q�K��? .c�����P���í7����[�WE�(�`�h?aUP�a���2�cH�V�QkT�c38-�}72�ws�ߢA���9��X���TU;	����͈Z�.� r�SC��#0�,�Z,�%�w
�$^�#uH���t�kNs�8I�H���[�+Z2��jj�w�2|��%ķ��Kpd�3��U��p�WQ�۱����*�z�]؃��\��"e+�1�{qܚ�6 ��kl�vCp�p5R)7�B�^��T�洢�z�f@B�����:O ^�#�9�|�M�豎>}���{�αM��j��]8�aUCۺ[� V�z�q��_k�"�(�v��xp�a�㮚��5���]� Z�0����?-�M�2@^��}9�Eq�:�	&��=������cj<ޖ#�m99f�;q-HN�xO&�J�Q�\�5��ò"$�0n\��/+(�1�s&%�''����ʮ8��$洼#��E����Q���-h��P�LYBRs̟�����
U/�.���o�T������h g�&�bu��j"U��C�cG�ܭL���&���C�\M�%E�}��Q8�[��}��Ӵ�ȸ���b�!�6��)�x����.���oB#c:e�Kt\�gKZ�F� wX����Х�Z1
�Ȑ�oב�v�I1�-����xׅ	դ�1�n �90�;]�xmg�F:H]5���֙�ʹI0;;�-k�>B��h�����V@(:h��d��U=3���B,�q�!v��w��Ԫ��N�:Q��/I���t�24~ �6���z�5&�`uN��؇�7x3�����Da�],k������]w����Y��ȑ������߇O�o�&�2b�fD�/�Yz�����'�A�N�����n�H��7d�x=��〶ݸ����"� ��i�Ӄ0i�M�[�¤>b��[먄"ɾY��E92X��*�[\_���=�H<ĹӢ�C�v����C(���ß��������Ya�)h����m�<8.������DxȜ3����J�zKp
*U��V�8G�s�_߾����OU�Kqʚ�AP|���l/���d\�-��p���92X�㼿�i~�8n��;������o�V
���g�rӷ֨��,ʁ�|=�p'�G{��GZ�:'yIe�v�PT�L B�Ǭ+���pd�g�e'���VM�-����4�Rg�k�6:�y#��7����s?ͼ��f���̐��N�%@Y(Ŏ�qAg��/��6�[o��5��,�����Y��ng�]�,(5a��J�m�w�$�a62^j#m���cyc\�S�`��D��T�Գ�'5"8=+�X��Ƅ���,,��;@�s8XT���Tp���V��P���MqS7�01j�R]�<:m8������62�`s"�.���e�w|�}|������!~��pbxm\"'��,f�`�ͩ�55���#����;�����0K^�Y��p�7nIP���5M��̃���` B�1����ˆ�^"�%�1u5�Wrv�r%�X+�@J|O�&��! 	�N�KhT��f8�"�����3.��\��ǁ�ZTES���.�h���^\�t�z���U
fZ��#���8t�fh���=�g[�E����W���5*�\s<n����lLk��2K�TA�3h9�߃%p�,�×��'���P��/���UD���oMmA�3��L�ܪko�Q���t�ES}a:&0��?�+X�S�Vag��t�Q�{l9'9�pF�BM�Ҏ\��"�hd$�$�Ӄ�J@�b��|1�(�EU�p��jjpw�_3~����nPd�*bE�e�h��{]cn���q@����v{�΀ۺ�%�i9sxo*�	j2$Zn�!��hK�~�sL�W$I\Vr&��Y��"X\8�lc�-M��ͦy<*���x8w���Ƴ��|�/(��Lb������x�
��,��}���"��7��h%Ht䧑�#�-?$��6�S�q0��iC�BR��l}٢�}�;sp\:E��`N�?6瑋k�mQ��t�	U�F�0���bl�Dܖ*����/J�.�o
�;:��݈�¨`)&�\��=�~�W�FBt�ɾ���u������Q]��t�/T�1{`���l�3���w�u���<,6h�h���Gi��E�p/8��	��h7���i�8{o?���c$6��A�w*^��hxY�~�4+x���;b���m��c�:H�eio���W���\�ZK�j.hƟ��ȳV2+{֨x��
���@�ӕb�k9��4}�A���Q:�oW���'ǭ��L��w*^̢��,����7mSL9�N?���P�t������Jl���=,�m�$��b�z���=^ڢ��-WA�+�a����aRz��Y����?�%1e,#�����P��,*��2ݗw�ן���oA������r!�9)������E���j�sݩ_�>���>�x��t/g��w�'��śŚ��v��,�՘ީ��Rb�{Y�
����*^���e+�!�.�%�%��ϕ(�\��N���|��)����El�5Q����Z?T�cE��Á-��_��3��]`��+/��a������/�FHx�[��[��%��gSW�^��"'B�N�\�t�s$��,�	�(�g_A�j�ef\�ͅ���6"��8��S��\2�)���26/\Q,��[O%8ztg�������� �!i�Ol2�ťĦ>���,*��2���,{�ײ1��k����f�L	�jC�[���ef�ob__ec����x��߭VKp����O��y�e��h�vyY��H'���;�/_Q��{�̧�5l�^_�������r��l����J7��X���0��}�Ɣ,\5�-ܘ�zS͇C�$6��G�ǌ��5�8�4Sv���]L��v\$Y9m�^��	/��Y�<~;߼I��aʜ1    7qJ�݁BH��%�3���W��ݻ�*�"a      �   &   x�3�420��52��J�I��L���425 �=... |�%      �   6   x�3��HMLQ0�2�0L�L!S.CN�Ĥ��"�Ģ�T.#N����=... }�      �     x���_O�6ş�O�{5���y@]
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
�rW���m�����q]9����^O� ���!��������|�x^=��˓�O������b)�k����V�fn��Z��u����t(�.�kP֚N�\���<X����5��,"�h)X~^�x�����      �   �  x����n�@���wqأw�B�)j1j��7�J���w�ޱ=��$�ӿ���y~<�<�����%��'�1;�ͧ#��K��ٟ*�̃?n�"�E���M����s�%�dg ��pQ� �h��Z� ����(��T6-��d����Ij���pb��$���=Zd%�|+_�8���ڄ���k�$z��.)���Y6� ����5�OV�"h *lg7�$�Ʃ1�tw�ZTh�"j��:w�Y��h��  `^�ܨ0j�QFm3��Q�z�Uc�5Et��(�h�8Q��yu�5^��Oۢ��A,�}���DV�06#SP��p�8]`sT;[��E�1?�X�+��̵�X��O"\'���)R%VS�Q�T5K<�r��"Ԑ��@���T�SZz�k=�i+7D�7L��S��V������x8�>7��Jp!�N�����[�k��E��a�s��HGt&�k�����ʲ��������q,XzR���R��Ueˍ.�g��6u��4z�{"��(sX�6�mk��I�Rע���#�C�k����V�$G,�fM*-���n��U钹ih�R(7��>�J#]G�s�R4�d��+�r#Yӣ,b��wq�ZĦ�      �      x��}�v�8���)pS���2�3A���ؕ��XNR��alU�.Y�C%�ռü�<��II$MҒ5kzU�ao~�a��~�����w~����w�������$<2���H���D�p��(�1�(���O�\��u�����o�Y:Nƽ?�8��1�{?M���tֻ������hx�~z�ш\������,���"3��Q����)g{��1M��|_�HP�Eǟ�?����Ɉ�L�����`�;��1y�N��B	9�LSx�����~8ܒWgo�}|��0������g�AJ^]\��������1Eߧf��(6�R�/�kF�IһX�E�o�����"R�;�X���4�Ȉ	�p�܏�V�E��������Y�������x6��o���Y��净B�p�0��9�9�~!������]:��r���0��žL"��e 5��]��4�_���B�l�(2@�U`�����,�sr9��o����6"��t:O����trs7�L�DQ��w�D%��e��!� �b�%8�>�����9�6���p0�$.��#�#|������n2#A89j�A>(�:IE��� �@|��iz3�L{'gG�'W������(��{O�X�\�UOH�ddL���Ȱ,�B�=͙�`O�yzs7����gb��%̯y�u�P���|X��c�� TE1^3���Z�H#5�;I���H�<��1r;��m�qDC�"[��I����
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
�Ldd���H�Y��mM�i���m�]h��#*�z��eX0n��{��������#�6�gO�a��K�lM��)d�0�R����Z'����8��B��V)������W������A�      �   i   x�U�1�0���á1�g,���H���p��� qC,��X8�#�z��dKRI�$AR��H�$ �I��L2�H��y����r?c���ʄD'Sz�ѻ����9�      �   �   x����
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
?ݔ?���B�@�7� a��2��tsQpP.�.n�w�h�4�`T��懛Oן�?�m}���>*�]���o�w7ohj�:�%uIBE�.5�'q�HIQp�C�Z^`Ɖ֤���14��P>l��-�����-����׍9�J��}l�����R�=Dv��꾵G�����W�/_��?M��؞Yˆl-��eu��I-t�=���/#2�:3�]��d�.�w��Tu*H�	#N� �`�?�|��?��u-:��q����e�C�����"���ӝI
ͻ�[��O�G��q��vq�V@�t��vo5 4]VB��n�m�֭P��ۻe�a�Z	c+,��}�wm�m�*l���c��R%���ߏ��n�s��nљm�����;������X~Q!�j0���y-8]��m�I�qh�EC��h'a�7�nE�F����3d#'�s��AY&��$w�MהO��T��ܛ�h��lj4�`U0#��)�ۂ�BG�wp+G��������J
"��?#B����E�g��}v�hQi�g���{�pE5�oz��Z*-��o��9R1�T��8�4������Q�h��Y-�!r�"��z�q�±BA�,�j r���hxF��Q\�8D����7�#%�y�q�Cq%�b�案�(�Z���=(g\���<�J��uD���֧��I�RaI�{���y�X�-m�-�]���|�8Bo����XHi7���U����A��"�C:@�c���FB4��Fq�
O��(�2�C�ʨ�����-v�WdE; 1
#+ڋ�!lí�8��b1����=�H�Lq��?</6�XM�Xa&d�g8C��'���w�{@�������[��1?'JwϷs-��1���"��`Hl2�sX��1/�/[�����5>��K�0�R�-�H�g�^��n��B�AJ�)%��c�{ �{X,Q����$��m>�{��us���/6@d�k7�2l�n7�o�#�AϾdvZo���
�F����	�����9�����yZ6(�``DE�&�f�̅-\7�p��d���ۺ���w 7K�g�1r9H����se���k궱K�9V"�P�u�4$?>1��nQZ.��X�^��t}�:h��s&���5�)�DS�\g����1_�ǹ��E�|��ҳJ��m[g9�&0��'��X��ʓ?{����N}�~�����������Y���c��/�?�����"C������0~��ŦK84��t��sT6��g��>^2$��r��}b�Z�8�`8�{C<m	������X��se��EM\��KB;o9O������p2����C�FW.���n��Z�f<�~����K�9�����U�U�߼�����=��U�,�������fE�{��:�M�{Z�o�_�~4A9t�s>Uf�W2rOe4'(]��A2h��<��
�o������w7��������O�'u&�����qiQ�۩�*ĭr�F���qsz@��CsՍ���<�@/_7n�B8��	���    I���Y�:���c!�M�y	t)��$���9
k���s�T�E~�O5���>Q�ٍA-'Tr��!�@bˆDl`����ůvU�Fl���l@ �n;A������H8�D� ��Jt1C+{-�SN'�0����MhZSO�p6j��~��uy3�D�┪��t[D��t�p����-a���9��'�p�Dg�B�n1�����.)�1����1�D��r��Rq�e��yx����x�xw�0s�{J�RsL�'E��b���/g�e��z�P���3��r'�xy"���S�%��V��7��1�~'�b���'�T5J�Ţ��#�dw���F	L ��SK�%�8)����+�AD���ɋ���Lc��"��98|k0ca�����G/�^�ܠb���3��݆�H���&|xq���_~y���8�^�Q��xQא��6'�68ƪ�����v6h�����ML���-��er}��CH�L���wto����M)��5�O7F�0RquTZǟ�66J�0��Sx}<A��c�Oi-��`Ψ���c�#��wf�M��]���D�zuHYp��$�'��5B�M*�z������,lZ�%������V�M����O��ȶ�7]ό.x��0�ۄ<�����i�C�}B@��5�����w�"�4��:�3@h{��qK��Qx��j��b�bE9G�DEcg��?w�~��<g��w:�L�*n=�²�Q\��8N0�g�1<aڒ�� ���*�P�NUP4J�P���/�0���3l����q���y�3�@E��aàIh�2�ʥ��#���1�77��n>]��9�?m�+��p5x�����OG�fΧb���|�L4�6��`g�Tr���nWH�@�P6&������yw}��~���_}w'�)A��F��PDs�`Be�$��_���]]���yT�o��"�F��ʘnn���.���)X�w�=!��`���l����`Ы��Rqc�hD���I\��dr�1à�������rO "�ǒ�~�!w �Q`�.S஻o��b�gĒ�E�75���O5ztKr�i�t,��Zm�KAb�gA��q�p�$U2#��C*�ꭼ�޳͈��L,�/���(~�vܝ&�&��_/϶��UL���ɒ��q�
M��T���]*�g`T�������}�����O׷��c�'��.pD�R*d�=΅(��F��>�>�����!y�!E�1}.#y�#B	��2��(�z.���RE�	�#̰��Xh��`�wK���8�!>�J��� ��=O����uUړ�Ԙa����
�զ6���<�k�*a� 6C�w�⢠8,��(L�r��kpjV>����+��f������E���]�L�F���šX(�"U�2� ���IGE�����ww��]�q����M&�t�@q�d�/�v{������Z�K�=/�|b���1�ߤ����ĥ|�J���3�L�c�8`�d�-J���Y�M�A����ճ7(y{=��t4*�ԫ��s�8|0����4�b�W�}��	,�����7o�s�K6i�B��r�و�p�z�f�(�1�ʙ��qX<��MC�L̜LG�]?�!�E��a���vG�8 K�+�;��= �R�N��� UC��*}��#y��%
R�"a�at���\�|���k��_�Q�ZS84y}��p�6G���r�z8����n�ufp���2qj��ǻ��_�|��+�c^4��`�`�>G�҅\uH� R/@(2�_��&f���R2G����)��̡T�����5f�=�}�ꋠ2욮
Z�|��ͫ�&�|���N7{����#�{�2���}��46�T��G��=��$vdN�C��8}��P`0E2�`�AP�a�����m����e���VI+�:�L�eҚ�H�]�h]&��ɿ?Q�U'�Zo�����=�ڒٮ���6~A��"Ϊ�ԧ����P����%Ӂt7���д�Υ�uv`��L���pX$b�*�`$�~O�UY�s����(C�$y0:ǀ��c7&V�X(@2�?��*�%��5s�QB�/������d>�l��T#I/�E�%�B�9��AЫZ�'"�%p�:�l��Uƈ�&ܸhZ�|؎��sQ�8��ldG�1X� `u�L�j�qp��ZT����Unߏ�}k0R
-�J���X/��}��U�8O�I�
�O�oG�#q"�Z�i5N�P{�Ҹ�0�����#�8�X��_���`���"���`�$ �)~:���.0	�@�Z�����Bs�(v~1�2������	��m���x<hk�2���88��%��B� a(,t'��zn;x���ڌ*��;n��#U(@�R2L(C��h��<F��
���)�ƣ�s�&�7t;ݖ1G24�1����F���B�=T�=�"��tbr�S�?划��4��cy�\x� sڜ�1���?�N^�|���9v���O<+a�b;���i���9�@RMY�|X��߼yvJT���#��0�l1;�߷}�)��0�3�6��6�5�n5zULq��_��h�HNF-�{���7�i�6F���?���t ����g�n/7{�۲(��l�|=U0�.������Qe�!�+C�nZ��y���o���`����ӳ����T�!.*]d��!D,�A6w�����k�g�x��1w�	�N�fc�Wܫ��,)P�p����g p�j^��]Vϼds�W�a��qR�[���]**�KmI�}_�Q�<E[�,�t����W3�8����N=ot:��GC�:�u	74�uNU�[v�T�ah)0�?[�j�b�
ha�=��х8��Q`��q�Ō���!�֜��c��FͰi�6��O<~����G��=|�Q�s��rX�:���8rZ0��{�Û�w7���������������w~�޾W���s���?��)G�Y/�i�o�:s>�T�f�������Z�s�ׅ�Á\wO�	%`��D!O��;��LB�;8IC���G)��O�ι��׭��b`4n�_:O/��Qt�ߙ
�n���pl4mD�Π)7���4*��}��A4����r��&q��k9�@qq�=Gڊn��.I��8��*��E8��92��G�����n���/nU�=1�KaD�-���]6�8|,��J�ߠ�P�]�o0�7���*83�����7�p�������ʫooP�����lr/à��sd������ԔVT����{�l�F���8�Rм�ݡ9��������s���+m1v֜�p�v���S�9�YK7\}I���u8�>�L������e)mM�����ۙ�+�t�Uɲ���Ϥ���ēΨ�!n��l��^��^�#�����
�r"�Ņ�˶M��s�C��{�m��B#�Є���h�R�g�`�b8�z
8�u��bQ$��|�,�c�#���#�
00�2�,<N.ǀ9��1��o�^���G����8!�Arm�d��;�;^������C�ti�����H^�/��>���j�vm��l��9������O?����CAWs���9�����䌖�kr&1�o���W?^�2��P��Z��
�eS�@��ȴ=lq/b�bȽ+lx{�NQ�����G�X�)ڐ��9{m��Wo���B��g��8볼�����6ɴ�;��ry!��Tf��>�{�槷߼-�� ��T��g�>�M͒�y�]2�W��jUx�©58���C�+��Y�y���]��lF��ށYٌ$"���6K����_}_fm3���@�	ɦ��Q߉m*���3]�{S"nvܽ��:*���P���gt3 {{�q�P��B;|��W/��q�&�A�0]�	ɖ{�q�}Ѿ�1����շ%�	�;wE"�N_f��8Q(zSm�G׬o2��U�(j�86�bܷ'��Ӫ*�e��'(()|���3�0T
�6��������՛2��x��ht�L�ڎ10��]�,}��K?��@}�    l��}�᩹�37���1�]�Q�m�M2?��y�i�����������{t�~��RI��[RH-��A�dZT⓸�G�B�>�B'�c��e�8no>f�-�Aߥ?n�p����ʄ0p@am�ު"�с�}M�d�Y���a>J������w��H E�]W��(��4դ�E����)��G�_iX��k�J�5�]b��5���E�k�X.8-h���B_'�DC��~�M�Q	���N�&m�f���{uN�^��{CfeE5Z/f���Q�R�˸�a��^Σr�e|�H���b�|FE��+@_��3��4X8p
�|�_4|_JV9���p&��~�F���Ϙ�cc��M�l6LϜ��1#��ćI�/��2#̀Wp'�3 '���u[Wi��8#֣�����d<J�Ш7]��5a�h{��վ����2#���H�HЖ d�Sυ��Ă;��N�	�H�>�P�f9�ᄄ�eV����
v�CŪVe)����LǨ�Q�x�פ�pgp5��b���
�c�9$@�,�e&v���	��7����/����&�i���>��BfAm�m�ݻQt%n�\�E�Gw�����#4�s�@C�;xC9k��Hp�yw�x��7��o����t}������0������<�Ʋ?ԉ��٪�4�ɤ�|����1��C
��l�a:�ۖj��a؎������3�o��\_^̮3�X�,\Ԃd�(��tV ��8=��|�i��yY+��)�@�&��(|��X'�����@qa�w�%�)j{�.2(k�W�p�\錿(��^M�-fFX$o�*���&#����x��(m��0��i��d�(���,/�e���"n�C����G<��a�=���'
 ���o{yM�)ä-b��Nm�CgG�܂]e�J�wl8Aa�8�f��p��������������p�B|Z�à�s��t����J�q�j�U��8�5�,Tb�������`��8�23���c�oq��0�γ�z���Ms^%�����R���A��H�^���� kշ��m��<��w�~���v����Y&�h>s�3�@R3븷�i�bEa[֏�S��&���׾G�	�'�#��}K�.8(������[R?�AW��Y�~i�p��2� ���WeȌa(�|��W��Id8��d���t/\�s�A�ztAW�9#%����hg�dC�y�h�J@���ޢ9|�U �b�D�>�g\�L_ �J�>؊{&"�0��W�8�.����ι�7���AѥNCf܄����Ŝq�'���&/mW
��Xzf �3[�e2	�f�a%�L� !��fk��k��2��E���X��@�hm��ԓ�Ȅ@�+�%ddZ鷨t�Ί��:���P�N�V�zsnH��T)d�4�D��T�X�s��}3����+D0�@-}�	"�
��j��.ʷd@�/ҕ�sl֖��>SG+Q2��MH5$�EH-&Q,sF�
e&Y�S#�i!���p��C��B�-
D��I$[Hq\�`Q�Fԓ�&$Ƥ��ɴDHg���L-,����xp2����ijz�Hhg*T�'2 *٬	b�6�㕃���gr
	"Kw�w�2qpx3&O�l����E(���d ��Ћ��g�K$]N���8=���o�:���l�Ж=u��x��.0�̴�oI4{��J���& M��������r���U&��@=OX�*�c�l��̛�bj��І�;7��)�8 �Ԩ���@S]8
蜭w#��ч�Ɨe~?@oFy�[)濅��ܼ��R���ӻ��@h��#^|ܽ�}�]�>���Q������]�Fc�Xگ�fjtS׎���������9z����}�Q�w��~��{�Ww�H 'H ����P)��4���W�yMbJe~�a��j��#���ǈ��sK-��|��I\Z��027��[S~�u�e7"�26��5ѣ�����������c���g�?�n��t�Q>4a�����>��/���'^l�	Y�3�xdQ��,�A׵H+�EDTV|j�Z�wBG����4jc�LV:�*�Τ[ј�w��b"�t�V��͌.��R*��G�Eu����L\�RNohN>���@�6K��d4�Kr���HZ�8R����Ҝrp�QB$Ui�y��E�A*ByX��߼yֳ�?�d�A�d)g�����U�)é�`�������f������p*H��,g�%eo2�_4�|y�o2j�ƌXe2� !~���&��ח��L�C�;�G��!���'`���j*���H'|��0��A��Ie�΂*]�ftPt.^�{���)|A�
[=�ڌ�B3��+�m\ڌv"������d�q<wͷo�:�l�1�|<V��.݀S�v^�'4��D(|U�*Z��_P�N'M��UȮV۟D��`��P�f�O��Nlq9h�'�BMϱ��<� y���45�>���;p���:�ri��<_�|4	AA�Q~975�t��5�P�x�w��o���6�K\�h	>�P|>�r�i|e���c$���\鶩u������7�mʌ�(�+9B��֨{�#c��X�|��5(xwY��;�۽q��2>���x�%�.�����Lq��R浢���<�>#�VA����3Rqx|���gg)�Q��2^��K�yy	�g��F�S�}�E�f/pfز��I1��ۏ��(�vT�jO|�B��:.q{e$D�9u;Zd~�܄uv�!�����^{�!�<����}����݇���}����͇뗻���ݯ�3Q���G��M�qŻ?�%|�|Xt��-�}�����	��gs�kf�6`���~���LB4(��'�f�`���.���a�-�Q�`��|���i����/A�iY{��h&Rb��||�̊�%
	��1kҴS}<?8g��F��ڊ@FN���Mr�&�OjL�S�rǌ�4.��e�01�$M�I˧ab�)ݞW�G)1���$��(Ō�fa��V�}�����C{]F���������i�/��pCo1�-���[zmh3f�d,
\�pl3
�h��ĭ)�)c��ܙ�?=��c����2#4��X�u�u�i-3fC�D)�U7Ug�	&P���EX��Q��o;fR���/��3���i�
�6�zt&l`����*]�3YD�,l!�8kN������'̔dG��cj;k��4���Ɇ�L.(O��}�>eVg�		;H�����t&��(�/.�ՙ�T�.��ly�2A+i�:V_S�;�4�a~��(K���+�q2ч��Ճ��N�t�.n��&��:as�~&5�?*
zS�k�ۧ3u
�'�Ӭ�k<ӵΤ)p���J��4]�L��7*!�|.Ng�8���;U5]�L9�F�7�ԙp�%M,�����wK��D�U�	�jL��L��̥h�{��2�s���{�yw�q�a�����5+�^�τ+������y��-��6>ٔLRd�	F
t\OV�*�H��_�Ȧ�X��2���d��/��qX������(%d�	@ڪ�N)!��]���(@�֎�P��^~f����;N#@�]
%�L��mx�e�*:�)J =�i��y�H`v��P ��F ��ഫn�0��X�B5p���q�R�f<`��̦<?-J�T�_R3�
��u�:��
~�cvuh3���jS'܌�,�qK�ꄛ��ŗT�l�o�X8ߨJ��YLi9�;��%Ӱ@Z�:7d�u�hC�G׹ƙF������3=�b�G��)3ŋ�(�m�+=�C��*=G<���Ҙ$�� �I3P��%��@�X�^'�"��4S�c�$*n�� ���1�tq����E��ိ�1d2׉P�f�H00�N��/.�ª��������:�����:�f������XP�^�py�y��8�Y��N�Δ6.��]%܌�2��un�L~��B+��s�|Dd{z�sh,�δ4�c� }�}x����s4��3S�@�.�+^L��g�T�}�^Y�*�����d�(/�e/z��C'U�    ik ��[������6{4��1 �����e��cDj��)g����t���Y�w��c(�$LW"�p��Y{��RYT�
q�f�XAg�v�'���JaSl�%'��=�R�<L�!� :�N:�r^���	��=D������{�� �^�O�'<��v���	�����p1?!r>R���5�f�X'@.p����rا��Ó���%,��9*�0a/�pK��ME*n��]�Y�����8)j��������	�&a罐�E�N��`^)�³qǝ��O�t���X=��v��%r�K,*������s
�1K�)O��f�u���Fr���"{�[1O2�Ԑ�HΊ	s�������ם$#9?��� �TY
�Ȍ=$�:�~�̈/4Z�U>���\#k�|�42#4�W�ΒD#3�
TO�V�o�d;��{<�u��3���]�(NjFc�Yb�@�B�Yha�?��v�����(�p	�!}�NMq�3s1�������?\�h� a�J{���PY�&����P�"N��a�|��w�o?����YgJ���U�egT��"�Y�jg�FO�5��sJVox/e\BS��� kYp:��$�3V��֑_:�xC4:c	����_$������ݤ�=��Y	Co�Fg��8L7�у��Rg�������W��\MkT�l�g�d��a��	�8��ty��]^Fg���ʶ�Kk
��Μ���eM�n}���������Բv�7�	Hg=t^���h��Q�:��zr�=����fp��c���4�3j��L�	#�`85X���Cᜐ��xxʛ?4k��b8-���ұ��ԹÝ;�:Y��8]����(�}��O�8Ʃ|����An/����sز����'��I[�Y��2��\[��	�f]$'Dk�����2��]�f>��\zR .���c�zY�����Û��^����G�']���u�f��dt�ql)��ҙ��(
��8��5��Ę����ځgL�G�����ԇd41'�o�힀I�)��5�r����*-=���z�����O��no>���yw)ֹ�����K� w�@�"D�6mS � (Vdb��GhF�Εќ1�rw�M���a
p����i}��w��=�*��R�»�縕�z�t�p�s�<C���Q�^A��=N��;�:��[:t}Վ�9"���rm���-�	�mƅۖ=��3-�wӌ��)�3��[���ނ��c�������E���ƮP���R�E��2����2&ǁc������0��zF��s��8Šs([�ȱ�@�i˶���/D̓+�qn��Va'����x�8���?n~���:��1-6�B�1����82��J��Ύ,rd��Ð��� ��q�~�vB�%eBoD��Za'���N�wk'��QS�3��E�,�9��Ư�(�����~ku� [����s�����E�{[F\��h���M����'�����������Q���K�?��%��h��e"k	�Ιnz��m���X�u�-�_�:z`��Q���]�������O���`��:�d�v�t,f<Em�T̓�x�{P������l�n?v���ӝ����E��۔�ǂ	�zXV�F�=��vq7�Ik e�W��s�r:}D8���vY�DO���o[�x���������巺�I�8l�z?����pB�$tm��HB��4����e�N�~D���-r^�*)��>�Z��>`�������/o���ͧ���g����o�=6�f������+U3L��8CY��,�$i�����Ki�vQ[�5��o>m|�!���u������X��.3/>ӁtM�z_��>�-�w՘��s$���ڶ��C<�� ��a|������N�p���lP�6�v�|[0x%�M�/�.���N�����}䳝&��ok�{#����ܦ(�Vj�Zi��\��}K��^�>�|�����O�������yL�b���b���8B�-QXUZB�#4F�C����C4(7X�_D�,4�l�@�>ݠ[�ֳ��4{p�l59	������D��D�Z r�0�6'���s��[��G��!��H�*:-�\���Κ�"'���Ym�@��}A�X�^��bi���Z jN.	���n=VԜ\l��9.��>\��T�М\�G���@���4r�����K��5mEN.X�l�@U��(he���5'0�@[�iN.8�7��h��h8���!+R�^4�\p6������Pb+�z�������t�+ZhN.�IUV��K���W�>�x��W��dSD�C���z.�&p�
�_|E�?9DM��+Z�!L.����*��V�(]b5�H>��zܢ5���"Xq]D�!j|���m!���^щ����kU�9�`9��Ы�PF:���a�Q>}d�� *M���N�	�Q3��"�� D�(� ��`i�6����+��o��u�����u������B+�d���W����ʼuEO��g���#��-t��� y�zN��9D��g���5�2mE�����fqF2�p4#*ڊv�e��wD��>�������-J��Y����9���u�Iף�t�N��F�`Ѵ�e�.r���BX�V��^�P�����,R��o�r`E�w�0��g:����5�4�Z-Q_�2&bA��j���2��ݧ����i��8���6�'$�Z�q����G��0��=o�tVbٷ�H65G�A���Ē)9�����N_����PK����v4�jHjuL��v��[(�ϝ�PV��M�9��v��Q)3�͙3=���=�ii>���C<	�]Jː(z���������`k�����tlkZ�K���A`������H[���uv��w��龭]Xρ�hi���t�d��3l��Ŏ��{Gͺ�R���:�V�m�T����=��[3b2ƣ�!l�\��k(�p;}��Q����� vA8��D�F|�4:��-��Q�,�'���2oJs�bv��0�ǣ'�SH�O�<L�&���{��p=�պe��5����f��4p,�HP���R�Gc�n��<�-)�-'t��#��[V�]_�6-��Oż��(���x4� ɉ@c����ӄK���v`c��
� 9A�YV���n���(�F��(�`-5dh�J>��e��|n�x�C��,���CK�����%߃� t'qw$��P�&6ΨIR�S���!��qx���t`�y)Z<����%��-�YٴV/�_l�nr��О�v3u��C[6���Ko��t�0��`[b��bZR�w���Ť�d�����ZF�~;�d4}Q�|���R��Mn~V�y�_����@�#�����Y�<������<�Y�i2�����3V���H�)7��������Î�GS��/�}ƅ�@K�)U@�ƭM�YS��U�r�~�C�B~aM��M�<�U��-��GFuGr&����[~�C�IC|~�b6�\��r:�}�<}�]�J7w!AB����ׯ��EM.J���CE)�9��P�h�����o����v�,����ils�G�.J/���"30�)��B���9�(]�.$+@���������hm���������j��1�)���-���IrJ��]�1w��b5��p�4�R��9�R@�"ϸ`�A I���	�;l�p�`lkO��L5�~�;mCS^�>f�-��f;�&f̪O7�ۖ�i��jncvW�� �/�YS�s�so���� �9ƫ���;�fJ*�6/][�Aat�x���5�ܲ�/e#,�NQ�Ŗ�>Ve|;ݺ�HS=��i\�"�,����դ��ex���T�ӗ{ A�gx%�4�6X�5ű')-{:��ٶ8<V�o���@����������G�)���.�F~B��@�TT����>�9�t%pf�p�U�
��aGQ�v����Z[�]�̡�ld�fkX�6Nq(�}ӈ��l�6N�    (й�fm^����L���[m��az`ʖ݇�,GB�C�)ZE�
��Ke�]�r�	5[���gH�F�h��:����-������Wo~z���R&�`q�Sn ͖f�2bS`�( ���1�W��8��=�MM�s�	���{�X!��W���ĦF�n�R����\C$x�UQE҈ 9�M��w��2�.�JΞ����#Qtu�ɦ�9��Ƣ)�I>r �C�<�!��A�tH��%ܯ_���ǫ7e&(���� �M͢9����3Q���|]�&Lb�Өܥ&XHq�����_?y�m� Cb4�a��:�oh���W���CA�.�X���շCA���a�԰��}[G�f��Բ��~<⸆tS�A|S,��-7���)���b�H4\�[�5���(���ك=zh�a��V����El�g释����K9�����W�?$���������Vyi��/�hh1w����T���Ԛ��ki5�Ȱ �dўX�dvR��q�,T��N*�������` ߧp&Q�2$Ύu�@uNrv�hQ�!��$g�t�����>�($�t�'�YoIϰ)����������B�z^v2���%&vd\��<�n���)����� ?��ߒ��T����.rJsT���9Ɨ�p(XI%d��E9�to8es�*-�_��t9!��.�Q��^Y`N���?W�0G��)N)�R�nWqBrp�%��p�tY�"��%��`�Ψn�f��Ӝ@px��6|p���t� u�O�?�U�!q#,XU�9���̐"��
PL�5]�4t�e�c	�RU�\P1ٺ�H�#	��Z/Q�X{;�-�����qC�ؘ��*,���ݝ�s�J8Iee��z�HO%W�\��U�9	�8yvZ:[���
�=��U�tv��r�P
����ƿ�9�u�9@��9�M��h�#�ø��7�#1�ļ�#Y��&A<����P�w �����x�s"D�:~��qp����I��oQ��K�ֹ�vW�I[�S�e7x�7%������a9C`s2����UJYN#� ޔvޖӈ%q켄�tҳ�|b��r�hV�Q1����e���ie��C�?�|T8f
��r�U��X)�+�U�S8m�ƇXi<@�o�>m�/hֻ _�Jc=�Ԑ]�8��$|���J���3�s:kU.�H��,M��@mj�I�)���i�y��(�4A�X�UvW�Ɂ�/�f���(��V�@�T��y�1�^J!u�=p��M�F�4t[�����xaN�[c"�Ա5�xd�W�O�n>��o؏���r
W�C���ͧ��&М�N��BŠ]F�f�pLe�3�H����=��lxZ\��Y�8��>,.�
�K��y\�y}z� ���on���c�� 5o�u�1a��@gtQc#�.y
{L����A�be��/r$���t͜�%m#u���k�{���$zR�����2v���K�K�b�F;����[�A���&;��@u�6S��8	<�x���L�i����Y��*PGM�N�=�Wj�P�81�al�:�
kQ�j�'@x��A�)��f���7ʟ�Ip���n'�,�15���l���"�R5�U9X��t�`5�Z	Bj�M̱�|E��6��Fm9�ب������-�a`����Dk�hp^
��KGI�-
�fY����&��O(��`�&p�1�K`���<���)����_�l��Y�49?��!g��}��w D�)���������/��2�3�һw����:����h]�{�p �*��uq�CbQ%��Bs�m �QI�k%����88�c%T8G7U�����+�T��H<w/jT�R1���

|����q9��"`T&х�:���"�q�J�r�J�Ͱ`"-}f6��M/�0Ǒ[l9��*є�s�����O��K����4cZ5�bzɹ@Y�6fXse���H��%�,H�gp!��7���}^_������<��S�77���`p�0��w�� � 8%�[
�� 6l��Ӏ�8>bSA9#pwn��s����F4�eu%����m���(��������wC
S��Z��Zޕ:��Z���;��l�������W�6��9�L� v��d~�d�k�]��?ÑӚa��b%0N�H��s��m.��k��/2��Ms��W#��q,$/i���x�9xR2ҕT#�:0�0^WC�Dsz�c 9z���h8/�֣L˄���Kn8�h��Vn��%6�bp�q!���h8��J-b�ƫ����_>޽|�v�����u�����|�ow��q�������~j��o�Ă�k �H nW�>���1���ܟq9x,��P�>�>ǁ��.'��Ovȱ�f�t��lb�&X�
�Vr8�A����l�M^��FiU���9zLm��j�yk8.�;�V���Z��hL�S�Za�r
A�F+쐼ӦK�� 3U�ʠdV��� �T�:U
�l�
�����S�QEM��*�I��qXM1��};(�X̩�x��s�C�a,A��ӎާuǘ���7p�����	�p~Y�Ϊ��mv�Gr%�&U2^��704��x,�8E|��]���������X#��Qk�}�xc0���M����Z?��	�����¾�������_����D�.�e|��Z��Y�d	�Oa&E"�w���y�Ww�Ecĝ�ʱ@~?䫏eıL�2�H��ZM۶�&���G{l�tδ�nVGRkh�"�N���������PI(<-�;WCs7�/�}�J�DHM.�_����O׷s�?`y��e�APݖ,�#��o�^��9huI��?u�˰d��J�w�a�BwI��������,��5�1���y/9 �Be�W�:%^q4��1lrH�ο^�C�y!�d��a���F���c�οC# a#�o�9���w����p'��8�U��ی)���{���������w?O�n����Q���m�G��D�-�������44�x��s������ +�Xk����Ҍa	2�B�}M:���_}s�f����:�5��&Nē�� .�69.A�߯=�1,;.�6F0�ד�5�� t�j�y�E�8RNUj�V+�8*y�v�)s��i�\�����t[�?B�q����9����$&��5%J���$�վF�-���|����G\�������O��y|E�L����<͓��ӷҋb�N�ؒ�5����v����~�|� ���j�hy� GG�jx\�C��o�|��Y�s�S2-�v6T�>+�b���'�ު	n�˾�f]O'Y�{�W�k�Z���Kȝ���·��%�=wS�ZU���7 �]�AT��{���@{׆5H���x!#y����I��X�`61H���NXS&����o:#�=���\��>�}���{���~��?w���f�wˬbsT)x�ҍ���L��} g�us|�R|A��ŋ�;��zǲ��r<6�������_��w�Ŀ~���qW
S�7k�IZ�>'�"9aJr0��eP�';���+�
XD�����|������_��ov����&/R�F�P��x�����펯��90���_���*��p�nԒ�V����+�H�GP}�l�O�P�n��ګ�<R
8$�!Ē,�8��$MP�!��(���
"�!<�0�c �
�\��<H����QN��\��C �W���i��dߎS:�uܷ�Lh��8|��O�de�h�z�Z�\^C�V�.�^�e5���5�l�g��H:�	��kǫ�� fX��O������۶ ����@�Yϑ�,���IbP�O���%M�w����頀wkó���n��;�F2@VҤ��	P��z�H<�i�ɺ{>���ۺ={�HՍ�l�L�p���͇d$ʄb�x���1PÇ��dw@�}�sG�u8��9�GdR$����x�B;l�R���[r��'�i�B���_���0ĳ�4���U��q��ɫ����3PuvM�/η�Wg    �ϑIZ�^Vq8O@���՛}1ǘ�ivl��<3�]D�Α�c��SczH�e�g�b8TNJ7�&������o�N�ql&-�NG�.��͡@���C9j��P�10,��e?�i�&�9��=6���H�˜�-2	�t�tax�(�y9)ų��1ѤR?ClË6�x҂���yb,�.��K�Ӑ�Ҁ��š��
c�񭓶�n� k�nR�0�ix���\�6���w�m:��󵤕�rr���w�@�`N�/���/PO�e���W��4"�����C��ti<����4�r�9 J3{3��nm\�$���F'O{F�t*G��v<ǺC:�y�.ƴ�~�x��x��Nנ��ދ�w׷3�P[�����M�}�pt��r�x�^}�����(�q��
�����-�0)��i��y�{��/�7w�*����r(ߖu������8�=7!�oz��"�~ِ|y��LS���>9H�����a*��q�~UZ�+C��:�;d�_�B�hŸFiQ���;b��ˁ:���G�
��ƽ&��6�p\�M����M ^������c,��A9�B=8�*�ٯ�����r�K��Q��}e��{k��@�ݐ%y#p�� A}�"y���t�~�*x��+ۀ2|��T(�}���V&�7���Tx�a��5X�����onүj��y��>#M���K�W����أ���W����kǱ�(�U/���`�
�U�9X�����%�F�R#/:yU��@xЩD�c�����(�1Qq�Zy����G1Q��O�!-)ʵU�kb�"A%RW4򌖣�l_��GΓ�'�ex�B�/خd�A�0���ΑGϱhltӣ��8�`������%F�Ps����G)9X��r����c��0HO�ժW-J� 94qA��s4q�A�����Y��"g ���}� �9X���a��#@C���G�t�����EF�K�G�9��Q&���sm����K嬙g�h��S��j"C��|b���o߾�X��~%�|�t6�#���9�1x(��O�����嚣RH���}���E4�Jx��^�=��1�\��)�q �#���S���M�}��矯��VE�~?�Jڢ�$`�cZ��H���%H:~4`1��H&�4VL'v����i�ȧE��f:�
�j�b�Xc+MUN��O�3<)�n�^h�p�ҝ( ?-X��z���W}`5�I�|��HI��c��_V�+i��n������N7^~�[�� ���x��\0H@a�z��|��-jǱD�Jm��^����N�VN��`@�}�Y�y±���HtX�>���v�>a� ��S��ܨ��nq]�2�B^DK�.��
w��F�m�o:h�ρ�:�w�X��v�P�ʦ��u¡p������Xd�q^�!5��[�;�����Zm���&�{m�gN�c+o���b�U�h�t��c��r�����Mf%�A�Dұ�������.��M��}?�*�>Ҝ3w�5��%C:{�G�1O*y�C��-G�� T�*,p��D�C�`K�ɨ�P!X�n�n�4ձ>������`=��i�YU����z��S��w=�����4�h�������	855�be���R��\���_�Y�,�w��p8�$�):���-pF��d�ŧmOTprZ��d,`ǳ9U��i�r�id7c���$ci��!�����z7]%� X�Y	+���m�8{%�t��Ҳ�,|Ū�
�fi������.c�HZ���[���4��UgTN\Xm�=YPNZ��LIY#�:NZ�iɑ$噬�	G�z��s��z�L�zNV@��a�x��`9Y�̐��J��� _h�bȺ�+'�4�+R�HV>#+�4�W��g�@�<+��l�r%R�3��J��.8
.��@Xڊ�/2�&���|�S��#��F��������>��8��n�1��o��'l1@ƣΌ5j�GM��ž���x_pK�A�,���
n�^5����1必s\��x�=G�������%�-1��Z�UCh� u�h��b�Y$mz_�k����-�*1�g�� P�p���n�)b����4c.�A��iF���QN-2KZ���`"Q���7Y����k,hX�^�)�<�B�HR��ŗWo�������I�z�*@d�T�� �g�������Ɨ�w���^\�^�{��v���+�Ӭ��qIK��M���i�[2���Wt�����c(�1
�j��(��6� ��vi��B;�N��^��q Azi�3��a�nwmB#���0g�b��6�
L��2��8=��=k���z�����ۆ�`U��ۖ�.��ŶG��l�C1x=��W�������Ԑ��f����A ���e��VM���)��X'� ��c��؞f�R��&Jr0$����l�~ž�Xj7���KUܥJ5Kϲ�5V=&����x$]�K@���q�$�/�\6��N;s!P�=����!i���9�`�z�s���t+2Q�L,�\�K���8Y*�ϡ9uYvʚX*Eω�ҫڪ<'̦�)�"�='�f�HTyNp��G�9�S

K��+!���E�}RI���`c�d�0�]�$X��b22Ҕ�??�Ǐ�����h;:45�	9�W���Xm����ı))u��"�ϗ�4�q�=\��;AQ
 ���{\�qsv�p����`��y�\�-H�=�"�� fM'��} ���>	������O�����T���i5jߧ[�LE�����P%EQ���6CsM�u���Æ�Q��L���&r��J�m������#鏥[��0�n{���%Vမ#���`�� �0�kxu.�V|�0�Iw~��o�|�����쉁ҕLg�tAyq�1�����9�����f�L�_��m�
���b����~z���ד��@(棳�@Zϡ J��v,fY,!ǂ����㚧#�F�Ȑ�F		%_IA2#@��H�r���o�-����ʬkA;�3[���͑D�|�:�e���x��x�F��[dN���"��-�X�r,�Fg��`*��z0 �X-�`]s�ӨP�B��|=�@6����q��xQ�9M�h�Nwk�
^�	��r���^8��2�^�� ;ݨ�R��G鸦ta6�A8��U�c8�@���?�=t���؀���b�,�����H����yU��:Ͽ?�k�bZ1 %��%�X�0Ҟû�L�w�.��1�:����@�*+|XU�9�x�q��.�T�@h�zj��T'7s�6���K����~��p��ݯ�����'�OJXz��ZƬ���za�)�L.��kJ~������������F��GϞ����������cE� %�
���p~��l{�Il�.�__���BI-����Mc�I����y��k�fe�t���T|@$)�`ԋ��}|x��z3o�ZHH��K�3�bpg�q(\�"��8�aH��x%�_�>���w�9��|���kU�
��xT�}S.�h�B'O�[��<4-�h��_,C=N�z�;5��}-q\͊{&`E6VE.r�T"oE�q��V���i�QxW(Wv�R�|
�%�|�=�)�A ɺyY(rhT<|���9��������z�3�Fw%0���$��d�s��3$HkZ�,S�fľ��$˄�r,��+�q\���|������<ϕ�8,�qG`hp>l"�6���ۯ_������YS!uNq�Ҧ����GϰbȈò*|ꎁc%I��u[z���㘗t���3%%��m(5�$AP9�����U��
�
�r��1��Ok2b�j��
���ldݦ�"�=�y\{{�����zspg�EcQ��q�eSsp7���@ͦKnl�D�#�v�!��ܓ�F�����Jq�j��X����F�$ܫ�I�����2��.�����ܟ&8j`N�����&8(�6�2��&ܥ&D����&]Ů�/c�S-��<C��9�KM 4������^l� 1  p�jI�,�UqOH65w�	D
�o���?�}5�b�54��8t �>��li�=�%�%�{���)(���M~�ܟ&4�b� �M�½*Pڶ/5e��Js��e�N��w����}Ǌ����1\d�8Bi��1�]ĕ�^���pq5�DTw�B��Flui�
Q�l��w�c�t��g�b$�b0�����E�t���F�}yW0e��f �
e������3X�1=���M�[�e,A�{�B�^� Ê�/���g$� ��B�2���%@�[�q$��N�ySƳ�G}��!M=�_����v��      �   �  x����n7���O�=�r/��@�"@�"��C����3�J&7�q$�Z�w�3s��p{�~zf\,�������}�|���K�#���u�ǹT�A����>Om$JY�B{ ���DW���G�&��N���OsY-�ZT�EθF#�����۷��#�㵕}5-D!ʋ_x<�<y�?��ߣ�"��V�U��&!6e$֟"Z[E
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
�|$�u�` �CǾ$�{D*l�CA�&��y���GQ�KV�t�P�h6(����]6໖Z*�����k|;n��zR֦ݛ ֵ���I�[ ��K��Qqy,��(���۲;	@m(z�u��&҇�U.�P/Ŭ���}� ���}��y5�xX�N�dq�ck̶o� i��:��$L\��}��ix�-�&l�	!Y3�@ϫ+��%.g�!�A�x\u�k����n�����.��A�!�t�Oۊr��'M���N�~/Wp��=�v�@�s�������>��|xx�p^Ey      �      x��}[s�H��3�W�i���5���7P�	$��5������ŭ����?�U�(��{:θG ��>f�=�<�<ݽ[?l޹�K�Ȓ��%�;�Z�]�yZ���V�Ӽ������4^��uf�겈�H��S�Ce[g�Ȭ�����[��*+�u
ʂ�����������/��<l�.�bs{iO���o��??=l��w�w_-�Os�w.[����'������>��u߀�����q�����K]x�w.�	=��	�����_����^~���]?n����,�w�W�|��&����P�ⷫ��<p��Z���x�y��K��g���x>����o�3���-���4FضW�ղ�ߗ�vV���i�3|`%�;N��W�:�����zs���p����./:?�`�rɤ��J���0<	?a��	uA�4x�.�1����CzV�e�ړi:-�����E\fղyy�;7�aE�;�AD��G��8D���S��@\����@�!�VW�"�˸8�<�)�h�[ ��b
_��S��:.f�5���ݐd-���X�|vug'����X��=;�^U�i'���L����b�OIND��#�2��@�4��x�XJT���x�CC�S��3� ޷#�ߞZ�d8� �PA*��O2�onM�xv'��IG4A��"͊Y\���\�RB%r��*Lҗ$�b�hN�x��FÎyR�1�]���+�J<�8].�*=�vU	�Q�h�-��$.�`�F@�Ni*�hB�h��j�|��q#":Z>�L��,��l��t"(I8����X���<q\g�;�os����y_�Q��Û�C:����E��%��%�faǤ���a_����N2{u���|�<�i_< n�����Dk�Z}9ք{�Cxȴ����G��:~�IiH8 R��tGyR')x� ����%s�.�I����ړ����.	�P��@��37d�P�.6/*Ā��M�$�7��D�RX®,&��^�.K���D�Aw �/��M\�!������j���H��$��@�ƅ%�~�@�y����\HbU5:������x�M���q�5;(z�{1���A�������������3��|���Oo���\Y�w�wO��zyw��y�o����������	�0$z9e.��?�E�BNY &�&��҂e�и�3�=�����Q&���r#�o8�{�?��z}��\~=}#��r�vZԶp-���TK�� ��<j����t% 	�V`bR���1>�SF\�`X�3���Þ�	ߑ���C�X���K5�@�q! Yf��R8�"�րW)u���� '��kgYV���?��w4nN(�ͱ? x���������K8�8�����mRË �&ܨA�?�Z�<qӥ�!�)�I|�y�c�כ����k+���}ݼ�+��캔�C�$��K�Ё"���	I�#m>c����4v��Hz��}��a�Y�[Un��}.�V�s8�)&��9
]��9��^fy:���95��jB�9 ���1������1.��'��Z�2e/(�UL��p��'���M�3���쭢�#���ꇇ's<�����M�����@w�2G�䁄?��tu��iE���\�/���g�����>��s�����cRx"
��^C.G^���]޵Ck/� ���Ʈ�E,��I6?���ɿ�'
��h�m�bG5؊n���lp�ix�R���?$���נ�"�iz�� -��/����������:���؞@�qM$t�4r��F���tz�m��c�����A�DW	K�93d��v.�i/�~�f�Ɛ���[�
�S�"G拟+0��7wp��ސ&U)�!�8��C�脸N@]O{�}��)L7�=P�hn��X�38���g�<^O���:���[|'ӏ�A�Ӊ]ĳ��Uڏ$����/E�`�6*G��}���<nH�!��|�40yF	A�??���81V~���|�c����J&V* �8�RT��%%C������C+�T��b���4x�$/~��$�R�#�p|?����dh-����b�5��"n��=���F��q��"��"8��샪˟����>��Q��Ow��Dt���Y��ƈF7.:q�6�;�,�L�γ=4��[p�@�3c-<��j�ݻ�Q`J������(<7������"�\��a�gu�2��p0f�v�þN3U�l�L��v���~q���.g�:�����`RxL"#�z�h�$����^�Q�S8���r07���D�T.�4bٽz���Me`�\���i���?�8���+��߁g;8a�C�U��V�of���<u8�L�Y��9*>��v������������B����޸Ѝ��	<�3�X8^��%�<7�V�����Ʈ��\�Y����Z���Ԯ |��dV��tBS>#4�3�p�YtB�C9��t�p]eG��Q��"��T�eO3�60+͍&��6��-�͇5���mJP��������B�h����*l �m~h����(��Y4su�0X���ov�|������b�?ו�^�lv��rk��4��z�V{ٲ�qAbI�Q��B#��7������H2�vlsR}x���=�
�B�8��Z�&�wp���(��R��k�;����Ӵ�?M�ɴ�>VkK��O����J���;��bE�O�&D���������Ys�b���_ڟ�E�02��a�{ڴc��o�����?�x>=�a��+a��[k�1�^v�^�[w��[��k���|c�ن��ښb��(��+}L9����.��U�!���7������%�ވJy�L�����p�V)�=Y�N0ʋE9���X��V�[��(�0�	��${�bB@v���O�KB�}C�"m�Pޗ�Rl,R�Am/2L"�v;�6�����?�<?>��^>��� ~7!W���ₒ��g��[i����2���rq���=�j1��;�FnhM�E-;��ef��Y᰸=(�$�
�7��WK��$�����̄c� �U� }�͂@_�7a�Q���v.�ی�V�nE������W�h{�^ ��1�'�3����{���fi:Fvs�u�t1Z(,�&�0�ݣ "?��	��¨s�����Y�yG-ǉ��I�>�F�������t�x;xz����j��Ȫ�yj����������i��TS#����q�ZP���E!��~@V�W����vZ�5Ϫ�o������͝]l��|��67��+���-��u|�N��GU˺̄�K�v�ϝ��^O�1/h�i�f�����"tm�`".���{^��t��ׇC��_��޳�S X��直g��*U7f�:�e����k�����j쇳jPC[v�x��Z
[A�@4� {N�8�w�N9ʈ&q}7ѵ�?�z�R�"�PO�r� d�� ݷX&���cD��2�w�T<�8�@w¿rx,t0hջy{�س����aX��kp��x^��L�D������Pt_��c1���>n�g����C�(�k&�dD�d%I���0����c�xZ$��K�'�y�|ȓ��c6?�gS+���|՚L���g NH�&��c��4E}���l��6�I��{���և�\��_ċis��T�$����8<���96��v�)�W�a)/7�/��{�B� ���ti�M�k��@ᙊN ���gb��g����0fo��宫5�����/#� ��3ɔ�)�Q�g��	���������V��ў?]8��c����nLb>��O�wً58�nbD$�;�D����NS��!@���z�~$o�[�L�+���l�{��ê��	[�mPPh����e#�-�J�7�k�ej�X�"#�=X���4C;{~�g�#�q� ԰�zn4� ƪ��?o���BX�?_]�n��|�Gs�����}}-��3z�~TeaL��u��A|�� ���7]���K��D�3r%����^D�r�R���.�MmB��    �7��q`R�!%���']C[/��X!06d+�ѲM����=W��7J�Ԍ/*�<��T9B�s'C�E�u���E;֢&k��'l����x��������f�	�h�S��qt�DEh�ZQEh��a1�o��'��,Pʘ,ژV�0 bZ�~�������F�&=\�x�7m�A/Y�
�ތ�m}�ckw�`}�� z'�A��M�{�X�O�8.��^�q�s���`3���N����0�B�I\�'���ÿ������|;�}�Џ(՞PST��/�M�7�"�`w��j�bsss�囵z����D����M��^��#�>Y��I���^�ݘP�"B�F+�߀F!�����r�l�e�%�l��x>v�dѐ�r1�����K�Ne���w	�	Ibt�ghl�Y��w�e�����1	���˄��z��o����z�01 M�����ݾE�u����� �f�h��w�_��Dw��T���������"�a����
	���"����5	k;����������m��d�cU=Z�IU��:p�\�� �X42�0�Dk�����!���K�Z����ߞ6J}�g���M�Gh|49��řPl ZUN�r}d�f�+�_�j"]?���M�����"����m��'ڱ$��%wEgj(673ρ�.�Q�����q��yƼ�� �M@��N���(�Ku�������J�ho�[���_���Vl�%��>C8�~vA拓�~�v��5�TI��1��3�uBoh��oG�a85~;� �G��1-3q����,��O����\c�[�f�)��C�t��5$塞R�N� j�N��wA��)fPOq|7���0�.%�* piȭŃ�Ç��L���������O����A�$j�<17��g�bX�"�r���\�9:�����%e��A'�H���I�F���� �02�}m�"���"�a��o]ѣ��%�-x��)ыz@�N/�&q��T݈ETk�=�����LO��Gǳ���W�wϪ�\r �j�������}bP����6�ٳ�Vh���ʁSfQWZza�F�T��T�E��!^O*�?��4-C��=�w��p����e���o��+�n�!t:-0�0���e����������
��*����e�U}�H��sy�D[�ϱz�0�����43ٍ��A��Sx�!@����i�M��D�N1jR6�L�#*E*��K��b#��u�>����8��g^�����!s�{)�уHJIjB�$�yE�'��"��v1�-���5�@t�:������!��|��;|��kPzw����IߩQ�y]a���8@$^�\"�v'��ƃ��a��k�\_6�Wʽ�#�<�u����1�T��TY5mb��c6��=�Շ|�B�#������}����6S����r(�aG�"�o�>�R0hV7�we]Ӈ���o��W}�[-9���A�vR�#yR���Jb�9k����c����Q66c9Q@���W�,)}I�Ic��i-T�f$KxQ����M�2ԭɅ��x�q=�����}Cw���'3F�Ξ{�wɷ�Y/އ.�)� 6�b���/��ࢉ��Y}V/jLba�T/����\]�x^\ڜ��h�����
�����$(�4F��7���b�g�%�I�? �ۃ�̊�_w�[b��<
=�Z=?�m ���8�"O��`	p>"�=��Ţ��O��
1L����@T1-<}Ib�=}�%$ؚ����~~�������a�6�"Ül��"[(N�l�`,�$X�n��`'n耞bz��=vAᨕ�;�{cPY	^�t�',M�j�,��J'mZȚZ2M��r9�wh[LÙp�ǅ�/�F�.X^D�Vǃ�!����TQ�M��۞7�Q[��W�C� ]`Q�5�'K��Zk��J�3!��:�bA��Ec�H�����Ϭ�8ſ���S��W{�T��ݮ��:z!����#f�?�é��'��7�w����Cȡ#�[U�5sS���ܕ�f��-�P<A��ڣ�u�F��)�<J�3�����O��i�/O�TP�� ���^��~*/��i�.j�[4�X�N�l�Y˺�&Y�	&�`_9�b�Yg�*������Z��Ԥ6��ic����bh�En�9�������l%P��*��;b� 8:�U-�n�"��E�h�GI"�؄���� �it���(
к��)���z��U	�o��}]��y���p>CY�|Z$��G�4�a;r� �����+�9n�!����m)B^���{�}�z��O�A6U�@�C�!���c��<]��t$pnE���WGWT�R��O��
g����a3��(짉[�9�3����F����}������=	���!e���j�MH�����m�ؑ���> 1��a�h@Nެ&���o�!>�Z�3�F�O9�`�|<ǿ�I����\�~�i��;����6�;�� '(aN���z����u!���	kw�"�z��ÏjQfk��8�V=��s9D��V����)z�J���P4�Er���Y$)�&u;�Cb��{�[B �^�E���[�C=$/
\�$��h)��ѷ�r��h�&&�;J.�Y�b1E����#c�4�JkP�bB���u1a9A��_�E1q}�h ����j�6����e�1d=Qv�X�X'�>���������h�ͷ���Z&(x�ۓ����'ey��דּd
��G�
ChU��1���y���1�M��Ift!6w{,}8�#������F!VWbi��K���`�:!�H�s��_��h+ G���b	C�>Ff��<�T��ZT���oE/��k�� !��xϲC����b����J���[�	�[�W��"p��F��0�NH��aD��k�q�u2���\
fcr��
���յ}zu�y����������}��h ���狍�����z����h*Ɔ��:�7�8�y]96kWB|�j9����EZ�U�I>�Iq�-�2�z`>]M1�0$�0+V���ںa�G�8&ҝ��.׷+5B7�=d�@�Ŝ�b'l������ 7�q?ڷ�|������H3%{��~X�Q_7;��x�χ�h��r��(�#��7f&�{��`�~Oy ���N�H,'�:��|�9�%2�`ŧ�a�Ĵ��}{�W�#:����,ĕI�3L3��������dRI�RV����r�/jS���46�x�S�y5)�����7���t�C�f���\1�@߹�Q�(�������`s��.���J�q�&�ZQ���Vmv��V��I�28PYRO�쁱qAj���SWY�ܧ "p~Q��o�
����r_?�q�O�2� ǦNmH���F���,��$����Y�u#"����(
=�Fa_SP�Z��� �N%q�3��k�c^e�
{}����Mi76]�H��8��|��v⧳�9�]�J��&�">�V��ax�,���ݷ��A��p븬�VV屰�R��e��O"�4�D�
^t.�Ϊ��Df�ߛ`�>v�	�k�Z�E�-�i{��e��2섞K��t��ꯓ�3�s����J3�{��y�rC���mřa�9��o�9t��f���;K�z-Ga�U�n�rQ�K]B|-:�3i�x/��k?��/|m��+��d�`?�U�ǳ@ �5t���
W��u0���,��{�#���r�f�1�,I��	6LW��H�2up����s��N��G��Zz�����6�g�'������Y��W%q�(VMk�����7���jh9:���g�ۮp�=�`/��3"��qg���W�����̻��G��D~H���E�&�b���>��wt?F��,�L�PY��q�mϔ��������i�\��Y�=��g+��=��"��(Ec`r}�	eHQ�����@uJJ�>�rǡ��2͢��xޤ��=m	t��G�7��|���1V�;^0���0mog�    �G\��mp]r��fɭ�o����xL��X�҉$AW���vv؉����V��ab�h&�H�!Y��6���n��Q��8��6���z]7�_�!��e�~:�LO�h�pR%�w��?0��늘���	\�%oo7uJ����P>h�����j�n'�;P]�F�'�&e��/�V����y��iG�W��N��47�:���٤2B� ��`+�7�Sǥ��_>GB�'y��d̶-��/��]�8��!B��.|Y���)�x^��_W��sr�Ci�V�:���/Z$��[��K�e/,l9����Ӌea������uȍ���i+�~d�;3��j�8�.G[�ҤNg�|���ݏ:�����s*����w�Y3�9�z?ڬ��Aq�G���0���%��N��,��T���G&���i��/t�J����@�@�i�	n��N��.��Pon&vZa��LniEs���?}-~D�zH����X&�!�܃�A\ekI�0G�и���q�U��]8�s�X��2�����vo�vb�%�x�Jh���c�@0��g�:]�������K) �a���)(dj  �;!����|D6ig{��}௣�#[6sc�O���S��`m����q�=�6��Xh�ͷ��>�1 �B$~�I��ёIѲ���4f�N-��b��8���^h��YVh|�k��}�:��n�z��[g�m���V_]t6?+����c�+�2�Yʁ��X�*��2AL�W�g�;���U��Fa3�~ՒQ]t���>M��ʖح� �=o����h�S���^�<+��\7T^x>mPv���u�oN�Fqy[�߭D8il��.�qȫ��Wׇ��sb����<QZ�2)���W�ׂ�[5�W���#��:�(�#�O���Y�b���h�K �Xc�F2��f�9i_ +�&��m/^��_ ��F�b|�C�T��
Z<<:6�e�,+3A"'m����8���u,�H�����$f>҄��� �f1�����JAF]d҃��Ka׭�%籜����B�,�^�	�s��K�`�;w"2<��$x\���0D ��P�\�2ܤn���_%9j�+H�1�����s��'af4��k��3Z�n,Ɂ�;�W=�fˏ���q���qQ���8F�~�)����J?�3��Q봞m,��s��eh8&��'����� �x;R����gTp9
bsq�$��ɵ�&6M΢>��I�����e�������lQDc���ub�����=�;��y�8�8$
|Cr�h��5�cR�.�*De $�}�J��8�3l'Kw�j��˸�t�D�$?�@���#�HH���Yg�Km�[;=���S�k%�|��,Ƒ�3s�
3��2�\w>
��w�����e�!Y�
�\�19��e�B �^(�]m!\8�!�Q4����k���p�!W`��d)��/.k�R��Vگ6�o�b5o�n�lێzw�D(S��Ӝ�Ĝ#���=�����&��X�41�1��϶�b,
Ķ�J��HM�ǈ��͝&�}�r(;�ģWy'zw��$"/�yؗszBA�z,i��� �±յ�g��D"�U�e�XdU�
H�扮�>��Z���xd�Z�c��S8��.�F�I�� �r����}����tm?ܸꄑ�/M��3M��m�~
&�_��Vu�+m%��^X�7:�l�{�S�vI�r�.蝂�S����0�������=Y�c���#g6�3���Q�y�(Mߌ�z�P��fް�>Hc�{8Q��'q0}x�������� h?���%6����E;�h���۷�.�q۸�G�r��f�y�5b���i�*��t.��R��O�O ��SYh��XL��S��7��n?��6)���!;�f��!ȹ/�{��00h"�Э���Q��ѦlМ٧&�w[�����7-�����P���8����k���:�i:���Er��#(�RP�
����2 ,�-�uÜ�S��'��,�S���u{=�k�<dgj��3.!�=i����|�Ex'/��ܺ
�o�,sq�斵 S�'�+%�b�A��ݺ�J���i�㪇��O@MSwC��BP]�}
 R4l6*����������^�^�y�I������f��]�c2�j�l�ؽ�����sE�����&[��sCbX{fL�t=9s�|7��Bv9�t����;�zԦ�%&� ~ldc���i�~d�o�E��|:�7e�X�}:�=�P���<h���K<_��_��J�iϔw������
�����5t���n��>�?vB0	�	n�8v�w��1fw �8�Jq�eU�|�]���S��ێ���9����N^�Q3�ڞ	������3ݽ���#���3!ƂIN��Y�����T�W�Q�3Kp�O�hQ2x
�Ζ.v���&Rɸ��/G��#�+CH��+����|�F?M���
Ju��ש|_V6����}ܠUp���;�siG�R�b/>�Hx&P�\m%��Gҳ��]�1 �s��a6i+�E��"/�5��i�"iA���b;N�!-O�z&a\�s��(��y־���NT�!R�"��Y��r�%���$������&P�9[����Z�|w�����p�2������3�ׅ��f��󞬙J�Fڨ1��}Ŵ=5,��X��"���*���[��Em��!34�q���XfoƬ6���M:J�	��):���r>�M��tz�͖�tT���\l ����#Q���C���f�&w����g�����i9��4�m%˹\���h at%۸���|�*Z�6��46ǎ�(���A����z^����GH�*Y�����kW��g�x��>U�U{)M�N1f�]��[Z��A*�/�k?��{D(.�Z'��@�q��<�Ӭ�IN����4�Y�7��d/��7%�Fb���S7Է���Lȋl�9��2����uS��C��챋��U<e�r�/;�`��4#��4�v�+�:Є@�ė��ʔ�,c��H��Xcu��8Һ�"k�C(	��F벺�zx	A�Sw=J��n��Ҹ�p����a�T.X�-�����L菏O\"�2)1e��Ζ�j��b�9@A�3;��
WX`tn����N8�I9���">mZ�x��c�j�9��&	�Љ	���H3�������)�j��d�)�|+��5�x�A��)[7������������0��)R��pdr���a�t�nC��v��G7=Ǎ�pd��g��[�Sp�_� �τ��4Œ�X�n�R7x"�9���%�g2���h�O]⬴���-��%�k�ȑi׏�6=����p���0�4mt��Hs�Rr����ť_Uފ#f��X&X��ǯR��,�8 �+�"[�+x�M=*�|i`%�Pì�p�O��̚[-EO�K��v|X���������ǃ(��yn�Ad�v+L�{nD䞀��( =L(�i�n��<$
��N������9��t�)�'�	3����Y�.���u$�1廮AC�Ug�b�A˱�p�H#t�y�P��n�1yl�|��F��!a1��Ǣ.:�xX1�\�5_���s���fܢ�Wh���qZ�^U����mV�мE�`�#g�c����^jm���se��`i����m�?g����1uſp�v��y��8
�6z1���*���CM_o�-����哕��������.Ds�p������4a�?d����.���ס�SR)�v��F��s����!���맇k{�A��m[�I^=��ڂ�A�"f��s�{9�|�k���@���A����i���vȢ�]m���aݮ� jiZ�Ń���,��4^�5<Y�;]цa��\�h��A�C
>�:�U���	��T�R+���!�,�(q�z����g�wK��o1�-�E���\9v|�����=,Z�a��L�n=�&O�G<�EHɝ��Y����bv���w3�L�pu��r�    �d0��.۾n�V�<B`'�6�<��z�.t�؊g�iǤ�+� Z�1S��4�h��2��t�cW�\ܰ�Ҽc�v�Fu�1�x�Q �pa"8A�~J%�HսqX�]�o�;�huv!�� � �8�<-�C b?�,���u)1��kAքw��T�y[hR�L����p\����-1H&Z@���X���-d~��T������ x��9]wd��pj� Z�].�/��'���7{2���g9W�u�f�c�DG�	&q��<}C�v3���J�v�6� 7�r�:���p&�,�<��+�MK���^At�	>"��!vu��.ׯ���t���~�	���]n%�7�OA��m�r�eSC�\��0�p 	:/��A�7#fa̓�P��ls��Rߏ"K���A-zi����a�o2��EF:�y�6_�d�A��7�t������`�.�v�iݒ�1��Ӳޝ|����={2��{|��Z�v���!�0^��́������%y٩�lbP�s�t����Nd��7��b���`���(�_�������կ��w����aP�R�u�1�����p������G}Tm�B39#�)8�=�ǉ�ߍ<��5�\����xy�}F�G����0��~�g��uO���&�����d�EeE�)�,8{��:����VX�y&s��lgbǭ��y���/W��г����V��p�9Ā���Wx�H�Hz���e�`v�C�9���K ��MCH��[�-Q��k��u�y5�;פ�F"'�d}�8�il?�8�z�Y�L�A���Q����ٲG��H!�/�8ý������뎫� �5U�ơ�o8pI���x\e�C�u��8��EB�*^�c�e�V=J���Z�P	�J�m�{�|���͍=���F++��<���k�2x,���t�kf���/=�����B��J+�ڊ��v��34���n~�Fk�>���h�`� 9 8�-��A���F� �p�a\[:�q���� L�5
8�:ك�B��z�"��0KP�Ҿ�z$����y�~����v�&�������{�Uc�Gnz��3��y{9���Ol�#n4�F>������ߤb-�ʱ���z�}	�!4R�ޞ�/���e���Ҽ��5�����]9�>�e��2��Q
Z�k�� 3�4 �x;YMs�vTlI�r��2�&�O3-��=����9�<.w�E_�9EM��I}8a����=cx0�,�������d	o����WɹCEm&�G�S��T��6B� (�:�zk�"��2ƌ5���������I�dL�Ǔ�Ny?���:�|G-���$G��aF�H2��}�"�� �6-.�h��������Fmd/�ds�������/A�?.��O8w���-���D�*W���OSg���3V__�[d�y5-o#p���09��UrZ�Tr���?:6KƳ���|)S��~G�e8%��S֋�L����A�Eo��C3��������d�Q���q	�R���,i���,,,h�us�	��p`��������kx|G5��A�c�����B�_>��œB��Ʃ�!�U!Zm��y0�#�1��#��rypZ�pt7�l�?�����g۴�H�#K�n��c�OSlBEk<�d=�g�O����':�)�\1�9�ҡ2ڔ�z`ٱ'��碜�Qi)��$=B������֑c�'\�!CC{�x���ˡ,�μ���H0�I�4d-���5�\��h*�Vfg��&��WZ�� w�f�hGYԔ�D���M�4��mn\�.�`Pt�).(k���Ȉj�gU;���9�q,6�l�f��;�qd�Q�#iS�*�7��n����=	��2Q-�eU	m�\������8� w��K����_I u1>J?N��b��5n'w2�ؕ� �V�y�s��js���mC���M-��oR�xx'e?;�O.؆��Ou"B#}�Q(���@�m�x'_�m!T���#[q*nW#�������Èߎ��tz����Ę�yK��p!�a���w�a�p,��M��#T�����0����{�<���NB��b�e }EN��#q��2Q7�t����D.D7��͗�@�)�����A��������{��������~Gh>y1�8�A:49�� �pjV8}�@x|�U�'"���%<��%A�vt4O�i�T���2��ۉ�������x��1^ �Q�a�FLP{�V�\��� gઃh=m����#h_�L��G�
W�,����ytO�"F�=�O���8|��T�a	M8wvK�"���=�;V����������O�8 !�%~;�Itm�2i���o��*]����pIsm��L�V��Q�wL�H�#8�ܰf�����.W�/G<b�`�zyfO�e�v"����J� N�QŦ��[���2e���8I[��q�	�h�:��Z0�|1Іy{�iOkh��j��b�\����]�����^��G[Y�G{�t�X��^�"�+�=WI�m�)����f� ����I�� ��_~���������������4����a�o__�$�����F��qI��"m�5���=p1d�~�G6C��m�<�f�549ef�J�N��G�������\yqH�e&j����:�ҦdB�n�TB��@�@��i�l4.���۫���������:^s�bm��2=����V�ءq���hȶK�Z����La���f�wi�b9�P9��$���L�ϼ�  ~l�bd��6f�:=�NO?�c̽�>}9H_b�B���F�˲�U#W��QT���F:�+����.��{��g��b0�MþD���d� ��ߚ:4BK�8Q��)^�0w�M��a@�H�(�b�4��sB8��<��nO�7�{D\x����mu�d�	V��R��if���f�kd�2�.�k�L����ֺ�Lϛ�&t^9�=��59�4�q(�K��K�Hqå`��.�7��"��ڧOG�\�kӓ����/���3�:��ϣ��toD�+o&�"↘���p�q�"���Q�.z��	N�J�ߪ������nu\��ڦ��#���,���O��S�����S�t	������n���.��M���'�Ґ�pg�	��2�����i���C >n��|�fU�x����S�A�����]-�5��!�-('��IĔ;��d-�Xս��!&�󙅣b�l$a��� L{����#�u�2{�a�[9o������\Ѿ.�l������>��
n]��I\L�Y"�>�����r�?��������9u��Z|�!J'��h��pv��$�������5�+r�awD��>�D+��gXoB�crh�+�!�a�M�x~j��!���a���]����6ߏ�>������&�Ѱ�M
=Y?6�P������\�u,�"��GԐQ4-D�,D\O�d­;a.��r-Hg[�����DV�����Ap���:�G#��Ss����;�8�ϐ�Rv�rY!�jʫ]�*�l-��1Y3��1�1G,����p�8o̰U�Lszuup�`�a	�\V��[���$9�|'N����S��A�gt����^��ڧq	/@�7$��ٌe7��\B,9Ź�h�9�R$Ѫ��.p��Zo(�U���b�;E�iu�,ו�Z~�C���l�"{Jz�No L�#��8�&�2)^�D%����H<�l�|�p�D���Bb�D��u�N��~����0�L�"���Ů�M`G�x�Bs��|�na��˝(
<$������"�d9O\��G0��iCs'��LTp�:C��9]�1 ��N�b��%Y�Q�y�F�S%^�o�5'��P;A�s}Lc!V��أ�F��"yu�b7�����l���7\���]�J&�qq�	�O�����zp��4�gřڻ\���ۉX��
����Ge��  � ��k�_`��<�K+4̔�u�!2�^�s}9������0"R*��� S  `��C�Ū�R,���AQ�7|�f��R�Y�Tm����t�M�Ұ��l3[W��>H�����y[H��#5r�2��̑��*@b�@�nY���T�c<�H3O��F$z2j�5yBt8�4;Q��6&Ȝ���65�-����v���2�n B^��,to���Yn/���Bo����U�)\8��{9Ԇ_\ހz������?�<?>��B|��!�	�Ms=p�C���E�Ĳk�_3 �!*$���9��?��=�
!j���zф7-�r3;��rzW�\�c�//�
��s�zsi�y~��3 ��AҡZ@pR�v����s�RFj�O^�����O?�?�J�:      �      x��}[WG������O���u(2#�mؒ� ` ��^��׶�K�����'"�YU�*�h�Gxf4��_Ed�#�� l��&���ݓ�`L1'O�����}��0�v�?]_r���7_����/w�]�.˟���ӯ�m�?��X���zf�x����7׿�����Wz��ka$���U��=�����o��n��n������~��t�rO@�90���ͧ��������>Z�֔tp�{��y��x��+Ӧ�t��\/6_o��\]�ss���|��7�O-��L��Y0l�R�V���ǧ�GakǇ�v~]�xsv��١Z2�]
�E���.@f�����}C��p!3�r���:�b��8�)7�������ơFqX��vx �Q�J����>e���N��ܪV�r�dH���š��-����	��(��px}e�2DE��!Q�ῄ����8�����Y@d�rrC���N��@`��V@d��~���9@T��VpesG�8As���9'�k����QxvE�c�!:� x�y�����?�����`B�)��i�{\Z����"ˮ����y,��c�YϺ�=��b����͇�D(6��A��Bֳ�vO�B)�:2�2�w�D��5��7���k0׳�Λ���W?�������@~_U�z6��	[Xn�3�q�8�|4�0���k��1Q�A$_����c"�h�t�<&^q�%Vd�Zy"Ma��$���qw"���D@2O�\O��Σ��(.�`_�<<<|���_�n<';���,�olHݔDb��t���ow�>�fХ�2NuI��R��9ǐӧPͦ�+� \gQ��*2d�6�d�>�z6��a�D��I���	��G��p}�lZ?��+��(��N*�dn�s���{��h�C�Pڣ���_�n>l��>���B�1ڱ֦pX2�Ǵw&i��TH�|��>kd ���Eq#�<���.Cv�2v&�zO�Ch�k׿�O�&����)]hWȯ;��d�|�e���:�HI�7��\����H�}���kzn�\��d�B�D���}r��5����U��{�� �i���/7��wOϏ7)��s��.�'}H�M�b�q���=���{Qb�d�d��A����~P�{����mR��.'Xp�5)�,Q��2��?j�D�)I��?�淥�	���?�%�Tv7��P�@�q� ��st�ݦ��yf�Y���������X�H���w�Q�8��IN�ðYk!�>nzY��OΣ4,F6�v	.���r��B��缋�+��;<����q�9UL�e���c4
�P̞P`���c`
8��"�%J�J�Z'�TŊ�S�E�{Lx,�N� �b��+��Y6��>��G���G:f~ ���S4q\u�T@qw���;.�iU�TM�?~Ɵ���g�����C8)���L����TqN�@�'3��1'�s�t�(���3�ES���������� UrH)E�+���&�EN0��	�A��U��I��f�r��/��P�M�E�)cC-�����X��p���m���ݮc�|٩h�m+0��B�@��T���V2�����2��� t��P���+.��=�b.�+�Q�[�ФBkR��)�x[�B3)]��0qD@��S)!�lG����ay�'�VW�0�D%��=�|� R�W��1�5rE;Ú�M��?3�C��P5UՁ!@�lT����Ye�F��>�<>�?%����s�dXB�<�:���1^X�4�d��ߣ�CӘ��Hrӽtr�l�d",<�+DH����:����HL(^DK֥�*�Lƀ
,�E������� ��uDD���9�h���+�U�MAD���/p�Ei���������(�d(����P0x2�.���u��>�F}C0�F��h��=�R}0:���`L��������0P
i���Xl��,�H�(�ʅ��,�����C���e|������SDE�(\���.{I��>Q�+��`g�ڧ�)��� ͩ�������^���$�,V�G���������X&ђED
��e��h�Si4�ݯ�|}��������ӯ+�ۏ]�D�U�eϣ�wh��1tZK������;�'VT��=����:�J���r��.��y��dZ:d�×�/]2!&���çRx��<�VX�2Im,gK&��l�%�ݾ<�Z#J2��DF��a�酺�X����J<.
}�`�Z^��p#�m��jL�*�6M�eģs����[�..���9�%�;�uK9F§�=�a�I.w)�*��B��
g��J¼�.A�ͲrrR����$��d��4��d����@+�u_ ���T<�k��D��!
�i4!}/k��门"8�����A8"�9���dD���Ew�c�ۊ&3� ;1�|�XDQ*A��;W������k|t$	[�%	k��k^Q�C�`Tg0��ۆt�#8|���	!��~*G�V[.�鴍6��b�t���K��Kd(f8�б�@��:����b��j�f��吡˛�̗��Gt��{D�o5�A��Ey�d�t��"C�!r��a
?���TRv\8|�Y�����47�f;�*���t���Xt镉�X?ՠF�7��g,0�P�y�,�U�a��{UӰ�^�u]��1B�0֦Kz,Y K(H�1F�6Z02���4���?t~uW�B)�������8�h3ƿW"4��D��~���o��`������k�#��A��Ԓ�}�\)+���.j��Vs������15�����RD�L��!C��'�Xa��D��Yң���"ę�:+׭E�PA}�Bk�"��h��b�Pj�����}���èD���Hw�S����r���\��U�>NE��:S�	T��6�q�:"�Q�%F!`��Elv2&O�tд��
n�)4!�4/Cɟ�+-�Z\��_��=��zO��]���ԽB�MӺ}U�����M�^yj�v�Yʼ9!9J����c�enY�~�F�����E��������0e���雃锊�B`T/,�Ǒ�&��̰e�|��Y*�"���c:�!�HV����Ҋ�w���r,$2 B:�O'�M'��J��1�%�R̢���3 �5.Ǝ�*�2���4TZ@��1"�BS(�Q�ApiIW�Nv���b���-u�,���M��*�[�=����Q�2��EQ:5��t��q�Q�h�c�h��Ǡ��i,�<���web��N#��� 0H��67���d-p<�������].�7�\F8&�U�`�L�>�n��xN��E۸�a&3B��lP���^�uQQ]�B�I���#(3?tf�.(˺�*�Oa��@n�6���H�y=��[h�M����oq�v���ӣ�I-#����Զ�Z�%EE�j�Q��z]�.M2̌�90�)#��m�����X8��Q1������"��"�E�U$�#t+3p�$\H�W�ֺ���-jG�ų�����{���l�ˌ���+'���m.Ƈ�ޗ�3$N����ό��>��GM� �Ahz�駓��G�d�����5}[s��b��r�l_AjQ��G��S��7�ֶ׏�U���KL �܉�f�J����(�9�P��z�"7�Tj�L�L�=x�,])a��-e����ũ�ҿc��Y�R�I�Y+z!�@��]�;5��J��s�$�Y�bv@QoHR�4-aqu�R�����s<]յ$�-Va�X�������"s�să���\UX� ���
����v�z(�d�e��!]vp���aH�7(�/�qd��vds��?�\^ԩ��
ɘ58DVR��� Z�t���t���� ��.$[6�(��w	n��'!�qG+�{Xl
�r�B8n!J�س�'�,�ӗW�p�C�4(�>CT����FݗU�$�էT�Bp�������{�)��x�R��D��"�Ƞ��~⟜�&*j)�m8���d"Y�������i����iΐTR�69c�IԮ��`�    �Pż�z��|S^]��#��h�� �Cm��'�f�Vk�)C��Vvx	ŐS�_�{�\݆�x�����#�j�N�¹�#$Bw�Pf�JT����u���g��,�*ӥ���KNt�HP�q�?U#��۸�)�ラ\�BP��<<��տh[���Y�U��G9�S#m���t�������G_�Sl����?V�S2�yj�A�̇q�+�f�<��-3A��+�ew�<&�b筱��D%/�Ŀٿ�Ӏ EDLHV�>�oՌ`}���L-+�?o ��G������g�B����S���H�h_ ��8�p���V7�(޼���6�_���D��N����"w�y�+�¨VrP*�f1`ч�E~F*�� E#O��N�&�����b Hc�N��6��T4(.ח�rCW$@G����%��Ad��N�D�ƙ7��]���L��)�>B ��rh怛���)5�GX�2�}�C���yVǄh��lt%�M{�h�m3�m�H2�|�W+���R$�s�5�sr���F}O��~?�0�ϣ:���P�i���jw�s���SFQK�����M�^ӯo��@��H�:����t�/n��#��DV��,)mѬ��B�� ��.�L�)�WS��vH������P�g�S�I��-C.5A��jKwt���L�"J�)t�kѺx�vuq��:Q�-�I��%���."ڰ����b�)j ��"��Hj�1	���><f�8ʭ�٭Cu���"K��/�El��QP�����'�g��z�uI5�F�� $U�:�&#Ua�y�
֧����CF��>�b<M8J*F.&/
�K��CR�]���R��9�� ����B��31>0Fi~�U��\"��Rʙ���2e(�S�����+W��4=c(d2��C���v"Uf)�U���dM�Z(!���Pk��s2��>� :p��Q5�����z��)��u&К0��� �@m���{����t���s7��r�yW�}����jqz���~U�}���|Z��X�>K��v�$�1�	3]�^uX��r�����n�m#x�z�k�Y�a���<��@M"�c��ǑQ��J����cC�!��j�����<��eG�I��Qd�ǝG�;�X���	�֐:�-6�-�4���M�.6Cm�R[|����-�d���ыs#X2Ͽ��3�;�@�Ґ���ɖ�{�dO��/����Hu��b|pz�B��F-d�0J� �dh��˧��m� t��SeTIоn�n�
�Nƥ�|y������Q���4�#�MH%�Ls�+�vk)A�C]�ߊ���'	�3�Um	��O᭕&ݷ�� �޿�Ym�R]�xY{�y��4���ڡ�ޮ�m�[��۠��J�~����	ִz./D���h�k�(BБ��	�{`$@m<:I�mK�i(��D�!;�nq������ȮGP.��ʰo	J��~�W�9JFE-�8~~�
�q�"�P���'q�W �totpP���=T�v� ~ꓮ`�WNAf�N��R�7��6?В.ɽ�����)�q��.���QR���HM��<P2�[�l(��-7#� %�Ar5*I�JP3d�vA� tጦuQ��8Ju|p6�����ٜrPJ�tm�V�A8�|c�;�Js�-���i�#݊�I(Bc8�������\�2���,u�P�:P�~�����
#$Bb��(ڵbF^�ȏw"3���D+{T�d	k+Br �wյ��_�c�������{7|s���P��߭v�h��QM����������������#6h�%�]�4�?ׁ��-���M�;�o=�F��?o�w�l�D|�� ����ӲN�Y\K�����*�"�g�\u�xL�_�{W�m�Զ���0Uh�IH�TZ$E�
�v��!уH�\��8�qv�ےk�/�"\�e�k�_���(�P�+2��W(|��O��k2F�փc̘G�<�����y�m�nm$�Ⱦ|���ӿ��/�M�#^�_\(z�l�u̪o���qM5�k�Lau��qT����4�����)�T�$5~}s ���L���C/������>�r��K�O9�2�ϴ�.�N5��'���b�!�Rb��pz�_�-zT��4�F����"n���nV��m��
:̨�ā"�6f�2�:J�Fe=|���\�1�{�/���ծ��)�*���Ǐ�}΍���O:�eB�dfSMk�i�M��e�K*�F�9�;剨@�\��0<
��<��K+ݒQ��a�E��P�)FU���4Z�H�.+R�6��5����]u�]+7�H�6TJZ�\�4fP����D��ݰA_��m����������bupuv�Ͷi�F݉��TZ׭r��ڰ�BѰ5�C46Fj8$ =:]�_@�TҌ�s"�Ū*Z�F�ڌ0@�H��Ȋ�m
���uk@������g� j�H���tBz-�y*�6���9��juk���Y޼����S��?(��i{Xޑ�Yi��:�c�b����9��hׂ�������;�?$��jouF>KD��l�����8�0��:j�9<���)扵K�m>7�V�����D�Ӯ)Վqs�6-�I��B�Oh�v�x�:
֥(ؿ���I�S<�oٺ(�=���u�X`4��)��#�%��=��V*�M"�Y��4D:%��#$,7)._�7ʺKl��ә_m�n�����Hb�����Q&'%�a�`!ٶ��c�w�c���:����tL��:G��Z�v�
>���0Fސ���2�	�Ne@�ĩ�y���<��B�����qgVa0��p��>1*t&Ԫ1��]�A1nOʘ�%ۃˇAMq*�N�6:ŧ�"-?���XZ�N�L;5i+���X&�3�H��A�)O���ٿ\��?�9�rG�v����j�YJE�z�֣+�^����]��J#4���(�h\�����n�w%�ƣ��v�C�񼻺X���-���'uR�\[E=M�����EW�mF���'�m���ƌ�d�1����4�,�����6^׶Z��W}�BrNiN�-Q�3��� �E�rNN�[:{9W;^z����Ǆ�"��$��'��^-%,/~^^,��O�ǻ������t|�L�s%�����2Ֆ�;��5��]��P"6��D�Wp"���c�dOv�d������˦ӵ E�&�eF����L�����r:�A����=�݋y������n� ���q�씲"k��JLZ��(ԭy��dZy�V��i�c����v�u���
�<�Nf�j��J�>b�3�y�B����9Bk�;Z_(���s����k���m�nH���8q��Ӝ8���W�U�_��K�V�����l��v~:�I�Wl�<8ZM G�$GMs�Q���)����&�Ԍ�IM3̓���`�0�2W�q1s�(j4e0K��*�ZH��������8���{����c\I��;2��B�s���BG��RVj �E�68�����,Iμ�9Q0f;:m���D�Qı�N�Ytr�6�~@c��2|	Gt�-q����h��-i�g?=\�A�C�6�������x���T�ÄVv���q(�
�b,QUP�$?ځV�����t��ż��h��_jʦ)%���������1+������B�/�<�F�a�׌i���M(0c'/��E*TZ��ȉ@5�a�M,�;�SV�,h���K���d����h��i�)�t4�� fXP��}Jtǯ�&����C�]��D$o6N�����d(]�d��q����(��|}Z~�<>Q�h���뫿���5���%�d�\R��_l�}		Ҭ�����ש��D�?v���p�%��u�q�EتQ�����R{&�,���p�l�(�h��{�e�$�צ����turt�Zֹ��h�pk@�����H��y	7��W��@�rmD��!��+B�f�E@�p��N�8��(��=ŮK���BK_�c�����Ap��" X1��O˘�~���(�]�ݼk��4CP����_:�"�"�<��O�0�A3��oܟ�����E�b��FX����B�m    ��B!�+S8-��ޟ/Მ1�.�.��/��)�t$H���źO1��-�9wT��
��{��zc#����o=����`��IK.ޮр_��Qd���]����=:wu�5^Ԁ���Tj�ftbqY�Mړ������m��ؗB�Ɯjz�R9�Uުs.��o�t���1!��;��6�v�f�T[wB�H�<::Z^�sz/Gv��6��i����mB�����p��
igˊ%�Ḹz��[�g,g8�*h���ӋT <�5�� �|��̽)ܬ���I.mW%�x��r�9�{������/�~:[���l�Re]��t�s�Oש�D�Lr��VW�ׯ����+�����pu|u���3��q�2ڹ<�E�{�B�NU���)S�
��v(�����,�Af� HW-�p��H�ϣk�tZ��1��5���W��ֈ��o�����y��	ژ��K��H\�a�2%�:R*��.C���>�����fP2��+���dA;����}�
dȴ)P6b��<k�r��Rb�����f\��%ƅM��s�􆠃��Ii6���A��fӺ����g���?���&�)w��]�cUfC�c�Ai�uRC��7f>`��l��X/�A�Ť����$�h�(Lbk&:i�m�}8�7�����-��R�6r�%]>�t6ݼ�����9�1ڽ�i+N&7���1�۞�`A#��B:*�e mv�$"�yB[''t���e;\�;3M��N,�~'��A��?�,�z�P���g�x�A�#�J��֊��/�Қ�kϛ�9H[?��a�3>pBo��JO1%A���W6IP��YH�Gt�������b�p���Sn%�+/�Z�r�j�*�*��#�Q0���t��*��#�Pn�v�,���ϛǧ�O�n����Hp�*/���o��VfB4A�|`B|�w�+�C4m�����d���t����匙肞��l�l�>&�>��E?�nvQ�$�R�����O~!)����t�~����R1�֑�&'8g4���(�i���eϕ@:MN��@$�aɞ�~j��C��H��k��%hnz����4�i+3��p���>;?GЮB*�D�LS�{~eڢ篞���6Yv��M�MFG�aP�ڥ��R�e�]~נi�:�Z9>�8M0��?���w�]<W�5�Y6�P�66��F���6/)oڼ�a ����7��ie��BsRM��5y�d�A���1���� T�xUnYJ��f�9�+�m���x}8�䔂i�*����&�/�拃��+R�M2f�!YTc��{	o�(��$�9IӖ�� !�	��T�P*�k������`Y�h�)$��~6����F":���N���ZJSk�r-�ID��kQ�mw#Fٿv7��,[�(�\��/��� <щ�pe�?�0���c���Ջ�K.$�1����C�����R�j�]mT�5'���Î
�������닳�K�i�f�6n����3��r#M�^���F�hS���a��Y��(�SW�؅���{,6���	��F]�tAnu��v��@����8���3��]q��cʪ��q�����-�������(c�R��.J*g{<�<�A�I��/�?&�-/q����V�b��O������W������NV�ɡ�����Xm��t��D��#R�
�l�1��h�]�-� (_0|!�y9u6]$�~Z$]�phϥ�vg'��>�l�`�"�\x��"��B��y}v1�A.����A���D���ѵ��q��m���.d��Gg�������B��<'�Ǡ����z3��n"_׮0*��qNN0/Z;�h�Ϡh'�Ȝ�,��!6�^�HM��[�'�:�����"m����"*'a�d�<L�S��DE�F���̈́U��vS(���X%����1~=_]\m��3�.���3���1 ō�2m������#�a�*AԾ�n�ҧD*��v����@�˙R�8x���$�����s��c�z��<9�v��_=�b���PX�9=ul�<0gx"���Em�������t��Z�>:]��J���"=����KA���g��@�t+��z|�=�Y���j0@SN�L����` l�T��T��c�tϲf[3�(�RI�#7�)T|����4óGo��퟽ۥK�m��#��mV�L87��A�)�]"g2�AL�7DǺ�S
�_�=���%�������m���)������:%�R�Oj �(�%�6)���N)��YN9�6��� 10~�#�eZg��J�8���36u0�w2��ʎ�T|�����w@ҳ�	�zg��T�q�C�'��B(�3~=���B�Sk�o~�g��MK��{E�gR d�2zz@M}�u���t	�'oF�p'mh�FZ��Q��C(\uw���$�Я�7���%g���8`���|g�U1�s��RS
s6��6���������NS������]n8Fc��f1 &�H�l)[<y�,>~|���֑���N����a��+��&fa�-.��D���W�0�c(�I�-���H=bx�g 2%f�xV�����f�����4׈�0ȑ��
�ۏY	Pv��8R��_p���u�蜃�-mk��p�y�4�On�I��e�L�vi�cC����B2~����ͧ����������M�b�,)�&9�D�3�	�ݼ6ǆL�R���Ħٰ�����D�¡���d'���B1o�l��U��L�-�Ig�N1;o� ��&X��͡dZ�	Vѭ,�LK�NʶW����:X ���VZӅT�����}�ݏ�e�"�z�$�X�B��t/l[�\R�]��[%�L��O�*�1%�����_�9�`�%��.,/7��mA�'������D��9�=G�T�]��u�tB�J�\�j�P�������|���w�rs�g
QU�2@��uJ8�6�%'"9��hZzឭ�>tzC�CW���4+8��ϾNlߠ�j�|x������{� L�8�=��U ���u�m�ui{��X�Ǫ��� ���:*�R	`�X�W�O����Ћ���`��L��mn{=�V,�S�m~�X\שQ�U,��i�&1q>O�������WhWlvk�[�3���BK鳤��XHm��v=��@Ni��K�hA��[т��>Һ@����.�D�|!�6O`E;����7��Ա��o���6p���ظ|������~�L�^%J��D�M�'Я��<1��%��FX�ӫ������%�c9j����D+�h��W�)�2z�	=��� T�`��P�(�r*s"�_�����^��i�W֯8G˘�dBw�=���f��rJr"�aKr	v�����,}�/͵���pCfB	���3T�٦:�am����ZhZʜ�/�,���HO�S����m����y�������W����0o���9�2Շ�0]w⌠=�o�;������� |�B��b��'ܓ3�\��Pq�op24�\�����~y}�N��.׳8At͘4���o��G�d�����iY��`��ց:0��{�Ul�.a���sjV�:�r�X�fn��5+Z���]�%��Л�����Z���<�����Y�<�'۴I��w܍��7���?�b���w�ަjg�<��9K!ܧ(�p��1zC �1+XZ��j�R����^�vw���e��H-�ĦC�D�����\�Z���r)���������U/$�iW�u��\�J�sq1�nd��D-H��j�ypgWWg��z�[dclk%�c�Wz�6�*�Hh9�������I�#��x�.b����+�*țl�C��p�x]�!��au����{�T�'��ٍFg�ו��m)jG�C.�����k@���<��}J�XH�5�oV�� ʽ��m7�(�����,m��W�s��	��%�-wҡO?��[��&ק7�ɼ(����C&�F��<�2d�S�"^T%'h�:�ҍDa���)��8���	!?S;�M�ާ].e�7��P�T����֙��lZ�w5�+��{��0��1��g'��)Y�ë�P�kL�-Yt[s�뮶L���_$x�Q�H���vB� �
 o  �M#�6{�������}F�Z_(�W!�������o�w��Hw�o�w�'��������"	h��_�$�EZ��F�/ܿ��}�&y���n�4//�=�
A�#"�=�Br��P�r[��}7�Oj�-�Bˌ�AG�m�0>Hd�D"�_�B�h�D�k�Bt���ߥ���Nҡ��]�m��3�3-:����bu����oXl��43"�#��i
c�ȳ���](Qhpt�J�5v�n"��n��X���D��<4�/2;�t[��K���=���:�Ӝ�}���L�kQ��b[p%|s��e�����6�2��b��.��IC7Y�����c����I��P�Qk�È�mk�+�;�)����l�0�ȣ�E��ͣ���I�O\�F�Xt�F�N�i�#Bg:��uB����ct���L��x�֜TOڕ�ޛ�ᨙ6��Z��0�_��L�26�~����ve��Ѐ͛:4�Ƨ˜����'�P�g`Gﾲ�#�_;2�O����=z���$�7����}rѠ��F��m�,���}zM�^����\5@n����@n��)p�Y s���M\�H�P!j �Br���s�'8��ڕ�~��e�^�]m��-4-��w� +!�We�,�#�J�rI��&��\_�B~2ĪHd�}�{�t3�`��/�BnuD� �Q�FZN܂I���K�'".�0��x�9��]6��F����^�@��;%����\��m^�)jYНQ�-�]ҍm���O\�T:����>= ��AS��xpZ2J�rfO��1!$,h�m���*��;��W�U�r�asw������w�o��5����Ɋ�=׿����'�ؿ{X��Ő��{���?����Jy$9      �      x������ � �      �   �   x�e�Q�0D��S�	����g�L��]�Ʋ%K!r{������f�E�IOaF�T�ғd�>a�ohh7����a$u�h.J�3�̉T����a�,cv�H�mR27}�*y♂k5�%|��:I���^�L*aL�z��ߖ��r���i�JK���xsF����>	-ߎ��q�3o�͑�콲־ Ƀt8      �   ,   x�3�tK,�U�MM�H��,N,����2��J�rS22�b���� ��      �   5   x�3��/-JMNU0�2������lc.8ۄ��6�2��͸��ls�=... �{�      �   �   x�]�K
�0���=��
�7m�ґ�%��B��~Ӂ���|p�����~������F�3�l}�P/����p,�L� �G/j�P� �p`b��)���-&?����嫎4�%Dէ��!��q?� hhQj      �   /   x��J�I��L���􂱸��r�sS�3���Ē��<N7_�=... �x�      �   3   x�3�I�PHK-I�PH+��U�,I͍/(�LN��M,P(IL�I����� E�      �      x��}YoG����_L䞕on��vʠ��b�r%�b7.����/����H�m� {�U�y"N������_�O���I1Te|L����FeaBV��� [���T��CiY��\+���S����|���ś���]�m������\��.�l.����n�/7Xp�?3����ׯ�W������9o�6Q(�h{���Ň�ņVyo6�7�o����]��|b��߼����x��n.�\��:߰?`{�n.�i�w��׆ɍ�� �Z��6~��y��GKq���ͫW������Ŝ��X~ޜzw���`�
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
��Vx��@[emL�T[��V�`A�]D��k�r�	��Aa�n�j�� �X�j�"�@0Q�.&Ud�\����������ԯ_�      �      x��|�rI��3�+���}�S%H	� y�T]���X�E�JT�������̤D�-++�Bf�p�r���>��������`������'BO������a�������,<��X����q���%݅��8����j���|5�Ь/���Y�򱹸���^O��#�l�,�hlQ�2/����PK�q��dXI6����Eo��ZW���{;ZO��|��w���8&�	q��D��0����<����6<=�����ۧ������R��>�g%=}yx�vo>]��/6���|9��ւ1ݙ:_�x�^#�N��EХ&gj�9Ƌ�:[��O6Z墮Uʠ��)!�T&a�����QS��Ty0U�a&n�1<ގ�?¿ß���ݿ���x~_����szz~(�������ϻ�00u}1��Y���_W�z�ڞn���z{ss5��~9_4�+�YY]2���K�&k����&8�X#,㉱ wK�`�2Q[F��6���LO����Q���f��-;a�]����ͯ��r�l��ѯ���yܜϖ�6�\��\�3:UL��)��[�D�J��u�)";F��͓��Y���xF�T��M�`����N�G.���_v���l�����)_��:!�*B*�T+&i�x�5�D�H,.������A%E���	�b"�D�����M�w��D�.�f��؎/��f5FA]4��������f�����W��|3;�Dw�\5�_�[�@z�TvA��L���{#��ffEME�ʂw�9#�B�i.�ͪ�D�YVO���Gͳ���<iO$�c9��.?4��>�xq}�,7����y<]]o.P!F��:ZN�8��]rQ�p���'��ǳ�%9�[�Nko)T��j�*�(�V��0
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