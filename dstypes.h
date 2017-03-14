#ifndef DSTYPES_H
#define DSTYPES_H

#include <QString>

#define CMD_GET_MEASUREMENTS "get_measurements"
#define CMD_GET_ALL_INGREDIENTS "get_all_ingredients"
#define CMD_GET_INGREDIENT_OF_KEY "get_ingredient_of_key"
#define CMD_MODIFY_INGREDIENT "modify_ingredient"
#define CMD_ADD_INGREDIENT "add_ingredient"

#define TYPE_WEIGHT "weight"
#define TYPE_VOLUME "volume"

#define STATUS_OK "OK"
#define STATUS_ERROR "ERROR"

#include <QObject>

struct DSMeasurement {
    QString name;
    QString symbol;
    QString type;
    double multiply;
};

struct DSIngredient {
    QString name;
    QString description;
    double kg_per_cup;
    QStringList tags;
};

class Measurement : public QObject {
    Q_OBJECT
    Q_PROPERTY(QString name READ name WRITE setName NOTIFY nameChanged)
    Q_PROPERTY(QString symbol READ symbol WRITE setSymbol NOTIFY symbolChanged)
    Q_PROPERTY(QString type READ type WRITE setType NOTIFY typeChanged)
    Q_PROPERTY(double multiply READ multiply WRITE setMultiply NOTIFY multiplyChanged)

public:
    explicit Measurement(QObject *parent = 0) : QObject(parent) {}

    QString name() const {return m.name;}
    QString symbol() const {return m.symbol;}
    QString type() const {return m.type;}
    double multiply() const {return m.multiply;}

    void setName(const QString &v) {if (v == m.name) return; m.name = v; emit nameChanged();}
    void setSymbol(const QString &v) {if (v == m.symbol) return; m.symbol = v; emit symbolChanged();}
    void setType(const QString &v) {if (v == m.type) return; m.type = v; emit typeChanged();}
    void setMultiply(const double &v) {if (v == m.multiply) return; m.multiply = v; emit multiplyChanged();}

private:
    DSMeasurement m;

signals:
    void nameChanged();
    void symbolChanged();
    void typeChanged();
    void multiplyChanged();

public slots:
    void setM(DSMeasurement v) {m = v; emit nameChanged(); emit symbolChanged(); emit typeChanged(); emit multiplyChanged();}
    DSMeasurement getM() {return m;}
};

class Ingredient : public QObject {
    Q_OBJECT
    Q_PROPERTY(QString name READ name WRITE setName NOTIFY nameChanged)
    Q_PROPERTY(QString desc READ desc WRITE setDesc NOTIFY descChanged)
    Q_PROPERTY(double kgPCup READ kgPCup WRITE setKgPCup NOTIFY kgPCupChanged)
    Q_PROPERTY(QStringList tags READ tags WRITE setTags NOTIFY tagsChanged)

public:
    explicit Ingredient(QObject *parent = 0) : QObject(parent) {m.kg_per_cup = 0;}

    QString name() const {return m.name;}
    QString desc() const {return m.description;}
    double kgPCup() const {return m.kg_per_cup;}
    QStringList tags() const {return m.tags;}

    void setName(const QString &v) {if (v == m.name) return; m.name = v; emit nameChanged();}
    void setDesc(const QString &v) {if (v == m.description) return; m.description = v; emit descChanged();}
    void setKgPCup(const double &v) {if (v == m.kg_per_cup) return; m.kg_per_cup = v; emit kgPCupChanged();}
    void setTags(const QStringList &v) {if (v == m.tags) return; m.tags = v; emit tagsChanged();}

private:
    DSIngredient m;

signals:
    void nameChanged();
    void descChanged();
    void kgPCupChanged();
    void tagsChanged();

public slots:
    void setM(DSIngredient v) {m = v; emit nameChanged(); emit descChanged(); emit kgPCupChanged(); emit tagsChanged();}
    DSIngredient getM() {return m;}
};


#endif // DSTYPES_H
