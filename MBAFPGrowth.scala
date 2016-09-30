%spark
import org.apache.spark.mllib.fpm.FPGrowth
import org.apache.spark.rdd.RDD
import sys.process._

val data = sc.textFile("/user/admin/retail/marketbaskets")

val transactions: RDD[Array[String]] = data.map(s => s.trim.split(','))

val fpg = new FPGrowth()
  .setMinSupport(0.007)
  .setNumPartitions(10)
val model = fpg.run(transactions)

model.freqItemsets.collect().foreach { itemset =>
  println(itemset.items.mkString("[", ",", "]") + ", " + itemset.freq)
}

val minConfidence = 0.8
model.generateAssociationRules(minConfidence).collect().foreach { rule =>
  println(
    rule.antecedent.mkString("[", ",", "]")
      + " => " + rule.consequent .mkString("[", ",", "]")
      + ", " + rule.confidence)
}
