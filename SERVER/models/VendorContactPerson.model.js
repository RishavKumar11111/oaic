const { Model, DataTypes } = require('sequelize');
const { sequelize } = require('../config/config');

const DLMasterModel = require('./VendorMaster.model');

class VendorContactPersonModel extends Model {}

VendorContactPersonModel.init({
    VendorID: {
        type: DataTypes.STRING,
        allowNull: false,
        references: {
            model: DLMasterModel,
            key: 'VendorID'
        }
    },
    ContactPersonID: {
        type: DataTypes.INTEGER,
        autoIncrement: true,
        primaryKey: true,
        allowNull: false
    },
    Name: {
        type: DataTypes.STRING,
        allowNull: false
    },
    FathersName: {
        type: DataTypes.STRING,
        allowNull: false
    },
    MobileNumber: {
        type: DataTypes.BIGINT,
        allowNull: false
    },
    EmailID: {
        type: DataTypes.STRING,
        allowNull: false
    },
    Designation: {
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
    modelName: 'VendorContactPersonModel',
    tableName: 'VendorContactPerson',
    timestamps: false
});

VendorContactPersonModel.belongsTo(DLMasterModel, { foreignKey: 'VendorID' });

module.exports = VendorContactPersonModel;