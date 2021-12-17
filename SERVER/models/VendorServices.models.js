const { Model, DataTypes } = require('sequelize');
const { sequelize } = require('../config/config');

const DLMasterModel = require('./VendorMaster.model');

class VendorServicesModel extends Model {}

VendorServicesModel.init({
    VendorID: {
        type: DataTypes.STRING,
        allowNull: false,
        primaryKey: true,
        references: {
            model: DLMasterModel,
            key: 'VendorID'
        }
    },
    Service: {
        type: DataTypes.STRING,
        primaryKey: true,
        allowNull: false
    },
    InsertedDate: {
        type: DataTypes.DATE,
        defaultValue: DataTypes.NOW,
        allowNull: false
    }, 
    InsertedBy: {
        type: DataTypes.STRING,
        allowNull: false
    }
}, {
    sequelize,
    modelName: 'VendorServicesModel',
    tableName: 'VendorServices',
    timestamps: false
});

VendorServicesModel.belongsTo(DLMasterModel, { foreignKey: 'VendorID' });

module.exports = VendorServicesModel;