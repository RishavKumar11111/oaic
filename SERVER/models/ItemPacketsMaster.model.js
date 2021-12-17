const { Model, DataTypes } = require('sequelize');
const { sequelize } = require('../config/config');

class ItemPacketMasterModel extends Model {}

ItemPacketMasterModel.init({
    DivisionID: {
        type: DataTypes.STRING,
        primaryKey: true,
        allowNull: false
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
    PackageSize: {
        type: DataTypes.STRING,
        primaryKey: true,
        allowNull: true
    },
    UnitOfMeasurement: {
        type: DataTypes.STRING,
        primaryKey: true,
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
    modelName: 'ItemPacketMasterModel',
    tableName: 'ItemPackageMaster',
    timestamps: false
});


module.exports = ItemPacketMasterModel;