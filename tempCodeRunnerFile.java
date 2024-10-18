class Ovrd
{
    int sum(int a,int b)
    {
        int c=a+b;
        return c;
    }
    int sum(int a,int b,int c)
    {
        int d=a+b+c;
        return d;

    }
}
class Tovrd 
{
    public static void main(String[] args)
    {
        Ovrd ob= new Ovrd();
        System.out.println("SUM OF TWO NUMBERS"+ob.sum(10,20));
        System.out.println("SUM OF Three NUMBERS"+ob.sum(10,20,30));
    }
}