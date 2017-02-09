function plotval = plotData(accuracy_vector, accuracy_vector_test)
hold on;
figure();
x = (1:51);
plot(x,accuracy_vector', x,accuracy_vector_test');