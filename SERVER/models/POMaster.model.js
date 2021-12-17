const { Model, DataTypes } = require('sequelize');
const { sequelize } = require('../config/config');

class POMasterModel extends Model {}

POMasterModel.init({
    FinYear: {
        type: DataTypes.STRING,
        allowNull: true
    },
    PONo: {
        type: DataTypes.STRING,
        primaryKey: true,
        allowNull: false
    },
    OrderReferenceNo: {
        type: DataTypes.STRING,
        primaryKey: true,
        allowNull: true
    },
    CustomerID: {
        type: DataTypes.STRING,
        allowNull: true
    },
    CustomerOrderRefence: {
        type: DataTypes.STRING,
        allowNull: true
    },
    VendorID: {
        type: DataTypes.STRING,
        allowNull: true
    },
    DistrictID: {
        type: DataTypes.STRING,
        allowNull: true
    },

    DistrictName: {
        type: DataTypes.STRING,
        allowNull: true
    },

    DMID: {
        type: DataTypes.STRING,
        allowNull: true
    },
    AccID: {
        type: DataTypes.STRING,
        allowNull: true
    },
    DivisionID: {
        type: DataTypes.STRING,
        allowNull: true
    },
    Implement: {
        type: DataTypes.STRING,
        allowNull: true
    },
    Make: {
        type: DataTypes.STRING,
        allowNull: true
    },
    Model: {
        type: DataTypes.STRING,
        allowNull: true
    },
    UnitOfMeasurement: {
        type: DataTypes.STRING,
        allowNull: true
    },
    HSN: {
        type: DataTypes.STRING,
        allowNull: true
    },
    PackageSize: {
        type: DataTypes.STRING,
        allowNull: true
    },
    PackageUnitOfMeasurement: {
        type: DataTypes.STRING,
        allowNull: true
    },
    PackageQuantity: {
        type: DataTypes.STRING,
        allowNull: true
    },
    TaxRate: {
        type: DataTypes.STRING,
        allowNull: true
    },
    RatePerUnit: {
        type: DataTypes.DECIMAL(20, 2),
        allowNull: true
    },
    PurchaseInvoiceValue: {        
        type: DataTypes.DECIMAL(20, 2),
        allowNull: true
    }, 
    PurchaseTaxableValue: {        
        type: DataTypes.DECIMAL(20, 2),
        allowNull: true
    },
    PurchaseCGST: {        
        type: DataTypes.DECIMAL(20, 2),
        allowNull: true
    },
    PurchaseSGST: {        
        type: DataTypes.DECIMAL(20, 2),
        allowNull: true
    },
    PurchaseIGST: {
        type: DataTypes.DECIMAL(20, 2),
        allowNull: true
    },
    TotalPurchaseInvoiceValue: {
        type: DataTypes.DECIMAL(20, 2),
        allowNull: true
    },
    TotalPurchaseTaxableValue: {
        type: DataTypes.DECIMAL(20, 2),
        allowNull: true
    },
    TotalPurchaseCGST: {
        type: DataTypes.DECIMAL(20, 2),
        allowNull: true
    },
    TotalPurchaseSGST: {
        type: DataTypes.DECIMAL(20, 2),
        allowNull: true
    },
    SellCGST: {        
        type: DataTypes.DECIMAL(20, 2),
        allowNull: true
    }, 
    SellSGST: {        
        type: DataTypes.DECIMAL(20, 2),
        allowNull: true
    }, 
    SellIGST: {        
        type: DataTypes.DECIMAL(20, 2),
        allowNull: true
    }, 
    SellInvoiceValue: {        
        type: DataTypes.DECIMAL(20, 2),
        allowNull: true
    }, 
    SellTaxableValue: {        
        type: DataTypes.DECIMAL(20, 2),
        allowNull: true
    },
    TotalSellCGST: {
        type: DataTypes.DECIMAL(20, 2),
        allowNull: true
    }, 
    TotalSellSGST: {
        type: DataTypes.DECIMAL(20, 2),
        allowNull: true
    }, 
    TotalSellIGST: {
        type: DataTypes.DECIMAL(20, 2),
        allowNull: true
    }, 
    TotalSellInvoiceValue: {
        type: DataTypes.DECIMAL(20, 2),
        allowNull: true
    }, 
    TotalSellTaxableValue: {
        type: DataTypes.DECIMAL(20, 2),
        allowNull: true
    },
    POAmount: {
        type: DataTypes.STRING,
        allowNull: true
    },
    NoOfItemsInPO: {
        type: DataTypes.STRING,
        defaultValue: 1,
        allowNull: true
    },
    ItemQuantity: {
        type: DataTypes.STRING,
        allowNull: true
    },
    ItemQuantitySold: {
        type: DataTypes.STRING,
        allowNull: true
    },
    EngineNumber: {
        type: DataTypes.STRING,
        allowNull: true
    },
    ChassicNumber: {
        type: DataTypes.STRING,
        allowNull: true
    },
    IsDelivered: {
        type: DataTypes.BOOLEAN,
        defaultValue: false,
        allowNull: true
    },
    IsReceived: {
        type: DataTypes.BOOLEAN,
        defaultValue: false,
        allowNull: true
    },
    IsDeliveredToCustomer: {
        type: DataTypes.BOOLEAN,
        defaultValue: false,
        allowNull: true
    },
    Status: {
        type: DataTypes.STRING,
        defaultValue: 'indentInitiated',
        allowNull: true
    },
    InsertedDate: {
        type: DataTypes.DATE,
        defaultValue: DataTypes.NOW,
        allowNull: true
    },
    InsertedBy: {
        type: DataTypes.STRING,
        allowNull: true
    },
    UpdatedDate: {
        type: DataTypes.DATE,
        allowNull: true
    },
    UpdatedBy: {
        type: DataTypes.STRING,
        allowNull: true
    },
    IsApproved: {
        type: DataTypes.BOOLEAN,
        defaultValue: false,
        allowNull: true
    },
    ApprovalStatus: {
        type: DataTypes.STRING,
        defaultValue: "Pending",
        allowNull: true
    },
    ApprovedDate: {
        type: DataTypes.DATE,
        allowNull: true
    },
    ApprovedBy: {
        type: DataTypes.STRING,
        allowNull: true
    },
    IsDeleted: {
        type: DataTypes.BOOLEAN,
        defaultValue:false,
        allowNull: true
    },
    DeletedDate: {
        type: DataTypes.DATE,
        allowNull: true
    },
    DeletedBy: {
        type: DataTypes.STRING,
        allowNull: true
    },
    IsCancelled: {
        type: DataTypes.BOOLEAN,
        defaultValue: false,
        allowNull: true
    },
    CancellationStatus: {
        type: DataTypes.STRING,
        allowNull: true
    },
    CancelledDate: {
        type: DataTypes.DATE,
        allowNull: true
    },
    CancelledBy: {
        type: DataTypes.STRING,
        allowNull: true
    },
    POType: {
        type: DataTypes.STRING,
        allowNull: true
    },
    VendorInvoiceNo: {
        type: DataTypes.STRING,
        allowNull: true
    },
    MRRID: {
        type: DataTypes.STRING,
        allowNull: true
    },
    DeliveredQuantity: {
        type: DataTypes.STRING,
        allowNull: true
    },
    PendingQuantity: {
        type: DataTypes.STRING,
        allowNull: true
    },
}, {
    sequelize,
    modelName: 'POMasterModel',
    tableName: 'POMaster',
    timestamps: false
});


module.exports = POMasterModel;
