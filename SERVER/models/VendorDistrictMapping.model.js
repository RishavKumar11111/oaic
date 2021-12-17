const { Model, DataTypes } = require('sequelize');
const { sequelize } = require('../config/config');

const VendorMasterModel = require('./VendorMaster.model');
const DistrictMasterModel = require('./DistrictMaster.model');

class VendorDistrictMappingModel extends Model {}

VendorDistrictMappingModel.init({
    VendorID: {
        type: DataTypes.STRING,
        allowNull: false,
        primaryKey: true,
        references: {
            model: VendorMasterModel,
            key: 'VendorID'
        }
    },
    DistrictID: {
        type: DataTypes.STRING,
        primaryKey: true,
        allowNull: false,
        references: {
            model: DistrictMasterModel,
            key: 'dist_id'
        }
    },
    InsertedDate: {
        type: DataTypes.DATE,
        defaultValue: DataTypes.NOW,
        allowNull: false
    }, 
}, {
    sequelize,
    modelName: 'VendorDistrictMappingModel',
    tableName: 'VendorDistrictMapping',
    timestamps: false
});

VendorDistrictMappingModel.belongsTo(VendorMasterModel, { foreignKey: 'VendorID' });
VendorDistrictMappingModel.belongsTo(DistrictMasterModel, { foreignKey: 'DistrictID' });

module.exports = VendorDistrictMappingModel;