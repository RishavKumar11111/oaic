const { Model, DataTypes } = require('sequelize');
const { sequelize } = require('../config/config');

class VendorMasterModel extends Model {}

VendorMasterModel.init({
    VendorID: {
        type: DataTypes.STRING,
        primaryKey: true,
        allowNull: true
    },
    LegalBussinessName: {
        type: DataTypes.STRING,
        allowNull: true
    }, 
    TradeName: {
        type: DataTypes.STRING,
        allowNull: true
    }, 
    PAN: {
        type: DataTypes.STRING,
        allowNull: true
    }, PANDocument: {
        type: DataTypes.STRING,
        allowNull: true
    }, BussinessConstitution: {
        type: DataTypes.STRING,
        allowNull: true
    }, GSTN: {
        type: DataTypes.STRING,
        allowNull: true
    }, GSTNDocument: {
        type: DataTypes.STRING,
        allowNull: true
    }, IncorporationDate: {
        type: DataTypes.DATE,
        allowNull: true
    },
    ContactNumber: {
        type: DataTypes.STRING,
        allowNull: true
    }, 
    EmailID: {
        type: DataTypes.STRING,
        allowNull: true
    },
    Password: {
        type: DataTypes.STRING,
        allowNull: true
    },
    ApprovalStatus: {
        type: DataTypes.STRING,
        defaultValue: "Pending",
        allowNull: true
    },
    ApplyStatus: {
        type: DataTypes.STRING,
        defaultValue: 'Pending',
        allowNull: false
    },
    InsertedDate: {
        type: DataTypes.DATE,
        defaultValue: DataTypes.NOW,
        allowNull: true
    }, 
    InsertedBy: {
        type: DataTypes.STRING,
        allowNull: true
    }, 
    IsDeleted: {
        type: DataTypes.BOOLEAN,
        defaultValue: false,
        allowNull: true
    }, 
    ApproveOrRejectDate: {
        type: DataTypes.DATE,
        allowNull: true
    },
    ApproveOrRejectBy: {
        type: DataTypes.STRING,
        allowNull: true
    },
    WhetherSSIUnit: {
        type: DataTypes.STRING,
        allowNull: true
    },
    WhetherMSME: {
        type: DataTypes.STRING,
        allowNull: true
    },
    SSIUnitRegistrationCertificate: {
        type: DataTypes.STRING,
        allowNull: true
    },
    MSMECertificate: {
        type: DataTypes.STRING,
        allowNull: true
    },
    CoreBussinessActivity: {
        type: DataTypes.STRING,
        allowNull: true
    },
    Turnover1: {
        type: DataTypes.STRING,
        allowNull: true
    },
    Turnover2: {
        type: DataTypes.STRING,
        allowNull: true
    },
    Turnover3: {
        type: DataTypes.STRING,
        allowNull: true
    }
}, {
    sequelize,
    modelName: 'VendorMasterModel',
    tableName: 'VendorMaster',
    timestamps: false
});


module.exports = VendorMasterModel;