const { Model, DataTypes } = require('sequelize');
const { sequelize } = require('../config/config');

const DistrictMasterModel = require('./DistrictMaster.model');
const UserModel = require('./User.model');

class AccountantMasterModel extends Model {}

AccountantMasterModel.init({
    acc_name: {
        type: DataTypes.STRING,
        allowNull: false
    },
    acc_id: {
        type: DataTypes.STRING,
        primaryKey: true,
        allowNull: false
    },
    dist_id: {
        type: DataTypes.STRING,
        allowNull: false,
        references: {
            model: DistrictMasterModel,
            key: 'dist_id'
        }
    },
    dist_name: {
        type: DataTypes.STRING,
        allowNull: false
    },
    acc_address: {
        type: DataTypes.STRING,
        allowNull: false
    },
    acc_mobile_no: {
        type: DataTypes.STRING,
        allowNull: false
    },
    UpdateOn: {
        type: DataTypes.DATE,
        defaultValue: DataTypes.NOW,
        allowNull: false
    },
    UpdateBy: {
        type: DataTypes.STRING,
        allowNull: true,
        references: {
            model: UserModel,
            key: 'user_id'
        }
    }
}, {
    sequelize,
    modelName: 'AccountantMasterModel',
    tableName: '"AccountantMaster"',
    timestamps: false
});


module.exports = AccountantMasterModel;