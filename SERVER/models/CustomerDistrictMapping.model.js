const { Model, DataTypes } = require('sequelize');
const { sequelize } = require('../config/config');

const CustomerMasterModel = require('./CustomerMaster.model');
const DistrictMasterModel = require('./DistrictMaster.model');

class CustomerDistrictMappingModel extends Model {}

CustomerDistrictMappingModel.init({
    CustomerID: {
        type: DataTypes.STRING,
        allowNull: false,
        primaryKey: true,
        // references: {
        //     model: CustomerMasterModel,
        //     key: 'CustomerID'
        // }
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
    modelName: 'CustomerDistrictMappingModel',
    tableName: 'CustomerDistrictMapping',
    timestamps: false
});

// CustomerDistrictMappingModel.belongsTo(CustomerMasterModel, { foreignKey: 'CustomerID' });
CustomerDistrictMappingModel.belongsTo(DistrictMasterModel, { foreignKey: 'DistrictID' });

module.exports = CustomerDistrictMappingModel;