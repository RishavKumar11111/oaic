const { Model, DataTypes } = require('sequelize');
const { sequelize } = require('../config/config');
const DivisionMasterModel = require('./DivisionMaster.model');

class CustomerInvoiceMasterModel extends Model { }

CustomerInvoiceMasterModel.init({

    CustomerInvoiceNo: {
        type: DataTypes.STRING,
        primaryKey: true,
        allowNull: false
    },
    CustomerID: {
        type: DataTypes.STRING,
        allowNull: true
    },
    POType: {
        type: DataTypes.STRING,
        allowNull: true
    },

    MRRNo: {
        type: DataTypes.STRING,
        allowNull: true
    },

    PONo: {
        type: DataTypes.STRING,
        allowNull: true
    },
    
    VendorID: {
        type: DataTypes.STRING,
        allowNull: true
    },

    FinYear: {
        type: DataTypes.STRING,
        allowNull: true
    },
    DistrictID: {
        type: DataTypes.STRING,
        allowNull: true
    },
    InvoiceAmount: {
        type: DataTypes.STRING,
        allowNull: true
    },
    NoOfOrderDeliver: {
        type: DataTypes.STRING,
        allowNull: false
    },
    DeliveredQuantity: {
        type: DataTypes.STRING,
        allowNull: true
    },
    OrderReferenceNo: {
        type: DataTypes.STRING,
        primaryKey: true,
        allowNull: true
    },
    DivisionID: {
        type: DataTypes.STRING,
        allowNull: true,
        references: {
            model: DivisionMasterModel,
            key: 'DivisionID'
        }
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
    HSN: {
        type: DataTypes.STRING,
        allowNull: true
    },
    UnitOfMeasurement: {
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
        type: DataTypes.INTEGER,
        allowNull: true
    },
    ItemQuantity: {
        type: DataTypes.INTEGER,
        allowNull: true
    },
    TaxRate: {
        type: DataTypes.INTEGER,
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
    }
}, {
    sequelize,
    modelName: 'CustomerInvoiceMasterModel',
    tableName: 'CustomerInvoiceMaster',
    timestamps: false
});

CustomerInvoiceMasterModel.belongsTo(DivisionMasterModel, { foreignKey: 'DivisionID' })

module.exports = CustomerInvoiceMasterModel;