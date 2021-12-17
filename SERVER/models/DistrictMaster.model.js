const { Model, DataTypes } = require('sequelize');
const { sequelize } = require('../config/config');

class DistrictMasterModel extends Model {}

DistrictMasterModel.init({
    dist_id: {
        type: DataTypes.STRING,
        primaryKey: true,
        allowNull: false
    },
    dist_name: {
        type: DataTypes.STRING,
        allowNull: false
    },
    DistCode: {
        type: DataTypes.STRING,
        allowNull: false
    }
}, {
    sequelize,
    modelName: 'DistrictMasterModel',
    tableName: '"DistrictMaster"',
    timestamps: false
});


module.exports = DistrictMasterModel;