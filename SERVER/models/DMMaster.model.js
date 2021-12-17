const { Model, DataTypes } = require('sequelize');
const { sequelize } = require('../config/config');

const DistrictMasterModel = require('./DistrictMaster.model');
const UserModel = require('./User.model');

class DMMasterModel extends Model {}

DMMasterModel.init({
    dm_id: {
        type: DataTypes.STRING,
        primaryKey: true,
        allowNull: false
    },
    dm_name: {
        type: DataTypes.STRING,
        allowNull: true
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
    EmailID: {
        type: DataTypes.STRING,
        allowNull: true
    },
    dm_address: {
        type: DataTypes.STRING,
        allowNull: true
    },
    dm_mobile_no: {
        type: DataTypes.STRING,
        allowNull: true
    },
    UpdateOn: {
        type: DataTypes.DATE,
        allowNull: true
    },
    UpdateBy: {
        type: DataTypes.STRING,
        allowNull: true,
        references: {
            model: UserModel,
            key: 'user_id'
        }
    },
    BankName: {
        type: DataTypes.STRING,
        allowNull: true
    },
    BranchName: {
        type: DataTypes.STRING,
        allowNull: true
    },
    AccountNumber: {
        type: DataTypes.STRING,
        allowNull: true
    },
    IFSCCode: {
        type: DataTypes.STRING,
        allowNull: true
    },
}, {
    sequelize,
    modelName: 'DMMasterModel',
    tableName: '"DMMaster"',
    timestamps: false
});


module.exports = DMMasterModel;