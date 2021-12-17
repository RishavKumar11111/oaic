PGDMP         )            	    y            oaic    13.2    13.3 <              0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false                       0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false                       0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false                       1262    69947    oaic    DATABASE     `   CREATE DATABASE oaic WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'English_India.1252';
    DROP DATABASE oaic;
                postgres    false                        1255    69948    UpdateAccountantAddress()    FUNCTION       CREATE FUNCTION public."UpdateAccountantAddress"() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
	UPDATE public."acc_master"
	SET "acc_address"=NEW."dm_address", "UpdateOn"=CURRENT_DATE, "UpdateBy"=NEW."UpdateBy"
	WHERE "dist_id"=NEW."dist_id";
	
	RETURN NULL;
END;
$$;
 2   DROP FUNCTION public."UpdateAccountantAddress"();
       public          postgres    false            !           1255    69949    UpdateDeliveredQuantity()    FUNCTION     �  CREATE FUNCTION public."UpdateDeliveredQuantity"() RETURNS trigger
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
       public          postgres    false            "           1255    69950    create_po_no()    FUNCTION       CREATE FUNCTION public.create_po_no() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
	--NEW."PONo"= (SELECT "DistCode" FROM dist_master WHERE dist_id=NEW."DistrictID") || '/PO/' || NEW."FinYear" ||'/' || nextval('po_no_increment');
	RETURN NEW;
END
$$;
 %   DROP FUNCTION public.create_po_no();
       public          postgres    false            #           1255    69951    update_invoice_number()    FUNCTION     R  CREATE FUNCTION public.update_invoice_number() RETURNS trigger
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
       public          postgres    false            $           1255    69952    update_mrr_id()    FUNCTION     �  CREATE FUNCTION public.update_mrr_id() RETURNS trigger
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
       public          postgres    false            %           1255    69953    update_order_po_intiate()    FUNCTION     �   CREATE FUNCTION public.update_order_po_intiate() RETURNS trigger
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
       public          postgres    false            �            1259    69954    CustomerBankAccount    TABLE     :  CREATE TABLE public."CustomerBankAccount" (
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
       public         heap    postgres    false            �            1259    69960    CustomerBankAccount_id_seq    SEQUENCE     �   CREATE SEQUENCE public."CustomerBankAccount_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 3   DROP SEQUENCE public."CustomerBankAccount_id_seq";
       public          postgres    false    200                       0    0    CustomerBankAccount_id_seq    SEQUENCE OWNED BY     ]   ALTER SEQUENCE public."CustomerBankAccount_id_seq" OWNED BY public."CustomerBankAccount".id;
          public          postgres    false    201            �            1259    69962    CustomerContactPerson    TABLE     �  CREATE TABLE public."CustomerContactPerson" (
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
       public         heap    postgres    false            �            1259    69968    CustomerContactPerson_id_seq    SEQUENCE     �   CREATE SEQUENCE public."CustomerContactPerson_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 5   DROP SEQUENCE public."CustomerContactPerson_id_seq";
       public          postgres    false    202                       0    0    CustomerContactPerson_id_seq    SEQUENCE OWNED BY     a   ALTER SEQUENCE public."CustomerContactPerson_id_seq" OWNED BY public."CustomerContactPerson".id;
          public          postgres    false    203            �            1259    69970    CustomerDistrictMapping    TABLE     �   CREATE TABLE public."CustomerDistrictMapping" (
    "CustomerID" character varying(255) NOT NULL,
    "DistrictID" character varying(255) NOT NULL,
    "InsertedDate" timestamp with time zone NOT NULL
);
 -   DROP TABLE public."CustomerDistrictMapping";
       public         heap    postgres    false            �            1259    69976    CustomerInvoiceMaster    TABLE       CREATE TABLE public."CustomerInvoiceMaster" (
    "CustomerInvoiceNo" character varying(255) NOT NULL,
    "MRRNo" character varying(255) NOT NULL,
    "InvoiceNo" character varying(255) NOT NULL,
    "PONo" character varying(255) NOT NULL,
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
    "UpdatedBy" character varying(255)
);
 +   DROP TABLE public."CustomerInvoiceMaster";
       public         heap    postgres    false            �            1259    69982    DivisionMaster    TABLE     �   CREATE TABLE public."DivisionMaster" (
    "DivisionID" character varying(255) NOT NULL,
    "DivisionName" character varying(255) NOT NULL
);
 $   DROP TABLE public."DivisionMaster";
       public         heap    postgres    false            �            1259    69988    POMaster    TABLE     r  CREATE TABLE public."POMaster" (
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
    "PurchaseInvoiceValue" numeric(20,2),
    "PurchaseTaxableValue" numeric(20,2),
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
    "PackageSize" character varying,
    "PackageUnitOfMeasurement" character varying,
    "RatePerUnit" numeric(20,2),
    "PackageQuantity" character varying,
    "DeliveredQuantity" character varying,
    "PendingQuantity" character varying
);
    DROP TABLE public."POMaster";
       public         heap    postgres    false            �            1259    70003    CustomerInvoiceViews    VIEW     �  CREATE VIEW public."CustomerInvoiceViews" AS
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
   FROM ((public."CustomerInvoiceMaster" a
     JOIN public."POMaster" c ON ((((c."PONo")::text = (a."PONo")::text) AND ((c."OrderReferenceNo")::text = (a."OrderReferenceNo")::text))))
     JOIN public."DivisionMaster" d ON (((d."DivisionID")::text = (c."DivisionID")::text)));
 )   DROP VIEW public."CustomerInvoiceViews";
       public          postgres    false    207    207    207    207    207    207    207    207    205    205    206    206    207    207    207    207    207    205    205    205    205    205    205    205    205    205    205    205    205    205    205            �            1259    70008    customer_id_increment    SEQUENCE     ~   CREATE SEQUENCE public.customer_id_increment
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE public.customer_id_increment;
       public          postgres    false            �            1259    70010    CustomerMaster    TABLE     /  CREATE TABLE public."CustomerMaster" (
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
       public         heap    postgres    false    209            �            1259    70017    CustomerMaster_id_seq    SEQUENCE     �   CREATE SEQUENCE public."CustomerMaster_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public."CustomerMaster_id_seq";
       public          postgres    false    210                       0    0    CustomerMaster_id_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE public."CustomerMaster_id_seq" OWNED BY public."CustomerMaster".id;
          public          postgres    false    211            �            1259    70019    CustomerPrincipalPlace    TABLE     �  CREATE TABLE public."CustomerPrincipalPlace" (
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
       public         heap    postgres    false            �            1259    70025    CustomerPrincipalPlace_id_seq    SEQUENCE     �   CREATE SEQUENCE public."CustomerPrincipalPlace_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 6   DROP SEQUENCE public."CustomerPrincipalPlace_id_seq";
       public          postgres    false    212                       0    0    CustomerPrincipalPlace_id_seq    SEQUENCE OWNED BY     c   ALTER SEQUENCE public."CustomerPrincipalPlace_id_seq" OWNED BY public."CustomerPrincipalPlace".id;
          public          postgres    false    213            �            1259    70027    InvoiceMaster    TABLE     *  CREATE TABLE public."InvoiceMaster" (
    "InvoiceNo" character varying(255) NOT NULL,
    "PONo" character varying(255) NOT NULL,
    "OrderReferenceNo" character varying(255) NOT NULL,
    "WayBillNo" character varying(255),
    "WayBillDate" character varying(255),
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
    "InvoiceDate" timestamp without time zone,
    "IsReceived" boolean,
    "ReceivedDate" timestamp without time zone,
    "EngineNumber" character varying,
    "ChassicNumber" character varying,
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
       public         heap    postgres    false            �            1259    70035    ItemPackageMaster    TABLE     7  CREATE TABLE public."ItemPackageMaster" (
    "DivisionID" character varying(255) NOT NULL,
    "Implement" character varying(255) NOT NULL,
    "Make" character varying(255) NOT NULL,
    "Model" character varying(255) NOT NULL,
    "PackageSize" character varying(255) NOT NULL,
    "UnitOfMeasurement" character varying(255),
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
       public         heap    postgres    false            �            1259    70041    ItemPackageSizeMaster    TABLE     s   CREATE TABLE public."ItemPackageSizeMaster" (
    id integer NOT NULL,
    "PackageSize" character varying(255)
);
 +   DROP TABLE public."ItemPackageSizeMaster";
       public         heap    postgres    false            �            1259    70044    ItemPackageSizeMaster_id_seq    SEQUENCE     �   CREATE SEQUENCE public."ItemPackageSizeMaster_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 5   DROP SEQUENCE public."ItemPackageSizeMaster_id_seq";
       public          postgres    false    216                       0    0    ItemPackageSizeMaster_id_seq    SEQUENCE OWNED BY     a   ALTER SEQUENCE public."ItemPackageSizeMaster_id_seq" OWNED BY public."ItemPackageSizeMaster".id;
          public          postgres    false    217            �            1259    70046 	   MRRMaster    TABLE     5  CREATE TABLE public."MRRMaster" (
    "MRRNo" character varying(255) NOT NULL,
    "InvoiceNo" character varying(255) NOT NULL,
    "PONo" character varying(255) NOT NULL,
    "OrderReferenceNo" character varying(255) NOT NULL,
    "FinYear" character varying(255) NOT NULL,
    "ItemQuantity" integer,
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
    "MRRAmount" character varying,
    "NoOfItemReceived" character varying
);
    DROP TABLE public."MRRMaster";
       public         heap    postgres    false            �            1259    70053    MRRViews    VIEW     _  CREATE VIEW public."MRRViews" AS
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
     JOIN public."DivisionMaster" d ON (((d."DivisionID")::text = (c."DivisionID")::text)));
    DROP VIEW public."MRRViews";
       public          postgres    false    218    206    206    207    207    207    207    207    207    207    207    207    207    207    207    207    207    207    207    207    207    207    207    207    207    207    207    207    207    207    207    207    207    207    207    207    207    207    207    207    207    207    214    218    218    218    218    218    218    218    218    218    218    218    218    218    218    218    218    218            �            1259    70058    id_increment    SEQUENCE     u   CREATE SEQUENCE public.id_increment
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE public.id_increment;
       public          postgres    false            �            1259    70060    NonSubsidyPODetails    TABLE     d  CREATE TABLE public."NonSubsidyPODetails" (
    id integer NOT NULL,
    "OrderReferenceNo" character varying(255) DEFAULT ('ORN'::text || nextval('public.id_increment'::regclass)),
    "PONo" character varying(255) NOT NULL,
    "DivisionID" character varying(255),
    "Implement" character varying(255),
    "Make" character varying(255),
    "Model" character varying(255),
    "CustomerID" character varying(255),
    "OrderReferenceNumber" character varying(255),
    "UnitOfMeasurement" character varying(255),
    "HSN" character varying(255),
    "TaxRate" integer,
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
    "InsertedDate" timestamp with time zone,
    "InsertedBy" character varying(255),
    "UpdatedDate" timestamp with time zone,
    "UpdatedBy" character varying(255),
    "IsReceived" boolean,
    "IsDeliveredToCustomer" boolean
);
 )   DROP TABLE public."NonSubsidyPODetails";
       public         heap    postgres    false    220            �            1259    70068    NonSubsidyPODetails_id_seq    SEQUENCE     �   CREATE SEQUENCE public."NonSubsidyPODetails_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 3   DROP SEQUENCE public."NonSubsidyPODetails_id_seq";
       public          postgres    false    221                       0    0    NonSubsidyPODetails_id_seq    SEQUENCE OWNED BY     ]   ALTER SEQUENCE public."NonSubsidyPODetails_id_seq" OWNED BY public."NonSubsidyPODetails".id;
          public          postgres    false    222            �            1259    70070    StateMaster    TABLE     y   CREATE TABLE public."StateMaster" (
    "StateCode" integer NOT NULL,
    "StateName" character varying(255) NOT NULL
);
 !   DROP TABLE public."StateMaster";
       public         heap    postgres    false                       1259    70617    StockMaster    VIEW     ;  CREATE VIEW public."StockMaster" AS
 SELECT COALESCE(sum(a."ItemQuantity"), (0)::bigint) AS "ReceivedQuantity",
    COALESCE(sum((b."DeliveredQuantity")::integer), (0)::bigint) AS "DeliveredQuantity",
    (COALESCE(sum(a."ItemQuantity"), (0)::bigint) - COALESCE(sum((b."DeliveredQuantity")::integer), (0)::bigint)) AS "AvailableQuantity",
    a."DistrictID",
    a."DivisionID",
    a."DivisionName",
    a."Implement",
    a."Make",
    a."Model",
    a."UnitOfMeasurement",
    a."PackageSize",
    a."PackageUnitOfMeasurement"
   FROM (public."MRRViews" a
     LEFT JOIN public."CustomerInvoiceViews" b ON ((((a."DivisionID")::text = (b."DivisionID")::text) AND ((a."DivisionName")::text = (b."DivisionName")::text) AND ((a."Implement")::text = (b."Implement")::text) AND ((a."Make")::text = (b."Make")::text) AND ((a."Model")::text = (b."Model")::text) AND ((a."PackageSize")::text = (b."PackageSize")::text))))
  GROUP BY a."DistrictID", a."DivisionID", a."DivisionName", a."Implement", a."Make", a."Model", a."UnitOfMeasurement", a."PackageUnitOfMeasurement", a."PackageSize";
     DROP VIEW public."StockMaster";
       public          postgres    false    208    208    208    208    208    208    219    219    219    219    219    219    219    219    219    219    208            �            1259    70078    approval    TABLE     H  CREATE TABLE public.approval (
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
       public         heap    postgres    false            �            1259    70084    approval_desc    TABLE     �   CREATE TABLE public.approval_desc (
    approval_id character varying(30) NOT NULL,
    permit_no character varying(50) NOT NULL,
    serial integer NOT NULL,
    mrr_id character varying
);
 !   DROP TABLE public.approval_desc;
       public         heap    postgres    false            �            1259    70090    item_price_map_1    TABLE     �  CREATE TABLE public.item_price_map_1 (
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
    "InsertedDate" timestamp without time zone,
    "InsertedBy" character varying,
    "UpdatedDate" timestamp without time zone,
    "UpdatedBy" character varying,
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
    "DivisionID" character varying
);
 $   DROP TABLE public.item_price_map_1;
       public         heap    postgres    false            �            1259    70096    mrr_desc    TABLE     z   CREATE TABLE public.mrr_desc (
    mrr_id character varying(30) NOT NULL,
    permit_no character varying(40) NOT NULL
);
    DROP TABLE public.mrr_desc;
       public         heap    postgres    false            �            1259    70099    orders    TABLE     �  CREATE TABLE public.orders (
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
       public         heap    postgres    false            �            1259    70105    VDF    VIEW     �  CREATE VIEW public."VDF" AS
 SELECT ap.sl_no,
    ap.invoice_no,
    ap.fin_year,
    ap.dist_id,
    ap.dl_id,
    ap.status,
    ap.approval_id,
    ap.indent_no,
    ap.approval_date,
    ap.ammount,
    ap.transaction_id,
    ap.deduction_amount,
    ap.pay_now_amount,
    ap.payment_status,
    ap.remark,
    ap.dl_remark,
    ap.paid_amount,
    ap.pp_id,
    ap.pp_status,
    ap.dm_approved_on,
    ap.bank_approved_on,
    ap.items,
    ord.permit_no,
    f."Implement" AS implement,
    f."Make" AS make,
    f."Model" AS model,
    f.p_taxable_value,
    f.p_cgst_6,
    f.p_sgst_6,
    f.p_cgst_1,
    f.p_sgst_1,
    f.p_invoice_value,
    f.s_taxable_value,
    f.s_cgst_6,
    f.s_sgst_6,
    f.s_invoice_value,
    f.p_igst_12,
    f.s_igst_12,
    f.add_date,
    f.update_date,
    f."InsertedDate",
    f."InsertedBy",
    f."UpdatedDate",
    f."UpdatedBy",
    f."Division",
    f."HSN",
    f."UnitOfMeasurement",
    f."GSTApplicability",
    f."Taxability",
    f."TaxRate",
    f."PurchaseInvoiceValue",
    f."PurchaseTaxableValue",
    f."PurchaseCGST",
    f."PurchaseSGST",
    f."PurchaseIGST",
    f."PurchaseSGSTOnePercent",
    f."PurchaseCGSTOnePercent",
    f."SellCGST",
    f."SellSGST",
    f."SellIGST",
    f."SellInvoiceValue",
    f."SellTaxableValue",
    g.mrr_id
   FROM ((((public.approval ap
     JOIN public.approval_desc apd ON (((apd.approval_id)::text = (ap.approval_id)::text)))
     JOIN public.orders ord ON (((ord.permit_no)::text = (apd.permit_no)::text)))
     LEFT JOIN public.item_price_map_1 f ON ((((f."Implement")::text = (ord.implement)::text) AND ((f."Make")::text = (ord.make)::text) AND ((f."Model")::text = (ord.model)::text))))
     LEFT JOIN public.mrr_desc g ON (((g.permit_no)::text = (apd.permit_no)::text)));
    DROP VIEW public."VDF";
       public          postgres    false    226    224    224    224    224    226    226    224    224    224    226    226    226    226    224    224    224    226    226    226    226    224    224    224    226    226    226    226    224    224    224    226    226    226    226    224    225    225    226    226    226    226    226    226    226    226    226    226    227    227    226    226    226    228    226    226    226    226    228    228    228    226    226    226    224    224    224    224    224            �            1259    70110    VendorBankAccount    TABLE     j  CREATE TABLE public."VendorBankAccount" (
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
       public         heap    postgres    false            �            1259    70116 #   VendorBankAccount_BankAccountID_seq    SEQUENCE     �   CREATE SEQUENCE public."VendorBankAccount_BankAccountID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 <   DROP SEQUENCE public."VendorBankAccount_BankAccountID_seq";
       public          postgres    false    230                       0    0 #   VendorBankAccount_BankAccountID_seq    SEQUENCE OWNED BY     q   ALTER SEQUENCE public."VendorBankAccount_BankAccountID_seq" OWNED BY public."VendorBankAccount"."BankAccountID";
          public          postgres    false    231            �            1259    70118    VendorContactPerson    TABLE     �  CREATE TABLE public."VendorContactPerson" (
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
       public         heap    postgres    false            �            1259    70124 '   VendorContactPerson_ContactPersonID_seq    SEQUENCE     �   CREATE SEQUENCE public."VendorContactPerson_ContactPersonID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 @   DROP SEQUENCE public."VendorContactPerson_ContactPersonID_seq";
       public          postgres    false    232                       0    0 '   VendorContactPerson_ContactPersonID_seq    SEQUENCE OWNED BY     y   ALTER SEQUENCE public."VendorContactPerson_ContactPersonID_seq" OWNED BY public."VendorContactPerson"."ContactPersonID";
          public          postgres    false    233            �            1259    70126    VendorDistrictMapping    TABLE     �   CREATE TABLE public."VendorDistrictMapping" (
    "VendorID" character varying(255) NOT NULL,
    "DistrictID" character varying(255) NOT NULL,
    "InsertedDate" timestamp with time zone NOT NULL
);
 +   DROP TABLE public."VendorDistrictMapping";
       public         heap    postgres    false            �            1259    70132    VendorMaster    TABLE       CREATE TABLE public."VendorMaster" (
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
    "Password" character varying,
    "Turnover1" character varying,
    "Turnover2" character varying,
    "Turnover3" character varying
);
 "   DROP TABLE public."VendorMaster";
       public         heap    postgres    false            �            1259    70141    VendorPrincipalPlace    TABLE     �  CREATE TABLE public."VendorPrincipalPlace" (
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
       public         heap    postgres    false            �            1259    70147 )   VendorPrincipalPlace_PrincipalPlaceID_seq    SEQUENCE     �   CREATE SEQUENCE public."VendorPrincipalPlace_PrincipalPlaceID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 B   DROP SEQUENCE public."VendorPrincipalPlace_PrincipalPlaceID_seq";
       public          postgres    false    236                       0    0 )   VendorPrincipalPlace_PrincipalPlaceID_seq    SEQUENCE OWNED BY     }   ALTER SEQUENCE public."VendorPrincipalPlace_PrincipalPlaceID_seq" OWNED BY public."VendorPrincipalPlace"."PrincipalPlaceID";
          public          postgres    false    237            �            1259    70149    VendorServices    TABLE     �   CREATE TABLE public."VendorServices" (
    "VendorID" character varying(255) NOT NULL,
    "Service" character varying(255) NOT NULL,
    "InsertedDate" timestamp with time zone NOT NULL,
    "InsertedBy" character varying(255) NOT NULL
);
 $   DROP TABLE public."VendorServices";
       public         heap    postgres    false            �            1259    70155 
   acc_master    TABLE     b  CREATE TABLE public.acc_master (
    acc_name character varying(30),
    acc_id character varying(30) NOT NULL,
    dist_id character varying(2) NOT NULL,
    dist_name character varying(30),
    acc_address character varying(1000),
    acc_mobile_no character varying(15),
    "UpdateOn" timestamp without time zone,
    "UpdateBy" character varying
);
    DROP TABLE public.acc_master;
       public         heap    postgres    false            �            1259    70161    approval_desc_serial_seq    SEQUENCE     �   CREATE SEQUENCE public.approval_desc_serial_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 /   DROP SEQUENCE public.approval_desc_serial_seq;
       public          postgres    false    225                        0    0    approval_desc_serial_seq    SEQUENCE OWNED BY     U   ALTER SEQUENCE public.approval_desc_serial_seq OWNED BY public.approval_desc.serial;
          public          postgres    false    240            �            1259    70163    approval_status_desc    TABLE     ~   CREATE TABLE public.approval_status_desc (
    status_id character varying(50) NOT NULL,
    "desc" character varying(100)
);
 (   DROP TABLE public.approval_status_desc;
       public         heap    postgres    false            �            1259    70166 
   components    TABLE     �   CREATE TABLE public.components (
    comp_id character varying(10) NOT NULL,
    schema_id character varying(10),
    comp_name character varying(30)
);
    DROP TABLE public.components;
       public         heap    postgres    false            �            1259    70169    dept_expenditure_payment_desc    TABLE     �  CREATE TABLE public.dept_expenditure_payment_desc (
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
       public         heap    postgres    false            �            1259    70172    govt_share_config    TABLE     �   CREATE TABLE public.govt_share_config (
    sl integer NOT NULL,
    fin_year character varying(10),
    head character varying(30),
    govt_share_ammount integer
);
 %   DROP TABLE public.govt_share_config;
       public         heap    postgres    false            �            1259    70175    dept_money_config_sl_seq    SEQUENCE     �   CREATE SEQUENCE public.dept_money_config_sl_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 /   DROP SEQUENCE public.dept_money_config_sl_seq;
       public          postgres    false    244            !           0    0    dept_money_config_sl_seq    SEQUENCE OWNED BY     U   ALTER SEQUENCE public.dept_money_config_sl_seq OWNED BY public.govt_share_config.sl;
          public          postgres    false    245            �            1259    70177    dist_dealer_mapping    TABLE     �   CREATE TABLE public.dist_dealer_mapping (
    fin_year character varying(10) NOT NULL,
    dl_id character varying(30) NOT NULL,
    dist_id character varying(2) NOT NULL
);
 '   DROP TABLE public.dist_dealer_mapping;
       public         heap    postgres    false            �            1259    70180    dist_master    TABLE     �   CREATE TABLE public.dist_master (
    dist_id character varying(2) NOT NULL,
    dist_name character varying(20),
    "DistCode" character varying
);
    DROP TABLE public.dist_master;
       public         heap    postgres    false            �            1259    70186    dl_item_map    TABLE     �   CREATE TABLE public.dl_item_map (
    fin_year character varying(10) NOT NULL,
    dl_id character varying(30) NOT NULL,
    implement character varying(50) NOT NULL,
    make character varying(100) NOT NULL,
    model character varying(200)
);
    DROP TABLE public.dl_item_map;
       public         heap    postgres    false            �            1259    70189    dl_item_map_1_old    TABLE     /  CREATE TABLE public.dl_item_map_1_old (
    fin_year character varying(10) NOT NULL,
    dl_id character varying(10) NOT NULL,
    implement character varying(70) NOT NULL,
    make character varying(70) NOT NULL,
    model character varying(70) NOT NULL,
    model_id character varying(70) NOT NULL
);
 %   DROP TABLE public.dl_item_map_1_old;
       public         heap    postgres    false            �            1259    70192 	   dl_master    TABLE     |  CREATE TABLE public.dl_master (
    dl_id character varying(255) NOT NULL,
    dl_name character varying(255),
    bank_name character varying(255),
    dl_ac_no character varying(255),
    dl_mobile_no character varying(255),
    dl_email character varying(255),
    dl_address character varying(255),
    add_date timestamp with time zone,
    modify_date timestamp with time zone,
    dl_ifsc_code character varying(255),
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
    "Password" character varying(255),
    "ApprovalStatus" character varying(255),
    "InsertedDate" timestamp with time zone,
    "InsertedBy" character varying(255),
    "IsDeleted" boolean,
    "ApproveOrRejectDate" timestamp with time zone,
    "ApproveOrRejectBy" character varying(255),
    "WhetherSSIUnit" character varying(255),
    "WhetherMSME" character varying(255),
    "SSIUnitRegistrationCertificate" character varying(255),
    "MSMECertificate" character varying(255),
    "CoreBussinessActivity" character varying(255) NOT NULL
);
    DROP TABLE public.dl_master;
       public         heap    postgres    false            �            1259    70198    dl_master_old    TABLE     �  CREATE TABLE public.dl_master_old (
    dl_id character varying(20) NOT NULL,
    dl_name character varying(70),
    bank_name character varying(100),
    dl_ac_no character varying(30),
    dl_ifsc_code character varying(30),
    dl_mobile_no character varying(20),
    dl_email character varying(100),
    dl_address character varying(200),
    add_date date,
    modify_date date
);
 !   DROP TABLE public.dl_master_old;
       public         heap    postgres    false            �            1259    70205 	   dm_master    TABLE       CREATE TABLE public.dm_master (
    dist_id character varying(2) NOT NULL,
    dist_name character varying(30),
    dm_id character varying(30) NOT NULL,
    dm_name character varying(50),
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
       public         heap    postgres    false            �            1259    70211    farmer_receipt    TABLE     J  CREATE TABLE public.farmer_receipt (
    sl_no integer NOT NULL,
    receipt_no character varying(30) NOT NULL,
    fin_year character varying(10),
    farmer_name character varying(30),
    farmer_id character varying(30),
    full_ammount character varying(30),
    permit_no character varying(50),
    implement character varying(30),
    payment_mode character varying(30),
    payment_no character varying(50),
    source_bank character varying(30),
    date timestamp without time zone,
    dist_id character varying(5),
    office character varying(30),
    payment_date date
);
 "   DROP TABLE public.farmer_receipt;
       public         heap    postgres    false            �            1259    70214    farmer_receipts_sl_no_seq    SEQUENCE     �   CREATE SEQUENCE public.farmer_receipts_sl_no_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 0   DROP SEQUENCE public.farmer_receipts_sl_no_seq;
       public          postgres    false    253            "           0    0    farmer_receipts_sl_no_seq    SEQUENCE OWNED BY     V   ALTER SEQUENCE public.farmer_receipts_sl_no_seq OWNED BY public.farmer_receipt.sl_no;
          public          postgres    false    254            �            1259    70216    head_master    TABLE     u   CREATE TABLE public.head_master (
    head_id character varying(10) NOT NULL,
    head_name character varying(30)
);
    DROP TABLE public.head_master;
       public         heap    postgres    false                        1259    70219 !   jalanidhi_dept_expnd_payment_desc    TABLE     �   CREATE TABLE public.jalanidhi_dept_expnd_payment_desc (
    serial integer NOT NULL,
    transaction_id character varying(50),
    scheme_id character varying(10),
    scheme_name character varying(50),
    comp_id character varying(10)
);
 5   DROP TABLE public.jalanidhi_dept_expnd_payment_desc;
       public         heap    postgres    false                       1259    70222 ,   jalanidhi_dept_expnd_payment_desc_serial_seq    SEQUENCE     �   CREATE SEQUENCE public.jalanidhi_dept_expnd_payment_desc_serial_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 C   DROP SEQUENCE public.jalanidhi_dept_expnd_payment_desc_serial_seq;
       public          postgres    false    256            #           0    0 ,   jalanidhi_dept_expnd_payment_desc_serial_seq    SEQUENCE OWNED BY     }   ALTER SEQUENCE public.jalanidhi_dept_expnd_payment_desc_serial_seq OWNED BY public.jalanidhi_dept_expnd_payment_desc.serial;
          public          postgres    false    257                       1259    70224    jalanidhi_payment_desc    TABLE     N  CREATE TABLE public.jalanidhi_payment_desc (
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
       public         heap    postgres    false                       1259    70227 !   jalanidhi_payment_desc_serial_seq    SEQUENCE     �   CREATE SEQUENCE public.jalanidhi_payment_desc_serial_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 8   DROP SEQUENCE public.jalanidhi_payment_desc_serial_seq;
       public          postgres    false    258            $           0    0 !   jalanidhi_payment_desc_serial_seq    SEQUENCE OWNED BY     g   ALTER SEQUENCE public.jalanidhi_payment_desc_serial_seq OWNED BY public.jalanidhi_payment_desc.serial;
          public          postgres    false    259                       1259    70229    jn_expenditure_desc    TABLE     �   CREATE TABLE public.jn_expenditure_desc (
    transaction_id character varying(70) NOT NULL,
    item_name character varying(50) NOT NULL,
    item_price numeric(10,5) NOT NULL,
    quantity integer NOT NULL,
    serial integer NOT NULL
);
 '   DROP TABLE public.jn_expenditure_desc;
       public         heap    postgres    false                       1259    70232    jn_expenditure_desc_serial_seq    SEQUENCE     �   CREATE SEQUENCE public.jn_expenditure_desc_serial_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 5   DROP SEQUENCE public.jn_expenditure_desc_serial_seq;
       public          postgres    false    260            %           0    0    jn_expenditure_desc_serial_seq    SEQUENCE OWNED BY     a   ALTER SEQUENCE public.jn_expenditure_desc_serial_seq OWNED BY public.jn_expenditure_desc.serial;
          public          postgres    false    261                       1259    70234 	   jn_orders    TABLE     ~  CREATE TABLE public.jn_orders (
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
       public         heap    postgres    false                       1259    70237    jn_stock    TABLE     �  CREATE TABLE public.jn_stock (
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
       public         heap    postgres    false                       1259    70243    lgd_block_master    TABLE     �   CREATE TABLE public.lgd_block_master (
    dist_code character varying(500),
    block_code character varying(20) NOT NULL,
    block_name character varying(200)
);
 $   DROP TABLE public.lgd_block_master;
       public         heap    postgres    false            	           1259    70249    lgd_dist_master    TABLE     |   CREATE TABLE public.lgd_dist_master (
    dist_code character varying(20) NOT NULL,
    dist_name character varying(200)
);
 #   DROP TABLE public.lgd_dist_master;
       public         heap    postgres    false            
           1259    70252    lgd_gp_master    TABLE     �   CREATE TABLE public.lgd_gp_master (
    dist_code character varying(20),
    block_code character varying(20),
    gp_code character varying(20) NOT NULL,
    gp_name character varying(100)
);
 !   DROP TABLE public.lgd_gp_master;
       public         heap    postgres    false                       1259    70255    log    TABLE     �  CREATE TABLE public.log (
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
       public         heap    postgres    false                       1259    70261    log_sl_no_seq    SEQUENCE     �   CREATE SEQUENCE public.log_sl_no_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 $   DROP SEQUENCE public.log_sl_no_seq;
       public          postgres    false    267            &           0    0    log_sl_no_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE public.log_sl_no_seq OWNED BY public.log.sl_no;
          public          postgres    false    268                       1259    70263    mrr    TABLE     g  CREATE TABLE public.mrr (
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
       public         heap    postgres    false                       1259    70266    mrr_sl_no_seq    SEQUENCE     �   CREATE SEQUENCE public.mrr_sl_no_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 $   DROP SEQUENCE public.mrr_sl_no_seq;
       public          postgres    false    269            '           0    0    mrr_sl_no_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE public.mrr_sl_no_seq OWNED BY public.mrr.sl_no;
          public          postgres    false    270                       1259    70268    new_item_price    TABLE     ?  CREATE TABLE public.new_item_price (
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
       public         heap    postgres    false                       1259    70274    opening_balance    TABLE     e  CREATE TABLE public.opening_balance (
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
       public         heap    postgres    false                       1259    70280    payment    TABLE     .  CREATE TABLE public.payment (
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
    system character varying(50)
);
    DROP TABLE public.payment;
       public         heap    postgres    false                       1259    70283    payment1_sl_no_seq    SEQUENCE     �   CREATE SEQUENCE public.payment1_sl_no_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.payment1_sl_no_seq;
       public          postgres    false    273            (           0    0    payment1_sl_no_seq    SEQUENCE OWNED BY     H   ALTER SEQUENCE public.payment1_sl_no_seq OWNED BY public.payment.sl_no;
          public          postgres    false    274                       1259    70285    payment_desc    TABLE     �   CREATE TABLE public.payment_desc (
    transaction_id character varying(70) NOT NULL,
    reference_no character varying(70) NOT NULL
);
     DROP TABLE public.payment_desc;
       public         heap    postgres    false                       1259    70288    payment_desc_2_sl_no_seq    SEQUENCE     �   CREATE SEQUENCE public.payment_desc_2_sl_no_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 /   DROP SEQUENCE public.payment_desc_2_sl_no_seq;
       public          postgres    false    243            )           0    0    payment_desc_2_sl_no_seq    SEQUENCE OWNED BY     d   ALTER SEQUENCE public.payment_desc_2_sl_no_seq OWNED BY public.dept_expenditure_payment_desc.sl_no;
          public          postgres    false    276                       1259    70290    payment_invoice_sl_no_seq    SEQUENCE     �   CREATE SEQUENCE public.payment_invoice_sl_no_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 0   DROP SEQUENCE public.payment_invoice_sl_no_seq;
       public          postgres    false    224            *           0    0    payment_invoice_sl_no_seq    SEQUENCE OWNED BY     P   ALTER SEQUENCE public.payment_invoice_sl_no_seq OWNED BY public.approval.sl_no;
          public          postgres    false    277                       1259    70292    payment_purpose_desc    TABLE        CREATE TABLE public.payment_purpose_desc (
    purpose_id character varying(50) NOT NULL,
    "desc" character varying(100)
);
 (   DROP TABLE public.payment_purpose_desc;
       public         heap    postgres    false                       1259    70295    po_no_increment    SEQUENCE     x   CREATE SEQUENCE public.po_no_increment
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public.po_no_increment;
       public          postgres    false                       1259    70297    schem_master    TABLE     x   CREATE TABLE public.schem_master (
    schem_id character varying(10) NOT NULL,
    schem_name character varying(30)
);
     DROP TABLE public.schem_master;
       public         heap    postgres    false                       1259    70300    source_master    TABLE     {   CREATE TABLE public.source_master (
    source_id character varying(10) NOT NULL,
    source_name character varying(30)
);
 !   DROP TABLE public.source_master;
       public         heap    postgres    false                       1259    70303    subheads    TABLE     �   CREATE TABLE public.subheads (
    subhead_id character varying(10) NOT NULL,
    head_id character varying(10),
    subhead_name character varying(30)
);
    DROP TABLE public.subheads;
       public         heap    postgres    false                       1259    70306    system_desc    TABLE     u   CREATE TABLE public.system_desc (
    system_id character varying(50) NOT NULL,
    "desc" character varying(100)
);
    DROP TABLE public.system_desc;
       public         heap    postgres    false                       1259    70309 
   tax_config    TABLE     r   CREATE TABLE public.tax_config (
    tax_mode character varying(2) NOT NULL,
    "desc" character varying(100)
);
    DROP TABLE public.tax_config;
       public         heap    postgres    false                       1259    70312    users    TABLE     �   CREATE TABLE public.users (
    user_id character varying(225) NOT NULL,
    password character varying(300) NOT NULL,
    role character varying(20) NOT NULL
);
    DROP TABLE public.users;
       public         heap    postgres    false                       1259    70318    vender_master    TABLE     '  CREATE TABLE public.vender_master (
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
       public         heap    postgres    false            v           2604    70324    CustomerBankAccount id    DEFAULT     �   ALTER TABLE ONLY public."CustomerBankAccount" ALTER COLUMN id SET DEFAULT nextval('public."CustomerBankAccount_id_seq"'::regclass);
 G   ALTER TABLE public."CustomerBankAccount" ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    201    200            w           2604    70325    CustomerContactPerson id    DEFAULT     �   ALTER TABLE ONLY public."CustomerContactPerson" ALTER COLUMN id SET DEFAULT nextval('public."CustomerContactPerson_id_seq"'::regclass);
 I   ALTER TABLE public."CustomerContactPerson" ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    203    202            �           2604    70326    CustomerMaster id    DEFAULT     z   ALTER TABLE ONLY public."CustomerMaster" ALTER COLUMN id SET DEFAULT nextval('public."CustomerMaster_id_seq"'::regclass);
 B   ALTER TABLE public."CustomerMaster" ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    211    210            �           2604    70327    CustomerPrincipalPlace id    DEFAULT     �   ALTER TABLE ONLY public."CustomerPrincipalPlace" ALTER COLUMN id SET DEFAULT nextval('public."CustomerPrincipalPlace_id_seq"'::regclass);
 J   ALTER TABLE public."CustomerPrincipalPlace" ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    213    212            �           2604    70328    ItemPackageSizeMaster id    DEFAULT     �   ALTER TABLE ONLY public."ItemPackageSizeMaster" ALTER COLUMN id SET DEFAULT nextval('public."ItemPackageSizeMaster_id_seq"'::regclass);
 I   ALTER TABLE public."ItemPackageSizeMaster" ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    217    216            �           2604    70329    NonSubsidyPODetails id    DEFAULT     �   ALTER TABLE ONLY public."NonSubsidyPODetails" ALTER COLUMN id SET DEFAULT nextval('public."NonSubsidyPODetails_id_seq"'::regclass);
 G   ALTER TABLE public."NonSubsidyPODetails" ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    222    221            �           2604    70330    VendorBankAccount BankAccountID    DEFAULT     �   ALTER TABLE ONLY public."VendorBankAccount" ALTER COLUMN "BankAccountID" SET DEFAULT nextval('public."VendorBankAccount_BankAccountID_seq"'::regclass);
 R   ALTER TABLE public."VendorBankAccount" ALTER COLUMN "BankAccountID" DROP DEFAULT;
       public          postgres    false    231    230            �           2604    70331 #   VendorContactPerson ContactPersonID    DEFAULT     �   ALTER TABLE ONLY public."VendorContactPerson" ALTER COLUMN "ContactPersonID" SET DEFAULT nextval('public."VendorContactPerson_ContactPersonID_seq"'::regclass);
 V   ALTER TABLE public."VendorContactPerson" ALTER COLUMN "ContactPersonID" DROP DEFAULT;
       public          postgres    false    233    232            �           2604    70332 %   VendorPrincipalPlace PrincipalPlaceID    DEFAULT     �   ALTER TABLE ONLY public."VendorPrincipalPlace" ALTER COLUMN "PrincipalPlaceID" SET DEFAULT nextval('public."VendorPrincipalPlace_PrincipalPlaceID_seq"'::regclass);
 X   ALTER TABLE public."VendorPrincipalPlace" ALTER COLUMN "PrincipalPlaceID" DROP DEFAULT;
       public          postgres    false    237    236            �           2604    70333    approval sl_no    DEFAULT     w   ALTER TABLE ONLY public.approval ALTER COLUMN sl_no SET DEFAULT nextval('public.payment_invoice_sl_no_seq'::regclass);
 =   ALTER TABLE public.approval ALTER COLUMN sl_no DROP DEFAULT;
       public          postgres    false    277    224            �           2604    70334    approval_desc serial    DEFAULT     |   ALTER TABLE ONLY public.approval_desc ALTER COLUMN serial SET DEFAULT nextval('public.approval_desc_serial_seq'::regclass);
 C   ALTER TABLE public.approval_desc ALTER COLUMN serial DROP DEFAULT;
       public          postgres    false    240    225            �           2604    70335 #   dept_expenditure_payment_desc sl_no    DEFAULT     �   ALTER TABLE ONLY public.dept_expenditure_payment_desc ALTER COLUMN sl_no SET DEFAULT nextval('public.payment_desc_2_sl_no_seq'::regclass);
 R   ALTER TABLE public.dept_expenditure_payment_desc ALTER COLUMN sl_no DROP DEFAULT;
       public          postgres    false    276    243            �           2604    70336    farmer_receipt sl_no    DEFAULT     }   ALTER TABLE ONLY public.farmer_receipt ALTER COLUMN sl_no SET DEFAULT nextval('public.farmer_receipts_sl_no_seq'::regclass);
 C   ALTER TABLE public.farmer_receipt ALTER COLUMN sl_no DROP DEFAULT;
       public          postgres    false    254    253            �           2604    70337    govt_share_config sl    DEFAULT     |   ALTER TABLE ONLY public.govt_share_config ALTER COLUMN sl SET DEFAULT nextval('public.dept_money_config_sl_seq'::regclass);
 C   ALTER TABLE public.govt_share_config ALTER COLUMN sl DROP DEFAULT;
       public          postgres    false    245    244            �           2604    70338 (   jalanidhi_dept_expnd_payment_desc serial    DEFAULT     �   ALTER TABLE ONLY public.jalanidhi_dept_expnd_payment_desc ALTER COLUMN serial SET DEFAULT nextval('public.jalanidhi_dept_expnd_payment_desc_serial_seq'::regclass);
 W   ALTER TABLE public.jalanidhi_dept_expnd_payment_desc ALTER COLUMN serial DROP DEFAULT;
       public          postgres    false    257    256            �           2604    70339    jalanidhi_payment_desc serial    DEFAULT     �   ALTER TABLE ONLY public.jalanidhi_payment_desc ALTER COLUMN serial SET DEFAULT nextval('public.jalanidhi_payment_desc_serial_seq'::regclass);
 L   ALTER TABLE public.jalanidhi_payment_desc ALTER COLUMN serial DROP DEFAULT;
       public          postgres    false    259    258            �           2604    70340    jn_expenditure_desc serial    DEFAULT     �   ALTER TABLE ONLY public.jn_expenditure_desc ALTER COLUMN serial SET DEFAULT nextval('public.jn_expenditure_desc_serial_seq'::regclass);
 I   ALTER TABLE public.jn_expenditure_desc ALTER COLUMN serial DROP DEFAULT;
       public          postgres    false    261    260            �           2604    70341 	   log sl_no    DEFAULT     f   ALTER TABLE ONLY public.log ALTER COLUMN sl_no SET DEFAULT nextval('public.log_sl_no_seq'::regclass);
 8   ALTER TABLE public.log ALTER COLUMN sl_no DROP DEFAULT;
       public          postgres    false    268    267            �           2604    70342 	   mrr sl_no    DEFAULT     f   ALTER TABLE ONLY public.mrr ALTER COLUMN sl_no SET DEFAULT nextval('public.mrr_sl_no_seq'::regclass);
 8   ALTER TABLE public.mrr ALTER COLUMN sl_no DROP DEFAULT;
       public          postgres    false    270    269            �           2604    70343    payment sl_no    DEFAULT     o   ALTER TABLE ONLY public.payment ALTER COLUMN sl_no SET DEFAULT nextval('public.payment1_sl_no_seq'::regclass);
 <   ALTER TABLE public.payment ALTER COLUMN sl_no DROP DEFAULT;
       public          postgres    false    274    273            �          0    69954    CustomerBankAccount 
   TABLE DATA           �   COPY public."CustomerBankAccount" (id, "CustomerID", "BankAccountID", "bankAccountNo", "accountType", "bankName", "branchName", "ifscCode", "InsertedDate", "InsertedBy", "UpdatedDate", "UpdatedBy") FROM stdin;
    public          postgres    false    200   �      �          0    69962    CustomerContactPerson 
   TABLE DATA           �   COPY public."CustomerContactPerson" (id, "CustomerID", "ContactPersonID", "AuthorisedName", "AuthorisedMobileNo", "AuthorisedEmailID", "Designation", "InsertedDate", "InsertedBy", "UpdatedDate", "UpdatedBy") FROM stdin;
    public          postgres    false    202   �      �          0    69970    CustomerDistrictMapping 
   TABLE DATA           _   COPY public."CustomerDistrictMapping" ("CustomerID", "DistrictID", "InsertedDate") FROM stdin;
    public          postgres    false    204   $      �          0    69976    CustomerInvoiceMaster 
   TABLE DATA             COPY public."CustomerInvoiceMaster" ("CustomerInvoiceNo", "MRRNo", "InvoiceNo", "PONo", "OrderReferenceNo", "POType", "FinYear", "DistrictID", "VendorID", "InvoiceAmount", "NoOfOrderDeliver", "DeliveredQuantity", "InsertedDate", "InsertedBy", "UpdatedDate", "UpdatedBy") FROM stdin;
    public          postgres    false    205   �      �          0    70010    CustomerMaster 
   TABLE DATA           �   COPY public."CustomerMaster" (id, "CustomerID", "LegalCustomerName", "TradeName", "PAN", "BussinessConstitution", "GSTN", "ContactNumber", "EmailID", "InsertedDate", "InsertedBy") FROM stdin;
    public          postgres    false    210   y      �          0    70019    CustomerPrincipalPlace 
   TABLE DATA           �   COPY public."CustomerPrincipalPlace" (id, "CustomerID", "PrincipalPlaceID", "Country", "StateCode", "DistrictOrCity", "Pincode", "Address", "InsertedDate", "InsertedBy", "UpdatedDate", "UpdatedBy") FROM stdin;
    public          postgres    false    212         �          0    69982    DivisionMaster 
   TABLE DATA           H   COPY public."DivisionMaster" ("DivisionID", "DivisionName") FROM stdin;
    public          postgres    false    206   �      �          0    70027    InvoiceMaster 
   TABLE DATA           I  COPY public."InvoiceMaster" ("InvoiceNo", "PONo", "OrderReferenceNo", "WayBillNo", "WayBillDate", "TruckNo", "FinYear", "DistrictID", "VendorID", "Status", "PaymentStatus", "InvoiceAmount", "InvoicePath", "POType", "NoOfOrderInPO", "NoOfOrderDeliver", "InsertedDate", "InsertedBy", "UpdatedDate", "UpdatedBy", "InvoiceDate", "IsReceived", "ReceivedDate", "EngineNumber", "ChassicNumber", "MRRNo", "TotalPurchaseTaxableValue", "TotalPurchaseInvoiceValue", "TotalPurchaseCGST", "TotalPurchaseSGST", "TotalPurchaseIGST", "SupplyQuantity", "SupplyPackageQuantity", "Discount") FROM stdin;
    public          postgres    false    214   �      �          0    70035    ItemPackageMaster 
   TABLE DATA           W  COPY public."ItemPackageMaster" ("DivisionID", "Implement", "Make", "Model", "PackageSize", "UnitOfMeasurement", "PurchaseInvoiceValue", "PurchaseTaxableValue", "PurchaseCGST", "PurchaseSGST", "PurchaseIGST", "SellSGST", "SellIGST", "SellInvoiceValue", "SellTaxableValue", "InsertedDate", "InsertedBy", "UpdatedDate", "UpdatedBy") FROM stdin;
    public          postgres    false    215   �      �          0    70041    ItemPackageSizeMaster 
   TABLE DATA           D   COPY public."ItemPackageSizeMaster" (id, "PackageSize") FROM stdin;
    public          postgres    false    216   w       �          0    70046 	   MRRMaster 
   TABLE DATA             COPY public."MRRMaster" ("MRRNo", "InvoiceNo", "PONo", "OrderReferenceNo", "FinYear", "ItemQuantity", "VendorID", "DistrictID", "DMID", "AccID", "PaymentStatus", "POType", "InsertedDate", "InsertedBy", "UpdatedDate", "UpdatedBy", "MRRAmount", "NoOfItemReceived") FROM stdin;
    public          postgres    false    218   �       �          0    70060    NonSubsidyPODetails 
   TABLE DATA           )  COPY public."NonSubsidyPODetails" (id, "OrderReferenceNo", "PONo", "DivisionID", "Implement", "Make", "Model", "CustomerID", "OrderReferenceNumber", "UnitOfMeasurement", "HSN", "TaxRate", "PurchaseInvoiceValue", "PurchaseTaxableValue", "PurchaseCGST", "PurchaseSGST", "PurchaseIGST", "SellCGST", "SellSGST", "SellIGST", "SellInvoiceValue", "SellTaxableValue", "ItemQuantity", "ItemQuantitySold", "EngineNumber", "ChassicNumber", "IsDelivered", "InsertedDate", "InsertedBy", "UpdatedDate", "UpdatedBy", "IsReceived", "IsDeliveredToCustomer") FROM stdin;
    public          postgres    false    221   �"      �          0    69988    POMaster 
   TABLE DATA           �  COPY public."POMaster" ("FinYear", "PONo", "OrderReferenceNo", "CustomerID", "CustomerOrderRefence", "VendorID", "DistrictID", "DMID", "AccID", "DivisionID", "Implement", "Make", "Model", "UnitOfMeasurement", "HSN", "TaxRate", "PurchaseInvoiceValue", "PurchaseTaxableValue", "PurchaseCGST", "PurchaseSGST", "PurchaseIGST", "TotalPurchaseInvoiceValue", "TotalPurchaseTaxableValue", "TotalPurchaseCGST", "TotalPurchaseSGST", "SellCGST", "SellSGST", "SellIGST", "SellInvoiceValue", "SellTaxableValue", "TotalSellCGST", "TotalSellSGST", "TotalSellIGST", "TotalSellInvoiceValue", "TotalSellTaxableValue", "POAmount", "NoOfItemsInPO", "ItemQuantity", "ItemQuantitySold", "EngineNumber", "ChassicNumber", "IsDelivered", "IsReceived", "IsDeliveredToCustomer", "Status", "InsertedDate", "InsertedBy", "UpdatedDate", "UpdatedBy", "IsApproved", "ApprovalStatus", "ApprovedDate", "ApprovedBy", "IsDeleted", "DeletedDate", "DeletedBy", "IsCancelled", "CancellationStatus", "CancelledDate", "CancelledBy", "POType", "VendorInvoiceNo", "MRRID", "PackageSize", "PackageUnitOfMeasurement", "RatePerUnit", "PackageQuantity", "DeliveredQuantity", "PendingQuantity") FROM stdin;
    public          postgres    false    207   Y$      �          0    70070    StateMaster 
   TABLE DATA           A   COPY public."StateMaster" ("StateCode", "StateName") FROM stdin;
    public          postgres    false    223   �3      �          0    70110    VendorBankAccount 
   TABLE DATA           �   COPY public."VendorBankAccount" ("VendorID", "BankAccountID", "AccountNumber", "AccountType", "BankName", "BranchName", "IFSCCode", "BankDocument", "InsertedDate", "InsertedBy", "UpdatedDate", "UpdatedBy") FROM stdin;
    public          postgres    false    230   �4      �          0    70118    VendorContactPerson 
   TABLE DATA           �   COPY public."VendorContactPerson" ("VendorID", "ContactPersonID", "Name", "FathersName", "MobileNumber", "EmailID", "Designation", "InsertedDate", "InsertedBy") FROM stdin;
    public          postgres    false    232   �6      �          0    70126    VendorDistrictMapping 
   TABLE DATA           [   COPY public."VendorDistrictMapping" ("VendorID", "DistrictID", "InsertedDate") FROM stdin;
    public          postgres    false    234   q8      �          0    70132    VendorMaster 
   TABLE DATA           �  COPY public."VendorMaster" ("VendorID", "LegalBussinessName", "TradeName", "PAN", "PANDocument", "BussinessConstitution", "GSTN", "GSTNDocument", "IncorporationDate", "ContactNumber", "EmailID", "ApprovalStatus", "ApplyStatus", "InsertedDate", "InsertedBy", "IsDeleted", "ApproveOrRejectDate", "ApproveOrRejectBy", "WhetherSSIUnit", "WhetherMSME", "SSIUnitRegistrationCertificate", "MSMECertificate", "CoreBussinessActivity", "Password", "Turnover1", "Turnover2", "Turnover3") FROM stdin;
    public          postgres    false    235   9      �          0    70141    VendorPrincipalPlace 
   TABLE DATA           �   COPY public."VendorPrincipalPlace" ("VendorID", "PrincipalPlaceID", "Country", "StateCode", "DistrictOrCity", "Pincode", "Address", "InsertedDate", "InsertedBy") FROM stdin;
    public          postgres    false    236   �=      �          0    70149    VendorServices 
   TABLE DATA           _   COPY public."VendorServices" ("VendorID", "Service", "InsertedDate", "InsertedBy") FROM stdin;
    public          postgres    false    238   Z?      �          0    70155 
   acc_master 
   TABLE DATA           ~   COPY public.acc_master (acc_name, acc_id, dist_id, dist_name, acc_address, acc_mobile_no, "UpdateOn", "UpdateBy") FROM stdin;
    public          postgres    false    239   >@      �          0    70078    approval 
   TABLE DATA           $  COPY public.approval (sl_no, invoice_no, fin_year, dist_id, dl_id, status, approval_id, indent_no, approval_date, ammount, transaction_id, deduction_amount, pay_now_amount, payment_status, remark, dl_remark, paid_amount, pp_id, pp_status, dm_approved_on, bank_approved_on, items) FROM stdin;
    public          postgres    false    224   �C      �          0    70084    approval_desc 
   TABLE DATA           O   COPY public.approval_desc (approval_id, permit_no, serial, mrr_id) FROM stdin;
    public          postgres    false    225   pI      �          0    70163    approval_status_desc 
   TABLE DATA           A   COPY public.approval_status_desc (status_id, "desc") FROM stdin;
    public          postgres    false    241   �J      �          0    70166 
   components 
   TABLE DATA           C   COPY public.components (comp_id, schema_id, comp_name) FROM stdin;
    public          postgres    false    242   EK      �          0    70169    dept_expenditure_payment_desc 
   TABLE DATA           �   COPY public.dept_expenditure_payment_desc (sl_no, reference_no, transaction_id, source_id, schem_id, comp_id, head_id, subhead_id, head_name, subhead_name, sd_path) FROM stdin;
    public          postgres    false    243   �K      �          0    70177    dist_dealer_mapping 
   TABLE DATA           G   COPY public.dist_dealer_mapping (fin_year, dl_id, dist_id) FROM stdin;
    public          postgres    false    246   O      �          0    70180    dist_master 
   TABLE DATA           E   COPY public.dist_master (dist_id, dist_name, "DistCode") FROM stdin;
    public          postgres    false    247   }O      �          0    70186    dl_item_map 
   TABLE DATA           N   COPY public.dl_item_map (fin_year, dl_id, implement, make, model) FROM stdin;
    public          postgres    false    248   �P      �          0    70189    dl_item_map_1_old 
   TABLE DATA           ^   COPY public.dl_item_map_1_old (fin_year, dl_id, implement, make, model, model_id) FROM stdin;
    public          postgres    false    249   SQ      �          0    70192 	   dl_master 
   TABLE DATA             COPY public.dl_master (dl_id, dl_name, bank_name, dl_ac_no, dl_mobile_no, dl_email, dl_address, add_date, modify_date, dl_ifsc_code, "LegalBussinessName", "TradeName", "PAN", "PANDocument", "BussinessConstitution", "GSTN", "GSTNDocument", "IncorporationDate", "ContactNumber", "EmailID", "Password", "ApprovalStatus", "InsertedDate", "InsertedBy", "IsDeleted", "ApproveOrRejectDate", "ApproveOrRejectBy", "WhetherSSIUnit", "WhetherMSME", "SSIUnitRegistrationCertificate", "MSMECertificate", "CoreBussinessActivity") FROM stdin;
    public          postgres    false    250   ^�      �          0    70198    dl_master_old 
   TABLE DATA           �   COPY public.dl_master_old (dl_id, dl_name, bank_name, dl_ac_no, dl_ifsc_code, dl_mobile_no, dl_email, dl_address, add_date, modify_date) FROM stdin;
    public          postgres    false    251   ��      �          0    70205 	   dm_master 
   TABLE DATA           �   COPY public.dm_master (dist_id, dist_name, dm_id, dm_name, dm_address, dm_mobile_no, "UpdateOn", "UpdateBy", "EmailID", "BankName", "BranchName", "AccountNumber", "IFSCCode") FROM stdin;
    public          postgres    false    252   �      �          0    70211    farmer_receipt 
   TABLE DATA           �   COPY public.farmer_receipt (sl_no, receipt_no, fin_year, farmer_name, farmer_id, full_ammount, permit_no, implement, payment_mode, payment_no, source_bank, date, dist_id, office, payment_date) FROM stdin;
    public          postgres    false    253   ѿ      �          0    70172    govt_share_config 
   TABLE DATA           S   COPY public.govt_share_config (sl, fin_year, head, govt_share_ammount) FROM stdin;
    public          postgres    false    244   ��      �          0    70216    head_master 
   TABLE DATA           9   COPY public.head_master (head_id, head_name) FROM stdin;
    public          postgres    false    255   +�      �          0    70090    item_price_map_1 
   TABLE DATA           r  COPY public.item_price_map_1 ("Implement", "Make", "Model", p_taxable_value, p_cgst_6, p_sgst_6, p_cgst_1, p_sgst_1, p_invoice_value, s_taxable_value, s_cgst_6, s_sgst_6, s_invoice_value, p_igst_12, s_igst_12, add_date, update_date, "InsertedDate", "InsertedBy", "UpdatedDate", "UpdatedBy", "Division", "HSN", "UnitOfMeasurement", "GSTApplicability", "Taxability", "TaxRate", "PurchaseInvoiceValue", "PurchaseTaxableValue", "PurchaseCGST", "PurchaseSGST", "PurchaseIGST", "PurchaseSGSTOnePercent", "PurchaseCGSTOnePercent", "SellCGST", "SellSGST", "SellIGST", "SellInvoiceValue", "SellTaxableValue", "DivisionID") FROM stdin;
    public          postgres    false    226   q�      �          0    70219 !   jalanidhi_dept_expnd_payment_desc 
   TABLE DATA           t   COPY public.jalanidhi_dept_expnd_payment_desc (serial, transaction_id, scheme_id, scheme_name, comp_id) FROM stdin;
    public          postgres    false    256   �      �          0    70224    jalanidhi_payment_desc 
   TABLE DATA           �   COPY public.jalanidhi_payment_desc (transaction_id, farmer_id, farmer_name, implement, make, model, serial, project_id) FROM stdin;
    public          postgres    false    258   |�      �          0    70229    jn_expenditure_desc 
   TABLE DATA           f   COPY public.jn_expenditure_desc (transaction_id, item_name, item_price, quantity, serial) FROM stdin;
    public          postgres    false    260   \�      �          0    70234 	   jn_orders 
   TABLE DATA           {   COPY public.jn_orders (fin_year, dist_id, cluster_id, farmer_id, dist_name, farmer_name, status, date, system) FROM stdin;
    public          postgres    false    262   T�      �          0    70237    jn_stock 
   TABLE DATA           �   COPY public.jn_stock (fin_year, dist_id, dl_id, system, po_no, cluster_id, farmer_id, farmer_name, implement, make, model, engine_no, chassic_no, status, receive_date, deliver_date, dl_name) FROM stdin;
    public          postgres    false    263   �      �          0    70243    lgd_block_master 
   TABLE DATA           M   COPY public.lgd_block_master (dist_code, block_code, block_name) FROM stdin;
    public          postgres    false    264   ��      �          0    70249    lgd_dist_master 
   TABLE DATA           ?   COPY public.lgd_dist_master (dist_code, dist_name) FROM stdin;
    public          postgres    false    265         �          0    70252    lgd_gp_master 
   TABLE DATA           P   COPY public.lgd_gp_master (dist_code, block_code, gp_code, gp_name) FROM stdin;
    public          postgres    false    266         �          0    70255    log 
   TABLE DATA           �   COPY public.log (sl_no, date_time, user_id, action, status, ref_url, route, ip, browser_name, browser_version, fin_year, remark) FROM stdin;
    public          postgres    false    267   m�      �          0    70263    mrr 
   TABLE DATA           v   COPY public.mrr (sl_no, mrr_id, dist_id, invoice_no, fin_year, dl_id, date, items, indent_no, mrr_amount) FROM stdin;
    public          postgres    false    269         �          0    70096    mrr_desc 
   TABLE DATA           5   COPY public.mrr_desc (mrr_id, permit_no) FROM stdin;
    public          postgres    false    227   �                0    70268    new_item_price 
   TABLE DATA           �   COPY public.new_item_price (implement, make, model, purchase_price, taxable_value, cgst_6, sags_6, invoice_alue, selling_price, sl_taxable_value, sl_cgst_6, sl_sgst_6, sl_invoice_value) FROM stdin;
    public          postgres    false    271   U                0    70274    opening_balance 
   TABLE DATA           �   COPY public.opening_balance (fin_year, date, system, dist_id, transaction_id, ammount, remark, purpose, reference_no, "from", "to", head, subhead, payment_type, payment_date, payment_no, test) FROM stdin;
    public          postgres    false    272   *      �          0    70099    orders 
   TABLE DATA           �  COPY public.orders (permit_no, permit_issue_date, permit_validity, farmer_id, farmer_name, farmer_father_name, dist_name, block_name, gp_name, village_name, implement, make, model, status, permit_validity_1, permit_issue_date_1, fin_year, dist_id, engine_no, chassic_no, ammount, remark, expected_delivery_date, delivery_date, c_fin_year, date, system, paid_amount, order_type, "FullCost", "PendingCost") FROM stdin;
    public          postgres    false    228   .                0    70280    payment 
   TABLE DATA           �   COPY public.payment (sl_no, date, reference_no, transaction_id, "from", "to", remark, payment_type, payment_no, fin_year, purpose, payment_date, ammount, status, system) FROM stdin;
    public          postgres    false    273   QL                0    70285    payment_desc 
   TABLE DATA           D   COPY public.payment_desc (transaction_id, reference_no) FROM stdin;
    public          postgres    false    275   �d                0    70292    payment_purpose_desc 
   TABLE DATA           B   COPY public.payment_purpose_desc (purpose_id, "desc") FROM stdin;
    public          postgres    false    278   �d      
          0    70297    schem_master 
   TABLE DATA           <   COPY public.schem_master (schem_id, schem_name) FROM stdin;
    public          postgres    false    280   �e                0    70300    source_master 
   TABLE DATA           ?   COPY public.source_master (source_id, source_name) FROM stdin;
    public          postgres    false    281   �e                0    70303    subheads 
   TABLE DATA           E   COPY public.subheads (subhead_id, head_id, subhead_name) FROM stdin;
    public          postgres    false    282   )f                0    70306    system_desc 
   TABLE DATA           8   COPY public.system_desc (system_id, "desc") FROM stdin;
    public          postgres    false    283   �f                0    70309 
   tax_config 
   TABLE DATA           6   COPY public.tax_config (tax_mode, "desc") FROM stdin;
    public          postgres    false    284   g                0    70312    users 
   TABLE DATA           8   COPY public.users (user_id, password, role) FROM stdin;
    public          postgres    false    285   Dg                0    70318    vender_master 
   TABLE DATA              COPY public.vender_master ("VendorId", "VendorRegNo", "DateOfReg", "Name", "FarmName", "IsVerified", "IsReject", "RejectRemarkStausId", "UserName", "Password", "Type", "IPAddress", "FinancialYear", "UpdatedOn", "UpdatedBy", "DeletedOn", "DeletedBy", "IsUpdated", "IsDeleted") FROM stdin;
    public          postgres    false    286   0t      +           0    0    CustomerBankAccount_id_seq    SEQUENCE SET     J   SELECT pg_catalog.setval('public."CustomerBankAccount_id_seq"', 7, true);
          public          postgres    false    201            ,           0    0    CustomerContactPerson_id_seq    SEQUENCE SET     L   SELECT pg_catalog.setval('public."CustomerContactPerson_id_seq"', 6, true);
          public          postgres    false    203            -           0    0    CustomerMaster_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public."CustomerMaster_id_seq"', 14, true);
          public          postgres    false    211            .           0    0    CustomerPrincipalPlace_id_seq    SEQUENCE SET     M   SELECT pg_catalog.setval('public."CustomerPrincipalPlace_id_seq"', 8, true);
          public          postgres    false    213            /           0    0    ItemPackageSizeMaster_id_seq    SEQUENCE SET     M   SELECT pg_catalog.setval('public."ItemPackageSizeMaster_id_seq"', 19, true);
          public          postgres    false    217            0           0    0    NonSubsidyPODetails_id_seq    SEQUENCE SET     K   SELECT pg_catalog.setval('public."NonSubsidyPODetails_id_seq"', 11, true);
          public          postgres    false    222            1           0    0 #   VendorBankAccount_BankAccountID_seq    SEQUENCE SET     S   SELECT pg_catalog.setval('public."VendorBankAccount_BankAccountID_seq"', 9, true);
          public          postgres    false    231            2           0    0 '   VendorContactPerson_ContactPersonID_seq    SEQUENCE SET     X   SELECT pg_catalog.setval('public."VendorContactPerson_ContactPersonID_seq"', 15, true);
          public          postgres    false    233            3           0    0 )   VendorPrincipalPlace_PrincipalPlaceID_seq    SEQUENCE SET     Z   SELECT pg_catalog.setval('public."VendorPrincipalPlace_PrincipalPlaceID_seq"', 17, true);
          public          postgres    false    237            4           0    0    approval_desc_serial_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('public.approval_desc_serial_seq', 99, true);
          public          postgres    false    240            5           0    0    customer_id_increment    SEQUENCE SET     D   SELECT pg_catalog.setval('public.customer_id_increment', 10, true);
          public          postgres    false    209            6           0    0    dept_money_config_sl_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.dept_money_config_sl_seq', 1, true);
          public          postgres    false    245            7           0    0    farmer_receipts_sl_no_seq    SEQUENCE SET     I   SELECT pg_catalog.setval('public.farmer_receipts_sl_no_seq', 486, true);
          public          postgres    false    254            8           0    0    id_increment    SEQUENCE SET     ;   SELECT pg_catalog.setval('public.id_increment', 13, true);
          public          postgres    false    220            9           0    0 ,   jalanidhi_dept_expnd_payment_desc_serial_seq    SEQUENCE SET     [   SELECT pg_catalog.setval('public.jalanidhi_dept_expnd_payment_desc_serial_seq', 12, true);
          public          postgres    false    257            :           0    0 !   jalanidhi_payment_desc_serial_seq    SEQUENCE SET     P   SELECT pg_catalog.setval('public.jalanidhi_payment_desc_serial_seq', 24, true);
          public          postgres    false    259            ;           0    0    jn_expenditure_desc_serial_seq    SEQUENCE SET     M   SELECT pg_catalog.setval('public.jn_expenditure_desc_serial_seq', 36, true);
          public          postgres    false    261            <           0    0    log_sl_no_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.log_sl_no_seq', 2651, true);
          public          postgres    false    268            =           0    0    mrr_sl_no_seq    SEQUENCE SET     =   SELECT pg_catalog.setval('public.mrr_sl_no_seq', 209, true);
          public          postgres    false    270            >           0    0    payment1_sl_no_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public.payment1_sl_no_seq', 1084, true);
          public          postgres    false    274            ?           0    0    payment_desc_2_sl_no_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('public.payment_desc_2_sl_no_seq', 94, true);
          public          postgres    false    276            @           0    0    payment_invoice_sl_no_seq    SEQUENCE SET     I   SELECT pg_catalog.setval('public.payment_invoice_sl_no_seq', 107, true);
          public          postgres    false    277            A           0    0    po_no_increment    SEQUENCE SET     =   SELECT pg_catalog.setval('public.po_no_increment', 6, true);
          public          postgres    false    279            �           2606    70345 ,   CustomerBankAccount CustomerBankAccount_pkey 
   CONSTRAINT     n   ALTER TABLE ONLY public."CustomerBankAccount"
    ADD CONSTRAINT "CustomerBankAccount_pkey" PRIMARY KEY (id);
 Z   ALTER TABLE ONLY public."CustomerBankAccount" DROP CONSTRAINT "CustomerBankAccount_pkey";
       public            postgres    false    200            �           2606    70347 0   CustomerContactPerson CustomerContactPerson_pkey 
   CONSTRAINT     r   ALTER TABLE ONLY public."CustomerContactPerson"
    ADD CONSTRAINT "CustomerContactPerson_pkey" PRIMARY KEY (id);
 ^   ALTER TABLE ONLY public."CustomerContactPerson" DROP CONSTRAINT "CustomerContactPerson_pkey";
       public            postgres    false    202            �           2606    70349 4   CustomerDistrictMapping CustomerDistrictMapping_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CustomerDistrictMapping"
    ADD CONSTRAINT "CustomerDistrictMapping_pkey" PRIMARY KEY ("CustomerID", "DistrictID");
 b   ALTER TABLE ONLY public."CustomerDistrictMapping" DROP CONSTRAINT "CustomerDistrictMapping_pkey";
       public            postgres    false    204    204            �           2606    70351 0   CustomerInvoiceMaster CustomerInvoiceMaster_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CustomerInvoiceMaster"
    ADD CONSTRAINT "CustomerInvoiceMaster_pkey" PRIMARY KEY ("CustomerInvoiceNo", "MRRNo", "InvoiceNo", "PONo", "OrderReferenceNo");
 ^   ALTER TABLE ONLY public."CustomerInvoiceMaster" DROP CONSTRAINT "CustomerInvoiceMaster_pkey";
       public            postgres    false    205    205    205    205    205            �           2606    70353 "   CustomerMaster CustomerMaster_pkey 
   CONSTRAINT     d   ALTER TABLE ONLY public."CustomerMaster"
    ADD CONSTRAINT "CustomerMaster_pkey" PRIMARY KEY (id);
 P   ALTER TABLE ONLY public."CustomerMaster" DROP CONSTRAINT "CustomerMaster_pkey";
       public            postgres    false    210            �           2606    70355 2   CustomerPrincipalPlace CustomerPrincipalPlace_pkey 
   CONSTRAINT     t   ALTER TABLE ONLY public."CustomerPrincipalPlace"
    ADD CONSTRAINT "CustomerPrincipalPlace_pkey" PRIMARY KEY (id);
 `   ALTER TABLE ONLY public."CustomerPrincipalPlace" DROP CONSTRAINT "CustomerPrincipalPlace_pkey";
       public            postgres    false    212            �           2606    70357 "   DivisionMaster DivisionMaster_pkey 
   CONSTRAINT     n   ALTER TABLE ONLY public."DivisionMaster"
    ADD CONSTRAINT "DivisionMaster_pkey" PRIMARY KEY ("DivisionID");
 P   ALTER TABLE ONLY public."DivisionMaster" DROP CONSTRAINT "DivisionMaster_pkey";
       public            postgres    false    206            �           2606    70359     InvoiceMaster InvoiceMaster_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."InvoiceMaster"
    ADD CONSTRAINT "InvoiceMaster_pkey" PRIMARY KEY ("InvoiceNo", "PONo", "OrderReferenceNo");
 N   ALTER TABLE ONLY public."InvoiceMaster" DROP CONSTRAINT "InvoiceMaster_pkey";
       public            postgres    false    214    214    214            �           2606    70361 (   ItemPackageMaster ItemPackageMaster_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."ItemPackageMaster"
    ADD CONSTRAINT "ItemPackageMaster_pkey" PRIMARY KEY ("DivisionID", "Implement", "Make", "Model", "PackageSize");
 V   ALTER TABLE ONLY public."ItemPackageMaster" DROP CONSTRAINT "ItemPackageMaster_pkey";
       public            postgres    false    215    215    215    215    215            �           2606    70363 0   ItemPackageSizeMaster ItemPackageSizeMaster_pkey 
   CONSTRAINT     r   ALTER TABLE ONLY public."ItemPackageSizeMaster"
    ADD CONSTRAINT "ItemPackageSizeMaster_pkey" PRIMARY KEY (id);
 ^   ALTER TABLE ONLY public."ItemPackageSizeMaster" DROP CONSTRAINT "ItemPackageSizeMaster_pkey";
       public            postgres    false    216            �           2606    70365    MRRMaster MRRMaster_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."MRRMaster"
    ADD CONSTRAINT "MRRMaster_pkey" PRIMARY KEY ("MRRNo", "InvoiceNo", "PONo", "OrderReferenceNo");
 F   ALTER TABLE ONLY public."MRRMaster" DROP CONSTRAINT "MRRMaster_pkey";
       public            postgres    false    218    218    218    218            �           2606    70367 ,   NonSubsidyPODetails NonSubsidyPODetails_pkey 
   CONSTRAINT     n   ALTER TABLE ONLY public."NonSubsidyPODetails"
    ADD CONSTRAINT "NonSubsidyPODetails_pkey" PRIMARY KEY (id);
 Z   ALTER TABLE ONLY public."NonSubsidyPODetails" DROP CONSTRAINT "NonSubsidyPODetails_pkey";
       public            postgres    false    221            �           2606    70369    POMaster POMaster_pkey 
   CONSTRAINT     p   ALTER TABLE ONLY public."POMaster"
    ADD CONSTRAINT "POMaster_pkey" PRIMARY KEY ("PONo", "OrderReferenceNo");
 D   ALTER TABLE ONLY public."POMaster" DROP CONSTRAINT "POMaster_pkey";
       public            postgres    false    207    207            �           2606    70371    StateMaster StateMaster_pkey 
   CONSTRAINT     g   ALTER TABLE ONLY public."StateMaster"
    ADD CONSTRAINT "StateMaster_pkey" PRIMARY KEY ("StateCode");
 J   ALTER TABLE ONLY public."StateMaster" DROP CONSTRAINT "StateMaster_pkey";
       public            postgres    false    223            �           2606    70373 (   VendorBankAccount VendorBankAccount_pkey 
   CONSTRAINT     w   ALTER TABLE ONLY public."VendorBankAccount"
    ADD CONSTRAINT "VendorBankAccount_pkey" PRIMARY KEY ("BankAccountID");
 V   ALTER TABLE ONLY public."VendorBankAccount" DROP CONSTRAINT "VendorBankAccount_pkey";
       public            postgres    false    230            �           2606    70375 ,   VendorContactPerson VendorContactPerson_pkey 
   CONSTRAINT     }   ALTER TABLE ONLY public."VendorContactPerson"
    ADD CONSTRAINT "VendorContactPerson_pkey" PRIMARY KEY ("ContactPersonID");
 Z   ALTER TABLE ONLY public."VendorContactPerson" DROP CONSTRAINT "VendorContactPerson_pkey";
       public            postgres    false    232            �           2606    70377 0   VendorDistrictMapping VendorDistrictMapping_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."VendorDistrictMapping"
    ADD CONSTRAINT "VendorDistrictMapping_pkey" PRIMARY KEY ("VendorID", "DistrictID");
 ^   ALTER TABLE ONLY public."VendorDistrictMapping" DROP CONSTRAINT "VendorDistrictMapping_pkey";
       public            postgres    false    234    234            �           2606    70379    VendorMaster VendorMaster_pkey 
   CONSTRAINT     h   ALTER TABLE ONLY public."VendorMaster"
    ADD CONSTRAINT "VendorMaster_pkey" PRIMARY KEY ("VendorID");
 L   ALTER TABLE ONLY public."VendorMaster" DROP CONSTRAINT "VendorMaster_pkey";
       public            postgres    false    235            �           2606    70381 .   VendorPrincipalPlace VendorPrincipalPlace_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."VendorPrincipalPlace"
    ADD CONSTRAINT "VendorPrincipalPlace_pkey" PRIMARY KEY ("PrincipalPlaceID");
 \   ALTER TABLE ONLY public."VendorPrincipalPlace" DROP CONSTRAINT "VendorPrincipalPlace_pkey";
       public            postgres    false    236            �           2606    70383 "   VendorServices VendorServices_pkey 
   CONSTRAINT     w   ALTER TABLE ONLY public."VendorServices"
    ADD CONSTRAINT "VendorServices_pkey" PRIMARY KEY ("VendorID", "Service");
 P   ALTER TABLE ONLY public."VendorServices" DROP CONSTRAINT "VendorServices_pkey";
       public            postgres    false    238    238            �           2606    70385 "   acc_master accountants_master_pkey 
   CONSTRAINT     m   ALTER TABLE ONLY public.acc_master
    ADD CONSTRAINT accountants_master_pkey PRIMARY KEY (acc_id, dist_id);
 L   ALTER TABLE ONLY public.acc_master DROP CONSTRAINT accountants_master_pkey;
       public            postgres    false    239    239            �           2606    70387     approval_desc approval_desc_pkey 
   CONSTRAINT     b   ALTER TABLE ONLY public.approval_desc
    ADD CONSTRAINT approval_desc_pkey PRIMARY KEY (serial);
 J   ALTER TABLE ONLY public.approval_desc DROP CONSTRAINT approval_desc_pkey;
       public            postgres    false    225            �           2606    70389 .   approval_status_desc approval_status_desc_pkey 
   CONSTRAINT     s   ALTER TABLE ONLY public.approval_status_desc
    ADD CONSTRAINT approval_status_desc_pkey PRIMARY KEY (status_id);
 X   ALTER TABLE ONLY public.approval_status_desc DROP CONSTRAINT approval_status_desc_pkey;
       public            postgres    false    241            �           2606    70391    components components_pkey 
   CONSTRAINT     ]   ALTER TABLE ONLY public.components
    ADD CONSTRAINT components_pkey PRIMARY KEY (comp_id);
 D   ALTER TABLE ONLY public.components DROP CONSTRAINT components_pkey;
       public            postgres    false    242            �           2606    70393 (   govt_share_config dept_money_config_pkey 
   CONSTRAINT     f   ALTER TABLE ONLY public.govt_share_config
    ADD CONSTRAINT dept_money_config_pkey PRIMARY KEY (sl);
 R   ALTER TABLE ONLY public.govt_share_config DROP CONSTRAINT dept_money_config_pkey;
       public            postgres    false    244            �           2606    70395 &   dist_dealer_mapping dist_dl_map_1_pkey 
   CONSTRAINT     z   ALTER TABLE ONLY public.dist_dealer_mapping
    ADD CONSTRAINT dist_dl_map_1_pkey PRIMARY KEY (fin_year, dl_id, dist_id);
 P   ALTER TABLE ONLY public.dist_dealer_mapping DROP CONSTRAINT dist_dl_map_1_pkey;
       public            postgres    false    246    246    246            �           2606    70397    dist_master dist_master_1_pkey 
   CONSTRAINT     a   ALTER TABLE ONLY public.dist_master
    ADD CONSTRAINT dist_master_1_pkey PRIMARY KEY (dist_id);
 H   ALTER TABLE ONLY public.dist_master DROP CONSTRAINT dist_master_1_pkey;
       public            postgres    false    247            �           2606    70399 $   dl_item_map_1_old dl_item_map_1_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.dl_item_map_1_old
    ADD CONSTRAINT dl_item_map_1_pkey PRIMARY KEY (fin_year, dl_id, implement, make, model, model_id);
 N   ALTER TABLE ONLY public.dl_item_map_1_old DROP CONSTRAINT dl_item_map_1_pkey;
       public            postgres    false    249    249    249    249    249    249            �           2606    70401    dl_item_map dl_item_map_2_pkey 
   CONSTRAINT     z   ALTER TABLE ONLY public.dl_item_map
    ADD CONSTRAINT dl_item_map_2_pkey PRIMARY KEY (fin_year, dl_id, implement, make);
 H   ALTER TABLE ONLY public.dl_item_map DROP CONSTRAINT dl_item_map_2_pkey;
       public            postgres    false    248    248    248    248            �           2606    70403    dl_master_old dl_master_1_pkey 
   CONSTRAINT     _   ALTER TABLE ONLY public.dl_master_old
    ADD CONSTRAINT dl_master_1_pkey PRIMARY KEY (dl_id);
 H   ALTER TABLE ONLY public.dl_master_old DROP CONSTRAINT dl_master_1_pkey;
       public            postgres    false    251            �           2606    70405    dl_master dl_master_pkey 
   CONSTRAINT     Y   ALTER TABLE ONLY public.dl_master
    ADD CONSTRAINT dl_master_pkey PRIMARY KEY (dl_id);
 B   ALTER TABLE ONLY public.dl_master DROP CONSTRAINT dl_master_pkey;
       public            postgres    false    250            �           2606    70407    dm_master dm_master_pkey 
   CONSTRAINT     Y   ALTER TABLE ONLY public.dm_master
    ADD CONSTRAINT dm_master_pkey PRIMARY KEY (dm_id);
 B   ALTER TABLE ONLY public.dm_master DROP CONSTRAINT dm_master_pkey;
       public            postgres    false    252            �           2606    70409 #   farmer_receipt farmer_receipts_pkey 
   CONSTRAINT     i   ALTER TABLE ONLY public.farmer_receipt
    ADD CONSTRAINT farmer_receipts_pkey PRIMARY KEY (receipt_no);
 M   ALTER TABLE ONLY public.farmer_receipt DROP CONSTRAINT farmer_receipts_pkey;
       public            postgres    false    253            �           2606    70411    head_master head_master_pkey 
   CONSTRAINT     _   ALTER TABLE ONLY public.head_master
    ADD CONSTRAINT head_master_pkey PRIMARY KEY (head_id);
 F   ALTER TABLE ONLY public.head_master DROP CONSTRAINT head_master_pkey;
       public            postgres    false    255            �           2606    70413 '   item_price_map_1 item_price_map_1_pkey1 
   CONSTRAINT        ALTER TABLE ONLY public.item_price_map_1
    ADD CONSTRAINT item_price_map_1_pkey1 PRIMARY KEY ("Implement", "Make", "Model");
 Q   ALTER TABLE ONLY public.item_price_map_1 DROP CONSTRAINT item_price_map_1_pkey1;
       public            postgres    false    226    226    226            �           2606    70415 H   jalanidhi_dept_expnd_payment_desc jalanidhi_dept_expnd_payment_desc_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.jalanidhi_dept_expnd_payment_desc
    ADD CONSTRAINT jalanidhi_dept_expnd_payment_desc_pkey PRIMARY KEY (serial);
 r   ALTER TABLE ONLY public.jalanidhi_dept_expnd_payment_desc DROP CONSTRAINT jalanidhi_dept_expnd_payment_desc_pkey;
       public            postgres    false    256            �           2606    70417 2   jalanidhi_payment_desc jalanidhi_payment_desc_pkey 
   CONSTRAINT     t   ALTER TABLE ONLY public.jalanidhi_payment_desc
    ADD CONSTRAINT jalanidhi_payment_desc_pkey PRIMARY KEY (serial);
 \   ALTER TABLE ONLY public.jalanidhi_payment_desc DROP CONSTRAINT jalanidhi_payment_desc_pkey;
       public            postgres    false    258            �           2606    70419 ,   jn_expenditure_desc jn_expenditure_desc_pkey 
   CONSTRAINT     n   ALTER TABLE ONLY public.jn_expenditure_desc
    ADD CONSTRAINT jn_expenditure_desc_pkey PRIMARY KEY (serial);
 V   ALTER TABLE ONLY public.jn_expenditure_desc DROP CONSTRAINT jn_expenditure_desc_pkey;
       public            postgres    false    260            �           2606    70421    jn_orders jn_orders_pkey 
   CONSTRAINT     i   ALTER TABLE ONLY public.jn_orders
    ADD CONSTRAINT jn_orders_pkey PRIMARY KEY (cluster_id, farmer_id);
 B   ALTER TABLE ONLY public.jn_orders DROP CONSTRAINT jn_orders_pkey;
       public            postgres    false    262    262            �           2606    70423    jn_stock jn_stock_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.jn_stock
    ADD CONSTRAINT jn_stock_pkey PRIMARY KEY (po_no, cluster_id, farmer_id, implement, make, model);
 @   ALTER TABLE ONLY public.jn_stock DROP CONSTRAINT jn_stock_pkey;
       public            postgres    false    263    263    263    263    263    263            �           2606    70425 &   lgd_block_master lgd_block_master_pkey 
   CONSTRAINT     l   ALTER TABLE ONLY public.lgd_block_master
    ADD CONSTRAINT lgd_block_master_pkey PRIMARY KEY (block_code);
 P   ALTER TABLE ONLY public.lgd_block_master DROP CONSTRAINT lgd_block_master_pkey;
       public            postgres    false    264            �           2606    70427 $   lgd_dist_master lgd_dist_master_pkey 
   CONSTRAINT     i   ALTER TABLE ONLY public.lgd_dist_master
    ADD CONSTRAINT lgd_dist_master_pkey PRIMARY KEY (dist_code);
 N   ALTER TABLE ONLY public.lgd_dist_master DROP CONSTRAINT lgd_dist_master_pkey;
       public            postgres    false    265            �           2606    70429     lgd_gp_master lgd_gp_master_pkey 
   CONSTRAINT     c   ALTER TABLE ONLY public.lgd_gp_master
    ADD CONSTRAINT lgd_gp_master_pkey PRIMARY KEY (gp_code);
 J   ALTER TABLE ONLY public.lgd_gp_master DROP CONSTRAINT lgd_gp_master_pkey;
       public            postgres    false    266            �           2606    70431    log log_pkey 
   CONSTRAINT     M   ALTER TABLE ONLY public.log
    ADD CONSTRAINT log_pkey PRIMARY KEY (sl_no);
 6   ALTER TABLE ONLY public.log DROP CONSTRAINT log_pkey;
       public            postgres    false    267            �           2606    70433    mrr_desc mrr_desc_pkey 
   CONSTRAINT     c   ALTER TABLE ONLY public.mrr_desc
    ADD CONSTRAINT mrr_desc_pkey PRIMARY KEY (mrr_id, permit_no);
 @   ALTER TABLE ONLY public.mrr_desc DROP CONSTRAINT mrr_desc_pkey;
       public            postgres    false    227    227            �           2606    70435    mrr mrr_pkey 
   CONSTRAINT     N   ALTER TABLE ONLY public.mrr
    ADD CONSTRAINT mrr_pkey PRIMARY KEY (mrr_id);
 6   ALTER TABLE ONLY public.mrr DROP CONSTRAINT mrr_pkey;
       public            postgres    false    269            �           2606    70437 "   new_item_price new_item_price_pkey 
   CONSTRAINT     t   ALTER TABLE ONLY public.new_item_price
    ADD CONSTRAINT new_item_price_pkey PRIMARY KEY (implement, make, model);
 L   ALTER TABLE ONLY public.new_item_price DROP CONSTRAINT new_item_price_pkey;
       public            postgres    false    271    271    271                       2606    70439 $   opening_balance opening_balance_pkey 
   CONSTRAINT     n   ALTER TABLE ONLY public.opening_balance
    ADD CONSTRAINT opening_balance_pkey PRIMARY KEY (transaction_id);
 N   ALTER TABLE ONLY public.opening_balance DROP CONSTRAINT opening_balance_pkey;
       public            postgres    false    272            �           2606    70441    orders orders_pkey 
   CONSTRAINT     W   ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (permit_no);
 <   ALTER TABLE ONLY public.orders DROP CONSTRAINT orders_pkey;
       public            postgres    false    228                       2606    70443    payment payment1_pkey 
   CONSTRAINT     _   ALTER TABLE ONLY public.payment
    ADD CONSTRAINT payment1_pkey PRIMARY KEY (transaction_id);
 ?   ALTER TABLE ONLY public.payment DROP CONSTRAINT payment1_pkey;
       public            postgres    false    273            �           2606    70445 1   dept_expenditure_payment_desc payment_desc_2_pkey 
   CONSTRAINT     r   ALTER TABLE ONLY public.dept_expenditure_payment_desc
    ADD CONSTRAINT payment_desc_2_pkey PRIMARY KEY (sl_no);
 [   ALTER TABLE ONLY public.dept_expenditure_payment_desc DROP CONSTRAINT payment_desc_2_pkey;
       public            postgres    false    243                       2606    70447    payment_desc payment_desc_pkey 
   CONSTRAINT     v   ALTER TABLE ONLY public.payment_desc
    ADD CONSTRAINT payment_desc_pkey PRIMARY KEY (reference_no, transaction_id);
 H   ALTER TABLE ONLY public.payment_desc DROP CONSTRAINT payment_desc_pkey;
       public            postgres    false    275    275            �           2606    70449 !   approval payment_instruction_pkey 
   CONSTRAINT     b   ALTER TABLE ONLY public.approval
    ADD CONSTRAINT payment_instruction_pkey PRIMARY KEY (sl_no);
 K   ALTER TABLE ONLY public.approval DROP CONSTRAINT payment_instruction_pkey;
       public            postgres    false    224                       2606    70451 .   payment_purpose_desc payment_purpose_desc_pkey 
   CONSTRAINT     t   ALTER TABLE ONLY public.payment_purpose_desc
    ADD CONSTRAINT payment_purpose_desc_pkey PRIMARY KEY (purpose_id);
 X   ALTER TABLE ONLY public.payment_purpose_desc DROP CONSTRAINT payment_purpose_desc_pkey;
       public            postgres    false    278            	           2606    70453    schem_master schema_master_pkey 
   CONSTRAINT     c   ALTER TABLE ONLY public.schem_master
    ADD CONSTRAINT schema_master_pkey PRIMARY KEY (schem_id);
 I   ALTER TABLE ONLY public.schem_master DROP CONSTRAINT schema_master_pkey;
       public            postgres    false    280                       2606    70455     source_master source_master_pkey 
   CONSTRAINT     e   ALTER TABLE ONLY public.source_master
    ADD CONSTRAINT source_master_pkey PRIMARY KEY (source_id);
 J   ALTER TABLE ONLY public.source_master DROP CONSTRAINT source_master_pkey;
       public            postgres    false    281                       2606    70457    subheads subhead_pkey 
   CONSTRAINT     [   ALTER TABLE ONLY public.subheads
    ADD CONSTRAINT subhead_pkey PRIMARY KEY (subhead_id);
 ?   ALTER TABLE ONLY public.subheads DROP CONSTRAINT subhead_pkey;
       public            postgres    false    282                       2606    70459    system_desc system_desc_pkey 
   CONSTRAINT     a   ALTER TABLE ONLY public.system_desc
    ADD CONSTRAINT system_desc_pkey PRIMARY KEY (system_id);
 F   ALTER TABLE ONLY public.system_desc DROP CONSTRAINT system_desc_pkey;
       public            postgres    false    283                       2606    70461    tax_config tax_config_pkey 
   CONSTRAINT     ^   ALTER TABLE ONLY public.tax_config
    ADD CONSTRAINT tax_config_pkey PRIMARY KEY (tax_mode);
 D   ALTER TABLE ONLY public.tax_config DROP CONSTRAINT tax_config_pkey;
       public            postgres    false    284                       2606    70463    users users_pkey 
   CONSTRAINT     S   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (user_id);
 :   ALTER TABLE ONLY public.users DROP CONSTRAINT users_pkey;
       public            postgres    false    285                       2606    70465     vender_master vender_master_pkey 
   CONSTRAINT     f   ALTER TABLE ONLY public.vender_master
    ADD CONSTRAINT vender_master_pkey PRIMARY KEY ("VendorId");
 J   ALTER TABLE ONLY public.vender_master DROP CONSTRAINT vender_master_pkey;
       public            postgres    false    286            0           2620    70466    POMaster po_no    TRIGGER     m   CREATE TRIGGER po_no BEFORE INSERT ON public."POMaster" FOR EACH ROW EXECUTE FUNCTION public.create_po_no();
 )   DROP TRIGGER po_no ON public."POMaster";
       public          postgres    false    207    290            1           2620    70467     POMaster updateDeliveredQuantity    TRIGGER     �   CREATE TRIGGER "updateDeliveredQuantity" BEFORE UPDATE ON public."POMaster" FOR EACH ROW EXECUTE FUNCTION public."UpdateDeliveredQuantity"();
 =   DROP TRIGGER "updateDeliveredQuantity" ON public."POMaster";
       public          postgres    false    207    289            3           2620    70468    InvoiceMaster update_invoice_no    TRIGGER     �   CREATE TRIGGER update_invoice_no AFTER INSERT ON public."InvoiceMaster" FOR EACH ROW EXECUTE FUNCTION public.update_invoice_number();
 :   DROP TRIGGER update_invoice_no ON public."InvoiceMaster";
       public          postgres    false    214    291            4           2620    70469    MRRMaster update_mrr_id    TRIGGER     v   CREATE TRIGGER update_mrr_id AFTER INSERT ON public."MRRMaster" FOR EACH ROW EXECUTE FUNCTION public.update_mrr_id();
 2   DROP TRIGGER update_mrr_id ON public."MRRMaster";
       public          postgres    false    218    292            6           2620    70470    mrr update_mrr_id    TRIGGER     n   CREATE TRIGGER update_mrr_id AFTER INSERT ON public.mrr FOR EACH ROW EXECUTE FUNCTION public.update_mrr_id();
 *   DROP TRIGGER update_mrr_id ON public.mrr;
       public          postgres    false    292    269            2           2620    70471    POMaster update_order    TRIGGER     ~   CREATE TRIGGER update_order AFTER INSERT ON public."POMaster" FOR EACH ROW EXECUTE FUNCTION public.update_order_po_intiate();
 0   DROP TRIGGER update_order ON public."POMaster";
       public          postgres    false    293    207            5           2620    70472 (   dm_master updateaccountantaddresstrigger    TRIGGER     �   CREATE TRIGGER updateaccountantaddresstrigger AFTER UPDATE ON public.dm_master FOR EACH ROW EXECUTE FUNCTION public."UpdateAccountantAddress"();
 A   DROP TRIGGER updateaccountantaddresstrigger ON public.dm_master;
       public          postgres    false    252    288                       2606    70473 ?   CustomerDistrictMapping CustomerDistrictMapping_DistrictID_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."CustomerDistrictMapping"
    ADD CONSTRAINT "CustomerDistrictMapping_DistrictID_fkey" FOREIGN KEY ("DistrictID") REFERENCES public.dist_master(dist_id) ON UPDATE CASCADE;
 m   ALTER TABLE ONLY public."CustomerDistrictMapping" DROP CONSTRAINT "CustomerDistrictMapping_DistrictID_fkey";
       public          postgres    false    204    247    3291                       2606    70478 <   CustomerPrincipalPlace CustomerPrincipalPlace_StateCode_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."CustomerPrincipalPlace"
    ADD CONSTRAINT "CustomerPrincipalPlace_StateCode_fkey" FOREIGN KEY ("StateCode") REFERENCES public."StateMaster"("StateCode") ON UPDATE CASCADE ON DELETE SET NULL;
 j   ALTER TABLE ONLY public."CustomerPrincipalPlace" DROP CONSTRAINT "CustomerPrincipalPlace_StateCode_fkey";
       public          postgres    false    223    212    3255            "           2606    70483    acc_master DISTID_F_KEY    FK CONSTRAINT     �   ALTER TABLE ONLY public.acc_master
    ADD CONSTRAINT "DISTID_F_KEY" FOREIGN KEY (dist_id) REFERENCES public.dist_master(dist_id) NOT VALID;
 C   ALTER TABLE ONLY public.acc_master DROP CONSTRAINT "DISTID_F_KEY";
       public          postgres    false    3291    239    247            '           2606    70488    dm_master DIST_ID_F_KEY    FK CONSTRAINT     �   ALTER TABLE ONLY public.dm_master
    ADD CONSTRAINT "DIST_ID_F_KEY" FOREIGN KEY (dist_id) REFERENCES public.dist_master(dist_id) NOT VALID;
 C   ALTER TABLE ONLY public.dm_master DROP CONSTRAINT "DIST_ID_F_KEY";
       public          postgres    false    252    3291    247            (           2606    70493    dm_master UPDATEBY_USERID_F_KEY    FK CONSTRAINT     �   ALTER TABLE ONLY public.dm_master
    ADD CONSTRAINT "UPDATEBY_USERID_F_KEY" FOREIGN KEY ("UpdateBy") REFERENCES public.users(user_id) NOT VALID;
 K   ALTER TABLE ONLY public.dm_master DROP CONSTRAINT "UPDATEBY_USERID_F_KEY";
       public          postgres    false    3347    285    252            #           2606    70498     acc_master UpdateBy_UserId_F_KEY    FK CONSTRAINT     �   ALTER TABLE ONLY public.acc_master
    ADD CONSTRAINT "UpdateBy_UserId_F_KEY" FOREIGN KEY ("UpdateBy") REFERENCES public.users(user_id) NOT VALID;
 L   ALTER TABLE ONLY public.acc_master DROP CONSTRAINT "UpdateBy_UserId_F_KEY";
       public          postgres    false    285    3347    239                       2606    70503 1   VendorBankAccount VendorBankAccount_VendorID_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."VendorBankAccount"
    ADD CONSTRAINT "VendorBankAccount_VendorID_fkey" FOREIGN KEY ("VendorID") REFERENCES public."VendorMaster"("VendorID") ON UPDATE CASCADE;
 _   ALTER TABLE ONLY public."VendorBankAccount" DROP CONSTRAINT "VendorBankAccount_VendorID_fkey";
       public          postgres    false    3273    230    235                       2606    70508 5   VendorContactPerson VendorContactPerson_VendorID_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."VendorContactPerson"
    ADD CONSTRAINT "VendorContactPerson_VendorID_fkey" FOREIGN KEY ("VendorID") REFERENCES public."VendorMaster"("VendorID") ON UPDATE CASCADE;
 c   ALTER TABLE ONLY public."VendorContactPerson" DROP CONSTRAINT "VendorContactPerson_VendorID_fkey";
       public          postgres    false    3273    232    235                       2606    70513 ;   VendorDistrictMapping VendorDistrictMapping_DistrictID_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."VendorDistrictMapping"
    ADD CONSTRAINT "VendorDistrictMapping_DistrictID_fkey" FOREIGN KEY ("DistrictID") REFERENCES public.dist_master(dist_id) ON UPDATE CASCADE;
 i   ALTER TABLE ONLY public."VendorDistrictMapping" DROP CONSTRAINT "VendorDistrictMapping_DistrictID_fkey";
       public          postgres    false    247    3291    234                       2606    70518 9   VendorDistrictMapping VendorDistrictMapping_VendorID_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."VendorDistrictMapping"
    ADD CONSTRAINT "VendorDistrictMapping_VendorID_fkey" FOREIGN KEY ("VendorID") REFERENCES public."VendorMaster"("VendorID") ON UPDATE CASCADE;
 g   ALTER TABLE ONLY public."VendorDistrictMapping" DROP CONSTRAINT "VendorDistrictMapping_VendorID_fkey";
       public          postgres    false    235    234    3273                       2606    70523 8   VendorPrincipalPlace VendorPrincipalPlace_StateCode_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."VendorPrincipalPlace"
    ADD CONSTRAINT "VendorPrincipalPlace_StateCode_fkey" FOREIGN KEY ("StateCode") REFERENCES public."StateMaster"("StateCode") ON UPDATE CASCADE;
 f   ALTER TABLE ONLY public."VendorPrincipalPlace" DROP CONSTRAINT "VendorPrincipalPlace_StateCode_fkey";
       public          postgres    false    236    223    3255                        2606    70528 7   VendorPrincipalPlace VendorPrincipalPlace_VendorID_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."VendorPrincipalPlace"
    ADD CONSTRAINT "VendorPrincipalPlace_VendorID_fkey" FOREIGN KEY ("VendorID") REFERENCES public."VendorMaster"("VendorID") ON UPDATE CASCADE;
 e   ALTER TABLE ONLY public."VendorPrincipalPlace" DROP CONSTRAINT "VendorPrincipalPlace_VendorID_fkey";
       public          postgres    false    3273    236    235            !           2606    70533 +   VendorServices VendorServices_VendorID_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."VendorServices"
    ADD CONSTRAINT "VendorServices_VendorID_fkey" FOREIGN KEY ("VendorID") REFERENCES public."VendorMaster"("VendorID") ON UPDATE CASCADE;
 Y   ALTER TABLE ONLY public."VendorServices" DROP CONSTRAINT "VendorServices_VendorID_fkey";
       public          postgres    false    238    3273    235                       2606    70538    approval approval_status_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.approval
    ADD CONSTRAINT approval_status_fkey FOREIGN KEY (status) REFERENCES public.approval_status_desc(status_id) NOT VALID;
 G   ALTER TABLE ONLY public.approval DROP CONSTRAINT approval_status_fkey;
       public          postgres    false    224    3281    241            +           2606    70543    lgd_gp_master block_master    FK CONSTRAINT     �   ALTER TABLE ONLY public.lgd_gp_master
    ADD CONSTRAINT block_master FOREIGN KEY (block_code) REFERENCES public.lgd_block_master(block_code) NOT VALID;
 D   ALTER TABLE ONLY public.lgd_gp_master DROP CONSTRAINT block_master;
       public          postgres    false    266    3317    264            $           2606    70548    dist_dealer_mapping dist_id    FK CONSTRAINT     �   ALTER TABLE ONLY public.dist_dealer_mapping
    ADD CONSTRAINT dist_id FOREIGN KEY (dist_id) REFERENCES public.dist_master(dist_id) NOT VALID;
 E   ALTER TABLE ONLY public.dist_dealer_mapping DROP CONSTRAINT dist_id;
       public          postgres    false    246    3291    247            ,           2606    70553    lgd_gp_master dist_master    FK CONSTRAINT     �   ALTER TABLE ONLY public.lgd_gp_master
    ADD CONSTRAINT dist_master FOREIGN KEY (dist_code) REFERENCES public.lgd_dist_master(dist_code) NOT VALID;
 C   ALTER TABLE ONLY public.lgd_gp_master DROP CONSTRAINT dist_master;
       public          postgres    false    266    265    3319            *           2606    70558    lgd_block_master dist_master    FK CONSTRAINT     �   ALTER TABLE ONLY public.lgd_block_master
    ADD CONSTRAINT dist_master FOREIGN KEY (dist_code) REFERENCES public.lgd_dist_master(dist_code) NOT VALID;
 F   ALTER TABLE ONLY public.lgd_block_master DROP CONSTRAINT dist_master;
       public          postgres    false    265    264    3319            %           2606    70563    dist_dealer_mapping dl_id    FK CONSTRAINT     �   ALTER TABLE ONLY public.dist_dealer_mapping
    ADD CONSTRAINT dl_id FOREIGN KEY (dl_id) REFERENCES public.dl_master_old(dl_id) NOT VALID;
 C   ALTER TABLE ONLY public.dist_dealer_mapping DROP CONSTRAINT dl_id;
       public          postgres    false    3299    246    251            &           2606    70568 $   dl_item_map dl_item_map_2_dl_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.dl_item_map
    ADD CONSTRAINT dl_item_map_2_dl_id_fkey FOREIGN KEY (dl_id) REFERENCES public.dl_master_old(dl_id) NOT VALID;
 N   ALTER TABLE ONLY public.dl_item_map DROP CONSTRAINT dl_item_map_2_dl_id_fkey;
       public          postgres    false    3299    248    251            )           2606    70573 +   jn_stock jn_stock_cluster_id_farmer_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.jn_stock
    ADD CONSTRAINT jn_stock_cluster_id_farmer_id_fkey FOREIGN KEY (cluster_id, farmer_id) REFERENCES public.jn_orders(cluster_id, farmer_id) NOT VALID;
 U   ALTER TABLE ONLY public.jn_stock DROP CONSTRAINT jn_stock_cluster_id_farmer_id_fkey;
       public          postgres    false    262    262    3313    263    263                       2606    70578    mrr_desc mrr_desc_mrr_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.mrr_desc
    ADD CONSTRAINT mrr_desc_mrr_id_fkey FOREIGN KEY (mrr_id) REFERENCES public.mrr(mrr_id) NOT VALID;
 G   ALTER TABLE ONLY public.mrr_desc DROP CONSTRAINT mrr_desc_mrr_id_fkey;
       public          postgres    false    3325    227    269                       2606    70583     mrr_desc mrr_desc_permit_no_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.mrr_desc
    ADD CONSTRAINT mrr_desc_permit_no_fkey FOREIGN KEY (permit_no) REFERENCES public.orders(permit_no) NOT VALID;
 J   ALTER TABLE ONLY public.mrr_desc DROP CONSTRAINT mrr_desc_permit_no_fkey;
       public          postgres    false    3265    228    227            -           2606    70588    mrr mrr_dist_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.mrr
    ADD CONSTRAINT mrr_dist_id_fkey FOREIGN KEY (dist_id) REFERENCES public.dist_master(dist_id) NOT VALID;
 >   ALTER TABLE ONLY public.mrr DROP CONSTRAINT mrr_dist_id_fkey;
       public          postgres    false    247    269    3291            .           2606    70593 ,   opening_balance opening_balance_dist_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.opening_balance
    ADD CONSTRAINT opening_balance_dist_id_fkey FOREIGN KEY (dist_id) REFERENCES public.dist_master(dist_id);
 V   ALTER TABLE ONLY public.opening_balance DROP CONSTRAINT opening_balance_dist_id_fkey;
       public          postgres    false    272    247    3291            /           2606    70598 -   payment_desc payment_desc_transaction_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.payment_desc
    ADD CONSTRAINT payment_desc_transaction_id_fkey FOREIGN KEY (transaction_id) REFERENCES public.payment(transaction_id) NOT VALID;
 W   ALTER TABLE ONLY public.payment_desc DROP CONSTRAINT payment_desc_transaction_id_fkey;
       public          postgres    false    273    275    3331            �   �   x��ͻ
�0 ���ً!���f�v)�.��%ؗU�п��Vp�r>��P�	m��RPM�_m e׹��Lx���H����dg�@��Ba"��B� ��)Ô�o5Z*��I�1(��C��N��7r�9��b��/|2~��k̫��?:6w\g��<_�Z�$�J;\5      �   �   x�}ͱ
�0@���+�K�{�ii&ECAܲ�4���?&��H��N��I�50f?�м|�nMt�$����r?�����K
0�<�k��ZZ�ZkZ�|��
�����`*bSU�Eq�˩�����e�����r���?}      �   x   x���;�@�z��hW���g�!J����"E@D��œ�u�htČ��nl�K/иc&�u�dпr/���xR=�hv�tI�+�����~?��R��0�Șe*�ZX���%��Cq;&      �   �   x��α�0�}
7R��B7��D-�čMk�	����E�e׸\����|�����	��lg�nY�\��h�m_���N�3�l;�<�J��a��$0d0�BQQ�(�0	]��f�جf�EH,H�A��J��FM,�����p
�i��
���"����L�
�c�c5��Z~M]y��;nȦH      �   y  x��RMO�0=���w�(�G��D����2��ڥ�T�����i����Q���˳C���$�vY�晿M�܏�ְ��,wO��y�4n`���6���b���5 s	��h۴l������2-^�SU�G4��QʌTDapB�����E�!�2��١�8�+õ��H�pi�W�,������vi�6 ���m�����~�K;B4<����0���q��hz�?��6I���0I8�"Z^EUT���7����z,�0�`o��b?5�sB�)4P�a�$��x?��X��+C��_�rK��b5�	�bQ����xϰ�ɚ,B�&��{ޥ�B�t�늴�;2�%��S�d2�<_-���!��} �ͤ      �   �   x���=�0����Wd���ī�n�X�C�%EA��P[��5[G����)�|����O����}�8�KxCE5������k���3���<��c��J��09����"/צM�o%M��i�%�U݆�f���ؔ\ԊhK�J�fTXC      �   A   x�s	3�t�K-J�,N,����r	3�tL/�W�ML���T��!B�y�%@�	�[jj
W� �
�      �   �  x��[s�ǟ'�"�[��[���f��9�S���ؓ���r��i�x��I#;�lۄ�ر�sw��=- d��ӃׯP ���W�G#��O��9�F�.�����ޞ>����o�..���g7W�˫OH�����͟׳�����_ח.F`$�,:���?f'�W���w���e����4r�(���&�X
?��Q�����Y�}0c�c���"�Vo�ˑ��/k>��KEn�
��N�Ƃ�^��k=F�+kaQc�r����b�A,��`p#h�$bd��$��X�� �EƎ�ʵ$P�eu* VĂ2{9������F</u���Q���E%@�0)���X��`Rcp�1j-Ln�Wd%�L+�I�M�iiC։_�_N.�D��Î�a5����l��k��;aɴ筳'��]zl�;���!��P(N�Y(��'�8�$s�̂CA�_��D6��r��Z�&�W�;[s�r[����-�;/��%��"���:�-�/c<kisi³�U-����_3u��I��J*�N^%	��������F���g�d��e��"����NϞ�n K��H���s~��o�g��������ݬ収G,��ێG�t�����-��~tpi+�5�XQK*�Ř�W;�ʍ�a�T� �_�*�Ou���q4�e�y���������Z���3A�V�1�DJi-��3�d&��/���
e��^�Y����Y����y"�ZZ�-��DfK{s�쏊��=��J��������Q+mm>D�9'��Q��!���b���r�����$;�!��l�¶c�����eڰ&��]�?��R��*��a�Ɗv.�s []���}�Z�����UB[������vW^x![I�(���;��6̞����ck���`+��xl�p�DMq�A���r�P��ut���u?5բv}s}�����Ǡ��`h�u�QF���s�4j�:i�r�U@>Ps^^ ���Xi ���/�Q{W��W���mB���$E{()c����C�X������R�u�l=��^�բh�A�Qm�4q)�fM�Q�ZS�R3D�oLM{j���A#���m���$!�T��
ىi�24y��p+!��'N���t:�����Tvx�e���c��)PÖ�nɮi��Vmb��9�8��k~,�-�Mb̞򍉩�X��@�`�.��F�ҁ���%Z	�DC�ǲ������L&ٻ���{�ً��/�p���Y:�(~zP�b�~F��2!I�`a����h�I���ERZ eF 
-�c��F[v|��E�#	�1_�!�U 5�jc����h�!�bN��c��@2&Ɖ�69��lY�~��ߏ�Qa&�,��^*ad	f����?�[^ct���)�u�H���`j�]P}\�#a�1���'ϴ����	�`�M[��S�� ;=E��Կ� �A�c5&B��^�$�ρ]��,����I�ϵQ2R!"P6T�X�y<�Ay/KZ�6N[��L`M$_��a8x�ZD"�^1d�s5zz�4Z���+��^}ul�ZfV�kBCA�iI�W��4��66�b,�9�H)ִ���B"�)p��3b?�´�ឍ�X�\�2.e���ND�R��=�<GN̾�K<5�PV+t#�*�5�5��$��L_#������p2��Z�q�~�LD2ĎuAo���1UrAZ��<&dĲ�>��� r�e�cY~A���q����n}����h���Σ�c�"A��~	m�ؙ�"e���+w*�U�S؞��(�d��2ԛV��
U�@��c�Y缀��{�F�">5���
8��.�.ȩʤ��)��h8�I"�[{���/w�o��#��'F�*��1q2�o�Iuz��~�*D̎��%���:��'G�>��U4g(��Ze��ٶ6�Õ���,dȪϯ3��b����Ǭ�qa�Z3z5[�S�u�,���ͷ����&|����\��[�Z�
QBʖ����`�I��pQ�.�Sy��ݵ�3#+�e'��"��DU? M\�&�'�0P�ۧ��ֺ��R\l��'�5Ʌ�E�kz���ʫ��)��������j�&�>ݦ�;m6��U6=z|��no��'>�Q$�}�.�;����l�JW-�;�b"�-`� sa�S{\X���ˌE1��  �RV����B&s
	vv�%/���E�ۓ���Ԓ}�#�4�rvzQ��I�2-��4F��H�\M5+�`�"N����E_wȦ�6���ŧ�vp���/̧P�u`'�F!b��n$�EC���-��N�����d	��:g�����6H���o��t������:���K^���1b��w��}���HhC��&��E���u7��{�Y�^FŖ���Z��kvu1lf>P��1��=P��Э(�k������Y�W�Z�j�jM-|`�?Wb�k�Ε�ԁ5��{��C�~Z��,
Tʰ�)�݌����F�+���]H�@� ��i/���_�F�k�^�paթ�c��b�ruػدxu �dХ�qY ���v�ZJ�w)��Z�֙-�#��DRe0gf�j��@?�Ǉ��5��w����"k�.@�J����n�n�U�Kd�V�_����b_���Uu} �!b��=�)v�鑔��k��mm���3_>|�����np�Ƙv����pCR�g
,��偲GG뚍��vy��כbg]����������H�zR��I���c��KM���	�ך�栯V�ּ�)�݄�5�c8���^��n,eN+&,��H�㈝�
-��',l��I��cd������U�%�j�k�<?_�<?��Dt�>� ��08��m	��r!��V����X^jE��8�5��w(QW�*����^���������u$<����X4�N�w� m0��g���1o�W��]�-6 B&jl��l8O�B)G2Ȧ���r'U��c��V��x�<*B�l�by�-�<n������󽽽�o�AR      �   �  x���Mk1���_�{�Ї叹%,)%�Ҟr�a	�m �_��lH��.tXd�wGz����'�{�y{<j��=�<��BD@�2�T@��~�"p[��W�L%02�a=#9�:I��BQ>E������m�o��v��҅��u��ć̽^��Ɨ�y!��/D���,��"�r޿�v�����u����o&H�������~����4�@l D�iX�1�q ��Ġ�b���2*'ֶ�/qy�du�5:�E�ԞO0���)y���oGe1�4���f�_�rם�1-����_1�����QB��Qi�s��@���(��[c�|^�ēȄ"����3x������mT��U�����c�*�=�:L��Se"�V�m~����U��E��Go[@�a%�jn�Q�P���X�̸��f����5      �   O   x����0���0=LJBw��s��%�:!���B�72x���
>���d�D�h����p�l����h<��^$?�`      �   �  x���=o�0���+���<~mJ��i��M�,YT�E����rˢ�:��l4��#�~��T0O\̯)�bX]V���i�,,�91�} >\W��4�a:+V�쬼\^Up3��}}�P���z��������z�1I$�┳�J�����?�AZ[A��}�;�@�"�:��i��C�FFE��x h�o>Y�f�����c]�E2�x1}�<��E���IhV���E���hDy��ɢ����W�5�������&�=�Ή�Ct�Mʚ��qc�#��&��E�|p�>���c������X�+��k��}�>�Q���֡o�|�{�v��!��d(=e�_�ҹ`�u�򛋥	�u'4}��x9]\�#V��^�� K���V�2��he�{�̒���7I�d�IҼ^��X<�S�꽷��m����;tS1�)�)"+�tLSQ��Ftm|'Y�K��OWմ�˕�@3���b�6�]۸[�o#�Q�����d      �   z  x���Kk�@ ���W�^\gf߹��B�/�/����
����XL�a���|�I$F}Yw�ڌL-涇�D�k�ݯ7�S����m>�Y?�����s;��A�%���iD�@d�	���Ba�5������|�.{�T#X���S1WP>��'�1&-��gԱDHҴ�%���;�n�f�H���6��:t:�lEG��j����T�<�8�l-@�����}�1�>�l��
N8�4�L&)��r�qq\����-���C�NnB)=g���^B���/��:�$�_�Η�I�n����X|wA��i�;���|��ו��r�,���T��*�Jm�N��_�4���	U�:VF _R;��p�*��(�~ ���g      �   /  x��]ms�8�l~�|�ڭ��[��-$�]�wE�� $������-ْ';�$�L��Ժɴ$ۏ�V��R@�� Y<޿���} 7 �������Ƴ�dC��������W{�s����!e!]�����_���7�ͭ�Z�>����>;�O�6�<���={����l�Ql�l(��l�|8�ON�~�j�m��P
Qh��ӥ�
籔*"(�RE@iKY��@�2Fg�)��*
z|��S@��o�s|�������NO�������ފ!�g$��X�!?���������m�򛤞J|���㣿���CI`m���/?�`1�P<�|8�@��V��v��*�g��O��?H; "܆�#�ǠƚnEC/�7$�G�V����c}!k��p������Nߝ�������B������(~�ʂ֖��K�Y�@�Ro�(Ag!�h���B��CTs��^0�k s&9���{�������z��������O��p���u:;;�p��tV<}��x>�N�G�N��&?S��<��K�Fj�D�I+]iu!���t��"&E����� �	ې��,�K�Pd]�*5R�@�А����Z���A�j��u�	��Bl#Z~C�����/�WWhͿ����	;V8����;��;=��fF�kMX����s2�Xl=?��!����G/>�~�_<+��~��F/��#��/F�&�ώG��6�η䐭%�^�Ld�R�3W�k�#���'K%��*�)�A}�E���Zk�-�	_�Ҋ,��غ�=W�\�֜4��V�J�;	#�1!&dIj�0�����Oc� �aI���� ���NB���A�u^�GpTJcz�D��2����{e=g��9~;PC��r��v	�jI�e��uxx�Ul����������k��G �uJ�NzDL;'�Զ���MEg�?HK���a|}��\_�]@�|ү�`ߛ�����sD"q�[� r]h�@�V�����K=i�4Q:�=���N�R_����~nd���V_N��/�3Y�� �K}}9�]] J��A��
�6L����T������-^�|�ʮċ[4�w��=r��L-
��rux���.ESz��3�}����d6�49y������.Fh�2l)� ���,T!rU
��V�e!&3���(K��QCTs�U���2��0���Z>�]��w�4���P�7�����G\}��Pw��}#��N� �`�?��o�������G_�;n��ؑ�hy��r��K^
�v�.��_�ՒB-�ղv�"Kl���v@�:��9*o3�;'�g��#�	C9��^b�9���0^�ɖ���dzS&[G"&?xwz���ӗ�٤�e �T�Y�
��As*��QE-Q�	������N�p�����ڛ{���v����������(�gE�~=;ۂ��6@��o��jВ�Y`�J�mW꫚%�p��<��gUţ/�����l�w�������ho�q:jp5ߡ���c)��DIHIV$	���T�'�t*���������Q�m�4U�XS�e̍PկUSy���Yz���iZ�|M$��bs��a��Uj%=vŵ��BBJ�FD{�͟�[+�� ��8G]]�w��%땚

�'?5	������+����{@�SU��5��(��[A�kUi���������Ɣ��DT��d�!��^%9-����s��4��v^r�u�̸�R/�u�Ɲ�Iµ�I�7]I�E��X��GlC�9�$�T����f��Q'^v� �����]H� c �Ⱦ�I�L;^�γ�n0�˹<7�b �A]��Bԥ_RJ���^��	I�6�!1��t?Bѩ��&�N|Sȟ7ְ&ëJ�)fHF��L����N��p}e�u��h�Cp���ej�=;�ƹ[�VD�ۗ߿�ъ��hew�~6���ᓑ�<��o�#|ݍ��*Dg�Y��:�RE���Be!6��t:,=Q�mߩلsH�9���9�ov�_����\RDkjU�P@ؐzz[-n�5$�aVժ�ʨ̦���˰l��y5��D��䫁蚵B�'p���U�4��I苬�޲%N���6TW�
��a�J=ֺ��k��
�2{_�����$��^g�T��J,��5�^�VOI"͘\��tb�r�_�΢�tK�[
��o	TW�69I��87�sŁ���3�?=����yAF�!��}=��I��J�;�t*��*u�i�P�UVxYM6��T��(+>І��Z�����%�E�T�-e�$���26�!5�YxU��$����LC�걠J�[G�����R��)Ĝ;ܝ]�t1֦�+��g�P��Xm���a#�^���'��8}�(�Em4�~��i�w	T\
ԛ����.��
dU"LH5�^�B�Zx����C���_ϣ�s��݀��9\���G�����6k��V�F�WEv�C�|L6�Ռ�<RV;��'k(�iH=�d�b�,b�z�!T)���*�X�|�B���A;0W}I^S�;���#^����C�"�*�Q�4+"b�1d�C�����A�і����VE2�ƪm�%bj[�@�ٍng��k�r��F�W�bV��.�Lz.	�\>	��鼲O�9�F���=�W�l0V�Doo����GbFO1Lb�դ+�G�k>�G��E�L�n�Hv%��ƾz�%��5�0�p�Vr��^��1'���Xc�n.k�G��+�����?�����k:�B��4�@���47#�ű�����&�������ӽ-��^��Z�Z�_h��+;]:��!5���$e�XMLor@^\��Q[�:��`����w�_+OC1�5K�x�9$�Pe�h5u�)�P\=AV����v���5�5Mɴ�B��ҙ,���j^|3Y`DuJU�����	;'�G���Cތ��-Z8��Y�(MAY0�:q�,1���$�=��)��%z<�MC��2�0��늫�<zj��fX�4�pz��I�)��q4	�(U�{�;
��#�z�]�T��ϧ�X�_��TM��n���P�!�zm�I�P�n�_�՗��1ҏ(��k�Z�Q26l�X|dX:��7 ���&�י�1C60K�{�(�^��z�X����n,k0��@��#���z�)2�b�&���joTA0���m �T�h�\�?q	�+^6��TM�r�Ԓ��*P�1�~n���~Zr�v� ������P/5����#珀j��{�|C�ݢ1%�(�p���Q �C�ݘ�EW�0��&�+��C
�B�̾�o�x�P��O���ɘ��Ƿ6�}=nI����,��U��T�o 0�(�	�P�֡�br2ؑ4�x+$K�x#¥��"�c����zo�m!ҸvI/Xn<��E�N�	��p���k���yc�z%q���vX�����]���C;�z�_�eX�8]}�\x��a	h}0��+Q^�c���J�{�������`���b�s\��,g=/���u,�$zN�[��5枠��#�s�*h�ɳi�FY>�qA�J����oϩ"����e���� O���������ׁ�w��ή���+�=���;f��I���1����ݦ���,�%	�U�D��5��
��j9�c����4�E*�E/'�r/�<t)xG*��d���V�w������Ir����hʒO��<4Q���R�Jq,�*���4�bv�g��Gl����N�/��m�f�5����.5�̂F�R�!�����/_��]1����`���&G>�k�H��������)�ִ�k=��:vGim�c���|�]a�w@����Y���G�c��!���Ϭ�хdC��c��O�#�z��CG�Ϣ�j8���O�����Uy�޽�	o��      �   >  x�]PIn1;K�����ȉ���K/R���&9��"%S́P,2�$�T��6�N�%���yk���^a]�4����G��2�2�����d�ذ�z�Z�G�,���VB���ۥ��@36>�u�6;Zn`��e���|$��D�|��ъ��K&��*���%n�X_(�tD��]E��D	ѳQR��a��Yʰ��	B��=Q���K���J:n;x
�~nu��vlz�Wt�A����>�zW듍��b�3U�h]ܲR�B�!�1ԑC���`s��Dn�RP�|�ѻ8{�zy�O6z�֧���Ŀ_��̓y�      �   �  x���Mo�0��ï�}3��ط.�Z���V�ԋI�%�&(���u%IVh|�=��y���q*Q�Dʩ`�9t�̚�~)�&˪�<��-l7�q���#�]��|�AJ�1��Gk��
a�0L���C�e���!ۀ�*�g��m@g��  e輴Nuҡ>�����`�k6�_�u?*�G�ڻ C^iN���80�f\h�>����q�Bk�'J�nH!���PnX��e^6�"�ݶ
�~����S�*k�c�DX�D��X^Y��_ϐ"e=*/G-�!{\CV	���a�x��:�)ʼڲU�l�ۧ�t�F!�q��keG�e�K���sX�n�����c�)�+ʿ�:�q2p���I��q����kÝ2#t/7^y�"q���'��,�$Y      �   �  x���]o�0��O~�U�s�m_uRo�V�M�n,R���@�)�~N�$�B������>�9f�p͑Ӕ�k��&��C|�.ܖ�<oW5l?D;E���h<�L�+T^ ̾�>Li2K�	��e�YSV��
�/x���?qB���@�f��o���p궚'�.C�Jyt�Yձ���'�5���ת��?�@�Scw/�4����:O�#2�x*�RuB�����jh��_C�'/��Nm��6���S��Ug(;�&ն���~�E�X|�9ꔞMx���5�[�x�믏�!FS����s�x7��g����.4��
�LSq%u��.��>���"*K22�G�)f���wj�A��I'�����K Гb�� �C�q�݋s�h�/?�d78���L�i$����g�qz��Hj/���Y�@dD�*k��J*q!��?/43�2�d���?UH��      �   �   x��б
�0�9�
�%Ν$Ƕ>#C���w�tH[0�-���yl�*�������A���K����t~��������2�P'�.���d6�꺗���ysnsn!.=�����X���*�V�}ʯ�?�q��#8�~�{I)= e��      �   �  x���YS�H���_�Ǚ�{_�4T �H\ʪ�H��,�[���N&b��$VsH��v��0���3|s$#p��uݮ�go�׹���N�1�M�Y|�8�
=JAk�`:�4����D�0z����/�Y�\=E�N����j4�NW:y�W����Y�;yD(O�� ����l�Tk�/��;���km4��A��b�gA4��(A˚T4�u�kN	��9�NS6cz�Ȧ9�n�zss���v��2�IΓ�O��s��6[V����V�	�G���A)_��a%�e��ǡ��\�O��ht����
*�v˙n��S$�2U���,�Q�ӕ���D��X,��a��V3C�:�j��5��+`CX��+��ce����(�C�	�x�a�)#��C?�h�(��x��C���"� s�#��T�X�.��s�t��ӽ ��q�^n�V�Ж�<5�gf(�������_J��������Dt��C}c��@P��@��Ƣ�py x��=�V_�Ft����+1��Z�K��w+󗶓@Y|�_��VxeZ�z�[��)+Q�v�,	�9��%����ڟa�DE� Qm٧,e�3����ᛛ��*�Db�8�r|��9m�y�ȥ��a�C��^VF��I
�&<�?�ÌW& � ��y�
|:�u������V��H%�T��bJˊ��̗h�*J��p�*T��O�|V6s��?��PJ�2���T�M��QA7��P����i�8���ۼ4�R����f�&��H����#� ���n�R�L)�!��X�y(H�S�:���[E���V�9M�E*�KZʹ�n{-U�$BDrT�ȵ݂T�K��C�c�?==�(4��M��y~���'����$�
*�Y��fA�����\�1���+cd�"d���E�*�@�nO�*!����Y'��a�77հ�UM�B�$~���IrX�E��\0x�B��\������_�nخ�IG� +1�
`��U�~ټk��s����y��[.p�n~�"����D I�}���@z���v*QW�R����d��S��)b3Q��˃U��(��랛lJ\6/�جp;e4��I����d�k�i��6:(�!L��{nE��{�>n�R�
m�y
�Y���(/�}W���<�u7��A8�V�ҏ���.�h�tmϿ#K���]�{Q2����X�\��
f�$�8�U;99��IM       �   W  x�ŔMk�0@�ʯ�}�+�߾u��
-�1vIɠ���e�vi'�]Z�Ȑ���$G�j1ed���D@��f[�o����=ԟ`�Gd��7���a7)���r�l�M\�8�*�%R�:HƘ;�O���EET��B:	���u�Cۜ"&�1����nK����s�}�9m}	8��<����Ĺ���:�1�����Tζ9ہ���;�v��p�s���|y�-����銷����T��TB1�T�k	q\߫dK2}]����E=-�ι��X���P�n�uIK&��X�}��Wk}�Tbr���cժ�����v��UZ�:�t�i�Ӿ��(~ ��bg      �   �   x����
�0���S�.m�Mkkn� xP��x	5�`5%�>�UDD�w��fg��2 �u6J�k4VG�s�<8�H�f�2B������Y�+��
��Th*����
� ��2���}����l�� s^�T�F�r'jJ��B�L���a{���	�	��h��? _� RQU��ua�B�	�ȗ��7�F��4�X�f�y�?=���7!�l      �   D  x��Uے�8}��
}@L�07�	�����R�͘�l<�����6�`f�NiSP�D�n���Hd�$9���|:9wC�:�v�ʴ�n��Mᛏ�S��}��%߀��u�K>�h�Ͻm���x?,C�l����_��Q<�]��p@�g���㾻 U��1�!���[bL�p@�'��A5�ǷN� ��;Pm�`�%�����p���@9��q�����TX(��sk��U0Cs�娾�@C�=�C�+��bc�`�ʸo�x�p+�C�{ ���6����0D�?kkiC�V�=�]��(����G�,��&�V;�	�1ĮԀ�|���W�"��K�F��m���-�J�^6��Ma,���1!�>-���C��E��˪H��L�⬬��«��\q�)�T(�������(�Tq�J��{��7-��OQ�EB�i���Aul[3���l���fq��|��u�܌?�2���t��ǉ�~d:(�LQk�QلUW�#�wgA��Ԃ�=���'��g�%�OQ|���^0��N�:��m��M�ݎO��3��Ӻ��ˏ��3����} iכ�x��5Pn�{L�"'�k��ޖ�p6s�l6ʗB��g��U	7�t[1�[��{U5�����2@̣ ����vP�&��O�dJQ��������4����՛)�{Q�[A��E�V5� ^��ײ.�Y����%���P��"6u[ū��uc��7��D�&LG�*Ƹ�G(�ѯL�ñ+G{�ա�N~�!-��k�_/�4%ySt���)����0�t�8���Fh���e��������/w��      �   �  x��X�n�8}f�B?`�3��Eo�M�-֨�$��
w�6IӤh���;�|�d�v����9<3�w*�h&�Bq�FAP�Sybշ��Bn�W-� 7��h&�&�Vj�5��0(`��z��tQ�ti3p)��d�p�����ۥ�8]46ק�WW7O7�}�)�����R��|�ݛ���DÄ`�	a|n9�G	�_�w����������q=Y��Scȝ��@���_��.��d:����NӲKV�v�&�����nE�=�ć�+�&$�hay�����a��a�-
�Q`P��59r,��8���$v��R�s�?�l}�G��4�}h�݇}8{����=����裡Ѩ�D}�2� ��涪7BT�w��U5��^Vfxt��+������{���X�Ʋ�oo7�.�uZ���ea{g�"j���pϦÍ��^���d
�t�7ؐvZl��aB�#^�H�#�`{�d��&6���N{�@r����ǣ���#�D����E�#��� ��kۿ�~Y�/ ��P�� ���
?����m�m�)��u����|�, ��	$o,V`k�5�"�S@$P��`2�XI>5��j{{����W?����A��B{ߚ�@n����ݗNL�<MۘR\KΓڀIv�b*/�X�sE�߱��=���G^c�m��gb�!��l%Ky$��@�� �C�&�D]p0lj�ve���c�2h�U�T����%�^)y�|����6����a:��̕�>i�,\�0��S>"ĎIPGС�h�4\bG��N��%c�ZPt��%7�ܡ��j2RY���x�¾���X�{��@�-K���lt�{M���hf�(��U|?K	�e���n��@�
�<�˾�ge�fM>��tGp�9�w�H����#�Mބg�|̄��8��)ٝu,N���)U�Ԫq��y�:].��}��������m��Hp/�~���$�P!�k+��(猡��Y��(�1�-���v`�^��.f���T'�����._�\�������eu��b6}��4o�{�!����i��Yo��0�&�Ŏ�����o�����V*�Φ�3��Ioo�o�G`��6R��!)�r�{)^��?�G�
�tP���89�mL�J���?��i�Og���5�f��}�k��~������2;���.]����u���(լ��2���u]��G=jrx-� H?�fdS$������e��;LM�0�a��c��뇇���<�����"��,k��)�P��{
箅���5ܾ"T 5�y�pA	s�$�>�\�\�dŌ�ܱ���䄚J���Z�S��5}�����Y�œ���FiLwajZ�n���uR���"�K���p��u�H��1$�*�:� ���A�;�b�^h��������l�(�^��^����$BJI��zq�R�k�\���I��={�~�����:��      �   `  x���MO�0@��	�ݤq��i�M���K��@�6���`+q�E��۲����a�	&���Y��AD[�;��yE�`�a�`�a�}\��L���3��W�Y�6���L�!���}�ߍ2��ہf4L� L��Hb��e�P^r��!1�� V��y1��w��Я�Q��P !%�T�"��|��Qb����e�C,N����wp���U��A���ZX�ooΏ��%o���|�H���#U�iB�*P
b0�[��� �Q���g"�!��
j���ƒy���BS2���y�/�Tä��nQ���2�Ѱ�_Ǣ�l!a��f�g��3�S��a�޼nw�5Ė�juUU�7.	      �   U   x�+H�K��K�O,�O�����*\|�
rI�y�ȲN@>WAbf
gpirrjqqZiNN�BAbenj^�BI��KjbNjW� I�#=      �   j   x�U�1�P�9>L���ܥsU�?��b|r,+4���]�G�ü�ՙ�c�E#�l\� )%薭��|i�h�GS��U���fk>�&�ϋ�~ ��:E�      �   8  x����N1��g��/���/C�(�-!U�&4�D	y��z����R�\���?c�o�
��q����9�Z
���E������㦾~YԌ1qr��9!����i�K@Lv���,	H<�iT�|y��2m$�I��/1X�� ��"�|Ju:�h�%�Ғ4+��MUEx  �gSv��ͥ,�t��MRv5g�X�Ad�T��T��0=���q�>���xfA�6qz����zGllIxX-���ݗ��=o�|�Z�wE^�x_�J��&��F�/�"��)b=���T�H	��,!��;�HX�Y�J���tV��?�v��A㨼�R���	U��Ҟ��H� 3J(.����x�ݘ��[Р�bD���~�d�J��H&�L�<<%�(m�����j�]�VO�׎�c���3����rYX}�7�#���C*s'R[��, t�kߚ�3Ω�$��|��t��}3��C��a�`
6����܊�Y�����&	"y��a�.�}\<8��t3F"V�����"�gySX���̎-�1y<�FÏ�ۮ�q�cۥFk��\��f:þ�q����q�r]�X�m\�&�8z�\*���C�w���z�Z֎K:��-��F��lhz;5���cO�O��|���=��<� �d7�T��T2�����Ψs�(�Ry#P����;u�XÁ���QP���Q�=�}z� �����DQ��7wƚ(��������������J֧{�3*���ƪ�P�>�����u�S��X8���ʏ����hعr
��!a�Lo�H2f
���ZU�?cq�      �   f   x�e�1�0Cѹ�(v[�����1!��)�I�$6�����
f�����&:S3E���V�a�i�4\�������4���W�_��%a�~�rθ��x }F�      �     x�5Q�n� ;;3�~�i��@�
��I{��X�m�ql0,�]�����K#3(��k�;ƭh�R�dn#��YwO�t���d���q�1����ټ��,���N��(�
$�V��m��^����c�+�R��z螑�'{G���şn�Y4�Ε��*�Z��T)�B���4kz�F޴� g�r�פ��¯^uXI
�?�R�����w8w�t�P]e����c/#���
�s!�D�D�H�ƫ���׊�o�M��N�A��������~ ��a�      �   �   x�u�=�0����W�Q��"����BI\\�@b�Tb��tqq8y���%ˀ	�m%1(�5�;hm�`�0n"h�=WبU<'�6X]l��_��������F�M��55N(
|"/����jgo�ϾA����P�]z��Fb��8�B�7��0$      �      x��}[wW��s���'/��ت�[��H,I�{ּT�Q7�<B����S%������D��v�#"#v\��sڽi��ݛL�����z������������I7�5??�=��ɴ������q�n�m�p�i� h	�z¶Ւ�mN`��-���t�������mS�o-c.���}1]�uL�>�	}{F.��v��������|QKV�|K�~�]�uR�-�A[�`�8���B=3��Ӗuݠ%|Q�u�6�e=3p(j�A[䦡o��������f�KЖ�ڠ��j�A��K�[YSZ3<΄�j���%L씹9[lh�]__�/on�v�4�|�襜������R�4�5�Ɠ�/亭O綽�|������o���_��R���%�j��?i�Pl}8�J5͖��W�Ŷ��>�leӓ�J�	m���ĳ�`����}�Vx��i�y^�-�y��Wz/���5*��>����'t�_��:�;�N[�c�����߄u]_�VXs�iq}�5�����7am@�e0��LZ�}��&v�r����������d��^sp�!��2���K:�I8)�밊�,q�s\�&�qzܱ=�n֠຤-�+�a�u Hqz�V`Xh]R�a�tI	�p�MױD�*	��%���P �*�@�e�D
+��7�T�,�,�[����$�p�\��Um�7K�Y��0�T5c%R%$]q���%���R�[�a.Zy�H	���"����&"	W����_���*�L*VB�TB@!�PHa]�J�H�+���P!�] ��,�b%T��B*喢��[�����^�芓��P!�u�{�BJ���X	R,8��^�8�(D��i�g�T6y�J%Ie�DR,��U���Tٱ�R	ER�J%��]�TB9cER9�D]��uŽ�TBQW�T��")��V	ERW<��J(�`���UBѱD� ��._|s���Շ��������d�7��������t�������~����y����7?}x�`�~7���{���� J�:���R�� ���ay˔:߉�����	˝d�Np]�Fםxk�83��;��]�:�[�Rg;�u'���$�]�ְg��n������"^��S���Ԭ�xk'���d�bg��W��%KUvJ&JegBP*�T2@�����	A]ɌŤ�3!(u'Y0����ǯN�N'�rn6l��d:�V�F���IҰ#$9>�R�6�J�9ם�"����	J���k��]���?9�?i�{���Ѥ��*^7@�v��Q����Em�_7�����*d4�M�7�����OW����
'mNkdt8dN��g�Ns�s�iD��i�bg8��A(	�z<�;8j>����y���MUFל��֐EŨ�NN�#ΚF;Ü�T�pF�4��3��pղ:���J4W�n�D_���#ީw��_5q�^��xtF�#:c�F���Ot�Ne�:�� ����D��_:�N���ʣ����h�x�K�1��5.�1h�۶tư�5��Y:c���p�r��b�,[zB>�L��#���HzG����=�{O����L���t_r�s^]q�;����)݇�"'q'?`P҇E"�"rXp� �L���S�ߐ+��@ȝ�Z�ۦ�6�9��W��v�ɝ
\�snr*pa*�&��ؕ� �s�����BwΫN.t�ȝ
\�S�{� 'q�rթ�9	$�^.��,Kd�9�U���/��7�
N�8��&p�v�S���7��l,p��&d�rڃޜ,`�l�3W	v8��`�sol�9��Y�`�pGh������,-p�貱��B����Ĳ2�f���էͯ?ڐ+��Cȅ�n����%�&9��T�M�e@X�B7�97	��4�s�P�Md�"a���k�^���;�U�P��s�B�6�)ݥ�l���s�*�d����H��A@�%2���l��-�ʏ1{����#1��Mb mp�j�	f��Zb`g�ԒѬ��ZB��$s��l0G+����0-��2أ��@����6��)Zb�a%����Р|ex��}}ټ�T�ǯ�n���`B�����0�*Iu�a(au�.Cñ�G�2ZǱ6u�a`����P洃��.9e�:6��
��a =-�%�Ӵ�l�	��a�a���6��U�*?��������j?�{����jˢ�GY�
X�,%Z.m�T�ݧ�����e�])�=�|ޕBUw++��R�kK��-���.��³5�e�m�������B�wY ӑ,uF7`�/�V�X4�?�����rå�)'����sY8�\�:W�.��ϲ�H�2;����t4B^6����U�t.�J�vY�B�+f���
q�-C��e7�+�P�0;��C>�v+�#*VEc�{Wm^�k��z�b����@����z�ʝ"(ˠ��,3�e��ж;���f�y[zޕ}�|ޕ+��A��YZޖ%o�����g�y�zږaS�Y~�s���2l0�� L����*��_X�*(�Y��|��Ya�m�+��+`d��+,�+�ʯ�ϻҬ�
bV�QX��Wl�r_����Y�[x��+,�-v�WX~�s߬�
K d:��ʯL���R)��,ʏ>Q��[,�����BۢV~�)J�,Z�XxWj��2�w�V�-Ĕ
c�(�o٢�e�}��[��,Z�Xh[��o����V�-� �t$���
�@���:(��,�oSQ}�WY�	Vg�3&X�Em���ꨠۢ�
�b�����E�`u�|}��YԩOG�~�1��,������:�}c�ս0�K}��Y "9`>��v���(�_N�<��tρ���A	V_ %���A	�8�=���LL��q@	�eup�ꈲ�����j�`7�꘴F�j	V[%��`����x���V�%�{�67�����S�YJ�m7/zã���_@�h�0(���j��5U<���J��J��`�b������ ����q/(e�TP����F���qjhP����q�qP[�^��vce6�����R�LFQ�2|� �G�A	V%8�W�jq0{4��ј�K��#��� ��euj�F�%��(� �1i�k�j	V�%��`�lPB}<T�I�k��Y��f������g�\i�{�{�Z�3P�;�,28&�����E��S�`�X�j��T��i>�J���Ʌ�d���i�\FL[x�+�˴�gQړ�Bۢ5 �%�>���b�@�#Ykf�J_ ,�rq�w<�X�� auT�*�p*����Z
��:*�>��΄�YZV�B=bTLT�Q�P,�Z�bQ�V'D��auJTD5f'EE$�E}��:/*"��ՙjvj4�ZQB��巹���l)l�	»�'�;�����=��Tpᓀ'(+ ��;+ �	���<Ap=�0����QVd��Q� |��%aD����8ʪ����	JsR����"i2-i�⿸�4��b�h�Ţ@e�(n�Xh[�I�z�����-ޕZǶ��]�ua1�NZ,J��lQ*�e�}�/Z��,Z��Xh[�޷�S�}��_#�.e��AG��c��
��@�ee��;�.�c[ N�_8�&�� �s �&�(f�q�2"ѱ*�G8b�~� ��;9�E��4��c�Q�;�1d50��0���Ψ�f�r8���+��������ޜ�W�x����{�W[9��5���r����ɱ��ڎ���p|;�����g��I�������3ށ9p-u����O9p�t�I�;��99�Lt%'��pN�S|6p�d�=+߳pN�;�F���]_>}�r����������������&G�j�w�xè���1&
�����U	$�<
N�qUu��������5��FQ>q��!g��΢XD��G��6l�d����&C���A���,
�uG�1PW�-�n��]k|���m��rT�$��a�G`��`��p�z'��$��b��"�j0��"�И�IB*,�Rr1��b�0��$A���6�a���)��CS&)/
�j6�aْ�9�28��{{���S�jE�QTtQT,    DQiXE'Q�X�H��3�(*/D�S�{^��у�F#��Uu�XY�ʋ���"b�'*8���Ұ�0��ĸʫ��F�i�!:ƈ���R�Z���5GGG#yIʹ_�����$h����A��p�X@:A니$�$)-2�oI�i��}�|-�C��um�;��Ђ8�gZ.`�� <�$a�c IY8��� IYq~(�p�˅�(Ȫ��6([�:l^c�[I�鬹���� �0`����;C@%�~
C죧. �_a�$p�bm ��//`;��r쫹�Am$��_j��1����P�5ܷa�vce6��d�P�n,��n	�
�eVN���]�23��Ffw���6û�'�ێDftw��\$��Q�� Aw;�h�{�dfpO�l3�/M��&��}���5��G���f��*�U~��a�G���UY�+�ó��W%��9�eT�y��Uw�[�U�1h#�b.<[z)��p�1 �j� N4 ��lUl	Q`�V���8��h��ɂ�QFp�X`ڈ.�a?Fk��+0���t�V�pA�]�z{z֜]|�x~����i����������]|�p�|�����Es|�l�Ns0�����ezZ��Y��E��<����^�.OV��W��}&����J�~Ф�e��x-�J��U�^]��>я}^��^Vf|%��>O�� R/+�NǕ��쵙���|���ͭ����/?]M���l��ft�?����9�����?�r;�vӏqZ���lS�q�%�!w�qږЁї����v���F����n{�/a[���Ŷ6�8��ڊ������q����7�O���ɦ޹�R!�+�F,��F,�:+E�,��B,�a��q�\�5��uECC, ����b�j:3����3C,�Y���Y)�1�3��r�ш)舨Sʭ�n��P�4J���?5�����yq��������;}���쨙��n�-�:[)n\�k��r�-rťbWt�Z��Tq�R+.7�ǝ���a<�n����ks�[�b���>\�]��q/���]1ԊK���^1�:j�%JjE)f��$Kn��%�j=��㣳�7?�>=�S��Gݢ����C����f�_sx������I��pU�$n�z�۪'QAY����O�WeU!j��M�UO��2��'�"�o�\n
��=jP���?�����PݼʟT�����VK���ʟۓ�Q��I����r
@��l����͠�I_6�]��|ը�Zߤ��U��}j��~����9o^��s��?ח��hN�l[h��٣v�=꾝l�|��$Oؗ]�Y�f����1���2K�.QX��Y��}�2�v��/,�����-31�̀U�f]��>ӛ}"f�^�f_wZf	��}�f_7[f	K�_�[f�SjNM����|�����_���pq�~��|���/�ϛ�'8�'���?�gQ�E��2nB=�|ⶋƞ���A�eT��7�U�h �� �6n+n�Qp6SN�1���%�j��mM��9� ����7�������:�F׃���=�Ҷ��k�{!�]���t-h/&o���23[?�����1����0:���|kW��["��	�h�i2�!Z D�N��y�� �L���C�#`�s]�n���NKD'�q1�uB��i-:L&�pBb�$�gQP�+�-PrB%�v�M��|�����7l��3��q�q�g���f�.j�#�c���ɡ��3�W���w���dJi��4��3.`�����9Ԍ�E�s�[��ʴq�s�9��*J��y��pQ5���?�/��^s�����]�0)��L��1�"L�S����bO�L�j�1E�;���+1��4��FlZFl�Dĸ�c6E�ƅc
�T�}�)�H���)y ʋ���ã�OO&�M�m[k����Z.>�(�'��J�iekeZr��W��\9VDZ�#ȴ�/��/�F�B��2r�i�L���X֗�R�e}	Z�\˴��Zq�i|�|S*�L�`�ǙVfe3������|�l&�g�
�r�.�P����E�a���2�6�����KTC���2��+Va]�Y���.J�H�a����0^Otm`=]��6�Ŋ��@�P���؜.V�]V2Z�e74�BF�\^\_�߬��h�__�v�a��
n3)U�a�p�d���MZUw�$��ͤTw�)�\��;@D��T{=��8Lr-pl��cS$"���aR:���I�S�O��t�)y ʵN�Q�X�VY��ϧ��=�W��
�D�,I��R�D
몮�KR�4[�����O���%R�t�M�
�����*�*k���ʊ��+�Qm�[�'�ֶ%RXWu["%p��O[��H	����F[]�K�˪��i����eR��G�f�, _�Z�r:����{Dg ���\�4-����y�� ����������ޗ3,-:���a1�}�� ��2�g�Mk׍�F�%M�sIS�^���Hu��S����FI`(ԍRg C�n�v�yQҔ�\�S�s���P7J} �n�4�>R�(i|�x�FI����]��/�D|Z�����(�Qi��QҔ:�4��%���T7J9�/
�n�4 �B�(u0�FiW�%Mϥ>e<�� 8u����FI��#Ս���g�n�4���ߥ�Q��Aħe̗�o�=:B�(iJ�K�������Z1�i ۅ|�H�^b�,�{IS�a�O��>�����> ���%�����%��B��4���ߥ|����@|Z����F���JS�@S�,��4�> �)|QҔuC�0,놠3�aY7���h�x�)�Y�����> MY7_�n4>@<�uC�Al��.��H">-b���?>��mC���¡,k�FYf�J�>]�>���G���g�;��E����z��R��UH�,rD��)�JYd��'�RY�TJ�GBv�>�-�#��c*%�K�E0J���yWm��9�����6��Uv��4����� �@��3�c��Χ�}z ���p�<�N:M��p^r:����}}��V�A������N��}XEu_ 9���~���]�n�o���:Ѩr(D3�h�:���"��zD���G�\!����B�":-��W��!��z@�q1Q� ���IアQ0.)�[��,&B�����������A٩�1���b��D�,��:YO]m0�U�b`'W3�h�qr��P3�bsѲA�K���r��l`��i1�6(�b����\u-V2Z��l�]����Ͷsc�q���W�o���o�'�]����1��P�xA��猁��Qc�8��y�Zg3�_`m�A��\���3Fg��k�MLx�xa�=H����&�����2��n�`e�<*_�m�m�׏7tʎj�n\;U�H� �0��:���0�quT�@��B��y\	U{� ]���1.��~ ݸ̩t�~E�W�P���W3�������~C����ytz��~�^_���Ѱ�|�aP�tc�
0�X��@�0�r�:��gm�Y���Ѭ�V�ѣ"	0��K���+�	�г(���b0�~`s�'�0.� ���]���_�����r>�]��)��M�Q���f �����a]^����~=�s����R���[����X��:����1��P�C���䍋�N��˸��~C����y4�.I??n�����_Λ>\]�r������Y���3�*��W<y���]�ڋ�*W�k��5h�<yTFI�F�*�+��4�yV����* ���"�ƅ����&1�� 7/��*H� �qUWӫ�[n���N�]__�/o���I� �q�ǩ�y�q��p{�Q;�;�g�'�;���g8�{<�`�8�a�g�q*�� v���{v�cH�p��vm��mZaN���3
Gk�b�q��.Wƥg�+є��8��4^��qW�^|s���Շ�����������l�lX�m�,��Ѭ�8�"��u���va�>nk���xH��0����m]�m�G�*��.����ö�Z��xm��O69�5�9�6GbE	���ͧ�������ݶ[*�    ��2��g� 4e�4e���GS0�-h�4e$��CMLb���_�2l� +��X"M<�m�&	2Цlʨ�nӦ���H��h7ed��>o��n�zF��ȹ�����]��Ջ�/&�v��`:�n��e���etu�eƳ,xږaG����,=oKϻ��ϻrś?h�0K�۲�m὿���,=�XO�2lI0K�/|���S��f�#y�,��	��@X*�bo���\�uʢU~�E1�bQ@�Xh[��o=E	�E���J��[���*���Ra,%�-[�ܷlὯU~��E��m�Z�-��_���*�� ��d��[(}��T��bz�Y(?�AY��o�(�[,
�m�Z���(c�h��b�]�U~�|ޕZ�S*�Ţ�e����-����o�³h��b�mQ+�����Z�X ӑ�V~+`�/�F�x}���uszs~~}q��S���i������4�pF�4{��L#�lN�c8��H����P8�n�`k/�Ө.��F�q�ǐ�p;ÜV�q8�v�����3\���pƽ��m9���񈿫`��^�8z���<;<y�v������ѬoN~lNOF;Y�8�
�Eo��a_���y�
{����k����UV�.���.+쭈�U�s�
޾�>n���5���W}��������h������5��Ժy��w��}��XuFW�+�+$�{�� !�	���+$#ؠ��lP�u��gWR-]L���b��P�v1��lWH&Xw���IF����+$��	Y��~7�S�WJ"�z5�k�����d<34h�PQ�+����ʌ�L	_�f$lU���S���f�?��5�A�ZeFj��vœ���2#eI���UP�U�+"��j�UV�PWU��\U�UU�ո
zKS��dq�����a������të������51y�����ί�M޸���&�s��,^���"6�cNL�*b�;����9���uΠ0�uN�0���+�4��
^�D�7no�jb�����^yg���5>��{�5��&�C�>~urv:���z��c3o��l����UC�3�~A�s�߻���q�=�O��g�%��"�^uѷ��KRҿ+R~G��$>=���`�,�d����{WfC�\|޻:��^��6��p���i������f��������?������?�L�?o�R��i�ӳ�lot�]��M��JP��=x�v�t�S&���		�靄�OBB-�Ą���� hBBuDighHVG�v�0���`B�r�.��r�.�CuLjgt8TK�Nq&$���jGo�㡺Nj�;�Y�����DT�w���]l��$(�@%�/H�UKXTK�š��0�CW+a|!b@BuD�/Q YQ���VKh�qXV�P��8TK_�P�øwG$��Cu�_X�P����,��Du}ǩϬ���w�'��&�v��x����O����ʗM�~������������H~�����=鯞���׊�w���oI�����W�����I|zN�a��Y����9����@�\|���[��xM����jj�2'Ҍߏ$���-���*&g�f���,�g-}�S�H�<��E��˗S�{"���}<!�4>��d%���t<��4�����ǫ">����w��lx��l�E���nw�j��܋�,�����Z=��VX��9�3�b���X)��-�9�H�Y��Üa���0g��c}���s+���a���-`�h	k�p�
G|�=�{%�+q��^)�K��ͥ�-���_ϯ������ڮwlx�/
�xF�xf�E��������t<�x�x>�{@|:��!ܦ�6`�2`O ��:�=��;���S�+A<�����`��u�.�N�&Fb�~��i��)~�������(+�ר7�\}H�>��ҡ\�]ȮEH�e��!�V�g��u��ayָ��\��]!���}$6ƕ�����#�w�+�14B�w�:����7��Z���I�(&��Pl��zj;������PBɶI�	[=%�m�Fl���Bk#6�R)l�OR{�ͤ�	ۦ�Z����;"B@DV�6S�P����@���O�Ռ��=������������͟6�_�|hN�nֿ���V�J�J�x%+,g�$g�$'�be,�O�#g�����㕶0�Iq8^��k�$�M�g��OR<�W���$������S�"��d�OR}�@��d�='ߋ��p^d���<�Ο��T�}9�a{��d�)��.�<"�K:������bvI�x�\�A>W�_�IA�|F���t��%���k(���G�t���y�|&����=���g�g��\�\ϛ�шh(���s�4���3%Q�YR��w���������ɦ�����m�����#��t��.pRX�a��R;���u�q�Y�V�Y����K\W�[+\j���8=��D���xn���auI���߮c��A��]����������������bo�|�F���k��������槏�o~����ĕv�L��A}͔:ۉ��N���a/�Եۅ�~'��;ɂ~7��I�v�A�̔����Np�In�v�k���Nb���Á$S�n�u'}�߅���)S�.j�p$����L��.F7ܼZ�6oϯ?]\]>jm���2�ZSa�Xk$��̡�F�_5.3�[#sk@0�WM:�[k4���Yb�X���D�N�5��F˩�v7f��5bw�e�P�e;r�nJ�5+ֈ�Q������e�	0k�&n��������ϐ�ƧEKh8,����� ӊ)��4������h	�E���,G�"�㓡���4`	�+�p��0�EF��,Lw!4>ZBw�i��%t'q��� -�;	�T��� +Mw2L줠����|�<�5�ؐ�0f:\��:.C\F=�<���,Ø�p	1f�R8�	1fLJ�_��Ы6��^�q<��jp<d#.�k �ed�GB=5�\F�o����X��Q9�����=���˿�..ߟ_Oޞ�5g?nF�曦���O��?��>i~_��f�hn���|��G��H���	�%��%.�%f㸝%�u�%��8����{&=�W��L+��t��8���*]�.]b���>��t�-1?��L���v�ʖ�]{�Wv�O ��b6y����I����@�g���f��k�^㖺��g���׿�/�K@ݞr�9ʢ�������,�b�q��v�a�v$�a�v����vd��J��s��7_=��`�Κ6����Pn�h�J�� ���,���������R=i�`	����<��1�_��%^�x�͸Ve�o�0��+0l�����6�z>��zP�m�zּ��z����m�U6[���M���F2�4�n�M����-� �J�-%�ev�!���~���t@0����_Za�M�I��ɳ]��p�/�Sd1&�^7�I���e�n�r�6�wùO�.�����\��s�{�\ "�o�sѓ�ns����\����\�"!^���a/�s�6�;2��S�F���L!�Q._,�Q�X�vt��������8�X��J�ƒUH��d�Y��E��z<�S�Czt�2�g��d$���<��	16>/=�i��6�e	q:>�>�G�����!�x�nLFF|$����!�����8�P�g�����k��MS�c,X��8��c�˱}����Ǜp}�<��8s.')�� �9)�9���p9v��k1�OR<;��O�]��S��4˽�� 77V��a��7r�r��,��;�.')<�1�'��:��>Y�|�,�H�1��	��ȁr�B\�WĮ�>��p�!�����!/�Bh��5�Ն�Z��
��*��.�Շ0�#v����W�n��g�����q'B#*VEcѫV�ۻN��h���:lK���Qz��E�eQm�QPq�q8�`űP#7DM4<����3.�N���"�j�{�Z���"��cQ�T���"���hxt&�Y�fz/�E$85!S�w��r���]C|y��y��ŋ�����t�_�6W����y|{��F�r�nL����j,jTb0��A�J}    -}m �� �Ҫ�A�
hk1X�bP��Z�Z}��J�TP@u��ľR�a�
��������R�LJQ]X��Jc��P@�(n�Tb�vg\%�aZw���֝qkI�θ���Pj"��Rqj#Q��8�����@�θ��8���Zw�T��2�ruc�N&낶y{М~9��/f��I�ټ��a��js�l]D�2W f_�=ټ��uU͓�[�\����\�j�l^��m�X�]e�u���~n�[�\�j\e�e���0�/W���Cs�\a��q.`5j�����5E߼�֍0��=�������{Dפ�y�P¼��	K4����0'�98%����-�L'˹���̛'8a��>'̩ќ75s�N�SY9�2CÛ*8a���~.R���ޔ�	K�Ԫ������-.μW��B�R9b�gv'?�ٛ�Lfo�5�+l��
�'{/&��>b2���&dV$�Z�����j2{or��ޛ�isM��kB��5��Z��\a��>b2W�����k&s��*��_1ó��W%�=�֬X��7rC�Fnj��<��D�k�f�Z����o䦙��o: S3z��4�}�4�LŌ}1�)1��U���A��q�� ���431�US����
Ld�I����2�0��af�ل�r�\�03V��+̌3VX"f��jf� R�=9��2�֞�Yd�=��4�&+��,ff`1�� {�f1�fOA��D̜ɑ�g�=���Xa���X5�ɑM��&���lC�T�{���)�F�MSX��|�4���a:�M'36�L3٪am&ft�4�e:���Lal0����7Mal�61�z
2�%f �7�Hu@f��S�),54R�F�2C�^=0��n<x��_W7�f��닏���pq�=�����źy���w/n�O^�{���F�rHC����S!�O��ϰh8��H���ۥ�H�h�u)��rtIAw0��HiS|���p*��2K�%��}������5���nJ6��2+j���t�)��R��`f8}���lr���z���l���A��ڇ۳���A��,�r�h����1���3:�����i���W��~�r�4���4��th��gt4GOCڳvG��w]z��6�r�!>l�h�������d{�o�-��ӳ�������O�W9��M�����_�7��Л���Us|�hS�6�F��;��i-��>۩��.�o2`��w;�}���4��]����ҫӝJ�eDn{�.��|��w��v��e��4f�]꾝]v)}���޴�m}�i�n�����������������-y�����f^�t2�/Fvw魝v��n甝֏n�u{5y����I������d��������Q������?�L�<k��:��G��rnf�(�,̹sF�����3�(g��GBG(	�0B�.�ن�\����*��.�ه���vng�(gܟ�:�G���	���\�v�h��+u<�g�Nޜ>m�9;S8�?o�Es����l3ⴣ���l��R�
Y~b���L�F���@�:����c���n��|ӄ)Fֲk��M�&��I�H�dX �@�C�K�d�CW`.@��H�U�P5�|��x�%W6 !���E�\YQ�ȕ%{���]���IW�8(�ڷD��s��Q3�s���PCF�
��+��4ݕoC��W�/�����P#�tW��i�$�\�j�4rH*"�o}Z�e��В���Z�k���X�[����v�>`�<�a�jCF�� xV$6n�hLC��
yyB��ET��}���1�P.��Lα�G��n^��M���g'��7VO��#̯i+0�\�9�k���X�⺮��Y�A�%mq`���%���`�8=���z�0��u88��Ddf�`ux!R���_GJ�v�Z�,Sk��djmW�L��o��ek;Eju��LMyG��+[IyG��+c�����}���ڞMYoʗ��\Yo�Zݗ+S3z�o�
5�7���\��C��A}߭�y��pQ�������ʕ���*��~29����'��+���j����#+�.�n�t��dr�T})T&W�dd(�Ƃ�L���ɺs@�K�29�Uc�O�*i*b�R�LNIF$i*���E�}P�^��q�|�9zyvx�r��h����X_�?���5GM��|;w��*F׈V�
1}�Q}�Q�*��y�]6���9ᗃ�*I�����FL��m�u�1�lr��x�O��{��&�� �I�>%n�u�1I�q�û�~����?�6ϯ/>}�h޼����o�����y���������������W�'�����䷼�C�Ov�ב��f����1��k�jͺDa}&f}f�����U���<�ZX���2��Xej�e
�3��'b��%jv�W���2{@�����VK���W�N�M85��ey+l��2	��S�$,� IX84$a��ULA�f�t�ŧ IXf�Ƨ ��A��$o���$,�$��=@�,3�S��Y���$	KĬb
����Yf�OA����H�S��N�M85ѵO�v��q�������^����~�=��?'�	9`���� d�����	��SS��'���m��E�X��X�6FF��F�����K��~	F�����#���vFF}��3�8��4!��}���f�m�	�U7�0����ٖ�:-�'���Y�1��u�@��A*��*謟�*���*8���8�W f4NA��Sn4����~H��3�q��@Lx�:�W� e H�9�1u��t�)�&���_���N?�?~}��e󤝴�)�������ُ���f1��>9_��3�����3�->�h�/f�}���<�l��<�����<���%�w�|O�Du��:�ܲ�:�ܲ//����}A>�|�/f��hm������<#���!����V�E�n4����Ͷ����!?����~��i�����O�O񃋋g�}J��z*���=h�V?]� .Z?r������S���3���W\����:��=�K0>����E���(.A?hs��?k���@3��7���j��ճbJgk���1���21"�� 
�� �f�Bkp+ɚ�
bB���Y��lN�1��=��L��o��΄��^j�ya U7��#o�o�ӗ������v,!/����wK�B0�o:�5!������B2����Z6#��;�e����B�[beL�KbeL2"���Z�$C{��,$���~Z�'5���X���,�/���>�y�$ r��l�u�;⃮����+$$>��
�/fv͏�<�Z���G����G�%�w�j	O�"���E���E�//Ѕ>�}A>�2�/f_]�#�E��/�>_��|�.��,Zw�qM�8�����mSS���BطTQ�$I0�~���#�,9�ɘ�c�l9U����	�$� �}K���3��M�� Y9�˘d��}K��$D,�$Gl
�	Ⱦ��BR\���)�f��]�0�o 88m����~[_7��?_\��n<�������o��>����7�>���gm�>��ssѼ=k�v�L��)�#s��$��l��l����$�d�}6�}v`��N��U�S�O��6�e6�ٙ2��ؓ�mO�-�ώ�>�ᔜ$0=j�;P���0j�&צᴝ���cAv)����<Y_�r��[�����_/�.�'�Q���Dư�b�f1�E�-d۽+���u!�>f[sw�$��U��5X[�/ȶ�C�Ţd{Zc�cH�!ۆ��b�-VK��BlA�2�ޅeLp�k0��t���o>�+�?~���8���~��>;�����hq���8�:��>�=��M�_�\e���ï2~����_�K���d��eI�쯌?�r�W�͑㯳_j���+��I9�Z����d������c����v{�n������w�������N������|�����������??~*�w��_���}~�����=߫�>�]�|�+���_��.�����_-~����_�����W�_����/��w���7g�]}�l�ϯ�N{�Es�<x}�ms����������� �	  ���W.��3��Ubf9b9bR�v�*m�1}6}N��I��*�Ak���`���&'�W9�t9b�O�)�G�*1Iq�S��m��B���oUɐ��Rږt�t���Qs|�l��������&������v�$l�$)�:p�$	��!톀p��A@�A[>��L�	�IJC�I�v�@���	��I���@8�E�y����F&(��O�`lg$)/
�jA�iQ�m���z��~�����]����|#H��\��E���X���E��9^tk���)2�F���"��$�D>�~��W�V��Zd =m����f�����{�(����� ����	檪�5�ͭm珦��o;���Vڼ��Ԗƾ����wTGZ�����#���/�S��9�8��������ﰎ�T/�ﲎ4r�w|���^�H#�~��a�qi��@��:���Ԭg�{i��[Cr��!컰;�|9���V����O�P�B�7ￛLg����QӼyqv������z��.S�,U�"UZ*n��u�RuK�m{"]�����q��J�����sy�mϣK�����ي����>S��4�)-7�Rk�*�"��B����	|���v����r�p7n��9o�?���GO���N������|�9ܮ�)#%(��"D��9ܢ܍i-��{�-�r��E]�+�����X���O�� 5�����w�}�&�q����S�E��7�K�������ޢf�n�_)X��L^J��-����|)�r����ME~|�ӭ��G�
�~a����]a'����#�b�}��+�G�e����4��O�_:��	��qy�_����"q�	ā�k1מ ���$���G��>O�?�z ����`�ǵ��-7v"51�J�ʲ�Eі�;�aѺ�Ţ `�(8[,�-jG���������w��,�yWj��BL)5�R,[�`��{_k�-<��,��X,����% 2�j�&P�ay��g�O'�O�v>m��?�x�v}}���i~�z���w��s�wV���୰w]4�b��0�O���*x�8��ܸ�ò����FW�q����ǹ&&+�wUS7*r���;lʼ�eM����l�ic���d��D2L7�lJdB��JGdR�u+K�HY*.Q��T�D2޲Ȉ>�*��R�YX�	�/ꆹ^�h����+��ʹ�6�:]�	�6]���pA�U����:j��x�V��Q�1� D�Q�sA�u��jP�>��ZC-tD�Q�]AzF
��ƠA���!=�1(<��P��{��vd9^X�y��vq����*;�'4�/h�4� |�l�	=
���>a��bx����}�H�E�.]P|���2�h��O�� ��q-�z.A?���7Ǔ�����u��7o_5�rq[r�Vy�CYz�)Ä����YV4ˠB�,K�|�)�T�YZ^��-���x�;��<b=�a)�Y�H^�u|���+�mtDYxWv�y�;�Z?X=~zx29�����u�}�l��i{�v��ڣ�	z\�{�V]�9a[G� tX� �]1r	ۆ_�]ږ��{�s�K;#�%0�	z�o��u�~cl#b����إe⌱���#꙰,��koɔ#n,2��^$+�{��|y� ݤW^QZ�F&�	ː"��z,���+�T����."Y��(�V�A��a^�5D�02�-M$�t��D27,��%����]t�Π닔��[h��`K��G��eu���,�(���Y�Z��­qY�,b�)e5�d�RV6�"O-�"�,��,�tf<X�=Kg����1��P-b
g&�
iS�Q'�L��T�����{zvx��v����۪����r��A\�4�	���؆�r��N,l�6������4ʭ�q��\n�5tf<(l�6tf����1�s+l�6�)��6H�tD�IۡwSE�
$�м�^���d��ٞ���*��Fh
c�22��G��1�45cO�������2��>��t@f��G��dO�3�����g���ef }£�Y�0�,@SX"f-}��),5�2{ }�),54����N�M85����??�*�Q{��bo#�YhŜ-12���_6���.�b~I�3wȮ�m�7��,�������G!#F?��x#���(d[x��72�}g�����|Xڻhd� ȁH�σl�b���Oxg��bV~��BLa�SXh[�ʯ<�
�Ŭ�
�J�W*��4+���U�+�[��Wl�o�J��Ŭ�
m��+��_��7+�� ��d�W*(}��4��_�B�#��ؕ_f1͗YL�e����O1Fd�+��»Ү����+��/#fV���}�3�e[x�ە_��g�+��B��T~�%�>���/�@�#٩�r�J_ ,�]��nѼ9}��i�,�@��z�^�%��k;e5zN}G�&_��Ы;�5z�_�/4{I�;�5|�]���s[�_۽��O�W���?I�����9�[�W	=�?����|��œ�O��
Z<��
���������>0�Z      �   L  x���Qo�0�g�<n�H�����[�J{A{�Kl��H-0����g-0�V���(g�g�܌��ww{t\O�'�z��|�aS�������˫����,<>�t5�NYe��bSo�<4+��QS��Y=��b5���w3|��_��j�����۽M��rC�JU���L����ʼο�z��ng뱹���	2/fOM�E�f4�S0[�W�\�����e{�uo�4�N�lW��l	4'm�e-�k#`LRlK��G�<�)Ec*��68�D��Lc3�u0��4V��q;q˙:���2F��|���^&!G��I�@ ����Ay
d��V�H�M~N�Y�1x��)�;����5j�˄Aۛ���y��ag�%`>�>�:�m"�O��8@DO��?�je]J���t� ޹Sgw�^��K�t'�
���!��{�����.6���|����t�����m �ݾ�M��w�r��	��'Z�#�"��?Lʮ�_��D��b
�{�����b��jgϝ�m��˻y���n~Ƌ�^��e������C��Wv��x�^^
�",��;p������� �b�(      �      x��][��6�~V~�������V��e[�Jvu
���0`&��	���wHJ�lw���$h�YݤH��w�\~�ɲ<���؜��K֫e�X�y�������_�%ƈ\g�dER.W����嗿/���H�ˮM~���w��,ٷ�n[�����}K��z�*i۔�tY���x��	�&ϔ[��Q���.'�n�VUZ^�M�U��nU%�r�^��f�IN��SL�KS�N,�n��{p⳸������0;��?t���������P����CY��N��;��[��%+�T��W�,�^U']�6��-W�	��b���Tmr���"��/S2����fY�ߙ�] O6����>�r�6���W��"�}$�nYh���Lc�����@Qe�޶e�,�}�eZ0�qN?[��h;�I.ݶL�����v��f�J2�+����dI�.W)���ܐ%ǲL7ͥ��	�z��:���k�.Y�u���$�e�.�dU����Dn�n��<ocT�fWWU��7�=��J�0����{���/��tk�W_�w8G�^h���hV��C���H�M�})qv���d�,.� 9�j�M]A��s���<�GйjO\����ydv����u�_��CZ��	O�
|��[a���5tr��.����Iw%�F�b�9� �p�ˡh�в!���p.��v��v����r?��Ϛ�ҹr�U�J��wlB�O�h4v%膏��c�n;Q�dBf���)�n�7�Yr�w�j�ubv$���Se9]����h]�Xۣ��3p�L
��,�̹�ᅥ�/M{X��Y�$O!�4�����Y&[���e=��O��ݠ�4�;��mA�Z��x���Ԙ�l��O5ā����bo�hÍFOl�1$Hx�o �������\~i���N��G�'{LSC"C
_�sKLJj^h|�r�ELc5n��^����$�]^�M;bE+y�2��&���7m @MѠ0�`��C5+DQpw"87R�D&�^�%���ٯ_�ߧ�\v��Y��Y���Ћ,���?aJ&tΥ�"xGB�FO+H�ʟ�7�N�\�f���\���'	��q�gi�ku�+���i1�x->�����.Q�<� .��5:��'�IylwSd~Y5^��%��v_����A�ȓ�A����	��^V���f;��$}�r�!��tMΊx��XLH�?�˴�f_�31p;��ۓ
�"*�9��6?�6��������vH ���Ve1�*��e�i�:�I�t%�"@"�D�D 5�����A@'+�����b��
��P�2ƣ�#��,���h73轴���
P��&&��S��r�W���&)�i�QQ��z���\�p�~��p?�����,�9O�ig���WM{�7&�)O�z72o&��|���L-��:=�ׯ`li_�G�Q�����\���,������H��ۂCd&���&l�h��Y��A��镄��Z�#Q�t�<���������� ���y�=��	u��~9f��Nq�O�<���I�ͥ�ڽ �b++�8y!g�4%��=�8��j�*����{*� y����AgH�
`�@0���n�5�N��k���l,'�����ⵊ�x����9�K{Y�^v��*Oc�Y�ε2@E/�`�Dko����b�VM(������:�d���E�]ko�:]5���P��~ԛCH�k�x�*,��_4�%����D9sw�M�혵�h5���r�4��W��H��n��ZLHl#㼿o9���w��ĳv�e��lғ�^���z�
T�������5��v -����vf�*�p�3F�u]��x>��oޣ���~`]�i4z��c�M�&!�\�O	[-�8�[+�a�<"��"m���>���-=��n��`�t]���Uy�g�@A�֖�����#+�~�a�q=|��R+����d�Ɍ D1O�y�Sw]9 �AU��A�(t�9�T6��0�L�{r���D-D�TԺS�+2��T�N	�F���䆧�t��������̝�����έ'Ƶ���^�QL����_�̢l{�!�s���vc�O��I� y���F�䪞B��BBB5��s$P�����C��E%��C���s�9K���?�Dy�l߽y���%��@3�.!�/���͛t4�RA�\�:Y!C3��Ȭ���0�@$�6]��./f��s!to/��(�pD75�e�:!�3W�m��b�ݖX�pnK7=�Ӻ�nC���2p�H���z[�[�ѳ��8���X(@B*�Pv����%�P��qJc�Џ��n �Ii= [���%8�<�^�E��?,���eh+�����h�P�伭�/����z2x ���,��X��d!^�	�C���0�q�rzg	ɭ3�4�׹�B!&p�
R�(�C�_$��@g{96�'.�������x�v�e�����I��'��!/KF�9��|O0�L���_ȟF� �
d���]+���TCT^ŻL"����b?�9�4��Oɦ� w����<�
+�=��IC�r�G$��_��[���6NՉ��C�3���1 9,���(��n{*���L;TZ���������$'��~��2�(v�h�s5�(2��a�a4�ig,��j&��s)�r���xϸ)�����
��
�E��j!O���1>�\���V�\����XY�2�py>�r�)>���v����K}�b�K���c����œ/m�>�;c<t\�C�%��X�)���J�t�3:�%�)t|�J���5f������Q�vUA�3Xc�Ɇt������0����D{p��l�'���Ͽ�����># �EJ���6˴��C�w�>�_Kcr	6X�36�΋!��QbDK���	�o]�����S�9]��,������3N�@Z��'B���%�Xc0J����^��h|VK��[��jKKZ� ��**/(b��&�����^d^�������f�4�C[L�!���SM(�齪�Ym�`���i���3�+�wŜ(����	l�I �Ǆ��>��f�/1�hFZ>�1H��w	���C��Lg�У�i�Ň#�NU|��]hK��-�>��~�l7��t����d�]��ڙ�jB��@�y� A��o}�h	�".�C�$���	$��c�YT}��pk�f	2�'L�M��&��aQ��&�\k6����Cj�;4��im��O����(Cl��?�D���Hh_�I��42���{z
���O��C� %"�E���U��O͸J������b�>s2�������*��86��B������'8���NJ2���'��0I��<��;@�-�WM��(QP^��脒-����ˀ��^~����a%F�Q�F��ҝ!,�����rdJz���#��P���`i�Z��ŵs!%Z���pst��M��2��:Kg��u��#�g" p�ڌuG��RL`J�_�8�"���A��	���W�&�	x+�G��kb��,��L�kV;J�����p!u���NƓ�t>W��2�~�xN�֣��	��vԘ���<��QݗrW�d`�48!�� g�+< ��;��e�˄KX�e���5+Rn�~;U�;��Z�Ԩ1S̀�R'��~��M�$�����.>���:��q	i�q}��`�
�h���n}�Օ.Jy�.5N����\`�A<>k�I��������1����W�\*#,x���+���6�v�P h�G�,ˁ�qV��xi"n��-�������~����D����S(�_��r!6@�W�$%%&U\l4#�I�lw}�"LAZ��C�w"�&�cz�ԝ�r/�����2�~���L��؋MuByA"����2}��2�n�x�x
y�ί�c�4[�=�hY�L��th?�a�����ǔ%�F��:*��fǯ���۫z�������;��3!)lF�&`W�"^�*Փ�U�x*{��#�y��X/��F}Z�A���T��>���wӐ2W<   ]�����1����er[�9x�GC�<��(R+ږ�̊L�ޔrN�ba�H�E�Q�A�zo?%�����:Ҕ�4�%k��Si�re�-��cy��r��bh[Nj�gAYn�bVJ�x!aDF��cq�ʦ抙��C������w����Lx��y�1������P�v�_8t��8{�#^����k$Y.]*I_�29"]�\IÆ#�Ώ��
j��4w��T�u���n�H���*�������Z2sV�3���QeG�oj��^��C��(.��64؛�Mi�������k�4�
��rM��Y^'�L�J>��ŝ��@���e�Ղ|�0ι�V��-�a�ـnN+�%��iQM�7C�s+��2d���<��Bs����AF�B�Paq 5l���#�YΘY�a3��;�BJg���� ���T�sYŘ�Fix�+;�����*~J�Xjr��
 ہ�=��C���XR��[�����H(-��Cwil����翥�K}�ml�t�hfv�0"�8w�S�Z��5�)/�y�!�<���h<���HX���� ��W^[���G�����MԵ0���OK0|3��H6į�!��dͥ>��.=��o����_����<��Q\M\�ld�9���z�i�Z��5;���}������3����G�ҧU����6m��i��5l
K�ET��acGc��%���4H����J��x�*ޅD݄�CY�$�=����hfD.qyI{l�w�J!��=�˶������6Z�{�7I�D�u����8��sP�M���-�m:l�#�L[���z��2)l������R6��Iz���$�e>z)ŜO�CbM��\��V�c�\��/cqp$� z�V��̈́^�	fx�0��\��X^�m
�.�ky��9c~���D[��JEeZ�R�� ܲx�'�q\�V����)�W��I�Պ\�AϞ<��e��q�A2o�>�=������b,��N��>���W�5d6 �����q�˪�z�l�C���&QB�1�$���ρ�L'�b?FV�/�Yq���$�I�F.��}��j�Z��n7�O]�!�T.���l�4�h8~��w*�L�\_1�EhuīSF�#8��س
��_ L�t�9S���?9�1�h{�-l�J��K֭=#㺲}���e����ĸ~�]��JXٜ�*�rbe��ȍ� �1�!��\ �ƸE �B���!�<��Cq�e}�Z_�ͥ�cI�,64�x���X�=�
��_���*&#�#/�[��m~����$��t��)��120tjMݷ� �m���v�]jQF������* ��XO<��沶Q`��d���˟���&�^q�*/r�1,��r\��-���9Xt�����~Z^���h��Tb�Xm���"�m���\P��C�+���t�0;���d��AHJj�?�_Q_{���<&�#��ZVٵ6�;Ӄ<���P_2�S���h��'���b�}�D(�e�'b�k3ߌP������͚� ���Xf$O�����Pj	��vf�80�6���p�շ�t1cV�B��ÛL� Z���~���5�p������b�OR�_�K%��r���So�/m�x��� Y��[ٹ_�h�*:���j����7,d�F9D��a�'��U^[��)�̥Vl���VP{R^���uj�%I@����ʾ�q_�7]~��B��S�D��v����-� �,O�{�wj��x�{*u� Hڣ��_�Cl��v�&ne�[SW�k{���:���o�|�/o��Ӛ[�[�M���5���X1_���u�Ԏ�5F�i��e�N�~X1�G�P�C��k�;}U�%���f�ګr���$ʩ�Πj`(��*�`����N�z��J�T ߇��En4~q7Y��]���)�N�t^I6zc�ծ���kȩ�u|�k��[>����z��E���o,t�;[�+_4�g%���g�s}�S���?ՠ�^��衇c��:����Fk;g��X�9�m"��rn�W�� �6�
��KY�2;ׄv���LK#�`�A��&1\�D%@�*G��J�jDnj<������%��T�GZ����U��W��˃���v9��5کl�.�� sr��%��Fo휌cJ��+3�MI�;ټ�v`}�`7l�Gt�0L��3$lǜgc���3趦\����.�:t:���Dp���f\�¸�fO�/�{+�>d�^;��}u�����NWm��9��p�uqӅ��C�3CO ���j1�F�[O�#������ZR&4�4�����a�7�?� 
s����?��0����'�k҉�o�%e��n��3��}�=�+sc� l(����΅+y5e�y�9P��M���ׅ��+ȱͷ:�d��p�lbb�fi�z�Q+�ؤ �`�����N��S���Q_�|�L����G���ּ<8�4J xK���|ISr�w]9�1_o��LvA�V�_�i������u�#��է�� ULJ-�z�o]6�.�㇅���E�`�ѣ�L�<��m_~��n=?��z� �(�N����7�alFs�\�:
���/˒�G��/X�����0')L0z<�\Lϟm5uA��r��7�r�`��b��W��g�	z��^�~Oe�Qxv,#���r��}s��B&�،�cPl��J�W%Ɣ�!�SPW0wF�+}�����<��+�`��l6(_���d�	f�I�N���d6�����韟�M� �熞J}��nq���l`Jf��;��̥�Pɪ_�ψ�P�˯��>Ͱ<��J؝^.�F"��`��R�5�?K/ -w̘}AV.�i1E�@���Y�̝��NQJqS�D	W�yW��D�
1_���<)���j�4��x�|�i����ٗX� ��6���ڿ@�9׭��BH�*T�*�I�<H������m>!zn*y�o	S(S��flF�E�ϯ�&���P?a�+I���h �eq������������7s���
��f�Ah������;�j
�6���MC�>�;Bm�}J�;�mQ"L��>�� ��t�t9��簠�E6Z���Bʛ�k�O�J-�H
��Ƕ����B�v�B�ov�{�]���{�܃G��}��,fz=8۷֖���3��[�l���sJ����>'dԽN/zW(������^�N�P��IM:��T%]�s9u<��)y�����~�[Pnq�������S:�9o�
ʜ��ɴ�JN���u�3݂�O�����x�뜰���?�^�9�����ݩ� �o�_�jp�3������ ~��й��ۭ�ҹnD����i�=����HCR��s҄�9i�v���>�E9�&�AeW| Dh���i�+L^���H	����)ѯ��Ŀ�M�\~����iI���������~��?��˯�o�So�����{B%G?d����Ӄݫ��Zk�3ɤJ6�6	���������������z�/��73Q L���FS�����w?/����̴p�      �   �  x��Vێ�8}v��0al��yZ'dCn���H����	�i�����oiu�vR�u�|���Z,��
��>����~����Y�M8#�M�����������R��YR��Ec1��f��"�i�̓|�!������P����bׄ?X�N�$� 0`�랖�@U��־��2�D��`�����
_ު�V8C$S�d��" 6�"jQz0GfX4k�G�aM��S�6!d�5������	ډ�F�UԲ��`��ط8��.\�����,bR��C�Q f�h����7�8��3 �l���G�a���M���N�#�C�4��~����%y��(ԭ[�ޅ���
��6��Ew���CK��!����C�h�q���Jo�j��b7۷:Ɲ�%��)-/�s��Uv�˪H����m��&���\��k*��Tj��A"<�<Mh�>?�O	�Ҳ��O3�}3�d�0x�ę�:���[.e�	o�z����#fx=�*��}�����}]�6�qf�٧5&�5ܚãK{+Ҫ��e��/����*ӫ����C%��d����" �ivʯ����^�n.�;|B���҃�X��E}�j��MY�E2Ƹm�K����́�3�8%p��aWݡ7b��������|J(&���l8�?!��9��Ϥ(Yv��:��<>ż=�G�yɞ^�Tlk�/��b�*N�\��Ef�-#��ٜ�@0��.14n(��#ح�F��[Fl���C�>����h߃f��.�\���*�eܮ��7�7�0H�ӨWg����,�j������kY�&A���뭄g";��F�`یS8�87l�N���9���3��gꉳ4��ۖ%���9�ߨ}�g�Uf�h�o�p����-�����)�1��u�5.=�oE�d��(��#&D�eqi��Y9�NL�����a}���d2��7
�      �      x����r�Ʋ�������w�H�0O*�L�W���,E��������q�Iyź��P��Fw��=sm���j/��Q���v���n�x�[��8�5�Vq���~%4Q:R�3I�q���r�R\B�էlR_)�����]�Q��+���9\��K�/��)Q1�,Q��#j��l�����׶���o�y���M������z�ަ�M����pE)A�����a�G/^���l�6]M��������L�0\���%S����q���t��n2˜A���f�\��kV�3��#��81<dOpԇ��I��n8���,]9@�XS*#���/wEM(�	k��	�Z�As2��5�y�ڮ�Y<�Φp���F����o�O`���3WE(M�cFٔ���!\��u�y:[�KFw7�Jj�\�=���5	������+|\�ট�m�.�W
�m���~ W�~�� ��qe��I��2�+_����M���23�����ͼ�f?�	j$mvU,�X�Ϫ�	�uUg�q9u�@���V{lǼ��9����JM���>�ncj�Q���t���e:���$.�G8`ɇ��}���	~�$"��:���Oj�I6N�(Nm`q���v���L.5#�%T ����|i2�4�ݝ�v���0e-NI�P������/9Mx�B��Yr��p��ɞ�r�ڄ�d*j�
v3�<��� -ĺ���v�i��d�t;��j$��-�dM&���4�u�S2I��/E��"H;�l5I!��er�y�� >	�7��Z�~��2֗#��Q�ޡ��uΜ@u�J b)�k��������&�:��"�
�,�L�DZ4]B�d�A��R����X��럀,t�Aȕ�bd[1ʟ����y��\)�qG9~�^Gm(�%���,&vD�K�RSP2�d��YO�&_vK0���*��,B�����dx�O�j�zMCI��rd�r4w9�TM箮����P�i�]��~� �vaF�ez���꫐5�Tq��>ۢ`B0���Q�ňR(���`�F��jd[5��_��[��ϥwZ
:��%�A���^�s����zYX�$�L�� Ty!��I�m��eO��f���O�{]�Aylk�e�$����t���*I�Y�%�U�d�w�-6(���%V�>�b� tZA6=�2a�2�
�|�n/�9�;��YTFs�.gH��8����`�
�}���얝��t�h<|�BN�i�s=Pr�9�$X��>u�<��se'9ΔR�*�1�`(����a	��c�.K�����mV&Ī�EML�{^u�n�M�f6�� ��U�ˮ�jt�޼�#ѡ��N��aN�hFY�
f�c�ʒ���/����q_�I] �EЌ��kq�v�X��^eA㣵�2O�?�خw[.Rrl���������pa4���H�D!l�f;m���	�W�m��z��j�I��:O�e��,'PKZР�6o��$4&��KI��*���E�����0������,^��CqW�>�=��"�Hq�1	�U�1Ѓ79��	z'#\�Al�_�6�7pU�m����&���W��SM�O��1^���h8t26"��H?v*8�_�5p��:��v�Sps�kr�Ǣ����M��t:�n�� 4���b�����.&u%�I���_�V����'09��	ʁ�@A�@i d\p�1^�;����%Z������Dgt�]d4��h<�vp�S�^b��4&�HF��c-��˟���e/m֐��\%��X�@*�b�� �)HuR�D+�i?�W�ڿ�n ����[��ٺ�0,�� �:����W�*&F��l�b4��Lø�d�54ޫ�6�d�4v2����N����ވ����ti����H�S	��Ծʉ�E�vD�����������ߟ��Hi+Cì#]��[�%qI
!DFL%�ҀZ(���"�j�v�Í/8�/��*���CV�!}:�p�s\�����j�ˡ{L��
�X��*�Zʧ�Y��;���$���ub�ȸ���u�Ϡ�II�zh��z,�֗$�JR����~�^I��Kq�P��fC),�˺��2�P�M&�5@Aw_�ݧXj�	�����z�cܯ�D>N������W��s���r6(�@���BD�*c�
�ę�����=R���|$�;MB� �L_�X�I�����*]N�	�*��8L�:��?�_��������}�CC�Dy��a��V	4��3_�X+L�t�U�\E
yT�~�7�����O���"UtP��PP��9Z�"�V����?�.�M����ǫ���)��m!ީ7W`Q��|q���'^-�@t����:/Ae�M��e}�b�R��������v�5��j�ӷo/���	lhO�n���K\PV�Xz�B����R�Z��ݤs��es�8N�J#oW7���6��5-7	�bPN��z�[�
��RŞ(U89�Nf���`XL	���/X��1�o'����E�-4���}���zy�?~�
f��P�(�^�r�h-4���ӑs��wd�� �)4B��'q��b�U���f��2Ї/i�D��!^r&/?��5?��Fu���Ծ�q��Iv����A87V��>g&9.%�����ꖙ��
�[�kz������8d�fA�,]Ը�:(�n{��[�����V�`�������[e_߿Pv?/��lઌ�x�'�F6��\�z��]o�m�^������,�(��F��볐]es&r8��B9��Ƃ�p�E@_�x�i\sw ��͗�HQX��zzڭb��^��{ 8��N�&�s��� a}E㭢��~�W����%�1�p��7H�_�ײ/��5Lt�y���,� 8=��x��4W��C���{��*҇f�`�C�:|{Φ/��q�e�g�:}ዏ`g�>��6��$CQ3
���O�m�׀�_pD+88c��W'A�cLa7K�a�$�����Cgl�����5�	T�&8`v7��!N�))��0�y��֔������-}A��Lv�/�I9�i��?�� �Ϊ����9-��q:�A��U���r"Z99�Ɨ���.�ȱB
i���H�q���P��
���-_���?�m>���0h?��qL�L^;%��ŵtGRCV6� �׸�g|:���gp׳Y�]g�� �=^e�ͳ�>���8Ɗ 	cB.�V/.�sنkV�xS_���Guo��s���ي�c3�H*+��$��$�l�-p�ϪW�r�Ks�T`�����1�"�X��Q��6d׳$��r�v���HE-�Lr��.�"���I����a�d�'c���� ��s<����j�BsU%�����d8�H:�"�>o��y>���_�-7�(�P�!8&G�'�C����D'yL�B�{)�y��3��WCE�n�%f3fM�h�Ek7���*.��A�C���t�1����R>�j��e��
� DCw�~�ꑤ��
A��/Rw��2s�ie� `����$r���3_d+��/� ~u{_����8��`�P��᫃�Hb"�$�no��|�"@�U@�*�{��,�s��d����`B;i�����^A�
�P)�ṧ{�Q���:��G6�Y����fT���������
�$%*�c0f �{Ȭ��˄���E�Ȫ�^�\N�	<[�Ø=���FR9z
��ԗ��Ƣ��?�<�]�ߠ�ۗ+�ؔ	
�������t�r���_�����Cج�mp��5�3C����q�#�k���$�\O�TΏ��]T�a|���a#�þ�D���۱2�=\��^���(�O��!n�J�p��p*AT��|.mh�� C��+K,4˴��+`_|T+>��M�����ꄴz
*N�]
v�]�������C=�Cr!�1�ޒI�"`��I��t=˶��s�N85�*���V��UmYo
;ApQH�F��>��]Jw�d���	��e�Ϫ%M�����©X��̉X�Qv_!�5^�s�UԾ��N���6!+���
��rqwDF���x�'��97cN��}�	nT�q� ����}�S]�[N]WV:�<]��   W�j"k��/J��Q���8x�054�ڗ@ݑ���b�VT�ȫ!�Z;����	^ڜ��J�ɵ1x�7H�+��}߸-�Dd��B���b�QdF�n�O��a�7"[���WD�i�vPU�qX���Td�Y���N���Z�nS���uS`�K�n�q�-�mS����v��g����s�!m����+�O|�K���	�W��}yԭ<���n�.\4�����A���b��hC������8�V�x��ת+d��*��������؞}����=�o�q���6x�w̸�,j�Iu9�`�e�J�BM)�k�(�s�򭡖Ӑ�Q��\�9��nu�<��Oh�Ѭ`�A�F�v�\����u�%K���ɇ��6]�vz������ƪxz�(�Lr%�;��	'��Z��?����4_�q�ϳ���P�SҒs���a��M&f@6����T
�I���U��EEM�C�i��GmH(O��W6>:6���>C;�q3۹Ia��P�$SX=[|v�ke~&/�h�����	��}�3�Kg�q7�)�p﨟��k���tѼ�-����?�C�̀dBg�=ӊ>�8��/w���,T����p�g.���"	���K;b_�Lg�~�F��J��3%��亖>3����XZ��J	Nꆹ}�3����,����^�晶��<�>jgf�<[�p1��v������$J9H����@�j�$�oQ[б��a�
�=�·k;�|�`�1V������53��������I�K�      �   &   x�3�420��52��J�I��L���425 �=... |�%      �   6   x�3��HMLQ0�2�0L�L!S.CN�Ĥ��"�Ģ�T.#N����=... }�      �      x��}Yw7��s�W੏4WU¾�����D��EK�9�R�j,�(R�K��_?DUY�"s�����h|�D, O?�㓳��'���׳�݋�ɛ��������8=~3QR�4�i���i��<�#ZJ9�r���~f�D%�g!vT�R�^��j*��(!ӎ
;6Τw�%ݎ����T0;�+LvN�WK�U;Fό2�C��������?.'o��o�[|�ǿ^,�X�v���X!o�A.k�r��.�����?���{������nrv�vb��6��V�*#dܱrG����B�r��Jy�I׊�F�-���~
�t��0q�͂bR�f:�kR�^I&���
����構�������p����b>�_��������y��`�L�J�����/��6��+f�.��1�$	��0uZ`}�ZER��(X���w�GaM���V3k QP�1X6�'��9�q�ˉSQZ��2JB��UǸ�c�Dj�C�$Wh��A�jI��J���.^�r��F,�w˗'M�sa��DG�L����8c�t��&kL�9�^���1������0I��� �tH*ޕAr�tx>1*Dg�I�P�*�e(f���؁��Y�g�?��8}T#�е>�Ir�X��CR�n��묂�P�Aۄíc�l�lG���iz��i%:	����3Z�0B��L�+��� H��w��.?/��T�:��P�VϢ��at��d
�-IK/��4Y��_a���GLM��$Wh��A�U$�DP�*�ea�I*�l���\C�����m�D�I��6�1>j��$Wh��A�4:$o+���C��88�Yq�w�aoZ�h;S�Q����U��P�h������Hv��@5u�S0��M��$Wh��A��:$�����}��x�ˋ?��/'�� 2ƶ}�afde�lcG������'[����3㴋J�0��L�+��� H>��������۷����)���T| x&aJ�-g�W�f�R��,J,F���Wɀ�ϊ�0�&+�GH��>�Ir�XI�CR�n��m�"n�Z�׏����t�
Fe���͜�4i�C��נ=�W��p��*y��ܩ�k} ��
-�>�j:$o+#q������g��q� r�Q�!��Cˈ,��Qp�+��B�eL0�Ѳd�Lc�Km} ��
-�>�2^IŻQ�*�j��S0�E=1:H��Se�l�eG���%r/AjR��j�`t�71��Z�� &�Z`}4.:$o_$qv��Y>,��������}��� �}[,�i�Q����#po酱���ʌ���4F0]��$Wh��A�`:$�ARDcŇ��O�s���e�`Y�C�!��̈�m�g3k"��Dx�툁R[�$�B��B����������/�h��x"����`.��	
F�bʂq�/3X�=t4�I˜�`��4�`ZtLdz��W[�$�B��̪���� ������_���0�%�_h��9
�1X���Q�P�74�
:���*�eTa�=[[�$�B����!�x������c(R���ᅕ+�eٷc�AM�,.+>��v<p����0I���(�FR�9��	��8���9y1}[�\~~	.Xz
�Zјe˲)V�����+�Y�m6ce�N2�x}��0uZ`}��a$�T���"��2�
Z L?8�3�e�Hc
zR�"��oU�{d��x&��ƌ���L<:V��A��(H*�u98yx�}���z����nĥ�Cq�c6�;�P�L=x�t	.'��)���W�xp��K�i} SW��Q�����8���I���x���Z�<��|2!{��żFǴc�llG�	�s�	&�#��0��2��4Ɔ��`�\��AR�T��'`⁗4=	���ف�po]�(��ŗ}�����ǼJq}� P���J�++��Q��[!\6K�ɓ*��߿�?������q����/�o�j��
�ː]��m^'!��ֺ��A�_�mk]�+��u�H���@%_$y�Ik�}�}�g� Wn�*���>x�V^���竛Ow�_߿�����ԍu`b���巬P�Xb<n8�# ���683>XkFqk�C�$Wh��A���!�xW��w��o����Ӌ���݋c����x���b�?1AYO�����H3X6�� m��	r�3O�ef�q��=[>M��$Wh��A��#�x�$,����s����s��`�L�J�We��1�_��S�3.�{�ܻ�0I��냠j��������;����	L 0`0�b-���k�1>�*�e3�*M�qӢ���
�:�i	o��R[�$�B��8V����&��ܢ�+:Xz|��`�L�J�
%>b,tDa ��Vƥ�3���Fm} ��
-�>�26I�[�qs��,P�������zyw/�&HP���˥X��5��y�W�Ӛ�`Y��1u֖��a����*e��c��gt<�|��`�*��� �Z���EI������VLe4݋��f�������m�p�1߇[�8����;�w�РY%2���9A��]2+Lɩ`
 �H�6��6h��.a�ADY���px.>���(UA|X.?A��?/�<\��w�`=-��JMyq�P(�&]e=�b�Z�z�ij�8j�ۀ�RڠY�bW�����r�my�����ޡ7�'��&o΅�RM��mpT|D
� �(i��ZUIx�9�[�83#�4���`d)m��.W!T�(����şp�{��G����Y^~^���DSp�;��a�I����ݓ��4�"��
��[>U�0���_6�P/��ę0f�����{Y�V�,�
�Q�9���N��,��/.�����������P\,n��WByq� �΋�Ǉ��OK��ny�x� ʯ�-�^���o˥8O��sא���y������������1�,T�B���]��BZE�K�h���D[;B��67�N�oa�K*.�2�V�?��>t�$A�,�a�i��ɹ��������@�y��͞_�:�3A[d���B�Z��p���nsc泌BX���%�Q�pL������W7[қ��ŋ7���S���Wg׋���K������~q3�A*��b�%W�`ӧ�WOf�r�K9ǋ�*�1���=�T�t�vW�y�������)(}/^]M/�U|)�nn�I�)�O��
Z�i��j,E4� 
��Ir��ѵ���R� X鐊K��i�;���|1���WPQD��2|u���'S�J��	rĂ]������l �vY�S���a������~Z^���S;<�>�@t�gc�k4���0ab�L�c���f�o"�J�%�C�2�� �ZTGQT�[�vh$���2�B�zLu�Hm�&f�ƁϘ����Z�Q�q�� &�Z`}�Bf$���������K���J�e9�iJ�2�-�j�C�Q��jcez@#�Ҧ�L�+��� ���H*�V6g燇��MSʎ�9	������(�/�X��l̿��@�(���,P��0I��냠Q�!�x7D�#.c=��Z��;��1����5WX����]n{�����-x[��ʥ͎ [B�L�c‰Oޖ�)���3���ճ��g		�uJ=͍�&��ɓ?2`Z���9Xd�%��u��2S�5]K���$���J��$�V��o���8A3�S+�E�^��YW숣L��(!E1�t�0���In�_���gi;oC(��Q+�����K��BX��Dx���zT�*��:{����&��~]|Y��8���~[N������x��#�q�E�mH��1�*:]����W
d#��wR�����?�h--n虍֮��;�c�g�=rt��gqƷ�F��E	�L�������Y�T:XЅx�_�|NzM%q@i"�̈AԵ����F+��.K���eT��8r&t�ۣd����_�{�U16������!�ru��'�$��$i%�[=&u����;:�]D�2��}3���`���vu�{/w�&��H�%�^����#a�q���6�K";��be�~�cV���0I��냠    A�!�x�o SWL�I19ܚ�r�y0������7�䁮a�$L9�!GUx�rL�s�� &�Z`}T�CR�n��Z��!n�|a�k'ˀ,�J�i���Ѕ��tZѲU�X�d�ߴ>�Ir�XD	�0��wŹy}/拯Kx��3�y��TΧ��8�7(�>`���iYV�uBW!����2t��%�E�T2�$������pu�v�t�a�*��� dyq
��w��4�	���K��w�\��`Y��b�N�|*�0~)�p�ܸ|ή�L�Ҭ �(1{FR�n�_!MX��_��	~/s�4�N8�*�eh%3�~=�`S޾`8Wt?�q!��:BH]�C�$Wh��A���H*�!��U��b���s�S��al�������T�.�g�1NQj݈�K�� &�Z`}E���:�X�%h3 f0�e���E@�ā"�eP\��ZH�1�rļӴ>�Ir�XDq�IŻuk�l7,9���S>�<�1�e��(�Q��w6+�i�h%�c������oPm} ��
-�>�2�0��w�f����������
7�v����.�孳�:�Tq���L��ah�c��6�q3�և0I���(�;FR�n��o/�����u��������7�Zw�hg��c^�����v��<�)\�"b�a�umn���j�Ş�~�Vߩ�����W��'���⚜�&Pq�ܕ�T~zDp�*W'�fy��waѼI����mn�FNa�KV��E��8[u�s��щ�h�v=|�����7�_�,�T�^p'J�?�/�m��ڐ�嶩�}���:g��@��0���8E�)(�v�U��M��ScV�67�^B��j�E�ݢ�8+{��^��6ZL����2t{�:�MSN��S��]^6fƁ5�G�2M��$Wh��A�:$�������s��~�Y�St ��	h	yް	�=��`Y�U���;�@���J�c"�`*���cdT[�$�B����IŻu���~<��0��Ӌ����������%L��/�*���$3X���2h�����l�!ԕ��C����>�Ir�X	�CR�>m�͸sp����2G�^� S\�����?�,�B*ԁR)�MȤC~DF���+≯���F�>��&�Z`}űb$�3�s�����H���S�eyo?S�0�0�O��B�W�S���֍�Mm} ��
-�>��J�H*ޜӘ��C���体=L��ܓ�\��(;�%9���J��$)�)����Ge16mo�#����,20����U�K��pE��X����Օ,�S�i'���_��I�b9̈́���9�K����J�{/Sq���e�J��ե�M������A�լ�ۯ�P���ac�Hy	�qr��J5%X���X�-3�&>�m~�m\<��;���)6�^��j��ݬՆ�m�@�}c.���j���[�.����� ����}�g8+�cV�r�Ნ�H����[|<��=1.&J"�*���`mg$j��6_����h��ܤ�*c�tc6p7�`�\��Q�5#�x{�,Ɗ�'�+���c����|w6�'�B�R�-��X��^�Q)ZS�,�*1QYc��2	l��J��VD��W`� P�GE;2Rq�f>	����d(��P��N �WO;��ᚉjfb�|��67�Nç���%�~��첺�=�+��-H���Fk
'qf�l&+�J�@� ��e�5�6B0�-<��i} ��
-�>����H*��<]�U��[Ny��S^��g1xYiT�RP��T2�t>.�V�h�c6���0I��� �tH*ާ���Z���fw����%Z�Zf������f{yw�6�6V3n�vc�R��`�\��Q��H*��;�E�sF 88��%��ex�-S�B�y�ēp�,��:�EJ�|��S�	�1I��� �uH*�m�����k��Ĝ��s����L�Ū��y2�rB!�2���)�'�Q�&R�?���Q�mn읣���.Kԓ�eT?�o����.1^�/��S�_b���bwv&�k|S-Pv������(1��ČR"��T=Ӱ�67�N�i �vY���/��*چ�w��O����y�C��J��ށ�鵸8;ڳ��|��V)��f���T*ۜ����F�2qe��sGLisc��+��.��T6�T�F/#��|�I�G�h�Q&�x_�
�8	�8��ލ���q����{�ֵI;&���������������}��Kx�g=�,`ZL�r�?��΋?�}�w�ok�i�(�B|�~��׾]��S��-wT�� n�.�[����Ck��?x*�f���PW���(YO�g�W�`�e=k��q�8:X��X��2�e�c�Jtܒ����V��^U&�V��3M���
-�>ZS�T����<�v�����]]�N�`��Y=]�����[�d< A��Xzx�]>b�c�,o(48c��^i�W���+fB�G�>_P]�C��
-�>B�!�x7��'���\��f�l�BGq���D�g[�.|>���!����j��xeX/�$��ˮV
7��`���l>��,��Pi
���V�g��)I'�0�`T�k�� &�Z`}�h�����z|��!D��u����2�2�WZ˲2�"�E��1�W����Z[�$�B��M���ݲ0����塜+GI'c�Y�L�$��2V�K��-�]���3U����,�N�;�ZPfеޢ�j�[AJ.n����J�
��ѻ�����7�B��Љ�M�)�M�K�X��z0-y�RD,9�1d�TA�0l�ފ��QV@��e���"}�+��,n�uŧeD�����>��z���P�D��0@R(��S-�>'D����_e@-�1J�i} ��
-�>�5$�=�0����@t�)/9Bo����͜���0<-�������㥲n�Ψ��L�+��� ���H*�g�v������׽���1�}���(T���Q>����`h�D�0�<<9�X�S��p�ޔ7���P�sHB��V<��[P� ��(*ҿrG7��͆��3�v�$��u!BϽ\M��F?̇�&ڎ�j����KQ���%�~U+Ń�{��N����8<{}t�#c{�׷���#x���TN����5�㼊�)�\(�-`������������	�ͩh�6	s��}�y5-g[S���$�1X����{1�+��.s1�˨��!Wv:�u.ާbq����J�8�s��,>��|���f���$��?��|�]K�z.�p��펣����A�g��7��*�C$e'<�~���â\u,�2ż���tUfL�����(��}�]��P���Y�Y�RY����ݓrY�1*�y���ବRG@Ni)�	w['�D夝�ˮ6�D���HV�-�|�U���P0S�������ǯ�rr��ŧ`o4iA����B�~R:tff!6b� ]�5%�|�j�8?&����ܻ\����J��1]��)�ǯ�����?`���Ӕ�'])4T��ՎR�R΀��
����~ϥ�v�vW�2v�������9$|X���φ��E����k������j��+�
�V^8i<~�Ѐ�K�A�&�~Tf򾰤*M�q�<]��`�?W�2�]lL��� &�Z`}��a$��e�ϧu4~٦h`6�m��`v��hu��.��*u ����xx8�����0I��냠��!�x��O�������W������]�S`��4��|"K:��<�Ŏ�ZR�� &�Z`}%N�H*����� [68���>|�r��-������4���$��e��x�*�����L�+��� h�tH*�gǱ���E�K*\;��^Tf�,G��<�4?�3�s�'�/�w��[�ZX[��Uh��A��-H*^����|>ٝ����]� �����w�P�.�OQo�MW��^��&����Y&6��?PAO蘴��͕6���;(�<w�k͟k?R��lr��z񳾒��[��pu.�s�z $:��(}r�0.J5j�~��&�Z`}4�:$�_z`k=���鏔;�[ x  �r+$�o�U���JL��7L���ksc�%j[!�vY"T�/�ڤ���vOΎߝ��5��L娀��$U,˧�d0ee0�X4N�tnc�8��d���0I���(�:#�x�곁�m�J�y�<����`Y�4@�^�d�Õ�K��c;�W�x��!���L�+��� H�uH*��1��-0����[�SL�N��S���Tk�p7S��*i*u��Ŵ�6��`�����U,��A��zR���q�M�������{*o���c�͚,��Oz����Rx�`�j�ېe��x� UX�2��ٺ�����䢵G�ޗ6��}_~_bXK��-�Ok����rpO�����UW�����ek6���۟�9�駟�/�F�c      �   i   x�U�1�0���á1�g,���H���p��� qC,��X8�#�z��dKRI�$AR��H�$ �I��L2�H��y����r?c���ʄD'Sz�ѻ����9�      �   �   x����
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
&%���w1c�='�an���~# 3�Nv-�� �T�]`��>jÃZK��e��mV�N��BT�`����s�x���{���X��������&2x��*2�)�6�-�a��g����A!=� �l~�|�,f�i�A�)}�T�Ђ�����"�;�5����\^   �^�@���Q"�Q�3��	R��A�Jk&�R��cT�ń8��i��!��wF���6�q�\��"}n��s�5���/.�|=�Y#$��LW��2��N]��wwI��r�|n�S�sk�z�n1�Y��^�D����a��\����3�Ξ��ik�����_N�0s���[�K��y�Ї��r�}�y\1<��(G���&-�`�sȐ1�3�g������%1$ϘsJ���v�B!���_}���9hJ�Ϗ����Q��l      �      x�ս]s$ɭ%���W�q��]��?�4�.[]�Ԓ�5�O��)��ڭ�6V�d���@$��`&#3�=6f�]Eց�q88!���C�ާ�=��|�p��r*߽y����݇��x��/�޽{�������������|�����w1fp9�"�w~�o>��F~��W1kH��� �g��߾N0�����(��|�i?(X��
Ņ\�{�����z��b�U��[_E0�%?�mZ�m�K�`�{�����Bؿ�}���Ϗ�7��x���?5̠&j�l�5�G$h�[�Q!뫋%�!��CO�[�f`�K�v�Z(�/�_jn�?�dL���`�X4b���Q ;�	�F?�6Զ�f��+Đn�w����������@A�������j%��M�&�R��vN���L�o�4;�iJ���������O������ۧ{AL�n�:B;_'eY�j� �rJ6����rM�=bs  �Af?Y\���9�P䛇l�5fАp�A+o#c��ͣ*h�g�Ń� i�Q\�v�4$��!��l�y���jqu�_Ɏo_ s�snJ�7��#z���y��7O�>�����������8�׵q���'�Lkf��tl����V�tl�7ldGɥ�+v\�� �>!|2;!J�e���v�L騬��vkzq�OyGs��X͎���\C̮d��v<Wo]�̔׎�*�9����,�߽��,�����\ ��~���T�eA<Z�܍�ZZ ��D�y�s�i���0��B_���>���&�08���1	�UMo/�D����Cۥ����7�,������� �k���fp��i�v�%ɛ�#0��v���6p�v�D�g�n�#��R2Y���M���b�M���.���85�j�3��Ȑk�אI�E�{'�oC������ç�ǻ�7�?����w���������8�y�χ��G����?v���͗�ib�F��J�h���`m�S��� D��>ܶ���m�K=.Ta��~���ъ߽{��ۧ�w���ʷ���Q���Z��F|�}�c�vY�v=�u !tL��(�c\Mh��I��c���n)��.�6���m�j���Q"��dh��Lh�b| �櫆��DﭾO�D�C`͂ �q��Ԗ���;'<��˘YcV�ӗ�����|���@�+Xg0���b��5���d�|�G�A#�+��,��P�G?d���.�b�؃�s<�5{q�q-��F9'��Q�ƍ<�9��xq��w/��>�߿�˟���?�`2N�=�����7Ў"GS�3d��v�.s��G��3>Q�>4���
��2<Jb�1�%ŀh#�X����W{`J�Zo�Q4X�$����3�2̀e��Rf�ܭ������gw?!�܁�H|�(�34@y:�M�8&M�'~��	���Ea�y�g^�_1J聡ql�V���G�������o~���?���LF6$~�NL�{��hu%��8�&��9��Ϝ���{�L���?_��Ǩ�?����o�Co�g�ʏ��f�U����Ȭ���=yMVe%_ړKtN��{��`�k6�֓&�vK��p��]O#�#�L�|�+���K�EB9�����@�l�HF}@�>�8n$�y�栏���J=bۼE��Vi���Ήy��jMsٵ,�kZ40	0حi�Alw2^�<"��{�����|�3%���(Q��<X߬3(`�{yWI߬WF��J:�ou਀)2)R4&�%�7X�9i��k,%w��?=�{x����_�?6'���_7�����ç�/> �m���>�?<ʯ���������?p�8`��|y�>*�ܛΥ��^���|	x�9�se*�/w�����[��9+^�Ο����%L���(�����T`9���?Ś��|���.���TNk���O����z���!���ML�"�Y)�9K%� �vU<K���(+\�KH�v�8@�\&	8?�}z����x'?r�6��~�ÿ���^l�36V�U�Wcc��� ��(n3��a��[�N��]�=�9�j��
�SŒ��ӱō�r�g��%����5�&�����x���*����
���r5	Z�sո��b��g�^�J�9�|����%r�ۆ!�k��Qd�&��7�����_�ٸ;�w�ei��������{��q����4���盻�򨾰���8! ]6���kjc��|�W47��M�����k����r����83sH���>7gJ`�eîgn:~-��Tm=y�9?C����g�p��������;�m��N�+'hb���?�=֧y�;b�z��5�9���Ŝغ[��nA�Ў�9s�9�sl5?���w���;��)�|N�c�D�|4�7��g�g]v�4�S���FɅ4�7@~����bM4G3pu���%�,4�7���^���̛�mcc��X��}��pIV3	  h�&�A���A�0I͹�WyF��0yWgh��"�άfy�Rv4,e�q��v��B��ÅuY����#�|1{�G�HŽ=O��;�cbd&�y�[��;^��&��w7��c����'#�;:��6vbm�;z��������:����H>�l�ʂH=0��Ӫӷ���ᑝ�w߾|m ��L��0)?�??���������2j��#�������q_�S�
1pA��G����w��݇_�=s���/w��k:8�1';����=f��?�����,=&�x�����x�*`���Km �9O�����y8����?���0�7����8#@���bx�#s�u�qFH�"/j��p�(Y�\��,�pb|F�7޳�Kl��1�"D҈m�4*�pVX�4�B�ӆ���z����)����֣,�*
<ߘ�kS!aU���^���K��+,hO�d��O�G����-���=�h��ͱ6�yi���/��������vxxi���"R�X,5頾��~Ѻ�#?�,Б����")�~^g5	q����,�E���?��4S��HڼAGCh���C����N��8�\�W[-���Y�D�s���z��&�B�<������]����-i��~ʢ��Ec�(����eq���+�96L]q���ea��+&��)�Z��Պ��f~�QAR��̣��F��Ž-�̟E?� f�Eq+v�"�/[(Vb7�E�^�="�@֥� ��P���6$Z4�8��G^��@��C�%�Ӣ��E�JQ29�+1\1+����F��Gl%���<b�r�>l�A��Wf���:�SP��1?n�K`^q9�Ty�8h`�lO�5Y���J��c���F�� ��㨁E{%�Vϳ�p;����E�NNX¢Oz�X�p��|������`�'չ-�8q|��Y�j�j�TO��_<��p+y.�5������=c`T�!p`5L�����C��g��zx䗭���ϏbQ�!?�sJ��G�.6I[�YM���%3�{\Byh��LmQ��ls*�=pl�S'fé��k�*ߣ���^�c�<DuWϴ���X�0��V.o��UG��'.���\��H�0wl:7Q�XE����B�dnHC�����N\xi�G�5p�#���L����1��hVe"ʣq9M�c����ݐ������{&�!��s�uZ�|�e�y��sRzU�.�f�A=��V���(-��i�>K�5�r�&:�zW�t%���=����tP2���V�t�
3��-�+h�$�p:MBi0h�$�(NՁ>:���mx�����%#ՄER2�iT��S��>�|9��p	nԸ���k8E|r	.��f�^�\:k�k
B#$ec�2�RN)@_27Y�s,�.��e7�Zq���FzƎP{C�°��I�G�}ؾ��W��V�k�V̎[tiYj�)��#�E;
���{!�r�?>���_����[����~&+��4W�ny����&�A03vi�}���1J9�)��ᡋJ c�5��}Tc�'jr��+;r�&biȮ螽�O��a.y�.�/��a��k�Я��p��hfCI�f_ j
e�*2[�'c�H⪇�    Z�.�D؀�y�`�zs�)��I�]�)�������f"�}|�d��������?}��0I��v�S�)�E�UkT�G���Q%�_�?a�5�h��1*)Tn�P�϶3�4*���iZdKp��P�o���0z��u܏�&q>�]�p]�W����|�E
��x}���)��&�*݈�	����/�����&/n�ʏ��fiv���(���f7,��mw�f7�\�\�u5�I����_�c1�f�v�:Z�N�zg��(S�5�q�wp��X0̬�qK�3�9k6��P���̚�%�媬��Y���d��fMRN�jY_Ҳ�()�pZ��%������!�ϲ&-����P�Z��N��ޮ��e�`�!�~�y�_	7J5�uC,���k�|�N�(���y�T�U��N,qY��)���E��uX�$\���oٱ:�3q㹪��Z�,oA]Y�l�\�UE)��ݻ����v�J�U!��m�<���s�R�Ҏ��RaQ��h43���b��W��m43��D��e���f5��t�����1j�"U�v�O= '�g���4Q�8��l��B���Y��?��6���I�˽��p�6O9n%��%o| ��X^����Q�w��
7-K[�/��)q�����n�4��x�������0���e 3LR��Y���ޤ���ؔ�=T�m�9,�R�$v����8����*U�2ʪ1��g�a��/�趰HFlg�!dP����/'�v?�����h��d���0 *LnCZ۩m9�Qa����3L�`��.����ڤ!3G������]��vY�`9��1+�7������߼�����k��������?�����{x����o��p�5�V��3�1�*���0���>��z� JA|�JΒ
G;�ʯ\�d�	
3
��!S��B���,M����2�q0A���jݧS0Ic&ޮ񵢪�@�	da2t`9ʬ Y:��5�r��E�.[�������8�o�����`1����Ȩ�`�I��� ��9�%�?$i.%��:�o
@HT��3K������4�^q��BeM>/�?�c{J�yy�b)���k����������o�O�Ȝc�Dʮ�%C�^�J'���eJ�6��g�JY!"r����a�)Ks�����nT���Q��ζ��g]G�iTD��,�d(�w��x��+���skLL�&��.P���K9 �ph���7?��͟���O����e�����bT��)�M�}�r��Q�i\�5c���%���S���nJIR �o~��h�w����o������?��Q�q�u��w��6���<�N�3�C��(�(�0-��t�>�����fH������=�����c�O��+��fO�ܮ�������'���y,��]u�j[����W��~��[ �q���}#���q+����wʏ��ɥ�$��ƕ���fc�g�/��8c�%2tcF�{�ϑ�y����,�^��⫃�v�樂cg[�rJ0tF�;L��/��f�1��˄����n>@arO%~�ƣ����]�;ux�oU}����ږ�MN�1�+�]ծ±U�ƶ���i�����|z������H���۟��jw����/�/�!�p�+���t��h]44J�H.�/��O�R�=&�l�s���Fv�Q"���wT2�ټ�������׻�_���?C���#|���n�/w�:�>���Fu$�f4Rhn��f`o7�i[3bo+E�Ww�:e��h����b�ymh�	Մw�S��]O���m�(ڌ�G�6�ZQ�0t����QR����!ݖ�PBo+*�V� 3����O�t9>fԘ��ѬC����3R�Of����4��#���}�9���ږ�Jo|ix��+��K6�q��8����7|,}�JG����ve��_]yd�1d�{�t[��/�j;�v\)��㫻#���jǏ�gv-/?Rot��&����;]Ҷ�\���PM혔��K��-�ڱ�d9s��M��1�NP�/��#�̝�k�9tǗ�\�oY���^�됸[�mf��A ��w�kf>O8���ǑF�*����L����F%,{|n�B��H���Q���n�M������N�XX��/au��d^�&\B�XfU��,W������N|��b~�Q��:K�B�Gd��$�0�C�nE1��b�M�����hZ6����Ө�M���4�#�H�9'ǨJf�N��m��Ө`f�e��:l��-nQ�\,�|9�ƭ
�����mJI��p���ϲ�wx�,�)iT%3�r�i��'k\Ըj4��@�!��q�^MU,����-��+�.��Κ�8C*�\��yJW(-�Y��Pv���ޣ'T�!�e�t��{Xs�V)�r��c;Tи�8�}&BB��Y�нy&B¨��IO��Sԏ�1���矙8)h�K�ԋ3�5��M�W�d�aQ�\�C�9�)_�� �s�����W�CWT�azh���#�.��u�
��Ƃw��hr���r�q�S70E걑�:��5����z��Œ���K>������ה0���ݹc�A�1؟IQ�%� �ӓ�_u<IR���LOf�hS���'3�:y�C�:�,|0`�?�#K�Q���OM.p ��M�I�3�.��u�UX
7��f.���j]s�5iEy���Dp��&M[1I��]���+օCW��HIk	yYX��j�bHvo��������+ʋ��G��ٍ��1 i6d[�c�$CvH�Y�%:�M��������!p��Y����C�W�pV��cϚ9��|�yϚ&���]�����D���pM��ٙ���X:6���(����f3_� ����#�����;����	�p��e�Jm���Y� ����V:n-\���������5eC�ҙ��FL+�Ҹh��֗ϛֱ�q�ތ�6M�M�*1��W�I^Ḋ�	_�ФQ��$m]�c=����iT���M�,��^�Q���p�c�>�G;��旆{����I��}��ǟ\�W��{Dߦ�ƨ(�4�������`Q�<�ݱ�jJ�����y�t�qL�`���o�cC��4���c�¹os*��/R	���,�4�
H�����~C.�����������������@�҈�5e�$��|f{6(+��"+9C��4*��C��s|&����N£���K2�����O'�T{���q/(��M�{mSN�rA���	�W)��^fg�"i�ĺ��Eы�g�;W��3��b�@�A\'��[M���.�K�׻�f���Oz�7O��~B�,L8��˸�n���Tν�+���+Ln��E�Wb=\�����}�H�އ'=��d�t���ك�揥8p��<apH*����8&M0���yeWrK����';� tZ_b8s�g'y��Pj"���Y(�uF��Uc��p���=d���3��
�Ki���꘠0�����rC�Α}u'�E�؛֮���2��*,�,jˆS�P�"���>�f�Iarc�ડ�c��c�0�\4��f���ˋ�d���'�
��B�]!����c��j;
�`{ h�$�\�K�w�;�{���'�ُ��ŜG��\q�a�ܟǤ��(�z�ia��6?���wן�q��r�u�E�嘾bf�����Z��֌�g�`�M�!s������mesm���%R��Q'Ƚ���8_7^��͐vm���?<g����{���w���!'J����8��m{֍�����F���e��8`S���������pX�ku3�6�JY�x�eF�)��tklFUf Ȣ�mI��2��Os;p�]
ڌ���İ~���e�}ͻ_�7� ��Nd���y��Bm�e�[+l���)���
�3�f���46��U։��8���y�d��#S֘\��||�1o�����ư�N���P����L��t9y�͢]0t�3�.cl��H� 6W���C?n�.u��{����O���������?7����w_n�v������7�~A~~�4��4Ms�A���.�Is3�Ņ�1�70    ���I4dKw���FM��@�c�0�/��[e�����vy}x|��(�O�
�-a���-6_�������{��V��"X����gS�PD繂ywξ�n�|њ�WP��s�m��X��0�#�j���]�axrض�J�Q�����3i3�T4Ѷ1���;H�6l����&q�-�Z�������@��۷��eM�P��(l�(�vA��s�U�/��\��GHWf)����6�/�	3����7�˖K���Z����� ���.�elF����2�Y}C���:X-�T�h�y�2��ڛ��宪Җ_��͈��oi�ը��g~O�e*h��;�7����0N����v�EV��[uv\<< �m���q�P�r�9|�i��X��h�c�kG��6zQ뾺�u�;sB�\��z���;����>�?���y�!4���}�~n�0cg��->���o��<�O~B� 	,R��äœ�&���&�N
��B�P2
���O/w��m�mȬ�CNi/�b�}K�&�A�6UG�w�⫂�B^_H/1/�+�� ���S=K=6��px7��xbf�C��a��>�
��l%`���J�>�V��a���R{��B=v�J�z�Ј��+[�[.&�	]ĸ���a�Nm�"�m\TV�Cue\�&جwծ�[|�0�Ԡ]Qz��*e\�ְ�.��.���/�e\C�4��%��77��X?t�4C�j(����"5e\��4�X]z�A�ޡ$=�F9�Ɣ�,�Cay*4�^�̀&ǚ&Ƒ���n���zu������X:�R���>�5��4��P��#D�٭����%"G��rZn�y]v�E��w]����hvb� �~�S�lg��ٛDQ7��O��.8��|+	��Y@WD��o�)�D���N��r�K
�DW��BK4�$���C��Q��ڰ©�4����D�-m�r����L	�p�q��[LJ��x�d�I��0��(b�cq}��'�jÒ$X�"F�6绂������*E����AcK�ߠ�U!�Y�{��z#RԆ%)����4]��^t�_�Ci>��v��L,&FSf��b�r�cˉќ�Mc��W��0�l i�V�R#��S)�ˋ�����	_�ֹ�b�)���Ue�ⵒ@C�q�0�=6�����*>��q�듸���Đ���˙�[NLR��@�E)kl.�we�W�4a�v�n$��bCT��r�\���6{��P�˅��
��h�U�̘Ac�y}�b�QcK]fH��s娌�̕L�o�(��+g3s)�=v�#8�-Ɲ6�����S�䇣�[�.䪰c�Pl�/V|��i�q�)�h��*�ؠ�����&������ǻ7�|~��,X����w���%��/^�w�O�̩������!�!�|�C�z/��Yc�yc,�@�pH'J%�e�RR
��l�'��������ټ�r)3�e�7�2�X����N��S5��C	|3	�}����m� jT���:�e�d��o�z��#�~���N룲�R�K	6��J
;�|��\��| .�`�̟����8⸤/��k��g<3/�.� ��ȡ?�� �N����b�d�RK�9ˎ�W�(5�}��E����%���ƫ��K���9�|��h���ַ;d�n̯s��:.�{2�]�r"��"e$I��jV7�������m�m�K�u[�F"G��x�UN�>9��ĝ*_Lj�|�!�­�{$���";��<{/5�s�D-�K�����"�-/�(\�{	���̝m�@HazRf�Ō���B�6�p]��UN0)�QDo��_����2xy�-C�sk��9�����o� �hh�<g�΋n验���3�3x/`$xe$�5GwMn(L·v3眨,������n���O����6V.�N]��-E�g�x�y\!��77.\�h\@�8@�")�j��/M�Qڟ7�'k�;���p	#��H������͝�a��Y=���!�0?��W86������z���9>AJ���Mh��s�L������j/���k##���΍1����YA�������H����h������5MOG����R���'߱r�(��ұ#_��.�k5MGʦN��Fj���Uqt�J��EԼI�
_����Ly���0�rU�Y$m��Y,�#۱CL�&��r�8�����������Y��|5"�wR�Ղ/����^��oB�^��hsWN����Ҕ���x�œ�@C����@����R���{�vD�9	쵡ICg�Dm��NIC���8N�4W�$WNN_^ ]z�7�4�*h��������+h��pA���B�l�2D �ύ�ɬ�Vڠ��O���,F�˱2�5���]�]:'?��Y�4�qn	��
Is����{����4ۑ�Z�^��`~4ۑx1��<�<�Y��Ě��yʂ��Kn���.�[r�F"g�0����	g�Am�.�=�^��Q^�jϕ+7jPN���T曐4��y�,ݚSMޕ�J�Y���	W��G����|�W��<^��W4ri ������~(��H�ͪq����������&M��r6g���*�4B�H����˵G'Z�!Cr�%YI��2��Ɓ�sP���Y�'��u�(���u�����_���-���c�.�c��O���*��Ɣ^�F�"	]ϑ>:\�A#�T��C�� �՞_�9��~Zt�3h�����$!V���ڶ��ͨj^����[���&$�,.2+X��&�(������	�k���@�J��9𙾧�
MF�
^Z< [��̃����t��+tE_`��+��n�m�B��dگ�Ny��K�j� �噞�xJp�VT����劣�=hL�#�[.zQV���p���:\��>DՊk��C��y�!��V��
�Χu�R�� �թztF�
��n��cY�kq���Oli�`��#�o�-�%9jց�$�T̓ ��ޢ�ʙ�j�D>-㇬����J";��X��KX�f}�43�TEW����w��Pd�iNNh-&MG��'�M=@��pP#�x�8X�
RV��+y�A��P�q�ˡ��VdeJs�\V������`��2�m|�qmɓ܌&�;��
�'db}��;7�'������Wg*��I,��3.A@�����6T�X�^�-E��f�|K�J���ș�ܳ��[JY�>�����#s;]�O�E�Z$�/��3���rK�p}����ͧH��L�T����w��2��G�/�Wh*��R�F�Wg�>!D�U�߫3U�%��9fWg�>|DdӁ�c���fG]a��G^���ւ]w�o�QAt@s8�Su����zV�onF���FS��B.���*M�� �t�a��>��"s�L��`;�Hu��j�2j+���4��2���U�tˁ%���S�%)����[\�ʬ�d�bN��faT��r��]b)QT�3`���v�KS�ͷ ]��rC�IAY�Ⱥ�!����L���0o�䞦��qN�%��X�R��\/�d���k�Y��yJ�E�{�d��hN�����O�4�����w��61��+�՘X{	\�-��VHn�׳�rP&�gY�P7�.3h+D��,[Oj%�tyw�{+HT��f�4�sBm#�e.����@)�e)�k:2�>	0�v�%�ԧK%�K�R��^p}pP!Ik�o��� 
ɅE�i:OE��=�m�I1�R	m*��]ʋ�n��!��@��I�;&6/"/
��mM��������9}��+���Q�z�o�.m1�C.�&�Ny=��-;7���C��P�%&���Ꜥ�v����

.��"�qqZaii�Rj��r�H[�+�����}\��d"������`����n�:�6�*�LT9���ͬ�L3E�73���3�7��q=�Xw)[&��q=�`E��CIz�X2�f_�㡷�K��ٟ=Vt����ɟ��?�m7��wj��v�m�B�;�a��+^�7�@9�A]b�N�s�y�`�2�WV`doīz!(3q��iڪz7�าya�Ƒ7C���:��,�W�[�4hR    ��t�7�N������roEs��ޭC(���1�T6�;��4�.��b� S�$V6�+d�y@衹�X׸bչ�Q�G�e�Fy?PC�������n�����DB7r���,'��0�q�b�s��ť������t@��:`0��A��;�oz@�����V�f��Ÿnz�"(+���~�8e<�� y�sҋkCO�ox,�v�<Z�~���*w^�vړ�b�|��V�����2K�>N(��R8��U;Ȫ 9� W��O��gЊ���q�]�#T�0o+ܠAAs��0��䇻O�>ԗ}'?r��ش�.�f��><܋����Y�&�Pr���Tna����lu;hx� Yl�ԣq�lq��U��dc׊� �h��n�&���u����SW�՛w�az��/��1VW�Z1�A�:�oD��U�4��Ld�����Q8����&c���/_��������/ﾾ�� �rt%̇=�DNd���~m�zT���Ҏ��_7�ޥG�=�Q�Q5����ag������юJ��q�\}��+��z���'��9%-i���T=εqQ�'����z#����8΢�`=�,����L��A&	�>[8w��=����R�q�!H:+�jH�0wK�Z�Q9��w-��娲h�֎W�9�)}�?��g�1F�J§]�I3��W9$4G��"�������6x�̓�5�;�q���(� >#g��CO�\�&������X�|��V���m}��sR��q�#shP�,cm��g��@:�oa���tT�����{z��?�4亻�o�(��~���x!e _��yo��4�h����%�%kۆ���?�K�V�mI��F�Z���j�
�
�b���L�^�V��S�:v_¶�lJ�����֍8�M�m"i���6ۼ�[3R�:K��v�����Y�����`s����|{U�P5i��%�u����К���l��b�)�$�,�NB��L��D�B��5W�p@�����!xM�$�p���!x͍$��`SY9��8�?�z��s��K�S��*���0���܎����)���"2���೶��jx�k𥷂;�m��ڊ�Aԑt���^Y$4O������/Ѵi7��(\�[�����33�D h2m�]��!+� a�!o��I$��-�6TM��Z����f�$|�-�[q4��.��fMz�g��3 M��Y�.u	��Md���vW�Kئ�3���,�:	8ِ��% ��Y���}� id��.m �54���N�9t��"������j�ۯ�woo��Е�*>9͡��F^i�����û���z������������n~����C!ÿ�����G��_��w��8@w�C@P�Gi5���r��C�����*�-j�I"����U��8J���w���aT���o��И8��Q���������aT��ȁ>��ٗ�è~c-1�<�T��*��8���Ž���Q�#�D�R�e�RW�m� �%�qe� ������ÿo�}�8~������D�ڟ���	�zQw���@mF���d�[�<*�0菖�GN�ɮKf�P�F��6�Y��3��2�i����A�>+[ ���]�$Ģ!�o5q�dՐC���n5����Df#'�hP�v��^3�f9��`G�	�vr����H37df54��kR�R�^��gM��xsg; M^,=�����_���kno���U~�����M�m���5S^ʔ�#0�����\�;+��5$���=�r�U�:�KԬ���C��/eh�Xؠm��=�		rޑd���e)��؜w}#�.)����K��'	�U%Qz����2k/jc�ml��M3x`\��G��b_�W�<��I��҉K�Ƹ~E�Y�'%%~e�
��$LQw����mO��)\��60����W�,{�(_ˤ���p�)%�Y�����h��\Ǵh�%9U��ͽ�}��_�v����F#��E�y)^�Iǋp%�R�6�-l�=,gքk�/���R^�?�����~ve:�����=I���i���;��k�J��;l�j;/�������Z�eJ��^C�AQ4-_�:�Y	R��8x=�]�QC��Q�{��Crb^��C���?]����C����� I�a�,]��@��]���sWj�В���׆.
��d�si3+.s�A%�dtE��(J�yًoqD�Ɋ�H�-Ԓ�k�jh�~zN�z홟�Vs�����4���o��p@O�,K3r47�W9����P�, }֐�!	��Qo�]���m7���hm���0�)�U>+%�QC�����|��=;�k:�����w_n$Q�a|݁܌S�2�kf���I�@As����}�{T(c5.\�0��Ej�+��A1P����F�!��;�ϰW���6S�?��2�h3��5�+�ͪ�d�"�o�d&Lؙ��X��Eo�C=lL������@�9����,�f6�slQ#��Z��� ��@�\�j6��#b;�gn|BV�$�yS#c�sJ
�	��"�0�E��}��}C?}�J�����/�LRL@�|g!h�"*,��,�B�ͣS8~F�7�+E����Y�OM/Oqԣ�>z^�L\��@�������f�*����v��8.���Ʒogd�>1�%5�a�A�1���⸒�	1Ge����kHI��U>฾f��Q����Dx��7O�pՋ�T�i\�C�)�Av;r\��ɹ��qɍ@6_��W���K=$��Y��b�A�6�v��8����c���h,I<\4������I>.���<pҀ?/;�p\73��t��'W� (H�<O�= �4@���9�7��@c��o��s/�*��y�g�qk�7M����Uy�\��i�Y�ra��2Z�(�AE���y�JA�̚7��*��&:��/�����MA!�Nn8��|yDUYz�x�=?9;�8"*DL<�1�w~���q-�p~���%��H�+Y��R�Y|L��+YH'sׅ8�f���=�<��9#�(Hy�t��|�jDVOt�k����J�"RG�d�� �u#d��Ph�=b �bo�
�ӕB�7'��9{H ǚ9�4�4�b��S��:�Ɠo��!��L��&(f�UA�Tt�lw�� �kPp����AC~�;#q4��*��ZԐ$}���3Sb�ƽ�Ȏ�ʔ*'�yt���\���g�������A�oJ�Q~����j�-F�-'�jH�fN`7��k�£�����
�K�CCDЈ��,��5d�@6���|��Jq5p1%)H�F�㰓��4��.�߲��@�����1B�	�.h�\�k�Ў�F��;H�:x^C��e��$�g�丽����Q:?C�Xq�ڳS\�C����������_�I���Iv��#�e����C7?�d�*�2�h����D��N:0�����ǡ����� ��k86k�k}���]��UsF�a���D_{S	��{}��Me�,Gs�M��x�\��Ve���Z�������4*h�Aj��@��DG�Z9���ق��L� ڂ\��tRБ�k��:�4^��<�
.o� �2�����4��u���4(��x�q�t���B�+�0�Q��39�$�:b*���(���lߵ�QAGQfJ��]9jd�r{v%�Ȭ�E���`��:s�A�]_x9kdV>q�E-��[��L:�B%���w�E>��\�����Qi��p�����2J��[�g6���^��Q��ހ�%uM���p�H���+{D썇�n��wy��6�r�??/����܊���Jsl��sK_�u�n�ח�:��5�&e6��i�,Q�-�8P��$>M�(�7!hC�NՑiG��ƨ��;�s���}*�[������y�+/Q�4���|����8�^Cܵ�I��$�8��AR�~(��L�r��g��s	,'�t��x��~7�R��U{|�|������{E��Kf��=�r,��!�¿�M��{�3����C�n���xx������Adj�ϘVF-C�h)h[��|�H�C�+�ͮ$i��.�)�fW�i��ӣzF�8=]ˈ s	  �FS�8�v�H��1�ҭ�i�h*'���]�F���#��,�p}�ӱ�2D!�hzR���<�
]�����鶝�v	�1u�L��t�s�Q2�hd�v��:JNL�ϵn�4=-�h_R�ˉy�\��x����U�OSQ�\���}�Ĩc�f!~r0�se�QmC�������
�x�%4/��b�o��2*dn
Ѽ ���ڍt������4���*@W�N�#��VEӷl���Fi_߽T@͙�z�]V4�

��y�Qi	d�O)��0�����R2,���s��젥��'�C��&���2;�>|x��p����ۗ��q>�n�
v?�??��������ˢ�����8����H�	aT�2 ���ϩͮv���A�����qTѲG曀�RAմ�@�B�-��FU.{#���U��yk��7 ��.�t���)#�]�D�J��0hԡ��kSQ!s�85d��F���	T��5b%M~(�wk����h)�Zl�:���=��k��h+�->7�j+J�=�67s�^Cs%x��s�򡷔��.V[�Q���G��8�\�^Y�
�؛@��̼�4Z]iD�u�״�� ׀mi��Q���.��C3h3��qΝ�k�]�g��.S^�7�����͉���F�0M�� L�ng�iQe��J1�e�.�+kʓwN�[{n�#F�b I�dN��Uc��<K�{���ۺ�ÍiN��5kZH�қ�K�E]��͜A�wlƥ:u�\�y(pV���$�7K�Q�;��׼~��v��������9j�A�f\��7���{i��f\���Eci�+тUBm'g���Gqt�6���^��\�(�SN�:�]�9@�.H�e�U.���r�j�Dn��8d��	��R�`�EQS(��|�zF͆����;N�qh��o`K��@���C_���~ �����h8H��Eu�z��	}5o��n�ui��Ȭ E[�%o��EC"�)�k�/��R�����2N()m��A�Ҽ��AC?G-��_ 	=d����K�?j�l�=E�-�Ab��2�cGA�
���5#~��/���o�����O(���$}�v�5�M
��]J`;�*�,e)5����[���(���������F�0{S���i�vl���\��T�����/ͨfe����B;�լ� �������QCK"��^�*6*]ٛ�|��;�zԶ���(̱`iR�ɑ�q1�Gy6����y�:�2�CQ�Z|^!$�`���(i�lE�[Z��|)ӱyM��[�z���2 ����4���p�<��pV1��iG��)aofdU˵�F��֔J�dC�����4�D=g�]Wp�Q��N���M����_,�[f@Y����J�Gn7�y�Xo��πr��
Oůz�
�@��m>�� .�%��=vT�\�ӘwN�o�kkD*B��.��ц�S��}����I#K�R��� g�,j8`d�\2HA�'�.@�90r�^$he��52��l�b�(A#G�))�|�h��S����.��$
�9H��ڊ�4�G���٢)�u<�]rN쮷`��Ht1�>DW4�Q��o}Mq\�_�-�yGq��#��q/��b�0�>�S��Zj� 4^���z��7��Ծ�Ǹ��~=��L�,.�"����W�T����ĕ�[���6�	e{A��J����l0��$����+T�-X�����q<v�@���dl&'�ǵ�v�.V�1 IY�%�%�)GF%wh�{���A兓�Vtf��%�I�9���ڮ�fNN��P���Cլ��(�j<�)r#V��A�8�4�)�h<�)���,����*��n*>�V��R���-m�=$�ڍ�F�D"� �(�Ʌ�{�|f�K��u��s�'�YP��y���/Ab?P@C�=�Q�&֔������'醛?v���l|����r��Anr��@�E��˕�6:)�I2[�פ���HRTT���kMq�ƕW蚴���W^CJGYn�tb���QB�!��Ƣ�+&hI��A��=d;x�����Q���%�������V���4;/i򥍓&h�ʃ�N���_���-6O�a������î8��#��.��`�UCʽ?%�XI�=G���ף���öyM�:�]q����W<�������GW��������g¨M�L#���W\�Qc;hWM+8�L�ԆjN��v�4�޸\2��?�����5�qS��B
�)�/�u(�P�#�����s��L�,ɠѱh��4j��z��2!+N����y�'7^0v͡�m�����ǡQs(eQ��kh���h��>��*��5o�&pˠk#�����#-�t�jJ�,���7+n"M�ڎ\3��膢	۲��N�BîVL�6����p.��������c�4u      �   �  x����n�0 ��~+�I���ۀ����^T�$�Q�����D���l@?`LG̛����(bX^_�V�`�@F�s^��B5�����hދ�D�v���6f���=n^D@���kJ�Xa�*:Ѕs�9i�������ۄ�<�Qg�`�8�������xh矉�D�a��;I'R/�O��3QA4!��Хۊ�~�3��Ic�3伭��l>�����>�<���{��`[��K�ɇAahyv��Yݖ|�f�G�z�Tͫ�ity��u�����Jy|z~Oӆ��ڬ�C6��|�܍2V$m�z�dh37�ڂw1V&oL�5qD�rnSwW�nqW�l��5��3�\�Tf2�LZ��6>6=��:E�ʬ��]�s6X�A�R��r�.�ȅkuX24cQ!Y�nl��*��2f�Z���,U��4��,}��&L�3����آ`�(�&
��֘Z�{��NL7���0^WVl`y�	u��(".����xk���"ذ�ǒ�����V8���|�u#X�m:�t�,6KeA�e� ٛ�*3ڴ�i����a�K���@��4�tܩ�d}D���YQ�����L�̉ŉ�H��01�*�=�<��T�|�f��j�q��"�i�ʼ��L@J�wk��1����Ae��ג��4�\���Ε����o�)��6����+'wah��K�u�8��{l����9om�ѻ܍�K�2��o2��xk�      �   H  x����N�0����{7?v��U!D{��* BV�O
u�u�Gk>����#QA%PI`wM׊�m�R
��v�4#����;:L�1�Z�ƶ��qX��
V7CSs6Sm�p�]|iA^��1�	�j%�_~�"�	6�fT>f��ɻU�!��Eʙ.j�ȡ��w��hDFd��Y(�D���Xt抰LA�2�a^�D֡lx?Ù�����4��� ��&�uw�3#�.A~;2sQN]�E���U'��45U��0��?�p��o�\o3@�Or�D�dա���q~ �\�P�m�{�����C�c��ڂ�N��e�l����=_q��cL�            x��\�r9�}��
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
>����&��yϖ��HJ�H��F0A7��.�h�f�pH3uv�H�ͦ��I�F�)0�l*�*x)�^P��6�J�k���Cv���?n蠥��@ߕ�Z[���	t�Җ���S);��m2D�hST>bS���x^��8tiIi�l��Q�+/勹���(հO���W�y�Nl�,:�X�\��ST��o�G��b��!�>�*��JF���f6�&*h��Q�Z���:��J맿M���y9J'         �  x���[o�:ǟ�O�/ pyd��n�4T��<U�\0!7H M��ӟ�%ĹР�2
������O�E,�`D��rl��֫�KZ���U%¾�@��}ö&�eY�e�p4�����,{�֬��ӷw��e�P<���C�
�#���M\_���V�[��b�� ���6���#:r� �0�d�P�R6۱�$�&.�L���EjtbO��*�w��c˗w%�:ٰ8�$m��[Q;�e#y�^����\���i1�3 ��<�.�iS]瞍u/����I"��=E(��nx6ƽtR���T���+�.�`i�?�F~`��s��(���G��k�L"*��B�¢��=6���������{�`�sS��=�S���r1����XW���m���~��mv��,��O%�~f�⽙�G3�>Ӣ���9(��yG ��sx��v
bg��E>�N��ۢ��,K7��넺�%g�?�9g�耆m���.��.=َ݆+ȧ	ߪ���a׏���P'\W�z�]�[��kլ�L"��3OO����x����"�m��Ü�ʣ�"J��
�� �B�N,�%�.��	U��}���*��o���`�Ƨ^*��(� GZ�0=j�L�*3/�Ģ1;Ye�G�ɯJ�_LEˋ�q���-��"
/�R�����9}��`���Z�S���N��NPL腎��4�ټ��0�>P�B+_Ʌ���O
�|$�u�` �CǾ$�{D*l�CA�&��y���GQ�KV�t�P�h6(����]6໖Z*�����k|;n��zR֦ݛ ֵ���I�[ ��K��Qqy,��(���۲;	@m(z�u��&҇�U.�P/Ŭ���}� ���}��y5�xX�N�dq�ck̶o� i��:��$L\��}��ix�-�&l�	!Y3�@ϫ+��%.g�!�A�x\u�k����n�����.��A�!�t�Oۊr��'M���N�~/Wp��=�v�@�s�������>��|xx�p^Ey      �      x��][w�H�~V�
=�J�+�ҭ�[aa$�A(���z)1��8{���g��!Uaag���N�l>���W&���b��/L�$ﮢ�5�AM�_	����c����|9��Y&\��l�W��Ȗ	��$X6��-�M�*�����c�qm<_D	_��S��O�;m���f{N��>���=��������~���q�k��ۛ���&�4�]�֊��eLӀ����	�l��b+_�������IM��i��9�=ó�m����������|��珛��f��*|��m��m*�ů�O�l�t=m������q6�K=���DǓ!�NyP����ix&\��]�a;<� L�	|_��(Y���XExB���������n�o�j�����?���� �O��Hihi _7��$����K�	r$��5-���O��h)OV�4ԇ�p��$�(���yu�@��'Ê��AD��=�����fX.����*��T"eՖ<g���Ʉ'��!��_k ��d�����OƑ6%�\�D5�ӿ��Ln�z�^��o5Ǵ=��,ҿ����7�2����n�p"j�te�@�Tù�A,T���ߠ��Ԗ�鹎�m����Z&-���|�A�ʤ��a�M�a���<g�	B�(�%�v��+%�@��R��B���ޜ��� �g�~?5o@�Ts�4m0{ɼϔ�󹖆�|��Y��:x�͆<i���2�Y�|B@S��7io�$�0}"z�|�
0��[��'ѪN��`$A�#��k^����8�"|���_��r�P��3�y���p8I�G�S�"�h�6I�ޔ�9��o6\�\8O*��_�4j=���]�]?滟��p���.~�'R�T��s]���f��Z���~�I�W���2b"i�����,�Q�$¹���Kƀ]><*�~!d���f����O@�p���:Ϡ�e2�j��&� z�n�>��x�~%ф_�G�3%xq8_�q�A@��$�x!��+����X���|��:��II"W^���H +
�J�3L⹞T �پ�P`�
�hi�$��3��(Fu��m��y̗;(z�}6���I��Y<�X����A<�VO��n�_�==~��6ۛ������z�?6ݷ�G��>�pΈw�q۶�9���Z�e;
~.���Z�L��
.�LB�ǂ=.x��d��E.F��s#��&p�k�b�r���2��'�ođP�E��L�2 ��L:fu�T�h�%`+H@4�h�Ǩ�/�%�1\��^��g��Ǯ�z���8!.�Y,4�0�DA�˨8��R�A�
�Z6t�$hՋ��m�Q��G���xGBs��?�� |���M��]|=�#������Mד&5"KO��)�ГD��!H�E��N2�u�ԑ'_����F�v��s�K��)��,����◸�=E�X�`ĳ}i>���w�_'D!��庮�~�0|�c-��	��^�|
�b�OQ�sDξ��p�p�����*E���Rc?����1&����VJ�I�T�
��*�mP��pp��iT,h�'�%Wѯ�
_h<�/g�2����aUJ���C`��"GQ偄�2�c�6��YE�ySR�O��}�ئ$!�dP����6�=9&��X ���-�gZ@�4��tݻ�C���A ���FOG	�� OGVT��k8#M�a���J�/����:�v�&5,bY��{�l�\�TQdm�1G�
^�K`AE��u���GO�1$��n\	�G��G}y²Ã.7_���SD@���I�2aYd���1���r�J�_���1$�ߦ��n�9ż�D�ޤ����[�s�8"��*6$���P�? ��Qӑ�K}�W%�|��\�1���lyj�<Ҧ|52�sPutD������=��h�'|�O{�n$<<}|.�/O�Q9Z@9�g{yݓg2j+2�K<��z*f���i
��9�-�������:>�L�T �<�B4����>By�������Js�BLe5�
/����C$4�Jۇ�u�<o~J&�
4�zTG�#j�	���-~TK#�n�xZ��M�r<]Pe�s�ʟwA��D��n����|�#��1ƍ>�1n�5��C�w�,�y�\���-P'��HY��Tq�&?�T�6����W���3��c�e˷-S�~,
�)�GY�� ��N �0*�߀M�R�Q=��O �[���B/�*�O&��Id����P�<[ ������c�h$�Ri�f��	%�r�'!X�e��k��q*��rD�~������9������?{�7��U��^��f���TLT�<�=FÇ�[���aqB��������{�
6.��ϰqa���z*3Ee&��ΗD[A�����w_������7[�o�$�Ʉ�. |?�V^�t�*��T���q�PjP���9�8\V�q��aD;�p��Q�n�:��ޅ�ɸ�y�� U�}H	����ҞI�	ND�޽���B7!��0�v�E�=����/Ϣ��c���������=��o�m~���u�j�~��<�ʭ-��0��)z�e��/�HJ<HY�<�!t�pj�i9�I˶�|s�^�+����6���@"N�(:5�!����1V��E ��0�&�Y�-�FK��h����t��a���;8��E=q��p�&V�xE+BD3\���	�fj��Û�����9���:�e;Ҵ���o-G��?R>�b�-u%�rm\�^���j��ӷ�[Wz��x�C������)�_�T��ϒE�e�����cb�Ԑچ	��*݉Z����6���6Su�`�����Fi�v��]�qQy�v��5�ٵ�1P����U�7J��ː1����pAj�� �yP�Ja)�\�*E�D�D����8�Ǉ?>=��׻rB�W�*�x
x����>~x�9H��,���A�m�V [�>�PSZ��	�� �7�6%Yѩ�#�/'���1�A�(�!��`���	\��ׯ�@k`�c�
�4 �����W\����}F(Mn�"�mٮ���Xγ�6DD �-�N�=a/@i�1�Sdg0=�/D#O��i8�|s�{��	+I6�E�(�hl`;�k
a�>�1>Q[9������\W%c�0_#��N��l���}����j��۾���P�� k��:�:��ۃJj$����q�zP��3�H���Y:],;��@�2[j�'��><����e���o�$���&�]~s�8��^�K$-E>*�g�HP�Vڴ��o	�NO�K/X�Q�n��]�}:}��b".)�p�Yn:��yw������;˳� ������BЕ��A�_�EY>�M��̏~͠F7�-5�e�Oো����D�1|�&�cِ��)��h�5Cj#~������0�<S"Z��,����}�yp�{�(Z�L@ٻ�*Q;`;�<<���i^G[>�Y�{>��_��4��E!�$�Rx
�{�B�>�H_��b�O�:&{Y#��ZΖ�6M2��m����
�k6Φ�+%AT�%��x�8�� ����>i�;���L���5�Q����1�p�=z�i�D��1	��g�P[�����	����W`��S 1�w���qx"Z�clx+ۉF�^�e�ο�w�;}�B��7��k�R'���.P�S� ol|&�8`�~�p:����L�4���,�y��R��aT������-��jsw�����Z����q�����7��1����?ߥ�V@J�@�(H�mx'M�ڃ���Ӈ� ����0�H�H	[�L&+���l����4��	[�u0P���vs�E#�^̕�7�}��N�j�:&/D�e�H����W�W����C}�@�7,[1 �ͫ{�f��Xb��u�����H�S��\쐿m�4���o6���D�U8����f��v49�������:��Q�G����`�A�!er"��lU�=u������v�1�볇[xyXC�o7����SW�������J!�HG��[�3xu��Y]�?�1l��V��@Y���I@�� ;  b>s�ň0��;Q�u^=׾&Sڃ߯ASZ�)#�#�>?Lj�Q�������Ɩ�|[�
E�tH6���k���)�,%�D^�����8�ӷL�D|Z!(�VŰ��l`5jE�@����Q�@���	�d�Ͱ�e-<Rӵ��o*�ۮ1,��AE?c��bnL������M�:# m��w�a���.�]��W-�;���T�*�9�@�l��ΑA�t,�@��[�^ �c�|7H��E�ȶ�ڰ��%��GOp��"���.k�aℒ��(��T���?���N	���������r��)�j�*&kv��fl	t= .�|~��`-���n��\��Ow ���nvy�D�S_�f�(�� zmZ�r��I{�"�hS�D��N���|�����M��ƤqA��D�ヺ�[FЖ֣��s��9XN\��1����a����m7`)�zO�*K߿/�����˗/=2�E�"�d>�,��x��>��]�E�nѾ� p�P�CJG�^㢛��e�O�sN���A#�Q��`ؔ�m@r�uX/ݖ�*���ɗ�n�-�I�!�q>wLӽ6�i���3)S�R_�m�9��W_�1fI�!��P�"t���F�F=xP50Nq I��'*�L�a�J# %���]eUV�|I�NA�$,���rL$��B��>��Z��ȓЁM��'�"s5[�-ǀИ���mǪ�{�~�Y�xY�V)�,Ds��>T���98&"�sFsxۋ����/�v�ڋ����g���'G���k�*H�`4���֑��낅^b0�r���G���L"��7���} I�F� ��������!��usQN���y.��m%�:/>Ad3��v����g%�D��V���A0C��	J[߀��\S��w�n���w\⣄zo@����+\�0;���a��X�~K�I��Is���^�NmK��U�,�"���*�Cl&U�,F �k�����tʾ��m�q0$��-�v�\�A�q�d���cyК���������dvU.#���^�>D��OH�|[E��So �ؤf�M��:uF����N�љ��SaH+���;`@��y�j'�f�hrtξ�X�,�X�%/ʿ,�5�����Β�~�6Xe6�7���l1�P�oh �h��g��z27t�����(�y���qS�L���b~\�1{Y�%�<�J"%�M�窀�LQ�OV��&�`M��V-1T�P��d���%ń�J�(�,P�ٶVۿg`DF�{�|ECC�'5���9܎y�6�n�z�Xo���SG���S^������1['s?��t���,b^&x�~��X�⫼.3!���cae������J�{�o����m���żႃ�I�jۮ�[�����JS�g�-�v�; p=ն��,*B�<۳\m��ׇ�W-�<�̷���>�p�q�bCëv���BG��iM�����⮟%t�m���<�>�����cl�A��[�%q�8��|���J\H!������X�Ap�R�m��'5�<������b�p��4�H�+��lBT3�l,�����(�GK�b�Im��!U�xU2��Qʟ���+q�졋�q��2��{�
�Rۑ�x9�(��R%߁ �}7p{M9�THc��p��+�~���*_�����]��3��17#�o6�cq݃\z�k��yP*���v����(���Y�"�y�L�@�I�%
y��x��"��i�y =8!��xb�X*��(̥,�����a7PkU�_0/��/�&�t��E�S���N���Z<�hVa�2�������o���\��t�o��:p�@���C �`E�ȘhD)��_J������)�VBG%�D�3���7�&��"DYBҪ]Kk�sZXm�t�7�Ġ�$�<��l�Yra�T����c$����	&��91Z5V���W�жc��$��7ǟ��Nׂ�����'(�Q��}B�����0�R�x�Q .ٱ:>{u�R�����}������yŤJ;���\��b>�i8R��#<թ���2�!/�E�Z��{�D�'k�)k�R�l*s�clp���)�MĲD�Ev�����S'Q��*���18�{��ٔO�{d�hV d�pAŉM�詘d�l�F�,���"��q��N��R)`�KXz�������Ǒgz:6��.���=`�ޔP�m�Z!�bLt�'�-G�L#mR�.ڏ{Mt���>i�s>|�2f�W'���`�\�>>C��I1�; ;T���㎰���,��#�f��FD�����n�M��lWj�΃<���E<�%��s=BHS�&���'��g�����+����Jo����i{SOF5p�$w-E8?
�:��b ���3	��GΞ4r�г�+؎lB���Q]�cᄔ�1F�و��6��^�#����iO��=UA���-�>[Ln��c9�����%�1��Z��D����s�b��kc�"DQ%=UYު��1�b�,;3��T�#�yE�ڼb�m��:�^*m`/a��*E�!O3���oܑ�{JA2 �eAE��R�S������||�����-�uj���u�c�0��+�(���oX@}��c�xY�ӧ�NI�a���_�������pAE��B���Y9��rw@�Qw�����e����e�K<��@���kr-��G�������@ �:]�+GK����"]X����!Hڬ�>���t�uPI�po�0�#���㙊h�������냒���cC%h��Y�		+���s�.w�M'�)^w�{[�����>�_@_���]!�zT>��ھuԕ��S���# ��·X�E���
��0u�<!C5ZFo��#�W$S�,(�Գ��cQW޼ב�$���<~��[�{V-��Z�hH&����*X�T�F,1/�m��H�#fo1K��l�6����ɬ ��������I�c��d��: 8�3��(���I�E���� ���o�7��� �Lƿ��� �E��K��Y�L-�ѴY��x�����㠷��%~9���(x�H?�7���ɗ3E��qyjY��}�G7�Ұ|��R\y!����wY+s+>[���h�O&c�t6�R�l�dl��y��_��@�4���	:�7p��y�J(��[F/�B� 6X��T�d~��G��)U�EN�F
�zpl����M�Rhb2��+�,�>9�PWG�î\�]�$큣�� )���"r;$1LA�I��i�o�}+���\�\2&�'�/�!�U!Z��D�C�O{����\*j�0m�籞�F��d��+D-��1-����8A���U����8��z4f��=����?{�T����4"G|R�g�椊��4��GB��i���f�#����8K2�Э��o;��A�2��;�,�8�Ck���C���.t������W,� q�~��&��T)5q�C�.�Zy&>g�8���)�򕴛�b��#0�����@�n��н�u0���fi�CBW�R�z����pbx�XO��7ؤ͇��*N<1�b!�s]���/�2~����+'|�            x��]�rG��=~
^@MeVe]�� _��>��� �h���b�}��Y}�����XC��3�W���ʉ�oР91�ĸG��&�:_C&�����?n�����g�O`s�{��;;?��yr^�67��Wlo��n�l��b�<��۽�]�gw��ϻ�w����c�����L�#���{���������������� /�S��4�W_o�^��r�=�w���}{��0�/�#o��;������CC����l�t��rӡ��哋�lo^�~������~7�X$Р�c�D�h�����|�[����cb�����V��ŧ�w�������|�ޚh7�m�oZ�n}�/=Fp��?�X��V?�1|*�����b�§Y��������g�k��|t�4�a��be=b��/���H{�Y#=��kE?��?�X��՗��X��,m��Ϛ'x
�b��w�����?/��>=��M�K��n��R�k��m~y���?��w��c���?{&�U��
�4�N�T@��T����O}�l��~���,�w�
��������/�E}^���q��Q�ck�S�����`+��@�<���z\��vw�k�V��4����B�Y��z��F� � :���������d+"_X�A*�0[p���z����)]�F�8eS@H�
Gb�,��/;�	�_�K���S���P��߃�afK���+�M1�Sc��>����|�S��>~���<Y�*��j�m1�w�
6:��_���l��·P�_y���f��5fO�H�0n޿���}��#�\��N��V����_-�m��#����ݫ?�޾���&���Q�8�2��I)��0FGb�^������������?k�J���������?=�����6VFu�{��?b!�螰J���l �G�1�y����t G��o��j�f{u��~���z�n&�7��L:5>�CƋ�}}��5c��x�X�1��?(��M���a�t�;�������[O�¿�S^+5�>�tJ��]�'���h�xl�8U����IBʝ�T��[�l�u2+�'�J��� s�M�X6���S��ճ��ײ���=��y���������w�֡J4$O]��}(;��"�r��׃ "A����9��
���O^,�#�)Om����ɓ�[ �X�:8��K�wH�}j���Ծ����!��ӧOz��u԰�}_�S`��8��)�.K�2�j����c#HY-�����}(t�t��bf O�đ���=��ގҿ�E��������k����5�`�]���|�y��ѣ��{Vga��XC��R��p,�S�`ZAp�9HGi�u���&��p�֞�X�#>��oZHQcb���"��D��MH��эBR� � �7�l,�q~�H��E�����ߕ^�^|���69��x�0��D�M����_+so��)B�aȀ$�e�(P*⑱q���%�����Ui�ľ^l G�ޔ$�'1Y~��ZJ��Ad�m��v?�y����]�_FLb_���[j�E3F��
���g��>��ͯ��Hǣ��\�=�S4�����5|X���3�4|VT?봱�x#(�t�X�+cp��_d��L��o���o�po��`r���ƹT���m_�Y�v>j�����������#�L1H֕��>�¯q�Ch���LWx(��g��Ӊ��9�4@o�d����YB_�NϦ���www�������s`5�����±<T�7��~�}znu��賗��k���G����)�*V�X���GJ�pH �B_� m��%�&\SCgU�q�b�S��"�e����y��ߪ��-�.��߫�H�Ux�؎5s��۷o�������f��?�X꭯��۔�ܘ��@���spP�:�s�9���!9p��(�1��l.��E
��S�{
��$���Ď^����^�Rq8�'s�`v�X�v3'���\C=�/��s�V�3���1H�6<H�����e�ޑ�Tc�'g?~�b����F�dtX�)�����'�)+�����<���~����yu��8�7Ȱ}{���2W"�:���ȼ��AV�ޅ��k~���tv"Od���xu˯�Ņ�� &%8���՝�.�ܾ�}?D�%�緷ok�l��"nBL:�{3摱M�-;�N�Q�?�����U�+<�`L�Isy]�&�B�(�LG"W�a�hN�W��Ͳ�r\[(�έ�KM�8WII��!{��e;% �9��:*���̙ϴ�F��[�s�0�C&N<E�"PQ��q�M��4����˛wŪw%�x2�0��#C�R�G�y?��3�%6LK#dݤ��]�Ӑ�Èn�.�2�r!�:K���w��<�®�
ToE*8XQ�R��v؇�@"$�ҟE���)�D�+�Um�̍6V���L"��y �W�G�q���
��,����?���a;������>�ة��%��Wx*KZC;X���G��8�+  V�/�*�#����8��"�
�������9�\�쥼��l&�KÂdC^�MQa�]� �i
�xa�~�ȹ�7ŏ47����<��։���QJ��Gv�)�f��l���96=�M�\E���A�3�kS<۴�Ƽ�vqH�"�^�w�^Y�F���o-W,�8o@��eUW)M��d��T��h���Y�ݛo;�{S���(�#��+y�dc��|�!FU���1 �NC�$�3Kz�#��qLJ���@U�Q�N=x�s�R���
9'^�l�۬��!𚤮�C|VZ\����&�d��?�O�kT�׳b.0����-�@{ӫ1��g\Qi\=a�T&�PZz����8\>j�c�TI�������U�er%*���]D� .}`rsAr#�w�6�?��rTH�"&���4'�鯿�fi���^؛��V%#�f򬘬J��!�(i�d�$>�s7ꪚ&ԅS�?�?����:��(�(�k���>���X��;��ϟ.�2���#���Ml��6��b�����i(�6M���J��F� �b�j��>9�Z0�祭�:^n���1<8�a�Ac�E)�D��|�z�Rg�O28l ��$��6^���$X-0_�����ЦU&DVX*����80�����u(r���A��j�v�K�!�$�� 1�P�C�@�I�Dj=#���X#ev���&�N&��P��`�AG��T�Q��C�]����d�4�r���n����X�j��c>Nf"�a�:�y����'�
2�w��k[�B���Je-!�B�}�'��0MH��h� I�����	;7)����q�q�[2Uy�����	�!}��ZA����l	q
Y��V�7�pv��N��A�_q���'b��M�;�v�RqA�@�kP�a,��P�j��h6�H~=�fa�n������h�m0:��>�"G�~�f>�U�p)v���*YS~7�몛��M7"�x.;��u��e[��#�L��&i��
Y�����(�AV�)��?�į�E�y��u0)��2w7/�A��$�]������������vw��)O��Q^���Dt��vZ˂��L��Ο��":Q#�!7gh/suc"j�rUQ�5�Egʜ��/��F@���n�1ڑ�>Q�ۏ~(�ƾ��?��q�F����I��Љ6�K�7��|B	�#�08q��yqþ�~;Q��^_���%d����AU�	q��:.(��Ӿm���W/�����6��F%���7���V����µf0��#�*����rS�R匉H�wvj #�E<���L�B_!.� ��
��ĺk����`����ONy \p��M��O���i��ʰ�4 肸�d٠��e=^i{�b�B�h�1@
�o�
��H~��� �fL-H�V�=ST�G9j$�����06Tc3l_�o��GC;�u�����.\|cJ`��]]X�Ba?)���ݮ����$���&aO��ͼ����@l��Jވ��8}�~� [  	�oԳ�I���n�}���Z����굧2��$$�*���8�������S���'�!<��.p �ֈIi��_M#s�ع��ȡ�{b��Jg�l,���l�p���V!�--��R����r�F�},(�}c�~ǲI��?�W���SK1�ɏ
*t���"s�'"pu89�	P�ð���˞yPEo���-�ĸ�n�;�H��\���2��,�	b+P\��uf+m�q��y��Hd4Fm�?�,�8��T��d��~�b�.?D��qwQ�`N��q�E!}�qpC1_�$/��"��"�%nCkՏ����Kc�(c����{���"	���@[����cd+�3o��48��|B��Ņ~Ȳ�V�C��?U�a*nG,�LM�Q0G��[���H��v�RH&���HiNc�� �PZ~�z�S�b�ӽ�~0J�k?��`!�z�ߤ�L�
��շ:z��N��r7wqy������]����_m�K�l��o���p�
�������6D�Cy��e%�����Xp];�
P qhH�T�N��k��������/+@C#�y�r`�-����/�x�ݙ�(p��ֈJy�����oew� i��x�y���Q����d��<2N���[*�(,�H��s)Rkc���=��,����4K$P� �x*a����}s�25$��b��	m���E��W��9JJF���	���\�tI��-o�����%/�J�.�2�'�t�Wq�U\R�E�&��{�~Ko�.q���EjMh��_�m^��񠧤��5�Q��
� ]�c�s����~�C�`D���C��i�MO&���K�M�сf1�璈��z�b=/ׄ����%��%�'����(��綊�\��[����c�N��sa}�9�7�	.N�%Z��:66t���U��^G��2���eI9�AHvg���Kb �P��:�y��4���	Y��m1 4���C�"�=�ՑH�$��O�Rf����$������r ��\�#���}�$FG���T����c֘���S�{��)�,�d����j���7���Nq�k"��:��c����I}�2�1(ӓ�I�moF����>��Ƿݍ����_c.�|	.�{�ֳ)@�p{C�i��eO 'I���$�&Iz����?oaN�Hk�vC�G�A����Q�52#�����"c�Cd+(?*�mܐ��4̥+��X�%���X<{�����,�pӢ�d�|��I�?��)��ɏۛ�V|}_|�����N)Ġr�b��z��{���y@j�F�D�%�&���o{��|m�f�K��0s@ WV���
}�S��
S_�'3���ox9c
{�v������<��Y�v�n�N7�������G�!�(�=�ܶ0��u0iS�W�����ä������8!V�|G�N�P��i�;�>P��5R�����+%�֫W4@A���5���Hii|0R5������[*J}�78D���*ROu;��Ty3I����/G��i�� �b�#�
�3	k�袨63 �@�	��D�ts$T�y&���I/w7o�$p@���)	<{�/.�a����^X����m�ic��}W����  �ew��x� �t�N��{�������^�kIАD�#����� ?-D��u��/I ̺���{-���O�ok�$af�)���Z���4.�] �$�0�9q�� ��	���T���>'_���h9yC���	�at� 'JY��/��"Xc�����eZ'����|ߦ�d��	�o@�-R"�ytEty�i�@����!�(����8ۋ�P�P��D5R7D*S��k�C(B[�Hi��+��
����e�J+<<j��
�C�߃� K4����=u�e0!��ʘJ2� &���yRZJ�{���������q��Gh�h�`:6^ʰ�wQ�Ѕ4ɢ�P/Ė!�,B��X��_(�ŭXp�b[�L�	ˢ2,[G�g����͵r'��>�,v	��y�����\*x����D�ߺI �^�w�'�*�/4����N�>,�� ����FU�0kV�E���8'���Fj�=�Y�qE7N���Z�ҕ������8b(            x������ � �         �   x�e�Q�0D��S�	����g�L��]�Ʋ%K!r{������f�E�IOaF�T�ғd�>a�ohh7����a$u�h.J�3�̉T����a�,cv�H�mR27}�*y♂k5�%|��:I���^�L*aL�z��ߖ��r���i�JK���xsF����>	-ߎ��q�3o�͑�콲־ Ƀt8      
   ,   x�3�tK,�U�MM�H��,N,����2��J�rS22�b���� ��         5   x�3��/-JMNU0�2������lc.8ۄ��6�2��͸��ls�=... �{�         �   x�]�K
�0���=��
�7m�ґ�%��B��~Ӂ���|p�����~������F�3�l}�P/����p,�L� �G/j�P� �p`b��)���-&?����嫎4�%Dէ��!��q?� hhQj         /   x��J�I��L���􂱸��r�sS�3���Ē��<N7_�=... �x�         3   x�3�I�PHK-I�PH+��U�,I͍/(�LN��M,P(IL�I����� E�         �  x����r�HE�ֿ�����nJ$�O�
��Ğ��1my£����z`��O~��! o�P	N7��e4V��Z�r�W�nP�qP��ZU�`x���p*��t���t9��kU]NZ�_N��_���G_�� ��{����p�f��[�i��n:ےG7i�{?���i�N�3�7]�,�;]�굯=Vys��/~��x��?S��_����[-|�k���S�uwy��b���_=���w���@�,>�z����ɯ�^o�~�����8���8N����6]ϪW�i|���5�؅޵��mһ��Ե���]��͵���u��]�������-��3�m�ѽ��:��ݲ�/������*��7X�j;t?:���͏���o�W.���B�{*�"�S��O���'Zs߁���\�ݑ�E�'0�������Yt�c���\�ޓ���	M����ԝ��K.?���}�Ħ�V��ԍ���,�ܪ��������'4��CO7��m�m	+HXI�*6$a#r3�e�n�|=n���]oHг���A��ps���Y4���Uи
�WA+`b;��[�E��h͂�YP4�fA�,(�E���,84�]áYph��f��Yph���B�f�@�P�4h
4���B�f�@�P�Y(�,�hJ4%�t�f�D�P�Y(�,�h*4��
�B�f�B�P�[]h*4��
���������������E�0D�0D�0B�0B�0B�0B�0B�0B�0B�0b%����1��1��1��1��1��1��1��1��1��1���m�ڶ���o��m�����s��m���V�l*`	[hXC�Ѱ��U4뢅����hau��>ZX!-��VI뤅���Zia���^ZX1-��VM릅����ia���~ZXA-��VQ먅���Zja5���ZXQ-��VU명����jau���ZXa-��VY묅���Zka����ZXq-��V]뮅����ka����ZX�-��Va밅���Zla5��[X�-��Ve벅����lau��>[X�-��Vi봅���Zma���^[X�-��Vm붕u�ʺmeݶ�n[Y����V�m+붕u�ʺmeݶ�n[Y����V�m+붕u�ʺmeݶ�s��5=iͦ������ikx�����Y����V�m+붕u�ʺmeݶ�n[Y����V�m+붕u�ʺmeݶ�n[Y����V�m+붕u�ʺmeݶ�n[Y����V�m+붕u�ʺmeݶ�n[Y����V�m+붕u�ʺmeݶ�n[Y����V�m+붕u�ʺmeݶ�n[Y����V�m+붕u�ʺmeݶ�n[Y����V�m+붕u�ʺmeݶ�n[Y����V�m+붕u�ʺmeݶcݶcݶcݶcݶcݶcݶcݶcݶcݶcݶcݶcݶcݶcݶcݶcݶcݶcݶcݶcݶcݶcݶc��c��c��c��c�������b7��n��톿������?b���!ѫ|C�W��D��ip��^xC����D{b(u�1��Od#��h�2�RƢq�X4R��*c�he,��E#֋�Ǔr�>��h�n?}����D��������h	L��&�Ym+����X�hC�P8I�_<f���_ցZ�}�3�B�*ܐnI�
7�@��R�)P�BM�{˦3cъ�X�d3�ٌE�6cѪ�X�l3֨n�Fۋzc�q�rƮ�{\���n��5�k{z\������5�k�z\������ή?߇3��x����l�\�?d.�2�������E�ä���d͆"B�DD(�E��h"MA���P��#Ԧ��[c��d�]�&*���_�������i�%0�~�h;	L��&�L�%���V�IbI����0����Ʃ{�m3ci���?Q�HT�-�D����&*�Vm�9hk�X�t��5cm�Ŷ،�I�U����Q��6)c�	��"���D4[W"�+Mԕ���JDst%����\�hpnn>5�-��s�ފnH>9�-����zֳm�Zxxc'Q��LT�@��DE�4Q�JMT�Xզ^ц�S�6���I��3�&_�M cm��2�&c�M��_=����DE�6QњMT�d��DE6Qm��)��7���I{S�X�|�7���7��2�PxO�������,�Px/�������&J�o�7M0QMBE��70Q�\m7��/�]�De�V��W+R٫�6W�m�����Hea���0��m�	k�.�>���ʅP�ku�hC�qі��M��E�B��6�m=.���@�C�>1���O=����Ch�����>�(�����N���;���(;C��g� o��SCʎ(;/��P���Bʎ	(;#�6�ώF�I��Q�H5I<��&��Gt#�}H\�i�ၶe7��{Pv�!@ٝ� e7Ԥ��m� ewb��j�)x�5R��vJ+�+���@���>����@�;�Hx���~Nq��ec��_&P���~�3@ُ(��� ��-�~�[���o����b�"���@bO��ц���������<��t�T���He_܏T���He_ߏT��He_�T6
���yK����ls�\��g.��3����6��e�y�Z�/�	�^.�w���i���L����(�V����(�F����(�6��3����ⷉ�I����������Ulv����͝���D�C�Md0<:����D/ � E�l�=�va�>z��G6�<g�h�(0�5ٍ�.�nLvEvc���⺳˱�]�ݘ�b,�<�P�$�c�j�%xd9@-�D�+��n��5i�����'.<�����z����kU��z��_�H\�;9�"2�*q��"2�*sp�����v:˞߄e�n��[��%,����f	�6��e{Y���2��r�o��=��o�� ̳��6O�	X�X�5�����Sw�O�%.�A�%?��;Zx�/q�Y�ąg�����g�2ج�X�]���h���7`�l�P�^�b�Pm�h$�I�*zHT����Z�`��@+��uvZ��@��p���]��]�wuW��(�T�l*J6%���MEɦ�dSQ��(�TTl**6���MEŦ��R�'����C�㏿��o�~����x�<�^O��㋔��x��^ܡ8U��`p��e�����T�z>����4��Rɡ<N/�����o�?o8 }�x������������������÷�~;��n���������?Ƌ3            x��|�rI��3�+���}�S%H	� y�T]���X�E�JT�������̤D�-++�Bf�p�r���>��������`������'BO������a�������,<��X����q���%݅��8����j���|5�Ь/���Y�򱹸���^O��#�l�,�hlQ�2/����PK�q��dXI6����Eo��ZW���{;ZO��|��w���8&�	q��D��0����<����6<=�����ۧ������R��>�g%=}yx�vo>]��/6���|9��ւ1ݙ:_�x�^#�N��EХ&gj�9Ƌ�:[��O6Z墮Uʠ��)!�T&a�����QS��Ty0U�a&n�1<ގ�?¿ß���ݿ���x~_����szz~(�������ϻ�00u}1��Y���_W�z�ڞn���z{ss5��~9_4�+�YY]2���K�&k����&8�X#,㉱ wK�`�2Q[F��6���LO����Q���f��-;a�]����ͯ��r�l��ѯ���yܜϖ�6�\��\�3:UL��)��[�D�J��u�)";F��͓��Y���xF�T��M�`����N�G.���_v���l�����)_��:!�*B*�T+&i�x�5�D�H,.������A%E���	�b"�D�����M�w��D�.�f��؎/��f5FA]4��������f�����W��|3;�Dw�\5�_�[�@z�TvA��L���{#��ffEME�ʂw�9#�B�i.�ͪ�D�YVO���Gͳ���<iO$�c9��.?4��>�xq}�,7����y<]]o.P!F��:ZN�8��]rQ�p���'��ǳ�%9�[�Nko)T��j�*�(�V��0
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