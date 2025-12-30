import unittest
from py_hello_world import hello_world

class MyTestCase(unittest.TestCase):
    def test_hello_world(self):
        self.assertEqual(hello_world.hello_world(), "Hello World!")

if __name__ == '__main__':
    unittest.main()
