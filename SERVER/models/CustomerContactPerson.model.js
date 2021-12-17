const { Model, DataTypes } = require('sequelize');
const { sequelize } = require('../config/config');

const DLMasterModel = require('./CustomerMaster.model');

class CustomerContactPersonModel extends Model {}

CustomerContactPersonModel.init({

    CustomerID: {
        type: DataTypes.STRING,
        allowNull: true,
        // references: {
        //     model: DLMasterModel,
        //     key: 'CustomerID'
        // }
    },
    ContactPersonID: {
        type: DataTypes.INTEGER,
        // autoIncrement: true,
        allowNull: true
    },
    AuthorisedName: {
        type: DataTypes.STRING,
        allowNull: true
    },
    AuthorisedMobileNo: {
        type: DataTypes.STRING,
        allowNull: true
    },
    AuthorisedEmailID: {
        type: DataTypes.STRING,
        allowNull: true
    },
    Designation: {
        type: DataTypes.STRING,
        allowNull: true
    },
    InsertedDate: {
        type: DataTypes.DATE,
        defaultValue: DataTypes.NOW,
        allowNull: false
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
    modelName: 'CustomerContactPersonModel',
    tableName: 'CustomerContactPerson',
    timestamps: false
});

// CustomerContactPersonModel.belongsTo(DLMasterModel, { foreignKey: 'CustomerID' });
// CustomerMasterModel.belongsTo(DLMasterModel, { foreignKey: 'CustomerID' });
// CustomerMasterModel.belongsTo(StateMasterModel, { foreignKey: 'StateCode' });

module.exports = CustomerContactPersonModel;