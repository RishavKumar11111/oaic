PGDMP                          y            oaic    13.2    13.3 E              0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false                       0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false                       0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false                       1262    16384    oaic    DATABASE     Y   CREATE DATABASE oaic WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'en_IN.UTF-8';
    DROP DATABASE oaic;
                postgres    false            "           1255    24593    update_invoice_number()    FUNCTION     ~  CREATE FUNCTION public.update_invoice_number() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
	UPDATE public."POMaster"
	SET "VendorInvoiceNo"=NEW."InvoiceNo","IsDelivered"='true',"Status"='invoice_generated',
	"EngineNumber"=NEW."EngineNumber", "ChassicNumber"=NEW."ChassicNumber"
	WHERE "PONo"=NEW."PONo" AND "OrderReferenceNo"=NEW."OrderReferenceNo";
	RETURN NULL;
END
$$;
 .   DROP FUNCTION public.update_invoice_number();
       public          postgres    false            !           1255    24595    update_mrr_id()    FUNCTION     �  CREATE FUNCTION public.update_mrr_id() RETURNS trigger
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
       public          postgres    false                        1255    24596    update_order_po_intiate()    FUNCTION     �   CREATE FUNCTION public.update_order_po_intiate() RETURNS trigger
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
       public          postgres    false                       1259    24688    CustomerBankAccount    TABLE     :  CREATE TABLE public."CustomerBankAccount" (
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
       public         heap    postgres    false                       1259    24686    CustomerBankAccount_id_seq    SEQUENCE     �   CREATE SEQUENCE public."CustomerBankAccount_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 3   DROP SEQUENCE public."CustomerBankAccount_id_seq";
       public          postgres    false    281                       0    0    CustomerBankAccount_id_seq    SEQUENCE OWNED BY     ]   ALTER SEQUENCE public."CustomerBankAccount_id_seq" OWNED BY public."CustomerBankAccount".id;
          public          postgres    false    280                       1259    24661    CustomerContactPerson    TABLE     �  CREATE TABLE public."CustomerContactPerson" (
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
       public         heap    postgres    false                       1259    24659    CustomerContactPerson_id_seq    SEQUENCE     �   CREATE SEQUENCE public."CustomerContactPerson_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 5   DROP SEQUENCE public."CustomerContactPerson_id_seq";
       public          postgres    false    277                       0    0    CustomerContactPerson_id_seq    SEQUENCE OWNED BY     a   ALTER SEQUENCE public."CustomerContactPerson_id_seq" OWNED BY public."CustomerContactPerson".id;
          public          postgres    false    276                       1259    24757    CustomerDistrictMapping    TABLE     �   CREATE TABLE public."CustomerDistrictMapping" (
    "CustomerID" character varying(255) NOT NULL,
    "DistrictID" character varying(255) NOT NULL,
    "InsertedDate" timestamp with time zone NOT NULL
);
 -   DROP TABLE public."CustomerDistrictMapping";
       public         heap    postgres    false                       1259    24698    customer_id_increment    SEQUENCE     ~   CREATE SEQUENCE public.customer_id_increment
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 ,   DROP SEQUENCE public.customer_id_increment;
       public          postgres    false                       1259    24650    CustomerMaster    TABLE     /  CREATE TABLE public."CustomerMaster" (
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
       public         heap    postgres    false    282                       1259    24648    CustomerMaster_id_seq    SEQUENCE     �   CREATE SEQUENCE public."CustomerMaster_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 .   DROP SEQUENCE public."CustomerMaster_id_seq";
       public          postgres    false    275            	           0    0    CustomerMaster_id_seq    SEQUENCE OWNED BY     S   ALTER SEQUENCE public."CustomerMaster_id_seq" OWNED BY public."CustomerMaster".id;
          public          postgres    false    274                       1259    24672    CustomerPrincipalPlace    TABLE     �  CREATE TABLE public."CustomerPrincipalPlace" (
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
       public         heap    postgres    false                       1259    24670    CustomerPrincipalPlace_id_seq    SEQUENCE     �   CREATE SEQUENCE public."CustomerPrincipalPlace_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 6   DROP SEQUENCE public."CustomerPrincipalPlace_id_seq";
       public          postgres    false    279            
           0    0    CustomerPrincipalPlace_id_seq    SEQUENCE OWNED BY     c   ALTER SEQUENCE public."CustomerPrincipalPlace_id_seq" OWNED BY public."CustomerPrincipalPlace".id;
          public          postgres    false    278                       1259    24581    DivisionMaster    TABLE     �   CREATE TABLE public."DivisionMaster" (
    "DivisionID" character varying(255) NOT NULL,
    "DivisionName" character varying(255) NOT NULL
);
 $   DROP TABLE public."DivisionMaster";
       public         heap    postgres    false                       1259    24724    InvoiceMaster    TABLE     �  CREATE TABLE public."InvoiceMaster" (
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
    "ChassicNumber" character varying(255)
);
 #   DROP TABLE public."InvoiceMaster";
       public         heap    postgres    false                       1259    24737    ItemPackageMaster    TABLE     @  CREATE TABLE public."ItemPackageMaster" (
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
       public         heap    postgres    false                       1259    24750    ItemPackageSizeMaster    TABLE     s   CREATE TABLE public."ItemPackageSizeMaster" (
    id integer NOT NULL,
    "PackageSize" character varying(255)
);
 +   DROP TABLE public."ItemPackageSizeMaster";
       public         heap    postgres    false                       1259    24748    ItemPackageSizeMaster_id_seq    SEQUENCE     �   CREATE SEQUENCE public."ItemPackageSizeMaster_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 5   DROP SEQUENCE public."ItemPackageSizeMaster_id_seq";
       public          postgres    false    286                       0    0    ItemPackageSizeMaster_id_seq    SEQUENCE OWNED BY     a   ALTER SEQUENCE public."ItemPackageSizeMaster_id_seq" OWNED BY public."ItemPackageSizeMaster".id;
          public          postgres    false    285                       1259    24628 	   MRRMaster    TABLE     +  CREATE TABLE public."MRRMaster" (
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
    "NoOfItemReceived" character varying
);
    DROP TABLE public."MRRMaster";
       public         heap    postgres    false                       1259    24616    NonSubsidyPODetails    TABLE       CREATE TABLE public."NonSubsidyPODetails" (
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
       public         heap    postgres    false                       1259    24614    NonSubsidyPODetails_id_seq    SEQUENCE     �   CREATE SEQUENCE public."NonSubsidyPODetails_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 3   DROP SEQUENCE public."NonSubsidyPODetails_id_seq";
       public          postgres    false    272                       0    0    NonSubsidyPODetails_id_seq    SEQUENCE OWNED BY     ]   ALTER SEQUENCE public."NonSubsidyPODetails_id_seq" OWNED BY public."NonSubsidyPODetails".id;
          public          postgres    false    271                       1259    24597    POMaster    TABLE     }
  CREATE TABLE public."POMaster" (
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
    "MRRID" character varying(255)
);
    DROP TABLE public."POMaster";
       public         heap    postgres    false                       1259    16793    StateMaster    TABLE     y   CREATE TABLE public."StateMaster" (
    "StateCode" integer NOT NULL,
    "StateName" character varying(255) NOT NULL
);
 !   DROP TABLE public."StateMaster";
       public         heap    postgres    false            	           1259    16953    VendorBankAccount    TABLE     j  CREATE TABLE public."VendorBankAccount" (
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
       public         heap    postgres    false                       1259    16951 #   VendorBankAccount_BankAccountID_seq    SEQUENCE     �   CREATE SEQUENCE public."VendorBankAccount_BankAccountID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 <   DROP SEQUENCE public."VendorBankAccount_BankAccountID_seq";
       public          postgres    false    265                       0    0 #   VendorBankAccount_BankAccountID_seq    SEQUENCE OWNED BY     q   ALTER SEQUENCE public."VendorBankAccount_BankAccountID_seq" OWNED BY public."VendorBankAccount"."BankAccountID";
          public          postgres    false    264                       1259    16916    VendorContactPerson    TABLE     �  CREATE TABLE public."VendorContactPerson" (
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
       public         heap    postgres    false                       1259    16914 '   VendorContactPerson_ContactPersonID_seq    SEQUENCE     �   CREATE SEQUENCE public."VendorContactPerson_ContactPersonID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 @   DROP SEQUENCE public."VendorContactPerson_ContactPersonID_seq";
       public          postgres    false    261                       0    0 '   VendorContactPerson_ContactPersonID_seq    SEQUENCE OWNED BY     y   ALTER SEQUENCE public."VendorContactPerson_ContactPersonID_seq" OWNED BY public."VendorContactPerson"."ContactPersonID";
          public          postgres    false    260                       1259    16980    VendorDistrictMapping    TABLE     �   CREATE TABLE public."VendorDistrictMapping" (
    "VendorID" character varying(255) NOT NULL,
    "DistrictID" character varying(255) NOT NULL,
    "InsertedDate" timestamp with time zone NOT NULL
);
 +   DROP TABLE public."VendorDistrictMapping";
       public         heap    postgres    false                       1259    16903    VendorMaster    TABLE       CREATE TABLE public."VendorMaster" (
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
       public         heap    postgres    false                       1259    16932    VendorPrincipalPlace    TABLE     �  CREATE TABLE public."VendorPrincipalPlace" (
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
       public         heap    postgres    false                       1259    16930 )   VendorPrincipalPlace_PrincipalPlaceID_seq    SEQUENCE     �   CREATE SEQUENCE public."VendorPrincipalPlace_PrincipalPlaceID_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 B   DROP SEQUENCE public."VendorPrincipalPlace_PrincipalPlaceID_seq";
       public          postgres    false    263                       0    0 )   VendorPrincipalPlace_PrincipalPlaceID_seq    SEQUENCE OWNED BY     }   ALTER SEQUENCE public."VendorPrincipalPlace_PrincipalPlaceID_seq" OWNED BY public."VendorPrincipalPlace"."PrincipalPlaceID";
          public          postgres    false    262            
           1259    16967    VendorServices    TABLE     �   CREATE TABLE public."VendorServices" (
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
       public          postgres    false    202                       0    0    approval_desc_serial_seq    SEQUENCE OWNED BY     U   ALTER SEQUENCE public.approval_desc_serial_seq OWNED BY public.approval_desc.serial;
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
       public          postgres    false    207                       0    0    dept_money_config_sl_seq    SEQUENCE OWNED BY     U   ALTER SEQUENCE public.dept_money_config_sl_seq OWNED BY public.govt_share_config.sl;
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
       public         heap    postgres    false            �            1259    16422    dl_item_map    TABLE     �   CREATE TABLE public.dl_item_map (
    fin_year character varying(10) NOT NULL,
    dl_id character varying(30) NOT NULL,
    implement character varying(50) NOT NULL,
    make character varying(100) NOT NULL,
    model character varying(200)
);
    DROP TABLE public.dl_item_map;
       public         heap    postgres    false            �            1259    16425    dl_item_map_1_old    TABLE     /  CREATE TABLE public.dl_item_map_1_old (
    fin_year character varying(10) NOT NULL,
    dl_id character varying(10) NOT NULL,
    implement character varying(70) NOT NULL,
    make character varying(70) NOT NULL,
    model character varying(70) NOT NULL,
    model_id character varying(70) NOT NULL
);
 %   DROP TABLE public.dl_item_map_1_old;
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
       public          postgres    false    215                       0    0    farmer_receipts_sl_no_seq    SEQUENCE OWNED BY     V   ALTER SEQUENCE public.farmer_receipts_sl_no_seq OWNED BY public.farmer_receipt.sl_no;
          public          postgres    false    216            �            1259    16442    head_master    TABLE     u   CREATE TABLE public.head_master (
    head_id character varying(10) NOT NULL,
    head_name character varying(30)
);
    DROP TABLE public.head_master;
       public         heap    postgres    false                       1259    16998    indent    TABLE     �  CREATE TABLE public.indent (
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
       public          postgres    false    218                       0    0    indents_sl_no_seq    SEQUENCE OWNED BY     J   ALTER SEQUENCE public.indents_sl_no_seq OWNED BY public.indent_old.sl_no;
          public          postgres    false    220            �            1259    16453    invoice    TABLE     ]  CREATE TABLE public.invoice (
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
       public          postgres    false    221                       0    0    invoice_sl_no_seq    SEQUENCE OWNED BY     G   ALTER SEQUENCE public.invoice_sl_no_seq OWNED BY public.invoice.sl_no;
          public          postgres    false    223            �            1259    16464    item_price_map    TABLE     �  CREATE TABLE public.item_price_map (
    implement character varying(50) NOT NULL,
    make character varying(100) NOT NULL,
    model character varying(100) NOT NULL,
    model_id character varying(100) NOT NULL,
    purchase_price character varying(20),
    selling_price character varying(20),
    tax_1 numeric(100,10),
    tax_2 numeric(100,10),
    tax_3 numeric(100,10),
    fin_year character varying(10),
    sgst_1 numeric(100,10),
    cgst_1 numeric(100,10),
    igst_1 numeric(100,10)
);
 "   DROP TABLE public.item_price_map;
       public         heap    postgres    false            �            1259    16467    item_price_map_1    TABLE     �  CREATE TABLE public.item_price_map_1 (
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
       public          postgres    false    226                       0    0 ,   jalanidhi_dept_expnd_payment_desc_serial_seq    SEQUENCE OWNED BY     }   ALTER SEQUENCE public.jalanidhi_dept_expnd_payment_desc_serial_seq OWNED BY public.jalanidhi_dept_expnd_payment_desc.serial;
          public          postgres    false    227            �            1259    16478    jalanidhi_payment_desc    TABLE     N  CREATE TABLE public.jalanidhi_payment_desc (
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
       public          postgres    false    228                       0    0 !   jalanidhi_payment_desc_serial_seq    SEQUENCE OWNED BY     g   ALTER SEQUENCE public.jalanidhi_payment_desc_serial_seq OWNED BY public.jalanidhi_payment_desc.serial;
          public          postgres    false    229            �            1259    16483    jn_expenditure_desc    TABLE     �   CREATE TABLE public.jn_expenditure_desc (
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
       public          postgres    false    230                       0    0    jn_expenditure_desc_serial_seq    SEQUENCE OWNED BY     a   ALTER SEQUENCE public.jn_expenditure_desc_serial_seq OWNED BY public.jn_expenditure_desc.serial;
          public          postgres    false    231            �            1259    16488 	   jn_orders    TABLE     ~  CREATE TABLE public.jn_orders (
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
       public          postgres    false    237                       0    0    log_sl_no_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE public.log_sl_no_seq OWNED BY public.log.sl_no;
          public          postgres    false    238            �            1259    16517    mrr    TABLE     g  CREATE TABLE public.mrr (
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
       public          postgres    false    239                       0    0    mrr_sl_no_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE public.mrr_sl_no_seq OWNED BY public.mrr.sl_no;
          public          postgres    false    241            �            1259    16525    new_item_price    TABLE     ?  CREATE TABLE public.new_item_price (
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
       public         heap    postgres    false            �            1259    16537    orders    TABLE     n  CREATE TABLE public.orders (
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
    order_type character varying(30)
);
    DROP TABLE public.orders;
       public         heap    postgres    false            �            1259    16543    payment    TABLE     .  CREATE TABLE public.payment (
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
       public         heap    postgres    false            �            1259    16546    payment1_sl_no_seq    SEQUENCE     �   CREATE SEQUENCE public.payment1_sl_no_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 )   DROP SEQUENCE public.payment1_sl_no_seq;
       public          postgres    false    245                       0    0    payment1_sl_no_seq    SEQUENCE OWNED BY     H   ALTER SEQUENCE public.payment1_sl_no_seq OWNED BY public.payment.sl_no;
          public          postgres    false    246            �            1259    16548    payment_desc    TABLE     �   CREATE TABLE public.payment_desc (
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
       public          postgres    false    206                       0    0    payment_desc_2_sl_no_seq    SEQUENCE OWNED BY     d   ALTER SEQUENCE public.payment_desc_2_sl_no_seq OWNED BY public.dept_expenditure_payment_desc.sl_no;
          public          postgres    false    248            �            1259    16553    payment_invoice_sl_no_seq    SEQUENCE     �   CREATE SEQUENCE public.payment_invoice_sl_no_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 0   DROP SEQUENCE public.payment_invoice_sl_no_seq;
       public          postgres    false    201                       0    0    payment_invoice_sl_no_seq    SEQUENCE OWNED BY     P   ALTER SEQUENCE public.payment_invoice_sl_no_seq OWNED BY public.approval.sl_no;
          public          postgres    false    249            �            1259    16555    payment_purpose_desc    TABLE        CREATE TABLE public.payment_purpose_desc (
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
       public         heap    postgres    false                        1259    16573    users    TABLE     �   CREATE TABLE public.users (
    user_id character varying(225) NOT NULL,
    password character varying(300),
    role character varying(20)
);
    DROP TABLE public.users;
       public         heap    postgres    false                       1259    16576    vender_master    TABLE     '  CREATE TABLE public.vender_master (
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
       public         heap    postgres    false                       2604    24691    CustomerBankAccount id    DEFAULT     �   ALTER TABLE ONLY public."CustomerBankAccount" ALTER COLUMN id SET DEFAULT nextval('public."CustomerBankAccount_id_seq"'::regclass);
 G   ALTER TABLE public."CustomerBankAccount" ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    280    281    281            }           2604    24664    CustomerContactPerson id    DEFAULT     �   ALTER TABLE ONLY public."CustomerContactPerson" ALTER COLUMN id SET DEFAULT nextval('public."CustomerContactPerson_id_seq"'::regclass);
 I   ALTER TABLE public."CustomerContactPerson" ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    276    277    277            {           2604    24653    CustomerMaster id    DEFAULT     z   ALTER TABLE ONLY public."CustomerMaster" ALTER COLUMN id SET DEFAULT nextval('public."CustomerMaster_id_seq"'::regclass);
 B   ALTER TABLE public."CustomerMaster" ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    274    275    275            ~           2604    24675    CustomerPrincipalPlace id    DEFAULT     �   ALTER TABLE ONLY public."CustomerPrincipalPlace" ALTER COLUMN id SET DEFAULT nextval('public."CustomerPrincipalPlace_id_seq"'::regclass);
 J   ALTER TABLE public."CustomerPrincipalPlace" ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    279    278    279            �           2604    24753    ItemPackageSizeMaster id    DEFAULT     �   ALTER TABLE ONLY public."ItemPackageSizeMaster" ALTER COLUMN id SET DEFAULT nextval('public."ItemPackageSizeMaster_id_seq"'::regclass);
 I   ALTER TABLE public."ItemPackageSizeMaster" ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    285    286    286            v           2604    24619    NonSubsidyPODetails id    DEFAULT     �   ALTER TABLE ONLY public."NonSubsidyPODetails" ALTER COLUMN id SET DEFAULT nextval('public."NonSubsidyPODetails_id_seq"'::regclass);
 G   ALTER TABLE public."NonSubsidyPODetails" ALTER COLUMN id DROP DEFAULT;
       public          postgres    false    272    271    272            e           2604    16956    VendorBankAccount BankAccountID    DEFAULT     �   ALTER TABLE ONLY public."VendorBankAccount" ALTER COLUMN "BankAccountID" SET DEFAULT nextval('public."VendorBankAccount_BankAccountID_seq"'::regclass);
 R   ALTER TABLE public."VendorBankAccount" ALTER COLUMN "BankAccountID" DROP DEFAULT;
       public          postgres    false    265    264    265            c           2604    16919 #   VendorContactPerson ContactPersonID    DEFAULT     �   ALTER TABLE ONLY public."VendorContactPerson" ALTER COLUMN "ContactPersonID" SET DEFAULT nextval('public."VendorContactPerson_ContactPersonID_seq"'::regclass);
 V   ALTER TABLE public."VendorContactPerson" ALTER COLUMN "ContactPersonID" DROP DEFAULT;
       public          postgres    false    260    261    261            d           2604    16935 %   VendorPrincipalPlace PrincipalPlaceID    DEFAULT     �   ALTER TABLE ONLY public."VendorPrincipalPlace" ALTER COLUMN "PrincipalPlaceID" SET DEFAULT nextval('public."VendorPrincipalPlace_PrincipalPlaceID_seq"'::regclass);
 X   ALTER TABLE public."VendorPrincipalPlace" ALTER COLUMN "PrincipalPlaceID" DROP DEFAULT;
       public          postgres    false    263    262    263            Q           2604    16582    approval sl_no    DEFAULT     w   ALTER TABLE ONLY public.approval ALTER COLUMN sl_no SET DEFAULT nextval('public.payment_invoice_sl_no_seq'::regclass);
 =   ALTER TABLE public.approval ALTER COLUMN sl_no DROP DEFAULT;
       public          postgres    false    249    201            R           2604    16583    approval_desc serial    DEFAULT     |   ALTER TABLE ONLY public.approval_desc ALTER COLUMN serial SET DEFAULT nextval('public.approval_desc_serial_seq'::regclass);
 C   ALTER TABLE public.approval_desc ALTER COLUMN serial DROP DEFAULT;
       public          postgres    false    203    202            S           2604    16584 #   dept_expenditure_payment_desc sl_no    DEFAULT     �   ALTER TABLE ONLY public.dept_expenditure_payment_desc ALTER COLUMN sl_no SET DEFAULT nextval('public.payment_desc_2_sl_no_seq'::regclass);
 R   ALTER TABLE public.dept_expenditure_payment_desc ALTER COLUMN sl_no DROP DEFAULT;
       public          postgres    false    248    206            U           2604    16585    farmer_receipt sl_no    DEFAULT     }   ALTER TABLE ONLY public.farmer_receipt ALTER COLUMN sl_no SET DEFAULT nextval('public.farmer_receipts_sl_no_seq'::regclass);
 C   ALTER TABLE public.farmer_receipt ALTER COLUMN sl_no DROP DEFAULT;
       public          postgres    false    216    215            T           2604    16586    govt_share_config sl    DEFAULT     |   ALTER TABLE ONLY public.govt_share_config ALTER COLUMN sl SET DEFAULT nextval('public.dept_money_config_sl_seq'::regclass);
 C   ALTER TABLE public.govt_share_config ALTER COLUMN sl DROP DEFAULT;
       public          postgres    false    208    207            V           2604    16587    indent_old sl_no    DEFAULT     q   ALTER TABLE ONLY public.indent_old ALTER COLUMN sl_no SET DEFAULT nextval('public.indents_sl_no_seq'::regclass);
 ?   ALTER TABLE public.indent_old ALTER COLUMN sl_no DROP DEFAULT;
       public          postgres    false    220    218            W           2604    16588    invoice sl_no    DEFAULT     n   ALTER TABLE ONLY public.invoice ALTER COLUMN sl_no SET DEFAULT nextval('public.invoice_sl_no_seq'::regclass);
 <   ALTER TABLE public.invoice ALTER COLUMN sl_no DROP DEFAULT;
       public          postgres    false    223    221            Z           2604    16589 (   jalanidhi_dept_expnd_payment_desc serial    DEFAULT     �   ALTER TABLE ONLY public.jalanidhi_dept_expnd_payment_desc ALTER COLUMN serial SET DEFAULT nextval('public.jalanidhi_dept_expnd_payment_desc_serial_seq'::regclass);
 W   ALTER TABLE public.jalanidhi_dept_expnd_payment_desc ALTER COLUMN serial DROP DEFAULT;
       public          postgres    false    227    226            [           2604    16590    jalanidhi_payment_desc serial    DEFAULT     �   ALTER TABLE ONLY public.jalanidhi_payment_desc ALTER COLUMN serial SET DEFAULT nextval('public.jalanidhi_payment_desc_serial_seq'::regclass);
 L   ALTER TABLE public.jalanidhi_payment_desc ALTER COLUMN serial DROP DEFAULT;
       public          postgres    false    229    228            \           2604    16591    jn_expenditure_desc serial    DEFAULT     �   ALTER TABLE ONLY public.jn_expenditure_desc ALTER COLUMN serial SET DEFAULT nextval('public.jn_expenditure_desc_serial_seq'::regclass);
 I   ALTER TABLE public.jn_expenditure_desc ALTER COLUMN serial DROP DEFAULT;
       public          postgres    false    231    230            ]           2604    16592 	   log sl_no    DEFAULT     f   ALTER TABLE ONLY public.log ALTER COLUMN sl_no SET DEFAULT nextval('public.log_sl_no_seq'::regclass);
 8   ALTER TABLE public.log ALTER COLUMN sl_no DROP DEFAULT;
       public          postgres    false    238    237            ^           2604    16593 	   mrr sl_no    DEFAULT     f   ALTER TABLE ONLY public.mrr ALTER COLUMN sl_no SET DEFAULT nextval('public.mrr_sl_no_seq'::regclass);
 8   ALTER TABLE public.mrr ALTER COLUMN sl_no DROP DEFAULT;
       public          postgres    false    241    239            _           2604    16594    payment sl_no    DEFAULT     o   ALTER TABLE ONLY public.payment ALTER COLUMN sl_no SET DEFAULT nextval('public.payment1_sl_no_seq'::regclass);
 <   ALTER TABLE public.payment ALTER COLUMN sl_no DROP DEFAULT;
       public          postgres    false    246    245            �          0    24688    CustomerBankAccount 
   TABLE DATA           �   COPY public."CustomerBankAccount" (id, "CustomerID", "BankAccountID", "bankAccountNo", "accountType", "bankName", "branchName", "ifscCode", "InsertedDate", "InsertedBy", "UpdatedDate", "UpdatedBy") FROM stdin;
    public          postgres    false    281   N      �          0    24661    CustomerContactPerson 
   TABLE DATA           �   COPY public."CustomerContactPerson" (id, "CustomerID", "ContactPersonID", "AuthorisedName", "AuthorisedMobileNo", "AuthorisedEmailID", "Designation", "InsertedDate", "InsertedBy", "UpdatedDate", "UpdatedBy") FROM stdin;
    public          postgres    false    277   �                 0    24757    CustomerDistrictMapping 
   TABLE DATA           _   COPY public."CustomerDistrictMapping" ("CustomerID", "DistrictID", "InsertedDate") FROM stdin;
    public          postgres    false    287   		      �          0    24650    CustomerMaster 
   TABLE DATA           �   COPY public."CustomerMaster" (id, "CustomerID", "LegalCustomerName", "TradeName", "PAN", "BussinessConstitution", "GSTN", "ContactNumber", "EmailID", "InsertedDate", "InsertedBy") FROM stdin;
    public          postgres    false    275   _	      �          0    24672    CustomerPrincipalPlace 
   TABLE DATA           �   COPY public."CustomerPrincipalPlace" (id, "CustomerID", "PrincipalPlaceID", "Country", "StateCode", "DistrictOrCity", "Pincode", "Address", "InsertedDate", "InsertedBy", "UpdatedDate", "UpdatedBy") FROM stdin;
    public          postgres    false    279   X      �          0    24581    DivisionMaster 
   TABLE DATA           H   COPY public."DivisionMaster" ("DivisionID", "DivisionName") FROM stdin;
    public          postgres    false    269   1      �          0    24724    InvoiceMaster 
   TABLE DATA           �  COPY public."InvoiceMaster" ("InvoiceNo", "PONo", "OrderReferenceNo", "InvoiceDate", "WayBillNo", "WayBillDate", "TruckNo", "FinYear", "DistrictID", "VendorID", "Status", "PaymentStatus", "InvoiceAmount", "InvoicePath", "POType", "NoOfOrderInPO", "NoOfOrderDeliver", "InsertedDate", "InsertedBy", "UpdatedDate", "UpdatedBy", "IsReceived", "ReceivedDate", "EngineNumber", "ChassicNumber") FROM stdin;
    public          postgres    false    283   �      �          0    24737    ItemPackageMaster 
   TABLE DATA           W  COPY public."ItemPackageMaster" ("DivisionID", "Implement", "Make", "Model", "PackageSize", "UnitOfMeasurement", "PurchaseInvoiceValue", "PurchaseTaxableValue", "PurchaseCGST", "PurchaseSGST", "PurchaseIGST", "SellSGST", "SellIGST", "SellInvoiceValue", "SellTaxableValue", "InsertedDate", "InsertedBy", "UpdatedDate", "UpdatedBy") FROM stdin;
    public          postgres    false    284   �$      �          0    24750    ItemPackageSizeMaster 
   TABLE DATA           D   COPY public."ItemPackageSizeMaster" (id, "PackageSize") FROM stdin;
    public          postgres    false    286   >@      �          0    24628 	   MRRMaster 
   TABLE DATA             COPY public."MRRMaster" ("MRRNo", "InvoiceNo", "PONo", "OrderReferenceNo", "FinYear", "ItemQuantity", "MRRAmount", "VendorID", "DistrictID", "DMID", "AccID", "PaymentStatus", "POType", "InsertedDate", "InsertedBy", "UpdatedDate", "UpdatedBy", "NoOfItemReceived") FROM stdin;
    public          postgres    false    273   �@      �          0    24616    NonSubsidyPODetails 
   TABLE DATA             COPY public."NonSubsidyPODetails" (id, "OrderReferenceNo", "PONo", "CustomerID", "DivisionID", "Implement", "Make", "Model", "UnitOfMeasurement", "HSN", "TaxRate", "PurchaseInvoiceValue", "PurchaseTaxableValue", "PurchaseCGST", "PurchaseSGST", "PurchaseIGST", "SellCGST", "SellSGST", "SellIGST", "SellInvoiceValue", "SellTaxableValue", "ItemQuantity", "ItemQuantitySold", "EngineNumber", "ChassicNumber", "IsDelivered", "IsReceived", "IsDeliveredToCustomer", "InsertedDate", "InsertedBy", "UpdatedDate", "UpdatedBy") FROM stdin;
    public          postgres    false    272   �@      �          0    24597    POMaster 
   TABLE DATA             COPY public."POMaster" ("FinYear", "PONo", "OrderReferenceNo", "CustomerID", "CustomerOrderRefence", "VendorID", "DistrictID", "DMID", "AccID", "DivisionID", "Implement", "Make", "Model", "UnitOfMeasurement", "HSN", "TaxRate", "PurchaseInvoiceValue", "PurchaseTaxableValue", "PurchaseCGST", "PurchaseSGST", "PurchaseIGST", "TotalPurchaseInvoiceValue", "TotalPurchaseTaxableValue", "TotalPurchaseCGST", "TotalPurchaseSGST", "SellCGST", "SellSGST", "SellIGST", "SellInvoiceValue", "SellTaxableValue", "TotalSellCGST", "TotalSellSGST", "TotalSellIGST", "TotalSellInvoiceValue", "TotalSellTaxableValue", "POAmount", "NoOfItemsInPO", "ItemQuantity", "ItemQuantitySold", "EngineNumber", "ChassicNumber", "IsDelivered", "IsReceived", "IsDeliveredToCustomer", "Status", "InsertedDate", "InsertedBy", "UpdatedDate", "UpdatedBy", "IsApproved", "ApprovalStatus", "ApprovedDate", "ApprovedBy", "IsDeleted", "DeletedDate", "DeletedBy", "IsCancelled", "CancellationStatus", "CancelledDate", "CancelledBy", "POType", "VendorInvoiceNo", "MRRID") FROM stdin;
    public          postgres    false    270   �@      �          0    16793    StateMaster 
   TABLE DATA           A   COPY public."StateMaster" ("StateCode", "StateName") FROM stdin;
    public          postgres    false    258   �F      �          0    16953    VendorBankAccount 
   TABLE DATA           �   COPY public."VendorBankAccount" ("VendorID", "BankAccountID", "AccountNumber", "AccountType", "BankName", "BranchName", "IFSCCode", "BankDocument", "InsertedDate", "InsertedBy", "UpdatedDate", "UpdatedBy") FROM stdin;
    public          postgres    false    265   �G      �          0    16916    VendorContactPerson 
   TABLE DATA           �   COPY public."VendorContactPerson" ("VendorID", "ContactPersonID", "Name", "FathersName", "MobileNumber", "EmailID", "Designation", "InsertedDate", "InsertedBy") FROM stdin;
    public          postgres    false    261   �S      �          0    16980    VendorDistrictMapping 
   TABLE DATA           [   COPY public."VendorDistrictMapping" ("VendorID", "DistrictID", "InsertedDate") FROM stdin;
    public          postgres    false    267   -a      �          0    16903    VendorMaster 
   TABLE DATA           �  COPY public."VendorMaster" ("VendorID", "LegalBussinessName", "TradeName", "PAN", "PANDocument", "BussinessConstitution", "GSTN", "GSTNDocument", "IncorporationDate", "ContactNumber", "EmailID", "ApprovalStatus", "ApplyStatus", "InsertedDate", "InsertedBy", "IsDeleted", "ApproveOrRejectDate", "ApproveOrRejectBy", "WhetherSSIUnit", "WhetherMSME", "SSIUnitRegistrationCertificate", "MSMECertificate", "CoreBussinessActivity", "Turnover1", "Turnover2", "Turnover3", "Password") FROM stdin;
    public          postgres    false    259   Id      �          0    16932    VendorPrincipalPlace 
   TABLE DATA           �   COPY public."VendorPrincipalPlace" ("VendorID", "PrincipalPlaceID", "Country", "StateCode", "DistrictOrCity", "Pincode", "Address", "InsertedDate", "InsertedBy") FROM stdin;
    public          postgres    false    263   �      �          0    16967    VendorServices 
   TABLE DATA           _   COPY public."VendorServices" ("VendorID", "Service", "InsertedDate", "InsertedBy") FROM stdin;
    public          postgres    false    266   ��      �          0    16385 
   acc_master 
   TABLE DATA           ~   COPY public.acc_master (acc_name, acc_id, dist_id, dist_name, acc_address, acc_mobile_no, "UpdateOn", "UpdateBy") FROM stdin;
    public          postgres    false    200   b�      �          0    16388    approval 
   TABLE DATA           $  COPY public.approval (sl_no, invoice_no, fin_year, dist_id, dl_id, status, approval_id, indent_no, approval_date, ammount, transaction_id, deduction_amount, pay_now_amount, payment_status, remark, dl_remark, paid_amount, pp_id, pp_status, dm_approved_on, bank_approved_on, items) FROM stdin;
    public          postgres    false    201   W�      �          0    16394    approval_desc 
   TABLE DATA           O   COPY public.approval_desc (approval_id, permit_no, serial, mrr_id) FROM stdin;
    public          postgres    false    202   �      �          0    16402    approval_status_desc 
   TABLE DATA           A   COPY public.approval_status_desc (status_id, "desc") FROM stdin;
    public          postgres    false    204   ��      �          0    16405 
   components 
   TABLE DATA           C   COPY public.components (comp_id, schema_id, comp_name) FROM stdin;
    public          postgres    false    205   "�      �          0    16408    dept_expenditure_payment_desc 
   TABLE DATA           �   COPY public.dept_expenditure_payment_desc (sl_no, reference_no, transaction_id, source_id, schem_id, comp_id, head_id, subhead_id, head_name, subhead_name, sd_path) FROM stdin;
    public          postgres    false    206   ��      �          0    16416    dist_dealer_mapping 
   TABLE DATA           G   COPY public.dist_dealer_mapping (fin_year, dl_id, dist_id) FROM stdin;
    public          postgres    false    209   ԩ      �          0    16419    dist_master 
   TABLE DATA           E   COPY public.dist_master (dist_id, dist_name, "DistCode") FROM stdin;
    public          postgres    false    210   B�      �          0    16422    dl_item_map 
   TABLE DATA           N   COPY public.dl_item_map (fin_year, dl_id, implement, make, model) FROM stdin;
    public          postgres    false    211   m�      �          0    16425    dl_item_map_1_old 
   TABLE DATA           ^   COPY public.dl_item_map_1_old (fin_year, dl_id, implement, make, model, model_id) FROM stdin;
    public          postgres    false    212   ��      �          0    16428 	   dl_master 
   TABLE DATA             COPY public.dl_master (dl_id, dl_name, bank_name, dl_ac_no, dl_ifsc_code, dl_mobile_no, dl_email, dl_address, add_date, modify_date, "LegalBussinessName", "TradeName", "PAN", "PANDocument", "BussinessConstitution", "GSTN", "GSTNDocument", "IncorporationDate", "ContactNumber", "EmailID", "Password", "ApprovalStatus", "InsertedDate", "InsertedBy", "IsDeleted", "ApproveOrRejectDate", "ApproveOrRejectBy", "WhetherSSIUnit", "WhetherMSME", "SSIUnitRegistrationCertificate", "MSMECertificate", "CoreBussinessActivity") FROM stdin;
    public          postgres    false    213   ��      �          0    16434 	   dm_master 
   TABLE DATA           �   COPY public.dm_master (dist_id, dist_name, dm_id, dm_name, dm_address, dm_mobile_no, "UpdateOn", "UpdateBy", "EmailID", "BankName", "BranchName", "AccountNumber", "IFSCCode") FROM stdin;
    public          postgres    false    214   �      �          0    16437    farmer_receipt 
   TABLE DATA           �   COPY public.farmer_receipt (sl_no, receipt_no, fin_year, farmer_name, farmer_id, full_ammount, permit_no, implement, payment_mode, payment_no, source_bank, date, dist_id, office, payment_date) FROM stdin;
    public          postgres    false    215   �      �          0    16411    govt_share_config 
   TABLE DATA           S   COPY public.govt_share_config (sl, fin_year, head, govt_share_ammount) FROM stdin;
    public          postgres    false    207   �;      �          0    16442    head_master 
   TABLE DATA           9   COPY public.head_master (head_id, head_name) FROM stdin;
    public          postgres    false    217   �;      �          0    16998    indent 
   TABLE DATA           
  COPY public.indent (indent_no, "PONo", fin_year, "FinYear", dist_id, "DistrictID", "DMID", "AccID", dl_id, "VendorID", "PermitNumber", "FarmerID", items, "POAmount", indent_ammount, status, "Status", indent_date, "InsertedDate", "InsertedBy", "UpdatedDate", "UpdatedBy", "IsApproved", "ApprovalStatus", "ApprovedDate", "ApprovedBy", "IsDeleted", "DeletedDate", "DeletedBy", "IsCancelled", "CancellationStatus", "CancelledDate", "CancelledBy", "CustomerID", "POType", " CustomerID", "VendorInvoiceNo", "MRRID") FROM stdin;
    public          postgres    false    268   "<      �          0    16448    indent_desc 
   TABLE DATA           ;   COPY public.indent_desc (indent_no, permit_no) FROM stdin;
    public          postgres    false    219   KA      �          0    16445 
   indent_old 
   TABLE DATA           �   COPY public.indent_old (sl_no, indent_no, dist_id, indent_date, dl_id, fin_year, status, items, indent_ammount, "accountantID") FROM stdin;
    public          postgres    false    218   hA      �          0    16453    invoice 
   TABLE DATA           #  COPY public.invoice (sl_no, invoice_no, invoice_date, rr_way_bill_no, wagon_truck_no, challan_no, challan_date, fin_year, dist_id, dl_id, bill_no, bill_date, status, rr_way_bill_date, discount, indent_no, payment_status, items, invoice_ammount, invoice_path, gst_rate, "POType") FROM stdin;
    public          postgres    false    221   ?E      �          0    16459    invoice_desc 
   TABLE DATA           =   COPY public.invoice_desc (invoice_no, permit_no) FROM stdin;
    public          postgres    false    222   �M      �          0    16464    item_price_map 
   TABLE DATA           �   COPY public.item_price_map (implement, make, model, model_id, purchase_price, selling_price, tax_1, tax_2, tax_3, fin_year, sgst_1, cgst_1, igst_1) FROM stdin;
    public          postgres    false    224   YP      �          0    16467    item_price_map_1 
   TABLE DATA           r  COPY public.item_price_map_1 ("Implement", "Make", "Model", p_taxable_value, p_cgst_6, p_sgst_6, p_cgst_1, p_sgst_1, p_invoice_value, s_taxable_value, s_cgst_6, s_sgst_6, s_invoice_value, p_igst_12, s_igst_12, add_date, update_date, "Division", "HSN", "UnitOfMeasurement", "GSTApplicability", "Taxability", "TaxRate", "PurchaseInvoiceValue", "PurchaseTaxableValue", "PurchaseCGST", "PurchaseSGST", "PurchaseIGST", "PurchaseSGSTOnePercent", "PurchaseCGSTOnePercent", "SellCGST", "SellSGST", "SellIGST", "SellInvoiceValue", "SellTaxableValue", "InsertedDate", "InsertedBy", "UpdatedDate", "UpdatedBy", "DivisionID") FROM stdin;
    public          postgres    false    225   �]      �          0    16473 !   jalanidhi_dept_expnd_payment_desc 
   TABLE DATA           t   COPY public.jalanidhi_dept_expnd_payment_desc (serial, transaction_id, scheme_id, scheme_name, comp_id) FROM stdin;
    public          postgres    false    226   ݏ      �          0    16478    jalanidhi_payment_desc 
   TABLE DATA           �   COPY public.jalanidhi_payment_desc (transaction_id, farmer_id, farmer_name, implement, make, model, serial, project_id) FROM stdin;
    public          postgres    false    228   V�      �          0    16483    jn_expenditure_desc 
   TABLE DATA           f   COPY public.jn_expenditure_desc (transaction_id, item_name, item_price, quantity, serial) FROM stdin;
    public          postgres    false    230   6�      �          0    16488 	   jn_orders 
   TABLE DATA           {   COPY public.jn_orders (fin_year, dist_id, cluster_id, farmer_id, dist_name, farmer_name, status, date, system) FROM stdin;
    public          postgres    false    232   .�      �          0    16491    jn_stock 
   TABLE DATA           �   COPY public.jn_stock (fin_year, dist_id, dl_id, system, po_no, cluster_id, farmer_id, farmer_name, implement, make, model, engine_no, chassic_no, status, receive_date, deliver_date, dl_name) FROM stdin;
    public          postgres    false    233   �      �          0    16497    lgd_block_master 
   TABLE DATA           M   COPY public.lgd_block_master (dist_code, block_code, block_name) FROM stdin;
    public          postgres    false    234   ��      �          0    16503    lgd_dist_master 
   TABLE DATA           ?   COPY public.lgd_dist_master (dist_code, dist_name) FROM stdin;
    public          postgres    false    235   �      �          0    16506    lgd_gp_master 
   TABLE DATA           P   COPY public.lgd_gp_master (dist_code, block_code, gp_code, gp_name) FROM stdin;
    public          postgres    false    236   ��      �          0    16509    log 
   TABLE DATA           �   COPY public.log (sl_no, date_time, user_id, action, status, ref_url, route, ip, browser_name, browser_version, fin_year, remark) FROM stdin;
    public          postgres    false    237   G_      �          0    16517    mrr 
   TABLE DATA           v   COPY public.mrr (sl_no, mrr_id, dist_id, invoice_no, fin_year, dl_id, date, items, indent_no, mrr_amount) FROM stdin;
    public          postgres    false    239   /      �          0    16520    mrr_desc 
   TABLE DATA           5   COPY public.mrr_desc (mrr_id, permit_no) FROM stdin;
    public          postgres    false    240   !#      �          0    16525    new_item_price 
   TABLE DATA           �   COPY public.new_item_price (implement, make, model, purchase_price, taxable_value, cgst_6, sags_6, invoice_alue, selling_price, sl_taxable_value, sl_cgst_6, sl_sgst_6, sl_invoice_value) FROM stdin;
    public          postgres    false    242   %      �          0    16531    opening_balance 
   TABLE DATA           �   COPY public.opening_balance (fin_year, date, system, dist_id, transaction_id, ammount, remark, purpose, reference_no, "from", "to", head, subhead, payment_type, payment_date, payment_no, test) FROM stdin;
    public          postgres    false    243   �<      �          0    16537    orders 
   TABLE DATA           �  COPY public.orders (permit_no, permit_issue_date, permit_validity, farmer_id, farmer_name, farmer_father_name, dist_name, block_name, gp_name, village_name, implement, make, model, status, permit_validity_1, permit_issue_date_1, fin_year, dist_id, engine_no, chassic_no, ammount, remark, expected_delivery_date, delivery_date, c_fin_year, date, system, paid_amount, order_type) FROM stdin;
    public          postgres    false    244   �@      �          0    16543    payment 
   TABLE DATA           �   COPY public.payment (sl_no, date, reference_no, transaction_id, "from", "to", remark, payment_type, payment_no, fin_year, purpose, payment_date, ammount, status, system) FROM stdin;
    public          postgres    false    245   �i      �          0    16548    payment_desc 
   TABLE DATA           D   COPY public.payment_desc (transaction_id, reference_no) FROM stdin;
    public          postgres    false    247   ��      �          0    16555    payment_purpose_desc 
   TABLE DATA           B   COPY public.payment_purpose_desc (purpose_id, "desc") FROM stdin;
    public          postgres    false    250   �      �          0    16558    schem_master 
   TABLE DATA           <   COPY public.schem_master (schem_id, schem_name) FROM stdin;
    public          postgres    false    251   �      �          0    16561    source_master 
   TABLE DATA           ?   COPY public.source_master (source_id, source_name) FROM stdin;
    public          postgres    false    252   �      �          0    16564    subheads 
   TABLE DATA           E   COPY public.subheads (subhead_id, head_id, subhead_name) FROM stdin;
    public          postgres    false    253   d�      �          0    16567    system_desc 
   TABLE DATA           8   COPY public.system_desc (system_id, "desc") FROM stdin;
    public          postgres    false    254   ��      �          0    16570 
   tax_config 
   TABLE DATA           6   COPY public.tax_config (tax_mode, "desc") FROM stdin;
    public          postgres    false    255   <�      �          0    16573    users 
   TABLE DATA           8   COPY public.users (user_id, password, role) FROM stdin;
    public          postgres    false    256   �      �          0    16576    vender_master 
   TABLE DATA              COPY public.vender_master ("VendorId", "VendorRegNo", "DateOfReg", "Name", "FarmName", "IsVerified", "IsReject", "RejectRemarkStausId", "UserName", "Password", "Type", "IPAddress", "FinancialYear", "UpdatedOn", "UpdatedBy", "DeletedOn", "DeletedBy", "IsUpdated", "IsDeleted") FROM stdin;
    public          postgres    false    257   =�                 0    0    CustomerBankAccount_id_seq    SEQUENCE SET     J   SELECT pg_catalog.setval('public."CustomerBankAccount_id_seq"', 5, true);
          public          postgres    false    280                       0    0    CustomerContactPerson_id_seq    SEQUENCE SET     M   SELECT pg_catalog.setval('public."CustomerContactPerson_id_seq"', 39, true);
          public          postgres    false    276                       0    0    CustomerMaster_id_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public."CustomerMaster_id_seq"', 43, true);
          public          postgres    false    274                        0    0    CustomerPrincipalPlace_id_seq    SEQUENCE SET     N   SELECT pg_catalog.setval('public."CustomerPrincipalPlace_id_seq"', 41, true);
          public          postgres    false    278            !           0    0    ItemPackageSizeMaster_id_seq    SEQUENCE SET     M   SELECT pg_catalog.setval('public."ItemPackageSizeMaster_id_seq"', 19, true);
          public          postgres    false    285            "           0    0    NonSubsidyPODetails_id_seq    SEQUENCE SET     K   SELECT pg_catalog.setval('public."NonSubsidyPODetails_id_seq"', 1, false);
          public          postgres    false    271            #           0    0 #   VendorBankAccount_BankAccountID_seq    SEQUENCE SET     T   SELECT pg_catalog.setval('public."VendorBankAccount_BankAccountID_seq"', 57, true);
          public          postgres    false    264            $           0    0 '   VendorContactPerson_ContactPersonID_seq    SEQUENCE SET     X   SELECT pg_catalog.setval('public."VendorContactPerson_ContactPersonID_seq"', 68, true);
          public          postgres    false    260            %           0    0 )   VendorPrincipalPlace_PrincipalPlaceID_seq    SEQUENCE SET     Z   SELECT pg_catalog.setval('public."VendorPrincipalPlace_PrincipalPlaceID_seq"', 66, true);
          public          postgres    false    262            &           0    0    approval_desc_serial_seq    SEQUENCE SET     H   SELECT pg_catalog.setval('public.approval_desc_serial_seq', 107, true);
          public          postgres    false    203            '           0    0    customer_id_increment    SEQUENCE SET     D   SELECT pg_catalog.setval('public.customer_id_increment', 43, true);
          public          postgres    false    282            (           0    0    dept_money_config_sl_seq    SEQUENCE SET     F   SELECT pg_catalog.setval('public.dept_money_config_sl_seq', 1, true);
          public          postgres    false    208            )           0    0    farmer_receipts_sl_no_seq    SEQUENCE SET     I   SELECT pg_catalog.setval('public.farmer_receipts_sl_no_seq', 524, true);
          public          postgres    false    216            *           0    0    indents_sl_no_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.indents_sl_no_seq', 245, true);
          public          postgres    false    220            +           0    0    invoice_sl_no_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('public.invoice_sl_no_seq', 353, true);
          public          postgres    false    223            ,           0    0 ,   jalanidhi_dept_expnd_payment_desc_serial_seq    SEQUENCE SET     [   SELECT pg_catalog.setval('public.jalanidhi_dept_expnd_payment_desc_serial_seq', 12, true);
          public          postgres    false    227            -           0    0 !   jalanidhi_payment_desc_serial_seq    SEQUENCE SET     P   SELECT pg_catalog.setval('public.jalanidhi_payment_desc_serial_seq', 24, true);
          public          postgres    false    229            .           0    0    jn_expenditure_desc_serial_seq    SEQUENCE SET     M   SELECT pg_catalog.setval('public.jn_expenditure_desc_serial_seq', 36, true);
          public          postgres    false    231            /           0    0    log_sl_no_seq    SEQUENCE SET     >   SELECT pg_catalog.setval('public.log_sl_no_seq', 3343, true);
          public          postgres    false    238            0           0    0    mrr_sl_no_seq    SEQUENCE SET     =   SELECT pg_catalog.setval('public.mrr_sl_no_seq', 229, true);
          public          postgres    false    241            1           0    0    payment1_sl_no_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('public.payment1_sl_no_seq', 1146, true);
          public          postgres    false    246            2           0    0    payment_desc_2_sl_no_seq    SEQUENCE SET     G   SELECT pg_catalog.setval('public.payment_desc_2_sl_no_seq', 92, true);
          public          postgres    false    248            3           0    0    payment_invoice_sl_no_seq    SEQUENCE SET     I   SELECT pg_catalog.setval('public.payment_invoice_sl_no_seq', 114, true);
          public          postgres    false    249            �           2606    24696 ,   CustomerBankAccount CustomerBankAccount_pkey 
   CONSTRAINT     n   ALTER TABLE ONLY public."CustomerBankAccount"
    ADD CONSTRAINT "CustomerBankAccount_pkey" PRIMARY KEY (id);
 Z   ALTER TABLE ONLY public."CustomerBankAccount" DROP CONSTRAINT "CustomerBankAccount_pkey";
       public            postgres    false    281            �           2606    24669 0   CustomerContactPerson CustomerContactPerson_pkey 
   CONSTRAINT     r   ALTER TABLE ONLY public."CustomerContactPerson"
    ADD CONSTRAINT "CustomerContactPerson_pkey" PRIMARY KEY (id);
 ^   ALTER TABLE ONLY public."CustomerContactPerson" DROP CONSTRAINT "CustomerContactPerson_pkey";
       public            postgres    false    277                       2606    24764 4   CustomerDistrictMapping CustomerDistrictMapping_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."CustomerDistrictMapping"
    ADD CONSTRAINT "CustomerDistrictMapping_pkey" PRIMARY KEY ("CustomerID", "DistrictID");
 b   ALTER TABLE ONLY public."CustomerDistrictMapping" DROP CONSTRAINT "CustomerDistrictMapping_pkey";
       public            postgres    false    287    287            �           2606    24658 "   CustomerMaster CustomerMaster_pkey 
   CONSTRAINT     d   ALTER TABLE ONLY public."CustomerMaster"
    ADD CONSTRAINT "CustomerMaster_pkey" PRIMARY KEY (id);
 P   ALTER TABLE ONLY public."CustomerMaster" DROP CONSTRAINT "CustomerMaster_pkey";
       public            postgres    false    275            �           2606    24680 2   CustomerPrincipalPlace CustomerPrincipalPlace_pkey 
   CONSTRAINT     t   ALTER TABLE ONLY public."CustomerPrincipalPlace"
    ADD CONSTRAINT "CustomerPrincipalPlace_pkey" PRIMARY KEY (id);
 `   ALTER TABLE ONLY public."CustomerPrincipalPlace" DROP CONSTRAINT "CustomerPrincipalPlace_pkey";
       public            postgres    false    279            �           2606    24588 "   DivisionMaster DivisionMaster_pkey 
   CONSTRAINT     n   ALTER TABLE ONLY public."DivisionMaster"
    ADD CONSTRAINT "DivisionMaster_pkey" PRIMARY KEY ("DivisionID");
 P   ALTER TABLE ONLY public."DivisionMaster" DROP CONSTRAINT "DivisionMaster_pkey";
       public            postgres    false    269            �           2606    24734     InvoiceMaster InvoiceMaster_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."InvoiceMaster"
    ADD CONSTRAINT "InvoiceMaster_pkey" PRIMARY KEY ("InvoiceNo", "PONo", "OrderReferenceNo");
 N   ALTER TABLE ONLY public."InvoiceMaster" DROP CONSTRAINT "InvoiceMaster_pkey";
       public            postgres    false    283    283    283                       2606    24772 (   ItemPackageMaster ItemPackageMaster_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."ItemPackageMaster"
    ADD CONSTRAINT "ItemPackageMaster_pkey" PRIMARY KEY ("DivisionID", "Implement", "Make", "Model", "PackageSize", "UnitOfMeasurement");
 V   ALTER TABLE ONLY public."ItemPackageMaster" DROP CONSTRAINT "ItemPackageMaster_pkey";
       public            postgres    false    284    284    284    284    284    284                       2606    24755 0   ItemPackageSizeMaster ItemPackageSizeMaster_pkey 
   CONSTRAINT     r   ALTER TABLE ONLY public."ItemPackageSizeMaster"
    ADD CONSTRAINT "ItemPackageSizeMaster_pkey" PRIMARY KEY (id);
 ^   ALTER TABLE ONLY public."ItemPackageSizeMaster" DROP CONSTRAINT "ItemPackageSizeMaster_pkey";
       public            postgres    false    286            �           2606    24636    MRRMaster MRRMaster_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."MRRMaster"
    ADD CONSTRAINT "MRRMaster_pkey" PRIMARY KEY ("MRRNo", "InvoiceNo", "PONo", "OrderReferenceNo");
 F   ALTER TABLE ONLY public."MRRMaster" DROP CONSTRAINT "MRRMaster_pkey";
       public            postgres    false    273    273    273    273            �           2606    24627 ,   NonSubsidyPODetails NonSubsidyPODetails_pkey 
   CONSTRAINT     n   ALTER TABLE ONLY public."NonSubsidyPODetails"
    ADD CONSTRAINT "NonSubsidyPODetails_pkey" PRIMARY KEY (id);
 Z   ALTER TABLE ONLY public."NonSubsidyPODetails" DROP CONSTRAINT "NonSubsidyPODetails_pkey";
       public            postgres    false    272            �           2606    24613    POMaster POMaster_pkey 
   CONSTRAINT     p   ALTER TABLE ONLY public."POMaster"
    ADD CONSTRAINT "POMaster_pkey" PRIMARY KEY ("PONo", "OrderReferenceNo");
 D   ALTER TABLE ONLY public."POMaster" DROP CONSTRAINT "POMaster_pkey";
       public            postgres    false    270    270            �           2606    16797    StateMaster StateMaster_pkey 
   CONSTRAINT     g   ALTER TABLE ONLY public."StateMaster"
    ADD CONSTRAINT "StateMaster_pkey" PRIMARY KEY ("StateCode");
 J   ALTER TABLE ONLY public."StateMaster" DROP CONSTRAINT "StateMaster_pkey";
       public            postgres    false    258            �           2606    16961 (   VendorBankAccount VendorBankAccount_pkey 
   CONSTRAINT     w   ALTER TABLE ONLY public."VendorBankAccount"
    ADD CONSTRAINT "VendorBankAccount_pkey" PRIMARY KEY ("BankAccountID");
 V   ALTER TABLE ONLY public."VendorBankAccount" DROP CONSTRAINT "VendorBankAccount_pkey";
       public            postgres    false    265            �           2606    16924 ,   VendorContactPerson VendorContactPerson_pkey 
   CONSTRAINT     }   ALTER TABLE ONLY public."VendorContactPerson"
    ADD CONSTRAINT "VendorContactPerson_pkey" PRIMARY KEY ("ContactPersonID");
 Z   ALTER TABLE ONLY public."VendorContactPerson" DROP CONSTRAINT "VendorContactPerson_pkey";
       public            postgres    false    261            �           2606    16987 0   VendorDistrictMapping VendorDistrictMapping_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."VendorDistrictMapping"
    ADD CONSTRAINT "VendorDistrictMapping_pkey" PRIMARY KEY ("VendorID", "DistrictID");
 ^   ALTER TABLE ONLY public."VendorDistrictMapping" DROP CONSTRAINT "VendorDistrictMapping_pkey";
       public            postgres    false    267    267            �           2606    16913    VendorMaster VendorMaster_pkey 
   CONSTRAINT     h   ALTER TABLE ONLY public."VendorMaster"
    ADD CONSTRAINT "VendorMaster_pkey" PRIMARY KEY ("VendorID");
 L   ALTER TABLE ONLY public."VendorMaster" DROP CONSTRAINT "VendorMaster_pkey";
       public            postgres    false    259            �           2606    16940 .   VendorPrincipalPlace VendorPrincipalPlace_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public."VendorPrincipalPlace"
    ADD CONSTRAINT "VendorPrincipalPlace_pkey" PRIMARY KEY ("PrincipalPlaceID");
 \   ALTER TABLE ONLY public."VendorPrincipalPlace" DROP CONSTRAINT "VendorPrincipalPlace_pkey";
       public            postgres    false    263            �           2606    16974 "   VendorServices VendorServices_pkey 
   CONSTRAINT     w   ALTER TABLE ONLY public."VendorServices"
    ADD CONSTRAINT "VendorServices_pkey" PRIMARY KEY ("VendorID", "Service");
 P   ALTER TABLE ONLY public."VendorServices" DROP CONSTRAINT "VendorServices_pkey";
       public            postgres    false    266    266            �           2606    16596 "   acc_master accountants_master_pkey 
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
       public            postgres    false    210            �           2606    16610 $   dl_item_map_1_old dl_item_map_1_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.dl_item_map_1_old
    ADD CONSTRAINT dl_item_map_1_pkey PRIMARY KEY (fin_year, dl_id, implement, make, model, model_id);
 N   ALTER TABLE ONLY public.dl_item_map_1_old DROP CONSTRAINT dl_item_map_1_pkey;
       public            postgres    false    212    212    212    212    212    212            �           2606    16612    dl_item_map dl_item_map_2_pkey 
   CONSTRAINT     z   ALTER TABLE ONLY public.dl_item_map
    ADD CONSTRAINT dl_item_map_2_pkey PRIMARY KEY (fin_year, dl_id, implement, make);
 H   ALTER TABLE ONLY public.dl_item_map DROP CONSTRAINT dl_item_map_2_pkey;
       public            postgres    false    211    211    211    211            �           2606    16614    dl_master dl_master_1_pkey 
   CONSTRAINT     [   ALTER TABLE ONLY public.dl_master
    ADD CONSTRAINT dl_master_1_pkey PRIMARY KEY (dl_id);
 D   ALTER TABLE ONLY public.dl_master DROP CONSTRAINT dl_master_1_pkey;
       public            postgres    false    213            �           2606    16616    dm_master dm_master_pkey 
   CONSTRAINT     Y   ALTER TABLE ONLY public.dm_master
    ADD CONSTRAINT dm_master_pkey PRIMARY KEY (dm_id);
 B   ALTER TABLE ONLY public.dm_master DROP CONSTRAINT dm_master_pkey;
       public            postgres    false    214            �           2606    24577 #   farmer_receipt farmer_receipts_pkey 
   CONSTRAINT     i   ALTER TABLE ONLY public.farmer_receipt
    ADD CONSTRAINT farmer_receipts_pkey PRIMARY KEY (receipt_no);
 M   ALTER TABLE ONLY public.farmer_receipt DROP CONSTRAINT farmer_receipts_pkey;
       public            postgres    false    215            �           2606    16620    head_master head_master_pkey 
   CONSTRAINT     _   ALTER TABLE ONLY public.head_master
    ADD CONSTRAINT head_master_pkey PRIMARY KEY (head_id);
 F   ALTER TABLE ONLY public.head_master DROP CONSTRAINT head_master_pkey;
       public            postgres    false    217            �           2606    16622    indent_desc indent_desc_pkey 
   CONSTRAINT     l   ALTER TABLE ONLY public.indent_desc
    ADD CONSTRAINT indent_desc_pkey PRIMARY KEY (indent_no, permit_no);
 F   ALTER TABLE ONLY public.indent_desc DROP CONSTRAINT indent_desc_pkey;
       public            postgres    false    219    219            �           2606    17012    indent indent_pkey 
   CONSTRAINT     W   ALTER TABLE ONLY public.indent
    ADD CONSTRAINT indent_pkey PRIMARY KEY (indent_no);
 <   ALTER TABLE ONLY public.indent DROP CONSTRAINT indent_pkey;
       public            postgres    false    268            �           2606    16624    indent_old indents_pkey 
   CONSTRAINT     \   ALTER TABLE ONLY public.indent_old
    ADD CONSTRAINT indents_pkey PRIMARY KEY (indent_no);
 A   ALTER TABLE ONLY public.indent_old DROP CONSTRAINT indents_pkey;
       public            postgres    false    218            �           2606    16626    invoice_desc invoice_desc_pkey 
   CONSTRAINT     o   ALTER TABLE ONLY public.invoice_desc
    ADD CONSTRAINT invoice_desc_pkey PRIMARY KEY (invoice_no, permit_no);
 H   ALTER TABLE ONLY public.invoice_desc DROP CONSTRAINT invoice_desc_pkey;
       public            postgres    false    222    222            �           2606    16628    invoice invoice_pkey 
   CONSTRAINT     Z   ALTER TABLE ONLY public.invoice
    ADD CONSTRAINT invoice_pkey PRIMARY KEY (invoice_no);
 >   ALTER TABLE ONLY public.invoice DROP CONSTRAINT invoice_pkey;
       public            postgres    false    221            �           2606    16630 $   item_price_map item_price_map_1_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.item_price_map
    ADD CONSTRAINT item_price_map_1_pkey PRIMARY KEY (implement, make, model, model_id);
 N   ALTER TABLE ONLY public.item_price_map DROP CONSTRAINT item_price_map_1_pkey;
       public            postgres    false    224    224    224    224            �           2606    16632 '   item_price_map_1 item_price_map_1_pkey1 
   CONSTRAINT        ALTER TABLE ONLY public.item_price_map_1
    ADD CONSTRAINT item_price_map_1_pkey1 PRIMARY KEY ("Implement", "Make", "Model");
 Q   ALTER TABLE ONLY public.item_price_map_1 DROP CONSTRAINT item_price_map_1_pkey1;
       public            postgres    false    225    225    225            �           2606    16634 H   jalanidhi_dept_expnd_payment_desc jalanidhi_dept_expnd_payment_desc_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.jalanidhi_dept_expnd_payment_desc
    ADD CONSTRAINT jalanidhi_dept_expnd_payment_desc_pkey PRIMARY KEY (serial);
 r   ALTER TABLE ONLY public.jalanidhi_dept_expnd_payment_desc DROP CONSTRAINT jalanidhi_dept_expnd_payment_desc_pkey;
       public            postgres    false    226            �           2606    16636 2   jalanidhi_payment_desc jalanidhi_payment_desc_pkey 
   CONSTRAINT     t   ALTER TABLE ONLY public.jalanidhi_payment_desc
    ADD CONSTRAINT jalanidhi_payment_desc_pkey PRIMARY KEY (serial);
 \   ALTER TABLE ONLY public.jalanidhi_payment_desc DROP CONSTRAINT jalanidhi_payment_desc_pkey;
       public            postgres    false    228            �           2606    16638 ,   jn_expenditure_desc jn_expenditure_desc_pkey 
   CONSTRAINT     n   ALTER TABLE ONLY public.jn_expenditure_desc
    ADD CONSTRAINT jn_expenditure_desc_pkey PRIMARY KEY (serial);
 V   ALTER TABLE ONLY public.jn_expenditure_desc DROP CONSTRAINT jn_expenditure_desc_pkey;
       public            postgres    false    230            �           2606    16640    jn_orders jn_orders_pkey 
   CONSTRAINT     i   ALTER TABLE ONLY public.jn_orders
    ADD CONSTRAINT jn_orders_pkey PRIMARY KEY (cluster_id, farmer_id);
 B   ALTER TABLE ONLY public.jn_orders DROP CONSTRAINT jn_orders_pkey;
       public            postgres    false    232    232            �           2606    16642    jn_stock jn_stock_pkey 
   CONSTRAINT     �   ALTER TABLE ONLY public.jn_stock
    ADD CONSTRAINT jn_stock_pkey PRIMARY KEY (po_no, cluster_id, farmer_id, implement, make, model);
 @   ALTER TABLE ONLY public.jn_stock DROP CONSTRAINT jn_stock_pkey;
       public            postgres    false    233    233    233    233    233    233            �           2606    16644 &   lgd_block_master lgd_block_master_pkey 
   CONSTRAINT     l   ALTER TABLE ONLY public.lgd_block_master
    ADD CONSTRAINT lgd_block_master_pkey PRIMARY KEY (block_code);
 P   ALTER TABLE ONLY public.lgd_block_master DROP CONSTRAINT lgd_block_master_pkey;
       public            postgres    false    234            �           2606    16646 $   lgd_dist_master lgd_dist_master_pkey 
   CONSTRAINT     i   ALTER TABLE ONLY public.lgd_dist_master
    ADD CONSTRAINT lgd_dist_master_pkey PRIMARY KEY (dist_code);
 N   ALTER TABLE ONLY public.lgd_dist_master DROP CONSTRAINT lgd_dist_master_pkey;
       public            postgres    false    235            �           2606    16648     lgd_gp_master lgd_gp_master_pkey 
   CONSTRAINT     c   ALTER TABLE ONLY public.lgd_gp_master
    ADD CONSTRAINT lgd_gp_master_pkey PRIMARY KEY (gp_code);
 J   ALTER TABLE ONLY public.lgd_gp_master DROP CONSTRAINT lgd_gp_master_pkey;
       public            postgres    false    236            �           2606    16650    log log_pkey 
   CONSTRAINT     M   ALTER TABLE ONLY public.log
    ADD CONSTRAINT log_pkey PRIMARY KEY (sl_no);
 6   ALTER TABLE ONLY public.log DROP CONSTRAINT log_pkey;
       public            postgres    false    237            �           2606    16652    mrr_desc mrr_desc_pkey 
   CONSTRAINT     c   ALTER TABLE ONLY public.mrr_desc
    ADD CONSTRAINT mrr_desc_pkey PRIMARY KEY (mrr_id, permit_no);
 @   ALTER TABLE ONLY public.mrr_desc DROP CONSTRAINT mrr_desc_pkey;
       public            postgres    false    240    240            �           2606    16654    mrr mrr_pkey 
   CONSTRAINT     N   ALTER TABLE ONLY public.mrr
    ADD CONSTRAINT mrr_pkey PRIMARY KEY (mrr_id);
 6   ALTER TABLE ONLY public.mrr DROP CONSTRAINT mrr_pkey;
       public            postgres    false    239            �           2606    16656 "   new_item_price new_item_price_pkey 
   CONSTRAINT     t   ALTER TABLE ONLY public.new_item_price
    ADD CONSTRAINT new_item_price_pkey PRIMARY KEY (implement, make, model);
 L   ALTER TABLE ONLY public.new_item_price DROP CONSTRAINT new_item_price_pkey;
       public            postgres    false    242    242    242            �           2606    16658 $   opening_balance opening_balance_pkey 
   CONSTRAINT     n   ALTER TABLE ONLY public.opening_balance
    ADD CONSTRAINT opening_balance_pkey PRIMARY KEY (transaction_id);
 N   ALTER TABLE ONLY public.opening_balance DROP CONSTRAINT opening_balance_pkey;
       public            postgres    false    243            �           2606    16660    orders orders_pkey 
   CONSTRAINT     W   ALTER TABLE ONLY public.orders
    ADD CONSTRAINT orders_pkey PRIMARY KEY (permit_no);
 <   ALTER TABLE ONLY public.orders DROP CONSTRAINT orders_pkey;
       public            postgres    false    244            �           2606    16662    payment payment1_pkey 
   CONSTRAINT     _   ALTER TABLE ONLY public.payment
    ADD CONSTRAINT payment1_pkey PRIMARY KEY (transaction_id);
 ?   ALTER TABLE ONLY public.payment DROP CONSTRAINT payment1_pkey;
       public            postgres    false    245            �           2606    16664 1   dept_expenditure_payment_desc payment_desc_2_pkey 
   CONSTRAINT     r   ALTER TABLE ONLY public.dept_expenditure_payment_desc
    ADD CONSTRAINT payment_desc_2_pkey PRIMARY KEY (sl_no);
 [   ALTER TABLE ONLY public.dept_expenditure_payment_desc DROP CONSTRAINT payment_desc_2_pkey;
       public            postgres    false    206            �           2606    16666    payment_desc payment_desc_pkey 
   CONSTRAINT     v   ALTER TABLE ONLY public.payment_desc
    ADD CONSTRAINT payment_desc_pkey PRIMARY KEY (reference_no, transaction_id);
 H   ALTER TABLE ONLY public.payment_desc DROP CONSTRAINT payment_desc_pkey;
       public            postgres    false    247    247            �           2606    16668 !   approval payment_instruction_pkey 
   CONSTRAINT     b   ALTER TABLE ONLY public.approval
    ADD CONSTRAINT payment_instruction_pkey PRIMARY KEY (sl_no);
 K   ALTER TABLE ONLY public.approval DROP CONSTRAINT payment_instruction_pkey;
       public            postgres    false    201            �           2606    16670 .   payment_purpose_desc payment_purpose_desc_pkey 
   CONSTRAINT     t   ALTER TABLE ONLY public.payment_purpose_desc
    ADD CONSTRAINT payment_purpose_desc_pkey PRIMARY KEY (purpose_id);
 X   ALTER TABLE ONLY public.payment_purpose_desc DROP CONSTRAINT payment_purpose_desc_pkey;
       public            postgres    false    250            �           2606    16672    schem_master schema_master_pkey 
   CONSTRAINT     c   ALTER TABLE ONLY public.schem_master
    ADD CONSTRAINT schema_master_pkey PRIMARY KEY (schem_id);
 I   ALTER TABLE ONLY public.schem_master DROP CONSTRAINT schema_master_pkey;
       public            postgres    false    251            �           2606    16674     source_master source_master_pkey 
   CONSTRAINT     e   ALTER TABLE ONLY public.source_master
    ADD CONSTRAINT source_master_pkey PRIMARY KEY (source_id);
 J   ALTER TABLE ONLY public.source_master DROP CONSTRAINT source_master_pkey;
       public            postgres    false    252            �           2606    16676    subheads subhead_pkey 
   CONSTRAINT     [   ALTER TABLE ONLY public.subheads
    ADD CONSTRAINT subhead_pkey PRIMARY KEY (subhead_id);
 ?   ALTER TABLE ONLY public.subheads DROP CONSTRAINT subhead_pkey;
       public            postgres    false    253            �           2606    16678    system_desc system_desc_pkey 
   CONSTRAINT     a   ALTER TABLE ONLY public.system_desc
    ADD CONSTRAINT system_desc_pkey PRIMARY KEY (system_id);
 F   ALTER TABLE ONLY public.system_desc DROP CONSTRAINT system_desc_pkey;
       public            postgres    false    254            �           2606    16680    tax_config tax_config_pkey 
   CONSTRAINT     ^   ALTER TABLE ONLY public.tax_config
    ADD CONSTRAINT tax_config_pkey PRIMARY KEY (tax_mode);
 D   ALTER TABLE ONLY public.tax_config DROP CONSTRAINT tax_config_pkey;
       public            postgres    false    255            �           2606    17014    users users_pkey 
   CONSTRAINT     S   ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (user_id);
 :   ALTER TABLE ONLY public.users DROP CONSTRAINT users_pkey;
       public            postgres    false    256            �           2606    16684     vender_master vender_master_pkey 
   CONSTRAINT     f   ALTER TABLE ONLY public.vender_master
    ADD CONSTRAINT vender_master_pkey PRIMARY KEY ("VendorId");
 J   ALTER TABLE ONLY public.vender_master DROP CONSTRAINT vender_master_pkey;
       public            postgres    false    257            &           2620    24735    InvoiceMaster update_invoice_no    TRIGGER     �   CREATE TRIGGER update_invoice_no AFTER INSERT ON public."InvoiceMaster" FOR EACH ROW EXECUTE FUNCTION public.update_invoice_number();
 :   DROP TRIGGER update_invoice_no ON public."InvoiceMaster";
       public          postgres    false    290    283            #           2620    24594    invoice update_invoice_no    TRIGGER     ~   CREATE TRIGGER update_invoice_no AFTER INSERT ON public.invoice FOR EACH ROW EXECUTE FUNCTION public.update_invoice_number();
 2   DROP TRIGGER update_invoice_no ON public.invoice;
       public          postgres    false    290    221            %           2620    24736    MRRMaster update_mrr_id    TRIGGER     v   CREATE TRIGGER update_mrr_id AFTER INSERT ON public."MRRMaster" FOR EACH ROW EXECUTE FUNCTION public.update_mrr_id();
 2   DROP TRIGGER update_mrr_id ON public."MRRMaster";
       public          postgres    false    273    289            $           2620    24637    POMaster update_order    TRIGGER     ~   CREATE TRIGGER update_order AFTER INSERT ON public."POMaster" FOR EACH ROW EXECUTE FUNCTION public.update_order_po_intiate();
 0   DROP TRIGGER update_order ON public."POMaster";
       public          postgres    false    288    270            "           2606    24765 ?   CustomerDistrictMapping CustomerDistrictMapping_DistrictID_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."CustomerDistrictMapping"
    ADD CONSTRAINT "CustomerDistrictMapping_DistrictID_fkey" FOREIGN KEY ("DistrictID") REFERENCES public.dist_master(dist_id) ON UPDATE CASCADE;
 m   ALTER TABLE ONLY public."CustomerDistrictMapping" DROP CONSTRAINT "CustomerDistrictMapping_DistrictID_fkey";
       public          postgres    false    287    3989    210            !           2606    24681 <   CustomerPrincipalPlace CustomerPrincipalPlace_StateCode_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."CustomerPrincipalPlace"
    ADD CONSTRAINT "CustomerPrincipalPlace_StateCode_fkey" FOREIGN KEY ("StateCode") REFERENCES public."StateMaster"("StateCode") ON UPDATE CASCADE ON DELETE SET NULL;
 j   ALTER TABLE ONLY public."CustomerPrincipalPlace" DROP CONSTRAINT "CustomerPrincipalPlace_StateCode_fkey";
       public          postgres    false    279    258    4063                       2606    16962 1   VendorBankAccount VendorBankAccount_VendorID_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."VendorBankAccount"
    ADD CONSTRAINT "VendorBankAccount_VendorID_fkey" FOREIGN KEY ("VendorID") REFERENCES public."VendorMaster"("VendorID") ON UPDATE CASCADE;
 _   ALTER TABLE ONLY public."VendorBankAccount" DROP CONSTRAINT "VendorBankAccount_VendorID_fkey";
       public          postgres    false    4065    265    259                       2606    16925 5   VendorContactPerson VendorContactPerson_VendorID_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."VendorContactPerson"
    ADD CONSTRAINT "VendorContactPerson_VendorID_fkey" FOREIGN KEY ("VendorID") REFERENCES public."VendorMaster"("VendorID") ON UPDATE CASCADE;
 c   ALTER TABLE ONLY public."VendorContactPerson" DROP CONSTRAINT "VendorContactPerson_VendorID_fkey";
       public          postgres    false    259    4065    261                        2606    16993 ;   VendorDistrictMapping VendorDistrictMapping_DistrictID_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."VendorDistrictMapping"
    ADD CONSTRAINT "VendorDistrictMapping_DistrictID_fkey" FOREIGN KEY ("DistrictID") REFERENCES public.dist_master(dist_id) ON UPDATE CASCADE;
 i   ALTER TABLE ONLY public."VendorDistrictMapping" DROP CONSTRAINT "VendorDistrictMapping_DistrictID_fkey";
       public          postgres    false    3989    210    267                       2606    16988 9   VendorDistrictMapping VendorDistrictMapping_VendorID_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."VendorDistrictMapping"
    ADD CONSTRAINT "VendorDistrictMapping_VendorID_fkey" FOREIGN KEY ("VendorID") REFERENCES public."VendorMaster"("VendorID") ON UPDATE CASCADE;
 g   ALTER TABLE ONLY public."VendorDistrictMapping" DROP CONSTRAINT "VendorDistrictMapping_VendorID_fkey";
       public          postgres    false    259    267    4065                       2606    16946 8   VendorPrincipalPlace VendorPrincipalPlace_StateCode_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."VendorPrincipalPlace"
    ADD CONSTRAINT "VendorPrincipalPlace_StateCode_fkey" FOREIGN KEY ("StateCode") REFERENCES public."StateMaster"("StateCode") ON UPDATE CASCADE;
 f   ALTER TABLE ONLY public."VendorPrincipalPlace" DROP CONSTRAINT "VendorPrincipalPlace_StateCode_fkey";
       public          postgres    false    4063    263    258                       2606    16941 7   VendorPrincipalPlace VendorPrincipalPlace_VendorID_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."VendorPrincipalPlace"
    ADD CONSTRAINT "VendorPrincipalPlace_VendorID_fkey" FOREIGN KEY ("VendorID") REFERENCES public."VendorMaster"("VendorID") ON UPDATE CASCADE;
 e   ALTER TABLE ONLY public."VendorPrincipalPlace" DROP CONSTRAINT "VendorPrincipalPlace_VendorID_fkey";
       public          postgres    false    259    4065    263                       2606    16975 +   VendorServices VendorServices_VendorID_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public."VendorServices"
    ADD CONSTRAINT "VendorServices_VendorID_fkey" FOREIGN KEY ("VendorID") REFERENCES public."VendorMaster"("VendorID") ON UPDATE CASCADE;
 Y   ALTER TABLE ONLY public."VendorServices" DROP CONSTRAINT "VendorServices_VendorID_fkey";
       public          postgres    false    4065    259    266                       2606    16685 *   approval_desc approval_desc_permit_no_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.approval_desc
    ADD CONSTRAINT approval_desc_permit_no_fkey FOREIGN KEY (permit_no) REFERENCES public.orders(permit_no) NOT VALID;
 T   ALTER TABLE ONLY public.approval_desc DROP CONSTRAINT approval_desc_permit_no_fkey;
       public          postgres    false    202    244    4041                       2606    16690    approval approval_status_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.approval
    ADD CONSTRAINT approval_status_fkey FOREIGN KEY (status) REFERENCES public.approval_status_desc(status_id) NOT VALID;
 G   ALTER TABLE ONLY public.approval DROP CONSTRAINT approval_status_fkey;
       public          postgres    false    201    204    3979                       2606    16695    lgd_gp_master block_master    FK CONSTRAINT     �   ALTER TABLE ONLY public.lgd_gp_master
    ADD CONSTRAINT block_master FOREIGN KEY (block_code) REFERENCES public.lgd_block_master(block_code) NOT VALID;
 D   ALTER TABLE ONLY public.lgd_gp_master DROP CONSTRAINT block_master;
       public          postgres    false    4025    236    234                       2606    16700    dist_dealer_mapping dist_id    FK CONSTRAINT     �   ALTER TABLE ONLY public.dist_dealer_mapping
    ADD CONSTRAINT dist_id FOREIGN KEY (dist_id) REFERENCES public.dist_master(dist_id) NOT VALID;
 E   ALTER TABLE ONLY public.dist_dealer_mapping DROP CONSTRAINT dist_id;
       public          postgres    false    210    3989    209                       2606    16705    lgd_gp_master dist_master    FK CONSTRAINT     �   ALTER TABLE ONLY public.lgd_gp_master
    ADD CONSTRAINT dist_master FOREIGN KEY (dist_code) REFERENCES public.lgd_dist_master(dist_code) NOT VALID;
 C   ALTER TABLE ONLY public.lgd_gp_master DROP CONSTRAINT dist_master;
       public          postgres    false    236    235    4027                       2606    16710    lgd_block_master dist_master    FK CONSTRAINT     �   ALTER TABLE ONLY public.lgd_block_master
    ADD CONSTRAINT dist_master FOREIGN KEY (dist_code) REFERENCES public.lgd_dist_master(dist_code) NOT VALID;
 F   ALTER TABLE ONLY public.lgd_block_master DROP CONSTRAINT dist_master;
       public          postgres    false    4027    234    235            	           2606    16715    dist_dealer_mapping dl_id    FK CONSTRAINT     �   ALTER TABLE ONLY public.dist_dealer_mapping
    ADD CONSTRAINT dl_id FOREIGN KEY (dl_id) REFERENCES public.dl_master(dl_id) NOT VALID;
 C   ALTER TABLE ONLY public.dist_dealer_mapping DROP CONSTRAINT dl_id;
       public          postgres    false    213    209    3995            
           2606    16720 $   dl_item_map dl_item_map_2_dl_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.dl_item_map
    ADD CONSTRAINT dl_item_map_2_dl_id_fkey FOREIGN KEY (dl_id) REFERENCES public.dl_master(dl_id) NOT VALID;
 N   ALTER TABLE ONLY public.dl_item_map DROP CONSTRAINT dl_item_map_2_dl_id_fkey;
       public          postgres    false    213    3995    211                       2606    16725 &   indent_desc indent_desc_indent_no_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.indent_desc
    ADD CONSTRAINT indent_desc_indent_no_fkey FOREIGN KEY (indent_no) REFERENCES public.indent_old(indent_no) NOT VALID;
 P   ALTER TABLE ONLY public.indent_desc DROP CONSTRAINT indent_desc_indent_no_fkey;
       public          postgres    false    219    218    4003                       2606    16730 &   indent_desc indent_desc_permit_no_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.indent_desc
    ADD CONSTRAINT indent_desc_permit_no_fkey FOREIGN KEY (permit_no) REFERENCES public.orders(permit_no) NOT VALID;
 P   ALTER TABLE ONLY public.indent_desc DROP CONSTRAINT indent_desc_permit_no_fkey;
       public          postgres    false    244    219    4041                       2606    16735    indent_old indent_dist_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.indent_old
    ADD CONSTRAINT indent_dist_id_fkey FOREIGN KEY (dist_id) REFERENCES public.dist_master(dist_id) NOT VALID;
 H   ALTER TABLE ONLY public.indent_old DROP CONSTRAINT indent_dist_id_fkey;
       public          postgres    false    218    3989    210                       2606    16740 )   invoice_desc invoice_desc_invoice_no_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.invoice_desc
    ADD CONSTRAINT invoice_desc_invoice_no_fkey FOREIGN KEY (invoice_no) REFERENCES public.invoice(invoice_no) NOT VALID;
 S   ALTER TABLE ONLY public.invoice_desc DROP CONSTRAINT invoice_desc_invoice_no_fkey;
       public          postgres    false    221    4007    222                       2606    16745 (   invoice_desc invoice_desc_permit_no_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.invoice_desc
    ADD CONSTRAINT invoice_desc_permit_no_fkey FOREIGN KEY (permit_no) REFERENCES public.orders(permit_no) NOT VALID;
 R   ALTER TABLE ONLY public.invoice_desc DROP CONSTRAINT invoice_desc_permit_no_fkey;
       public          postgres    false    222    244    4041                       2606    16750    invoice invoice_dist_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.invoice
    ADD CONSTRAINT invoice_dist_id_fkey FOREIGN KEY (dist_id) REFERENCES public.dist_master(dist_id) NOT VALID;
 F   ALTER TABLE ONLY public.invoice DROP CONSTRAINT invoice_dist_id_fkey;
       public          postgres    false    210    221    3989                       2606    16755 +   jn_stock jn_stock_cluster_id_farmer_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.jn_stock
    ADD CONSTRAINT jn_stock_cluster_id_farmer_id_fkey FOREIGN KEY (cluster_id, farmer_id) REFERENCES public.jn_orders(cluster_id, farmer_id) NOT VALID;
 U   ALTER TABLE ONLY public.jn_stock DROP CONSTRAINT jn_stock_cluster_id_farmer_id_fkey;
       public          postgres    false    233    4021    232    232    233                       2606    16760    mrr_desc mrr_desc_mrr_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.mrr_desc
    ADD CONSTRAINT mrr_desc_mrr_id_fkey FOREIGN KEY (mrr_id) REFERENCES public.mrr(mrr_id) NOT VALID;
 G   ALTER TABLE ONLY public.mrr_desc DROP CONSTRAINT mrr_desc_mrr_id_fkey;
       public          postgres    false    240    4033    239                       2606    16765     mrr_desc mrr_desc_permit_no_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.mrr_desc
    ADD CONSTRAINT mrr_desc_permit_no_fkey FOREIGN KEY (permit_no) REFERENCES public.orders(permit_no) NOT VALID;
 J   ALTER TABLE ONLY public.mrr_desc DROP CONSTRAINT mrr_desc_permit_no_fkey;
       public          postgres    false    4041    240    244                       2606    16770    mrr mrr_dist_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.mrr
    ADD CONSTRAINT mrr_dist_id_fkey FOREIGN KEY (dist_id) REFERENCES public.dist_master(dist_id) NOT VALID;
 >   ALTER TABLE ONLY public.mrr DROP CONSTRAINT mrr_dist_id_fkey;
       public          postgres    false    239    210    3989                       2606    16775 ,   opening_balance opening_balance_dist_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.opening_balance
    ADD CONSTRAINT opening_balance_dist_id_fkey FOREIGN KEY (dist_id) REFERENCES public.dist_master(dist_id);
 V   ALTER TABLE ONLY public.opening_balance DROP CONSTRAINT opening_balance_dist_id_fkey;
       public          postgres    false    210    3989    243                       2606    16780 -   payment_desc payment_desc_transaction_id_fkey    FK CONSTRAINT     �   ALTER TABLE ONLY public.payment_desc
    ADD CONSTRAINT payment_desc_transaction_id_fkey FOREIGN KEY (transaction_id) REFERENCES public.payment(transaction_id) NOT VALID;
 W   ALTER TABLE ONLY public.payment_desc DROP CONSTRAINT payment_desc_transaction_id_fkey;
       public          postgres    false    245    4043    247            �   d  x�m�Ms�0���W�ޑ�l��� ��T��r��V*�h;S$��!�����4���#&�q �?3�uYf����x�M�Bsʵ��#+s_�gInNuyk�~���������6�!���|*l.�K�+�"T/@��-6aԢ��;l'5�Ԉ T8�Y�����HM~5=���;+�"}��Sv-X�P�A����
i�3B�]��Pb޾�{ ⷵ������O�����a�a,�%�_y�m|o�Mw��yQ�b�4���	�b�&�#n�sS�� H
��=I��lX�[v��A�u������q�c9jN��b���D�����eq֦������Mp>P�䒴fΘ�ޚL&߬@�U      �   7  x����nK����`�V�/�r;�@��5EGʦa��jf���>�6��8�8�7�E�]�����ϓ�D�G���{�o.�<����k.� m�X��j^�?~l|�Ƴ�=T�}U6�
1��'b?Q١*$�s��!2����`�]��Ǹ�������M�����k˨1�K_/˕_��|9�<�F]/��l2���6�,���;w�F��uA�(��ʢ�j��i�BM��H�Z2h�cEG.w��n����=2LXE$������>�-k��3αH	� h�G��\�s2�ݩ�PV�(
U��oJj�ߋ�3B��X�T1uУ����N�&��j���T�Y�jwh(i#$3j0�:!d��3��=vn�y��$�	MAӥ��m��|�ʿ�6�6���6
��:�/4�7}�ǩ��r�)Ѻ��J���i�b���0�QXq�Ї�����p }��/.���ʄp-%�_=�O�ú���R�W�v����ń��
u�GLr�:C7�|�<<FMC�\�R�C��0M�)�eQ�H��@,mR�E�H��`8x8���-�4���\����o���/~��},
�%0W�ᢑF4B�6����stk'��Ъ:�˭�-�a�@X�&m�1�i��J4�&�V��X�������JZ�B�S��D��A#�hD�C�Ƒ�G����3�0͈���axA�	���uD������Ԇ��M���w���d��Ae�Οu>5����@A�%�jFL1v��M�7�NN�|p�ㆡ�A1��o��N[$*bI�J�FF1>*��X�.��z[�p�E�X����@M�b7L?���]���h`b��3�(a��K@Xgu��o!�aL*fdS1뺩w��aPx*�,�xd ��"��~����lv�}@�PI�2z���+��"� ���RT`�*�����:�����g��\f�`�S��E?������_nPK��+����OO��g2�I�.�Dc�	<:�� ���9���@��R(S$�ٕ-L�po	X�X��v���ލ�N�i]�2A��m�r��c��M�(�$�R��4<�f�w��mH�7��M7�$p�V�f>ǫ麅.���ǣ��<���ҋ��a`��`S��t�݂�0�B&Ir�S�ͣ�����Y	�t��)����!�/��N2�G��W�f�c9�A���o6z@%\�X%������?�I���ѡx���jV����&��'��G�
r.����Yoѫj��(����T&�g[Qo�T���e�ù�o��,o��"�_e�\_�V1C�[Ų]��5�&o������"�~          F   x�s6�40�4202�5��5�P04�24�25�373�60�26�r�2�4�@Wfbel�ghaU���� ���      �   �  x���Ms�H��տB����m�J*I��@2�|i$�s)ƨ���=��~�*w��m_և[Y��ǛYx�S��^�����Ir�SGN���#i��T�|����rCv���C��.��ic{�S5�����ʥ}�~"u��4��y-��<�v|�o�8%2&�B	��d�K�r �v܋3���ӟ���,'qf�E��8�I'��6��>�@xp�)	]�F��#�j���y�X�OM�A�	�w���Q}Re_�&�E�k�#0�Y��9N_�)e>�����/L����7j5�4byn�z6sy+�X�5��]ˑ���x���î��K�(��9�.o��;:�8n(��x>�>�����Z9 ��6?Iq�C�ɡ�:=�+�?��Hxg�d @$���)៩���M'&��Ø+Hu�Q����)�~�2d�v�:��(�k+�ńXײ+G#9� #���f�ￎ�>6�$�}!��܀<=��z�c��k���'ie�`1�h�����2�ۂhcM2�h]�H��s�z���ɧ��̥�n��Ԫ�Tj�f��6Ӆ-��u:��9D�-j�gb�=<@n��ˮ���ծ\���W[�_V��l�%�ǟ�3mϥ���G�F&ǌq�g�����T���n��P֜l�[T؞_�a�n�d� AEZ�s������U��E�j��{����1�r��zP�7(L�_��zjF �v蝠y�\d2K��X�"�Hˇo:�9b4'�3L���Av&t������_����]�(ge#��4�w�s�հ�!�Q�τ����U��8KǺ�#"����R}�)7�����Y�\����f���w�X�ρ�u\����1J���;���<���Tfm��H����!�atN�N��2�B��c��.V�~�֍F�����a����7���^�[�xI������Ӵ�R枥<8uU
=�h����=�Ԁ�B��3�ٔ9uD��i&s3��1��|�qbu��C`�9��x�&$t�5�C';�O����m��ů19F���j�?E�cE�6��q�h��i�c�E	�-!�Q�k
��觩�P�U�)|p�)�����KV�o�d/��j�-idvpҿ��lؼh��QT�Hc*fGE֕/�0<�	�΄��c���"ðuq�es�軻��H��]Z�@�BNd7K:�`Rd��7�`���X㫫�y�-���HK��w�%��jW���]����w�|���m��/2S��B=�3��iU����/,L�:��u|3\`��)	=��p��x8���������������y���qDIw <Vo�������'��f�)����1�O��4�f<������ 3iA�1C��[\:��W�nw�u�D2���`6���.f���Ɲb���X��(FI�,����Tr����8��&��Ճ}�uf����/ZԱ�Sj�j�n�ݩծs <��_|G���	,D(���(���r]Y�}� l�_��;�|��VV��<P���#��Q�����eAo�q��,�I�z%��f�8�_
<y��������������^ˡ�z�s3s`����yyOP��%����|���/,��l�ے��M������::��+��D�o�|�4�'t�q�ifl7�1:�����!�VO���O�����Î>6� 7A�u��fS:�e�p ��.���꣇���m,9��{d������|�MU�5���\_�a	��W�æs�bH�V`�!�m���v��k�8Q@ �;7�6������c<�!�{Y1��"�`<w�?:^b<�z�l�~7�ۏw�FDG/��� �	��+Y���7�W�4�1)�Hs�^�҄`�.�z�>�gl���y^o��]�q�?��Lm{I|��'�������_j��W�{��j�?���������f��?E��-����Foa���㲼G5��#�C̃���@���	g�lf߶��o6��H`�y�T��D��W�v|u�7��yɏ�;��W�����gP�ź�=�Ϛ_$�eΝ���f\���-�	��7��M^�~C݄�ށ��*U��ܲ�Ia�^7�Q=��(Cg�A{����M����.�ف%-�"`�k{�W�f�Po�axR�f��h��z�1|Q�<��.@�
'���Oo�ޢ��N��h�{���AmW�J(�ˋk4�J1�9;s�>�ش0�x"�U\�,Ǯs��\_����i�7��a�y��+���b��0w�a������� ���6      �   �  x��WMS�8=�_��&B���)q��ز�Nf�-.ށ(�@Q�j���6����D�E��j���#���ѵ�"����p�2<D�6�m�l�kh*匰Y�}S���nF���:	&���s�	7�b��T��7�3�"�ץ����Lz&�2�����/�[�i;`�Io��N�o���vۍ���'�R�+Ƹ����Z�[���X��i
�`큓��n���=�9�qz+>#�?�����ˌ�=�a?<��?���y��ę�T	��+H�
���u6��\�6�p�1m�*ƀc��,D�.�Ƃ�"��B���1���Hn[Y�,�u�.���bk��q-:�	�H%I��OtYEu����MY5�@�	�[	9E��h��A ����n�:Ҍ�T1�T��J^	cQm��0��Ga]n���ѕ#.3f��1�m�D
'�2r��Yz���>A'��q�Y��ZO@�Hx�B�yg��wߪ���LĨA�}�Lf�	G(*cL<d�'59�-�d�P�%O���ȁh��+����~�t������Jr �,�U�>�V�Z d�K.�*S^#i �?�J]F�AD|�-9@���9K�[iD�
�I��Ғ`���s�2��!-ĄG�8D�`0�.�f�r<��#tY�q�(q��v~�|@v�$i�K/&��vA&0��H1���t1��IH�4cT���D�����4$ʩH�����Ӏ&cB�v���$$(����X[�`�rws?|zt�n�����ԙ`0a�7���~�5<�v�&aLÇ�W�|���x����;���i�'O�ɷ��o�ǰ����~w���<������Ksl�+RL��y���Ť�x7*����E�j����>�����m�Z�=*v)��j�#�XR���y��-Y6u[���V�#]�$��֫��X�s�/�Es�_�ٯMn�,闰VV �l{~��&$\����[m7���������e�Tӷ�y�^��\�����(]>��&
e	���K�HJ�kim��(�	HTKX������Ҝ��?#���b�9-�Mer��T�����'��2LX��j=LA����-c,d� �N[��%lMES��5�%s�6"h^��<��(۲*�q�:������r,ÏԂ}C~^X���A����6j�xu��d0bq@e��p���#A��Qt�W���kzvv�vBr?      �   A   x�s	3�t�K-J�,N,����r	3�tL/�W�ML���T��!B�y�%@�	�[jj
W� �
�      �     x��[s۶ǟ�O��3���;��k_�#e�&�5vS'��nz��Y�� 	7�3c[���`��i����2����c(�����ϳ�����1f6�^�l";FV C6f8F��d�Y���_�����C)�6�g���O_9B��L�s8F+���O�g�����'g��4��%[�e�Iϻ�?/�'7�g�_�}:�4��Rrk�˓ߋ��o7g'�+����Ll���UR������=o���l�S�v�q2�l��z�"������0���K0��qPj4;m4�'�%��иմ\O���<C6�����������:v4`T�h��}Ec����� ɵ ��Di&B"�J!u7��lrS�ˬ�H��y�D��g���Y ����	��Փ�d�t��\�l(� 9EV�K��0����!6F\��3��y��f&�P��a4B��ۧ�F��pT�sƲ�ݣ�!����l,-%��Нl 7�����*�2YҮ�M��}�l�`�	�/�lN���؄�g���ɦkM�=�?x�l(aZE�xM���&��}�����@�{���_�F�c�w��J��,2�1�,�`}d(|�� KP�������v�����`�����ȶ���Z�c#��	ۭ��:����Ȳ�6�P�u����?{�<C{i���l6�ωwlD�}�u��n�����6���X6�$ض�a-6H�#Kd6��w��l�2�Ȅz�<g27�=�!0b�>I ���t�߹�H�6��FdC�	�E&����q�q2���?#����#�Π�/�p�ϫ�	i�����F#)n�R@�dnk��3����<;*ĥVw����^Zf�Q>6!��{�~J�M����]nDd�\���{i�9;i��
y��u���j��: �TFu��=ާ�Xl�0F�8�'�q𞋍D%���<��Bu��<+��0ݕ�Ɍ,���(�Ҧh�P=�D�H��I%�S�� ^���#�g;Dc�C�.�QW4e�ƐJ�rM����Es� ���JIy� �Bdiy��$�*��[ ����D�\iޒY��p���]!x�C9;Ѫۋ���XG�C ���ni`���#<�A���,eOQE�FiX�]�h��r��8�S��@��.�w�J+G"�y� ���鲷_�lB>�!�
�T��|�Y��@�)Β�,ǵD��F���#=Kͻ�)�C��c��"%ha��K}Z_�Ø�1F������l��0F�6f��9�T!54Z�P,�y��	1�#��]� 4Ē����v��84h�*̆!�kRw0(�H,e�]���J2�J��nt��]�Ͽ>�Nht7��C�]�< ݛ��i����j��T��H���L8�}S�sP�Ձ�p�r~Z���j4������	�~��bv8�|�zy�����u�Rc�`cl���kbz7]"{��2���d����Aҏ�3A������R�7X�����e���h�x�3y����x�)4"��6BtY�y�kִ/��Ycޞqy��Z  r0r�� �8e2�1j玅�/��!���m�ߞ0-�qܟL�>��b ��L�)
��H���캗cJ�6��� ����8"Z��&Gʙ�⦤k�'�=��	�q�3"�X8�!�o�* �u&5*��Ϥß�L�L��P �"��Vb]�Y�-��N�v�]��l� �8���3�H�y�z0�E<
���J0�2,�F�u.��K����:)��g��4P;ɺ+5�j)�T��T2��5�����4����	E�NJ=�ƭ�����k;6��P�a�b<Y�������c-Ԥ���z)�&���L�dWk�(I$@)D�I�k_�D� �@�qDd%+�>l�HFv�J!�Yr�@$cy" +i}<�R�a�Lq��i��tu����i���ҏQ,v>{%�#�W7�u�{(TV�0>'gVte[�ii��K�R�ze�����*tSTC�Ռ)^�1���b&v���{F���'�a�#BI�x[ar�y��1���N1jI#}]�W��M,i��8����Lpr�{����a6&�Ť��А�,�����Ti�>4�g��!h�R��CVI��yif�C+[���B#��1�L��h��
�\Scڞq��$E�!��+.K��9_Mvi^�0�ݛпF�2{r��:j�x&2�H�y��u�Q��&�Q���I\;i�kM�GٶZ

\��-�;�o�9Q Mi�w����.}[�����K��Pl]�]G2��˕##S����>����@�bh5Hl���=|�]�s+U���H޻��\��k"/,e@��Mu���x���VJ縑ZMs25���mb$�D_�U�&�fu6���䓭��;��zĨ�()򤬎��W���:"�<��X�I��_�O��x1Q1Uje�s��P�9��vX)C[ο�1 �#�ך�g�ZŶU�H	��a�o�`�:�	}�m<���&�mP��֦r���DT@D��g"�D{�hޞq����-���EEc������[�m��0���2U#=Nm�(�~։Q��q��^�B[J�y�Ph+:���j��1|E~����bB����v�}}OYhS��J�/&m���1j&�ӓ-�˅L-�X��j۫I0&���I�Զe�}$$�E^]5��|;F}� }@uZ�cx���w���
����f���%%����q ��H\j��b$���Ս���\�t�a('�/T��Dc�mh���OU�J��s��A��Ԗ��е�}��_dǅX�SW�FY�?Bo�v�%��Mi4tr�q����ۧL�4e�"��z����u�h�Y��cR�Y�V��EO�&���}HpZ�k�Y���Z-�uW�]��q���ċDዎ�y�3�;
)�3��@����hB*�4w�j�s�C���R�D��6���Nu(�ֵ�V������lX�lX��@���a�|C�9T�yK�,���[g)4�[�T���ԩ�.���ʆF�ً�:p�����mG�[Ҧy{ƭMfk�����~��h9Z�1a���H�/4O�3buC�PkD�l��[#f;3EYП���������,�vm}���GS�Y�B[R0Oߚ�ԖJ�����9����*>s��!�߸� }�	"U�| ��g�خ}.�*!��Զ�R^�lĺn��IJې�)�KZ��dQ����w�Ia(O�,}������j���ٮ�$]}��%:G����(�E>�1oϸu�����`H�JBɇ�W�G����};�������%HZY���m�T\'J<�y{ƭS1�o���0Gڕs��lq$XK!g�=�⸈챉1����1mϸ�i#�A�Am���"򅺊���Z�F������      �      x��]�rǒ}���_a�ø�/x�)[�X�9���������$�I���������ɥ�] �� �H�A�>՝�yr�����O�?���Y���v~9�0[��L�u;o��/�U��f��lu5?[^]/onGR�~�_.�XM�nFR���C�]D����Z������#%��Jį�m��(3���v��������8�'��ً���� �&N0���AL�:��~hZ�~8�xF?/�O/�����_���ړ��f	��f��y�ay�|;=����/���z��_^�����������s7?w�������kB�6�:�Ʋ�e��I�2ckG�:k2)`%c�vM��$xޖ�Cti�3sc����%�']��,I+| Z�|Ȃ.�J�����w�Sz1���r�h���Z6?�ݮ����K9����\5_OofY�^�~|
���"�R�o�K��MOl�X7�N=�JT^�A䆑�"�2-��v���O���� �%�6�t��]���~"�Z�0V`�� ��f���O�«���Ս���������k��d�w���iJ��ï���^Y#�V'Btt�ۍ��=q��w�;ƍF��4E��Qc����t���l5�=�!&F��>̌tpnݎ�p[u,X�v)�#I��ȗ	���F���g���b�a�|�����U731)�W�H ׽�>�����q ������jV��M���|>޼H?Qvl\O����p�o����b!�f)�"�;��Z�a|5��t���'�zﶠ�:c�gA\Lw΅,8RȡH�_u�0�;4q�*&�cgQrL����f��K~���F*x����(�_���n�g������Pl���y�=?��N��׫�y�D�y������W��M`�vt��[�<�n�A�Д� ;�m��)��%#�h�Y��K���y��N������]T���7�3x���Ϛ�?o�ͫ�sНw����|�H�|s��Mn�nlvG���E�Hw:��@*�L�3ho��K{;���WD;oޜ�Ҟ�]��p��������I�(��2+�N&K��L��I Z��$��D>m��M ���*���T�_ӎ��u�HK�ِ�h{����nPs�����
�K��S�����p�_O_5��W��w׫��Dh?���lv}1��5.?%U�}����s��L>��(�ķvR����.P�'�R�w�]��U�"[�"S����,Ƃc�p ��)���w���tv���!7��@}�
�� ���&�|]�2g�p�隣L��Z/���HΒ�M�E�˜,���"����=Ԋ(bW22"
�Y&#5�9� �<��1ole��{eFڇ��*�d�Z�
N9���Kx8���j�uN�2"=�I�K���S�	��a�ng�ojp2]�]��[M���9y�n������M!�s%�C��C��5��
��X�
�ј�kq� �Ԇl+f�m��jsP [Ja7}�Q �N���ޟ��g�K``��&
�1���J���`J���1҂l�/�'�����հ������g�_`��Hd�O��2�`h}D:n1gj���&����EJ�Ӣ�,52` �aހ�N���R^�H{)�qO�<�k�������,���9�@b��l�6{��>w����|�zl�10"�����.� ��k�c�HK��������y�s}�=�M�g���,�m��9P���gt?���u�#J����U���L����B�@�s�
�">eM�.�
&�� �MT��&�T\��G�dwp@��G���:�^z�+�޺oQ�_�I�{2,�?��Z�	X�`*�x*%�q��¬�ї��7� !愥̒?p%s b/ڸ��������ܯ�7,p.ج,9zP��Kj�W
�O���KBD�XM��x��#���je+2�+́J��� �������by����׳�Ռ�@濩��A��O���Epa@��s5��1!2��Eb@&f$�KD���Oe!u�*�J�94K����ql�N�]4hc�}����k5�.0Ɇ���d�m�������˹���~&�Q�{���Ø�"m�����Ң���	���v�G����zq�ZXE�Xq���D�r:i�xJ��	{� g?>� ��!=(ٵ'����"F���'U9�nR�X0�ҧ�ՖA«�Ă^�c�mo0ƃ��3&�.m�� �c<�q�r��@��J��"�ZĢ�{b��p��>�܁��q�n*<m�Ї�@�G 4.�J� ��1}D��<�K �D�����0��j�[�t�;JCARj��ѱL�v�Z����ҏ����sȟ�c�swk���x�Sn��N�l�;s�;ov��XR�&UH��RJ�$����N��H�y��@�è�����5(@9�K}�G
�Z�=��q%:������X?�Y\�r�FEtn��F���4�=Q
�WoT4��+�[1W���DM0�$hj�z�W�o, C+�4��m�IF�IƜ}\�AY����1���?&ve��v-x㹌�d�����3L��tA0t3^�ze���n4:4�q�/�{If�-\ê�i,Ȑ5&ɜ�%�1�VƢw�`,�i9\2`w}�!6.hjf��J��82Vtb����~�]w7�1uSJ�/���+bJ��Q
h@'�
�F327����\p�>�Y;S@�'�1�B,)E|SB��(
7�37m�ܘҀf��h��Q������n1�WsĤ9������O|��7W�+����z��@J`;7T�w�R@Y]�X_T [g6YW�T���Y/��qI~MLIs�O��$ٞ�8`�nw��UK�W߯�|�=Ca�gB�����⸘��֤�ӛ���˒-g�@n��vK�K)ZQޭ:��?�^F��%�u�]Hͭ��_�?;hRΡI/�	8��-��4��W������<���;��b�\4f3�$li[�z ȴ#��1s�Ӎd�vN�b#���]]�C �S�W�퐁�)�[�9_Y�L�Y`���l�1pw�0�d/��t���t*χ���B���p��B���@C8�	���!�\W�i5ls��uܴ0�1�W��C@�gAJ��@[�J��c��7+��qz�[u��������+2��RR�Z�IINJIIeٖT�t���p�72SV#����?Ԯ�.b9Fsg<v��$�k;�"qV����HP�j�Ub�t�����-%oJ��{�U'gz�G�Z)�Ԏ۰S�ԡ�~�|��0�n�B����:��}��o�׫�b~و�s��e7ԩ�G*5z
]��u9a�dDu��!Z�
�~���z+�L�,1:�r�@�2g�b���J�`�0:�[����=����O�.�td?�}=nq�n�ƃ�6����h0±B��0`���pn��JL �"���y:��2g�s&E$��;�*�����>D�m�($�GЛ��*��s�ub��d���{E]5��~x�2�%�cgz�ч��8D�'��M\T�efD�\9g`+��w�4:�$��z�y�[�J�&�t�BŢ��uf��	�(���;@Wi����>�	�����;ޝ�Ci+�_�Y��^���cZ�q �V�y���f�~�hv���\��X��&b��̕CNXS�Gp��i(�ׯB�g(&;�A�F�HUY���
VvB#�}��-ڃH;�=FO���ƃO2ր�|����X/�� 9/ �l�9ݥri;���Q����^˨u�x�G��sҗ�C�D'�c�T�����ׯq��}5�z{>m����ۜ���^.S�g�5@ŖrG-��׺�K�MS��y�٨	5�r��[���A]�X�6��\r
��rU�U�%�爎9�tM-��npd�ˏ��.�:���Ώ`�c.��@�S���I�z/>�cfa'o�r��T��}�,��Ҧ%�oH�*�n�"��^-���<V��6����:tS�|��ҩ�]ྲL޻l  Kc��d]�@x'���>z���ˈ�,��t�%&s.�&N�R��ؿ� �jˍ���r`�L����GX�p�� x  Y;`9�>�Us�	���D�,�0��p$F bVl"q��p�}�+E�W�+���R��r���P��dJ��]�����1`�63{.a}����by�Z�.��L;�������΄�H�R�WH�]}$��򠋀]��nĶ�
�1h�dt�U&F��\�D7��B�S��:OрW��#��*`x	��Jnya��~9Db4�@*0�����˻�r�4�*q�|�9���ӳ��-8��I.�eW࠰2���f�dp�4�Ĭ5���M2 ��q$Xڱ���N;�N73<�O�q<Yf�ʻԖij�7x)��(``5�9e(m���Ȕ�ɚ�_�X�kq~����}����I�=,wpj�1m�ګ<��:��ֺ:�?$�:�O
��0Jl��@8Zz@U�S�R��"�u��u/UB�ڏ�R҂J�04���a���e����p,���jm�0[O�D�i�-p�hv�%=hv��	쟣� �SaY$�%�]9/�G�q��ι΃ r�㡮ܰ�	iJ&FHy�P�X��Ql 0J�:{��y7_L/���:y�����r�,|	/�Zғ�:���0��<�����b>��ڿ�W��m"�����u�KF��_�f�O(��t�����zF�$���Z���i,,�<h-�gE���sX�f�u-ť����j9*N����v9ݝb�kE� ���T�l�T�W�R��xMcI>����)�����)��e��)"U��#�sE}�Ѳ���M����6�\Q�H�Vն�JO�F_��AH~��nۍ���gR�����-W%w�H"n�u�Ѡ7�>eң(TSm�R��t�K"ž6E��������@-��ǝ��=K��k#��s��W�c��N-7t6�˶� �`��Ĩ�nh��8ȃ��mW�R�K/4�ײ`���Xsl,�u��P�]��r��@�� �f�.
�"%U>����3e{���,�}�p�[���D���W��	�u3��PBX��^I�� ��p(��@{%n�����<�H�IS�U��`}��xr�׀f��<h{�#�s�4�#�ɒ��l�r��2�F����{���^Ow�Y�uS�B�#_~��B��w0Ș�B�a�wٶ��`�h��N\�o������'���N,m���UʽJ=jk5�x~�S��t8��ڇ��vV�P��_�SB��]�\�v��Z��K�ꊒA��(��7�l��>ʽ�~�He����XvԎ^��9�q[���`E�+�n�z�y_�0_�hJ��ksV$O���p�s�,sY��~1�L,Ew�)@�:׸��
wmn� i̽����~�g��NϚ7�s���Y:n�{5 ���-;V�
X�\��Cy>XA:��C,s���SX!6gyS��G�M��1_f��M#Y&[���
�p�VW)�Gߍ܃#M�����v��e�T�t���m���j���m�Ҩ��	�G*�Z|?D�M��T��_[�[﵈΀��Z"�Zb���I至If-�	,$8#��V�~��Et�5��_M? ?��
��:s;@k�Ʊ��w9�`Wg�ށ�C#
�>�x�K9�Ž����݂R��Hs_�cN�P'��ɛ��%} ���2	��UuAj9�c?;H=d	��8/y,��y� rL�-m`ɜ.�8��v�H�������.�w�w�E�9�<ʏ�le|ϊ��M�X�t��YdjN�#��x4Vqg
f_\g���iD76�zՒhߵԎ�I9�}7ɘ#c��!��S��\`�Ҵdƕ���K
̭> c/��}�bl���Η���H��'��D��m.����2�b)��ˤ{��Yn�HoJ�r)��l
<䔛Ŧ@�ߙ�pW�5vs����#�|y�H�y}ܴ[���5��J�w�CR���<<���U[�;�s��R�Mōyr��ϗ��]������%�/i����G�ɟ��y��������������K&�?L��+��8!���7_h!���gM����O�K~�q�E�褅5%����uI�;���t$ń:9w�-cAuk�GG��Ĭ�-'>]����f(c�)�i�c�Ϛ�o��;�̯��Had�y���\��)\AHx�',���oX(�y�h7S�0|=�����y=_�yY73X���b��Wg�.�P�'ˮ2�0����*��KA�_%R�[�9M��el�Q��Co?M"9Q"y�),)]�4���DᾷCg)�F�����Ôx���r�{��)�#ќ��~���7Ѻ��hXՒ�_��6�[�Q��#�v�_��kmi36���	��ng��#��Mȑ5�B~"�:�&^��������j>m�Non��Ŵ��� >m�h���oCs����֧-b�P�q!��KȦJ���Gf6b|�9����ި|ԅ�ey�G�y>e/L9\��}���1���	,dm�!<��P��x��\��{��nG��*�o5��-�Hk�fz�J��r;;�hNW����6�_V���lu5m���sd��XJ�s�D�P�����(�w���p&�q�ĺ���uɔ��ȶ�!()��y���u���0��1���SPۗ��_��w���r1k�8}��~�������jvy9?k��W0���W�K"vk�|RSp;*�����3M���e[06;_!v�e��Rܕ�g##XU��jϾTp�Z��d�QM��48r���,���i� +��C�2�ؘzGuRƔ�3,R��N���5��!J_˞��6�[�6\��z'24x��T�e��`�GR?}mw����=�x�6�m��#x�$��ɽb��to� ?Q�\�߻h�غIR͉N,��LE�Q��q	��o�c���(4�κ��i��߄d�8&еw&P��8�}�%��W�K��n�̖ά@o��>�(�(;IʒǗH^͈N �
9�D������?����%q       �   O   x����0��0L�8q�����(�KAL�
T\���6*x�A�gC�G�c -hZ3�*���r���w8��>$?�`      �      x������ � �      �      x������ � �      �   �  x��]o�H��'������ɜ��a����� ��U�M�:[Ŏ�S��~��IjGF�%dd�0�yxg�se�a�D�����1�w�-�杋$�P
��t�?��|���UXV6�	��ɥw�������_1��\/	��x?\��?�&ӿ���:>�<�}�&?��,�� #�k)��;B[+�+8aF[�j[�
[T��l��׸}�>���|����|�����i�n�]N�����#�Ļ�O��v�u�t�p@w%�ڮ�<�[q�������ۛ���[����M�W�d�^cH)��J(��Oi�]e!��ͫnǰh�������"�Dx��#/�y���0�X����'�8������� ��T�Z`V2W±���,��y�� �6P: 3�ƕ
v ����-��ȉ?��h*@�ւx>}�wP� 3���bqw{��L��gD֕JH�\�	�Fsת����U��*�m�!��|��4(H8�o5x��$�M�4� ��szI<�q&���Y��z)R!-��X��Di��ˢ�Kf��I�h����+~�����3��g�Ϸ � ���P� �!�Y�l(@�	dy��/�.�.S3+����o<y�`rqN��A�������_��m<_���H�Ѭk�\��"���dY�+l^u;�E��L9Pz2���
n�=����Q4�阈#������t'ġ+u��TO7#�;)��A�e��%��A��c�p�gg}�j�HЛ�y��S) Z�����!E���Sv�#jS��W�o��ד `��aj$SΞ�?y�$��ҽ✶����U�¹�UU�r>��_�r����p�j�^-u�QڒI�c��^�ꅞ�~q���4��n�4
���ž	͘�����7T4B3C�����7�0?�7���Q=n-��Y���x:NzQk�B�e���.�m6�2]��l�vWW�T��u���&`�;d��j�րζ�����;��ٔ�ũ�{)g�6�Ytt�qAl���J�%r��-�?fm��5�k%l����S^�Ip����I��rѕ�Լ!O�Ϫ�P�\�l�$��$�(˓�0^�I�p�r�&�bo���E�uv[U�\X���{2ۡ<4�q�;Xl���j�:O�v����&��{2`�jVZULY,�M���χ�dhUy���~��~��l͚2��#�r� K�\缠�@��CsN�X��o��]?+��QS
%����i�bd[r��y�-]�V֮p4�R��R�]�Z�q ��ʮ��ٮ�z�oՍؒ���e�ׄ�{�nV��=���΅��2 ��Q�F�u������[ ����gN���!���^���Ѩ�F���t����-C1�8�]�Ƈ.�'��|�/{�5�:Tz�G_ܣ���Da*      �   >  x�]PIn1;K�����ȉ���K/R���&9��"%S́P,2�$�T��6�N�%���yk���^a]�4����G��2�2�����d�ذ�z�Z�G�,���VB���ۥ��@36>�u�6;Zn`��e���|$��D�|��ъ��K&��*���%n�X_(�tD��]E��D	ѳQR��a��Yʰ��	B��=Q���K���J:n;x
�~nu��vlz�Wt�A����>�zW듍��b�3U�h]ܲR�B�!�1ԑC���`s��Dn�RP�|�ѻ8{�zy�O6z�֧���Ŀ_��̓y�      �   
  x��Z�r�F}���[�{z�xEE�)QZJ�^*/����8���*��g@�"1�"�����Ꞿ���������T�&y�������l�p��\6�>=�����b:k�Y̋��f�l��l:���[�{��婽���v���EӧO/<���*��Fg<�`����ݯ��VQ�|ͦ�T���B�*>.�˷��y��7��:R4�j�^�����;�-�*���I��W��\�NfD���#v�ZGt�*����)T��QĔ��M�8_M�㭔��l6���>���A�O�����c[��buY�^!�e�8{_^4����U���%����c��ș�'�J�k�ɇ*��8�n(��fSYU4ӫ�Q��
��qڒ���-���SD1����I��P�Ͽ�.I���Md�SI,wټ6�Q��s�J�o|���B:T�B���ʎﱧ��}�a�Ԙ�N
y�9dP�X�p�`,4h/�9�]�^B�W�l�7�|�Zy6#9���b��IcaU�8���јdc�Gs��g����N�7v�dؚUovA�w8�H��ai4TEV[K���d)�R���4���cy~{�_\��*X6��1k�PU!ƣ
�ݳ�[R%�ڨZ)̒��	����ݸ+�����Ogۺ]>�W�����-���p��#f�)���1��X��m���¬ǣ�����R�9����"��y%m�:��A6Ϳ�d3ow��aV��: TQ���`�M�a>�&l�XQ�v�f>XL�Ӟ� F����q�GS5�ry�L�ȁ�<f�*oB���uu*"WF�<�O���:�T��g��֏O����h�f!��{d���p�M��&���TpKP�XRA�2%V�N>���e�[�K�h��A�e��~��6��j�C���6'���1�Cl�]�:��B�`.�сXD�/'!�3�9h�E���k���c9ٴ�O����D����v�=��?���Y�1��5�k�o[�1!��� (����|�E�X-���f������-���rD*��!���TE� #�<�P�~�]��N�k����c�N_d���v	��r�Z�[_,WW���@#9�Nw����4˦?�}܈�����x��c�,v�t�1�Pɀu�1P:_<��'�ח�1�P�#���>���cR1 {X7Y*��P3U�U��V�`��:*�Z�<y
��7��8X6c�YY��!� S���Pm�AN��~`��i�i+�1tOEkX�\�����F
]`�8n<	oأ��HMױ���	h>͇R��y)�n���		�`�EU�~@�<�/�������J;�\�n��e�hV7x��F�iL���:�,�����jr��-4Y�C������~��	3ALtvf�\[�(�f#��q���R:h�F&�;��e�og����7��{�Y?��	c��{���6ᓴ7@aS!]!'�����1 �ԏ�v���]]��MI ͮ��_W��� �1C�Y��D�UbD�0"ڮ�4��Z�䈍�n���߀5m��}\��rR�4]�*���-�c:�c+`���bE�Td�"�]NV�Mf�?p��;�1&	���O�Q>�8�6�pj��Yi��2��dpq��a2�M���AG �-�$D�;d���[�h ښ	�ۜ�}w:.g��v��Vww��|w��c�r��
��gI��@�\EB�X"�)����:
��s?kשٷg�'g��
xL����e��4��+l-!\
@� �7������a&%��ceI9@�U��I|�Ȭ UkWAd^�U`��#��=�.��h�&����o �KO�p""N�
%LJ�$t�j��\���`RaIc������w{��#W�`���8���tPG>�x{�j(�#�f{�p�7rѐ0���+ͮ��'Á<X��f�'�%�$>��0�l,���@X�l@�A5�����:���INt�R�$�����F>��fSe�w��K��k�%�L�1Z,�'	�Qa@��B�H���;�I��9P���VYut��r�bc����t䗣�s1�z�-��� %{�r���b�j�Q+ze�0��� 54�r��G����O���P,�&`4D`4�C���%�Nʽ-��Ġ9�4xl��UmM����9�&�� ���
����U�ܷg��ed�p��:�0)&�2̮�!�SH�h��F��k¥+�++���Г_d�9�51�PrFӛ&	�O'��#o�B�+�� �XA���m��~!�����B�_�g����.F]9L��pǥ�ż@f&������-�|8��	�w��W;�������<�-����>���û�1��w��TV!���5U�|	+H0�p]u�C��D�g���ͺ}noZm��^�ʛK�R`����QY����<+��cr/d%���f�p@�T,��6���ڍJz툐�e���G�%�o��$��
�'�i}𤣑5�᜶�/��薥A|�P��%HaC�:�a;A.:U$��z284�8�ag�����a���,#l�h�4��=�&��8��vIf�D�g��S9�UD�^����� ��fl����Nب$��%�4�~���4���Vco�@�/���r`mW���Og�T�FwlH0w�D��+b�6�.v��
0��;C"}�F��%gO/���m?*=� ��<�Gq��xܱ��\���{l��_�sc��sd���L2a��ho{+iʛ�ۻr��t��n���֐��}p:����E��Pa�9��u��@����D�\�C��P�t����ӁG�E5p����TԱFq�	�Pa�W����0���������=�Wt�s��a����G�G�݅�R{M�S6~�M>o�?�t��y���l�~��MOn�4�@E�px��	���Z����ec:Qhafb��u>}����1>ɏ���î��K�R�Of��F��e�Іk�i�$��	X�	@_$�k�Vl�V��-�l&�򮹜��ow~yh?�$9urQ�tE��F2YZ&}fSiaQ���\�y�濝% E      �   1  x��Yks�F���+��5J��j>E^�����٩ڪ��a�l.����-� G����L\)��Gg��soߏ\ğ��)f��g���V7������F�ٰۺ������)���l�����??�}���kvWl_�|�-X��y�9�ض�j�&J���m����;��?C�Y�_�;���V�?l���o�~�7��D�$��Ɩ����k���m�ĭX��n+cj�;����9߷&~y`7~���C��$���3\ژ��9}|�6���۷�q����Wz�Nz����/�5NG�A/�R\Ϙs2Q��ı�n"����_�7�à|E��U��X,�}�zz�}�U�X�Dr�?l�)3�|_�Gz��o~�����-d[�(1q�����	6I�T���-��7���֗~��;+���2@�<�7�����R P��-m��H(w�A�!H6Φ�7�٤?L[i'��m6��7,�A!l�,����
��[�Op(6N���Vov7M���դ|p�&��s�R\V��ó={�-2��g^�Y,�u�_Po�ҧ���W+�&9�Wg'�Z��暳���[Ta���a{�/?�C���U�Z)��b�C�[�[������/����4`���a�w�q�G{��Y�Y���.��^:�����C)RR�-ǯ�7ʂ����-V��<���bP�6�mn#'�`j�������4�̆]�����B��d�������<a#���d��-�-����2i�V����uB�0�&��eh�aFq�O�G�8���ّ=�5B'���E~�̋?/]�IP�j+�ztj�%��ڤd�.�>���V�?��'���)�$l����#������L���6����l2�ݾ2L��N��PDc������?�Ch'��Ot��,�Tq6�;#M�2�°��/����:���
�"�R�E�aP�b::�b<�MY'�������9t����*����2G]�}P*����I�\܀���X�&���=1�n�!ƽ}丢|Y%堖��_}Ӧ���Ц��!J����M� ��Qg��9�:�7�튜�P��|���H�)J��H�wKv����1!����E�� �f�Q?�"�_���.~ 6:���I!�c��b���+��ߘ�T��N�hр���3��$�~M+&�K�D��;��Y��ƑA��z�]��<��Tڲ�2f��
K���lߌ�(��z��SJ F�����2zX���.��I�WY�PN�&R2t0���b�����!Ǉ@E�;d�
*�������A���B�@unTM����Mg7�z�t�N��t^��qdA��`���au)u&8NK<�X7��+�f"{���H�N��ѡ�%��yu��Y��V�=�'���y��.6���Q��WcKi�o<CҠ)��N?�e�m'��P�Ȓ%��|V����x:U��t[�m�D�	S�3�e��Ox�����M�58�V�!��۔Ώ�i6.;06ո����hD��(��
ٌ�iJe�@e�ЈG�Vi����+Hu�����
����u���XAk��`��y��Uo�}W��$M1�1�tL��o���?���U�=�A�C��/�|�#�>�ȟ%&׎5lR���*���di��̅ڢ�� �Nk0����x�ƿS)���E�߬�]:��|y���=U�O3�����U�j����P>3�H[/��b��/
�e���o�!�V�G�2�����Q�t��:�
FxH\l�C-K���r��q�.��!��
86. ��0p��=�?H[���iT��Q��X颰�pBKYޠ����J14=���)�7S���)Q�C����r��en��J�H�u�g+���lf��ՠO���B��A4�h|u���&\j�W���c��EkF4�^�G)�JG2i*g��M�gS������Pv/��D�&'��W�2�?�u�3�T� ��]�{z��q�u�J70���r��V��
�"�4�&U�e:hPG��ƃc�Sd0�AC����{�ILc��Me^S�0�>u]�j��M��6['��$����Ii�����Ih"��4a�	�d0Y.^��k����W9���V+�g���%vV_���v$B��j�9C�OP�������I ���ǰ�t�(�i*ȇ�!#D�Z6���郎z��lvGNb~}�����B���'������b������%��2��'�A7uM�`�v0��I��:E3}�����(�$a��"���(~���RM��酖mt7�]���uG� ���sk]/,TV�:�A��6�MY�E��Rh���mH�`�RZ��J��)T�7_��݌%�FV�Ġ�P���Z3Et�M+�W�Y\��.�w��R���l_��b�aZr4�X���"�h ���7�Wb�N($<R\Dbx"ryo��/5qB}6@J�F�`�eh�%�ҳ��0ԅU*�.��<�����+~��ŵrBke�D��Axt�^�!:l�{ħ�jn��cq��#ۀZ�v��b=G0Ά��|$�Mb�=M���52Վ�S¦bX���[H�6��	o%8-XN�^E����N�u��ZbDh*����=�����xV�/lp@.Z��7?Q�Ĩ�{�|X�?Џ�/�Re��Gb NH����6:��=��y�;��{��sy70,����sn��g}ڽ�Q���n�pr��>R�w��v�M��p8�����P�O�;���ǋ�.,�%m��&�i�{@��%����el�=p��S�-tb�� $CKUQ!#���&���9�V��I���7�r6>���`B�v0�,*����ˆ]$��8��������8����C�s�}�/de7�.�%��W�޸���x(�J��7��������n�D���@h5���&ZF34Ē�p�}ʸzgCQ}��XA�K�����s��W���R�T�6��f�)B5�2�����iy�p6��7��o���s��Qq���IQ��Z^�����M�]-c�(���rw��˜$��a����B�q�y�u�	��?.��K�)�''M�ASS.�0�ϸT�
NI�`�MҖ��~Y�A�M��A�}�6��bB1h�353��d ���������O�\\q�r��	e�(.YO�Y�U�tQ����C2���n��w��9� LM�!<��l�0B���a��~X4�5˙��6�Lh`@�`� (wΎh�V�u���m��+��PԼ��i�=��)k�.��cJR���)s�Ά�<+w�\�
R�}]�~��}��@�3���� �^T+      �     x���;n�1���)�,��1R����R�L!�7| ��!����A@�N������u�hEz�:�>_hx�}��D�VIq�\�;i.2țAJ��<@Q��8��݆^S��'���ԡ͵,��QI�R���CeȪ�BO���^�ٽ�8p_{������C)N�[�z�q��B���Ȏ�=A�޷s���a�%�4P
ZR�רkH_+U��G��ݢ�����DY3��.��6�^â֒1e��6�9�[Kp۫� �%@��u����Ǵ�o;nQ]�XF��N��ꃑd@`��p)�w p�㲐&�I3B;ކxu��L��`8/��O-�eǻ LU�z�%��G}���m�2��T�C<2RjM)uǽ:8T����8i���09|���;�z����̈�$�Wa��:�Ic�PO��7Ve4��7L\u���e�L<"o�8�]y�m���Dw���5�!.Ւ�C׈�0�\)�m٨-�����&�MZ���gT|�%�Զ�Me06�e׻�e�[(�yW.���`o�q>_�5��p��)0p�ݍ��c��4ٳ���&�y�|C&2�<��S�/7Ic�%0}l��0�y1e�\,�y���x�d�����K�_�s򲇉�o��C��8Ζ�ؿ�ާE�6�۠�l�-W4_�tE�]��vE��o���pA_y�Wz㕗x��RO�'.�����?ٙ�t��=�'G���~��L=�w�ҝ�t�*ݹ��V�#&�!���^�����_e�*�      �      x��|]S�ض������}������؀0��'Ԯ������ �����wL�2�-��S�����^Cs�1�>��)�������`4���n�o�&���O�ӫ�k�?������_�y�OG��������u\3���g�������^^�-~f����.ߗ���u������q���B;���7�'�e�Z��f�e�1�z{~|~[����_��}}����1��|y�#��6=���׬���}�|��	��E?OG�؊��en��4'��������4�>�����}�bzɔ�F:�3a�uR�e���%�l(x��)Q2�Ka�b�t�*BT���'���1UƦ|~���l>����S>����dz�u(]�ϙ�l��1LK�y\����}\���N7p����N)f��^_ӟC����z,P�D���J�M��m���'��ѽHq��V3n4S��#��| b���aLk��]�XuY�
�j�"�:YV*@i���R�aU����旳�xp�_�'�����l��h>��|n�Q�����H�ם�5����5�����m�v���6{���R~��o/��o�J���|�E�8��'��-[�М k���^ ���?���L#�<���&���I��ߋ�ϓ�hc'�oGFs{ѷ��+��_����ϗE��u���%��Y�c�L���_.�cJ:#��"���gxZ���2F�I�!�܋�q�؆�#�C%���~I����Or=�����E�(�[��0�/?�ʈ����rF��U�ᐍq�?��Xv;����r���Mvv	�f�u>@|�q��ܞ2��y�Ó�z���^�?���<���M>��ގ�H�c�۬���Kx��;��q�
�[�n(X?�j((Nv/���SV0��q/���Q�d6�?�痃O��L�|~��Ɵז8�_k��OoG\+�C-������A�^�?|�3�z��Z�$�X�IZ�w.�鏕�{]��·�����,-�,���3���-���	>���s�빆�-���GqŸt+�w:��;�����o{A�Fi��������-�0���{���O�c���^���)4����~el�ܨ�'��m�c{Sv�);�|(��@���zm��2�ҁ��i%5���*��JY����*$�9��y�B�W��Jk����ċ
!]�K�Z���*���C�c���<��_a���~C%���[����+[��}� ��@�}��!���G��x��yqj�\$�yh�D$&��A��ʶ��J��*VX��	�䠄��	�D9ϊB�AQ���)�(J*�Ml�eV�dt?�����xv;��������|�V���*G.;�k����b78`�K�9��0�z���X�a�'�!¹�̎�!�q�����ď�(	/���GY��\�R�R�T�"p�B���~��e]�ڴH���H>���v:���t6�]e�r{����:�Eð��v���%�ø��2^����:��0�R�f?_����m���ŏDg�5 V������ �������˔��"�g�	�Q�!�$�,jI�2(&��eYZc�B���@�pa��r:��T	�!d��X'`��d�_�n�����x���P~6;���]�t�qX�v���UY���o �����hg�d2{�����1������$c҂�vz;�mz�DB�k }�� �q-�A��Ҙ́(2*a�Pl�>j���!@���*�D�1)��T�sQ��E�ѐ��-�lv�_�3��"��+��ʳ��O�A89�t��\�9]�AǡY��c~�K���^���P\���M�02c���[�Ͽ޾�㈊��>���T����U���Շ�S�TM���d��ұ�b �������[�B�`������*�s~)�F�0X=O/.���}��Gl>Ń�����<?=�U���:�}�MR���ìWZ'zMR����8'ᡭ�$a��u�\����~�U;i�M�Є��ۑ�;����y��\���9M�b �:/��Х�1�2p���LT�(+-8Ç�<"��}��mm���0��4��l���y~}�Q�(��Q�#]7�i��W���F��]a�)�Aϳ������6��ё�V�zȻ�/��L�$0��ćQ����[�2#�t�i� ��
&�9|�)�%�Q)Т��c�w౥��$�Ke�. M|�r���̧w�|f�y>�x>�މ�=��~������*��؞�����x]� ��;����6=D
��O����ڴ<���dx����9L��U>�̀|�ը�H���O!�UOH3`O\�������l�r�X�������F�p�-��d>������⢪�Kw�mN�&[��#����Ʉ;:,��K����Cr���cE��ⰊP�0&�U��'�$c�Ԫ�PU�l�$ ل�)��XՂ��e�Y~�N�t�ǣ�9\���w�JX�$������[���dR�QI����熁\��,(K����-����;h�ۭ��:<�����ПP�7acBQ�ENT�,���O��IszY)D#�:��C`ByHu݊F�H�h<���Ƀy~ys��^��n�O'w9	����9��A}yx!���^B<|�q��_����F�?�%�xxZ�����o�%�-�
Gx4]'O�	.!xG��Tr�FK94�0��F��2��&'d�Ƴ`*�����#�&#���X�ܔea\���hY���L)bQ��D������t2Ϳ���,��>�ף�����CY>;�͝�z?�p ���iH�r�%��y����H�7jמ\[G1*VCe}��[z���E��<a��c�9�M���t��A� D���[�Iͼ��v3����jSx��ҙ�S�R<T	��`Se����X��&+�h�OՁ����'-��y0�/�g^K=�AЀ�:�Tg�k��g��5�{�NzU�] �d�0������C��x�"��C �����l�o	��1ջ��y��V�NR�P6�7�"����z�	kBis���`!z���s#M��>W{�'�W��P@��ձ���$j��n2���`��nc��d�GM%�l���-�f��
�ne��}_�?\�\Fq������樽m���Oxٯ/�yY���<��
��ٗ�J��v���0C&�w/�#�*�痓�)dqSU�~��v�k <�"�����VԜ/>�Y���{��kCNh8x�=�~�K����5�U��|��oWk8Uk����8�zꏤԒH�!��V�(����o��΁<�t~�Az2�x?�h/\'����A��a���(*�OSQ��~ÍE{�v�K���.H�7;ĶuА݄�X���Yd��֭��S6�����d�T ���IZ���_�t�D3�PJ浓��g�#�-����kߔ�nS����l���zB��Z��o��R� J�_��{]�r|�u�X֖ם<f��<�����r�^���q���a�N,��cG�IK��(j�`N+���@B��P���UJxS'xU� ��(�Z`_E�p��'.L����
ĸ�4���&j�g�7��lZ���FV��=
�����n<��\O�ƣ/ң�k��ه��}2!W��e����j�xKqp���0�W�z��}��멵�e�
�xp��Oo5������)�X|?nKF��4�%�­�%�<ќ���g����~�>�pE��x�@B�,�(lɄ/iM�)��A���}e|�邮�<|��e�"�x�$�wys�g��`>��0�O�=)�n/��m��kE4q_OJ����i�YO;����p�2+~�����-p��M8�U�|W��n�$�s͇F�#�((�eL�RB��W� ����2J?hQ��<+�8[��2��tЕ�e)[x�l~J��F�7"oux2�����W��tt?�#�~zs�f���Z����[/�����i��w�%ە���	�]������k{�n�SCk:�ڭ�KScw�5Er��26� ��et9�ň̓殪XY��C�P�v����\TR�qG�S	�    |�)
(ᖟe�<+�~��M(�r�%_6;�;����-HG_��;�
�����Y�?�>��e�Zw���L�(�i��$�鞇���_��v8:J�S�pQRo7�(�Nȡ:�Ƿ�*�,Yf�%��V�%S�����A�:�P�T��d ����*'Z������,��Q�m2��w�����g\F��3��@P�ۊ���Fk�	ؕ�YI���-˞�Ɨ��X|	Oo����)��K�j<��Xg��Vo�DY*�ќB�H�J�Y����U�5����q؝�PB�ʤ�K[jH����-�U�	�+˔dj�Y��(��ZwaN��4�V��W㳻��,���L�>���&7������&b�|(}�d�==+�%�Z/#���ح��
�1���5<���~@q�@��8*�bR�VM�p�!5��Ԃ
R����0O/,�4���cQ[�ԫ�X�RWJ�H0I�2����DhA��iW�X&��L%�#�>Ţ�:�Vp��i�=Y%��7D����D\o�NWR�}�Y� ����i�^&�f��;���.��Zz����X�iEɆ8�
����I+Zq�R$9x	�_Ʃ�wj(*��*���&��2D� �tQ�NEu`f�Z�B䢪RUPj�tB[WY�nSP����ݷ{$��ί���Z�k7��߯9�w�g���� ��a��^������^p���Wvܬ���>7��
���f�
^��=�tDY+jc�W�Q������d�JhE*�����&X�/l�U����<�f4�I;�Z�T�l>]NV��u�XM@7K~�^��~9�K�U_�4���:�����n�zڃ�B�*�:j �s��"~[ԝ�Dx�׆ �
с���x�9�zh��!-���8W�&���&�<�V�BS�h!�x�X�*CX��&$V��,��CA

jFO��JhC��@Ewj;�(�6���6�!9%-�$�����4,��r�T�59�)�#@���Ǻ������k��D8JN�J��N�*z1�C����|9K�]QU�z�YY�]b
.W�"2�O˙�I.��+Y�@���dU���\5ja'��'8�K���{��|��|���^mo~egW��|�W\�a�LO�Y�W;�"����r˧�p\�R���S�)�wy* �|��qוw�<0�N��.�����RU!E��6�JK��U�:!VBAm_�X��J����~-*VI�Ou��6��=?����g�����{�Ú�{{r�k(��������h�6��ٱL�O�V��N�K�$7�����T�8��g6[)T�E(T�a�E�,x%B������q�Ɋ���U`�.�	���e���������ӳ�\�Z�S��[���l[��>��QZ��'�N$3����X,��g�=��
M��w.Զ��u�.��<�?a�V'�l���-qM
�547�7UaSH��M(n5U�
�W U���P���ʶ�WY~18�g׃�o���k��y���y�����h=�~�n�Y;\���AkHa6��AZ:fO�������Uxy������@���hTһ�C�������y
�sf�xJ��%DE�L���!p�F�S�F����0AY�4�HjaT,����4���u>�y����E�GO�.��Ii��Wo
���!�@%B�\/�������d�KY������´��1h2/��6&��C�>b*���QA���_��B�2]�E1R�&m��e	��Lm��p���&��̥��ӛ�O���o��v����P��E��}*}�D�Ϋ��f�ga�f#݃��Q4������>��h)�h�W��]R`�*��T�Jy3�4� �m�ˠe�`ʤ��;o8U�"V�Ѫ���p��� ���i�(��P��5m|�Goo�>�����뾴���A���ٜ�_j�נف�.g���~��N���,�m�Mp{}�y�u�V�-�se�e~~e��4���%��.k6Ri�Ϋ*�󓾔S,�}' pb1�(�Ԥ�K�
#C��4|56Y��^�&w�ˮC��1�5�'����r�n�]��&}h�B	�Ⱥ;(Hz�.i���
�|��e��o��?A?-G;Hё�6|,-���o®4�'�lJQ�R���TZ���c���L����	 J�����B����R�?j�]�\���M��b�M<&�`S��|�=e�r��N{8����K���� �e�h�j����Rړg��=�d�O��o�?~��x,��� ���j�vfSQG� �燅�X��Zސ�цd�2®"��% ��cp�QSÓ�w��o��]8S=�k��X]��O�Q�Ak�x=�|�˄�H68:��g�>�_y�khe�%u��N<	 ��~Ex[v0���������c
ݰ-��̳��Yͦ��_ͣ���T%��2%̊[h��i�BSm/�L�~4�2ɂ�&z �c�e&��MN��ySG��w�_�xI~::���`-�_�u�ao�z-�p�k�XO�8[�s�Ď@��$5}[���o�<-o `���ɎL��.��=O�Ah��Z��`xj�Z�
��*��F\���p��R^K.�e{|��5��{�n�q
>����s����ݝ֜�ͅ���l�w��?�Q2+O��}s6]��RY*ߕ븅�NRy��p�U��;���@J�(u��dǒ�e*� �U������n�gZ��y>��8W�&gv�Q	B̻�q�׸K7�1�&��żf�C1�*LjE���^�P�K�V��X+�o� �P�����N�Գ����"^��ԡέ����#U	�X�U�8�!�G����GU �U1Q�
�!������rΈ���e�{O�]>�'���I���k�%�'_no9$b���҆nG��f	�;ƺ\F�"�b���@2 ��~�U�״(��u�e�zv���PtE�M'(�f����N*-h0^g��h�AP�U٬��+��ʕ��CxG�\�R�C
�Ed���UE�KV�z��n����4T�����u�<���o��3�ww};W�٫��O���[?o���n�����ٮ:��4�2M7}h��ɣ������g����P��3�L�w���ˏf��7�N,�[��h��i�i8a��X����L.�h43��V���R��B)j�bhl���/[uv# �~u�!	�Ե�&��&�O��G�[6���b�kx�[����J�L���Kx��h��Q���{C��J�:��,�B� _����gX��5kreM�,T�D�.�60Ob�U�h��v3S��
�LK��Pܕ2��A4�X����|�ȅ��y������z��u�n\�Lm�������^�w.ٙ%�㢡������-���"����>�,hp���H���L�Є��Φ���W4stOF�q��aR+e��f����I�29�hT1���3�e�x^:+�LS9#`q����I&��g�\��V�Js������R���c��
o����>���.� �W�ԋ���	b �V�����B���<i�o�h��,���e4�����&4퀦)٭+A�«D�wBX��U��-I�N�.�/���B�)*#���.��0���5������u]��=��#p%�?�%v�����N8\/ї�l�q�	��Q�wS1��2w�H��Z�cbm���9LZ���k��P~s��9��~�����i�6K_�o4o��Ԏ{�g�}O�\\�6C$M���T�_w�r�J@��1M��W>!��&1��+Gs�^r�/9H���@d���:Ve���2h���ݸ,�}yz�|�_�_3����^���I�,��k�lְb�<�>��.��"��0#�F~�Z}�Wu�ú��]q��M"n�H{��4�Ƶ��4Ѐ���r��46{U��M�[�la��RE�"+�<TL�'+�
��T;����Z�z!X��E;nWI�������V7L�����|N��{=u�s�;{����UWk@�4YBYt������V�o�z;�/��Y�no���fU��
�fr�pmW����pR���[����^�Z��[(R�P�)e%K�k�7� �   ��UQak=�X�&%l}��/7�ψ��3ʰ}�\ݍ���˳[��+T$�W���zRi��Y�V/����:��거]�M����������q��>?��O)��6|��~�H]���Z^߷W��]J�!��������<���X�ಸF��Օ)���V*V�
�"���xE4��������^r�      �   �  x��Y�r��}�|E?M�ԑ����2 QB$�)�(Ǟ��#R��ߟ�-�D���T��R�����ڭO�#����P�Q�>n�(����sKE	E�,����J/W:�ǟ��$	)�4ΘȘ�D�"3NЧb\���'�A�l�u�>�xۣXń�H�/�m��5��u�<~{޶m���·v��Y��m���������b� CFU�b� ��M���#T\±�ᇶxj��ôy�n_^��W�>4���=���F�7�"�g��ЫMu�к�����ו���j<������b�q|�c�V/���B�KW��f�;�
.�v/M�u�Ǖ��C�~���ۦ�q�ao���S�	�I��7�n��m�������H/��$������^�/~�qU�1>��z�g���(a�s�g�D�{�\o�4�b�����G��O��	׮�X�I1��v��Ig����ַ�r8��e]�!K�
�j
�Z �DU��ػ���u��(�X)�\�x[��t�x���S=���5�0�q�U$�f��o����	�a�4�6���w����U�M�'�Ϻ
��� ��|=�A���s��$�"J��y��\��g0`t� )����b���2 �ηhb{s���]A���1^M�j�W��
.��m	�S���P�~�bnb%Yƒ(M3�!��Č�d�E�C�	�I%?���m�`�⸄�.t�o��,�bSƛ�G��q�x�Ϟ���CX��@K�A`>ӵ��y#9��r����Ǫ,j\~�}��/����=����F�TW�Ӳ^B.����U�����D	{[K3�Fd���_!)bn{+඼cV(�U����6k��!M�uw�C{�oou�q��4J� �^pX��@����e���.��(����Գh<��B�v���_�Ƌz�ڷ�ߠ5̀�h I\��j>���y3�ob(A�Mpx��P�ϥ$$F�|�Cq�<���������44c�%Q�{��siyf�YY�g�j�fy,����*�n�{����9�6�<��,�� 
��8�]�m����-��u��X���j�;5�lC�_$i:`Zx�%��Aw����M�6�g����/ۗ�W(/���ow��<��B��oz�?��w��'��?�/�`K�/-t!敘E�៌� R�!U�2w���
�"�m�j�S���pp�]2c4#	P� �r�^y�8sE�L�0C1d>��	*d<��Fz ��u^=�@����O�08(�8"g��`$�;|sĶ�L7�MF8Z�V��H�14�|���@_Ʒ�,�ی�v
����y �Y���<�|�'���R_I�d(`)�qq����H�!�P^�<�|"	D�����Ng_���M�.���@�CA�xH��U����F/ln�����Z���T$׀.�8�`$�t����Ua��br��Ў��٤��TЀ֓�Y��߀b���'��%t�tc��I�C�zܾ>7}w���!ua�`d u�Ǹ�#�\Q1"9���_�f}t��]I&l��d���p�@<�
B�&c#.��;+׫�Q��ѷ]eo͏�	�΁`��)6�&�@����B¡�9�=��87�e
ylj�ML���|��h�)1SQ��������D���餸�!�:���F3έF��h2zx�g"��E���VwQ�16����	qUI����1h؋�� ¤a
���ȣ8�"q�)�{�[��g�$�r֠G<�jP�st�Β(vס�	���I�����1M:�"�C.���"�M��;� JHz�>z=+�GM��m�Z5��>��&k�%C>��H�Dre�&'/�4�H�y�w��v���°���d�Dzç|Ѩ���y1�TF��<1E˩$�qa��@�S�Ť?eK$�Ց��)>6<
r!�C�٘D4u9�L��]n{?���u*|(	9:+P*S��S����N�?����0дҟߌ���Z�yu��t�O;[��l�3�N��	�ۉTH���D�T�s��8 ug��ꭥf�����9%1�!m`4J�F#��N��|g��+J��%I��ea"��0�@H��@���,7��T87��9��3e����#���4�K�x�
g��1�����3S��J/k|$�z?�&�A� T�uG����[C��ڿu�);����s��0��b�*C����n&�O9�A�c���0����l�|��xc���/
����AOAlE�Ф�9�
D}��)-��!O9̦���r�z�?0���w����?��5�'�����}=4�#��m{xn:5���n�i^̉��hk�?<������FSIu��dK�\��;���_v�6�)=�Q�U��H����m[�� ��/�F8p$��p�����bH&�)F����i�\-&�C.A��IF�2�Db^��[��`�0��+��HLmQ�L���i�3q�ő���U��9�@�S��L���4K���ot���m#J �y�?7߻�]Ĩ�b����W���|����{�d�j��~�?^�f:-:�ʸ=V�R1C�P��u"��W��|�&�ө@G��N�\3��Q�\��ʁ@�|a���	��$OV�1Ø;�B�]Hi��� �*����z�3d�gt����hT/�?�cV9�XeC���RH9L���fC*%9�CțD8n9�7�&��>�}n(�I~N���N�!��\2$���CT����Shzi�
um~0����a���+$k�b�>9�մߚ�Gf�5N����y�ҁ6���P
$_��#b𑘏�DR,�q���<�b��M+f<�� �H/�4��J7��Y��,�N
�vq;����9�R#�&�r΃co>��⮴�4�(���=�C���+�J�W�G� �B��SM̱?I"�����Q�I�����pA�К7��E2^m�f'*�5۶��As�Q�C*�x)IlU1o��ܢ��^�H�wf�-�)�h����@�3�3����I�������U>����O�L�e��hQ1�ּI?&H����$��'	�M+p��[��ղ�gPO{\��'�T+Т��`<��^�Z�!��o_������>�uъ0
����|x�>|��??B�T      �   �  x���Oo#7��ɧ𽈖��ϭݢ@/m�.��^�t�1����ۢ����vki��V6@N��H�=Rs{���;}�aZ��w�E��+M+�E刿!7������+}y{I�P��<	pʸT�Rk/��4m�>o���q����v|��ځ���U$ېnv����9΋�9��`��"嬮b�a,�©� �˚�a4S�~��X���apQn]Y[�&��Y���J�����"�U�m�g?|n�9�j���bA��Ύ�*;�fn�&E�K��4\�>����4N����|?���a>np�{7��!�|����!��h1d;�!;K	W����I�����w�t6��<��/O����  ���묺d�妆p�;�x���x�V�`�Sٷ�濨�g@��؜�CWNd��٠�������!���<Y�1�m @>�g�Xs7��=u�� )c��ʺ�n�͒u��y@�W��q��=$`݅`d����BCX��|F����~^��=��4��l)�ۙ��p�B���d*w���|�RD�,-���ʝ,p�B�jh��@5�n��=�����<X���rC����֜� ��%��O�6�i�W�1������'���$��I<,��ct��!,�����y�#e�!Ao�F&/QyJG��ʛ��oKa�i���V��:�7��.*�u�H�� 0���>V췅�.ۤF���H^�}`�`��EWT���J��:�Hώ�b1�0��GYRc'	L��g�4��⨁a:�p>=0�
!d���Q� fP��R���rk�:�Q,I����ɝm��ч���<ʑ��!�y����*�v`���G�'������\X]`�;�Yy t�:�������-O���8�?1���gdeE�����y!���GM Y�J�H5�������<�YZ��%�ˢf�x�Jf~.3�b8I�"t�+���θ|ݔ�r^�f@�jI?oI����[|={���g�ս��L�<Ye!!t7�N�\'�2�e @%��$]Q�B���a�`�L��oH�4,F8Ii�Qjp��Ǉ��z��a������qz=���M8?O�֏��7a}I�z|�o�6���_��[p��� <}zA������KiiH��@�U�k����Wuyy��h
      �   �  x��V]o�:}v� �l'�G�t�G	(4+��/nIo!�@T���;NB�һW��G0�3s�kSl���n�H�F���N&�:��� �B*�~��Y�p�gz�����χWD��=��>��C��5A��l�D����k",�JU��GW|}��:��&S��z�8��d����w��k��z��]�	b��}|]�_�	1u��DXM҇���4!�p����tc��@��5�i<�I}e��ީ���ؙ���ΔM.�k1G�����C�)xevk�*��%�,P�pBB���D޲� 
DĔG�Dz���7��Mq2x����2�����&fg�J{��c��H��";T���������@�_�B����f�ex�J�s<�D)j�.ު���bSO�5[����0+s���7��~B�D��p��w�4P-�.�Ҽ������=N�A��0�܆�؟�-�y��lJ����}� B\҅#EK7�O���ݵ��wc��t�g���E�
Z։�̟��aH�)�� 8��L2�ēa�2=��9���ye?��������:g��#o�io���ˋ}� I�5�}��,Iȑb�Pzʾpӈ��'��-��~�*���������/@�J���-����08Ǯ6�-�9�Kƥ����;\���,�3��f�͠=mm��W��F�PP'h�O��K�!�/���Ҝ�CV����cP�
���{�yV�N����4Pπ���ϤRRRv�G#�{>�����q���~��'���>]쌯�e�� ���W%L�(7y���z� �����x2'(�<7 RY����<���	�b�2�B�^M�����)������ܤ�+��LǠ�P���$���h⇳�=(:���9��;�O����h!ٞ�����=@g8-^�}q�sgx��xul�9�q��@K9A>+ %!exỊ�{Jo�xrÊ��(�y�����G̏h�q��IaF��f6�0��K�y���k$Lef�폵�=�mc�@�R��sq�=
�����ۍ)���6��_@��>u{2@���v�Y�u�7��������;�,7�z��RK�w�S�c.���	/$g'Z�����B
��נӸ�?@��T�P�I�;Ve����k�1+
�^W����R��(w�[��j�a�&.m�Z�BW�F����~2Ev|7��a��
�AG��_��:?֭�����Ϳ��-      �   z  x��Y�n7��~�}������j�~�%�n� 
�R�[���? o�!w��h���k����9s��ɼ�r��͔?R2�]L��}]ޮ��y5r�a<Qɑđ�9�BR�Jx	�e@h5��V#��<-�#dϓ�F�K���o>�����O�����77w�w��z��	����u��e�{��>\~��w#�
��^�q䜿
�mߌ@�����Y��uJm7�1�r��"�g쇧/_�/�l<��?�f�ة����|����?�^(�,����˛�v=ZX?�n?��|�c��)
^�R���X 	4h�I5ޑ7CJ
d�2(������'�o��*��^>lv��Ύ��� z�J�]C�^��쬾E���������wB̤m���V5����i^{���5�֢��?@ c8����Nԩ��gcQ���l��Em�#��"�d:� d�T�ՠ��m>�ͭ���˧����䊷2����G�='���\I޵�FXc!shbЯ�
$�������V��8�3�}��]��Q�p�tI`%�>p�Ba�\Ű��k�#�ό�|C� ��H�#��A�r�xT&D�J���Y���@�;m'c���o���r��^�M��5�V���F.�[6-�4�6����ǵ!{V6�@L��T�v=������� ��-f��?s41�>f�Y�j�ƵJ�-8/���c�^ԩG��&l���-<*�A�hV�����ȿ�Е��[�O�i3wܔꆆ�3VJvI��9	�	q�z��ب��Jz<��L�8lӽ!�KR�֐�ǓKn�)�]X(-PrY�3+e�CCl���D%���=�6I�.�ho4u�8�D\=`�<��n��:������$�y8�}�'e��L6���rD0�9�!'U��ǎ�7��t'y������@6đ�����jU?84/_�]�W���>=�����!r�W$� Ʈ����֐+,�*4w����������A0�cDgj�e�ۃ9{�>��-���ٯ������/g������j6�8I���o��%n;uA3�mQ'_�<��* *�yo�y�;�J��t6�1�L����d���䜴>�X�*܁R�+U��zMp+�8��6�M+��7ܫ�������c��:��aOz�8uJ]�|c�����Zڐ������#G����S�,�A�a��{��s�ټ�������k!Dz��3|[��j%��a�I�����_�r`/�BqG��YP��p�pH=7w7wQ1C3��م�1�ZXp@��\Շ1����Ƈ���I���v`��۳�+�����(�����FX����6y�r��L�H�LH!L;�Tև;+�I��.-9�B��{���_���e�M�o	 (:��Y�?��TDF��U�čl��Żg%��\C�|5�x�ی�v�}5@Vka�v�rK������XlL.���s�e�v(t'�x��e�}73A;�>;מP1A]�rb���;@�p'��,�"�p���=�W'����"�H�������	 �ygȱ.��'��?�at�Qt�H�ݧ�7��H���:h�Vr[4I�~+#\�\]]��h9��Pۦ�|\�\�}�	˧���l���i���&�&�/m˅@^��z�
v����n����$����ǟ~�\^G�K�.esnȇ.�KD�cl��?58:�Nn-�Mvpe�M�%���QJJ78�.g�A�������҅#9b�jy��Zh�T<���mǜ���<��n�ߖ����e����v�ވH_b�.}&���&�~i�����Y4�P���j
�4Ν"8�%d�A���5��Kn0j������:��H�X˂�8�ۜ54Ή��'��l�sz(�Vs\V��X������~�ϧ&�6c�뺌�XU�t̝;F7�ɂ�By���ؽ!�)O���I+ij�%���d[��0B���Vh�Y�@e����e��k�MeA���Kq�աi��w�������I���:w�-O�]��5��tT���'A\�q3]�j�"<����>׻^���-Nr��`QH\�j�H��g�(Ҏ���N��K�kuvi��F�4�?����ח��ph��Y>o^?����b#�=�+�_P�.��b������f� �      �   �  x���Mo�0���q#����ˊ�`X{��Ê�ȚF���i]��c�GC�c�"E֕8έ��z�nu�������%G������0WpJ���ѲL+���۟�HҾ���LR�J)L��~��d�#-�^���۫���dWARC���PWC�J.�`��|�����>��I���L� z+f�1��,��$�T��|Z�����.��@���c�4_T��t������i\�no�|=x����zu�H�CO�@]����"����<iqp&��9xS�)�t�[2�ս�R�̲~�fb���9y[\b0����H1<�wu�C��+~b���(�i�6�80S��hF{����`�F���s�{����)�땁;4��/øO�2ٚ�)9�̲�~��u֦��6e*�����?�exfM��~�4gzk
��B�~��3���;0�:�5M]��d���_4M�uN��      �   U   x�+H�K��K�O,�O�����*\|�
rI�y�ȲN@>WAbf
gpirrjqqZiNN�BAbenj^�BI��KjbNjW� I�#=      �   j   x�U�1�P�9>L���ܥsU�?��b|r,+4���]�G�ü�ՙ�c�E#�l\� )%薭��|i�h�GS��U���fk>�&�ϋ�~ ��:E�      �   (  x����N1��g��/���/C�(�-!U�&4�D	y��z����R�\���?c�o�
��q����9�Z
���E������㦾~YԌ1qr��9!����i�K@Lv���,	H<�iT�|y��2m$�I��/1X�� ��"�|Ju:�h�%�Ғ4+��MUEx  �gSv��ͥ,�t��MRv5g�X�Ad�T��T��0=���q�>���xfA�6qz����zGllIxX-���ݗ��=o�|�Z�wE^�x_�J��&��F�/�"��)b=���T�H	��,!��;�HX�Y�J���tV��?�v��A㨼�R���	U��Ҟ��H� 3J(.����x�ݘ��[Р�bD���~�d�J��H&�L�<<%�(m�����j�]�VO�׎�c���3����rYX}�7�#���C*s'R[��, t�kߚ�3Ω�$��|��t��}3��C��a�`
6����܊�Y�����&	"y��a�.�}\<8��t3F"V�����"�gySX���̎-�1y<�FÏ�ۮ�q�cۥFk��\��f:þ�q����q�r]�X�m\�&�8z�\*���C�w���z�Z֎K:��-��F��lhz;5���cO�O��|���=��<� �d7�T��T2�����Ψs�(�Ry#P����;u�XÁ���QP���Q�=�}z� �����DQ��7wƚ(��������������J֧{�3*���ƪ�P�>�����u�S��X8莓���9�M�5�%:W$^��ZU�?��      �   ^   x�e���0�x�p���S2���с���^��D'�yu�ِ�/�9�w!��T�@�`��,��Q��QA�s鞩��<~��T�{3��}@-      �     x�5QKn� \�Syߥ"'���R��:i�1�3�`,XB/j��Ⱦr�ד0r\#�8����K#���u1�H扩O�1�y����uE[,Uy��>ΒY���A��;��@�i%�8��	q�U�F�馽��!E����)x�wd1��S�<��sed���F69Y�~!�^��uS�F޴� g�r��Ȫ�¯^�0�:���k(7(���e�ҵ�����ݱ�^F�S�%,�!�D�HZH�ƫ��kE�o�M��N�A���?����~ ��a�      �   =   x�3202�52�t��540�)JL.�/��U���M���K)JT��W014Up������ h]      �      x��}[wW��s���'/��ت�[��H,I�{ּT�Q7�<B����S%������D��v�#"#v\��sڽi��ݛL�����z������������I7�5??�=��ɴ������q�n�m�p�i� h	�z¶Ւ�mN`��-���t�������mS�o-c.���}1]�uL�>�	}{F.��v��������|QKV�|K�~�]�uR�-�A[�`�8���B=3��Ӗuݠ%|Q�u�6�e=3p(j�A[䦡o��������f�KЖ�ڠ��j�A��K�[YSZ3<΄�j���%L씹9[lh�]__�/on�v�4�|�襜������R�4�5�Ɠ�/亭O綽�|������o���_��R���%�j��?i�Pl}8�J5͖��W�Ŷ��>�leӓ�J�	m���ĳ�`����}�Vx��i�y^�-�y��Wz/���5*��>����'t�_��:�;�N[�c�����߄u]_�VXs�iq}�5�����7am@�e0��LZ�}��&v�r����������d��^sp�!��2���K:�I8)�밊�,q�s\�&�qzܱ=�n֠຤-�+�a�u Hqz�V`Xh]R�a�tI	�p�MױD�*	��%���P �*�@�e�D
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
���������>0�Z      �      x��}[s#Ǒ�s�W��C�u���.� ��� G�P�/��]kF1�N���ɬ�+ Rz�V�3V�3d2���e�|�=K�n�n�t[싲J�iB)aL�?j�h��HIb-׊KL⦳�������<}�9�N�2�)�����|�=M�eV�r�����M�]̳�ۤe���tQ��vw(*�&2P��*���̓jU.�;싴Z�w�l�T�,���w'�
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
FJ�"ͳ|~��GqT��h������h�t|��G}��G�����x�(���'j'���oO.^�&^�?�=����!�����ۿ�����l�����2&D^�5�������������l�Nu�/(k���3�����[������o/Oo�}��4�ӟ���_��P      �   �  x��X]S�H}�"?@S��t��F"� �;[��
B+���_���@b@df��5͹���snK����*����=\��Z��HrD\�"��k�]nc�S�� �-�{Bk����+�,�,�+���F�E�:�����W�`@�5��ޕx_���{��0���K�#n}�gOK���E���1쏦�;F�M�`�2�v�:���i2ϳkW����>��9��t�!�M����x��s�������A2��}H�2�8v��ָ�!�<�!�
UWEP�*����U�j�uo��)w���L�GU;��{���KݪhP����i�J�2��ݙ�]�CE���!�Q��/��{ �C}B}�����<���9t��[�z0hG�JV�:6��7�,�k[es}ew��R��u^ٷ@F���*zuMP�7��IqHoQl��8A؛�'Q��m�����z(��I�0)�<�\&�"VWݫ�c�7�9�s��7N�QΣc?����s�l�֛4�_�Ж\XRV7�nO,|���#=U[ϖ�BbўW'®�e�m����ns�>��O���o��,P�^���q�����n�k�f��+����ezen#tH�v��O�Cj�=�/S�n`?� ����7@����q�С�Q��ԺSw�,E�<�鬠�~-d�s�xMϣ�=#��}���Ƌ��P) j��ֹJց����e�B�)��ĖS*X����;��}=O�-4/�on����`��<�����Z��j�s�# l	L�!��)?�#�#ס��i�����\�}r�C&�x}��@���HM�R�N��mk �ǲ�҅~��z{�́�w���q�L;��b5�NjƵՃ�9��&�z���������C�����r5�'Ѓ�:ͮ�LC30��1֮(�©�eu��?�h#�����PS�Isku�q�W�E��ză�R��
�c����ƭ�`z�Uau2n�=m[.� �z>{_��'��Gu���&zE�N�MT�Fu}�T�Ί)cvT�&*E�x�j��r�Ėmli���{SH�wzD<k�������Ecΰ��-�C�<~��fTm��R=���=���<֮��s	�՘S�{/�0xq0R�����O,J]�2��Dw0��*Oo�e	�\�o�����[0���n�����Rg�|�ϴ9" ֔�-��%��X�4y=l��6m$
>�\$���Ц��DEo��X�

+��@�G�%�6Ϡr�9�����G%�|�#1jRRWH�A�}(����ڣ;��;�
�Q���O�F��b3��'D�� ��t2Q7�t"l�qO��R�b8�M���g3Qx�Ԇ��VQ�������y��`�����
e��waubF"���WΒ���>���;m��g;�ǝ���|��D>����b���ö0��F�*R�����ˈ���<��N�+��9�K�&[{hޮ��s���2�+;���q`R�g=��#|&���r�E'�7���`^�RH^�;��`��E�����2ǘo>��R��������E���j�g�=V�_���7�Wz��J������cĉ�i¼m�|؁gBcpH�Jg�iaB�Y� �MH��dJ�x]�U
��oϚ���lJ�o~�k���LYF�{l<g�u!���V]��w0��0*qQ]F�(�@�\��45�75W���t��;
�      �      x��]�n�H�}���O�0X�y�荲T��AI=��V�(�]%�������H^SLJ����ntِ��Ȉ8'"#�\��"�`��sF.����&K~K6I4�.�,Z�#I������Bh��@�$���盗��b.����J���o�/����a0H����������9��DD��r+ʈ�j��6'͇�׶��nq�L�I�,��e�XM��d�%x�	WT%�Rv0zz�1�^����iO�,����ܛ.f)c*�윩3n����8J���d����x�:�2CE��:�UX�g�)�T�LqbxȞ�Qm�'�r�a���d� *���Ra�`�r�W�_aM9�:&T+�kN�#f5�u�ܬ��h4�N`�XC���1�_W_����3W�P��+ƌ�)���"Y�J]'�ժ��`uZI�k��_bP5�&&�20T���
���&��� MW
�m�!� \Ab�c�p�W�p�d=]�Qi��i2���%����ᬂ�Y^�*��Ӟ����`Wł����vBw]Vu�BN�;�FCR�<�e^�i�z�HL�&����>N����*��|�Ίt
1E�T���K>�����`=Ư�H���4���+�#55�q:JfHNM`q+Om?�L.5C�c%T ������dj�՝.��[�1��"'I�P�r����9�x�����>Y�瑰��dπ9xe�v�?5'�JK�h-ĺ��ɶ�i�\�Y�����ЖJ�:����P��Ӻ�)�$��OE��"H;�t9N MWEr�y�� ~>	�!7��Zخd�2֧#���z�E;�&U�Cu@� �H�^�o���@k"��=�m}"�M�l2˶Eh�d�
�"'��3��9�?�бF@.=�'#ې��	�z��
��J��;���U��9���()���&���L�L֧!����v� �^O�	ȓB�r%i�����_�Wc�kb��K�֧#ۦ���Qk:wuU��H�L{�* �> �ef(\�W:��hP���9͠�sE���)� ��\)�̨J�g#۰���5߽E������NK�G����)��G�[n��zYX�$�LW} Ty&��I�m��E���f������Z�@��jY0�k@G}t��e�,���Va�Y�p#6(�`�sT�>��� TZAlz�e� e�?���ڵ�u
+R�YdFs �z��A�l�AJZT������Zd�]�B�U���,���`rB�L�;�%G�@'�u���G�0O��5���gJ��Jzk0�m��̐��S��ѳ��Gא���&-b){���W1f��k���Z3�t��1��'UyY��yQG�CiGI;�8!hH�	d�2���a����]���w<I@�Z�8�'�i��a���L�.�4>��Sf��
��v��EJ�E��P׷S�A<.�FT@�
+"��.��AJn��0z�ߖ@m3Y��$��ɤ�hʂ8-i����|��L��Ј�/j����*���Cg�!%5����S4{���D���.}�}(�Eȑ|��$Ԩ�C@�nr6'蝌p�{aS����}W��6]^M�_2��8e���K�y��A��h8t8
�ؐP�#�"��)�1���7�Ν��$�ukN��!��>>6�Y�c�E��LƓ��@�_5B������ІI�$71�(!�b���}��L�}eO
�AA�@ci d\p�0^�:�a	�h<�wvB�պ e70�>4��w�c�^��Aj����tK���/.?Z-;i�	��U��
���/�>R��4�
~���%H�_L� G���-P�tU(�?Q��{��WP*�F�@o��h����&K�+(���M���$r4�������_�A������R@
5����D@�*GB�'!�"�|��FO.�/�?*���V��Y�Ľ[4��@
!D�L��� [Pv&��E���v_8З�d��&E��rH�k��9LE�g:�Z��P=��XY,�|b�'�i��+�$��ީ��v�ޅ�����I��
��P\S�X4�OI����������{I�7/��C�+��Pj����2� ��c�����W���vКP[0��X�Gk���z��]vp�y᧸�5`ݾu�Y� r�K��	���
m������Ң�v�_��C�ib�xh`Z��sk8�K�- ;.�Ť�HX�P	u�~"Ճ�>�u�rQ�'=���C"&�#�S��J��A�Z����b�%��Ts%Rȣ�t3�d�o�����	1R��6�	죕Q�3ki�����y��?�]����?.��wj��X���z~�u�#�J<*:�XP	���2�;o�˙oY��X�T�ds�������.�FS�q������:�S7[�g�.0��->c!����T���ɒX��ҙ�
�q��7˫ˏ�~��
-71�b �z��}��_�tP��#R��t*`mr��$&� sq��8�b(ߎ@��C�H��n��|�٧.ޢ�����7P0���W���Fk�������!�-rT�P�	m,��ĕp}��]m�-n�d@��I5D��!��D��sW����0���F��ɍ�v��׮w¹�"��91�q�KqX�#.��n����p�a��V(�<1)[�Mֲ�L�y7�Sb���{�A�+�JSh�3o�m�{����~�_K��Q9�E�/j�8�-�w��Uv�ʒM�Z�0����Y�VQ2է;�O��͉��i�)�c�5|_��.�9�7��5s �mn�-Ea�߫�i[��^{��z ���J�Ɔs��� ����F;�~�&j;��9����PĄït���gB�&Z��u�:��Y��{6U1�s�R�3��#qr����F�PO��u���\�o���9��C�#c�,c��]�/|����c�hsJM�F!ܦ5��M� ��h{̐��$��SX�R�_1�`/�)�����@�p�����	6���|"�qxJ��:)�~}�������-}B�����j\4v�?��mM����}Fy|~|D3���{ gi�4}�|:�/���h`[�
i���H�q@+���~[�';���r��cPÚ� '�|c�tHzN$\{w҂Ĝ����4�C35�i����^��Wi@�Ά�:��&Z�g�����ݝ���q͚�j&�	��ևg˽�8)Sns�4�0(ܻۘL���bwc���6�#�z�I�ᓤ�����-��D˫����o���n�������Z�$$e��c&(ꃢ5��i���ʹ���ZXQ�1�Z.��!��~�7w{87�-�[R�|t�FWm�^N��f��
t��ƕ��p�æp�Ez�����_�Q������6脏N��a|���E��ɭ���D{�����_E
�p�'kp�4��@9�V�h��Oe��9\v�m����6��a��@\�ΤmQ�U���ȕI)���'bE'b�c���.mtf(YL$8C8�#d��l=��|S����H�����0{l!"�����1�3�g �O�!�y��Ez�� s<�_�u� �Kz2`¶�j�_���|̧	i�_�B')��5��x5:哄jHb�,��w�yR������A�V5Z����p*~�B���:�wO�4������P�=Ǒ���-� �5k0��dLq��_�,��f�ո�ZS>���G�d=��W���0��JQ���������c?�e�g���B��)���&���a�Q2�Γyt�mד��Y0��ªm���-.<��	� F\{�QT�(7�/��.zu��Z�����Ȏ����_'����߾�ܡ��墯�͸�ҋ��/�#�K��C��g%Z���Q܀DQ�*D�� Zh��#m���4#ߟ����V>����)H�5��ٴ8��$����"ܘ���|�P��]�2P$�0����LI�����v��''ՐS���M����{�7�x�&e�5VZ��<2����?�~�:�c8X]�*M���g0�0�:K��j7��)�t�K�������n �  �w�u��$[O��ohN�	%�Tppl.u�R�S}���մ��)߽���հ��7����w���>��%��-nص,j�	�M�r�.�}�.T�z.ʧ6բ�-b�
�sd9-�\��mXu�C�N�Q�e8)[��x �BO�d�I�4Z����YE Pە�����a����ۤ��Ճ[�0EL�%J�>�����|���GZFy[C,��gP"f�?]y�x��@ ��~��$�q���4��yO�x��Ɵ�-�;I�b����澮yY@�wޅ�>� &A��P�D�[�Ur9M+�n1��.ADк�D�<����3܋��t���yP7<X�������ʝMe�v���Pal!LF���U*�Go���b?��τ�a��d���n���u��H�u=:�
��V>��.e��>�i�JWӭkV�J�C2��F�Ud%?���*K'@F��~��j��d���;  TB������᳞nX/�����I��r�\0#[s��]��Y?l%*�nfƱ����6���%�,��)O7�7zȿC����]><�o/�� ���cs�����g�F����®���[���]G�<D��9N�R�\�8AoiW��t�{oP/g�`�f��`Q�d`H˰j�寻Ή�d)$��=�{h%q��j����E�c|�3���g���e>�L�FS�j{����6T��M_FsX}�3��n1q�ĵUgɼ���DVxG?������f?A�J� X�t]7���PcI��s�k=(�Jl.ӫ,����T*F�a;J� ^r���"o�����f����Ω�'���4tx���h����n�#��	����\f�r49�
��O'�Ϡ�,#�Ʃ?J(����h^��`e+$���z�\H<o�(ô}��wG~{�?=}{b�j%�6�5�斟��"��h$fVQ(�A� �l���������4�5�d�VOJ1TO�
���ļ�k$$�����1қ�o	��K��%�sO~�[�R%v���&\���s�2Vb81d-��c�h�Q ?��D	���EK���iZu�v�}�bZ�U3VVY����=g4KǍ�l�2û��m�P�s�ʹ,h���}"5�Β�B�\OW���W(�B���S��YŌq��zNP2�:Mk��T���+a )7�m۵��[��91�¸�����������`��pV/�C�ϡ��P$�{N�V��*��TWa׀��GSD����])���P(u�>~�{G�jk��b����ji˳����໧`8:({�?�v��9�� 4� �� 8tS�e�Z��H��y�6��,�M��l�e\�F��vO��e�m��
����wK�\*�9�����6\����-(/�*��`<7�����n��ާP�Ph�V`�QRb�VE�猎��0v��am��0�ϟ���d�y�/(���#z���75��o��\$"�$�P���R����6D��v�Vi?�nǅr7T˪+�~���!kA�C��Q7��}N����gP�0�&]ζ~�4��v�?�[f8Ҩ�aEg�����X���K��j�$�v�/l�H�3��\s�	�Lo	Hw�K=!�s��!Bl0Q�+�S�m(v<M�b(���W�w��	��ǖ��:H�=�
V"�Fsl��s{�xt+I�dݮ�@W��$�#p�v+�g��P1� ט��ᎋ���
6���%�>��L�fs�[�5�w����!*�i	5�� FA��exN�#�16|	��~f�j6-z�L�V ᇊh|M$x �������p�iI��!ͫi����f�lIJ��e�b��[*Tza���B��{6��م�����;{Iy0f�'�C���>�z|s~��g:���%z{���~/�6�|Y-��71X2�L�U\p�!�g~�ImÔ���^EQ�|{�]�~�
t�����C�0���a4��U�Y�ý�|G"�x4���v��4 �$��P�]���PO���i8s����M3���]D����J���������!���*cl���i��$�՝�p�PI����L��ɦx����/�Gٿ��OGv"�0��fؿ��i2���Ţ��~��Bao_��\����!�����.� 8W�ț��,:�`����j���vTR���PkW����>Bh�-�@�Tp�oOu���a��U��؛FBSE����	����7YV(�;ۮp���H����3I}����tv���v�ǹ:Ξ�
���  
����C9�h001�P�/)�������(��,	@��M�]�ןs��X���&e-�1��E/,��9Rk'�nA�@:���]#5�j�9.ZO��>K҆%�W�ԯ���g�C�GL����b16ѩ
�5�>5҆�EZ��> E�;�\ ݽ=�@�w�0��f����Ȉ�-�V���O��!F��7"6Yz:��Y��YAI�>���7��T0�ާ��TA}ʣ��d+H�iq��H�>��=W����7�u����#h��؉��g;ښ.]OW3�
�5T�\7z��}J�р*�PS�I���"8ˎomٮ�ތ��g8�0�"�L�˂$J�������g���V+Ma�˅����.��.����qi?	n��hՊ���ԧ<�d�I7n4��f�z�c��]��h�b����G��)�Pʃ�d>�1���8�_��^�R��)�h��`�Ŕ�I�%y�Z���(�(g��~��������7����@�f���ڸO���Zվ��D����U�펱k�� I����Z�"�m��i6��[���:�����Wy�t����m������80�������1w&�,�'aBg�9���M�æ�^Y�c����,_���u�ǅ���U1;�}��TGS�ʧ��e�ɦ@n\ˁ�ǧ��͙d>s��9+�����0�ѐ@a𡮎"�@Fk�Lwwﯠ��ʺx�"��XZ���b�*��������� ��2      �   &   x�3�420��52��J�I��L���425 �=... |�%      �   6   x�3��HMLQ0�2�0L�L!S.CN�Ĥ��"�Ģ�T.#N����=... }�      �     x���_O�6ş�O�{5���y@]
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
�rW���m�����q]9����^O� ���!��������|�x^=��˓�O������b)�k����V�fn��Z��u����t(�.�kP֚N�\���<X����5��,"�h)X~^�x�����      �   �  x����n�@���wqأw�B�)j1j��7�J���w�ޱ=��$�ӿ���y~<�<�����%��'�1;�ͧ#��K��ٟ*�̃?n�"�E���M����s�%�dg ��pQ� �h��Z� ����(��T6-��d����Ij���pb��$���=Zd%�|+_�8���ڄ���k�$z��.)���Y6� ����5�OV�"h *lg7�$�Ʃ1�tw�ZTh�"j��:w�Y��h��  `^�ܨ0j�QFm3��Q�z�Uc�5Et��(�h�8Q��yu�5^��Oۢ��A,�}���DV�06#SP��p�8]`sT;[��E�1?�X�+��̵�X��O"\'���)R%VS�Q�T5K<�r��"Ԑ��@���T�SZz�k=�i+7D�7L��S��V������x8�>7��Jp!�N�����[�k��E��a�s��HGt&�k�����ʲ��������q,XzR���R��Ueˍ.�g��6u��4z�{"��(sX�6�mk��I�Rע���#�C�k����V�$G,�fM*-���n��U钹ih�R(7��>�J#]G�s�R4�d��+�r#Yӣ,b��wq�ZĦ�      �   _  x��\�RI}.E=M��u�원�"@@���7��ZK3Xb�d����Y�j	<��)f"(Ka��YY��d��|Z��&Svֹ�G秧ͳ6�B�����T�e�*f���h�`R	�/��1�c�s�26�`��;kW?|�s���c�[����Io'+��C1�� 4sRyg�SQ�@6���o��	&�F���x&��Y���S�r0�1����s6bJ0���"��lF�n��g����_	�F�d�/�DP<�ˁ��w�);i�Z�������q��ɷb�;�/�� ;ɢ��.~����Y�{��ݳ��?k�]���Zj����_���~>O߱F�LX����{e�����^mI}�����yƴ��x�8���G&�!�Ee��Mo窘���VF9��u�:�4~|���{_e9�G����#����i>�O���φ��g�P:4��#�pFk:*�(^��a1����Z��0qԬ�8�hO柗{mo%�%ߢMt�a���陕JY�	Գ���?������Y1�N�8��?Sд�H}`F9��RL��������y�J�9���q��P���T4�!�D4�ߊ��VS姳�}��;�v������g�j�?���6�Rx�v�J�&���ۧ7u腘����0�$��;�RjA���q�[�s<�y{0�zx�3��X�1{�]��㠡�M$ \w`#\ �N5��Y��6�=�mF`0�ZL6!`��f�ꍕb�8|�[)�h�R���<ج��f-�{�",�r �bfa�uX�R,Ȩ��j�p1yLt0�=�Դk��<0��7N� 	ZE�|h�?H�E$A���n5���	ѩ�5� �����P��]�6~ ����_�`8�|=�a��L�������9U�sB!�0�`�b��`�[@�&�0�.SL$�#�����\0�%���߾-��]�}0}h��s������FPJ���:��8�
i5�U� �.�m�hpW�V e=�U�t��y^����D@� �-��Z�ߜ�������I�����T��	�lN)��i��d��o~����{��p4.��yw|7*�ŷ�>�;vj��6L�3oS���YR {�<+�eM�J2�Z�m5����A�O����_�}�|�;<�{'�=L�ɚ��9l�~~�p*������S�,��g�0
��`���M��t�v��q_�3������ �nd��rxW[� �$�&��hm���%n$���3t؄��ݴ��.�ι��z`,g`�`pRi�9}|����`>�_�N��n�,V%&�'%"��`���YK�+8��$�S)n�@�D7�oY�U�e�A{����s
�U��9،�6n?�40@�:��u{��+�A.�.*ǜ7F��9N��k�`�ev��T2�%Nॖ�v�b�����G�<�Mz{� j����^{� Z�L�O�}D1HAH���
bU�@̄6�[����ׇ�d�����R�G�/C_�gA���h%)g�\&�o�e2�4j&�pU65�˝��|Q��e6��J�usK��V�	�3�����`J�E0����7[k]r�4��lD��
��4Xh(��U3׈*Xm��Ym�絆���7���������B�6����8����u�ӆ�u4��M湘N��3� ~�w$��1�i��J��f��*��� ���+�[�pYO���MV�[�N�#]�0�Z)aY�M������D݁��*�a:J�3�&�F{1"�W�l�vc��L�|g����X�X�����u�: &X�z&��숷.��]�N�X�-\�,������JE�-��C�m�f�nUQ�����J )�5^���N�]�`�Xڙ�]���v%�_'w�{ ����q�Y�����D���*�wM*�X�u�GE+�:�j���"�&,�����F��R�Xk���nr�:T��0�a��.?o%)4�W���7 ��5��y&	�K� ��[��a�qM4�d#�o�I��&����ςXBT���G&x��� `0ೌ�N�9����g���?Ϳ�~���O�ِ?w��3� T��Y��W�4qk�&�D���7�;��5��7<k=�@��F�b ]u�@�/Z������[eb��/*^Rѓ�rY��Q�t�1JXB� ����A��;��Ͼ�V�p]�L�θy+һ�Ep���q�T�Sf�w�c���~Zt?%�fUZ�׿�ܧ�T�`'���	�./��#(F^`���F0Fl�_дHT�o�<��p�3ƽl���\�SI&�7[���A�I�A�8)%	����i�w���	�200K�<3�M�`�<�
 �ZEC��~H�C	�.���N��kN����I�BkT"YZ�Q#�A���~�θE�X�0�4��<K\��lXcd�
�\8Z� 206	?iO�ֺ�x��֎�Pq	�>N�v�6k	Y��@{^�%},o�l��[�4k���Q1�,�o1l%p�4�Y�w�baOQ�_UhT�~(�j�5X�3IV����1O��Z��aAQ�D����͹\�]SZN�[��q�GjJ:���B�3�L��������)?͟�Ȝ��z�
Ƣ�j�JW�l�Z�|�",�%7+�|s4����<1���裥E�v ���SXt���>�#Lڊ���T�R�9j����q~�����x�~�g��It7�t����.+�J�bE��8j������5��Zi��]:����a-���`���ײ�s8��l�Q&�(	��Ɲ+gL@�=��t廷�F��W�~��sԌ��F*x���Mf�,��
����@ĻH��W��3�����0DG��|1חxu��ϟ��?�����`8t=�R�V�@t��H�v{�<�<�fG��;[y#ز=tu}��MygDI�g�-s�R�T�Q��������5�^���%ħ�^���A�%}7��A��/�h��Do����q�����X��~��J�t���i�U�6k(+%��ؼ�_vu�SN��Jv,[\��}��`�J�Y�霦�<¿�.�BV$������9�pU�
��*�;e���-��K	�RM,�:�A��ݵC�˃m2顀D8�m2F\E~҇)��H�
xw����򓁡�8cxz��\�dQ��3��q�BE�]qK�4���x�^C������-6`hE��p��V���b-�%��;_^��ʫQ��&�y�$d�t��U��>��?���`�
<(~|/�E�|��`=[[Q����y:)Q�l�0�sy��n�/���xd��P�����ތ������ պt����g4:�o�C��@��ub jW�Ky������L�n�V��B��WK��+�>��j�T�������x��}�ϴ^V�{a5��6K֯��5���������Y�      �      x��}[w7��3�W�%�읨���o�9Rl�:�bg��/m��8�Hm�J�<��p���%�
�n���)�=�Ӆ0�c5(�.��zg��{g�����z����r�2��
'1�J{L(�Բ��T��������x8�m4+�ɸ��/��?�{�Fw���|8���'s���p7�.?�{磻;rY�fÛ4L,���Ljp9�#JhN9ۣv�i�h��䅠��>����y;��Gw�������fT���rz��r8�<���������|xC^��}{��u���G7�d<��?(ɫ�w�#��?��c�0ާ��la��T�E��QF�s�����(F����//B�3�P�g�
��#��`"<B����V�9��"B����&�G�?Nǳ��|t=��z?_�OR�<>L'���	Sߑ�����ᶜ����t�M�0��/]!�Y��d����mZ�/���l@v� h_% �b�(��q<'���5�-y?�)Hﰜ��r��f:����L�_E�wd��H��Kx����{x�g��ļY?�L�����z4_�$.���4z����LG���(���nB����Ѕp�ų	�䗘��jZ^�'�������e�xt}3����<����Q0Wq��*YX[�����Z(����o����׷#�y�����q�]3Q��Z�݄��9�'pT�őJN��/^�gp���j�\�'W���=���0�p�X�Y]�����:IEx/F����4���T~���i��{l�Q5���2��j�5Ɯ�8�h��ۓ�;�
��S�0n���9<R�8���e��}7!��A���OY���A&�b֒�BK]H�I�ƥ���+�������M�w"�䰺�VS(+�es�ϳ�IrtJ�ٻ�W������q>-_×*��7gzBXXޝ�XW�j�{&)�}7!��A�����QX�"�4���]�~8'oyOjJ�?0�Me!U]���IT1ŭx�ϫ�	MrX�#�R�!Ö�s~���|x�~���*a^1Q�����2LW�2|�.`�y���hU}7!��A����+�E4����So�'�v�&��_�ȇ��m9�yu^N��?	6��uOh'�W��S@��
XW0WQɄ�W�,"��nBDS�V7�9��
	�7����UO�l���yS����u�5uT�R�<é�	MrXd����%+$sd��r��_F�3��P�
X�:W��Z!�I%��nBDS�V'���&�geBz��y2/��������{(p�p��9ɨ�� �.8�X�ﬢV3�L:R�w"��:�L�>3�B��ѭd�^*j��z�
F� A��JKU�:\�5�M����Z�w��A���`���޸����9���tM��y�)�!�5wC������RR˰41K�?�}\�RAY��r�Q�؄��9�U�a���7�?�H^�2\�5Ġ��kH*`]�]E�L��C+����ж.(�`/�R"u�8hj��Ye$Rq�1n���^��ir;&G��t�J�u����@�_W����˂��������X]��BɊ�\5���Z���2S�Yѫ6	*�G� ���7���7	j����[�$9��|:�Y�	tZ-@�@�6��+
S����m����>ʪ��4�巔�؀��9�U�a�T�k��B������X��i�� m��ʀ��d]�[E�+���*�P���,`�5~HokyI��U=6ࠩAf�q�EŽ��J8D���rv[�>��0�l=ձ4����Y.R3R�r�`�� �TA]]P�´�R4U�M8hj��Ye���{��Y4\2��]9�q龙��4ma�	���RW�d\��༢��N䙂Z�A#XR��Q�.hI��f�I0Y�8hj��Ye杊{�q�`��l� 5�\��р(�Z�H�@&i��օE�VsF�R���[�a.�
�	�ZβY�8hj��Ye�Rq�1n
���p�s�3���������W���_�j����:P��T�õ4Q�<T����8g�Ja�H� �k-���&I�Y ��8�2�{��IT2
���}(�׷���*��b�;u]��B��:��3��뾛�� ��Aְ��è�R�wg�<ڿ h�6���Oe?��	4"��6V-[7���cΆ���\Mƹ�`�2�+΅���k�H�ƺD�f�z���**��z!l�<��V�;����pxO~�a�v�w�M��<�B��ȭH��&	*�L!p�r0�L� ��#����Ó�fh"q��=�	]2����������e��3R�oHj=�%w����k�%��ܶ�R}���KD5�V��n���j�QP0�dE�Ĭ?.����yEC��'�\n��#��m̙靫�Ƞ�M���Kx�V��a�&�+28M�Q��]9f#�������&����-��AM�̬�`t����ͯ��Т��_�ɆZ?ti!�^;,����i�24�2�����K�?
v�u>�L�P���P1x��l^�-��e�6��Q��`IY:���r^�I�6�N���7kʺ��E�A6��Saˬ������ s�b-����45���2�:C�^cܤ,��} o�/ARTrЙ�H�p��[,`����gR�������II�Oq�^�?G=2�CG	g�BC��́-�XW0UQ[E�L�ĺ�&D45�au�(9
���F>��NDg����@�n|U���-Q%h�a?�ua���(OP�i{�Q�؀��9�U�qO�k�OU�J�*μ�Z�e��X�L�Vr��R�0#n�ĉ�*h�@m)���45���2�{�ĽƸF���lHa��8�"W��;T��I�AP����zHrn��^�LhШ��X�OiURҨ�k,	L�I�;d�����k���U��*�Ь�^c\���d^�Q����GSP�zUr=��]|�d>I�$gW���#��{<B8?��
|K�h!t�Z�𣄊C-R �Vjug�����2�0��
ֲ�.>|:�$�����/Q\�fA>����� �/^^�i�3�+���2�L��% ���
���m����Q:x�$jk+���M�i��,��M*��q�_?�C��n���C������I�/\��!���4�T�à10�(󌜒~�H��Z Y1�T�YfU�kt�b<L�/ ��r��2y��'3D�oC\%I����䰡���2�?�;�3Ԃ��3'o��D�����U%hV�%W�3�i)����ú��]d�qCs$�$rR���;+��sr�7�0�L���h2&�$	G��S�uf3
�o>���9����m$�7k��"E�Tz�d$� �Y�����N��Z��ggl��D^	�&鼝L�x�g�!(]� �ɫ��%�oN���I�}��@�'���
�!��U��g�HP�Z�!���c���.���#�JH��l>�g�p0����fx����Փ�G��7����@�!���աϥ�3�H�䜞�!�ߍ;���HT\>��b?k9��b��&~7Q��&�=�P9;��o��ś��7�t@&w��O`���Ȼq�0+�'g�ٜ��l�w�xOn�?��j�`���|(�G�/=C�ER��I%3��	����y����J��|��(����ú��]d֟�+!i5~�����Ȼ�lV�ɞ����`���k�@Ȗ�'0����G.��U$0�E�T�6-�I ���j�Kn��+���c��*��l�P��6s�@ȟ��-99�8&W��w�	�8�ȫ�x��4~�~�	�f��{MNCE��/R�a���}���XИL�~,��$z�Ƨ�!XJ1���|�Px2��[ݼ��^�p��|�2g*#�������Z��},Z����d��O��Ns�1�*���-eX���-�)c����O��F������.H0����r�n�G�0C�[��@��dx���-Dj�BKO�Y�P�$����ùO�v�M����V���:��
~5z^F����0"���*�DB�a˜�_M ���<���Y�1���"������_�N%..����f��    �,��+ -�Ae�
XWHSQۉ'�ֶ?���nBDS�V��+���e�*H`�=�p2�܃v<���ְ��_�6�����kP'����/?�}���f�?��S��D�DiV�J�Ng�)
�����-�a^�$����Pm	C���n3�sӧ�l�
�k�@��.����[D-�Q��?3�FX������1@z;L��s�Ek׬�q8!�vm2�w���sp ��e[�����zG�??O�co�"������z�ח��%���z�s6w6�d�!O�0<��|��HE�a�Zk����r)NjU�]E��F�'KN�8p1�>3w���6����@�9T$�K�j}�����E8q��D�,�u:U��p�� Y����W�݄��9�k��v`�܊�f!��$&�H�i8����v�H5Sѵ������?g[-T*�M`ij�#n9�T��qh�m��7Ӓ����ez�3���xP���a�U뼽'R����{Y�݄��9�NZ�0{��>k$TYO�����{�C[��X�N7��� �q�G`U�M�hj���&0T�@w��r{;y�o�ߞMP�=�e�i�gl�	ѩ�d�Xo��O���8ć;M�E"����*U?k9��j�v�M�#����.���
��_�z߫H�DX���v_>�7��&"4m�wM���t��"�Py%$�~u��6?HFsr�B���kϢ9���9,$6<������~�r���f�Ul�
'��n�� 2��e���	�ͧ�߇�x�Ld�+��2=���j�7;;(XR��(�r��5rh�2a1h"o%����i���.��ՉWB��@�lH�0b��RQo8�C�p7i�!�><�	���û4I��V����Y�1����"�0oG^	I�`�Pԣ	��E�Ԧ�����\�@��<���h6������W�qev�1o	�=�ya���}����$�|Tv�:�>���m�_���[��3�9�P�$�v���U�+S���n^F�����׵���KN�BP���	�)�V��.��P5��
���&D45�auRt���Z�^0Ub$ԧ(1����c�������T���&DU�V'�`:X���|%\�IaUd~���J���IZS壏����>󈩂o���6A��A���.L��`qb8��`� ��8��p��Fq�"�Ģ���sP��Dtw��&�i�Z@�Jd
ϕħ��R�E���~�c� Fк��::yU��Bʚj��m�� ��q�G��OʀRg;�I<���� ���U8{��-���͌p{4|���������~�z���4Ku��p�U�[X��#U��)ٳ�ku�M�hj���:�{Oj�a���kmB\,�c�\]��ª���b�s%���nBDS�V7��>(ήx���K`2�ӡ)ڛS��c�|�q��k����b�R}��۝�z�%�M`ij�#n;{%�]��X8v�aB��y����ua�TK��s�U��nBDS�V�a�Y�`�5Ձn�%�b2/g����⽏��L�7U��Ϣ�gpQ(�1vS&&Z0�yr�cF�ꂟ�'�hc7	d2`��٥�M�
ۖƦ:m��W���d>�#����f����n�x���R�������Mw��v"�E�S��z�k�S���%ee�:N??�������)삡x��0���>������8�m��aN�}��,���I�Ō�"�2�NB5.���H`��7���i���_���͂y��I�XQL}��a8���3���}�"�1��/!!y�J@�|�N��>0���E&'��ٿ�}�~'�0"�!��^LG`��a���oh?&����R�CX�@��W�`/2� O� �`��������n�٘v�~xh<��w ��#�]ǣ;"�Trz?�)��&�э��O��
�[�Pr����cE{�,`Z��|@�!/�P?��)�͘Q���������MI����?��ܖw��ڀ�����N�>s[֌��8j�y�8Z�
���[̖b���,c�2�[�Tz櫗X4e�;zͅs�������h�Qd�w�����yb�]78�Z������W�����"ں���˾�ě�؀��9�UƾYͽƘsܐ�O�r389��w�"t��-��׎{�Ȫ�u踞��\�l}�ɘ��2�y*�/�m�^�p�� ��8���^c�$���ڋC��M:�,�;�g��.`:�&������L�T���8��
��	Mr0����*�5�MBJG�h,V����ܠ�ߧ���y*#U�j����n�|������巔�؀��9�U���W�k��İ<��e��&G005|���h�Ƭ.`]�UE1�\>��V�w"�䰞��t`*��ʚ�D�q(�\po��8o��
X�#�"U���&�T}7!�䰺�G��ȕC�e��-9�L¥�T���1��goL��&EI~��po��{Ko}�\�mKS�q�(�q�a������w�������|������W��a�����W���<Q���(��u��%P��<�u'�݄(���:<&��K��lڛ%g$%�����PL��&����ٺ�u��UQ��3	��	MrX݄eA/м�VX{(,Х^0V�@]�^cl̘i�}F����
X�~,��Att�f���W˾���6���A����čp�s'd R����%(&�u�.`��*��x�|�u�M��9�N�o54���ͺ����K�'�Nf��d� ��-w�ʡ5�n:�� O̷<'���(��_�=���Glߓ�G��wȨ�`�v��D��4f9�緑�J̷�Ѥ����@V���|�F��aM�	��2�W������?��d0�A�!���8dS
c2_`\8|#�w�<�MG���,g�rLz������q
	���z��4��j���3�nF�,2_hG�>���]ތ`��E�-�w������kr6����Rd8�I����Ji
�[ϵ�Lg���|En��~N~�N��H���~2�W?^�n'�G�ai�ݍ��>4!ȝ}G�o!"t���ZH�ND�{Ox�$�K�� �a/���8��+W�V��jF��������3��UAk�=�6�.�Mr0��}��{�1�1�Se1����ڐIK0t���.`]���ゅ��<^� 0C�Rovb-�wd=6ࠩAf�q�QŽƸIF^Qu��p?@��6<�A�5�D
�
X�sXG���o}�pv������F�fd45��uҋ1m��-ܪ^��w�TZ��������T�:o@�Z��b&���d�J��L�TmU�c��`V�f���Z�'�ή�3R��>������S��)LUL:^�ū���%�5>;z��X�R��?��P�*ʠ�i����o#��s �LC��s��+$�_��^~>8��&�^�Y��>~:���Ah�FɅy�Z�6avMkpb����L-�q���'Rf`�l9�g�m�@Sud�ib�\�kbH_9�����=��9���	��bJk@M���<���R���0�a�̦̮-�P��M�9�e��QŹF�,�g���N@�����c��.$w�,$��c��,�x��۬Y�9��Ǚ%.���6�bU?�8�)c��&TG^	I'a�V�9Ga6�����H���h�
���h���;{B(Yx�K�5�P��s"+��l���5�bE�t�I�������	�� t��B�=�m��	�E��"�����gWk[+���/	�f��$~��S±I��|�+9�����mL���0��T6X|H��J/�p�W�71u�M��9�N
�X��]���'ô�8[����q�*X��p�϶-���\E�a��R�#YZ6�H� �\��Z�4�e�y��a�[}�?�`�`d��_����*�#O�0wJ|�;�
S���ex2�ZY�zY�+j�9�8�&�l���>�:x/STϮ�r��7d��}�^?��\�bn̇�
X����:);��(t�-���Xj�M`ij�#n�)<9��o�̊Z���xL�F���q�p?σ��|�    ��e�����G僲m�E*`���T)�/�}J� ����a��B5�&�45���H�^��xH��V	��X⭔��3%ZUQͩ׳:���a��m���b���9�bM7���U����b"R�]���̻�ɺ�u>�+R	#}���]��u�M�hj���^+���X�����kL�I04j>}��4�tTʆt	����öR�
�+
{Ƙ�����x��:��f���9�CT%�+Ct]�^�\�\�Nf��|�]�w�!|���r>.	��Ȭw�߸�.l��fb/�q������<�P��e=�� �D�Ȅ�p��ś��%)���lwP�i$i�����|e�<��h����n%�r9¦c����-����5����N�p���.C�d�>�Ϡ���P�-�\��yy?�Q�����}>���>�yrS�s_,�B� v�UN?O~}��c"�#��/����a��MA��M ����c�X_�ʽȍ�*1��Hɥ�����K�����R8��;A�a��`�W�З���G*��i�/�y=��t�<+�W=����s�J0/�w���f��>�LUPJ��7����؀��9�U�Q�O�k�9Ǎ	���x�:&���c��T��B��:�R,�DӴ�w�X�����8���"�zl�AS��*� ��{�qY]�p��������r��p_��2�њ���'j)=�@&h`��}ꦺ�^N��IZY�Q�T� e�mhV�.�깎ł�$K�wy��l&�RN�Ñu ����)�i4������"Ჭa��g-�XU�]d�#����7�L6���`��ӫw���s�������D� �����=�Wj�`ʰs��'��q�M���
ǽ�?�i�>��e�0�2�9�P�$�f��!��:��:�`nX�ZS!\U�*�>���X@�5�'�݄��9�'>�[�����ٺ,�{��ź]M������T�_s��� ��ğ�����H�,XƧڍD�廌7.������j��l�"x%$�������}z�P[�Փ�`hʐA^�uh�A>�����3�l}��Ъ�nBDS�V����Y�ʮZ-�_�W֓p	x��k!�u*�`5)+��nϕk��	MrXD����f%V��9>��k�����{��?�j��9mBx���e_��Nv�3��mX���@�c�qW��D�OG=�)Y=\�5S^���u���NI�1y%�{���G�5�&�45����Lw}>��N�δ���	}��QŜ�uqz�UM�6d;�Ѐ���Rq�W,����!��R�>�f������"�O@̕-���h"��I���)1����"�U�4�+̩�pZ���Y�AؑH��ѼHo*���5�D!�n��s�2Ȭ�ۯ�:��W&s���|��d�x�?Lv>�������r:/�ɗ����玃�������5�%�f�	����|UTx8%��-q�֊��C��L���5G�O܍�!>�aW�5��9*�2g�i���Y�|vO�|y�vx�*P�f˷~�s��Y.����h-�)o������_�{/�mǅ�tF��뤂����|�Y�P[%�B��jշ6��th�y�(�cw������@T���20�]���,h�p0.[��(PE�X��#���,��/�W���d<���V�WQ�	��;��w��dh���E�Yb���!K�m:I�s5: �o�ryi��|�Xm��z�H 鯫T�p/�N#����M�����t�M~'�8׫���"Z��/��^>P����E������ge!�����*1�ڄ��^?�e�4M�Y<wNo�z �թv���a�/��s�b����y�И��<<ܿ&!���Q�x�}��*I�x�x~�v���9����7f"��2�9z�^�����#���/�#"1�&?"�Ή�N2�L�.`&�K�X��9���n�RX�4u�2'��%n_�c��`V�f5�c�q�;�89F�J}،`���u>B�N�\��&D45�a=�c)���0|��ËW��xC3s4f�`h�,��u>�E��	/�.8��Ⱥ��&��nY�8hj��Ye�[ŽƸf �g��e¢�+�?�<���_���{c��%�ɟ䡼��B:`V������ӫ����H9UB�h-��0�+�b�3���޳p�� ��x�{�qY���c~�To��3q~���ȏ%ȑ\N�N����P�Hb����T�����y��;�"Q\����~�r���f��&��+!�4]\_��P����@~�+I0nyѱ�u�TQ+Z�um5�T}7!��A�۔C�o*M�؈�`���`Z�f�������������2>I���w���)��u����%�hȺ��^Z�ú)ИgQ���b��Z�a�dlل��+!���d��j(�xz��E�'͙́F�SL�����T��Eqs�����ϊmX���@Ľp�������2J�����Xc�'�Q���fGu�e}�� �Jn�[�mKS�qK��qE���>?���>9D�I��p
�=����������/p�Y8�I�������c0ܣ��f/У�����o`��,����{C��cܝQD�����v���3��m'���.� �o+��Vy��O�kM��NR�na9�
���z��a�Cw:��r��N�D�۩Cfu���"a_,1���Z(�óNB[����R2ɨ@��/qi��&�`v������ѳ��zu���_v��F^����v�u9���Q���s^���mU���3BMJ�����v�B�;�B�#�_̥�' ;0��K��ꀷ��s.S��70�~H,�w�7����I�¼�Őڧ�`k���vɩ������la_bh��=�'��i�'�w��a�u�S��3���.��A[~$�{��B��e�<�����q4.．����&�)^�r?y�`�ܕ��� &_"{E��H ���-o	-��������Z�~�
��>��W��b�%�߷��[��a3��)�o������v��������<Z;VgPA�5fɨ���y�)3U�vp��/�0�/�٩e?1ߑ�����)�����lT�K�@n��\�W��L-9|�s�#/)���BuK��{h��β?"��4W�V/sOs�Q ��2}�Ǎ�WTQ��bb^���������sS2	�2uAYmM[ct�c��`V�f�c�qc�n~�C�bX���[�����2f؊*�l�#��O��nBDS��8�t�u��Dt9,a��&r0�T���]�T�'='�a��c8Q�(M�Q)u�]@�m?:��)�:�m��F 4�f(�9�E�5�M����<���*/��!�
�Zh��R�0�:Qɹ�ϕ���	MrX���1�0�J��5&ؽ�[�	clȮ0z���E�,�n-B{xa��D	��Ƨ/U)��_8�f�m���Z�a���.���<�JH��R2�=r�x�9)�LI�_b&�՜oF����ܱ��Q�dH/����X J��� ���#]f��f��z�f!���n^f�~ �/�M�v0�c��Ij��&6^��A��%�6>���A����(�[N[U?k9�dl��D^	ɦ��xp���j��)�P	$�@�cL>��"/p&Dx��u>4<Qͥ[Z�7���O%(̠{lo���6���A��Dx!.�N���9+ ĲP�Sy��+�,=z�S9��z���M�)킻L*`��,<Q��t�l��f��V�5�&�U�q++T�v��;����mC�u�h:�c����eM���Ru��=M�j�A���0�	]c�OR�mKS�qK1��Y̭s'�y�1�s�gm�8��a���:gD-f)W�������@�&�45���J[��.�Š����~/��2���_�֋ùuR�O�V,�og)$�( ��Cx��:�X�GL���7���aMFd�'���P�wۄG��ނ�`�`i�BS8|�/a3���S�?[ξ\O�����%y�q��5y+:�ö���}k�j��o���W-�_��� �  ��e�7j�g��~�}�,g�&~?"�^/L0V�>����g��O7�x�̓�
�^��G&�I���N�����:�������M�>|�l��_ʍxS���E��)�S�1g8�V)�zG��d>��9�2!	>�x��Q��]$jy��v/1<�^ym|�N�|�i��2��`K�����"F����Ob���eG�>0�a0*{!W�Sx ��k��-����_&WId����QY�m�\����	���|���c�n��b0;]N[���\���v���	^J�B��5���j�}h�7�!���:�ᜍ�Z�^hIqx���sd�ظ��D��A0yn)��ƪ��Wo:I Z8h��*�'�d����AH�7-;ua��ן�<���9.g�S�P��N��c:���܀>Z�?F~Ƕ1�.#��;t�@vꤒ |u���/0�Lf�w�����/w~=�B0!R���7!R�X����?���Oa      �   i   x�U�1�0���á1�g,���H���p��� qC,��X8�#�z��dKRI�$AR��H�$ �I��L2�H��y����r?c���ʄD'Sz�ѻ����9�      �   �   x����
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
<��g����픒���8H9�8KKD*"��xc�K��Y���q��;���t�,���c~�c��K\j1H��3�ѫOMGO��|�cq��kPQ�K�ŕ�{a;�o�A�����ZroWB0R�P!��%�A��I�.�xa9R-S��r.C���� e��| @�$������0(�;�!�����$���<�W�����@&>��u^i��ٺ���(M���g��#k��2Y�M&�]$H�Xq��L����H�G��V��*�:�����|�J��ԑ��U��sb�M��RE�
�M՜A�Ku��CM��GU��I�k/�nxn ����eh�M)������k"R&Q���a֜1�N�Q�U�«"��iz[�Ue7UU�s�'/�*JFь$7�/C��2 ��E��yY+K�$c���ycK���⬃�ra8AAw�t�E����w������n�'{t������K��},��L��@�_� ���E�%
6���̍�1С�l;��!5<{�����^g�y�G4:�ۃ����X�	%,�}�q��(a'�]J�
Xj �d+�"�|6N"$���:�)zz|�l:AS�����GS̛�Zk�!��sAVjꐃ��t�C�����R8���]C���f@`����T`y4�&�%�mc�A`�U�z|��E}��|����?�{�qz.�4�]�{D	��Wr]|��ʹ��c)��@�Cɚ��h��S�����P�r:}�$�h�6	��~��7_j��������X|v�����$�S��+���k%Or�1F*1h��C�1A�M��!����	�9I&�L�j��@K�EmLl�l��p�L�L��"@AayG�YS��S�E��=J���&�M9�nxf�����qp#�m�D@v=+�k�:DIai�b��f�x|vq TM��4KW�P����HK:06UPJ

��O(�t(���SPS�䆪1r��Uc�O�9Aaxz��3�W~�����8��y�A�����J�� ʧ��A�푲LI�;06+��~�!�q"a(��6�7���������v�x(1���G�c	As�]��#�m�xr�j�l-��@s�GɥJ�흝�%��'�Y��#
��T����?|���Q9�Գp�# ����(XhԬ�&�l�X�$�ݵS�m��A��[|4v�����i���=��wK�@��OԨ��PP���C��B�N��!'�j=��Zzi�/@B�~�v`�����wy7�;��2�>,�CW��(��p�,�����#�y9պ��������n���gV�ר�~�ˏ��S������G���?�}�}�u�CWB��R�\��Q�ѯE:�gP^�˔\ԗ-`�_��G�J�w�P�k5�ε����'���!>ᛇ��?����x�+~�p�������'�x�Z��,ڒ�R�phN�QڹJ�\ty6/�-)����~�|���(=6��{*A�����~��$vN�$F"A�G�g�ߞ޷ԕ���"�m�2�A�G���U'j�f�=��/�:�|ʫ���Qix�'�lͦno�k����~e�=^VQ]Q>34G���*k��$(I����`ۣ��e��I�[kۣx�b-��%�Q���rkNb�S;�P�H��B͎<dݮ�8v�o�*K�@�r�"��	��u��*X�b,�����0{3�|8����ӳ����Ը�&�l+:p�~i։���%��\�E| �ek���os�����Q�e4(i<)��N�eK��=�]N>�u�j���/?��p�t��I��'�lJw��^�98#b��st]
��0,%&�vVHji\.���1&E����,
~MXG��0�O���M^��_��}��؟�����5��������k�(�C�)�_&v�b��^�H,���k�}!,�X��^�J�Z���EdB��	��>�,�a�Tn^�y�d�D �({*C��d�Ĳ\n�.(� �#(<�%#jWJf���V�'�l��ӱ}{��z{��=�[����~֩���@��!h���FR@qSm
�K���"�ˣ�9�`�����D�V��:`F�d��������~������s��~�𾏓�5�+VH�J@:L)��������ⴚ��$N��y7�}S���]U?��`4v�&B ���T�?��( ����v'�'e�$e\��R�C�7��7��~*�s�:�@�w�2��zLo�?|8������7�}�����٧ȩT���F�QB5*ʸh�� H����� w�I��d�I��M�*��Ͻ J@��(nj��{@+��<ӛ�P���s�2����m�l�
�܌'6�60����I��	�Oν+G��
q��L%�-=�9UUK�`u�t�������I��r�����M��$5јSL�T5X���tɒ՗&�f�a�שp�(;/��)r�4���un 8��y���_���j����Vc�[ݯX{"I�֚$:agC��5I$4<6(3��u��H�r�ڦy�� �l����Pԃf|<|��x�������w&E���Oӿ��M�]�~1[C�̔;�X�~=y�AH�9��7k�˽
��$ব r���r�C��(�'��z�`/X�'ɘ5i�9M:'���݂KB����E�Ӯ�'a&>����f��TN��ލ!�!�S��3?�A��}>���՟F�put���B�4�C5l
�;S5C�НP�k5�Nk:QO#���N�F��zHh���̝HX7��J7��v��3+�a
r�Q���l��9�sSoC�����,�Q�[��/�O����Z��R��ز���Y��M�^�y��M��f�8Tߎo�<�F����IS��T#�ɹE���������R��7$l��Kɢ�u�R$Cl:C����^���w��Cp%DvT�h7�1�/!�V���f����N�%�r�Fkx�_z�w�l�����I�'ب%l�/�a&Y4�mԠC�VwVĳ��X`�k��[���ɺ�Z����T�tnusN�Kw�T��s��Tm(�ܭ�	�Z�0U7�˶��%q���qs �j[+�Jw�[4��PWn�{�����'-`�AŸGe�����ސ��y�|�����S�nU�ؙ9��Q�%X>�%�G_"���/T~:9��JX�h̟�Y�&"R���Nx�|�l	�%,_��=5S�4�5��wqHQ�:҄]n�$`)ԝm�ޡ�Z�.�Im�vk,�r�r{��Km�����¢���u;�_Q�5�;ϰOX'a=]�Zܡ3��t!m��t��A�RG�fuRQGA`�J���:IV*%W!�Qw]�Rq~d�"2#�NEx�ZӴM	�$I�`�s$iW����Q��c����u���.%&m��W���p��6PՉ�#�.�G�T�`����oYܣ�5I�R�v6y;����%,�� �q����
�>%��*�RqJX��kq�A�]�B+`-�1�v�����������ʰ�ޣ��~�.�t�����CP����H�E�B�G-��|eX랛�UZ/�qzL{�[(͗�.�I�/x�QZ-�ՀA꫋2�U�Q�O� �E�d�<w��%"�W�A��"�hL���1JF�#�7rQ�$�X�L��$�Ղ�R�}\��HFK��(o//����0�("JDOG#�t�Q�Q�Jƭ/�(m�1QK^H]�Q�ԟw�Fie��2x{QFie\׆K�/�(�����"�xIF7�2tZ��q��:#��*�C�EA2�`��'�5:��<Vɾ{�6_-�����w�g�L>:+H�"�2�3R'Ia�+)Q�"���+�Ӄū�N��߉��5�{%m�Rr���Sw����I�R�uTm|�aջ�z	x��������nj������$m�+a�YK5���Bk�	ӒQ�/'^&��lOK��'�[�AqV�wIJqpN�Y:�(��۷7�������ٺ��:��8,�'FK��~�`]�p    ��5�DHM�y���8I8�j'���/Hk���Ϡi���:�Җ8���\�T��4#)��N<dBiA7��fI���>� -Hw��p���:��G�w�Z�ʭ�:�^R�qZpX�Op<DŤ�i%�ᢄ��+��>��k�!]7c��5B«���0�Nz>ఎ�Ɖ��z�O�(H8KI��i��CG���~pV�n�`v'&njv�礭�<��ø�I[�EHQ�]�i+,}�4��e�f�v��di���D�f�QB ���P�
�S�W�}]�P���y�)^m�`��E�[�����6 <ȓ�(�ws����i��u�$�T����o���0��QV�_�0JB>��]L���8&���iX�O���`G��$�!���bDҰV�%kY�}AB,	-�(藴4'<�I�~YZ� ~G�,�	�郂����ք/s{m/O(�	�b�|����(|.�/Gh�E�9/<n7�Ң����#BiP��D��5iPh@��OM�.�u%#m	�	*�H|Ҙ � <�I�]�!�G'#M�O�Q�����4@�*`���������	���3�nYP2R�)�/��4[��>s�lbCـT��m��uQ;�H-NM�]��fv<�ڴ tן�����H=Lc�0����n����=�y�ㆂ��4�&0�@jd���1Y{!�j��b�J�J��5@��9��T�T�mW*u^�P*���S��EFi2��
�^niJSAI��v�n�P��>�҂���	�]�	�!;�3��U�~xz�5O^�����>�3��c)��I�~��	��nrK�)+5��[��\Q���S�J笊m5�ܾJPN�1y_ᚽ�ήm���)�K�Q.ꘙ�u�'�����l�AOc#R�0���Y��t5PR�x!&��y}�V�����E�k;����,�5�����m�����L]��K�HI4q���2m����@�5
Vǭ���Mi��p\#f�7�oI�1q�r���~�Mi��q���ɔ��J�+}��H�i�!s�gg��iJ;�d�S伊���7�u����&�z*�K�g��{R6Y���-d>�Nh��u���>?�$i}<Ц��<V�+ ��F�f�ە���Õ���p�J�M͙�X¢���1�9T������qOH�ޗ�r/�I��mir���j�H��1�Un֜�����M����z�4����/��m������td�V;E=n�_ڒ�o�Jr��N�4/.P[���_���h̕�(rZ�L�+~a�OQ����p�����ã�t��O�>>��7_U�4(�����hCa���'��ʶ0q�v���^�1pO�|���~��x5t>}k��C(�h��a�F�fx��l̲�eOȥF�?���唉{�7�)ʜ��ķD(b�{��?��\	���|��k���ķQ镛�p����<��8k���8�T�2T���x[(���~�'�x�eO&�]���aO�0L��Hs�;���
3�Ѷ̆˓
ki։��{6I��V��-�"�8 ݵ:�&��������@�>�l I��ԩ�]���Ͷi.I�V�>]���4Ȗ�J�~RQ�̡�]	�J�s��4�l �L�qiP<f�ٷ
ZK5�\#�܅��02�P�F>�R 05��� ϗ#���0P� �1�n�Mw������6�p��J_@Apmv�/o(?p�+m �P�PV*��;#Jޠ��7�����.��v^<j�w����r�=l��4Y"�%r�7���R����n3�T�Β��RKw���D9�|��|<>���1`~�p�O�?̉U� %+�&b��<'�b�.�7�����?�~zw������v_��W�ѼD��;8�<Z(��0�~c��E	�8�ɴ��6�|<�Gr��Ӓ&P�ϩn�����*۰�#���b�<Bj�Me��X�,o�RP��l+iUL�����P��0�2+�2����%�����!��'r��^� ���@;��R(I`@$5ݜZ���@-(ȋ
���m���|�M�+u��((r'E��n SH=��Ɵ{P���P
�@v��*6�+�Ǿ�2�#��a�����
�2G4���ClkP���T���
����v6�I�;?ޔ��v��S�U�|o���vS�yg�]���T�@E����Z+�mFC�t��G�` ��Q�@q��ç�?>�}�}��L0����f<=V�~.,9,�%.ǫ�Ӆ��Z���K�f�����筞$D�E��>S���֭vO�F�cH�_��W��aX��I�[mp�Ѐd�0&�e��Y3�~�-�Y7'.qlub��5z�W<zd�m�Z�M�����;�p�7�K�$�SΏ�s�	ė.��8��o� ���v���S��eutc�e5���T���㺵J�í���Y�f�Z�#��P4�H����@nu�BZ�L��R<H0�|����t����g�O�i,#e*��T\c%���_�~9����\IA�!g��,�@wӼ�ڙNR�B���P��vE,a�?*C�"I��[��8'�`�(�.! ������W3��HԌ�y��
^�y� ��S���Y��_���#�DHt�sq�*L�证Ϧ�o�kF�$Zѫ�;R�N�2�4C��A��:�����n���݀��K\Pi����������=�ϜAr�CK�t�⌒�x�vƙ'u;����}q�j⎜��`�(p4�㩦-�_�o��Rk[O��^$$��4�Il��.w<L�&��!$����¤\>	,J���*֤�i�Q*����ٛ�C��9��?�3�$8)��^18}vM��$Wv�n�k�L���+X�#�y�	
R�F����JjW�R�,�d%F�z��9�,���z0<����cN^p����MMa�n�;��6�����v�Q�[v��R�f�	td���X�(FKE�Q��е��b�Ը�Q��>�R��[2z������I�h���e;;�m%���83�ZgH�v��=������h/hG�i��Abp#T97S�Fǒ";>4An_;8	N0|�������H}2�iYvg�))�S������x��ߛ�1R{#p��v�)�7�}�ƝqJ5��{·���4 ����SZ�������'���@u�y3�*��֋�T�˽4�����%�Q�MJH3B�'�|�r�ZdK����H�;��9v�i���6��ƅc��D��֤i�/(@s̷�7�Ǜ�#�%�{DA���8��R(Ibp�Vh�\��P�&ZK׼M�U4���*]bc�@���]>A4�M1��fp[�ݜ��R+�VBPE]������	�+)�5pQK
/(�PFc�����?��������an��d�Q�ҫ�|K6�����>S��%9�&c��*���q���=�Ծ�
�:
���Ra��F����>�� ��l�r{�����/¸1��=�>�P��Fg�o�^U`Gc5un2kD���"~��mݓ^�_�A�j��z�=���Z�#P���4���u(�����+6�H
m˫Gc��v���:��k>'�o7m#/M��O�������u~�+��k>ftY���vp|{Q,��)��O����bmy_솚��쉔O���\Vrq���	�	���l�����ٞ�!6�b\(ٱ�9M�(i8��%"��K� a${�/�k������2����SG��r��HIT�Қ�KM\ΘϠ�Œ�8b�;õ�n�R/� R�s[�/�3�X��gF��^_���5���}v��~w���}v?>��'�EjjbsYۦ	l�	L�m�|���{���Z��ʦ��^av-^D�J<A�鮻�Gx���Ӆr�j>F��܄��f���5k��-��(@�-l�t������;�:�gY(�:j�����ZX�Q�=��s�d�n��c��>����|
*�����_�������wO�^=�S�ˠ�e�4�$u��\>�q�Wk:��jE#`(>��,�0VgOoy�PO'J�C��4���mQ"P�w~_e�{���E�%�5
��N<�P�D���f�uP;T_��Sg6�QO    1�Ϧ���\ﭿ�(P�-d>��^zT�#�6d�v� ���\�ݐ�|6'��9������]SNh��El��Ҡ��W��8�H�5��i��
����$��\�xH<ܑ>�/���?��K���f ��(�$ rlU(y�<��	�D�e=�f%����Gz�#9��-��[�?��/�yԧ�j�Zq9�H��c%�dR���2P���ص�Ɛ(�޾������o�n�����_?�~�����g���/������������+U��_|���ܼ}�}~%~�/�� V�?n?�>��ͧ��ޠ����y���#�V@nƥM�-������
ڕT����6ݏ^�$2�!A��0B�`����Q���β��}W�u&�2�=�oV��u]Bۘ�:�Nc$P�vD���4�Zd��l�u��3E���Z ����jڢ>�:�P#�@~vd_��}��f���*c� �Ki5�ħ0͟o�xWV�ǆG4U��+�Qh{� �G���5�~7���㺲��=��L�r���/{9�B͇.bk\!/�� ?��ζǼ5�jĜ+b��T��z#��ŧ]��%zAJR�����ӓ*��������=]~������vuĳA�?�W�?8HN�쭂�� �\eOq�T�Ȋܺ��*�WSjr�|匌�<�⟾��Ek��ۘ)���U��rj-�����u��/K��T�;��YWsKS8�_��ԃ�f:�v�]Y��;XΈ�&UE�/Z��:0����Mk�_�x��y��*�~cG���nڰ�U�'J�a�7�\8ARu�n^�SV+�(q�I��0��Th�m��	��ҲRK���H�\,1+�7�}f�j���Z�IM<Ȗ�����T�]�y�k�RՊMju��`ԑ��Eu`�*�k�K�װp�?�YA�DQ�6ȧj���28&�a�O�GI�F�8��"8��~ꞝL�K�&�)kk����i�C�\>�VxFG��+��Z�2P��V������#���ES�6�y��a`��x8��V�?vV�{��Oz��|��I�@�	�q��+�O/i"{36T����J�L�� �ͥ�c� aA�e�X��@����s�$�d�:�K��T4ҏ�n���o?ܾ��p����@�l��4 ����9�c�!/�������i�Jh����v��©��_n�t����qw���m���6��*�Ԕ�ݲ���M,ղ��/`T�������0����z�
�)�^���6�7?�kGD��]bT)�L]X.�`$�~�c����J�w����RAI��L�]���������y��ү>��< ZB8	��հ�:7d�%��i���xaOI�('<��x�%�Cǒ�[|)�V��۵8������WϘ����t���ug��no�<��'8y��^�fAc��y�3�E����ݜ�pY�B/s��O�uc��#%T:��-VՖ*�v�S��q�B<R��%��Hߵ�֢4t����wh-J�AU
�x��|6nL��R��x�Dۆ�D�j��$�+6��:� hz`�g�Z����o]䀖�r�.c�Z�ʜ�)�xH��T�.�kO��_��J,R�w����K��$U1P�&�^��&�`)i�)�^w���NR�㮔�����n�QK]n_����Z�b�T�m{S�Z�b�f11���7���Ũ)�u�٠��>����B�٠�����
�r�4��\�R�K6��Ը4�Y+�Gcc��B*[��nT�u�l�0�j����'�?|�ݷK��	�H�j��R�-�T��q���H�lk�L���G��MI�"�����w[�H=j#]�k� Yn`�Ԩ�۰;'h�q�s��1�ׯo�����ο�Ͼ��r�.w?��!����ݔ:_��k�#u��47|-��bq���2'���R�k��fG�0�I#�AYx%����.y��v	�!�ǡ�/�UT1��|��	$��p&�����ݿnh2���?��=�cw�7ǿ������_?>����m��ۍ�<��o��P4�|��p%�
��݇o�1���R<���/����M��ӹ���gֽ:��4�|��� m/�|ɑĊr���P���T�1��,X���O�x�����Ά��W�v�e����>_bb�בF�^�T�c6]cit�D��|����0_��,������?g����nD��!��ʌ.l7��&�_:��o���;�EJ�c��� � �+��[��ʟ0���v���*��46o �Xhln蝢t����c��#���i�8jΗs����<�*ڵ��͡>we�(�5#�Є/�&���H��XvH���Q�U��F���nHbK��J�@��c_$K���z5z`�9��a���KD�\?9�yX��`���:��������*{?��������
_��E��������"*K�v�WRe��!ta@C�Y�e�i�s1+�P叩L�G̑g�I+��/-����w �B��.����]�����8n�+�Cs _�9i<,����>�v��W��+:iS��K~�ý� &��d�4;����ߛ�v'CX�3���
��42�۹D�Kba,�vr(FԶZ��@>��/;H��V�`�A����Q�Dq�iW�-$I�$	e�4K��������VբدXuo�%�y��:M��\���%���P���_��Jx1��&���Վ"���َ��a���qk;�=�ַhԆ�z�����$�K�F�~�ꉆZÂ`B�P��p����F��w�,�K(R�,����n
��~�_�����ۇ���������+\Oo@�'�kx#���sg�šs�o ��2��:��P���:x}-o`��/ ��]��91X��_�X�8�vN+Գ>˕�&��������H�P��W
�w����J�|N�~lWl巅(!�U��t���j0�y��;� ��P�d�(�Y�IO"Q-�s�&�4� ��>@l��e6�r��%�4֞�f�h�^W�I�ջ�(m�D�g*$�է���M	����u�ܥ~]���d5�VI���,T}$��F�}���������w��7��]�+U�E���D����(u:��t���5�ޮ{�R�[����������w�A/qNR߻cG�����������!����:�%Q�4�ށ�@3UL��*YIa؋������gr����U�f���ЁK�d�"d�՜��9reT�8j+�m��[@݆��׵�i���ĀX3�j)��Z��F*k��	�(6V�}]���u���e]��N����q^��0��1�j+QOA�f�
����[�F��d��hc�/�QZ��T��4dz�x\U렿��2tC�����2�#-���D[;o|Po{i��/�އvc�i�˿�thx�j��*$vJ���|�����4�ᆮ���}�F$�$���`{$'u�l�(��H����3$��߼�������c8���ː��Me��G�ӣ��|�~a��|�
�*눖m� a�t��o�(I"E��\�E'jkRI@m�_'DTE7��KT��M��h�jJTgU�b�mh*Aڃ�yU�]���ȅ>�R���.-H�b��r��kyib,����ֵ��47֒WU�z�����z���kyi���Q����>Ҋ�D1���Aij�A8�Z(�x��}�=����p;�H[��:�j!��ㄫ̅S��d���ǲ(m�������li۩��bXf�f�ꀏ�D�5���X�a�+�+�W��.���R��w��;��14ƀB!��Q�J��h[���p�Z-Q�:2˵�5#T'v�J҂|�ց>�dբ��d���Re�|��+'D]��8�>����-��>^�O�F�\��H��ͧ��V��J�H4Q�k=oZi\�4�7�T8i��W�"�l��)��%�['��qt��\�}q�~^��-@rx.��+��
k��/A�IF�(˚�%F뤗A��AQk�}sKo"s���E��޸��`8w�K��7l�O�N�{qN��2�w���{�|+|˽a6��tQv����������;p���7�/le��2�g�7��V    �Pl��o��VFj6V����0�����bg��p�2�+�{-X��ȓ��nt|a+#���w�KcI���`ZbE�M�Ə����c���iѨ��Q�xc���A�5���zi݀�x�� �-w��Ut�����y�˶�4E;G+ͫ묨��A��u&^:�v���p�\�c�/�~�շ��0��?u�͞���[9m����������$R�;N��!���ߪ�H�w���~���.5�.��^D��Yϧm�a/�uJ���{�EI��M3�KZ+i�#���i���T��GZ/i�_Ǵϯ,Z�Z��}�FI�ͧ~���'׺������6�Y<�M%��k��?��&i��=6
p��+IF�_��L��z_��Tg%i�hLv�����g�y��]�7�����&iD��u�_�jh�%�F8*����VQ��(�bD/��4r�wi@Sa@�v�g������w4["��>����6c���D�
��������N&��L�C����ç�����{>��z�������.�!՜��]��ѶWa��J1;i{�v��f���.O�NKs�a�Wv'UiiАF|�,^
T�#�+&�R���dR�ϔqo�	���A$�I�=���rF��[�8�3�^�H�4����2�|�ė���SʥH�Q!��t[�a�x��c�e��X��I�S���ĺa��c�#�p�/3�6�Y�����e�|�Hz>�peV�2�}6�w��s�"nm���{��bv<���{$S�D���H%�϶�,�-M$R[��N$��yW`�v��-N=q�h���'���"E�:��a{B���u��Ѹ��Q!/��E�=I:��� o�7\������ԕ2?���〼��������ǟ�gx�6�"sbѦ�,�d���e)�z�W�J1��g\T��<���+ŃW�*J� ���+7���*Jk@�`T.�_]W��ሔ<�{����,��A�Y)����և�NE��(��,J����!�}���H�s�[i`ú��>��- �JwU�����AQ$l��I�F�Rz9�|9X�]�R�\�,�]�k9����q���dMV��.�E	�k^��� �����Ӭ�gׂu6R6t\�(�;�`�,�Х8�6HXӥڮ��%��3k� ��$,��T�ͻ���s���$<����=x�~���3|�C� �W�qez�	4}q�d�t}}��Z*,�`ͻ�{}+�ͽ��͘����BRԈa����!*jY��cdR�'��>d�V�f��EI�=v����l��M �_�X�"+��P7���%��|76]�O�~��W�oc�^�!��+��F�R�WU�6����Mj�|���Ϗ���Ƒ;Kw������/�����Ϗ�����]t�Q��7�<�#�ecF�mG�h�T�ֱz;��G��Q���I.[Ū��K��%��[Mg����"��:��@/e������w�NF���3d��>��.W:����6����7�V���X��󩤁���ByN��q�-p��_�c���u����T��'�`�l!�|��Y��9���.R4�����wy�l]�d��i�����P�;mQF7l�%��J�М�I`���!��)�K�@Tɷ�l�d��T��&�z�u���T��P�n�t]�v5<�Z�Tg�P����/����@�����|����ќ���,�=G2~��LB�Wh�@!4cl++�:P������[���]�%���*sX�`�au�P�\q�t�Fk[��DC�!�xHKW�y*a�ޚ;vo&��猛t���
�Jz�:�H衼�����P��;�n�@��p��|���M/��v�/@I�z�@*`�^]�ɛ��Ҩ'���$�$59��$�c�6~aI�p����w��~`Ij`B	�hH�LqH�<N�N̛�Cj`����i��I�&�'��34f-�Z��t�3�����QZ����ٍ�H�)�K���w���@Ǻ�ax�k��;��1��7&^K�\�)+3�]�;���Th�D�5���ݢ��^K�n�u�g7��6E����浴tې�7����_�4��ϼp	�����>���{�s��0��U�@��,
6s��=�1��C���wo�z�(�<�FH����ڽ��Ja��ZR�[	�Rq<���Ro�Y��Ӏ��3�Ma,&�q�^�B���~�]�ǛB}��zp��gky��Q��`�x��Zo
��H�`�/z��.��x�6��
��� Zw}�Z���v$c����b2�qT�n��CU�Z�B�c'�	)M�������Wա����W2�ccHa~[�����,g��zc���6�E�8��#�T�T��TQ�P�����KI�$�{d��r��ڦ8�ȉ}��b��j���>*�L�D�t����4Q"s��B��e���VK�1P�4�4P��P��?[�|��O�[�w�4�r|�නP���\a�j�6.��1JO��[����$E`Cg����v���n��W���5�R�W��=S�w� i�M��#-�����؎�[+i=]��
W�u���3ٍH�i�3�W|hz��KXn�៺l�hzlx�)���H8;C�d|�Wѝ b  ��'�Q7Q�p�;���l��m��KB��2E~g�)Z���Ū��~�b��-.����@U{]4���Q�ֱ��<SȾt�l����ϧ��f�6ͮ@��kl+���ga��Nb�Ă�7���)�0*�|kAMm>,��o�(���4��5v��<U��{g{i#1�X���^�HL����՟�6�K�n�yi�,vCR^n\�v1���/M�J���F`���9/3�r�K�h#]�:�!\�Vo��nO���6�V[9�wن��u��`Ɔ�.���Ɲ|{饡̯C7��4��?������7�k$Xi�(�O�Gr�M}~?ڑ�$T~�gH���y�釻��Ǎ{��eȿ��R�"<2��_!HCH}���6j���Y��57:�i���4ΪX���a'�4k�q:�+�A?�]�ba(&� ���Z�+���J���n�3�u�AР���׀�0/ٗJ�ɵ�P�ȍ��(��7aao"����A�7a,,G�{|�R�"����lg#�Y�X؜�E�[�6�0'������6�0�2V}��07�fca8e��x��@O}2B��Y>I�u$53�C*o�b,O�6LMv�ra$AӍ!	Ѵ�s���%�2���KC%��c�Y��ٟ�2��@S�P�;=��k��(��
ꭤ������%'��_`�Gn��/jD�/!,M��4��/���L����8�8�;xk��~p� �^	�rf`��ʇ�_2vQ�*A�~%o�BӪ�vu)�U	�R^ԧ�|��vdZ���M��о�����B�p�c�ga��`��%��c]bc;`	��d��(�.=�Q��l��+�� 8�P�hjRo'q���/��4.eܷz}A�#�/G(YyV��۲D��}O���U_�E��A:Ŵ(!y�V�U�)"�x3#���Kmv4kܜ`L��oSe�`� �Ꭾ��Ԩ���fO�t�F�T袛�Y�6��sR�\b��nu��L5^�E����@QU_{�[)�U�ػR���S�]9vc��5���rc�M�f�j���^�p���֍]�8�Ph�H�םr�Z7��/�_
���$�%;�T4o5c�V�b6���Q�ՠ�=�:z�
ꦀ�\�^����)�|�*��0���D8u�5R]O7S&���'
�@*.���W}z��+��3ɛ�@	��djJ��`IC��]M��r+h��)]�2��Q-�?��{׍P�|���2�`\"^�P-��)U��W�Dj،�<ۜy7���!umW�Mm�*n-+�1԰��;Py���`������Lخ�/X#a9��Z���`�:����ڻ9^��C	a����n��|<h�^f����4<$T�F�j��K��v]B(a��?u�m&�Xb8�gn��$I�H�b���ԫ��t*�թ�M��^�,��?ӿkV��y�B]P2���]N�g��F�|O%�=�U�u�e,(Y�e��5Uc[�8��2H���	�<{7ԅN�������^b������g�+|�    ub@fA��^��〡��o�J��<�`!%��������~*˸`����D��v]c���<m�?�Pb`��C�9g�I4=��d�,�1�jv��Gw�G�a�815_+@�a<����w�ۻ�M۪���Iդ���1Ў)��?��v5����Y�(��^����:�vk�G����J�МVf�4�tdM�|��{�^�+-_!R9�W�
F��	!���y�� �v�D��(߀|GE���y;�
t&��
N�r���
����
�R� �%G\\��H�K�����vW�#8R�k.��=���� m/�=�jN~��z0Q�N����Uzn�@�f/?@Q��wS�&��M�u~�Q�Cԋ4M�w�6�4:���±?u�5u�O6s�?�n@�6$E���g��L�{��5�ס!N*�駱]�N�C=�B=}u.���$_xh���CA���Z�tE�`�WpN��9[&o��I?�����R���{�w��O�*���@�i�#??R]��1I�1��m⒛��D}�HF�9�4F��t~�&��
H$�i��Є!�����:�&ɷ�)�
��!�Z��!oԩ�<{Em��P�V�M�+5�W�ȣ��ixB��g怮�)G�X�W;	�*5��Q[	���9�4�,O_$NPP��ă���Q�"�ƵY%���u(�NM0�";ia���`q<i��}������Iw�O� ܙ����zw�����?���9��@�MB���1�!����������MaL��s�0!-� ��s���Y'��ތ��8���[�d�h���貢&\3;�q�"^*�ꝳ\^RP�i��&�B��n�W�L��S;�ab	AΫ-̇�J�*
䞍z�>x2u9���Q���'�w~��� �p���x�w�����D 8�Ӡ�s��E@	��*�*��mE�����G==;{�x�BM^W7 �^s��D�O��e���W�I+�8�K�n��;2k�e��W�Ն�|)m�*��uH�����?�A�r��-��0a�,����l� R�*�&�7����%�}w�El9�)�n(�n�a�3D%%w�s��	J�H�B�� ״�ъw�)��K"Hͱ��LW8�_Ǖ��4,H�͓�����k����e��o�͏��%�ӧ�嵁�)
����A��g��m~[�҄`WV���Z��<<I,���ߜ�c���f啠]�r^I��^�F��K9NJ��[N+��Ů·���>~=�#��>�������I�f_.]a+͊M��b����m�Xia,��3'��g`��q�N��:�T$�D8*�QNO[�ͅ$U��~;1�嵐R�<���zug�?|�ݷ�J)ɞJ�0��QE��N�l�nÍQv��uOiݔOX}
�B%LO}[��D2��\WV��!htz@��V5��Kh�ޯ�fk���8��"H�j�b���
H��y��C{�^�	?����ߖ�yOY�|'�|N��{�����D�a�Y{����^br�# ��������b��k��)��^���F�R{��������~�|���Ç��>�������.�wa�Q��_5�c��L*�r�� u%��6�2+����SW�]���~Nϋ����*$�e����
jrw�ru�K�x}HV�@����5�}3�]����4��ED�_�O�S�Nt�t��� �d�s4�e�.�����'�|TwZ&��$-5�T��*�-JZǭ�ן���-a󩘚��֕���
�֗��aIA���6HZN���}���W��������~]#�S�'�ˤ!�1JBi��^ڻkz'�*���%��b�靤����Y�5�=iag��_�5��4����ca��靆��tBI�O|M���;�4r�����|'���N�e��w���/�o\�;%�N����o���+���@��^��WJd���_S�2s�������4x���n��|��sI]��Y�r#i5ڀ����ѰeT�;놳/��$,Y�+����;�>�64�&�$|��7ǿ��/�_�(����v\�D�o��<_)k��o�yD��3�T��"��opz8�X�#i��K"���������%�=�W�wv=����e+
5!֑����u��{ʢ3X�����H�D)��dZ�4��eI��ul@3_/�� �͉��CT#[2�d���>>���>��x���P*J�Q�}�S�H��N�%Jv�y�u��&�$�/ܢ�%��:W����@����d�P��	7̓T��s2�d�~����yK�HK!m_�@|�u��K���p���
,�!<�q1��:9�k�O�	/��i�>�/+����7g��Я?���7�s��e�$�d_�R��5X����p0l���~�y8�k��q��G��曗2���������v�9_S:��p��֠Э7�l�d���H� ��W���AjPH�oS�T�R�R�N�i�E#�ԥtNʛ���du}4T)����o'�T#��V��y0�X]�J���\�D�v�>�����'H��:0{��Y� �j�xG��k�p�'r��+]s�Y��%��g+��T.HOG�c�8����E��_��u=��Ǵ�2���'�l�L����8�$I�[�G�u".�9CQ@Xͅz���H���I���B�\8R�7oDE	����L�r�#A���,:�.��ۡb�`�{ܶt>�-! l#��:�|���~:��p����jm!�h�%��0�gc���_z|[�T2䟣
�v{�ia#m�g��;NxH߿f������j�����.��n���Ȭ�d�?��� `ݾuCu���禵6��4KΚh�`K�|��28� �n�~<���.��QT�)���|xÖި�%��J���BH��V�o��Z�X����K�MɑM��-w���vF�}�����.[7#��\VB�~��0��@Mv]��Ϣ�wetl�aL���Α�����/����E��#ME��`,EOW�ӝ(�6�M�L��|C��_Yy��I� ��a�۽��T��P0���Hi���ጷy3��$�ܩ(�N�΀鯈-(k�8orrS�Ţp�#r��cs�'���K Kᏻ��3�7s�U�,�Dᜱ㜌>�v҈#I9��#C�I�$<y�5
�D-�8�ܷ�E#!�~��a<�G�����=��p�?o�Q�ܣ��2����Fe���.�m��dġ�L,PS٤���$��K�WRt%��KJ����_��16�&E/8�h8�[�Z$� Y���$JCibMk�T�PϬc�p;�4М�M��G���rC#@(�/ps�&*,A�|�;T�.r��d�Vd��H�"�r��
59����0q5�@u�7�St�²��5��c�}>� M�|��߿��p�<�lJj�	Q�q5���q�D'�)����8Ҁ�0��]UӵL�{eDĂ\��{�̳�4�VwKT���4u0��t��8��l�F��7g�P��9�BY��<�]�,6J���$���)���������SC�fyQ�$H�J�S����K�B�Y�̐J�|<UY�m�^��3D�X�Er�2��D�<=��nU񀄉�;:5�j����nʍv�P�F�Ϣ1M"J��+��5(�wi�ݚ�&��5͒i������=g�@��T�
������:����c�u+��WB�1��aa�^��*̏7��K֩L��@0P��+���E���@��δ2g;��yeٝ�M���+ E����/��h�-�!����C�sDɀ�Ҏ
"I�����������g�.�`y���}�R'��w�_�R(����b�E �"��ξs�s��TR)Z.�}N�ws����/o�>�~,3�on��.s����0�-@���޳N�LG	�*>��Ù�f6+醺4�w�shwA]7����^�.I:$�OK�$�Q�.�����T�(�=2#ڡ�N�mH��O��C>�XG��Ͽ�5I;�eg��q�8ˡ��ѓް !,��X���3���/������Q[+�r>����4�L�zE8N�QFV�&o �  }2��d��0�Kd��M!
��ڤ���+G���SMe��c؛9�Bv�R�#A��@�����z�GO�Z!;�n/�$�<q7Vﰝ8��0ٛ)�6l/[��	g'��*WBP �Uo(ԽR$"�rh��ܰ�4C\rA9Z��%Tx*ѫ�c+�R��.	:t48��5��E��O�^KD�����AGeMЍ(�H�ȣ�w"����mө�������X:��=�� ��\�j�d�V�]Y�+y@�:|S�z��{��q�^�Xo'Ag�#Q&�.J:K����|�`tǦ�L��В0pO���>:����7Vl��(!hr	θp8V8P���,���6|����[8HU40Dy7����ɪ��T��e�.,�M�������,T���;���Z��Q��P��n���,ŧ�� J-�x��K"�m�8��J��͢8���<XjUq�6���|8u>�9f��$�L�obk^ߖ�:�YyF�^�I�=w��,����J��.���e�.�X�����Q����P�v�p��>N�I:jF�Wv�HF�e�����p%�t@�l��'�P�Y�>�}J͸�[��@t�=����5�ɕ`��z\�5���Y%^:^��Ƴx*�3�&I6E�x0���fOѓ�2�aΠѺ��˚&�
��|>��0X3�g�0@��ǔϖi�pS�4u׏��$�v)Fے!o�v�ZF;I`�!�
����u�d{����0����������ӥ�3;�R��#�/��ǩ t�`�p�0��:�CKGv��p�ST�E	�k�:�<	����Ԉ�@�Y��P�V���J���\^��a���%�K�N�G
������z�5��y	n��~�]��u�hf앧��I��_oǓZ) �ϙ+Y�_�(ՙ�����A��5����
��D Z0P[� �\������.����|��Ox+Nv<����C��كz�i�
0�k�#}�\	�M�hbj����Q�M��Ԣ��^�+^��P��z!be6�I��)�[m���QV��hD�.���x(��� 0��̧q���K���������P�F:t�qX|;����Iti���}	F���#p�W���d�guA8V&�z�g�</#D��)��Dħ"��0Ibq�QL�/�'���.v�W)d�I�������F�P�:F&n(��"�W���zΪ;P��R2XV!��7���~�����n>�}�{�}x<<�yx���<JD��D�A�\�6�6��4l7�V��f���x��0��o~#�:M֯�;=�\͸�����M��cu�N�Pbɑ}w�+\�#I�H���mo�®�̉1q�~g��/���Ե9������tk���bk�,Qzk\}h�K����A����qN@8�Z�o�,0mu��Π*D1F_7T��"n:���^.����:c[��]�Ȼ��~�Zta5\����e�|~~���7� !��}�����G���η:�z[>�1�j����r��x3�7�ˉ��	�
���Qv���nx����ѦA���m%b�k��s�D�.������DtZa�J���F:n	�.�w��P(W�ڴ"��βe��������~<��$"'�>w���4�;�y�|��и$���(';ohcC��1��`�'$��@�I���-|��D6M��T���|~�
�j�-���N���E,9�y܊�p��J�f���ѕ�w��\`gx	�����R]"�{����S*M䣬[�A�yaH�!,3��B�z�'u�O4I�� �f4I�ٍ�X�e�K� �d~:��]1���j�"����F���7�+aHg�꡾lCxI`h��6I�)���ja�q��e%���t&4�;�T>?�T��S�BY�ւ�&�E%+���_o��t��.n�����������g���ts��s�Ok0o�u���������`RV�QkD�؝�B[�%G�Z�?�E�\�G�r���4�]s���M-�,52��e_�:�T���)mw�-�4r���}P�o�2��0�Njw*�J
q���tF�{�����ʞJ��}A7��z�3�l�}���CI������q��YI�%���M��s��rm�(��w�K:�y
~����;�a�tQ�%�	�}|�I�!R�����KD���\� �hy�nz!C�����N��o�(h���ӏ����ՠօ�.�B���j Gs�y�eἄ��	m� C���f0��uI� ��*�U�q���=�O	�N5Li�~�#��T���ӯ�考`nǤ~Y`G�Ii�}D�E�LGE�Q���/&��,���-{YΠs��[
�>��~�!�х�
]�.H��'̸��"�<_-D�.|L���P�ژ�jA��c��q´Fұ!�f_�I�C�>ο w 2�8Y+��w�B�X'��J�.,��%�rs�K=�9���u�A `��5;�`:G���R��[�%[5�N R�gG��������t�;cU���I�L��A�-L�R����e3�<;��-��%�KV����zj����,;��)�?�o�I5�N*hgٕ߅W��Ξ<)�-{�Ϡ�v�����x�.I�HӘϷ�?=��~<|~8��><��Ǐ������)����EE�y����������O\c�%�kI�x<\��4TJ�zc�/�r$�M*�#��Q�E�G�/T�������;�~2�Q��&��d�年s你�
�2s�.x�P�W3�0��T�Tz�OM}1lu�R7�ý�i��g��^�)�:�u���f�Cu����v�q� �(+$�Z�_�%��vA�`%�5�م������4VȽ�����?|�}��������z&�bk.��bK������Ș�Q���K�I��2��B��b��{An9gk]�t�P��>�I�t�r�q�P&Q:ǭ�v���f��l��R��WA�%��}�#
::���5g�YI�x�J��t�L�}�n:F@��s�Ö#|g0H���'��
1JD.ta7-7 &�H�A��E�u�RI����4�3 Iڀ��~H�iGIk��>$I�cH��]�NJBŬj��=�$m�3\�g�!6��]��Ro:�e��+��,�}D[St4� ���⼐��Ktw�v1@�tٰS�����t<�v�o�cq��"p���Գ~��V�Y���0`�5��p�}�]SQ{A�J�]������y�Ru����T� ��E��$�(�FY��O�hAgx��5�0d�:��yj������p�x���"_��7���7|TaH��������0(�<{�Sm�.Dh$rgM�۴�C�F�O��G�9l}�F�%r�	]}�W)� 9�Mװ�9��-_��ЦM��-����R� u��OF:ho)�Zٱ���a� �Ժ4�5�s[y��uAj]ʐ�*����E�:�q�>��ۃa��b�jd�2�ȃD��m$�6�_��&�

���Q���2zd���1
�=Mўkbu�ߧ�w6M_��@=8e"�/�4}���	ҝ@�q'��BY�V�8�,n�<"�WÞ �W����q�Pp���j��_�zzx~�e�����C�_���4|ɐuG�K#�$��M�%��6N�Ԫ�'�Ԛ�$#(gf{��o���^\�O��
i��T��Tj!�n3X�(�KF���0;T���#-v������-)�i��������?��,      �   �  x����n7���O�=�r/��@�"@�"��C����3�J&7�q$�Z�w�3s��p{�~zf\,�������}�|���K�#���u�ǹT�A����>Om$JY�B{ ���DW���G�&��N���OsY-�ZT�EθF#�����۷��#�㵕}5-D!ʋ_x<�<y�?��ߣ�"��V�U��&!6e$֟"Z[E
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
�|$�u�` �CǾ$�{D*l�CA�&��y���GQ�KV�t�P�h6(����]6໖Z*�����k|;n��zR֦ݛ ֵ���I�[ ��K��Qqy,��(���۲;	@m(z�u��&҇�U.�P/Ŭ���}� ���}��y5�xX�N�dq�ck̶o� i��:��$L\��}��ix�-�&l�	!Y3�@ϫ+��%.g�!�A�x\u�k����n�����.��A�!�t�Oۊr��'M���N�~/Wp��=�v�@�s�������>��|xx�p^Ey      �      x��}kw�H��g�W���y�	U���JF��Hڽf�Y$���$rZ�OO��w�*@�t����i�C�����+��y}��T�m���q���$������$���x�oLy>N�fܼ��t�W��,��Y坫��3��b�j
_����d��3����2������1��J�w�8MRs��ַfV}�3G����~�<o*�����a��?�\�lE�Kf_ڶ?�/�<��U_�7C����p�yo��:�������Kj_:���q���j����>�W뇧���qm0[܅/㿍�o~����/���|c��|�ͤLyny��xq��s�r#>�Ɍ�)G��Gt�"��K�g�1�V1^0��¡f��Y\��Pm���O���������v�� *�ًaT�QD�q{�Ĺd���A�Hz6�. �j���F��բ����t��������bѼ�|���U(zA]=|�������Ͻt�y���V�$i�:�h����b��fγ�Pi� �9�1@��>�ݫ5�+�Mbc>΢�� �[���z7{�_������'õ׌�w�����w�Y���'��u�D���!~EQ��-�(�<H��-P�:* }���B�>�r�4@��܁$f�F�b@nn��|rã��JGAp�`g��&w_)�3�)#
�!��=L,�E\߶�CJ�S�Ԟm;`޲E-��.F1��Y�Y��R\ �����k����c��,@��T-�$�쐀X� ��F��,4�,^�	��!hr�{���>�3�U�?{�s�6ڭ��;8 �'�7���}�o��HK-���� ����W�W�zlP��Ql.�U��j�y���y����D�yZ�x�{v]�8SZEϱ=/��:<Q'�4 `Q��x�;*�)0D�>�֞�p�P��?��3��;4o,;�%�:V�\6�z�����mu���$m�#>oT6Gϑ�s����J[2]�p.�1%^¿���퀇����$6sŴ����+P�bHԪ
���	aC	����M|�W
��N��U�i��%$FQ")�f
�'�|i{�W҄'</!`Aq래�x�{M_�n�����,���$?�|�vg^}{y�|o<�o�����r���T�]׬�����bpʎc�n�l2�9�i�b>!�̇���S[���
r=lp�3{gg9=�J���M������d��G�썚ABy�����d�H����;�`Ǔ2��8�)��b��~G�O�Ɉ�U��.�O�o�%� a7�&ăЯL��KsA$�Q`���AQB�+@*��r��fu�6}�6�8.�vXM by	�Q(�x ����￉�C�:��#���i7����g���I�1pj��A��-"~ӹ��Wզ���`$��j��zjh�|���}ԐP�/�H1/Y`�wBe��Տ��M�F]�y�Q|��y��H����lo1��b���Q�"� D����t�qҧg����%f���� rvxi{� tJ.M��W����x��dPچ�pp��Kt�f�g�W�[�tgڻ-�9�Q�.�\���>�c�t*�9��`�J�Uhr6��z�%�"][�v֏��jb�Y��޹���8���be���ꑜ��m�%��ՖзP��!-��/Z5J��r����8�"g�`��u�+���Q&�0�}A��7w���&p\��b�1`�ĴC=�(��Wd��w��"p�MF�o��U!�ă»��E+�������4T';����k5@��Vd��~�خ�2���L�F.�q/�}5�'� 1K6�U�|(�CW#��$}W�C�Q�A�5"�G�J�G!��y	`xIl˧���h��v8Lڄ��<.:��2o;%�s�[�(6����A���h�~��������;�80z|�t(N��4Z:5�'{p�o���(�G��`�:�� ����YT@M���v��{�i�w�� 7��)�L�>�1�x{�˦�@��
�T�^�D�?�#��ItB�R</P��r���O��8�!<��v�c=��_�/�lٲ��I�e�*��r�C8�����m�	�)�E���Bbԗv��m:v�3,��x���Ɍd�h�<�֞���:�e=�.%�#�Q��ƻ�HV��2���B��j�(|m��*V$�ਐF�^M����(V�ԟ��{��FT���T\]���kOI=����R�>A�����b�geO�"�2��fF
����,_�=z�#�M>`J[�l�ҳ4��K�����g��ב��_2ע@�C���:�� :���{�ő���C�l�P�����9���xټ^��V���Z�����G�.E�%!N�>GC�]���7���+���zX|]�>(�R�����!�q	t�@��8�X��R�:�{��Ϫ
���C��D"�F���c�0p͉"d�^�����5����m�ߢ���vKY��k�(z��ӆ���8ك7�����a?ץ�O�Ƃ�����L^���Q�W����{� y�^�e���մL�9�����x}>�.��9C�&�f��Đ9���Qq����{��<��]���"�?�4�8��
��%�������*����87?���87>+C��ǻ�[x�f!ky���s�(�^V��F�����٠Y��->���}�-.�1�އ1�U�C�^�8_��Q��X͕{�IPkc��U���j4���7Wf�Y��6���e[�띞�6v%��"޺:]�E��5գ�e�jzZ��8����x�7�Q�,1��4�ظ��}���c4.��?N�n���� �y��:yg� ©�ix���)��Y���+y=�ة5j�Ę�+vLm����|~yz~�~��a& ؂�Ì���d�1�fNo�v�	�/uQU't4���^�R[Y9�ׁ4�c4�J��6]��g%����p�)��a� ���[.��[I��=+��"���1v��ɛ����>D�c�	�D$���	
��|Q��b�<��H�U���cWWfR0�b揢A�ͨth���o�+�S�8��Q�Ϲt�Kǵ<[���9	�ʚ�Ek���<�\}�5��׿��l��\=C�t�����(�����+����:�y�wT�*�wd��(�����q���m8U̗�@;x]�+����5�Ǘ�Tf^���fV�Q}5fշ��x�<��^�+�"2kT,�<Ĥ����N�h�5~w=��e��WS����`>�!q!^RR
�u�	���;���/���P���8l�j$�L�˓-���x	$,�a����0���e^�$���BxB���ֵB�u��n��>ʋ8۳� Ij��a>21j�.B��J����m]d`��E��Rz��1U�^��銵B�&.�H�)O���j������Q��+ hS>/S;+�R$<�/ �F)�՗��v$�t�c�/R��:O��Ę���%6���sq����s�ߎ�(�k�"K~ �F�IT�>��K>����t��OO��j�!H����)ڝC��!*�2�H�����BA��)��3����k�F�%��2��8R/	���:cp����U?�6��9B�� wK�F�����tjPx	�26-�����D�����ض��z���(��ȅ�1�kyyF�6��B���z���n�d�V�ɜ?�Z��1??~�?1���g�]f�ziGZ,A:�߃e�,��;h�p�;�n��A�딨T�g�������jW��`+�	��<8�a�V6�r��^�o0N��6��)u�/��q@*}����V��xj/����С,wF2!B*6�OՓ�>�C��7����{���e��ӊ�E��Z�ݹ���{j���;�	�?��61U���M෇$3f9&��������P3�8��Ge=���4�WO�i0RJ���?���^B�� �V,��K�)�Mm��#��^Y�R�ث�pO    α�£�sp�py/����Nթ�aU�;�Z�d59��M���=Wf����[F���vv���ٍ:�Z�:��Cp��E=SL��n��`A�@v#mcQeQ^Ģ8�����˷J��l���-E$�\kp�`��i/FNw���.tjuU����p�J݆�	����v,�i���������Ơ�e�|�)�d�%�А�:~�����N	������og����R�>#�n�jjB��],��O�*jxi������rS�����#����B�[Q��8K �m?R/��$Pv���iI��0��[3N1Y,�-��=$�i�K�ÞW��iM6�f!(����T�����L�#ɞ�;I�l�Y��g�����M����o2U*>?���GĮ�.��M`n�sn���;�n�ES�qe �d*�c�Ã׸�n�\�_ұ�}�?D1��S� [��X��=78�~��֤ ���y�/l���j2���p��x2F���4 k6EJ�>&�ȾPK*[{� ���Ch�'�j���V�(��h�ʛ�9�h��$@���0` NETc�:3��V��W�pH*��ݔ��b���J�;l~���@b�_A/rI�@BT΄b0s-͂�]�?^6����86f �\n���x�R9jO[�3�Hp/P��`�1a>y�ڀ�~B6O�gx��� ?l����?^ �lk~O1ArO�7ܷ���^,+`��p�N��vL���vd�����r��\f.�s�8.>c�0 ��|]�7����6X`�U�� ��I�K��ܙ�S�5����RnR�m^byv!�f���~��Qxߦ�c����.�TEN1n�u�p��kkDH�BÉ�A��p�a���(�O]��	;To��V(𓾕�������qΉ��½����q�,�V����(�L���@TŇ=<�����;�Q�� D.M-ק:�h<퐅T�y]��O��FWŰQ���F����n}�R7����mm��է�����1����&���N˰�RvFCe�.�*�,Q�c�1A�S��v�f,�`,MN6y��?6��wSv>����u���t�a�`n`��ռ����=�~=��3p�?2B�>���ܭ�(d`��qPk������K���3���܋��[�����0fP�homry�	���"�B���j�Ə
Gr�Rl��@ر-F_�_�&�׸�!XiL�)���U]�{�=kM���8�1T��*�~I�� ��icnY6Di6�hY�X7:���t�}��f
���u��m���J���f�l�DJ��#��^��(*#�2=>m9�ۻ��	���ˈ1�?��2�A�1�tc���,.�M�J�}�瓳��v�Y�`��:p�A��{L*+��f�������Ga�:��K`{Ԙ��G��Tݚ?j�9ݼ<=|�{���r�a�%��I#��ݣ6f
$��[�`9�ؘ��҅�166Y�OO�B��=���t������)Ptq���h%K�8�Ӽ���T%�t�e�Z����9B�r�}��'Q��__�=7���)x�>��+�^�0�[a�x�n��r�L����i��&�E���������A������t��B=��:*PfD�N��pe�0j�^K�ⷭ �3M�%��D�D�)!�wmc��YW��Ob�w�ň��Dc�q�"���������#���Ī��=��Qؠ~Q\d7`N�3 ��.��0�d�G�0�R/lh� 2�Ѷ��BgqZo|�OYnׁ�Q�z	����t��K;��1�b��F;A��5��� Y���O��|�"ഞ����$Z�Lְ�q��Gu�l�W8۬dM��D�pم����4L{P}����`u#��i��[5X�$��B#�4�W&.Ùc3 VAc�@�UvF_����|c��cs	2٬^��E�T�򕽨�-+U)9E����y>Q�2\7����_,������ 0��ˊi���r-])��@0#��R�ϭ��Y (��h�ń��z!�3���ܯ��\�zl�~6�Qa����,P�
�-�ROOƌz��g9�s�sV���H�¯vf���hyF���t��;P����d���va!U���Ii�"�X���'9=fc��񰵔��bJ���4N%wȁ�B����@�,�s>7�9H�j
v~�����K�~��n%�,*'��|➋�&������"�eF�Uu����Mb?pu7�6e�?lE�>h�'��n��Μ�L���. 
�-j9���tf��Ƣmw��ɣ��u�J	�2Ej[�`�;r�=$͢f�
�~F���A��#���m�A�|Hk}��I����V�,Bq�f�^ �n�:2�$��8 6�(�,�s9Uz�
�!�$)|e��U�y#��f �А��s��ӈ��`�Z�ba���*IRf��9-J�.�נDqW��5���´��+�!'�=��M:�O^��t�U���&q!�����������QR?�Y6�l݆�����0J��~��P��	.mk��"."Ŧ�洬�3/��ET+d�5�#�)z��1����! ���a6#�:���������록�u�U~�s(����As��3~��m��Y>�����!�t2w�/Gxfl���9�h�<�	���?3�&�X8n���{|�،x�7A����IuDG�h���{���<6[���>M�#&���I��a|�¬��xh�%n{F��9��K������4B�E��Q�+�����:��-�]/�G�ԺX�p�=�죞��:ؕT^:��8��5���c���PG�`����ZT|�`z88�`j�
�g;�f��	}��G�	E��з]�k���&�K��si�f4�8U1�b,n�@�7��u
t�f����.KG4Y�m�"#\p7�������QҢ\.�8�e�~]�y�-�,�툧� 7WYV;Np	B�*�������]��)���O��G|%rY�����R�q[���cL*�J��2۱�G��	��s�|�`�'v��j��TCW��.lv��i2-E�D��b���[�s#^�r>��y�=M�q�U3յ��!��`�た����[a�hѵbݕ#�#�9��v�	Y�t	�,��w������yu_=0Ʋ�<ݿl j/�,\���_+qx.����,�h;�-�i&d;l)�q;XK���4�6�c���?P�󪋴~��Y_i`k^Qz��yՁ�=6?O�_��I�&^:?�#�.���.�~`t��z�'�!Nb�x^��!}5��Y�w�U�H ��� �sp�C�ur�#}9u�~5W&3�nCN���	��0\Y�6Nb�1Y�1E[��BȈ�8z0�Y�!���Lز4��8������%������L��D`}�v��.xq�g7�f�W��N^���1bg,�>1E��]���L�:��[$�r��t�S���}���>w���pw]4����ε�3,q�T�k������,S�T<o(�u�3ǂ��5�ˆ� )�@��:���&������{hk>���+n���	�����
����c�Ak�ݺ�J)��X�`8�Rͨ\n%/����;�Nq�	a��sUݧ��K�z�Tbu~�㿲y�FK��ʉv�*ؤyƚ~�UvO7ۥg<�T�_j+�X��c���şo�OA� �r���z5�d]��/�)l�2��8�[����0aR����R>]�U����	Z���X��مЪg7[�S��E�82K�6+W���u)�S%�2�)标B��7Qu$�[F�y`� a�j���ب"��^�}�����?�,�;���9n8�ϝ�m�N:��3a��;D��2 ]���~��d��+	tQb��{)U���DN,L�_-��#Nl@��{pg[�lAq}����89)�5�(Wt_�e���K\�I������& u�sj���CQN0��N-|�� �s��fb��E��""9��ĉ���2�kfL~�)rbcBP4�O/?~|��|�g���S9؂He���H�/�`���8�I<�"�6[E��X>��ӄ�R�G����
A 
	  �~�x��LK���u�PTMx$v���]�Y� 2����G#IG&n���"��i���tѷ��@���RO��z��C��u����v�(�.F��+Q�[8e�$�"���B�H��n�J�:���q��Q����<M�r�#�Z�S ruCu�� ����*�v��w�W�v�Nɴ����̷�4�`vg
c���y�9�@q�ٮ����l؟��M\��+ �)r)�C�ɡ�L����d*"L\�$)��B�3dT4
R|��!�����t?t��+����,+�*}�������H^�3�'�E�	Qښ��vjA��_���m�:H��͓eb�=6'q��Rw�ig-�x��竒� 7X�e@(z8�gC� �=��K�[c���
m��x�$;X~Q�Wz����<#eQ@%x'b�����S��v@� �s;���kӱ1�������&뽭��~�a�� ������Nu���c��/�["��8>q��,Mc��q S2�\�H����6 ���;cy8���-ʲ8b1���:�L%N�*x�k兺gVm���t4?D��81�7�@Fr1+��� Q�E�j��R�G"��e+���n�Oӗu-Z;)�\�����O!�lB�����%�2[��\Tf0�'y#�z�k���	T@��y�_!���j����	��=_=�ڱb�pHY{��Wᾉ>��������5�o���������C��LJ����D�H���K�s��^�v:�A���ã�@-���W��tDl�|_#FUlB0. n6�4\�������=��GH�G�σ�������
�a�%��.Pi�\�0�KȱYb|��M�
}{�OQ�q�)�=hw�W�|�,Z�,�� ���(��a���*���m��ƃ��X�������)��c-X�-J�L�(�I��d{p^��O���Y�Ч@.�I
��`���G-��
>ū�.� 'Xř����l4|�Y���k�n��v<54�8P�4p���laG�TԵ&d8j�5D�M�X�A�@�Āp���ɫ;e;���:؉y���������o��>����b��v�9&�:f��F����֕e��Ef�0�?w�������(�&Y�wAP'l g:�(�ޯ�2�G)�����h�Ӿ�	���e$�k�n�����\>N��?�Q�89���*�8.V��,���������NAe��p�@z<�9�q��e�p�}����B��8WX���5k�*pʜ��ү*v'V<�����������p��T�`)�#�{B,\S�.�kr�� �������Z+������j��y����a�L������?[�\k��Si`;�����/��iC4���S���xl�1�rӈs�����o���˰B��z�k�:J�Ϛ�k�$�#ѓ��{�=?t�3�̶.����E���� U�R��.�i��R�7�`��{Fh1e�{v��V��P�u���x�O��f}��ow�,ʙ���{�C�.W1�M+��w�o�],m�%�t�J���i�����n�L������$�n7.��ߍA�[Ycœ=luڽ����,�y���GM7��E����L9��_�z�8QMߗ����+W���.���/�_��xp�A3�}Ɉ�Z�	�V���N/�.���@�b��M5-˜_��9W���]�S^?5ō�{��G5l���� �ߢ^}��^�Akؗs|��z������3�l�����m)����.)qzN,pl�uAD9�C�9��^}>�+Y��X��ۣ���ٰ�����,|���ۮ݂����P��Fb��&��i�ޢ�%�*V&H1%5AD#벫N<$��x��!ןߔ��'��1�s�6������X��v�au=s���5@�Y'�œ�I-�͹j��
��v���j�c��9��lz��݊s��91�	���#�r�F�-�	�����DM���v�b��8O�\X C�yzѧ%g�7]x�0�:H1t��X��A�'6q;�'���q�تСɖ~��e�7ե��w��h[IX�BB�q�:�<>E�9S��f�i�������;7���	9�z�G�^R߲u�M4ğ��࠸w'�����V�Y<�]�+^�?7R��mg���b�oRF����&�z��A���O���wqj�2_GŸ	�����
���C��Q�ۍa2���#h���E �~���z�Cݢ_����}�Ƕ�M��lu6r����>��+P�x9}ʰ�x�����[����?��x�      �      x��]Ys7�~������,"q�o<F�%SR�z�h��ȡDr(j<����� TuUV�`+l�Ru����ٕR�	�'����VB���Aǟ��W?���Փs�{��������_�ׯ����oo7�7׷�W�8]5Ϭ.�]^������>�F�6+�����?��~���7�x��js{�i�x}w��\�􁒕)���6��^?l������'�-�>���������}�u�������ժC_��Ëon�]�������cC��P� ��7��^�<v��4x߂��;A���ի�q���jam��%xs ��V	�V?lo[�z}H�^z��ʟ_,Z{Ň���r� g�^�x�ش��$|/R���n�#���o���p����Rz�I�~��{��%�S/?W��,��� �Rٟ�/3��m7�Q�8k������5*,��2�?-��>	|��
�K��z�߄
���ۼ>}���/���l��W���^����M��HQ�qB�l��4~��G3��oHif�֕3xUf�m����B������>_�|��X	�Yjh`����j[h!�&��_��n���C�Z�n�$l�?PPY�t��.��2��Hm�� �%i`���Q�1lf�f)7�h�U�	�ѧ�z��tQX�M��F�̑�>ˡ��/h������0���@�ʃ��e��� @v������KS,ŁP�C�_����L�2�o5~��G � T��+��#~�*��F���O�࠲��ֹ��C�W*��0ȭ1zB�� -��������#�\��{�K�V����_-�M�#�͇ˇ��^�@��C7��ރ)�a|%*m�*� ������`9�l	̐���?��~�B�;C3N)�G7D�!tPf�k��������+�:鉭�k2��6hoV�ۣ��G�Eh�=���͟�m�o�o?=����e�f�	 ��@��	K�vt��5c�a�#���1����`x�7(�;2¸)R��\��O��W�@��wz-Ԡl����Á����}�CU6D+wW@N�S9�T��R�@�
u�Ldc&��Yzn7�e�� tL#6:K����3O��WO��VT��^��'~{
��?���׏�.(�C�LI���[��}=-�Y��/J��`8~��7#Y������v`5驝-��>y� �F]���<.!�!���������2t��_<\c9,|ʂ�k} H7�D��mJ��/L�*e�%!}l!�e�Wi��w����^L@��QyZ������f��]`�2�7��^�/N^땕H���J���f������gF�8��gq��`�U2p�T#���e�׀A���&�^�b	or�L	U0P�@�
�C&�#�������9&�*Be4)�ވT��X0�0J L�H
n (�����g��`ZĿ����,����kK��ૠ���
�8�>�H�d0)~|-̽Y���������}"gB��#�/���b���JS��Z���Z�[��y��kĤ����Lh~�"�l[������+ܾTw�l~1�S��Po�EW�!z*�d����I��O�={����fw�ܜk�P�G�!*':F�ݶ��O��>����ŧ��:m�5�RT8���:�]@O/��3F�Tx}�|}�'{�'�&���TVh�����K��>c��;;�sj�`y���vO�=S�(늏[r���kX ��$�t�68�2��)�fO��8�9��@��jՙ4a3�>��Mg�_><Я��g��s`
6��I�����<T���~�}zlu���3D�5��|��02
�� �XMɌ ���0R�F�䐀Ke�����؄kl訊8N�R%vy �2ϲ�Ǯ�4�E�X�GeG���U�72���"�j�N7�7>����]�ȋf3�X�e
(��Vh�U%=�`s0_��r�P9��w 9f��.�`�>Wr��V�9P�C
YٜR-��ק�{
nM��@�DP�k��'??�����=z2�F�5m�1cr+��5ԭ����6�l98C��_� )ڰ@]�7WW�zGC�ѭO~|~�/����5V-2��"g��������\�Ϸ��_�^^��Dض��/m�̙�M�NfA�2./`���n��_	�W'{�DĨ��w�Z]\p����'Kp��Vܕ�������=���Pf��9����C؛Ak���[tH5%��?�����*Ag��뤹��_#J�s�B�C���ؠ}�V�ͼ�rX[��dέ��KML8W�I��6%u 5�vvK�s���&sVT�3G>��Z�|�Zΐ��-�h�U�`�R%�m2&��4A�0a��qW{W\�Œ���&;2fZ�\zd��C);�_dø4\�M�X\��E�t�ұ�1Ʌ�,��\S#�(�`+${+B�A����Ue�����B�=��kD��P4n|%qU�*s�.>:���qnIDzeY�
tmKQ9�]�)�a|��~sx2���	t��|
�w�,fIM�+<�%��m��sp�qM�l��$HYy;�+3�����S�A.��]��������5�^ʻ+�6a�4LHV�2�)��C���#�48apa��i�u�M�#���Ͱ6��<*�u�Mb뀔�r�=���e�f���>��sl�%��#��xC=|�i�6œU[o���a���/�Epp'�J�6��>X���ٲ��Ｌ쪣	#�(�.���sf���U�݊n;�{S�� �w��+y�dc���!��̋�c`��P���,��r�p�C��0�y�J��!��+Sd$���WN�LN��;��6)' XNRת��We����)���O����%VL�����NeZ����W�w3��i\�)aU&�����
��2�Პ�[��
�l�>�t�Z�^���;�HV{i*��\
�n.Pn�c�2��?�
i_D�=z��D�y���-��z�7��C�JFF�dQ1)�z�%!Oi��4�$>�tU��©w�������i>�<
�Z�b�C>�W��x}��x>����U��6�iB�\ʂr"%��S������+�ZppE����ZMڠ9j�A	�R[�Ҹ�2�'��`gx ���d��S�ƣ������ߋ�di�&1�n�UrV�8�fs`j7` hO:�i��[�e�
�-�(thF庡{��dR`��p)n֎_cq��`(�*�.H��a���b�,�Db��%�̮��Z�h��h���#L]tڌ�l>촰sCB�+�K��6�@:N(�>!��>1�?����|�����e?�tSG>�B)���i/#�*p��=�Eȅ��T*��DYH��a|�v�pA��Ƌ������-�>a�&E���̓ZƖ�YU�!Cf�t�P� 䐞>?|�
��Fhj����&��o���o����˂FO9hE7�~��ڑK��R �arCa懪��z��!����5:v�(��C���RS��9@��8�H����dW>pB�����DM���~,�n�j6��	�����qğ��U~vw�2YKlL�c*����gzYY|$����
_m�@�DkkR��s�xe�n^�4Ҡ���`��K| �Z�x���gw'���$+�u�nND�j��P(�K�t~k����\҉yu�9�{��Q��������k��lG��h7��Gw�)��^\��\?�!w4��;���a)�F>�=i�kKj�ft)U���Cc��?�u�'.4=/���Iۉ�7`@��Rg7.!b�8��Sy�6��!��Է͵���e?_b�1`��ݨ����8���0�m�p�t�����&�/馸2��K3zg�0���sRZ;Ѳ�*�� �X!ؒ����1��Ƕ0��L��5�y|��.��J�2�����iө��ʰ�P Ԏ�p�Рg��e�]i[�b�Bi�!@�*V�
9P#��olV�3� H̐��(-3{"��'wr�uBc�vl��Mؾm��v��c���-뽚��B�@Q���H��
������˪��&mI8��u֍�s%�y!��M��o��R    ��k����1'8�Qb�1�
m���������V�מ��
~�-HP�U�8To��tWćw֟�?���$ut���DL�H�W�j����έ�GU��}�]Q*��P�ol�o�����N�[�����.�R�L�J��� [l���&�_~=�W���Ss1��*t�IK
��0�Oƀ���'@���F�ϭ.{h���Ʒ��!%��kQ)�c��+%���L+������k��P�)i��o��B��[���b&~��SqU������l�b�!�NE���O͋��o.�<${�~�Ny����T,��K=�#D�@+�l��nC��.��a
���T���`�>3�jg�N��>�Pu��O��șa ~�̀�xk��� 3*���܄Bw��܀:^�	�Qh�Y<B�#N�"Hp遀���7�{��5��F�z�YRT_SHI�q���I1ۈ���b������ٶ��t|��,��Ɠ�g@�������N�`0\fA����������f2�Y��i�Z1�|����=����F�!�Q۸8-���e69a�L�;���=����0��u� NPF������N�F}�����\�����K�(z�Tx��L=M�Oե�Y�,�dЛn���?����P��A�K���Dh�1�+a��6�m�h�8x�&�!v<9��8-ѓ[o,�g�4%{P$~�/	��*j����[���ﯥ(C���B��bt�Ў �ΙM!46K@%� )�'hl\�����$B�+�PP"�(&ě�)B?�pws� �A*P^��z�����)�촣R>��p��	�a���gj:э���ц��3���l�m�s{;6�� �OȌ%=�bAe�Qڬ��YK7��Nk�Uq����Bv�`t<2o>zż��Z#*��"��ֶ�
�����apѹ��T,e\��*�o>�+�Nx�NW����5��7��7�?��O蝹5q�K�/�o@<�$��'èW?|����x��T����с���N94�}d��R*����F ��k���������A��}�d7BG��&���q7���lY������oD����"Ж叺�5�s(iQRrԞ���7�~����f�I)�Č�d�/���`�a<�-�1t���� >ș���F�wz���� �W�B��=tM_�$N˂�r4Y�a�@wTo�?�3�����탩C5b�i�7�6t,��5P�,rR�sJP���t�B)*�N��ߟ�����P�l�bO�I�>X��i����S��X�b+�����U�A�;�:�n��G#Cv�Ą����v0n��tu�v�eo7�V�PK��X.��|I#�@�̈́���ό��R���혠�����.n�Ũ
�^���ts��tHti��[�8��蟋 u��&�2V/>���r��'�����&V4bSI��=�,�SǠ�8�kU�0e��ȝ��	F�YF� u<;����%�g���ΑQ�sT�����PVX�/�Y*
��茋�[�d���@�TV���=	����\���K.t_�
�Ҩ�T�Ƚ1�N�~ȅ�-ݗPp1��[o����v�]��~t�h�~%M��oﲴ��Y��b~�� ����T���H���8B[�UNiJ����|�#m�e%p�<ȁ��XY�"�B)�D��=�{(K�{�ԓ'��_?��|���
��m����D=X�0*��[w�~������wkj��	��7c�	�1��ބ�֋��]H9�0#�Na�~�P�n�CZo/�z��q�f[�(��pU��"�x;�{�M�D�rz1���mT�bvMŉ�JC��D�hcӆQ�%i"��%�f)��!γH҄-Y
<Ě6F
�Q�~���
V*#���쏱{j�-R�b�k}��oN?*�G��݄�D�>՗�f5h�?���s}�������C���N��z3A�0���7��{n��2�z���0G1��������7G�O��Q��l@��r���$�;P2F8�Ư��E���D�L��'b�O	ш�1�:����h�X����||zv��̈́3�i��"lT����ǉ�@_Ti(�����,����F�ۖ^9���Z���l�)ҫ�p��`�!��l���}��u��ܼ�� �j� ��q��)y�E�[h�k�i�����-�L����^-��pd�W����H�"M��h����ob۫��4B0�D鴅
t�p{�����Ut�*�~��͢�ӚƎ͕��4 �ɛ�HS[���1:|����'��g�ǯ_�m3E]�@_���2l�0� ����1���d֜�	:���OO��dCPӝ���i�3l�Fu}~ͤ\fk]��C����^���J�M@/	�[�F#�wpFD��wP�m�����	���6�C�����m&���P>hrѲ㦔��+�-�CK�p/��`��I�Sb>��?�9=zF�,�슗&�W�a��DU�y�9jYcpe�޼~�yXx��	f�-~�"{���������&�'$Ԛą]���$�K��ӗj��4��U��N��%8��yI��zaZ�e{wE$�.mv�#��+�	�zI�9K��pL�K����g0%8'����<8�?V��:0[z���
>��[b�f>sR�6�p�4͋��K�qX�oA����A�v�[ξ�v/�|��/,Ԛ���T0�T�e>�k;���3N*ͼ�����ޥ��9�2S*�e!�������Z�Yj�K��(Ƞ��j�m�"�+`e�r��Y�q.s��T�u��p%֌����^J�.K�3����\�|pK	"G�����Q�qt~���Ow̴pQ���q��p��)j�!��篅x����7\ϑ���Z3�H�w���뫋�����t~�۫M�S�������������e� ���PSQKJ<���&�m�iq����K.5�R��s���(����{� �%F���}�����Pi J¶�q���cL�̠UM"��5�t�8�Y�,����w���;$YctO[�'��Z��~Y�����������]y���%����B�ک�$7�܌8��A�WiGy�tƘ�w�����N�A#���K�m_ ��MQV׊wϝ��% ��*�q�4��X&�f70'����Q��L��Nc�%�TL�f�\���[�.ł��w�#�aC���^�Ĵ��_*ܫ��~a��J<�A�Ct%DMs<��e�5~D ��.�@ }�3�|4�=��ʖRK��Rv�tl������?EV���j[��ѵ�.���$��7�r�)��*j�Fg�f��4Ȝ)���'H���!��#1�P�M
O�n^f�$/F���Eȷ��	ߒ�#Dj�4���eN
|�_���C{�p��O}������f}k�q�}M(���n�r�8tÓ�C-@5îǃ���~�%L��[@$����4��]���0�?���}��X3�u-���~����q�B�,Ė`��o��}Kt�y��x@�E��"�W��L����/ȃ~zD}P�(n��4�`��!�����B��K���^L�I�|�4H�-r�p��Jk-�������T����%㰲
�y�[���0��G��:%
�o��:U��)C�=ϹR����14
��2^,���9f�Ƒrd�8=����6�6��nS4���1ꅶ7��pҁ�uV8�T��砻�O�S�s��USD��U;�a�:`��XC���q}�yx�N��evY��O^�������)`���
K�&�Rxq
9�K ��KzROn�_p�v��6��7��^#w��v��\�����n����%Z#����vy�!l? &��l�.����W��/��8\�9��5Sc����m�m�y!�����*���L}�����f7 ��B�}P.���Б��%�8b��X�J��e������'8��o��::,����(�@}1�w�ftx��һ	����T�*W94�����.=����!P��By��j��=����v^qW��0�1 �L~K���i���%�`$m�?�vE��*��H:    Q����_����.U�      �      x������ � �      �   �   x�e�Q�0D��S�	����g�L��]�Ʋ%K!r{������f�E�IOaF�T�ғd�>a�ohh7����a$u�h.J�3�̉T����a�,cv�H�mR27}�*y♂k5�%|��:I���^�L*aL�z��ߖ��r���i�JK���xsF����>	-ߎ��q�3o�͑�콲־ Ƀt8      �   ,   x�3�tK,�U�MM�H��,N,����2��J�rS22�b���� ��      �   5   x�3��/-JMNU0�2������lc.8ۄ��6�2��͸��ls�=... �{�      �   �   x�]�K
�0���=��
�7m�ґ�%��B��~Ӂ���|p�����~������F�3�l}�P/����p,�L� �G/j�P� �p`b��)���-&?����嫎4�%Dէ��!��q?� hhQj      �   /   x��J�I��L���􂱸��r�sS�3���Ē��<N7_�=... �x�      �   3   x�3�I�PHK-I�PH+��U�,I͍/(�LN��M,P(IL�I����� E�      �      x���YoG�����"!��S�@j+�8bK�,�(p�����dUn���'�v��/3#�9q#OE����K���R���OY6���¨"L,�9#|	�ϩ�k�-ԾȜ��r��R[���~=���۝_}  oث�Û���.y����򂆻��.��,�ٛO̻{}��K��vw�>]��F���ByK�س�7��ݮ�U�y�������۽�>�h�w�]���Ew�����c�cz/��m�v��S�V�
d��n��ŧ���N���������^}&�\*墥�kw����㎘a?v�_]� w�Xs����h
������s��W�3���
���j��}����G����ƛ�O��/4���%��|���s����緻����C�ܐ�W��Fq�AZ[+�}<<����_9�s*��yf5�?�0��~R��L�k�q�=�32���	��*�a�F��Ӽ>���ghb;��LtߟЬ��9��H>ǲ��g\f[���?CS7(?�Y���`�����h}�32�}�5������9����	����g^(�{�/4f�0˄9&�3a�	�L�T�u;hTH�
$U��I��*AR� �ZPT-(�U��EՂ�jAQ���ZPT-(�4U���m��Z�T-h�4U��MՂ�j�P�`�Z0T-�N��CՂ�j�P�`�Z0T-X�,U��KՂ�n��Z�T-X�,U��GՂ�j�Q��ZpT-8�;$�U��GՂ�j�S��Z�T-x�<U��B��OՂ�j!P��ZT-�U���@�B�T-�"U���H�B�j!R��Z�T-D�"7j#gmܰMp�6���7o��Mp7���7s��MpU����� ����C�shrMN��Q47���0Zr�hɍ�%7���@Zriɍ�%7���PZrSiɍ�%7���`Zr�iɍ�%7���pZr�iɍ�%7��܀Zrjɍ�%7��ܐZrSjɍ�%7��ܠZr�jɍ�%7��ܰZr�jɍ�%7����Zrkɍ�%7����ZrSkɍ�%7����Zr�kɍ�%7����Zr�kɍ�%7��� [rlɍ�%7Ö�[rSlɍ�%7ǖ� [r�lɍ�%7˖�0[r�lɍ�%7ϖ�@[rmɍ�%7Ӗ�P[rSmɍ�%7ז�`[r�mɍ�%7�V�l[q�m�Ͷ7�V�l[q�m�Ͷ7�V�l[q�m�Ͷ7�V�l[q�m�Ͷ7�V�l[q�m�Ͷ��5��5��5W�����������������l[q�m�Ͷ7�V�l[q�m�Ͷ7�V�l[q�m�Ͷ7�V�l[q�m�Ͷ7�V�l[q�m�Ͷ7�V�l[q�m�Ͷ7�V�l[q�m�Ͷ7�V�l[q�m�Ͷ7�V�l[q�m�Ͷ7�V�l[q�m�Ͷ7�V�l[q�m�Ͷ7�V�l[q�m�Ͷ7�V�l[q�m�Ͷ7�V�l[q�m�Ͷ7�V�l[q�m�Ͷ7�V�l[q�m�Ͷ7�V�l[q�m�Ͷ7�V�l[q�m�Ͷ57���l[s�m�Ͷ57���l[s�m�Ͷ57���l[s�m�Ͷ57���l[s�m�Ͷ57���l[s�m�Ͷ57���l[s�c�M�57=���Xs�cM��n�v�������\7&i7�[�����wX3-�����	I���:�'$u�O�f��'$�OH�'��N5��)r%�`�2Z�T)-X��,UR�*�K�ւ��k�R%���V2�Hg���KU�闠r�fdR�dn��T��T�Ts�Tg�T[�TO�j�j(�����>��S���W�p?�9!َF*ِF*ْF*ٔF*ٖF*٘F*�P�_(�U炥V삥�삥�삥킥V킥��ݨn�F��ua]q7��S_q7R7�Yq7�7�Yq7R7�Yq7�7Zq�Z׸z�ڝ�9��u�:�p��_�?,\�?,\�?,\�?,\�?,\�?,\�?����{��+�	JU���a�R�0A�B��TLP�&(��'�6�O]g�&�ⶡ3���w�;��wdR�~dn��TC�T?�T;�T7�T3�T/�j�j%t%q�d�n�#[������T9a#�}�t��k�3�:�3�Z 3�Z3�Z3u����L���L����.�m�ŵ������`�Q�V6��Ƹ/
�6*�&ĢH���D���D���D���D���D���D���D�z�D�pN��h���.I'$_7ܥ��+����|�p���o>��]t�;3�Z�3�Z�3�Z�3�Z�3�Z�3�Z�3u�z�����/�m��5���������Fa��`�n�1�~����L�V�L��L���L���L�V�L��Lݦ^��¢ꢰ`�QwQX��苻(,X�K�>e4A��7�|�%�O���E��.q��MP�{�>M4?�U��&8S7�=��8S�����۝�%�%���ٚ��ٚ��ٚ����'*�'*�'*�	gp�p�n�.�~�>�?r�Њ���RaťZK5��j+.�V\�5��TsX�jk0w�x��֝u�<#��	��-��n@G(�������;#��vg�r�P}ڽ����SC#�{dh�r��P�a��=)4B�ǄF(���ݦ���'�&�"՝����|Lw�n�+�݉��$^tg��@��|��w#���a�r�<�P�IIq_;�P�[����/&�&�"����7zWg�H�$���<8�=�$����7����r@r�N��'~�8A��L8B�_ :B�_�9B�_�9B�_�9B��-ϻ/����/68»F�����C�k4�(�M>��F�O�������=pq��U�ct���O�OT��'*�����������D�~��r�p�]~�:�b��_q��p�ξp���p���p���p�n�p��_�W8�t��l���/�s3#������T��~��r?�?B�����O�P�=/3�6��DS��E����v������?˽�ɟ�^���|hb��M,`�щL>=�� Ŋ���6�����>L�"o�?�9���K�hdr{��ے��܎���6d'���m�NLn7vbr���湽��BI�c�#t-��,��-��>��;C��f/��%]����3�|x}�O��ܭ�|~}撿%b撿'b���"�V�c[��Jsd��>t��,X���X���؍Ɩ�g3�kg3��f3�kf3��e��V�p�:{������_����.���|�~��|�xG������5��݊K>u7sɧ�f.�	��.��|�o����\�Y��K>˷h�|�oo�:[	����T)_���#��VL�J���V��R�`�nR��*u}��T׆�Z�p	��V�6�yֆZ��P�Er�p���>hC]յ��rUa���\UX�*,W��
�U���rUḪp\U8�*W�����������?'�Rn��p�I��Wk��"t*�%]����;ٚL�)k{�|�(]B�!dcllR�ч��כ'8h��^ZoK�s�����B4W�������T��)���>�����Ѫ��\��!��zkUoC�5��Ls��hK�kJ�XZ�-G��ӾI�w�=�y����>��(!ÿ�ޤ�������C-2���M�S�+���㗭r��~�d����s���ڡ�~�����]*�w�¯.��H)��6%�I��Ͼ�f�1*e��Í����E)N��l_�K����|{Y��#n�*�p�AU���LS����-Ӌ���6��}ȸb�"�����D�O׷��k;�}������5t�E@�e�S�"�$z{�*�ɕޠ�m��rh}.ŗ����ҕ���M�n��q�VWH=*�P����Dp�! ���<�V뽍�r9<�o}@?�Q:ܧC�������}I�����`ǋ#��R��+�-u�:�y���W�4cE�!H��2�����j.��8]�{����:��senPdxu��#n\t�!��uIV���}��%_T��N���N�ȏ��o�fE�ZG�r�=ʾ�R�T�(y�*����O

��%e[z�2�슞�7)}O�{�������}�/�QF�ش7�'A+J�%�zNE�h��x�(��猢3�K%fM|��>>|�,��)A<��QM�{���K�]���x�-�\�%z܅�=\������I7����]�P���ln �  ���Q�U����
u	����X��x<�Y��fv�nw����~���۽�k�Iբk�?�*A����%\ ����y�=�M����]�27��ӷ���s�7�*L<��P��kK���BďS��΄9��uK�g���?�ҷt�non��{���u��2�j5�rHuU1�XJ|�*z_�����>�UUɘ"�vp�6]�.�q,��7�z�wi�8�*'B1=
#Ո��8+��J$��X h���fo��a������7��Q�]��9��:0����N�cs��g���X+Bs���O�[���gU�dB3�-�G��޴��hw?q'�:�>�X��?����ǒ[*�՚]��"���-*��*����|�����kmu	��ƈW�7�ސ�m��Zk���2�����C-',I!E�'M�s傻�K7'e�_׷߿�C]k���b�5���Q9����Jcq�*��Fsp�������Z}��:;��"w���X�D��a�Q�h�V
�$�$eH(�Jv��aǡV����z�?^d��,f���0�}��$t���a��+��"&H(���h�D�� �,{�����F.[L6;Ԡ�=G�ա�
��գ�jX{�P$z�*=z�0��q:ޫ'���`�:�^b�����B�D�+ѷ��X%1t(��y0-h�����t����k�*�W�Wܡ-X�SuN�!ءH��Xr1E
.�`T��G�
f~�G��!�-�>��KK�=����3�i�9���d�CQE�Fk#z̈zn�QV:`��RK������]� �V�iuXl��i���X�T/���3���S�x�f��r�f̣��{�u{��>_���:XkS��Aej��/�G�\�
$�O_���VX�0��A>���K�z�6�G��=�x�?���Ki���K<{��x��'��
U�U�Ul$z*��K���4"��4�����?���9������VOd��)���P��-�"R4��i�a���c�ꓐCt�!����07���*���.+���tK�N_�i���<<*a{�|��;�M_����\`�|����+h+�p��|�"�yt�l�,}��قٓ��>�*�T,�j^�����Ɗ�Znպk��jjh�<�Mi��}�A?k�,�EI��>����h"ܬ̆�G���U�O<��ʎ�;����_I�ZXN� ����!w��ҁ�؊%R� z}A�q.���$Z%����4�>A4��}%a�h̼ƾ1��yl�ԆE�X�3�1lQ�N��V�8?˴��~������s_��p�9��`��F� `t�	t�0m�N�6���J5�0��,�/��B-����A/[��x��6M<���QB�������f<pCUǡ�hu��_SN�κ��4�77����t>[�_Y�a�4,�h��ؒ����,��cn���ӲhA�_���-�L��aq���X}BG���eL�ڍ�v���kAӁ��Y5�Z`TA|"��mC���عa�����9D� <�z�1�1=ei���_����X�Gl��B`����P��!�(k�[et�%��A�GI�^��9�l�-i���_�Ox��%�ԓ��|�X�7�FmN4.-�a�h�(��:��x�����NH��-�a�Ypp��+��a-�,C��h�l̰v�;�t��M+6Aey��m�O7X�<��a�6��c关w�����Ŀ����գ�v[Yz�����]����۾`�h��G�8���o��d�5,����u�	b�)��e�аHwF3�,U0�T��~|xj�>��
[l�ь��M���`+��Z��E���o�>05>��!��&y0�{lZ<,����U�e�����b�Ƥ$��Y�����c�����V�<������_��En:      �      x��|�rI��3�+���}�S%H	� y�T]���X�E�JT�������̤D�-++�Bf�p�r���>��������`������'BO������a�������,<��X����q���%݅��8����j���|5�Ь/���Y�򱹸���^O��#�l�,�hlQ�2/����PK�q��dXI6����Eo��ZW���{;ZO��|��w���8&�	q��D��0����<����6<=�����ۧ������R��>�g%=}yx�vo>]��/6���|9��ւ1ݙ:_�x�^#�N��EХ&gj�9Ƌ�:[��O6Z墮Uʠ��)!�T&a�����QS��Ty0U�a&n�1<ގ�?¿ß���ݿ���x~_����szz~(�������ϻ�00u}1��Y���_W�z�ڞn���z{ss5��~9_4�+�YY]2���K�&k����&8�X#,㉱ wK�`�2Q[F��6���LO����Q���f��-;a�]����ͯ��r�l��ѯ���yܜϖ�6�\��\�3:UL��)��[�D�J��u�)";F��͓��Y���xF�T��M�`����N�G.���_v���l�����)_��:!�*B*�T+&i�x�5�D�H,.������A%E���	�b"�D�����M�w��D�.�f��؎/��f5FA]4��������f�����W��|3;�Dw�\5�_�[�@z�TvA��L���{#��ffEME�ʂw�9#�B�i.�ͪ�D�YVO���Gͳ���<iO$�c9��.?4��>�xq}�,7����y<]]o.P!F��:ZN�8��]rQ�p���'��ǳ�%9�[�Nko)T��j�*�(�V��0
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