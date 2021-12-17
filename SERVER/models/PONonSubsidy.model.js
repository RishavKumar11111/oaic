const { Model, DataTypes } = require('sequelize');
const { sequelize } = require('../config/config');

class NonSubsidyPOMasterModel extends Model {}

NonSubsidyPOMasterModel.init({
    OrderReferenceNo: {
        type: DataTypes.STRING,
        allowNull: true
    },
    PONo: {
        type: DataTypes.STRING,
        allowNull: false
    },
    CustomerID: {
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
    TaxRate: {
        type: DataTypes.STRING,
        allowNull: true
    },
    PurchaseInvoiceValue: {        
        type: DataTypes.DECIMAL(10, 2),
        allowNull: true
    }, 
    PurchaseTaxableValue: {        
        type: DataTypes.DECIMAL(10, 2),
        allowNull: true
    },
    PurchaseCGST: {        
        type: DataTypes.DECIMAL(10, 2),
        allowNull: true
    },
    PurchaseSGST: {        
        type: DataTypes.DECIMAL(10, 2),
        allowNull: true
    },
    PurchaseIGST: {        
        type: DataTypes.DECIMAL(10, 2),
        allowNull: true
    },
    SellCGST: {        
        type: DataTypes.DECIMAL(10, 2),
        allowNull: true
    }, 
    SellSGST: {        
        type: DataTypes.DECIMAL(10, 2),
        allowNull: true
    }, 
    SellIGST: {        
        type: DataTypes.DECIMAL(10, 2),
        allowNull: true
    }, 
    SellInvoiceValue: {        
        type: DataTypes.DECIMAL(10, 2),
        allowNull: true
    }, 
    SellTaxableValue: {        
        type: DataTypes.DECIMAL(10, 2),
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
    modelName: 'NonSubsidyPOMasterModel',
    tableName: 'NonSubsidyPODetails',
    timestamps: false
});


module.exports = NonSubsidyPOMasterModel;