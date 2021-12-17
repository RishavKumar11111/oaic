const { Model, DataTypes } = require('sequelize');
const { sequelize } = require('../config/config');

class ItemMasterModel extends Model {}

ItemMasterModel.init({
    Division: {
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
    GSTApplicability: {
        type: DataTypes.STRING,
        allowNull: true
    },
    Taxability: {
        type: DataTypes.STRING,
        allowNull: true
    },
    TaxRate: {
        type: DataTypes.STRING,
        allowNull: true
    },
    PurchaseInvoiceValue: {        
        type: DataTypes.DECIMAL(10, 2),
        allowNull: false
    }, 
    PurchaseTaxableValue: {        
        type: DataTypes.DECIMAL(10, 2),
        allowNull: false
    },
    PurchaseCGST: {        
        type: DataTypes.DECIMAL(10, 2),
        allowNull: false
    },
    PurchaseSGST: {        
        type: DataTypes.DECIMAL(10, 2),
        allowNull: false
    },
    PurchaseIGST: {        
        type: DataTypes.DECIMAL(10, 2),
        allowNull: false
    },
    PurchaseSGSTOnePercent: {        
        type: DataTypes.DECIMAL(10, 2),
        allowNull: false
    },
    PurchaseCGSTOnePercent: {        
        type: DataTypes.DECIMAL(10, 2),
        allowNull: false
    },
    SellCGST: {        
        type: DataTypes.DECIMAL(10, 2),
        allowNull: false
    }, 
    SellSGST: {        
        type: DataTypes.DECIMAL(10, 2),
        allowNull: false
    }, 
    SellIGST: {        
        type: DataTypes.DECIMAL(10, 2),
        allowNull: false
    }, 
    SellInvoiceValue: {        
        type: DataTypes.DECIMAL(10, 2),
        allowNull: false
    }, 
    SellTaxableValue: {        
        type: DataTypes.DECIMAL(10, 2),
        allowNull: false
    },
    add_date: {
        type: DataTypes.DATE,
        defaultValue: DataTypes.NOW,
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
    Implement: {
        type: DataTypes.STRING,
        primaryKey: true,
        allowNull: true
    }, 
    Make: {
        type: DataTypes.STRING,
        primaryKey: true,
        allowNull: true
    }, 
    Model: {
        type: DataTypes.STRING,
        primaryKey: true,
        allowNull: true
    },
    DivisionID: {
        type: DataTypes.STRING,
        allowNull: true
    }
}, {
    sequelize,
    modelName: 'ItemMasterModel',
    tableName: 'ItemMaster',
    timestamps: false
});


module.exports = ItemMasterModel;