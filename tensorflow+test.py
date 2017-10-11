
# coding: utf-8

# In[34]:

import tensorflow as tf
import numpy as np
import pandas as pd 
import matplotlib.pyplot as plt 
from tensorflow.python.framework import ops

get_ipython().magic('matplotlib inline')


# In[22]:

from tensorflow.examples.tutorials.mnist import input_data
mnist = input_data.read_data_sets("MNIST_data/", one_hot=True)


# In[99]:

X_train = mnist.train.images
y_train = mnist.train.labels
X_val = mnist.validation.images
y_val = mnist.validation.labels
X_test = mnist.test.images
y_test = mnist.test.labels

X_train.shape
y_train.shape


# In[102]:

X_train = X_train_orig.reshape(X_train_orig.shape[0],-1).T
y_train = y_train_orig.reshape(y_train_orig.shape[0],-1).T
X_val = X_val_orig.reshape(X_val_orig.shape[0],-1).T
y_val = y_val_orig.reshape(y_val_orig.shape[0],-1).T


# In[103]:

print(X_train.shape)
print(y_train.shape)
print(X_val.shape)
print(X_test.shape)
print('Number a training example: ' + str(X_train.shape[1]))


# In[104]:

def placeholder_creation(n_x,n_y):
    X = tf.placeholder(tf.float32, shape = [n_x,None], name = 'X')
    Y = tf.placeholder(tf.float32, shape = [n_y,None], name = 'Y')
    return X,Y

def initialize_parameters():
    W1 = tf.get_variable('W1',[128,55000], initializer = tf.contrib.layers.xavier_initializer(seed = 3))
    b1 = tf.get_variable('b1',[128,1], initializer = tf.zeros_initializer())
    W2 = tf.get_variable('W2',[40,128], initializer = tf.contrib.layers.xavier_initializer(seed = 3))
    b2 = tf.get_variable('b2', [40,1], initializer = tf.zeros_initializer())
    W3 = tf.get_variable('W3',[10,40], initializer = tf.contrib.layers.xavier_initializer(seed = 3))
    b3 = tf.get_variable('b3',[10,1], initializer = tf.zeros_initializer())
    parameters = {
        'W1':W1,
        'b1':b1,
        'W2':W2,
        'b2':b2,
        'W3':W3,
        'b3':b3
    }
    return parameters

def forward_prop(X,parameters):
    W1 = parameters['W1']
    b1 = parameters['b1']
    W2 = parameters['W2']
    b2 = parameters['b2']
    W3 = parameters['W3']
    b3 = parameters['b3']
    
    Z1 = tf.add(tf.matmul(W1,X),b1)
    A1 = tf.nn.relu(Z1)
    Z2 = tf.add(tf.matmul(W2,A1),b2)
    A2 = tf.nn.relu(Z2)
    Z3 = tf.add(tf.matmul(W3,A2),b3)
    return Z3 

def compute_cost(Z3,Y):
    logits = tf.transpose(Z3)
    labels = tf.transpose(Y)
    cost = tf.reduce_mean(tf.nn.softmax_cross_entropy_with_logits(logits = logits, labels = labels))
    return cost 



# In[105]:

tf.reset_default_graph()
with tf.Session() as sess:
    parameters = initialize_parameters()
    print("W1 = " + str(parameters["W1"]))
    print("b1 = " + str(parameters["b1"]))
    print("W2 = " + str(parameters["W2"]))
    print("b2 = " + str(parameters["b2"]))


# In[106]:

def random_mini_batches(X, Y, mini_batch_size = 32, seed = 0):
    """
    Creates a list of random minibatches from (X, Y)
    
    Arguments:
    X -- input data, of shape (input size, number of examples)
    Y -- true "label" vector (1 for blue dot / 0 for red dot), of shape (1, number of examples)
    mini_batch_size -- size of the mini-batches, integer
    
    Returns:
    mini_batches -- list of synchronous (mini_batch_X, mini_batch_Y)
    """
    
    np.random.seed(seed)            # To make your "random" minibatches the same as ours
    m = X.shape[1]                  # number of training examples
    mini_batches = []
        
    # Step 1: Shuffle (X, Y)
    permutation = list(np.random.permutation(m))
    shuffled_X = X[:, permutation]
    shuffled_Y = Y[:, permutation].reshape((Y.shape[0],m))
    
    # Step 2: Partition (shuffled_X, shuffled_Y). Minus the end case.
    num_complete_minibatches = math.floor(m/mini_batch_size) # number of mini batches of size mini_batch_size in your partitionning
    
    
    for k in range(0, num_complete_minibatches):
        ### START CODE HERE ### (approx. 2 lines)
        mini_batch_X = shuffled_X[:, k * mini_batch_size : (k + 1) * mini_batch_size]
        mini_batch_Y = shuffled_Y[:, k * mini_batch_size : (k + 1) * mini_batch_size]
        ### END CODE HERE ###
        mini_batch = (mini_batch_X, mini_batch_Y)
        mini_batches.append(mini_batch)
    
    # Handling the end case (last mini-batch < mini_batch_size)     
    if m % mini_batch_size != 0:
        ### START CODE HERE ### (approx. 2 lines)
        mini_batch_X = shuffled_X[:, mini_batch_size * num_complete_minibatches : m]
        mini_batch_Y = shuffled_Y[:, mini_batch_size * num_complete_minibatches : m]
        ### END CODE HERE ###
        mini_batch = (mini_batch_X, mini_batch_Y)
        mini_batches.append(mini_batch)
    
    return mini_batches



# In[107]:

def model(X_train, y_train, X_val, y_val, learning_rate = 0.001, num_epochs = 1500, minibatch_size = 32 , print_cost = True):
    ops.reset_default_graph()
    tf.set_random_seed(3)
    seed = 3
    (n_x,m) = X_train.shape
    n_y = y_train.shape[0]
    costs = []
    
    X,Y = placeholder_creation(n_x,n_y)
    
    parameters = initialize_parameters()
    
    Z3 = forward_prop(X,parameters)
    
    cost = compute_cost(Z3, Y)
    
    optimizer = tf.train.GradientDescentOptimizer(learning_rate = learning_rate).minimize(cost)
    init = tf.global_variables_initializer()
    
    with tf.Session() as sess:
        sess.run(init)
        for epoch in range(num_epochs):
            epoch_cost = 0.
            num_minibatches = int(m/minibatch_size)
            seed = seed + 1 
            minibatches = random_mini_batches(X_train,y_train,minibatch_size, seed)
            for minibatch in minibatches:
                (minibatch_X,minibatch_Y) = minibatch
                _ , minibatch_cost = sess.run([optimizer,cost], feed_dict = {X: minibatch_X, Y: minibatch_Y})
                epoch_cost += minibatch_cost/num_minibatches
            if print_cost == True and epoch % 100 == 0 :
                print('Cost after epoch %i: %f' %(epoch, epoch_cost))
            if print_cost ==True and epoch%5 == 0:
                costs.append(epoch_cost)
        plt.plot(np.squeeze(costs))
        plt.ylabel('cost')
        plt.xlabel('iteration (per tens)')
        plt.title('Learning rate = ' + str(learning_rate))
        plt.show()
        
        parameters = sess.run(parameters)
        print('Paramateres have been trained')
        
        correct_prediction = tf.equal(tf.argmax(Z3),tf.argmax(Y))
        accuracy = tf.reduce_mean(tf.cast(correct_prediction, 'float'))
        
        print('train', accuracy.eval({X:X_train, Y:y_train}))
        print('eval',accuravy.eval({X:X_val, Y:y_val}))
        
    return parameters


# In[108]:

parameters = model(X_train, y_train, X_val, y_val)


# In[ ]:



