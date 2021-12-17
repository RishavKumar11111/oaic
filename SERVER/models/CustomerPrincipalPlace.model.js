const { Model, DataTypes } = require('sequelize');
const { sequelize } = require('../config/config');

const DLMasterModel = require('./CustomerMaster.model');
const StateMasterModel = require('./StateMaster.model');

class CustomerPrincipalPlaceModel extends Model {}

CustomerPrincipalPlaceModel.init({

    CustomerID: {
        type: DataTypes.STRING,
        allowNull: true
        // references: {
        //     model: DLMasterModel,
        //     key: 'CustomerID'
        // }
    },
    PrincipalPlaceID: {
        type: DataTypes.INTEGER,
        // autoIncrement: true,
        // primaryKey: true,
        allowNull: true
    },
    Country: {
        type: DataTypes.STRING,
        allowNull: true
    },
    StateCode: {
        type: DataTypes.INTEGER,
        allowNull: true,
        references: {
            model: StateMasterModel,
            key: 'StateCode'
        }
    },
    DistrictOrCity: {
        type: DataTypes.STRING,
        allowNull: true
    },
    Pincode: {
        type: DataTypes.INTEGER,
        allowNull: true
    },
    Address: {
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
    modelName: 'CustomerPrincipalPlaceModel',
    tableName: 'CustomerPrincipalPlace',
    timestamps: false
});

// CustomerPrincipalPlaceModel.belongsTo(DLMasterModel, { foreignKey: 'CustomerID' });
CustomerPrincipalPlaceModel.belongsTo(StateMasterModel, { foreignKey: 'StateCode' });

module.exports = CustomerPrincipalPlaceModel;