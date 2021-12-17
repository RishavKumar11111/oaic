const { Model, DataTypes } = require('sequelize');
const { sequelize } = require('../config/config');

const DLMasterModel = require('./VendorMaster.model');
const StateMasterModel = require('./StateMaster.model');

class VendorPrincipalPlaceModel extends Model {}

VendorPrincipalPlaceModel.init({
    VendorID: {
        type: DataTypes.STRING,
        allowNull: false,
        references: {
            model: DLMasterModel,
            key: 'VendorID'
        }
    },
    PrincipalPlaceID: {
        type: DataTypes.INTEGER,
        autoIncrement: true,
        primaryKey: true,
        allowNull: false
    },
    Country: {
        type: DataTypes.STRING,
        allowNull: false
    },
    StateCode: {
        type: DataTypes.INTEGER,
        allowNull: false,
        references: {
            model: StateMasterModel,
            key: 'StateCode'
        }
    },
    DistrictOrCity: {
        type: DataTypes.STRING,
        allowNull: false
    },
    Pincode: {
        type: DataTypes.INTEGER,
        allowNull: false
    },
    Address: {
        type: DataTypes.STRING,
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
    modelName: 'VendorPrincipalPlaceModel',
    tableName: 'VendorPrincipalPlace',
    timestamps: false
});

VendorPrincipalPlaceModel.belongsTo(DLMasterModel, { foreignKey: 'VendorID' });
VendorPrincipalPlaceModel.belongsTo(StateMasterModel, { foreignKey: 'StateCode' });

module.exports = VendorPrincipalPlaceModel;