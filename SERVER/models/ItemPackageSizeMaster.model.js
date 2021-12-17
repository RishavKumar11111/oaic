const { Model, DataTypes } = require('sequelize');
const { sequelize } = require('../config/config');

class ItemPackageSizeMasterModel extends Model {}

ItemPackageSizeMasterModel.init({
    PackageSize: {
        type: DataTypes.STRING,
        allowNull: true
    }
}, {
    sequelize,
    modelName: 'ItemPackageSizeMasterModel',
    tableName: 'ItemPackageSizeMaster',
    timestamps: false
});


module.exports = ItemPackageSizeMasterModel;