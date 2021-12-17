const { Model, DataTypes } = require('sequelize');
const { sequelize } = require('../config/config');

// const StateMasterModel = require('./StateMaster.model');

class CustomerMasterModel extends Model {}

CustomerMasterModel.init({
    CustomerID: {
        type: DataTypes.STRING,
        allowNull: true
    },
    LegalCustomerName: {
        type: DataTypes.STRING,
        allowNull: true
    }, 
    TradeName: {
        type: DataTypes.STRING,
        allowNull: true
    }, 
    PAN: {
        type: DataTypes.STRING,
        allowNull: true
    },
    // PANDocument: {
    //     type: DataTypes.STRING,
    //     allowNull: true
    // },
    BussinessConstitution: {
        type: DataTypes.STRING,
        allowNull: true
    },
    GSTN: {
        type: DataTypes.STRING,
        allowNull: true
    },
    // GSTNDocument: {
    //     type: DataTypes.STRING,
    //     allowNull: true
    // },
    // IncorporationDate: {
    //     type: DataTypes.DATE,
    //     allowNull: true
    // },
    ContactNumber: {
        type: DataTypes.STRING,
        allowNull: true
    }, 
    EmailID: {
        type: DataTypes.STRING,
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
    }
}, {
    sequelize,
    modelName: 'CustomerMasterModel',
    tableName: 'CustomerMaster',
    timestamps: false
});

// CustomerMasterModel.belongsTo(DLMasterModel, { foreignKey: 'CustomerID' });
// CustomerMasterModel.belongsTo(StateMasterModel, { foreignKey: 'StateCode' });

module.exports = CustomerMasterModel;