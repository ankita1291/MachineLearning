function plotval = plotData(accuracy_vector)
hold on;
figure();
x = (2:57);
plot(x,accuracy_vector');
xlabel('m features');
ylabel('Accuracy');
hold off;